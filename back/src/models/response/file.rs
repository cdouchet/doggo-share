use serde::Serialize;

#[derive(Serialize)]
pub struct FileResponse<'a> {
    url: &'a str,
    
}