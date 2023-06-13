use std::{fs::{self}, sync::{Arc, Mutex, mpsc::channel}};

use actix_web::{web, App, HttpServer};
use db::Pool;
use diesel::{r2d2::ConnectionManager, PgConnection, QueryDsl, ExpressionMethods, RunQueryDsl};
use dotenvy::dotenv;
use routes::files_routes::{upload_file, all_files};
use utils::{API_PORT, DATABASE_URL};
use chrono::Duration;
use uuid::Uuid;

use crate::{routes::files_routes::get_file, models::db::file::DoggoFile};

#[macro_use]
extern crate actix_web;

mod db;
mod handlers;
mod models;
mod routes;
mod schema;
mod utils;
mod services;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    let manager = ConnectionManager::<PgConnection>::new(DATABASE_URL.to_string());
    let pool: Pool = diesel::r2d2::Pool::builder()
        .build(manager)
        .expect("Failed to create DB pool");
    let cloned_pool = pool.clone();
    let server = HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .service(upload_file)
            .service(all_files)
            .service(get_file)
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
                    cloned_sender.send(()).expect("Fatal: Could not stop trash collector");
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

    println!("Launching Doggo Share Server on http://localhost:{}", *API_PORT);
    server.run().await.expect("Could not start HTTP Server");
    stop_sender.send(()).expect("Could not stop trash collector");
    Ok(())
}
