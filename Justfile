build:
  swift build -c release --triple wasm32-unknown-wasi
  wasm-opt -O2 -ffm -o ./.build/release/fastly.wasm ./.build/release/ComputeDemo.wasm

demo: build
  fastly compute serve --skip-build --file ./.build/release/fastly.wasm
