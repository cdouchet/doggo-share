use actix_easy_multipart::{MultipartForm, text::Text, tempfile::Tempfile};

#[derive(MultipartForm)]
pub struct UploadMultipart {
    pub name: Text<String>,
    pub file: Tempfile
}
