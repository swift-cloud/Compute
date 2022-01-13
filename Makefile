build:
	swift build -c release --triple wasm32-unknown-wasi

pack: build
	fastly compute pack --wasm-binary ./.build/release/SwiftComputeApp.wasm

serve: build
	fastly compute serve --skip-build --file ./.build/release/SwiftComputeApp.wasm

deploy: pack
	fastly compute deploy
