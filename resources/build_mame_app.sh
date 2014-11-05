#!/bin/sh
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

APP_BUNDLE_ROOT="$1"
DEPS_LIBS_ROOT="$2"
RESOURCES_ROOT="$3"
MAME_BUILD_PATH="$4"
MAME_VERSION="$5"

MAME_MAIN_EXE=mame64
APP_BUNDLE_CONTENTS=${APP_BUNDLE_ROOT}/Contents
APP_BUNDLE_EXE=${APP_BUNDLE_CONTENTS}/MacOS
APP_BUNDLE_RESOURCES=${APP_BUNDLE_CONTENTS}/Resources

# cleanup any previous app bundle
test -d "$APP_BUNDLE_ROOT" && rm -rf "$APP_BUNDLE_ROOT"

# create app bundle structure
mkdir -p ${APP_BUNDLE_EXE} &&
mkdir -p ${APP_BUNDLE_RESOURCES} &&
sed -e "s/MAME_EXE/${MAME_MAIN_EXE}/" < ${RESOURCES_ROOT}/launcher.sh > ${APP_BUNDLE_EXE}/launcher.sh &&
chmod a+x ${APP_BUNDLE_EXE}/launcher.sh &&
cp ${MAME_BUILD_PATH}/${MAME_MAIN_EXE} ${APP_BUNDLE_EXE}/${MAME_MAIN_EXE} &&
cp ${RESOURCES_ROOT}/mame.icns ${APP_BUNDLE_RESOURCES}/ &&
sed -e "s/MAME_VERSION/${MAME_VERSION}/" < ${RESOURCES_ROOT}/Info.plist > ${APP_BUNDLE_CONTENTS}/Info.plist
