use derive_more::Display;
use reqwest_wasm::StatusCode;

#[derive(Display, Debug)]
#[display(fmt = r#"{{"name": {}, "status_code": {}}}"#, name, status_code)]
pub struct DoggoError<'a> {
    name: &'a str,
    status_code: StatusCode,
}

impl<'a> DoggoError<'a> {

    pub fn internal_server_error() -> Self {
        Self {
            name: "Internal Server Error",
            status_code: StatusCode::INTERNAL_SERVER_ERROR
        }
    }

    pub fn bad_request(msg: &'a str) -> Self {
        Self {
            name: msg,
            status_code: StatusCode::BAD_REQUEST
        }
    }

    pub fn not_implemented() -> Self {
        Self {
            name: "Not Implemented",
            status_code: StatusCode::INTERNAL_SERVER_ERROR
        }
    }

    pub fn invalid_id_format() -> Self {
        Self {
            name: "Invalid ID format",
            status_code: StatusCode::BAD_REQUEST
        }
    }

    pub fn not_found() -> Self {
        Self {
            name: "Not Found",
            status_code: StatusCode::NOT_FOUND
        }
    }
}