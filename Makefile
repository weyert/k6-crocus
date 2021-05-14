K6 := v0.32.0
PLATFORMS := linux/amd64 windows/amd64 darwin/amd64
EXTENSIONS := xk6-prometheus@v0.1.2 xk6-crypto@v0.1.2 xk6-jose@v0.1.1 \
  xk6-yaml@v0.1.1 xk6-toml@v0.1.1 xk6-csv@v0.1.1 \
  xk6-ansible-vault@v0.1.1
VERSION ?= snapshot

.PHONY: build $(PLATFORMS)

temp = $(subst /, ,$@)
os = $(word 1, $(temp))
arch = $(word 2, $(temp))
suffix = $(if $(filter windows,$(os)),.exe)

name = k6-crocus
dir = $(name)-$(VERSION)-$(os)-$(arch)
bin = $(dir)/k6$(suffix)
tgz = $(dir).tar.gz
with := $(addprefix --with github.com/szkiba/, $(EXTENSIONS))

build: $(PLATFORMS)

$(PLATFORMS):
	@GOOS=$(os) GOARCH=$(arch) xk6 build --output dist/$(bin) $(with) $(K6)
	@cd dist; tar -czf $(tgz) $(dir)

clean:
	@rm -rf dist build
