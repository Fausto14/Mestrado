#Generated by VisualGDB (http://visualgdb.com)
#DO NOT EDIT THIS FILE MANUALLY UNLESS YOU ABSOLUTELY NEED TO
#USE VISUALGDB PROJECT PROPERTIES DIALOG INSTEAD

BINARYDIR := Release

#Toolchain
CC := C:/SysGCC/mingw64/bin/gcc.exe
CXX := C:/SysGCC/mingw64/bin/g++.exe
LD := $(CXX)
AR := C:/SysGCC/mingw64/bin/ar.exe
OBJCOPY := C:/SysGCC/mingw64/bin/objcopy.exe

#Additional flags
PREPROCESSOR_MACROS := NDEBUG=1 RELEASE=1
INCLUDE_DIRS := 
LIBRARY_DIRS := 
LIBRARY_NAMES := 
ADDITIONAL_LINKER_INPUTS := 
MACOS_FRAMEWORKS := 
LINUX_PACKAGES := 

CFLAGS := -ggdb -ffunction-sections -O3
CXXFLAGS := -ggdb -ffunction-sections -O3
ASFLAGS := 
LDFLAGS := -Wl,-gc-sections
COMMONFLAGS := 
LINKER_SCRIPT := 

START_GROUP := -Wl,--start-group
END_GROUP := -Wl,--end-group

#Additional options detected from testing the toolchain
USE_DEL_TO_CLEAN := 1
CP_NOT_AVAILABLE := 1
