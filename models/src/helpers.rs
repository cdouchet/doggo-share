use crate::static_vars::EMAIL_REGEX;

pub fn is_email<'a>(input: &'a str) -> bool {
    EMAIL_REGEX.is_match(input)
}
