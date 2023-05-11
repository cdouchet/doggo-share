use diesel::{r2d2::ConnectionManager, PgConnection};

pub type Pool = diesel::r2d2::Pool<ConnectionManager<PgConnection>>;