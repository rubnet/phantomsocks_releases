NAME=phantomsocks
BINDIR=bin
VERSION=$(shell date +%s)
GOBUILD=go build -trimpath --ldflags="-s -w" -v -x
GOFILES=main.go

PLATFORM_LIST = \
	darwin-amd64 \
	darwin-arm64 \
	linux-amd64 \
	linux-armv5 \
	linux-armv7 \
	linux-armv8 \
	linux-mips-softfloat \
	linux-mips-hardfloat

WINDOWS_ARCH_LIST = \
	windows-amd64

all: linux-amd64 darwin-amd64 windows-amd64 # Most used

darwin-amd64:
	GOARCH=amd64 GOOS=darwin CGO_ENABLED=1 $(GOBUILD) -tags pcap -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

darwin-arm64:
	GOARCH=arm64 GOOS=darwin CGO_ENABLED=1 $(GOBUILD) -tags pcap -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-386:
	GOARCH=386 GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-amd64:
	GOARCH=amd64 GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-armv5:
	GOARCH=arm GOOS=linux GOARM=5 CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-armv6:
	GOARCH=arm GOOS=linux GOARM=6 CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-armv7:
	GOARCH=arm GOOS=linux GOARM=7 CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-armv8:
	GOARCH=arm64 GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-mips-softfloat:
	GOARCH=mips GOMIPS=softfloat GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-mips-hardfloat:
	GOARCH=mips GOMIPS=hardfloat GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-mipsle-softfloat:
	GOARCH=mipsle GOMIPS=softfloat GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-mipsle-hardfloat:
	GOARCH=mipsle GOMIPS=hardfloat GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-mips64:
	GOARCH=mips64 GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-mips64le:
	GOARCH=mips64le GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

linux-s390x:
	GOARCH=s390x GOOS=linux CGO_ENABLED=0 $(GOBUILD) -tags rawsocket -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

freebsd-386:
	GOARCH=386 GOOS=freebsd CGO_ENABLED=0 $(GOBUILD) -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

freebsd-amd64:
	GOARCH=amd64 GOOS=freebsd CGO_ENABLED=0 $(GOBUILD) -o $(BINDIR)/$(NAME)-$@ $(GOFILES)

windows-386:
	GOARCH=386 GOOS=windows CGO_ENABLED=0 $(GOBUILD) -tags windivert -o $(BINDIR)/$(NAME)-$@.exe $(GOFILES)

windows-amd64:
	GOARCH=amd64 GOOS=windows CGO_ENABLED=0 $(GOBUILD) -tags windivert -o $(BINDIR)/$(NAME)-$@.exe $(GOFILES)

gz_releases=$(addsuffix .gz, $(PLATFORM_LIST))
zip_releases=$(addsuffix .zip, $(WINDOWS_ARCH_LIST))

$(gz_releases): %.gz : %
	chmod +x $(BINDIR)/$(NAME)-$(basename $@)
	gzip -f -S -$(VERSION).gz $(BINDIR)/$(NAME)-$(basename $@)

$(zip_releases): %.zip : %
	zip -m -j $(BINDIR)/$(NAME)-$(basename $@)-$(VERSION).zip $(BINDIR)/$(NAME)-$(basename $@).exe

all-arch: $(PLATFORM_LIST) $(WINDOWS_ARCH_LIST)

releases: $(gz_releases) $(zip_releases)
clean:
	rm $(BINDIR)/*
