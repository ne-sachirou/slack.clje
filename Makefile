.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: ## Format files
	cljstyle fix
	npx prettier --write README.md
	npx prettier --write .github/workflows/*.yml

.PHONY: repl
repl: ## Start a REPL shell
	rlwrap -c -b "(){}[],^%$#@\"\";:''|\\" rebar3 clojerl repl

.PHONY: test
test: ## Test
	cljstyle check
	cljstyle find | xargs -t clj-kondo --lint || true
	rebar3 clojerl test

.PHONY: upgrade
upgrade: ## Upgrade deps
	rebar3 upgrade
