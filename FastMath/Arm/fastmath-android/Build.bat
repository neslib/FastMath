@echo off

REM Set this variable to the location of ndk-build.cmd
REM Tested with NDK version 17c.
set NDK_BUILD=e:\android-ndk-r17c\ndk-build.cmd

REM Name of generated static library
set LIB32=obj\local\armeabi-v7a\libfastmath-android.a
set LIB64=obj\local\arm64-v8a\libfastmath-android.a

if not exist %NDK_BUILD% (
  echo Cannot find ndk-build. Check the NDK_BUILD variable.
  exit /b
)

REM Build 32-bit Thumb version for Delphi 10.3 Rio and later
REM Also build 64-bit version for Delphi 10.3.3 and later
REM ========================================================

REM Run ndk-build to build static library
set FORCE_THUMB=true
call %NDK_BUILD% -B

if not exist %LIB32% (
  echo Cannot find static library %LIB32%
  exit /b
)

if not exist %LIB64% (
  echo Cannot find static library %LIB64%
  exit /b
)

REM Copy static library to directory with Delphi source code
copy %LIB32% ..\..\libfastmath-android-32.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)

copy %LIB64% ..\..\libfastmath-android-64.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)

REM Build Arm version for Delphi 10.2 Tokyo and earlier
REM ===================================================

REM Run ndk-build to build static library
set FORCE_THUMB=
call %NDK_BUILD% -B

if not exist %LIB32% (
  echo Cannot find static library %LIB32%
  exit /b
)

REM Copy static library to directory with Delphi source code
copy %LIB32% ..\..\libfastmath-android-arm.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)