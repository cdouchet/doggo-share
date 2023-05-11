use serde::Serialize;

pub struct DoggoResponse<'a, T: Serialize> {
    pub description: &'a str,
    pub data: T
}

pub mod file;