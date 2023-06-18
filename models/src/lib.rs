use diesel::{PgConnection, r2d2::ConnectionManager};

pub mod doggo_file;
pub mod schema;
pub mod handlers;

#[macro_use]
extern crate diesel;

pub type Pool = diesel::r2d2::Pool<ConnectionManager<PgConnection>>;
