
GO_BUILD 	= go build
GO_PLUGIN 	= go build -buildmode=plugin
INSTALL 	= /usr/bin/install
MKDIR 		= mkdir -p
RM 		= rm
CP 		= cp

# Optimization build processes
CPUS ?= $(shell nproc)
MAKEFLAGS += --jobs=$(CPUS)

SRCS = $(shell git ls-files '*.go' | grep -v '^vendor/')

# Targets
TARGET = jobflow

all: clean $(TARGET)

# Build targets multiple platforms
build: deps
	gox -osarch="linux/amd64" \
	-output="bin/{{.OS}}_{{.Arch}}/"$(TARGET) .

test-unit:
	go test -count 1 -v ./...

test-integration:
	go test -count 1 -v -tags=integration ./test/integration

fmt:
	gofmt -s -l -w $(SRCS)

deps:
	go get -u github.com/mitchellh/gox

clean:
	-$(RM) -rf bin

distclean:

install:

.PHONY: test-unit test-integration clean distclean install