OUTPUT="../../libfastmath-ios.a"
PLATFORM="iPhoneOS"

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

rm armv7.a
rm arm64.a
rm *.o

clang -c -O3 -arch armv7 -isysroot $SDK_ROOT -mios-version-min=8 ../Arm32/approx_32.S ../Arm32/common_32.S ../Arm32/exponential_32.S ../Arm32/matrix2_32.S ../Arm32/matrix3_32.S ../Arm32/matrix4_32.S ../Arm32/trig_32.S ../Arm32/vector2_32.S ../Arm32/vector3_32.S ../Arm32/vector4_32.S
ar rcs armv7.a *_32.o
ranlib armv7.a

clang -c -O3 -arch arm64 -isysroot $SDK_ROOT -mios-version-min=8 ../Arm64/approx_64.S ../Arm64/common_64.S ../Arm64/exponential_64.S ../Arm64/matrix2_64.S ../Arm64/matrix3_64.S ../Arm64/matrix4_64.S ../Arm64/trig_64.S ../Arm64/vector2_64.S ../Arm64/vector3_64.S ../Arm64/vector4_64.S
ar rcs arm64.a *_64.o
ranlib arm64.a

rm $OUTPUT
lipo -create -arch armv7 armv7.a -arch arm64 arm64.a -output $OUTPUT

rm armv7.a
rm arm64.a
rm *.o
