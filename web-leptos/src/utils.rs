use std::{thread, time::Duration};

use leptos::{document, set_timeout};
use wasm_bindgen::{JsCast, JsValue};
use web_sys::HtmlElement;

pub fn show_copy_success() -> Result<(), JsValue> {
    let el = document().get_element_by_id("copy-pop-up").unwrap();
    let el = el.dyn_into::<HtmlElement>().unwrap();
    el.style().set_property("opacity", "1")?;
    set_timeout(move || {
        let _ = el.style().set_property("opacity", "0");
    }, Duration::from_secs(2));
    Ok(())
}
