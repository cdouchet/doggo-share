use crate::{db::Pool, handlers::error::DoggoError, schema::files};
use actix_web::web::Data;
use chrono::{DateTime, Local};
use diesel::{Insertable, Queryable, RunQueryDsl};
use serde::Serialize;
use uuid::Uuid;

#[derive(Serialize, Queryable)]
pub struct DoggoFile {
    created_at: Option<DateTime<Local>>,
    updated_at: Option<DateTime<Local>>,
    pub id: Uuid,
    net_url: String,
    #[serde(skip_serializing)]
    pub local_url: String,
    name: String,
}

impl DoggoFile {
    pub fn get_all<'a>(pool: Data<Pool>) -> Result<Vec<Self>, DoggoError<'a>> {
        let conn = &mut pool.get().unwrap();
        let loaded_files = files::table.load::<Self>(conn);
        if let Err(err) = loaded_files {
            eprintln!("{err}");
            return Err(DoggoError::internal_server_error());
        }
        Ok(loaded_files.unwrap())
    }
}

#[derive(Insertable)]
#[diesel(table_name = files)]
pub struct NewDoggoFile {
    pub id: Uuid,
    pub net_url: String,
    pub local_url: String,
    pub name: String,
}
