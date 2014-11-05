This project enable to easily build Mame on MacOSX and package the executable in a
convenient application bundle.

You will need Xcode and CMake 3.0 installed, Mame and SDL2 sources will be automaticaly
downloaded during build (so you also need a connection to the web). The script was
tested on MacOSX 10.10, but should work on older versions too.

The following commands should be enough to build everything:
# cd path/to/make-mame-4-mac
# mkdir build
# cd build
# cmake -G Xcode ..
# cmake --build .

The result will be a Mame.app bundle you can then place in your application folder.
