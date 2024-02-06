use crate::schema::support_posts;
use actix_web::web::Data;
use chrono::{DateTime, Local};
use diesel::{Queryable, RunQueryDsl};
use serde::{Deserialize, Serialize};

use crate::{handlers::error::DoggoError, Pool};

#[derive(Serialize, Queryable)]
#[diesel(table_name = support_posts)]
pub struct SupportForm {
    id: i32,
    created_at: DateTime<Local>,
    updated_at: DateTime<Local>,
    title: String,
    comment: String,
    email: String,
}

#[derive(Deserialize, Insertable)]
#[diesel(table_name = support_posts)]
pub struct NewSupportForm {
    title: String,
    comment: String,
    pub email: String,
}

impl NewSupportForm {
    pub fn insert<'a>(self, pool: Data<Pool>) -> Result<SupportForm, DoggoError<'a>> {
        let conn = &mut pool.get().unwrap();
        diesel::insert_into(support_posts::table)
            .values(self)
            .get_result::<SupportForm>(conn)
            .map_err(|e| DoggoError::from(e))
    }
}
