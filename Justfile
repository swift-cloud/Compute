format:
  swift format --in-place --recursive .

build:
  swift build -c debug --swift-sdk wasm32-unknown-wasi

demo: build
  fastly compute serve --skip-build --file ./.build/debug/ComputeDemo.wasm
