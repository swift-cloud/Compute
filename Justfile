build-wasm-docker:
  docker run \
    --platform linux/arm64 \
    --rm \
    -v ./:/workspace \
    -w /workspace \
    ghcr.io/swiftwasm/swift:5.10-focal \
    bash -cl "swift build -c release --triple wasm32-unknown-wasi"

format:
  swift format --in-place --recursive .

build:
  swift build -c debug --triple wasm32-unknown-wasi

demo: build
  fastly compute serve --skip-build --file ./.build/debug/ComputeDemo.wasm
