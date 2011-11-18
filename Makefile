APPNAME = fx-share-addon
DEPS = github:addon-sdk,github:oauthorizer
PYTHON = python

ifeq ($(TOPSRCDIR),)
  export TOPSRCDIR = $(shell pwd)
endif
profile :=
ifneq ($(OWA_PROFILE),)
  profile := --profiledir="$(OWA_PROFILE)"
endif

deps  := $(TOPSRCDIR)/deps
ifneq ($(DEPSDIR),)
  deps := $(DEPSDIR)
endif

addon_sdk := $(deps)/addon-sdk/bin
oauthorizer := $(deps)/oauthorizer
openwebapps := $(TOPSRCDIR)/addons/jetpack

#cfx_args :=  --pkgdir=$(TOPSRCDIR) $(profile) --package-path=$(oauthorizer) --package-path=$(openwebapps) --binary-args="-console -purgecaches"
cfx_args :=  --pkgdir=$(openwebapps) $(profile) --package-path=$(oauthorizer) --binary-args="-console -purgecaches $(BINARYARGS)"

xpi_name := openwebapps.xpi

test_args :=
ifneq ($(TEST),)
    test_args := -f $(TEST)
endif

# might be useful for symlink handling...
SLINK = ln -sf
ifneq ($(findstring MINGW,$(shell uname -s)),)
  SLINK = cp -r
  export NO_SYMLINK = 1
endif

all: xpi

xpi:    pull
	${MAKE} -C addons/jetpack/mac/
	$(addon_sdk)/cfx xpi $(cfx_args)

pull:
	$(PYTHON) build.py $(APPNAME) $(DEPS)

test:
	$(addon_sdk)/cfx test $(cfx_args) $(test_args)

run:
	${MAKE} -C addons/jetpack/mac/
	$(addon_sdk)/cfx run $(cfx_args)	

.PHONY: xpi clean pull test run
