use chrono::{DateTime, Local};
use diesel::{Insertable, Queryable};
use serde::Serialize;
use uuid::Uuid;
use crate::schema::files;

#[derive(Serialize, Queryable)]
pub struct DoggoFile {
    created_at: Option<DateTime<Local>>,
    updated_at: Option<DateTime<Local>>,
    id: Uuid,
    net_url: String,
    local_url: String,
    name: String
}

#[derive(Insertable)]
#[diesel(table_name = files)]
pub struct NewDoggoFile {
    pub id: Uuid,
    pub net_url: String,
    pub local_url: String,
    pub name: String
}