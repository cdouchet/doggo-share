use serde::{Deserialize, Serialize};

use super::doggo_file::DoggoFile;

#[derive(Deserialize, Serialize, Clone)]
pub struct DoggoResponse<T> {
    pub description: String,
    pub data: T
}