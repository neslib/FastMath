# FastMath - Fast Math Library for Delphi

FastMath is a Delphi math library that is optimized for fast performance (sometimes at the cost of not performing error checking or losing a little accuracy). It uses hand-optimized assembly code to achieve much better performance then the equivalent functions provided by the Delphi RTL.

This makes FastMath ideal for high-performance math-intensive applications such as multi-media applications and games. For even better performance, the library provides a variety of "approximate" functions (which all start with a `Fast`-prefix). These can be very fast, but you will lose some (sometimes surprisingly little) accuracy. For gaming and animation, this loss in accuracy is usually perfectly acceptable and outweighed by the increase in speed. Don't use them for scientific calculations though...

You may want to call `DisableFloatingPointExceptions` at application startup to suppress any floating-point exceptions. Instead, it will return extreme values (like Nan or Infinity) when an operation cannot be performed. If you use FastMath in multiple threads, you should call `DisableFloatingPointExceptions` in the `Execute` block of those threads.

## Table of Contents

* [Superior Performance](#superior-performance)
* [Architecture and Design Decisions](#architecture-and-design-decisions)
* [Overloaded Operators](#overloaded-operators)
* [Interoperability with the Delphi RTL](#interoperability-with-the-delphi-rtl)
* [Documentation](#documentation)
* [Directory Organization](#directory-organization)
* [License](#license)

## Superior Performance

Most operations can be performed on both singular values (scalars) as well as vectors (consisting of 2, 3 or 4 values). SIMD optimized assembly code is used to calculate multiple outputs at the same time. For example, adding two 4-value vectors together is almost as fast as adding two single values together, resulting in a 4-fold speed increase. Many functions are written in such a way that the performance is even better. 

Here are some examples of speed up factors you can expect on different platforms:

| RTL                   | FastMath             | x86-32 | x86-64 | Arm32  | Arm64  |
|-----------------------|----------------------|-------:|-------:|-------:|-------:|
| TVector3D + TVector3D | TVector4 + TVector4  |  1.2x  |  1.6x  |   2.8x |   2.5x |
| Single * TVector3D    | Single * TVector4    |  2.2x  |  2.1x  |   5.6x |   3.7x |
| TVector3D.Length      | TVector4.Length      |  3.0x  |  5.6x  |  19.9x |  17.1x |
| TVector3D.Normalize   | TVector4.Normalize   |  4.1x  |  5.1x  |   7.4x |  11.7x |
| TVector3D * TMatrix3D | TVector4 * TMatrix4  |  1.3x  |  4.0x  |   6.5x |   4.2x |
| TMatrix3D * TMatrix3D | TMatrix4 * TMatrix4  |  2.2x  |  7.2x  |   5.4x |   8.0x |
| TMatrix3D.Inverse     | TMatrix4.Inverse     |  9.8x  |  9.2x  |   8.0x |   9.8x |
| Sin(Single) (x4)      | FastSin(TVector4)    | 14.8x  |  7.7x  |  42.6x |  40.1x |
| SinCos(Single) (x4)   | FastSinCos(TVector4) | 19.1x  |  9.0x  |  67.9x |  93.3x |
| Exp2(Single) (x4)     | FastExp2(TVector4)   | 22.4x  | 32.7x  | 275.0x | 302.4x |

As you can see, some very common (3D) operations like matrix multiplication and inversion can be almost 10 times faster than their corresponding RTL versions. In addition, FastMath includes a number of `Fast*` approximation functions that sacrifice a little accuracy for an enormous speed increase. For example, using `FastSinCos` to calculate 4 sine and cosine functions in parallel can be up to 90 times faster than calling the RTL `SinCos` function 4 times, while still providing excellent accuracy for angles up to +/4000 radians (or +/- 230,000 degrees). 

On 32-bit and 64-bit desktop platforms (Windows and OS X), this performance is achieved by using the SSE2 instruction set. This means that the computer must support SSE2. However, since SSE2 was introduced back in 2001, the vast majority of computers in use today will support it. All 64-bit desktop computers have SSE2 support by default. However, you can always compile this library with the `FM_NOSIMD` define to disable SIMD optimization and use plain Pascal versions. This can also be useful to compare the speed of the Pascal versions with the SIMD optimized versions.

On 32-bit mobile platforms (iOS and Android), the NEON instruction set is used for SIMD optimization. This means that your device needs to support NEON. But since Delphi already requires this, this poses no further restrictions.

On 64-bit mobile platforms (iOS), the Arm64/AArch64 SIMD instruction set is used.

There is no hardware accelerated support for the iOS simulator (it will use Pascal versions for all calculations).

## Architecture and Design Decisions

FastMath operations on single-precision floating-point values only. Double-precision floating-point arithmetic is (currently) unsupported.

Most functions operate on single values (of type `Single`) and 2-, 3- and 4-dimensional vectors (of types `TVector2`, `TVector3` and `TVector4` respectively). Vectors are not only used to represent points or directions in space, but can also be regarded as arrays of 2, 3 or 4 values that can be used to perform calculations in parallel. In addition to floating-point vectors, there are also vectors that operator on integer values (`TIVector2`, `TIVector3` and `TIVector4`).

There is also support for 2x2, 3x3 and 4x4 matrices (called `TMatrix2`, `TMatrix3` and `TMatrix4`). By default, matrices are stored in row-major order, like those in the RTL's `System.Math.Vectors` unit. However, you can change this layout with the `FM_COLUMN_MAJOR` define. This will store matrices in column-major order instead, which is useful for OpenGL applications (which work best with this layout). In addition, this define will also clip the depth of camera matrices to -1..1 instead of the default 0..1. Again, this is more in line with the default for OpenGL applications.

For representing rotations in 3D space, there is also a `TQuaternion`, which is similar to the RTL's `TQuaternion3D` type.

The operation of the library is somewhat inspired by shader languages (such as GLSL and HLSL). In those languages you can also treat single values and vectors similarly. For example, you can use the `Sin` function to calculate a single sine value, but you can also use it with a `TVector4` type to calculate 4 sine values in one call. When combined with the approximate `Fast*` functions, this can result in an enormous performance boost, as shown earlier.

## Overloaded Operators

All vector and matrix types support overloaded operators which allow you to negate, add, subtract, multiply and divide scalars, vectors and matrices. 

There are also overloaded operators that compare vectors and matrices for equality. These operators check for *exact* matches (like Delphi's `=` operator). They *don't* allow for very small variations (like Delphi's `SameValue` functions).

The arithmetic operators `+`, `-`, `*` and `/` usually work component-wise when applied to vectors. For example if `A` and `B` are of type `TVector4`, then `C := A * B` will set `C` to `(A.X * B.X, A.Y * B.Y, A.Z * B.Z, A.W * B.W)`. It will *not* perform a dot or cross product (you can use the `Dot` and `Cross` functions to compute those).

For matrices, the `+` and `-` operators also operate component-wise. However, when multiplying (or dividing) matrices with vectors or other matrices, then the usual linear algebraic multiplication (or division) is used. For example:

* `M := M1 * M2` performs a linear algebraic matrix multiplication
* `V := M1 * V1` performs a matrix * row vector linear algebraic multiplication
* `V := V1 * M1` performs a column vector * matrix linear algebraic multiplication

To multiply matrices component-wise, you can use the `CompMult` method.

## Interoperability with the Delphi RTL

FastMath provides its own vector and matrix types for superior performance. Most of them are equivalent in functionality and data storage to the Delphi RTL types. You can typecast between them or implicitly convert from the FastMath type to the RTL type or vice versa (eg. `MyVector2 := MyPointF`). The following table shows the mapping:

| Purpose         | FastMath    | Delphi RTL    |
|-----------------|-------------|---------------|
| 2D point/vector | TVector2    | TPointF       |
| 3D point/vector | TVector3    | TPoint3D      |
| 4D point/vector | TVector4    | TVector3D     |
| 2x2 matrix      | TMatrix2    | N/A           |
| 3x3 matrix      | TMatrix3    | TMatrix       |
| 4x4 matrix      | TMatrix4    | TMatrix3D     |
| quaternion      | TQuaternion | TQuaternion3D |

## Documentation

Documentation can be found in the HTML Help file FastMath.chm in the `Doc` directory.

Alternatively, you can [read the documentation on-line](https://neslib.github.io/FastMath/).

## Directory Organization

The FastMath repository hold the following directories:

* `Doc`: documentation in HtmlHelp format. Also contains a spreadsheet (Benchmarks.xlsx) with results of performance tests on my devices (a Core i7 desktop and iPad3).
* `DocSource`: contains batch files for generating the documentation. You need [PasDocEx](https://github.com/neslib/PasDocEx) to generate the documentation yourself if you want to.
* `FastMath`: contains the main `Neslib.FastMath` unit as well as various include files with processor specific optimizations, and static libraries with Arm optimized versions for iOS and Android.
    * `Arm`: Arm specific source code and scripts.
        * `Arm32`: contains the assembly source code for Arm Neon optimized functions.
        * `Arm64`: contains the assembly source code for Arm64 optimized functions.
        * `fastmath-android`: contains a batch file and helper files to build the static library for Android using the Android NDK.
        * `fastmath-ios`: contains a macOS shell script to build a universal static library for iOS.
* `Tests`: contains a FireMonkey application that runs unit tests and performance tests.

## License

FastMath is licensed under the Simplified BSD License. Some of its functions are based on other people's code licensed under the MIT, New BSD and ZLib licenses. Those licenses are as permissive as the Simplified BSD License used for the entire project.

See License.txt for details.

