build:
    swift build -c debug --triple wasm32-unknown-wasi

demo: build
    fastly compute serve --skip-build --file ./.build/debug/ComputeDemo.wasm

fastly-world:
    curl -o ./Sources/FastlyWorld/include/fastly_world.h https://raw.githubusercontent.com/fastly/js-compute-runtime/main/runtime/js-compute-runtime/fastly-world/fastly_world.h
    curl -o ./Sources/FastlyWorld/fastly_world.c https://raw.githubusercontent.com/fastly/js-compute-runtime/main/runtime/js-compute-runtime/fastly-world/fastly_world.c
