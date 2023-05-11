use actix_web::web::{Data, Json};
use diesel::RunQueryDsl;
use uuid::Uuid;

use crate::{
    db::Pool,
    handlers::error::DoggoError,
    models::{
        db::file::{DoggoFile, NewDoggoFile},
        form::UploadMultipart,
        response::DoggoResponse,
    },
    utils::{BASE_URL, CARGO_MANIFEST_DIR},
};

pub async fn upload_file<'a, 'b>(
    form: UploadMultipart,
    pool: Data<Pool>,
) -> Result<Json<DoggoResponse<'a, DoggoFile>>, DoggoError<'b>> {
    let id = Uuid::new_v4();
    let net_url = format!("{}/{}/{}", BASE_URL.to_string(), id, form.name.0);
    let local_url = format!("{}/files/{}", CARGO_MANIFEST_DIR.to_string(), id);
    let new_file = NewDoggoFile {
        id,
        name: form.name.0,
        net_url,
        local_url,
    };
    use crate::schema::files;
    let conn = &mut pool.get().unwrap();
    match diesel::insert_into(files::table)
        .values(new_file)
        .get_result::<DoggoFile>(conn)
    {
        Ok(file) => {
            return Ok(Json(DoggoResponse {
                data: file,
                description: "Returned file",
            }))
        }
        Err(err) => {
            eprintln!("{err}");
            return Err(DoggoError::internal_server_error());
        }
    }
}
