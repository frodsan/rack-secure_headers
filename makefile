default: test

install:
	@cat .gems | xargs gem install

test:
	@cutest -r ./test/helper.rb ./test/*.rb

.PHONY: test
