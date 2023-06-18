use chrono::{DateTime, Local};
use serde::Deserialize;
use uuid::Uuid;

#[derive(Deserialize)]
pub struct DoggoFile {
    created_at: Option<DateTime<Local>>,
    updated_at: Option<DateTime<Local>>,
    pub id: Uuid,
    net_url: String,
    name: String,
}