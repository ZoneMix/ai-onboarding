---
paths: ["**/*.rs", "**/Cargo.toml"]
---
# Rust

- **Four gates before every commit,** and CI runs the same ones with `RUSTFLAGS=-D warnings`:
  `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test`, and the
  project's own end-to-end check if it has one.
- **Errors:** `anyhow::Result` in binaries and app code, a typed error (`thiserror`) at
  library boundaries. No `.unwrap()` or `.expect()` on anything from user input, the
  terminal, the filesystem or the network. In tests, unwrap freely.
- **Visibility:** prefer `pub(crate)`. Nothing becomes `pub` just so a test can reach it; test
  through the public entry point instead.
- **No dead code kept alive** with `#[allow(dead_code)]`. Delete it.
- **Tests** live in `#[cfg(test)] mod tests` next to the code. A bug fix adds one regression
  test that fails before the fix.
- **Hot paths:** no cloning big structures to dodge the borrow checker, no recompiling
  regexes per call (`LazyLock<Regex>`), no re-reading files per frame or request.
- **Dependencies:** keep them few; audit with `cargo audit`.
