.PHONY: deps aws-deps azure-deps testazure test vendor

ifndef TESTRUN
TESTRUN=".*"
endif

ifndef GOPATH
$(error $$GOPATH is not set)
endif

all:
	@echo "did you mean 'make test' ?"

deps: aws-deps azure-deps jq-dep

aws-deps:
	pip install --user awscli

azure-deps: jq-dep
	npm install -g azure-cli

jq-dep: $(GOPATH)/bin/jq

$(GOPATH)/bin/jq:
	@echo "Downloading jq..."
	mkdir -p $(GOPATH)/bin
	wget "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64" -O $(GOPATH)/bin/jq
	chmod "+x" $(GOPATH)/bin/jq

vendor:
	./hack/vendor.sh


guard-%:
	@ if [ "${${*}}" = "" ]; then \
                echo "Env var '$*' not set"; \
                exit 1; \
        fi

installdir=$(NASHPATH)/lib/klb
install: guard-NASHPATH
	rm -rf $(installdir)
	mkdir -p $(installdir)
	cp -pr ./aws $(installdir)
	cp -pr ./azure $(installdir)

timeout=20m
logger=file
parallel=30 #Explore I/O parallelization
gotest=cd tests/azure && go test -parallel $(parallel) -timeout $(timeout) -race
gotestargs=-args -logger $(logger)

testall:
	$(gotest) ./... $(gotestargs)

test:
	$(gotest) -run=$(run) ./... $(gotestargs)
