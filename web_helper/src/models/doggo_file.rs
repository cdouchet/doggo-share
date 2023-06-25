use chrono::{DateTime, Local};
use serde::{Serialize, Deserialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize, Clone)]
pub struct DoggoFile {
    created_at: Option<DateTime<Local>>,
    updated_at: Option<DateTime<Local>>,
    pub id: Uuid,
    pub net_url: String,
    pub name: String,
}