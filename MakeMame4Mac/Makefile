#
# Copyright (c) 2011 Antoine Terrienne antoine.terrienne at gmail.com
#
# This file is part of MakeMame4Mac.
#
# MakeMame4Mac is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MakeMame4Mac is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MakeMame4Mac.  If not, see <http://www.gnu.org/licenses/>.
#


ROOT=$(PWD)

SOURCES_DIR=$(ROOT)/sources
BUILD_DIR=$(ROOT)/build
RESOURCES_DIR=$(ROOT)/resources

MAME_MAIN_EXE=mame64

APPLICATION_NAME=Mame

APPLICATION_BUNDLE_DIR=$(ROOT)/$(APPLICATION_NAME).app
APPLICATION_BUNDLE_CONTENT=$(APPLICATION_BUNDLE_DIR)/Contents
BUNDLE_EXE_DIR=$(APPLICATION_BUNDLE_CONTENT)/MacOS
BUNDLE_RESOURCES_DIR=$(APPLICATION_BUNDLE_CONTENT)/Resources

PROG=$(BUNDLE_EXE_DIR)/$(MAME_MAIN_EXE)

RUNTIME_ROOT=$(BUNDLE_RESOURCES_DIR)

LIBS=$(RUNTIME_ROOT)/lib
INCLUDES=$(BUILD_DIR)

PKG_CONFIG_PATH=$(LIBS)/pkgconfig

ENV_CONFIG=PKG_CONFIG_PATH="$(PKG_CONFIG_PATH):/usr/X11/lib/pkgconfig" \
        PATH="$(PATH):$(BUILD_DIR)/bin"

MAME_VERSION=0143s
MAME_PACKAGE=mame$(MAME_VERSION).zip
MAME_SRC=mame$(MAME_VERSION)
MAME_RELEASE_URL=http://mamedev.thiswebhost.com/releases/$(MAME_PACKAGE)

MAME_DOWNLOADED=$(SOURCES_DIR)/$(MAME_PACKAGE)
MAME_UNPACKED=$(SOURCES_DIR)/$(MAME_SRC)
MAME_CONFIGURED=$(SOURCES_DIR)/$(MAME_SRC)/makefile
MAME_INSTALLED=$(MAME_UNPACKED)/$(MAME_MAIN_EXE)

MAME_PATCH=$(RESOURCES_DIR)/$(MAME_SRC).patch

# 1.2.14 has a bug with fullscreen on Mac OS X. Using head from repository.
#SDL_VERSION=1.2.14
SDL_VERSION=repository
SDL_PACKAGE=SDL-$(SDL_VERSION).tar.gz
SDL_SRC=SDL-$(SDL_VERSION)
SDL_RELEASE_URL=http://www.libsdl.org/release/$(SDL_PACKAGE)

SDL_DOWNLOADED=$(SOURCES_DIR)/$(SDL_PACKAGE)
SDL_UNPACKED=$(SOURCES_DIR)/$(SDL_SRC)
SDL_CONFIGURED=$(SOURCES_DIR)/$(SDL_SRC)/Makefile
SDL_INSTALLED=$(LIBS)/pkgconfig/sdl.pc

all : $(PROG)

$(PROG) : $(MAME_INSTALLED)
	cp $< $@


$(APPLICATION_BUNDLE_CONTENT)/Info.plist:
	mkdir -p $(BUNDLE_EXE_DIR) && \
	mkdir -p $(BUNDLE_RESOURCES_DIR) && \
	sed -e "s/MAME_EXE/$(MAME_MAIN_EXE)/" < $(RESOURCES_DIR)/launcher.sh > $(BUNDLE_EXE_DIR)/launcher.sh && \
	chmod a+x $(BUNDLE_EXE_DIR)/launcher.sh && \
	cp $(RESOURCES_DIR)/mame.icns $(BUNDLE_RESOURCES_DIR)/ && \
	cp $(RESOURCES_DIR)/Info.plist $(APPLICATION_BUNDLE_CONTENT)/


$(SOURCES_DIR) $(BUILD_DIR) :
	mkdir -p $@


$(MAME_DOWNLOADED) :
	mkdir -p $(SOURCES_DIR) && \
	curl $(MAME_RELEASE_URL) > $(MAME_DOWNLOADED)

$(MAME_CONFIGURED) : $(MAME_DOWNLOADED)
	cd $(SOURCES_DIR) && \
	unzip $(MAME_PACKAGE) && \
	mkdir $(MAME_SRC) && \
	unzip -d $(MAME_SRC) mame.zip && \
	cd $(MAME_SRC); \
	patch -p1 < $(MAME_PATCH); \
	touch $@


$(MAME_INSTALLED) : $(MAME_CONFIGURED) $(SDL_INSTALLED)
	cd $(MAME_UNPACKED) && $(ENV_CONFIG) make



$(SDL_DOWNLOADED) : $(SOURCES_DIR)
	mkdir -p $(SOURCES_DIR) && \
	curl $(SDL_RELEASE_URL) > $(SDL_DOWNLOADED)

$(SOURCES_DIR)/SDL-repository/configure :
	mkdir -p $(SOURCES_DIR) && \
	cd $(SOURCES_DIR) && \
	hg clone -u SDL-1.2 http://hg.libsdl.org/SDL SDL-repository && \
	cd SDL-repository && \
	./autogen.sh

$(SDL_CONFIGURED) : $(SDL_UNPACKED)/configure $(APPLICATION_BUNDLE_CONTENT)/Info.plist
	cd $(SDL_UNPACKED) &&           \
	$(ENV_CONFIG)                   \
	./configure                     \
	--without-x                     \
	--prefix=$(BUILD_DIR)           \
	--libdir=$(LIBS)

$(SDL_INSTALLED) : $(SDL_CONFIGURED)
	cd $(SDL_UNPACKED) && make && make install
