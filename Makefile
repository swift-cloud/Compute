build:
	swift build --triple wasm32-unknown-wasi

pack: build
	fastly compute pack --wasm-binary ./.build/debug/SwiftComputeApp.wasm

deploy: pack
	fastly compute deploy