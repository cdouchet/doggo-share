use serde::Serialize;

#[derive(Serialize)]
pub struct DoggoResponse<'a, T: Serialize> {
    pub description: &'a str,
    pub data: T
}

pub mod file;