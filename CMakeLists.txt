#
# Copyright (c) 2011-2014 Antoine Terrienne antoine.terrienne at gmail.com
#
# This file is part of MaleMame4Mac.
#
# MaleMame4Mac is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MaleMame4Mac is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Pouillotpouillot.  If not, see <http://www.gnu.org/licenses/>.
#

cmake_minimum_required(VERSION 3.0)

set(DEPS_INSTALL_DIR ${CMAKE_BINARY_DIR}/deps)
set(DEPS_INC_DIR ${DEPS_INSTALL_DIR}/include)
set(DEPS_LIB_DIR ${DEPS_INSTALL_DIR}/lib)
set(DEPS_BIN_DIR ${DEPS_INSTALL_DIR}/bin)

set(RESOURCES_DIR ${CMAKE_SOURCE_DIR}/resources)
set(PATCHES_DIR ${CMAKE_SOURCE_DIR}/patches)

include(ExternalProject)

set(SDL_VERSION 2.0.3)

ExternalProject_Add(SDL
	URL https://www.libsdl.org/release/SDL2-${SDL_VERSION}.tar.gz
	PATCH_COMMAND patch -p 1 -i ${PATCHES_DIR}/SDL2-${SDL_VERSION}.patch
     	CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR}
                   -DCMAKE_LIBRARY_PATH=${DEPS_LIB_PATH}
                   -DCMAKE_INCLUDE_PATH=${DEPS_INC_PATH}
		   -DCMAKE_PROGRAM_PATH=${DEPS_BIN_DIR}
                   -DCMAKE_BUILD_TYPE=Release
		   -DSDL_STATIC=ON
		   -DSDL_SHARED=OFF
        BUILD_COMMAND ${CMAKE_COMMAND} --build . --config Release
        INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config Release --target install && sed -e "s%-l/[^ ]*/\\([^/]*\\).framework%-framework \\1%g" -i .orig ${DEPS_BIN_DIR}/sdl2-config
	INSTALL_DIR ${DEPS_INSTALL_DIR}
)

set(MAME_VERSION 0155s)

ExternalProject_Add(MAME
	DEPENDS SDL
	DOWNLOAD_COMMAND
		curl --progress-bar -L -O http://mamedev.org/downloader.php?file=releases/mame${MAME_VERSION}.zip &&
		unzip mame${MAME_VERSION}.zip &&
		unzip mame.zip -d <SOURCE_DIR>
	PATCH_COMMAND patch -p 1 -i ${PATCHES_DIR}/mame${MAME_VERSION}.patch
	CONFIGURE_COMMAND ""
	BUILD_COMMAND
		cd <SOURCE_DIR> &&
		MACOSX_USE_LIBSDL=1 SDL_LIBVER=sdl2 SDL_INSTALL_ROOT=${DEPS_INSTALL_DIR} PTR64=1 ARCHOPTS="-march=native" COMMAND_MODE="legacy" make
	INSTALL_COMMAND ${RESOURCES_DIR}/build_mame_app.sh ${CMAKE_BINARY_DIR}/Mame.app ${DEPS_LIB_DIR} ${RESOURCES_DIR} <SOURCE_DIR> ${MAME_VERSION}
)
