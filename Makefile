.PHONY: server shell qa qa_js qa_ruby coverage coverage_js coverage_rails test test_js test_rails


init:
	bin/setup


# DEVELOPMENT
# ~~~~~~~~~~~
# The following rules can be used during development in order to launch development server, get a
# console or other common tasks.
# --------------------------------------------------------------------------------------------------

c: console
console:
	bin/rails c

s: server
server:
	bin/rails s


# QUALITY ASSURANCE
# ~~~~~~~~~~~~~~~~~
# The following rules can be used to check code quality.
# --------------------------------------------------------------------------------------------------

# Code quality checks (lint, etc).
qa: qa_js qa_ruby
qa_js:
	yarn run lint
qa_ruby:
	bin/rubocop


# TESTING
# ~~~~~~~
# The following rules can be used to trigger tests execution and produce coverage reports.
# --------------------------------------------------------------------------------------------------

# Collects code coverage data.
coverage: coverage_js coverage_rails
coverage_js:
	npm test
coverage_rails:
	bin/rails test:coverage

# Just runs all the tests!
t: tests
tests: tests_js tests_rails
tests_js:
	yarn test
tests_rails:
	bin/rails test
