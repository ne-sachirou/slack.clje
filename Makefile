.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: ## Format files
	(ag -g '\.clje$$' ; echo deps.edn) | xargs -t clojure -m cljfmt.main fix
	npx prettier --write README.md

.PHONY: test
test: ## Test
	(ag -g '\.clje$$' ; echo deps.edn) | xargs -t clojure -m cljfmt.main check
	rebar3 clojerl test
