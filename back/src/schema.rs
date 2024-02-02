// @generated automatically by Diesel CLI.

diesel::table! {
    files (id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        id -> Uuid,
        net_url -> Text,
        local_url -> Text,
        name -> Text,
    }
}
