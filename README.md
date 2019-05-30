# Rust MacOS Builder

Build MacOS binaries for your Rust apps with Docker. Useful for CI...

## Usage

```
docker run --rm -v ${PWD}:/build wearejh/rust-macos-build
```

Once complete you're binary will be available in `target/x86_64-apple-darwin/release`
