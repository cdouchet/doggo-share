<div style="text-align:center"><img src="https://bordel.doggo-saloon.net/logo-transparent.png" /></div>

# Doggo Share

Doggo Share is a file sharing platform, written entirely in rust with [actix-web](https://github.com/actix/actix-web) as server and [leptos](https://github.com/leptos-rs/leptos) in front.

Add a file, send it and share the generated link !

## Prerequisites

You will need to install rust and cargo. On Linux and MacOS systems :

```bash
curl https://sh.rustup.rs -sSf | sh
```

If you want to build the mobile app, you need to install flutter [here](https://docs.flutter.dev/get-started/install).

## Installation

First clone this repository:

```bash
git clone git@github.com:cdouchet/doggo-share.git
```

### API

To build and serve the actix-web server :

```bash
cd back
cargo run
```

You also can build a binary :

```bash
cargo build --release
cd targe/release
./back
```

### Front

You will have to set the rust version to nightly. For this :

```bash
rustup toolchain install nightly
rustup default nightly
rustup target add wasm32-unknown-unknown
```

Now, install the cargo-leptos build tool :
```bash
cargo install cargo-leptos
```

And serve the front as a server :
```bash
cd web-leptos
BASE_URL=http://localhost:444 cargo leptos watch
```

Where BASE_URL is the url of the API.

If you want to change the port of this server, you can modify the Cargo.toml file, and edit the site-addr variable.

### Mobile

First go into the mobile directory :
```bash
cd mobile
```

Then, to install the app :
```bash
flutter run --release
```

If your platform is iOS, you will need to open Xcode to change the signing team in signing & capabilities.
