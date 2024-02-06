use actix_web::web::{Data, Json};
use doggo_share_models::{
    handlers::error::DoggoError, helpers::is_email, support_form::NewSupportForm, Pool,
};

#[post("/support")]
pub async fn post_support_form<'a>(
    form: Json<NewSupportForm>,
    pool: Data<Pool>,
) -> Result<String, DoggoError<'a>> {
    if !is_email(&form.email) {
        return Err(DoggoError::bad_request("This email is invalid"));
    }
    form.0.insert(pool).map(|_| String::from("OK"))
}
