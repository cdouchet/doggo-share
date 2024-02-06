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

diesel::table! {
    support_posts (id) {
        id -> Int4,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
        title -> Text,
        comment -> Text,
        email -> Text,
    }
}

diesel::allow_tables_to_appear_in_same_query!(
    files,
    support_posts,
);
