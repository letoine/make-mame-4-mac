#!/bin/sh
#
# Copyright (c) 2011 Antoine Terrienne antoine.terrienne at gmail.com
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

name="`basename $0`"
tmp="`pwd`/$0"
tmp=`dirname "$tmp"`
tmp=`dirname "$tmp"`
bundle=`dirname "$tmp"`
bundle_contents="$bundle"/Contents
bundle_res="$bundle_contents"/Resources
bundle_lib="$bundle_res"/lib
bundle_bin="$bundle_res"/bin
bundle_data="$bundle_res"/share
bundle_etc="$bundle_res"/etc
mame_exe="$bundle_contents/MacOS/MAME_EXE"
mame_app_dir=$HOME/Applications/Mame

if [ ! -d $mame_app_dir ]; then
    mkdir -p $mame_app_dir
fi

cd $mame_app_dir
export DYLD_LIBRARY_PATH="$bundle_lib"

if [ ! -f $mame_app_dir/mame.ini ]; then
    "$mame_exe" -createconfig
fi

exec "$mame_exe"
