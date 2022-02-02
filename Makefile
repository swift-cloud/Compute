docs: jazzy github-pages

github-pages:
	echo "compute-runtime.swift.cloud" > docs/CNAME

jazzy:
	jazzy \
		--clean \
		--author "Andrew Barba" \
		--author_url https://github.com/AndrewBarba \
		--source-host github \
		--source-host-url https://github.com/AndrewBarba/swift-compute-runtime \
		--module-version 1.0.0-alpha.0 \
		--module Compute \
		--root-url https://andrewbarba.github.io/swift-compute-runtime/
