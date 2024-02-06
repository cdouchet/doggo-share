use diesel::{PgConnection, r2d2::ConnectionManager};

pub mod doggo_file;
pub mod support_form;
pub mod schema;
pub mod handlers;
pub mod helpers;
pub mod static_vars;

#[macro_use]
extern crate diesel;

pub type Pool = diesel::r2d2::Pool<ConnectionManager<PgConnection>>;
