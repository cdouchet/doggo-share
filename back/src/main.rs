use actix_web::{web, App, HttpServer};
use db::Pool;
use diesel::{r2d2::ConnectionManager, PgConnection};
use dotenvy::dotenv;
use routes::files_routes::upload_file;
use utils::API_PORT;

mod db;
mod handlers;
mod models;
mod routes;
mod schema;
mod utils;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    let db_url = std::env::var("DATABASE_URL").expect("DATABASE_URL env var must be set");
    let manager = ConnectionManager::<PgConnection>::new(db_url);
    let pool: Pool = diesel::r2d2::Pool::builder()
        .build(manager)
        .expect("Failed to create DB pool");
    let server = HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .service(upload_file)
    })
    .bind((
        "0.0.0.0",
        API_PORT
            .to_string()
            .parse::<u16>()
            .expect("API_PORT env var must be an unsigned integer"),
    ))?;
    // let (stop_sender, stop_receiver) = channel::<()>();
    // std::thread::spawn(move || loop {

    // })
    server.run().await.expect("Could not start HTTP Server");
    Ok(())
}
