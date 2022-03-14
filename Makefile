docs: docc github-pages

github-pages:
	echo "compute-runtime.swift.cloud" > docs/CNAME

docc:
	rm -rf ./docs
	swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--product Compute \
		--output-path ./docs \
		--emit-digest \
		--disable-indexing \
		--transform-for-static-hosting
