build:
  swift build -c debug --triple wasm32-unknown-wasi

demo: build
  fastly compute serve --skip-build --file ./.build/debug/ComputeDemo.wasm
