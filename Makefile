docs: clean docc github-pages

clean:
	rm -rf ./docs

docc:
	swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--product Compute \
		--disable-indexing \
		--transform-for-static-hosting \
		--output-path ./docs

github-pages:
	echo "compute-runtime.swift.cloud" > docs/CNAME

demo:
	swift build -c debug --triple wasm32-unknown-wasi
	fastly compute serve --skip-build --file ./.build/debug/*.wasm
