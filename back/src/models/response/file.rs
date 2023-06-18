use diesel::Insertable;
use serde::Serialize;
use uuid::Uuid;
use crate::schema::files;

#[derive(Serialize)]
pub struct FileResponse<'a> {
    url: &'a str,
    
}

#[derive(Insertable)]
#[diesel(table_name = files)]
pub struct NewDoggoFile {
    pub id: Uuid,
    pub net_url: String,
    pub local_url: String,
    pub name: String,
}
