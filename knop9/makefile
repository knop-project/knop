#
# A makefile to compile Lasso plugins on Mac or Linux.
#

### VARIABLES

## Environment
# settings
OS := $(shell uname -s)
#ARCH := $(shell uname -m)

# paths
LASSOC ?= $(shell which lassoc)
LASSO9_HOME ?= /var/lasso/home
LASSOROOT ?= $(if $(LASSO9_MASTER_HOME),$(LASSO9_MASTER_HOME),$(LASSO9_HOME))
MOD_DST ?= $(LASSOROOT)/LassoModules
LIB_DST ?= $(LASSOROOT)/LassoLibraries
LASSOAPP_DST ?= $(LASSOROOT)/LassoApps
BIN_DST ?= /usr/local/bin
VPATH ?= .

# extensions
SRC_EXT ?= lasso
OBJ_EXT = o
OBJ_LIB_EXT = d.$(OBJ_EXT)
OBJ_LASSOAPP_EXT = ap.$(OBJ_EXT)
OBJ_BIN_EXT = a.$(OBJ_EXT)
BC_EXT = bc
LIB_EXT = $($(OS)_LIB_EXT)
LASSOAPP_EXT = lassoapp
ZIP_EXT = zip


## Mac OS X
# compile against an SDK if a minimum system version is specified
ifdef MACOSX_DEPLOYMENT_TARGET
  # use Xcode to locate the specified SDK
  SDKROOT := $(shell xcodebuild -version -sdk macosx$(MACOSX_DEPLOYMENT_TARGET) Path)
  # use the SDK for all system libraries
  MACOSX_VERSION_MIN := -isysroot $(SDKROOT) -mmacosx-version-min=$(MACOSX_DEPLOYMENT_TARGET)
endif

# native compiler flags
Darwin_ARCH = -arch $(ARCH)
Darwin_CPPFLAGS += -DMACHINE_MACOSX -F/Library/Frameworks -I/Library/Frameworks/Lasso9.framework/Headers $(MACOSX_VERSION_MIN)
Darwin_Lib_LDFLAGS += -dynamiclib -Wl,-undefined,error
Darwin_LDFLAGS += -F/Library/Frameworks $(MACOSX_VERSION_MIN)
Darwin_LDLIBS += -framework Lasso9
Darwin_LIB_EXT = dylib


## Linux
# native compiler flags
Linux_ARCH = -march=$(subst _,-,$(ARCH))
Linux_CPPFLAGS += -DMACHINE_LINUX -I/usr/include/Lasso9 -fPIC -Wno-multichar
Linux_Lib_LDFLAGS += -shared -Wl,-Bsymbolic -Wl,--no-undefined
Linux_LDFLAGS += -pthread
Linux_LDLIBS += -llasso9_runtime -ldl -lm -lrt
Linux_LIB_EXT = so


## All platforms
# compiler flags
CPPFLAGS = $($(OS)_CPPFLAGS) $(DEBUG_FLAGS) -pthread -fshort-wchar
CFLAGS = $($(OS)_CFLAGS)
CXXFLAGS = $($(OS)_CXXFLAGS) #-Wno-deprecated
LDFLAGS = $($(OS)_LDFLAGS) $(DEBUG_FLAGS)
LDLIBS = $($(OS)_LDLIBS)

ifeq ($(DEBUG),1)
  LDEBUG_FLAGS = -g
  DEBUG_FLAGS = -g3 -O0 -DDEBUG
  Darwin_DEBUG_CMD = dsymutil -o $(basename $@).dSYM $@
else
  LDEBUG_FLAGS = -O
  DEBUG_FLAGS = -g0 -O3 -DNDEBUG
endif

ifdef ARCH
  LDEBUG_FLAGS += -arch $(ARCH)
  TARGET_ARCH += $($(OS)_ARCH)
  OBJ_EXT = $(ARCH).o
endif

OBJ_FLAGS = -n -obj
LIB_FLAGS = -dll
LASSOAPP_FLAGS = -lassoapp
BIN_FLAGS = -app

OBJ_LIB_FLAGS = $(LDEBUG_FLAGS) $(OBJ_FLAGS) $(LIB_FLAGS)
OBJ_LASSOAPP_FLAGS = $(LDEBUG_FLAGS) $(OBJ_FLAGS) $(LIB_FLAGS) $(LASSOAPP_FLAGS)
OBJ_BIN_FLAGS = $(LDEBUG_FLAGS) $(OBJ_FLAGS) $(BIN_FLAGS)
BC_FLAGS = $(LDEBUG_FLAGS) $(LIB_FLAGS)


### RULES

## Main targets
.PHONY: default mod lib $(LIB_EXT) $(BC_EXT) app $(LASSOAPP_EXT) $(ZIP_EXT) debug install clean

# default target
default: lib

# create module named TARGET from C/C++ sources specified in SRCS
mod: $(TARGET).$(LIB_EXT)

# create shared libraries or bitcode libraries from Lasso files in current directory
lib $(LIB_EXT): $(patsubst $(VPATH)/%.$(SRC_EXT),%.$(LIB_EXT),$(wildcard $(VPATH)/*.$(SRC_EXT)))
$(BC_EXT): $(patsubst $(VPATH)/%.$(SRC_EXT),%.$(BC_EXT),$(wildcard $(VPATH)/*.$(SRC_EXT)))

# create LassoApps or zipped LassoApps from each directory containing an _init file
app $(LASSOAPP_EXT): $(addsuffix .$(LASSOAPP_EXT),$(sort $(shell find $(VPATH) -mindepth 2 -maxdepth 2 -type f -name "_init*.$(SRC_EXT)" | cut -d / -f 2)))
$(ZIP_EXT): $(addsuffix .$(ZIP_EXT),$(sort $(shell find $(VPATH) -mindepth 2 -maxdepth 2 -type f -name "_init*.$(SRC_EXT)" | cut -d / -f 2)))


## Debug targets
# run default target with debug options
debug: clean
	$(MAKE) -j2 DEBUG=1

# run specific target with debug options
%.debug: clean
	$(MAKE) -j2 $* DEBUG=1


## Install targets
# skip printing message if this makefile is being included by another
install:
ifeq ($(words $(MAKEFILE_LIST)),1)
	$(error 'install' target not defined in this context, run `make [target].install` instead)
endif

# install all products of a specified type
lib.install $(LIB_EXT).install: | $(LIB_DST)
	@install -v $(wildcard *.$(LIB_EXT)) $|/ || :
$(BC_EXT).install: | $(LIB_DST)
	@install -v $(wildcard *.$(BC_EXT)) $|/ || :
app.install $(LASSOAPP_EXT).install: | $(LASSOAPP_DST)
	@install -v $(wildcard *.$(LASSOAPP_EXT)) $|/ || :
$(ZIP_EXT).install: | $(LASSOAPP_DST)
	@install -v $(wildcard *.$(ZIP_EXT)) $|/ || :
bin.install: | $(BIN_DST)
	@$(shell [ -w $| ] || echo sudo) install -v $(shell find . -maxdepth 1 -type f -perm +111 -exec file {} \; | grep -E "(Mach-O|ELF).*executable" | cut -d : -f 1) $|/ || :

# install products by name
$(TARGET).$(LIB_EXT).install mod.install: | $(MOD_DST)
	@install -v $(TARGET).$(LIB_EXT) $|/ || :
%.$(LIB_EXT).install: | $(LIB_DST)
	@install -v $*.$(LIB_EXT) $|/ || :
%.$(BC_EXT).install: | $(LIB_DST)
	@install -v $*.$(BC_EXT) $|/ || :
%.$(LASSOAPP_EXT).install: | $(LASSOAPP_DST)
	@install -v $*.$(LASSOAPP_EXT) $|/ || :
%.$(ZIP_EXT).install: | $(LASSOAPP_DST)
	@install -v $*.$(ZIP_EXT) $|/ || :
%.bin.install: | $(BIN_DST)
	@$(shell [ -w $| ] || echo sudo) install -v $* $|/ || :
%.bin.uninstall: | $(BIN_DST)
	$(shell [ -w $| ] || echo sudo) rm -f $|/$*

# create directories from absolute paths
/%:
	@mkdir -p /$* || sudo install -dv -o $(USER) /$*


## Clean target
clean::
	@rm -rf *.o *.dSYM *.$(LIB_EXT) *.$(BC_EXT) *.$(LASSOAPP_EXT) *.$(ZIP_EXT)
	@find . -maxdepth 2 -type f -name ".DS_Store" -delete -or -type d -empty -delete


## Intermediate products
# object files prepared for shared libraries
%.$(OBJ_LIB_EXT): %.$(SRC_EXT)
	$(LASSOC) $(OBJ_LIB_FLAGS) -o $@ $<

# object files prepared for LassoApps
%.$(OBJ_LASSOAPP_EXT): $(VPATH)/% $(VPATH)/%/*
	$(LASSOC) $(OBJ_LASSOAPP_FLAGS) -o $@ $<

# object files prepared for binaries
%.$(OBJ_BIN_EXT): %.$(SRC_EXT)
	$(LASSOC) $(OBJ_BIN_FLAGS) -o $@ $<


## Final products
# bitcode library
%.$(BC_EXT): %.$(SRC_EXT)
	$(LASSOC) $(BC_FLAGS) -o $@ $<

# named module from C/C++ sources
$(TARGET).$(LIB_EXT): $(addsuffix .o,$(basename $(SRCS)))
	$(if $(SRCS),,$(error No source files specified in SRCS variable))
	$(CXX) $(LDFLAGS) $($(OS)_Lib_LDFLAGS) $^ $(LDLIBS) -o $@
	$($(OS)_DEBUG_CMD)

# shared library from Lasso sources
%.$(LIB_EXT): %.$(OBJ_LIB_EXT)
	$(CC) $(LDFLAGS) $($(OS)_Lib_LDFLAGS) $< $(LDLIBS) -o $@
	$($(OS)_DEBUG_CMD)

# compiled LassoApp
%.$(LASSOAPP_EXT): %.$(OBJ_LASSOAPP_EXT)
	$(CC) $(LDFLAGS) $($(OS)_Lib_LDFLAGS) $< $(LDLIBS) -o $@
	$($(OS)_DEBUG_CMD)

# zipped LassoApp
%.$(ZIP_EXT): $(VPATH)/% $(VPATH)/%/*
	cd $(VPATH)/$* && zip -qr "$@" * -x "*[mM]akefile" "*~" "*._*" "*.DS_Store" "*.svn*" "*.hg*" "*.git*"
	mv $(VPATH)/$*/$@ .

# binary
%: %.$(OBJ_BIN_EXT)
	$(CC) $(LDFLAGS) $< $(LDLIBS) -o $@
	$($(OS)_DEBUG_CMD)

# keep makefile from attempting to rebuild itself
$(MAKEFILE_LIST): ;