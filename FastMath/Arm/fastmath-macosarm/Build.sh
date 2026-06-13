OUTPUT="../../libfastmath-macosarm.a"
PLATFORM="MacOSX"
MIN_VERSION="10.10"

DEVELOPER_DIR=`xcode-select -print-path`
if [ ! -d $DEVELOPER_DIR ]; then
  echo "Please set up Xcode correctly. '$DEVELOPER_DIR' is not a valid developer tools folder."
  exit 1
fi

SDK_ROOT=$DEVELOPER_DIR/Platforms/$PLATFORM.platform/Developer/SDKs/$PLATFORM.sdk
if [ ! -d $SDK_ROOT ]; then
  echo "The iOS SDK was not found in $SDK_ROOT."
  exit 1
fi

rm *.o
rm $OUTPUT

clang -c -O3 -arch arm64 -isysroot $SDK_ROOT -mmacosx-version-min=$MIN_VERSION ../Arm64/approx_64.S ../Arm64/common_64.S ../Arm64/exponential_64.S ../Arm64/matrix2_64.S ../Arm64/matrix3_64.S ../Arm64/matrix4_64.S ../Arm64/trig_64.S ../Arm64/vector2_64.S ../Arm64/vector3_64.S ../Arm64/vector4_64.S
ar rcs $OUTPUT *_64.o
ranlib $OUTPUT

rm *.o
