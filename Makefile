build:
	swift build -c release --triple wasm32-unknown-wasi

pack: build
	fastly compute pack --wasm-binary ./.build/debug/SwiftComputeApp.wasm

serve: build
	fastly compute serve --skip-build --file ./.build/debug/SwiftComputeApp.wasm

deploy: pack
	fastly compute deploy