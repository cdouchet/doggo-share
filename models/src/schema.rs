// @generated automatically by Diesel CLI.

diesel::table! {
    auth_systems (auth_system_id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        auth_system_id -> Int4,
        #[max_length = 255]
        auth_system_desc -> Varchar,
    }
}

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
    locations (location_id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        location_id -> Int4,
        ip_address -> Cidr,
        #[max_length = 100]
        gps -> Nullable<Varchar>,
        #[max_length = 10]
        zip_code -> Varchar,
        #[max_length = 100]
        region -> Nullable<Varchar>,
        #[max_length = 60]
        country -> Nullable<Varchar>,
    }
}

diesel::table! {
    roles (role_id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        role_id -> Int4,
        #[max_length = 255]
        role -> Varchar,
        level -> Int4,
        description -> Text,
    }
}

diesel::table! {
    setting_preferences (setting_id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        setting_id -> Int4,
        setting_desc -> Text,
        #[max_length = 20]
        values_type -> Varchar,
    }
}

diesel::table! {
    user_auth_systems (id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        id -> Int4,
        individual_id -> Uuid,
        auth_system_id -> Int4,
    }
}

diesel::table! {
    user_deletions (deletion_id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        deletion_id -> Int4,
        deleted_user_id -> Uuid,
        deleter_user_id -> Uuid,
        is_reactivated -> Bool,
    }
}

diesel::table! {
    user_locations (id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        id -> Int4,
        individual_id -> Uuid,
        location_id -> Int4,
    }
}

diesel::table! {
    user_roles (id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        id -> Int4,
        individual_id -> Uuid,
        role_id -> Int4,
    }
}

diesel::table! {
    user_setting_preferences (id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        id -> Int4,
        individual_id -> Uuid,
        setting_id -> Int4,
        value_setting -> Text,
    }
}

diesel::table! {
    users (user_id) {
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
        user_id -> Uuid,
        #[max_length = 255]
        username -> Varchar,
        #[max_length = 255]
        email -> Varchar,
        #[max_length = 255]
        password -> Nullable<Varchar>,
        #[max_length = 255]
        phone_number -> Nullable<Varchar>,
        #[max_length = 255]
        first_name -> Nullable<Varchar>,
        #[max_length = 255]
        last_name -> Nullable<Varchar>,
        description -> Nullable<Text>,
        birth_date -> Nullable<Date>,
        code_title -> Nullable<Int4>,
        #[max_length = 255]
        user_picture_uri -> Nullable<Varchar>,
        is_active -> Bool,
        roles -> Array<Nullable<Int4>>,
        auth_systems -> Array<Nullable<Int4>>,
        setting_preferences -> Array<Nullable<Int4>>,
        ip_locations -> Nullable<Array<Nullable<Int4>>>,
    }
}

diesel::joinable!(user_auth_systems -> auth_systems (auth_system_id));
diesel::joinable!(user_auth_systems -> users (individual_id));
diesel::joinable!(user_locations -> locations (location_id));
diesel::joinable!(user_locations -> users (individual_id));
diesel::joinable!(user_roles -> roles (role_id));
diesel::joinable!(user_roles -> users (individual_id));
diesel::joinable!(user_setting_preferences -> setting_preferences (setting_id));
diesel::joinable!(user_setting_preferences -> users (individual_id));

diesel::allow_tables_to_appear_in_same_query!(
    auth_systems,
    files,
    locations,
    roles,
    setting_preferences,
    user_auth_systems,
    user_deletions,
    user_locations,
    user_roles,
    user_setting_preferences,
    users,
);
