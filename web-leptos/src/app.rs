use dotenvy::dotenv;
use leptos::*;
use leptos_meta::*;
use leptos_router::*;

use crate::views::{home::Home, privacy::Privacy};

#[component]
pub fn App(cx: Scope) -> impl IntoView {
    // Provides context that manages stylesheets, titles, meta tags, etc.
    provide_meta_context(cx);
    dotenv().ok();

    view! {
        cx,

        // injects a stylesheet into the document <head>
        // id=leptos means cargo-leptos will hot-reload this stylesheet
        <Stylesheet id="leptos" href="/pkg/leptos_start.css"/>

        // sets the document title
        <Title text="Share"/>

        // content for this welcome page
        <Router>
            <main>
                <Routes>
                    <Route path="/" view=|cx| view! { cx, <Home/> }/>
                    <Route path="/privacy" view=|cx| view! { cx, <Privacy /> } />
                </Routes>
            </main>
        </Router>
    }
}

// /// Renders the home page of your application.
// #[component]
// fn HomePage(cx: Scope) -> impl IntoView {
//     // Creates a reactive value to update the button
//     let (count, set_count) = create_signal(cx, 0);
//     let on_click = move |_| set_count.update(|count| *count += 1);

//     view! { cx,
//         <h1>"Welcome to Leptos!"</h1>
//         <button on:click=on_click>"Click Me: " {count}</button>
//     }
// }
