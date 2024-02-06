use std::{
    fs::{self},
    sync::{mpsc::channel, Arc, Mutex},
};

use actix_cors::Cors;
use actix_multipart::form::MultipartFormConfig;
use actix_web::{
    dev::AppConfig,
    web::{self, PayloadConfig},
    App, HttpServer,
};
use chrono::Duration;
use db::Pool;
use diesel::{r2d2::ConnectionManager, ExpressionMethods, PgConnection, QueryDsl, RunQueryDsl};
use dotenvy::dotenv;
use routes::files_routes::{all_files, upload_file};
use utils::{API_PORT, DATABASE_URL};
use uuid::Uuid;

use crate::{
    routes::{
        files_routes::{
            get_apple_app_site_association, get_asset, get_asset_links_json, get_file,
            get_file_info,
        },
        static_assets::get_art, support_routes::post_support_form,
    },
    utils::{CARGO_MANIFEST_DIR, DOGGO_SHARE_CORS_ALLOWED_ORIGIN},
};
use doggo_share_models::doggo_file::DoggoFile;

#[macro_use]
extern crate actix_web;

mod db;
// mod handlers;
mod middlewares;
mod models;
mod routes;
mod schema;
mod services;
mod utils;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    let manager = ConnectionManager::<PgConnection>::new(DATABASE_URL.to_string());
    let pool: Pool = diesel::r2d2::Pool::builder()
        .build(manager)
        .expect("Failed to create DB pool");
    let cloned_pool = pool.clone();
    if let Err(err) = std::fs::create_dir(format!("{}/files", *CARGO_MANIFEST_DIR)) {
        eprintln!("Creating Files Directory: {}", err);
    }
    let server = HttpServer::new(move || {
        let config = MultipartFormConfig::default()
            .total_limit(100 * 1024 * 1024 * 1024)
            .memory_limit(100 * 1024 * 1024 * 1024);
        let cors = Cors::default()
            .allowed_origin(&DOGGO_SHARE_CORS_ALLOWED_ORIGIN)
            .allowed_methods(vec!["GET", "POST", "OPTIONS"]);
        App::new()
            .wrap(cors)
            .app_data(web::Data::new(config))
            .app_data(web::PayloadConfig::new(1024 * 1024 * 1024).limit(1024 * 1024 * 1024))
            .app_data(web::Data::new(pool.clone()))
            // .service(actix_files::Files::new(
            //     "/",
            //     "/home/cyril/Documents/github/doggo-share-2/",
            // ))
            .service(upload_file)
            .service(get_file)
            //.service(all_files)
            .service(get_apple_app_site_association)
            .service(get_file_info)
            .service(get_art)
            .service(get_asset)
            .service(post_support_form)
            .route(
                "/.well-known/assetlinks.json",
                web::get().to(get_asset_links_json),
            )
    })
    .bind((
        "0.0.0.0",
        API_PORT
            .to_string()
            .parse::<u16>()
            .expect("API_PORT env var must be an unsigned integer"),
    ))?;

    let (stop_sender, stop_receiver) = channel::<()>();
    let cloned_sender = stop_sender.clone();
    std::thread::spawn(move || {
        use crate::schema::files;
        let conn = &mut cloned_pool.get().unwrap();
        loop {
            let fda = chrono::offset::Local::now() - Duration::days(5);
            match files::table
                .filter(files::created_at.le(fda))
                .load::<DoggoFile>(conn)
            {
                Err(err) => {
                    eprintln!("Error filtering trashes : {err}");
                    cloned_sender
                        .send(())
                        .expect("Fatal: Could not stop trash collector");
                }
                Ok(trashes) => {
                    for t in &trashes {
                        let _ = fs::remove_file(t.local_url.clone());
                    }
                    let trashes_ids = (trashes as Vec<DoggoFile>)
                        .iter()
                        .map(|e| e.id)
                        .collect::<Vec<Uuid>>();
                    println!("Ids to delete: {:?}", trashes_ids);
                    diesel::delete(files::table)
                        .filter(files::id.eq_any(trashes_ids))
                        .execute(conn)
                        .expect("Fatal: Could not delete trashes");
                }
            }
            if stop_receiver.try_recv().is_ok() {
                break;
            }
            std::thread::sleep(std::time::Duration::from_secs(300));
        }
    });
    // let mut tc = TrashCollector::new(web::Data::new(cloned_pool));
    // let _ = tc.lock().unwrap().start_watching_trashes().expect("msg");
    // let (stop_sender, stop_receiver) = channel::<()>();
    // std::thread::spawn(move || loop {

    // })

    println!(
        "Launching Doggo Share Server on http://localhost:{}",
        *API_PORT
    );
    let server_start_res = server.run().await;
    if let Err(err) = server_start_res {
        eprintln!("Error starting HTTP server : {err}");
        panic!("Error starting server");
    }
    stop_sender
        .send(())
        .expect("Could not stop trash collector");
    Ok(())
}
