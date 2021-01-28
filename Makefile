.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: ## Format files
	clojure -M:dev -m cljstyle.main fix
	npx prettier --write README.md

.PHONY: repl
repl: ## Start a REPL shell
	rlwrap -c -b "(){}[],^%$#@\"\";:''|\\" rebar3 clojerl repl

.PHONY: test
test: ## Test
	clojure -M:dev -m cljstyle.main check
	rebar3 clojerl test

.PHONY: upgrade
upgrade: ## Upgrade deps
	rebar3 upgrade
