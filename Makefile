docs: clean docc github-pages

clean:
	rm -rf ./docs

docc:
	rm .swift-version
	swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--product Compute \
		--disable-indexing \
		--transform-for-static-hosting \
		--output-path ./docs
	swiftenv local wasm-5.7.1

github-pages:
	echo "compute-runtime.swift.cloud" > docs/CNAME

demo:
	swift build -c debug --triple wasm32-unknown-wasi
	fastly compute serve --skip-build --file ./.build/debug/*.wasm
