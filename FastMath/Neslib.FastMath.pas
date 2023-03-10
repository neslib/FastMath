unit Neslib.FastMath;
{< Fast Math Library for Delphi.

  You can set these conditional defines to modify the behavior of this library:
  * FM_COLUMN_MAJOR: Store matrices in column-major order. Be default, matrices
    are store in row-major order for compatibility with the Delphi RTL. However,
    for OpenGL applications, it makes more sense to store matrices in column-
    major order. Another side effect of this define is that the depth of camera
    matrices are clipped to -1..1 (common with OpenGL) instead of 0..1 (uses
    by the Delphi RTL).
  * FM_NOSIMD: Disable SIMD (SSE2, NEON, ARM64) optimizations and run all
    calculations using Pascal code only. You will generally only enable this
    define for (performance) testing, or when running on an old PC that does
    not have support for SSE2. }

{ Copyright (c) 2016 by Erik van Bilsen
  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. }

{$INCLUDE 'Neslib.FastMath.inc'}

interface

uses
  System.Math,
  System.Math.Vectors,
  System.Types;

const
  { Default tolerance for comparing small floating-point values. }
  SINGLE_TOLERANCE = 0.000001;

type
  { A 2-dimensional vector. Can be used to represent points or vectors in
    2D space, using the X and Y fields. You can also use it to represent
    texture coordinates, by using S and T (these are just aliases for X and Y).
    It can also be used to group 2 arbitrary values together in an array (using
    C[0] and C[1], which are also just aliases for X and Y).

    TVector2 is compatible with TPointF in the Delphi RTL. You can typecast
    between these two types or implicitly convert from one to the other through
    assignment (eg. MyVector2 := MyPointF). }
  TVector2 = record
  {$REGION 'Internal Declarations'}
  private
    function GetComponent(const AIndex: Integer): Single; inline;
    procedure SetComponent(const AIndex: Integer; const Value: Single); inline;
    function GetLength: Single; inline;
    procedure SetLength(const AValue: Single); inline;
    function GetLengthSquared: Single; inline;
    procedure SetLengthSquared(const AValue: Single); inline;
    function GetAngle: Single; inline;
    procedure SetAngle(const AValue: Single); inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the two elements (X and Y) to 0. }
    procedure Init; overload; inline;

    { Sets the two elements (X and Y) to A.

      Parameters:
        A: the value to set the two elements to. }
    procedure Init(const A: Single); overload; inline;

    { Sets the two elements (X and Y) to A1 and A2 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to. }
    procedure Init(const A1, A2: Single); overload; inline;

    { Converts a TPoint to a TVector2.

      Parameters:
        APoint: the TPoint to convert. }
    procedure Init(const APoint: TPoint); overload; inline;

    { Implicitly converts a TPointF to a TVector2. }
    class operator Implicit(const A: TPointF): TVector2; inline;

    { Implicitly converts a TVector2 to a TPointF. }
    class operator Implicit(const A: TVector2): TPointF; inline;

    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
    class operator Equal(const A, B: TVector2): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TVector2): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y)) }
    class operator Negative(const A: TVector2): TVector2; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B) }
    class operator Add(const A: TVector2; const B: Single): TVector2; inline;

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y) }
    class operator Add(const A: Single; const B: TVector2): TVector2; inline;

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y) }
    class operator Add(const A, B: TVector2): TVector2; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B) }
    class operator Subtract(const A: TVector2; const B: Single): TVector2; inline;

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y) }
    class operator Subtract(const A: Single; const B: TVector2): TVector2; inline;

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y) }
    class operator Subtract(const A, B: TVector2): TVector2; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B) }
    class operator Multiply(const A: TVector2; const B: Single): TVector2; inline;

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y) }
    class operator Multiply(const A: Single; const B: TVector2): TVector2; inline;

    { Multiplies two vectors component-wise.
      To calculate a dot or cross product instead, use the Dot or Cross function.

      Returns:
        (A.X * B.X, A.Y * B.Y) }
    class operator Multiply(const A, B: TVector2): TVector2; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}

    { Divides a vector by a scalar value.

      Returns:
        (A.X / B, A.Y / B) }
    class operator Divide(const A: TVector2; const B: Single): TVector2; {$IF Defined(FM_INLINE) or Defined(CPUX86)}inline;{$ENDIF}

    { Divides a scalar value by a vector.

      Returns:
        (A / B.X, A / B.Y) }
    class operator Divide(const A: Single; const B: TVector2): TVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two vectors component-wise.

      Returns:
        (A.X / B.X, A.Y / B.Y) }
    class operator Divide(const A, B: TVector2): TVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this vector equals another vector, within a certain tolerance.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if both vectors are equal (within the given tolerance). }
    function Equals(const AOther: TVector2; const ATolerance: Single = SINGLE_TOLERANCE): Boolean; inline;

    { Calculates the distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The distance between this vector and AOther.

      @bold(Note): If you only want to compare distances, you should use
      DistanceSquared instead, which is faster. }
    function Distance(const AOther: TVector2): Single; inline;

    { Calculates the squared distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The squared distance between this vector and AOther. }
    function DistanceSquared(const AOther: TVector2): Single; inline;

    { Calculates the dot product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The dot product between this vector and AOther. }
    function Dot(const AOther: TVector2): Single; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the cross product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The cross product between this vector and AOther. }
    function Cross(const AOther: TVector2): Single; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Offsets this vector in a certain direction.

      Parameters:
        ADeltaX: the delta X direction.
        ADeltaY: the delta Y direction. }
    procedure Offset(const ADeltaX, ADeltaY: Single); overload; inline;

    { Offsets this vector in a certain direction.

      Parameters:
        ADelta: the delta.

      @bold(Note): this is equivalent to adding two vectors together. }
    procedure Offset(const ADelta: TVector2); overload; inline;

    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalized. }
    function Normalize: TVector2; inline;

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): The SIMD optimized versions of this method use an
      approximation, resulting in a very small error.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use Normalize. }
    procedure SetNormalized; inline;

    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use Normalize.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalizedFast. }
    function NormalizeFast: TVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use NormalizeFast. }
    procedure SetNormalizedFast; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates a vector pointing in the same direction as this vector.

      Parameters:
        I: the incident vector.
        NRef: the reference vector.

      Returns:
        A vector that points away from the surface as defined by its normal. If
        NRef.Dot(I) < 0 then it returns this vector, otherwise it returns the
        negative of this vector. }
    function FaceForward(const I, NRef: TVector2): TVector2; inline;

    { Calculates the reflection direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the desired
          result.

      Returns:
        The reflection direction calculated as Self - 2 * N.Dot(Self) * N. }
    function Reflect(const N: TVector2): TVector2; inline;

    { Calculates the refraction direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the
          desired result.
        Eta: the ratio of indices of refraction.

      Returns:
        The refraction vector.

      @bold(Note): This vector should be normalized in order to achieve the
      desired result.}
    function Refract(const N: TVector2; const Eta: Single): TVector2; inline;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimit. }
    function Limit(const AMaxLength: Single): TVector2; inline;

    { Limits the length of this vector, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use Limit. }
    procedure SetLimit(const AMaxLength: Single); inline;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired squared maximum length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimitSquared. }
    function LimitSquared(const AMaxLengthSquared: Single): TVector2;

    { Limits the length of this vector, based on the desired squared maximum
      length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use LimitSquared. }
    procedure SetLimitSquared(const AMaxLengthSquared: Single); inline;

    { Creates a vector with the same direction as this vector, but with the
      length clamped between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of the vector.
        AMaxLength: The maximum length of the vector.

      Returns:
        A length-clamped version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetClamped. }
    function Clamp(const AMinLength, AMaxLength: Single): TVector2;

    { Clamps the length of this vector between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of this vector.
        AMaxLength: The maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-clamped version instead, then use Clamp. }
    procedure SetClamped(const AMinLength, AMaxLength: Single); inline;

    { Creates a vector by rotating this vector counter-clockwise.

      AParameters:
        ARadians: the rotation angle in radians, counter-clockwise assuming the
          Y-axis points up.

      Returns:
        A rotated version version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetRotated. }
    function Rotate(const ARadians: Single): TVector2;

    { Rotates this vector counter-clockwise.

      AParameters:
        ARadians: the rotation angle in radians, counter-clockwise assuming the
          Y-axis points up.

      @bold(Note): If you do not want to change this vector, but get a
      rotated version instead, then use Rotate. }
    procedure SetRotated(const ARadians: Single); inline;

    { Creates a vector by rotating this vector 90 degrees counter-clockwise.

      Returns:
        A rotated version version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetRotated90CCW. }
    function Rotate90CCW: TVector2;

    { Rotates this vector 90 degrees counter-clockwise.

      @bold(Note): If you do not want to change this vector, but get a
      rotated version instead, then use Rotate90CCW. }
    procedure SetRotated90CCW; inline;

    { Creates a vector by rotating this vector 90 degrees clockwise.

      Returns:
        A rotated version version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetRotated90CW. }
    function Rotate90CW: TVector2;

    { Rotates this vector 90 degrees clockwise.

      @bold(Note): If you do not want to change this vector, but get a
      rotated version instead, then use Rotate90CW. }
    procedure SetRotated90CW; inline;

    { Calculates the angle in radians to rotate this vector/point to a target
      vector. Angles are towards the positive Y-axis (counter-clockwise).

      Parameters:
        ATarget: the target vector.

      Returns:
        The angle in radians to the target vector, in the range -Pi to Pi. }
    function AngleTo(const ATarget: TVector2): Single;

    { Linearly interpolates between this vector and a target vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      Returns:
        The interpolation result vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLerp. }
    function Lerp(const ATarget: TVector2; const AAlpha: Single): TVector2; inline;

    { Linearly interpolates between this vector and a target vector and stores
      the result in this vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      @bold(Note): If you do not want to change this vector, but get an
      interpolated version instead, then use Lerp. }
    procedure SetLerp(const ATarget: TVector2; const AAlpha: Single); inline;

    { Whether the vector is normalized (within a small margin of error).

      Returns:
        True if the length of the vector is (very close to) 1.0 }
    function IsNormalized: Boolean; overload; inline;

    { Whether the vector is normalized within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length of the vector is 1.0 within the margin of
        error. }
    function IsNormalized(const AErrorMargin: Single): Boolean; overload;

    { Whether this is a zero vector.

      Returns:
        True if X and Y are exactly 0.0 }
    function IsZero: Boolean; overload; inline;

    { Whether this is a zero vector within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length is smaller then the margin of error. }
    function IsZero(const AErrorMargin: Single): Boolean; overload;

    { Whether this vector has a similar direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is greater than 0. }
    function HasSameDirection(const AOther: TVector2): Boolean; inline;

    { Whether this vector has an opposite direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is less than 0. }
    function HasOppositeDirection(const AOther: TVector2): Boolean; inline;

    { Whether this vector runs parallel to another vector (either in the same
      or the opposite direction).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector runs parallel to AOther (within the given tolerance)

      @bold(Note): every vector is considered to run parallel to a zero vector. }
    function IsParallel(const AOther: TVector2; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is collinear with another vector. Two vectors are
      collinear if they run parallel to each other and point in the same
      direction.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is collinear to AOther (within the given tolerance) }
    function IsCollinear(const AOther: TVector2; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is opposite collinear with another vector. Two vectors
      are opposite collinear if they run parallel to each other and point in
      opposite directions.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is opposite collinear to AOther (within the given
        tolerance) }
    function IsCollinearOpposite(const AOther: TVector2; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is perpendicular to another vector.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is perpendicular to AOther. That is, if the dot
        product is 0 (within the given tolerance) }
    function IsPerpendicular(const AOther: TVector2; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0 or 1). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Single read GetComponent write SetComponent; default;

    { The euclidean length of this vector.

      @bold(Note): If you only want to compare lengths of vectors, you should
      use LengthSquared instead, which is faster.

      @bold(Note): You can also set the length of the vector. In that case, it
      will keep the current direction. }
    property Length: Single read GetLength write SetLength;

    { The squared length of the vector.

      @bold(Note): This property is faster than Length because it avoids
      calculating a square root. It is useful for comparing lengths instead of
      calculating actual lengths.

      @bold(Note): You can also set the squared length of the vector. In that
      case, it will keep the current direction. }
    property LengthSquared: Single read GetLengthSquared write SetLengthSquared;

    { The angle in radians of this vector/point relative to the X-axis. Angles
      are towards the positive Y-axis (counter-clockwise).

      When getting the angle, the result will be between -Pi and Pi. }
    property Angle: Single read GetAngle write SetAngle;
  public
    case Byte of
      { X and Y components of the vector. Aliases for C[0] and C[1]. }
      0: (X, Y: Single);

      { Red and Green components of the vector. Aliases for C[0] and C[1]. }
      1: (R, G: Single);

      { S and T components of the vector. Aliases for C[0] and C[1]. }
      2: (S, T: Single);

      { The two components of the vector. }
      3: (C: array [0..1] of Single);
  end;
  PVector2 = ^TVector2;

type
  { A 3-dimensional vector. Can be used for a variety of purposes:
    * To represent points or vectors in 3D space, using the X, Y and Z fields.
    * To represent colors (using the R, G and B fields, which are just aliases
      for X, Y and Z)
    * To represent texture coordinates (S, T and P, again just aliases for X, Y
      and Z).
    * To group 3 arbitrary values together in an array (C[0]..C[2], also just
      aliases for X, Y and Z)

    @bold(Note): when possible, use TVector4 instead of TVector3, since TVector4
    has better hardware support. Operations on TVector4 types are usually faster
    than operations on TVector3 types.

    TVector3 is compatible with TPoint3D in the Delphi RTL. You can typecast
    between these two types or implicitly convert from one to the other through
    assignment (eg. MyVector3 := MyPoint3D). }
  TVector3 = record
  {$REGION 'Internal Declarations'}
  private
    function GetComponent(const AIndex: Integer): Single; inline;
    procedure SetComponent(const AIndex: Integer; const Value: Single); inline;
    function GetLength: Single; {$IFDEF FM_INLINE}inline;{$ENDIF}
    procedure SetLength(const AValue: Single); inline;
    function GetLengthSquared: Single; inline;
    procedure SetLengthSquared(const AValue: Single); inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the three elements (X, Y and Z) to 0. }
    procedure Init; overload; inline;

    { Sets the three elements (X, Y and Z) to A.

      Parameters:
        A: the value to set the three elements to. }
    procedure Init(const A: Single); overload; inline;

    { Sets the three elements (X, Y and Z) to A1, A2 and A3 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the value to set the third element to. }
    procedure Init(const A1, A2, A3: Single); overload; inline;

    { Sets the first two elements from a 2D vector, and the third element from
      a scalar.

      Parameters:
        A1: the vector to use for the first two elements.
        A2: the value to set the third element to. }
    procedure Init(const A1: TVector2; const A2: Single); overload; inline;

    { Sets the first element from a scaler, and the last two elements from a
      2D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the vector to use for the last two elements. }
    procedure Init(const A1: Single; const A2: TVector2); overload; inline;

    { Implicitly converts a TPoint3D to a TVector3. }
    class operator Implicit(const A: TPoint3D): TVector3; inline;

    { Implicitly converts a TVector3 to a TPoint3D. }
    class operator Implicit(const A: TVector3): TPoint3D; inline;

    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
    class operator Equal(const A, B: TVector3): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TVector3): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y, -A.Z)) }
    class operator Negative(const A: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B, A.Z + B) }
    class operator Add(const A: TVector3; const B: Single): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y, A + B.Z) }
    class operator Add(const A: Single; const B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y, A.Z + B.Z) }
    class operator Add(const A, B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B, A.Z - B) }
    class operator Subtract(const A: TVector3; const B: Single): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y, A - B.Z) }
    class operator Subtract(const A: Single; const B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y, A.Z - B.Z) }
    class operator Subtract(const A, B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B) }
    class operator Multiply(const A: TVector3; const B: Single): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y, A * B.Z) }
    class operator Multiply(const A: Single; const B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two vectors component-wise.
      To calculate a dot or cross product instead, use the Dot or Cross function.

      Returns:
        (A.X * B.X, A.Y * B.Y, A.Z * B.Z) }
    class operator Multiply(const A, B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a vector by a scalar value.

      Returns:
        (A.X / B, A.Y / B, A.Z / B) }
    class operator Divide(const A: TVector3; const B: Single): TVector3; inline;

    { Divides a scalar value by a vector.

      Returns:
        (A / B.X, A / B.Y, A / B.Z) }
    class operator Divide(const A: Single; const B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two vectors component-wise.

      Returns:
        (A.X / B.X, A.Y / B.Y, A.Z / B.Z) }
    class operator Divide(const A, B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this vector equals another vector, within a certain tolerance.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if both vectors are equal (within the given tolerance). }
    function Equals(const AOther: TVector3; const ATolerance: Single = SINGLE_TOLERANCE): Boolean; inline;

    { Calculates the distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The distance between this vector and AOther.

      @bold(Note): If you only want to compare distances, you should use
      DistanceSquared instead, which is faster. }
    function Distance(const AOther: TVector3): Single; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the squared distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The squared distance between this vector and AOther. }
    function DistanceSquared(const AOther: TVector3): Single; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the dot product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The dot product between this vector and AOther. }
    function Dot(const AOther: TVector3): Single; inline;

    { Calculates the cross product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The cross product between this vector and AOther. }
    function Cross(const AOther: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Offsets this vector in a certain direction.

      Parameters:
        ADeltaX: the delta X direction.
        ADeltaY: the delta Y direction.
        ADeltaZ: the delta Z direction. }
    procedure Offset(const ADeltaX, ADeltaY, ADeltaZ: Single); overload; inline;

    { Offsets this vector in a certain direction.

      Parameters:
        ADelta: the delta.

      @bold(Note): this is equivalent to adding two vectors together. }
    procedure Offset(const ADelta: TVector3); overload; inline;


    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalized. }
    function Normalize: TVector3; inline;

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): The SIMD optimized versions of this method use an
      approximation, resulting in a very small error.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use Normalize. }
    procedure SetNormalized; inline;

    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use Normalize.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalizedFast. }
    function NormalizeFast: TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use NormalizeFast. }
    procedure SetNormalizedFast; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates a vector pointing in the same direction as this vector.

      Parameters:
        I: the incident vector.
        NRef: the reference vector.

      Returns:
        A vector that points away from the surface as defined by its normal. If
        NRef.Dot(I) < 0 then it returns this vector, otherwise it returns the
        negative of this vector. }
    function FaceForward(const I, NRef: TVector3): TVector3; inline;

    { Calculates the reflection direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the desired
          result.

      Returns:
        The reflection direction calculated as Self - 2 * N.Dot(Self) * N. }
    function Reflect(const N: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the refraction direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the
          desired result.
        Eta: the ratio of indices of refraction.

      Returns:
        The refraction vector.

      @bold(Note): This vector should be normalized in order to achieve the
      desired result.}
    function Refract(const N: TVector3; const Eta: Single): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimit. }
    function Limit(const AMaxLength: Single): TVector3; inline;

    { Limits the length of this vector, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use Limit. }
    procedure SetLimit(const AMaxLength: Single); inline;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired squared maximum length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimitSquared. }
    function LimitSquared(const AMaxLengthSquared: Single): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Limits the length of this vector, based on the desired squared maximum
      length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use LimitSquared. }
    procedure SetLimitSquared(const AMaxLengthSquared: Single);

    { Creates a vector with the same direction as this vector, but with the
      length clamped between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of the vector.
        AMaxLength: The maximum length of the vector.

      Returns:
        A length-clamped version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetClamped. }
    function Clamp(const AMinLength, AMaxLength: Single): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Clamps the length of this vector between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of this vector.
        AMaxLength: The maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-clamped version instead, then use Clamp. }
    procedure SetClamped(const AMinLength, AMaxLength: Single);

    { Linearly interpolates between this vector and a target vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      Returns:
        The interpolation result vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLerp. }
    function Lerp(const ATarget: TVector3; const AAlpha: Single): TVector3; inline;

    { Linearly interpolates between this vector and a target vector and stores
      the result in this vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      @bold(Note): If you do not want to change this vector, but get an
      interpolated version instead, then use Lerp. }
    procedure SetLerp(const ATarget: TVector3; const AAlpha: Single); inline;

    { Whether the vector is normalized (within a small margin of error).

      Returns:
        True if the length of the vector is (very close to) 1.0 }
    function IsNormalized: Boolean; overload; inline;

    { Whether the vector is normalized within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length of the vector is 1.0 within the margin of
        error. }
    function IsNormalized(const AErrorMargin: Single): Boolean; overload;

    { Whether this is a zero vector.

      Returns:
        True if X, Y and Z are exactly 0.0 }
    function IsZero: Boolean; overload; inline;

    { Whether this is a zero vector within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length is smaller then the margin of error. }
    function IsZero(const AErrorMargin: Single): Boolean; overload;

    { Whether this vector has a similar direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is greater than 0. }
    function HasSameDirection(const AOther: TVector3): Boolean; inline;

    { Whether this vector has an opposite direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is less than 0. }
    function HasOppositeDirection(const AOther: TVector3): Boolean; inline;

    { Whether this vector runs parallel to another vector (either in the same
      or the opposite direction).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector runs parallel to AOther (within the given tolerance) }
    function IsParallel(const AOther: TVector3; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is collinear with another vector. Two vectors are
      collinear if they run parallel to each other and point in the same
      direction.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is collinear to AOther (within the given tolerance) }
    function IsCollinear(const AOther: TVector3; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is opposite collinear with another vector. Two vectors
      are opposite collinear if they run parallel to each other and point in
      opposite directions.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is opposite collinear to AOther (within the given
        tolerance) }
    function IsCollinearOpposite(const AOther: TVector3; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is perpendicular to another vector.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is perpendicular to AOther. That is, if the dot
        product is 0 (within the given tolerance) }
    function IsPerpendicular(const AOther: TVector3; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0-2). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Single read GetComponent write SetComponent; default;

    { The euclidean length of this vector.

      @bold(Note): If you only want to compare lengths of vectors, you should
      use LengthSquared instead, which is faster.

      @bold(Note): You can also set the length of the vector. In that case, it
      will keep the current direction. }
    property Length: Single read GetLength write SetLength;

    { The squared length of the vector.

      @bold(Note): This property is faster than Length because it avoids
      calculating a square root. It is useful for comparing lengths instead of
      calculating actual lengths.

      @bold(Note): You can also set the squared length of the vector. In that
      case, it will keep the current direction. }
    property LengthSquared: Single read GetLengthSquared write SetLengthSquared;
  public
    case Byte of
      { X, Y and Z components of the vector. Aliases for C[0], C[1] and C[2]. }
      0: (X, Y, Z: Single);

      { Red, Green and Blue components of the vector. Aliases for C[0], C[1]
        and C[2]. }
      1: (R, G, B: Single);

      { S, T and P components of the vector. Aliases for C[0], C[1] and C[2]. }
      2: (S, T, P: Single);

      { The three components of the vector. }
      3: (C: array [0..2] of Single);
  end;
  PVector3 = ^TVector3;

type
  { A 4-dimensional vector. Can be used for a variety of purposes:
    * To represent points or vectors in 4D space, using the X, Y, Z and W
      fields.
    * To represent colors with alpha channel information (using the R, G, B and
      A fields, which are just aliases for X, Y, Z and W)
    * To represent texture coordinates (S, T, P and Q, again just aliases for X,
      Y, Z and W).
    * To group 4 arbitrary values together in an array (C[0]..C[3], also just
      aliases for X, Y, Z and W)

    TVector4 is compatible with TVector3D in the Delphi RTL. You can typecast
    between these two types or implicitly convert from one to the other through
    assignment (eg. MyVector4 := MyPoint3D). }
  TVector4 = record
  {$REGION 'Internal Declarations'}
  private
    function GetComponent(const AIndex: Integer): Single; inline;
    procedure SetComponent(const AIndex: Integer; const Value: Single); inline;
    function GetLength: Single; {$IFDEF FM_INLINE}inline;{$ENDIF}
    procedure SetLength(const AValue: Single); inline;
    function GetLengthSquared: Single; inline;
    procedure SetLengthSquared(const AValue: Single); inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the four elements (X, Y, Z and W) to 0. }
    procedure Init; overload; inline;

    { Sets the four elements (X, Y, Z and W) to A.

      Parameters:
        A: the value to set the three elements to. }
    procedure Init(const A: Single); overload; inline;

    { Sets the four elements (X, Y, Z and W) to A1, A2, A3 and A4 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the value to set the third element to.
        A4: the value to set the fourth element to. }
    procedure Init(const A1, A2, A3, A4: Single); overload; inline;

    { Sets the first two elements from a 2D vector, and the last two elements
      from two scalars.

      Parameters:
        A1: the vector to use for the first two elements.
        A2: the value to set the third element to.
        A3: the value to set the fourth element to. }
    procedure Init(const A1: TVector2; const A2, A3: Single); overload; inline;

    { Sets the first and last elements from two scalars, and the middle two
      elements from a 2D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the vector to use for the second and third elements.
        A3: the value to set the fourth element to. }
    procedure Init(const A1: Single; const A2: TVector2; const A3: Single); overload; inline;

    { Sets the first two elements from two scalars and the last two elements
      from a 2D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the vector to use for the last two elements. }
    procedure Init(const A1, A2: Single; const A3: TVector2); overload; inline;

    { Sets the first two elements and last two elements from two 2D vectors.

      Parameters:
        A1: the vector to use for the first two elements.
        A2: the vector to use for the last two elements. }
    procedure Init(const A1, A2: TVector2); overload; inline;

    { Sets the first three elements from a 3D vector, and the fourth element
      from a scalar.

      Parameters:
        A1: the vector to use for the first three elements.
        A2: the value to set the fourth element to. }
    procedure Init(const A1: TVector3; const A2: Single); overload; inline;

    { Sets the first element from a scaler, and the last three elements from a
      3D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the vector to use for the last three elements. }
    procedure Init(const A1: Single; const A2: TVector3); overload; inline;

    { Implicitly converts a TVector3D to a TVector4. }
    class operator Implicit(const A: TVector3D): TVector4; inline;

    { Implicitly converts a TVector4 to a TVector3D. }
    class operator Implicit(const A: TVector4): TVector3D; inline;

    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
    class operator Equal(const A, B: TVector4): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TVector4): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y, -A.Z, -A.W)) }
    class operator Negative(const A: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B, A.Z + B, A.W + B) }
    class operator Add(const A: TVector4; const B: Single): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y, A + B.Z, A + B.W) }
    class operator Add(const A: Single; const B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y, A.Z + B.Z, A.W + B.W) }
    class operator Add(const A, B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B, A.Z - B, A.W - B) }
    class operator Subtract(const A: TVector4; const B: Single): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y, A - B.Z, A - B.W) }
    class operator Subtract(const A: Single; const B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y, A.Z - B.Z, A.W - B.W) }
    class operator Subtract(const A, B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B, A.W * B) }
    class operator Multiply(const A: TVector4; const B: Single): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y, A * B.Z, A * B.W) }
    class operator Multiply(const A: Single; const B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two vectors component-wise.
      To calculate a dot product instead, use the Dot function.

      Returns:
        (A.X * B.X, A.Y * B.Y, A.Z * B.Z, A.W * B.W) }
    class operator Multiply(const A, B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a vector by a scalar value.

      Returns:
        (A.X / B, A.Y / B, A.Z / B, A.W / B) }
    class operator Divide(const A: TVector4; const B: Single): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a vector.

      Returns:
        (A / B.X, A / B.Y, A / B.Z, A / B.W) }
    class operator Divide(const A: Single; const B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two vectors component-wise.

      Returns:
        (A.X / B.X, A.Y / B.Y, A.Z / B.Z, A.W / B.W) }
    class operator Divide(const A, B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this vector equals another vector, within a certain tolerance.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if both vectors are equal (within the given tolerance). }
    function Equals(const AOther: TVector4; const ATolerance: Single = SINGLE_TOLERANCE): Boolean; inline;

    { Calculates the distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The distance between this vector and AOther.

      @bold(Note): If you only want to compare distances, you should use
      DistanceSquared instead, which is faster. }
    function Distance(const AOther: TVector4): Single; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the squared distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The squared distance between this vector and AOther. }
    function DistanceSquared(const AOther: TVector4): Single; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the dot product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The dot product between this vector and AOther. }
    function Dot(const AOther: TVector4): Single; inline;

    { Offsets this vector in a certain direction.

      Parameters:
        ADeltaX: the delta X direction.
        ADeltaY: the delta Y direction.
        ADeltaZ: the delta Z direction.
        ADeltaW: the delta W direction. }
    procedure Offset(const ADeltaX, ADeltaY, ADeltaZ, ADeltaW: Single); overload; inline;

    { Offsets this vector in a certain direction.

      Parameters:
        ADelta: the delta.

      @bold(Note): this is equivalent to adding two vectors together. }
    procedure Offset(const ADelta: TVector4); overload; inline;


    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalized. }
    function Normalize: TVector4; inline;

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): The SIMD optimized versions of this method use an
      approximation, resulting in a very small error.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use Normalize. }
    procedure SetNormalized; inline;

    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use Normalize.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalizedFast. }
    function NormalizeFast: TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use NormalizeFast. }
    procedure SetNormalizedFast; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates a vector pointing in the same direction as this vector.

      Parameters:
        I: the incident vector.
        NRef: the reference vector.

      Returns:
        A vector that points away from the surface as defined by its normal. If
        NRef.Dot(I) < 0 then it returns this vector, otherwise it returns the
        negative of this vector. }
    function FaceForward(const I, NRef: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the reflection direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the desired
          result.

      Returns:
        The reflection direction calculated as Self - 2 * N.Dot(Self) * N. }
    function Reflect(const N: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Calculates the refraction direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the
          desired result.
        Eta: the ratio of indices of refraction.

      Returns:
        The refraction vector.

      @bold(Note): This vector should be normalized in order to achieve the
      desired result.}
    function Refract(const N: TVector4; const Eta: Single): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimit. }
    function Limit(const AMaxLength: Single): TVector4; inline;

    { Limits the length of this vector, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use Limit. }
    procedure SetLimit(const AMaxLength: Single); inline;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired squared maximum length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimitSquared. }
    function LimitSquared(const AMaxLengthSquared: Single): TVector4;

    { Limits the length of this vector, based on the desired squared maximum
      length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use LimitSquared. }
    procedure SetLimitSquared(const AMaxLengthSquared: Single);

    { Creates a vector with the same direction as this vector, but with the
      length clamped between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of the vector.
        AMaxLength: The maximum length of the vector.

      Returns:
        A length-clamped version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetClamped. }
    function Clamp(const AMinLength, AMaxLength: Single): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Clamps the length of this vector between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of this vector.
        AMaxLength: The maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-clamped version instead, then use Clamp. }
    procedure SetClamped(const AMinLength, AMaxLength: Single);

    { Linearly interpolates between this vector and a target vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      Returns:
        The interpolation result vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLerp. }
    function Lerp(const ATarget: TVector4; const AAlpha: Single): TVector4; inline;

    { Linearly interpolates between this vector and a target vector and stores
      the result in this vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      @bold(Note): If you do not want to change this vector, but get an
      interpolated version instead, then use Lerp. }
    procedure SetLerp(const ATarget: TVector4; const AAlpha: Single); inline;

    { Whether the vector is normalized (within a small margin of error).

      Returns:
        True if the length of the vector is (very close to) 1.0 }
    function IsNormalized: Boolean; overload; inline;

    { Whether the vector is normalized within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length of the vector is 1.0 within the margin of
        error. }
    function IsNormalized(const AErrorMargin: Single): Boolean; overload;

    { Whether this is a zero vector.

      Returns:
        True if X, Y, Z and W are exactly 0.0 }
    function IsZero: Boolean; overload; inline;

    { Whether this is a zero vector within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length is smaller then the margin of error. }
    function IsZero(const AErrorMargin: Single): Boolean; overload;

    { Whether this vector has a similar direction compared to another vector.
      The test is performed in 3 dimensions (that is, the W-component is ignored).
      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product (ignoring the W-component) is greater
        than 0. }
    function HasSameDirection(const AOther: TVector4): Boolean; inline;

    { Whether this vector has an opposite direction compared to another vector.
      The test is performed in 3 dimensions (that is, the W-component is ignored).

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product (ignoring the W-component) is less
        than 0. }
    function HasOppositeDirection(const AOther: TVector4): Boolean; inline;

    { Whether this vector runs parallel to another vector (either in the same
      or the opposite direction). The test is performed in 3 dimensions (that
      is, the W-component is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector runs parallel to AOther (within the given tolerance
        and ignoring the W-component) }
    function IsParallel(const AOther: TVector4; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is collinear with another vector. Two vectors are
      collinear if they run parallel to each other and point in the same
      direction. The test is performed in 3 dimensions (that is, the W-component
      is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is collinear to AOther (within the given tolerance
        and ignoring the W-component) }
    function IsCollinear(const AOther: TVector4; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is opposite collinear with another vector. Two vectors
      are opposite collinear if they run parallel to each other and point in
      opposite directions. The test is performed in 3 dimensions (that is, the
      W-component is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is opposite collinear to AOther (within the given
        tolerance and ignoring the W-component) }
    function IsCollinearOpposite(const AOther: TVector4; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Whether this vector is perpendicular to another vector. The test is
    performed in 3 dimensions (that is, the W-component is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is perpendicular to AOther. That is, if the dot
        product is 0 (within the given tolerance and ignoring the W-component) }
    function IsPerpendicular(const AOther: TVector4; const ATolerance: Single = SINGLE_TOLERANCE): Boolean;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0-3). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Single read GetComponent write SetComponent; default;

    { The euclidean length of this vector.

      @bold(Note): If you only want to compare lengths of vectors, you should
      use LengthSquared instead, which is faster.

      @bold(Note): You can also set the length of the vector. In that case, it
      will keep the current direction. }
    property Length: Single read GetLength write SetLength;

    { The squared length of the vector.

      @bold(Note): This property is faster than Length because it avoids
      calculating a square root. It is useful for comparing lengths instead of
      calculating actual lengths.

      @bold(Note): You can also set the squared length of the vector. In that
      case, it will keep the current direction. }
    property LengthSquared: Single read GetLengthSquared write SetLengthSquared;
  public
    case Byte of
      { X, Y, Z and W components of the vector. Aliases for C[0], C[1], C[2]
        and C[3]. }
      0: (X, Y, Z, W: Single);

      { Red, Green, Blue and Alpha components of the vector. Aliases for C[0],
        C[1], C[2] and C[3]. }
      1: (R, G, B, A: Single);

      { S, T, P and Q components of the vector. Aliases for C[0], C[1], C[2] and
        C[3]. }
      2: (S, T, P, Q: Single);

      { The four components of the vector. }
      3: (C: array [0..3] of Single);
  end;
  PVector4 = ^TVector4;

type
  { A 2x2 matrix in row-major order (M[Row, Column]).
    You can access the elements directly using M[0,0]..M[1,1] or m11..m22.
    You can also access the matrix using its two rows R[0]..R[1] (which map
    directly to the elements M[]).

    When the conditional define FM_COLUMN_MAJOR is set, the matrix is stored
    in column-major order instead (M[Column, Row]), and the Rows property
    and R fields are replaced by Columns and C respectively. }
  TMatrix2 = record
  {$REGION 'Internal Declarations'}
  private
    {$IFDEF FM_COLUMN_MAJOR}
    function GetComponent(const AColumn, ARow: Integer): Single; inline;
    procedure SetComponent(const AColumn, ARow: Integer; const Value: Single); inline;
    function GetColumn(const AIndex: Integer): TVector2; inline;
    procedure SetColumn(const AIndex: Integer; const Value: TVector2); inline;
    {$ELSE}
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TVector2; inline;
    procedure SetRow(const AIndex: Integer; const Value: TVector2); inline;
    {$ENDIF}
    function GetDeterminant: Single; inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Initializes the matrix to an identity matrix (filled with 0 and value 1
      for the diagonal) }
    procedure Init; overload; inline;

    { Fills the matrix with zeros and sets the diagonal.

      Parameters:
        ADiagonal: the value to use for the diagonal. Use 1 to set the matrix
          to an identity matrix. }
    procedure Init(const ADiagonal: Single); overload; inline;

    {$IFDEF FM_COLUMN_MAJOR}
    { Initializes the matrix using two column vectors.

      Parameters:
        AColumn0: the first column of the matrix.
        AColumn1: the second column of the matrix. }
    procedure Init(const AColumn0, AColumn1: TVector2); overload; inline;
    {$ELSE}
    { Initializes the matrix using two row vectors.

      Parameters:
        ARow0: the first row of the matrix.
        ARow1: the second row of the matrix. }
    procedure Init(const ARow0, ARow1: TVector2); overload; inline;
    {$ENDIF}

    { Initializes the matrix with explicit values.

      Parameters:
        A11-A12: the values of the matrix elements, in row-major order. }
    procedure Init(const A11, A12, A21, A22: Single); overload; inline;

    { Checks two matrices for equality.

      Returns:
        True if the two matrices match each other exactly. }
    class operator Equal(const A, B: TMatrix2): Boolean; inline;

    { Checks two matrices for inequality.

      Returns:
        True if the two matrices are not equal. }
    class operator NotEqual(const A, B: TMatrix2): Boolean; inline;

    { Negates a matrix.

      Returns:
        The negative value of the matrix (with all elements negated). }
    class operator Negative(const A: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: TMatrix2; const B: Single): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: Single; const B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two matrices component-wise. }
    class operator Add(const A, B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from each element of a matrix. }
    class operator Subtract(const A: TMatrix2; const B: Single): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a matrix from a scalar value. }
    class operator Subtract(const A: Single; const B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two matrices component-wise. }
    class operator Subtract(const A, B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: TMatrix2; const B: Single): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: Single; const B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Performs a matrix * row vector linear algebraic multiplication. }
    class operator Multiply(const A: TMatrix2; const B: TVector2): TVector2; inline;

    { Performs a column vector * matrix linear algebraic multiplication. }
    class operator Multiply(const A: TVector2; const B: TMatrix2): TVector2; inline;

    { Multiplies two matrices using linear algebraic multiplication. }
    class operator Multiply(const A, B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a matrix by a scalar value. }
    class operator Divide(const A: TMatrix2; const B: Single): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a matrix. }
    class operator Divide(const A: Single; const B: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a matrix by a vector. This is equivalent to multiplying the
      inverse of the matrix with a row vector using linear algebraic
      multiplication. }
    class operator Divide(const A: TMatrix2; const B: TVector2): TVector2; inline;

    { Divides a vector by a matrix. This is equivalent to multiplying a column
      vector with the inverse of the matrix using linear algebraic
      multiplication. }
    class operator Divide(const A: TVector2; const B: TMatrix2): TVector2; inline;

    { Divides two matrices. This is equivalent to multiplying the first matrix
      with the inverse of the second matrix using linear algebraic
      multiplication. }
    class operator Divide(const A, B: TMatrix2): TMatrix2; inline;

    { Multiplies this matrix with another matrix component-wise.

      Parameters:
        AOther: the other matrix.

      Returns:
        This matrix multiplied by AOther component-wise.
        That is, Result.M[I,J] := M[I,J] * AOther.M[I,J].

      @bold(Note): For linear algebraic matrix multiplication, use the multiply
      (*) operator instead. }
    function CompMult(const AOther: TMatrix2): TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Creates a transposed version of this matrix.

      Returns:
        The transposed version of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetTransposed. }
    function Transpose: TMatrix2; inline;

    { Transposes this matrix.

      @bold(Note): If you do not want to change this matrix, but get a
      transposed version instead, then use Transpose. }
    procedure SetTransposed; inline;

    { Calculates the inverse of this matrix.

      Returns:
        The inverse of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetInversed.

      @bold(Note): The values in the returned matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    function Inverse: TMatrix2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Inverts this matrix.

      @bold(Note): If you do not want to change this matrix, but get an
      inversed version instead, then use Inverse.

      @bold(Note): The values in the inversed matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    procedure SetInversed;

    {$IFDEF FM_COLUMN_MAJOR}
    { Returns the columns of the matrix. This is identical to accessing the
      C-field.

      Parameters:
        AIndex: index of the row to return (0 or 1). Range is checked with
          an assertion. }
    property Columns[const AIndex: Integer]: TVector2 read GetColumn write SetColumn;

    { Returns the elements of the matrix (in column-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        AColumn: the column index (0 or 1). Range is checked with an assertion.
        ARow: the row index (0 or 1). Range is checked with an assertion. }
    property Components[const AColumn, ARow: Integer]: Single read GetComponent write SetComponent; default;
    {$ELSE}
    { Returns the rows of the matrix. This is identical to accessing the
      R-field.

      Parameters:
        AIndex: index of the column to return (0 or 1). Range is checked with
          an assertion. }
    property Rows[const AIndex: Integer]: TVector2 read GetRow write SetRow;

    { Returns the elements of the matrix (in row-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        ARow: the row index (0 or 1). Range is checked with an assertion.
        AColumn: the column index (0 or 1). Range is checked with an assertion. }
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;
    {$ENDIF}

    { The determinant of this matrix. }
    property Determinant: Single read GetDeterminant;
  public
    case Byte of
      { Row or column vectors, depending on FM_COLUMN_MAJOR define }
      0: (V: array [0..1] of TVector2);

      {$IFDEF FM_COLUMN_MAJOR}
      { The two column vectors making up the matrix }
      1: (C: array [0..1] of TVector2);
      {$ELSE}
      { The two row vectors making up the matrix }
      2: (R: array [0..1] of TVector2);
      {$ENDIF}

      { The elements of the matrix in row-major order }
      3: (M: array [0..1, 0..1] of Single);
      4: (m11, m12: Single;
          m21, m22: Single);
  end;
  PMatrix2 = ^TMatrix2;

type
  { A 3x3 matrix in row-major order (M[Row, Column]).
    You can access the elements directly using M[0,0]..M[2,2] or m11..m33.
    You can also access the matrix using its three rows R[0]..R[2] (which map
    directly to the elements M[]).

    TMatrix3 is compatible with TMatrix in the Delphi RTL. You can typecast
    between these two types or implicitly convert from one to the other through
    assignment (eg. MyMatrix3 := MyMatrix).

    When the conditional define FM_COLUMN_MAJOR is set, the matrix is stored
    in column-major order instead (M[Column, Row]), and the Rows property
    and R fields are replaced by Columns and C respectively. Also, in that case
    assigning an RTL TMatrix to a TMatrix3 will transpose the matrix to keep
    behavior the same. }
  TMatrix3 = record
  {$REGION 'Internal Declarations'}
  private
    {$IFDEF FM_COLUMN_MAJOR}
    function GetComponent(const AColumn, ARow: Integer): Single; inline;
    procedure SetComponent(const AColumn, ARow: Integer; const Value: Single); inline;
    function GetColumn(const AIndex: Integer): TVector3; inline;
    procedure SetColumn(const AIndex: Integer; const Value: TVector3); inline;
    {$ELSE}
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TVector3; inline;
    procedure SetRow(const AIndex: Integer; const Value: TVector3); inline;
    {$ENDIF}
    function GetDeterminant: Single;
  {$ENDREGION 'Internal Declarations'}
  public
    { Initializes the matrix to an identity matrix (filled with 0 and value 1
      for the diagonal) }
    procedure Init; overload; inline;

    { Fills the matrix with zeros and sets the diagonal.

      Parameters:
        ADiagonal: the value to use for the diagonal. Use 1 to set the matrix
          to an identity matrix. }
    procedure Init(const ADiagonal: Single); overload; inline;

    {$IFDEF FM_COLUMN_MAJOR}
    { Initializes the matrix using three column vectors.

      Parameters:
        AColumn0: the first column of the matrix.
        AColumn1: the second column of the matrix.
        AColumn2: the third column of the matrix. }
    procedure Init(const AColumn0, AColumn1, AColumn2: TVector3); overload; inline;
    {$ELSE}
    { Initializes the matrix using three row vectors.

      Parameters:
        ARow0: the first row of the matrix.
        ARow1: the second row of the matrix.
        ARow2: the third row of the matrix. }
    procedure Init(const ARow0, ARow1, ARow2: TVector3); overload; inline;
    {$ENDIF}

    { Initializes the matrix with explicit values.

      Parameters:
        A11-A33: the values of the matrix elements, in row-major order. }
    procedure Init(const A11, A12, A13, A21, A22, A23, A31, A32, A33: Single); overload; inline;

    { Initializes the matrix with a 2x2 matrix. The 2x2 matrix is copied to the
      top-left corner of the 3x3 matrix, and the remaining elements are set
      according to an identity matrix.

      Parameters:
        AMatrix: the source 2x2 matrix. }
    procedure Init(const AMatrix: TMatrix2); overload; inline;

    { Creates a scaling matrix that scales uniformly.

      Parameters:
        AScale: the uniform scale factor }
    procedure InitScaling(const AScale: Single); overload;

    { Creates a scaling matrix.

      Parameters:
        AScaleX: the value to scale by on the X axis
        AScaleY: the value to scale by on the Y axis }
    procedure InitScaling(const AScaleX, AScaleY: Single); overload; inline;

    { Creates a scaling matrix.

      Parameters:
        AScale: the scale factors }
    procedure InitScaling(const AScale: TVector2); overload; inline;

    { Creates a translation matrix.

      Parameters:
        ADeltaX: translation in the X direction
        ADeltaY: translation in the Y direction }
    procedure InitTranslation(const ADeltaX, ADeltaY: Single); overload; inline;

    { Creates a translation matrix.

      Parameters:
        ADelta: translation vector }
    procedure InitTranslation(const ADelta: TVector2); overload; inline;

    { Creates a rotation the matrix using a rotation angle in radians.

      Parameters:
        AAngle: the rotation angle in radians }
    procedure InitRotation(const AAngle: Single);

    { Implicitly converts a TMatrix to a TMatrix3. }
    class operator Implicit(const A: TMatrix): TMatrix3; inline;

    { Implicitly converts a TMatrix3 to a TMatrix. }
    class operator Implicit(const A: TMatrix3): TMatrix; inline;

    { Checks two matrices for equality.

      Returns:
        True if the two matrices match each other exactly. }
    class operator Equal(const A, B: TMatrix3): Boolean; inline;

    { Checks two matrices for inequality.

      Returns:
        True if the two matrices are not equal. }
    class operator NotEqual(const A, B: TMatrix3): Boolean; inline;

    { Negates a matrix.

      Returns:
        The negative value of the matrix (with all elements negated). }
    class operator Negative(const A: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: TMatrix3; const B: Single): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: Single; const B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two matrices component-wise. }
    class operator Add(const A, B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from each element of a matrix. }
    class operator Subtract(const A: TMatrix3; const B: Single): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a matrix from a scalar value. }
    class operator Subtract(const A: Single; const B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two matrices component-wise. }
    class operator Subtract(const A, B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: TMatrix3; const B: Single): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: Single; const B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Performs a matrix * row vector linear algebraic multiplication. }
    class operator Multiply(const A: TMatrix3; const B: TVector3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Performs a column vector * matrix linear algebraic multiplication. }
    class operator Multiply(const A: TVector3; const B: TMatrix3): TVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two matrices using linear algebraic multiplication. }
    class operator Multiply(const A, B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a matrix by a scalar value. }
    class operator Divide(const A: TMatrix3; const B: Single): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a matrix. }
    class operator Divide(const A: Single; const B: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a matrix by a vector. This is equivalent to multiplying the
      inverse of the matrix with a row vector using linear algebraic
      multiplication. }
    class operator Divide(const A: TMatrix3; const B: TVector3): TVector3; inline;

    { Divides a vector by a matrix. This is equivalent to multiplying a column
      vector with the inverse of the matrix using linear algebraic
      multiplication. }
    class operator Divide(const A: TVector3; const B: TMatrix3): TVector3; inline;

    { Divides two matrices. This is equivalent to multiplying the first matrix
      with the inverse of the second matrix using linear algebraic
      multiplication. }
    class operator Divide(const A, B: TMatrix3): TMatrix3; inline;

    { Multiplies this matrix with another matrix component-wise.

      Parameters:
        AOther: the other matrix.

      Returns:
        This matrix multiplied by AOther component-wise.
        That is, Result.M[I,J] := M[I,J] * AOther.M[I,J].

      @bold(Note): For linear algebraic matrix multiplication, use the multiply
      (*) operator instead. }
    function CompMult(const AOther: TMatrix3): TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Creates a transposed version of this matrix.

      Returns:
        The transposed version of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetTransposed. }
    function Transpose: TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Transposes this matrix.

      @bold(Note): If you do not want to change this matrix, but get a
      transposed version instead, then use Transpose. }
    procedure SetTransposed;

    { Calculates the inverse of this matrix.

      Returns:
        The inverse of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetInversed.

      @bold(Note): The values in the returned matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    function Inverse: TMatrix3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Inverts this matrix.

      @bold(Note): If you do not want to change this matrix, but get an
      inversed version instead, then use Inverse.

      @bold(Note): The values in the inversed matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    procedure SetInversed;

    {$IFDEF FM_COLUMN_MAJOR}
    { Returns the columns of the matrix. This is identical to accessing the
      C-field.

      Parameters:
        AIndex: index of the column to return (0-2). Range is checked with
          an assertion. }
    property Columns[const AIndex: Integer]: TVector3 read GetColumn write SetColumn;

    { Returns the elements of the matrix (in column-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        AColumn: the column index (0-2). Range is checked with an assertion.
        ARow: the row index (0-2). Range is checked with an assertion. }
    property Components[const AColumn, ARow: Integer]: Single read GetComponent write SetComponent; default;
    {$ELSE}
    { Returns the rows of the matrix. This is identical to accessing the
      R-field.

      Parameters:
        AIndex: index of the row to return (0-2). Range is checked with
          an assertion. }
    property Rows[const AIndex: Integer]: TVector3 read GetRow write SetRow;

    { Returns the elements of the matrix (in row-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        ARow: the row index (0-2). Range is checked with an assertion.
        AColumn: the column index (0-2). Range is checked with an assertion. }
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;
    {$ENDIF}

    { The determinant of this matrix. }
    property Determinant: Single read GetDeterminant;
  public
    case Byte of
      { Row or column vectors, depending on FM_COLUMN_MAJOR define }
      0: (V: array [0..2] of TVector3);

      {$IFDEF FM_COLUMN_MAJOR}
      { The three column vectors making up the matrix }
      1: (C: array [0..2] of TVector3);
      {$ELSE}
      { The three row vectors making up the matrix }
      2: (R: array [0..2] of TVector3);
      {$ENDIF}

      { The elements of the matrix in row-major order }
      3: (M: array [0..2, 0..2] of Single);
      4: (m11, m12, m13: Single;
          m21, m22, m23: Single;
          m31, m32, m33: Single);
  end;
  PMatrix3 = ^TMatrix3;

type
  { A 4x4 matrix in row-major order (M[Row, Column]).
    You can access the elements directly using M[0,0]..M[3,3] or m11..m44.
    You can also access the matrix using its four rows R[0]..R[3] (which map
    directly to the elements M[]).

    TMatrix4 is compatible with TMatrix3D in the Delphi RTL. You can typecast
    between these two types or implicitly convert from one to the other through
    assignment (eg. MyMatrix4 := MyMatrix3D).

    When the conditional define FM_COLUMN_MAJOR is set, the matrix is stored
    in column-major order instead (M[Column, Row]), and the Rows property
    and R fields are replaced by Columns and C respectively. Also, in that case
    assigning an RTL TMatrix3D to a TMatrix4 will transpose the matrix to keep
    behavior the same. }
  TMatrix4 = record
  {$REGION 'Internal Declarations'}
  private
    {$IFDEF FM_COLUMN_MAJOR}
    function GetComponent(const AColumn, ARow: Integer): Single; inline;
    procedure SetComponent(const AColumn, ARow: Integer; const Value: Single); inline;
    function GetColumn(const AIndex: Integer): TVector4; inline;
    procedure SetColumn(const AIndex: Integer; const Value: TVector4); inline;
    {$ELSE}
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TVector4; inline;
    procedure SetRow(const AIndex: Integer; const Value: TVector4); inline;
    {$ENDIF}
    function GetDeterminant: Single;
  {$ENDREGION 'Internal Declarations'}
  public
    { Initializes the matrix to an identity matrix (filled with 0 and value 1
      for the diagonal) }
    procedure Init; overload; inline;

    { Fills the matrix with zeros and sets the diagonal.

      Parameters:
        ADiagonal: the value to use for the diagonal. Use 1 to set the matrix
          to an identity matrix. }
    procedure Init(const ADiagonal: Single); overload; inline;

    {$IFDEF FM_COLUMN_MAJOR}
    { Initializes the matrix using four column vectors.

      Parameters:
        AColumn0: the first column of the matrix.
        AColumn1: the second column of the matrix.
        AColumn2: the third column of the matrix.
        AColumn3: the fourth column of the matrix. }
    procedure Init(const AColumn0, AColumn1, AColumn2, AColumn3: TVector4); overload; inline;
    {$ELSE}
    { Initializes the matrix using four row vectors.

      Parameters:
        ARow0: the first row of the matrix.
        ARow1: the second row of the matrix.
        ARow2: the third row of the matrix.
        ARow3: the fourth row of the matrix. }
    procedure Init(const ARow0, ARow1, ARow2, ARow3: TVector4); overload; inline;
    {$ENDIF}

    { Initializes the matrix with explicit values.

      Parameters:
        A11-A44: the values of the matrix elements, in row-major order. }
    procedure Init(const A11, A12, A13, A14, A21, A22, A23, A24, A31, A32, A33,
      A34, A41, A42, A43, A44: Single); overload; inline;

    { Initializes the matrix with a 2x2 matrix. The 2x2 matrix is copied to the
      top-left corner of the 4x4 matrix, and the remaining elements are set
      according to an identity matrix.

      Parameters:
        AMatrix: the source 2x2 matrix. }
    procedure Init(const AMatrix: TMatrix2); overload; inline;

    { Initializes the matrix with a 3x3 matrix. The 3x3 matrix is copied to the
      top-left corner of the 4x4 matrix, and the remaining elements are set
      according to an identity matrix.

      Parameters:
        AMatrix: the source 3x3 matrix. }
    procedure Init(const AMatrix: TMatrix3); overload; inline;

    { Creates a scaling matrix that scales uniformly.

      Parameters:
        AScale: the uniform scale factor }
    procedure InitScaling(const AScale: Single); overload;

    { Creates a scaling matrix.

      Parameters:
        AScaleX: the value to scale by on the X axis
        AScaleY: the value to scale by on the Y axis
        AScaleZ: the value to scale by on the Z axis }
    procedure InitScaling(const AScaleX, AScaleY, AScaleZ: Single); overload; inline;

    { Creates a scaling matrix.

      Parameters:
        AScale: the scale factors }
    procedure InitScaling(const AScale: TVector3); overload; inline;

    { Creates a translation matrix.

      Parameters:
        ADeltaX: translation in the X direction
        ADeltaY: translation in the Y direction
        ADeltaZ: translation in the Z direction }
    procedure InitTranslation(const ADeltaX, ADeltaY, ADeltaZ: Single); overload; inline;

    { Creates a translation matrix.

      Parameters:
        ADelta: translation vector }
    procedure InitTranslation(const ADelta: TVector3); overload; inline;

    { Creates a matrix for rotating points around the X axis.

      Parameters:
        AAngle: the rotation angle around the X axis, in radians }
    procedure InitRotationX(const AAngle: Single);

    { Creates a matrix for rotating points around the Y axis.

      Parameters:
        AAngle: the rotation angle around the Y axis, in radians }
    procedure InitRotationY(const AAngle: Single);

    { Creates a matrix for rotating points around the Z axis.

      Parameters:
        AAngle: the rotation angle around the Z axis, in radians }
    procedure InitRotationZ(const AAngle: Single);

    { Creates a matrix for rotating points around a certain axis.

      Parameters:
        AAxis: the direction of the axis to rotate around.
        AAngle: the rotation angle around AAxis, in radians }
    procedure InitRotation(const AAxis: TVector3; const AAngle: Single);

    { Creates a rotation matrix from a yaw, pitch and roll angle.

      Parameters:
        AYaw: the rotation angle around the Y axis, in radians
        APitch: the rotation angle around the X axis, in radians
        ARoll: the rotation angle around the Z axis, in radians }
    procedure InitRotationYawPitchRoll(const AYaw, APitch, ARoll: Single);

    { Creates a rotation matrix from a heading, pitch and bank angle.

      Parameters:
        AHeading: the heading angle, in radians
        APitch: the pitch angle, in radians
        ABank: the bank angle, in radians }
    procedure InitRotationHeadingPitchBank(const AHeading, APitch, ABank: Single);

    { Creates a left-handed view matrix looking at a certain target.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraTarget: the target towards which the camera is pointing.
        ACameraUp: the direction that is "up" from the camera's point of view }
    procedure InitLookAtLH(const ACameraPosition, ACameraTarget, ACameraUp: TVector3);

    { Creates a right-handed view matrix looking at a certain target.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraTarget: the target towards which the camera is pointing.
        ACameraUp: the direction that is "up" from the camera's point of view }
    procedure InitLookAtRH(const ACameraPosition, ACameraTarget, ACameraUp: TVector3);

    { Creates a left-handed view matrix looking into a certain direction.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraDirection: the direction the camera is pointing in.
        ACameraUp: the direction that is "up" from the camera's point of view }
    procedure InitLookAtDirLH(const ACameraPosition, ACameraDirection, ACameraUp: TVector3);

    { Creates a right-handed view matrix looking into a certain direction.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraDirection: the direction the camera is pointing in.
        ACameraUp: the direction that is "up" from the camera's point of view }
    procedure InitLookAtDirRH(const ACameraPosition, ACameraDirection, ACameraUp: TVector3);

    { Creates a left-handed orthographic projection matrix from the given view
      volume dimensions.

      Parameters:
        AWidth: the width of the view volume.
        AHeight: the height of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    procedure InitOrthoLH(const AWidth, AHeight, AZNearPlane, AZFarPlane: Single);

    { Creates a right-handed orthographic projection matrix from the given view
      volume dimensions.

      Parameters:
        AWidth: the width of the view volume.
        AHeight: the height of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    procedure InitOrthoRH(const AWidth, AHeight, AZNearPlane, AZFarPlane: Single);

    { Creates a customized left-handed orthographic projection matrix.

      Parameters:
        ALeft: the minimum X-value of the view volume.
        ATop: the maximum Y-value of the view volume.
        ARight: the maximum X-value of the view volume.
        ABottom: the minimum Y-value of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    procedure InitOrthoOffCenterLH(const ALeft, ATop, ARight, ABottom,
      AZNearPlane, AZFarPlane: Single);

    { Creates a customized right-handed orthographic projection matrix.

      Parameters:
        ALeft: the minimum X-value of the view volume.
        ATop: the maximum Y-value of the view volume.
        ARight: the maximum X-value of the view volume.
        ABottom: the minimum Y-value of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    procedure InitOrthoOffCenterRH(const ALeft, ATop, ARight, ABottom,
      AZNearPlane, AZFarPlane: Single);

    { Creates a left-handed perspective projection matrix based on a field of
      view, aspect ratio, and near and far view plane distances.

      Parameters:
        AFieldOfView: the field of view in radians.
        AAspectRatio: the aspect ratio, defined as view space width divided by
          height.
        ANearPlaneDistance:the distance to the near view plane.
        AFarPlaneDistance:the distance to the far view plane.
        AHorizontalFOV: (optional) boolean indicating the direction of the
          field of view. If False (default), AFieldOfView is in the Y direction,
          otherwise in the X direction }
    procedure InitPerspectiveFovLH(const AFieldOfView, AAspectRatio,
      ANearPlaneDistance, AFarPlaneDistance: Single;
      const AHorizontalFOV: Boolean = False);

    { Creates a right-handed perspective projection matrix based on a field of
      view, aspect ratio, and near and far view plane distances.

      Parameters:
        AFieldOfView: the field of view in radians.
        AAspectRatio: the aspect ratio, defined as view space width divided by
          height.
        ANearPlaneDistance:the distance to the near view plane.
        AFarPlaneDistance:the distance to the far view plane.
        AHorizontalFOV: (optional) boolean indicating the direction of the
          field of view. If False (default), AFieldOfView is in the Y direction,
          otherwise in the X direction }
    procedure InitPerspectiveFovRH(const AFieldOfView, AAspectRatio,
      ANearPlaneDistance, AFarPlaneDistance: Single;
      const AHorizontalFOV: Boolean = False);

    { Implicitly converts a TMatrix3D to a TMatrix4. }
    class operator Implicit(const A: TMatrix3D): TMatrix4; inline;

    { Implicitly converts a TMatrix4 to a TMatrix3D. }
    class operator Implicit(const A: TMatrix4): TMatrix3D; inline;

    { Checks two matrices for equality.

      Returns:
        True if the two matrices match each other exactly. }
    class operator Equal(const A, B: TMatrix4): Boolean; inline;

    { Checks two matrices for inequality.

      Returns:
        True if the two matrices are not equal. }
    class operator NotEqual(const A, B: TMatrix4): Boolean; inline;

    { Negates a matrix.

      Returns:
        The negative value of the matrix (with all elements negated). }
    class operator Negative(const A: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: TMatrix4; const B: Single): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: Single; const B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two matrices component-wise. }
    class operator Add(const A, B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from each element of a matrix. }
    class operator Subtract(const A: TMatrix4; const B: Single): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a matrix from a scalar value. }
    class operator Subtract(const A: Single; const B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two matrices component-wise. }
    class operator Subtract(const A, B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: TMatrix4; const B: Single): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: Single; const B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Performs a matrix * row vector linear algebraic multiplication. }
    class operator Multiply(const A: TMatrix4; const B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Performs a column vector * matrix linear algebraic multiplication. }
    class operator Multiply(const A: TVector4; const B: TMatrix4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two matrices using linear algebraic multiplication. }
    class operator Multiply(const A, B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a matrix by a scalar value. }
    class operator Divide(const A: TMatrix4; const B: Single): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a matrix. }
    class operator Divide(const A: Single; const B: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a matrix by a vector. This is equivalent to multiplying the
      inverse of the matrix with a row vector using linear algebraic
      multiplication. }
    class operator Divide(const A: TMatrix4; const B: TVector4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a vector by a matrix. This is equivalent to multiplying a column
      vector with the inverse of the matrix using linear algebraic
      multiplication. }
    class operator Divide(const A: TVector4; const B: TMatrix4): TVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two matrices. This is equivalent to multiplying the first matrix
      with the inverse of the second matrix using linear algebraic
      multiplication. }
    class operator Divide(const A, B: TMatrix4): TMatrix4; inline;

    { Multiplies this matrix with another matrix component-wise.

      Parameters:
        AOther: the other matrix.

      Returns:
        This matrix multiplied by AOther component-wise.
        That is, Result.M[I,J] := M[I,J] * AOther.M[I,J].

      @bold(Note): For linear algebraic matrix multiplication, use the multiply
      (*) operator instead. }
    function CompMult(const AOther: TMatrix4): TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Creates a transposed version of this matrix.

      Returns:
        The transposed version of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetTransposed. }
    function Transpose: TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Transposes this matrix.

      @bold(Note): If you do not want to change this matrix, but get a
      transposed version instead, then use Transpose. }
    procedure SetTransposed;

    { Calculates the inverse of this matrix.

      Returns:
        The inverse of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetInversed.

      @bold(Note): The values in the returned matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    function Inverse: TMatrix4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Inverts this matrix.

      @bold(Note): If you do not want to change this matrix, but get an
      inversed version instead, then use Inverse.

      @bold(Note): The values in the inversed matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    procedure SetInversed;

    {$IFDEF FM_COLUMN_MAJOR}
    { Returns the columns of the matrix. This is identical to accessing the
      C-field.

      Parameters:
        AIndex: index of the column to return (0-3). Range is checked with
          an assertion. }
    property Columns[const AIndex: Integer]: TVector4 read GetColumn write SetColumn;

    { Returns the elements of the matrix (in column-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        AColumn: the column index (0-3). Range is checked with an assertion.
        ARow: the row index (0-3). Range is checked with an assertion. }
    property Components[const AColumn, ARow: Integer]: Single read GetComponent write SetComponent; default;
    {$ELSE}
    { Returns the rows of the matrix. This is identical to accessing the
      R-field.

      Parameters:
        AIndex: index of the row to return (0-3). Range is checked with
          an assertion. }
    property Rows[const AIndex: Integer]: TVector4 read GetRow write SetRow;

    { Returns the elements of the matrix (in row-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        ARow: the row index (0-3). Range is checked with an assertion.
        AColumn: the column index (0-3). Range is checked with an assertion. }
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;
    {$ENDIF}

    { The determinant of this matrix. }
    property Determinant: Single read GetDeterminant;
  public
    case Byte of
      { Row or column vectors, depending on FM_COLUMN_MAJOR define }
      0: (V: array [0..3] of TVector4);

      {$IFDEF FM_COLUMN_MAJOR}
      { The four column vectors making up the matrix }
      1: (C: array [0..3] of TVector4);
      {$ELSE}
      { The four row vectors making up the matrix }
      2: (R: array [0..3] of TVector4);
      {$ENDIF}

      { The elements of the matrix in row-major order }
      3: (M: array [0..3, 0..3] of Single);
      4: (m11, m12, m13, m14: Single;
          m21, m22, m23, m24: Single;
          m31, m32, m33, m34: Single;
          m41, m42, m43, m44: Single);
  end;
  PMatrix4 = ^TMatrix4;

type
  { Adds common constants of type TMatrix2 }
  _TMatrix2Helper = record helper for TMatrix2
  public const
    Zero    : TMatrix2 = (M: ((0, 0), (0, 0)));
    Identity: TMatrix2 = (M: ((1, 0), (0, 1)));
  public
    { Initializes the matrix with a 3x3 matrix. The upper-left corner of the
      3x3 matrix is copied to the 2x2 matrix.

      Parameters:
        AMatrix: the source 3x3 matrix. }

    procedure Init(const AMatrix: TMatrix3); overload;

    { Initializes the matrix with a 4x4 matrix. The upper-left corner of the
      4x4 matrix is copied to the 3x3 matrix.

      Parameters:
        AMatrix: the source 4x4 matrix. }
    procedure Init(const AMatrix: TMatrix4); overload;
  end;

type
  { Adds common constants of type TMatrix3 }
  _TMatrix3Helper = record helper for TMatrix3
  public const
    Zero    : TMatrix3 = (M: ((0, 0, 0), (0, 0, 0), (0, 0, 0)));
    Identity: TMatrix3 = (M: ((1, 0, 0), (0, 1, 0), (0, 0, 1)));
  public
    { Initializes the matrix with a 4x4 matrix. The upper-left corner of the
      4x4 matrix is copied to the 3x3 matrix.

      Parameters:
        AMatrix: the source 4x4 matrix. }
    procedure Init(const AMatrix: TMatrix4); overload;
  end;

type
  { Adds common constants of type TMatrix4 }
  _TMatrix4Helper = record helper for TMatrix4
  public const
    Zero    : TMatrix4 = (M: ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)));
    Identity: TMatrix4 = (M: ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1)));
  end;

type
  { A quaternion.

    TQuaternion is compatible with TQuaternion3D in the Delphi RTL. You can
    typecast between these two types or implicitly convert from one to the other
    through assignment (eg. MyQuaternion := MyQuaternion3D). }
  TQuaternion = record
  {$REGION 'Internal Declarations'}
  private
    function GetLength: Single; {$IFDEF FM_INLINE}inline;{$ENDIF}
    function GetLengthSquared: Single; {$IFDEF FM_INLINE}inline;{$ENDIF}
  {$ENDREGION 'Internal Declarations'}
  public
    { Initializes the quaternion to an identity quaternion. Sets the X, Y and
      Z components to 0 and the W component to 1. }
    procedure Init; overload; inline;

    { Sets the four components of the quaternion.

      Parameters:
        AX: the X-component.
        AY: the Y-component.
        AZ: the Z-component.
        AW: the W-component. }
    procedure Init(const AX, AY, AZ, AW: Single); overload; inline;

    { Sets the quaternion from the given axis vector and the angle around that
      axis in radians.

      Parameters:
        AAxis: The axis.
        AAngleRadians: The angle in radians. }
    procedure Init(const AAxis: TVector3; const AAngleRadians: Single); overload;

    { Sets the quaternion to the given euler angles in radians.

      Parameters:
        AYaw: the rotation around the Y axis in radians.
        APitch: the rotation around the X axis in radians.
        ARoll: the rotation around the Z axis in radians. }
    procedure Init(const AYaw, APitch, ARoll: Single); overload;

    { Sets the quaternion from a matrix.

      Parameters:
        AMatrix: the matrix. }
    procedure Init(const AMatrix: TMatrix4); overload;

    { Creates a rotation matrix that represents this quaternion.

      Returns:
        A rotation matrix that represents this quaternion. }
    function ToMatrix: TMatrix4;

    { Implicitly converts a TQuaternion3D to a TQuaternion. }
    class operator Implicit(const A: TQuaternion3D): TQuaternion; inline;

    { Implicitly converts a TQuaternion to a TQuaternion3D. }
    class operator Implicit(const A: TQuaternion): TQuaternion3D; inline;

    { Adds to quaternions together.

      Returns:
        A + B }
    class operator Add(const A, B: TQuaternion): TQuaternion; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B, A.W * B) }
    class operator Multiply(const A: TQuaternion; const B: Single): TQuaternion; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A * B.X, A * B.Y, A * B.Z, A * B.W) }
    class operator Multiply(const A: Single; const B: TQuaternion): TQuaternion; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two quaternions.

      Returns:
        A * B }
    class operator Multiply(const A, B: TQuaternion): TQuaternion; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this is an identity quaternion.

      Returns:
        True if X, Y and Z are exactly 0.0 and W is exactly 1.0 }
    function IsIdentity: Boolean; overload; inline;

    { Whether this is an identity quaternion within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if this is an identity quaternion within the error margin. }
    function IsIdentity(const AErrorMargin: Single): Boolean; overload;

    { Calculates a normalized version of this quaternion.

      Returns:
        The normalized quaternion of of this vector (with a length of 1).

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this quaternion. To update this quaternion
      itself, use SetNormalized. }
    function Normalize: TQuaternion; inline;

    { Normalizes this quaternion to a length of 1.

      @bold(Note): The SIMD optimized versions of this method use an
      approximation, resulting in a very small error.

      @bold(Note): If you do not want to change this quaternion, but get a
      normalized version instead, then use Normalize. }
    procedure SetNormalized; inline;

    { Calculates a normalized version of this quaternion.

      Returns:
        The normalized version of of this quaternion (with a length of 1).

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use Normalize.

      @bold(Note): Does not change this quaternion. To update this quaternion
      itself, use SetNormalizedFast. }
    function NormalizeFast: TQuaternion; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Normalizes this quaternion to a length of 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this quaternion, but get a
      normalized version instead, then use NormalizeFast. }
    procedure SetNormalizedFast; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Creates a conjugate of the quaternion.

      Returns:
        The conjugate (eg. (-X, -Y, -Z, W))

      @bold(Note): Does not change this quaterion. To update this quaterion
      itself, use SetConjugate. }
    function Conjugate: TQuaternion;

    { Conjugate this quaternion.

      @bold(Note): If you do not want to change this quaternion, but get a
      conjugate version instead, then use Conjugate. }
    procedure SetConjugate; inline;

    { The euclidean length of this quaternion.

      @bold(Note): If you only want to compare lengths of quaternion, you should
      use LengthSquared instead, which is faster. }
    property Length: Single read GetLength;

    { The squared length of the quaternion.

      @bold(Note): This property is faster than Length because it avoids
      calculating a square root. It is useful for comparing lengths instead of
      calculating actual lengths. }
    property LengthSquared: Single read GetLengthSquared;
  public
    case Byte of
      { X, Y, Z and W components of the quaternion }
      0: (X, Y, Z, W: Single);

      { The four components of the quaternion. }
      1: (C: array [0..3] of Single);
  end;

type
  { Adds common constants and functionality to TQuaternion }
  _TQuaternionHelper = record helper for TQuaternion
  public const
    Identity: TQuaternion = (X: 0; Y: 0; Z: 0; W: 1);
  end;

type
  { A 2-dimensional vector that uses integer components instead of
    floating-point components.

    TIVector2 is compatible with TPoint in the Delphi RTL. You can typecast
    between these two types or implicitly convert from one to the other through
    assignment (eg. MyIVector := MyPoint). }
  TIVector2 = record
  {$REGION 'Internal Declarations'}
  private
    function GetComponent(const AIndex: Integer): Integer; inline;
    procedure SetComponent(const AIndex: Integer; const Value: Integer); inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the two elements (X and Y) to 0. }
    procedure Init; overload; inline;

    { Sets the two elements (X and Y) to A.

      Parameters:
        A: the value to set the two elements to. }
    procedure Init(const A: Integer); overload; inline;

    { Sets the two elements (X and Y) to A1 and A2 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to. }
    procedure Init(const A1, A2: Integer); overload; inline;

    { Implicitly converts a TPoint to a TIVector2. }
    class operator Implicit(const A: TPoint): TIVector2; inline;

    { Implicitly converts a TQuaternion to a TPoint. }
    class operator Implicit(const A: TIVector2): TPoint; inline;

    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other. }
    class operator Equal(const A, B: TIVector2): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TIVector2): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y)) }
    class operator Negative(const A: TIVector2): TIVector2; inline;

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B) }
    class operator Add(const A: TIVector2; const B: Integer): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y) }
    class operator Add(const A: Integer; const B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y) }
    class operator Add(const A, B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B) }
    class operator Subtract(const A: TIVector2; const B: Integer): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y) }
    class operator Subtract(const A: Integer; const B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y) }
    class operator Subtract(const A, B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B) }
    class operator Multiply(const A: TIVector2; const B: Integer): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y) }
    class operator Multiply(const A: Integer; const B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two vectors component-wise.

      Returns:
        (A.X * B.X, A.Y * B.Y) }
    class operator Multiply(const A, B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a vector by a scalar value.

      Returns:
        (A.X div B, A.Y div B) }
    class operator IntDivide(const A: TIVector2; const B: Integer): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a vector.

      Returns:
        (A div B.X, A div B.Y) }
    class operator IntDivide(const A: Integer; const B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two vectors component-wise.

      Returns:
        (A.X div B.X, A.Y div B.Y) }
    class operator IntDivide(const A, B: TIVector2): TIVector2; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this is a zero vector.

      Returns:
        True if X and Y are 0 }
    function IsZero: Boolean; inline;

    { Converts this vector to a floatint-point vector }
    function ToVector2: TVector2; inline;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0 or 1). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Integer read GetComponent write SetComponent; default;
  public
    case Byte of
      { X and Y components of the vector. Aliases for C[0] and C[1]. }
      0: (X, Y: Integer);

      { Red and Green components of the vector. Aliases for C[0] and C[1]. }
      1: (R, G: Integer);

      { S and T components of the vector. Aliases for C[0] and C[1]. }
      2: (S, T: Integer);

      { The two components of the vector. }
      3: (C: array [0..1] of Integer);
  end;
  PIVector2 = ^TIVector2;

type
  { Adds common constants of type TVector2 }
  _TVector2Helper = record helper for TVector2
  public const
    Zero : TVector2 = (X: 0; Y: 0);
    One  : TVector2 = (X: 1; Y: 1);
    UnitX: TVector2 = (X: 1; Y: 0);
    UnitY: TVector2 = (X: 0; Y: 1);
  public
    { Rounds the components of the vector towards negative infinity.

      Returns:
        The rounded vector. }
    function Floor: TIVector2; inline;

    { Rounds the components of the vector towards positive infinity.

      Returns:
        The rounded vector. }
    function Ceiling: TIVector2; inline;

    { Rounds the components of the vector towards 0.

      Returns:
        The rounded vector. }
    function Truncate: TIVector2; inline;

    { Rounds the components of the vector towards the nearest integer.

      Returns:
        The rounded vector.

      If a component is exactly between two integer values (if the fraction is
      0.5), then it is set to the even number }
    function Round: TIVector2; inline;
  end;

type
  { A 3-dimensional vector that uses integer components instead of
    floating-point components. }
  TIVector3 = record
  {$REGION 'Internal Declarations'}
  private
    function GetComponent(const AIndex: Integer): Integer; inline;
    procedure SetComponent(const AIndex: Integer; const Value: Integer); inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the three elements (X, Y and Z) to 0. }
    procedure Init; overload; inline;

    { Sets the three elements (X, Y and Z) to A.

      Parameters:
        A: the value to set the three elements to. }
    procedure Init(const A: Integer); overload; inline;

    { Sets the three elements (X, Y and Z) to A1, A2 and A3 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the value to set the third element to. }
    procedure Init(const A1, A2, A3: Integer); overload; inline;

    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
    class operator Equal(const A, B: TIVector3): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TIVector3): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y, -A.Z)) }
    class operator Negative(const A: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B, A.Z + B) }
    class operator Add(const A: TIVector3; const B: Integer): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y, A + B.Z) }
    class operator Add(const A: Integer; const B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y, A.Z + B.Z) }
    class operator Add(const A, B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B, A.Z - B) }
    class operator Subtract(const A: TIVector3; const B: Integer): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y, A - B.Z) }
    class operator Subtract(const A: Integer; const B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y, A.Z - B.Z) }
    class operator Subtract(const A, B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B) }
    class operator Multiply(const A: TIVector3; const B: Integer): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y, A * B.Z) }
    class operator Multiply(const A: Integer; const B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two vectors component-wise.

      Returns:
        (A.X * B.X, A.Y * B.Y, A.Z * B.Z) }
    class operator Multiply(const A, B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a vector by a scalar value.

      Returns:
        (A.X div B, A.Y div B, A.Z div B) }
    class operator IntDivide(const A: TIVector3; const B: Integer): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a vector.

      Returns:
        (A div B.X, A div B.Y, A div B.Z) }
    class operator IntDivide(const A: Integer; const B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two vectors component-wise.

      Returns:
        (A.X div B.X, A.Y div B.Y, A.Z div B.Z) }
    class operator IntDivide(const A, B: TIVector3): TIVector3; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this is a zero vector.

      Returns:
        True if X, Y and Z are 0 }
    function IsZero: Boolean; inline;

    { Converts this vector to a floatint-point vector }
    function ToVector3: TVector3; inline;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0-2). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Integer read GetComponent write SetComponent; default;
  public
    case Byte of
      { X, Y and Z components of the vector. Aliases for C[0], C[1] and C[2]. }
      0: (X, Y, Z: Integer);

      { Red, Green and Blue components of the vector. Aliases for C[0], C[1]
        and C[2]. }
      1: (R, G, B: Integer);

      { S, T and P components of the vector. Aliases for C[0], C[1] and C[2]. }
      2: (S, T, P: Integer);

      { The three components of the vector. }
      3: (C: array [0..2] of Integer);
  end;
  PIVector3 = ^TIVector3;

type
  { Adds common constants of type TVector3 }
  _TVector3Helper = record helper for TVector3
  public const
    Zero : TVector3 = (X: 0; Y: 0; Z: 0);
    One  : TVector3 = (X: 1; Y: 1; Z: 1);
    UnitX: TVector3 = (X: 1; Y: 0; Z: 0);
    UnitY: TVector3 = (X: 0; Y: 1; Z: 0);
    UnitZ: TVector3 = (X: 0; Y: 0; Z: 1);
  public
    { Rounds the components of the vector towards negative infinity.

      Returns:
        The rounded vector. }
    function Floor: TIVector3; inline;

    { Rounds the components of the vector towards positive infinity.

      Returns:
        The rounded vector. }
    function Ceiling: TIVector3; inline;

    { Rounds the components of the vector towards 0.

      Returns:
        The rounded vector. }
    function Truncate: TIVector3; inline;

    { Rounds the components of the vector towards the nearest integer.

      Returns:
        The rounded vector.

      If a component is exactly between two integer values (if the fraction is
      0.5), then it is set to the even number }
    function Round: TIVector3; inline;
  end;

type
  { A 4-dimensional vector that uses integer components instead of
    floating-point components. }
  TIVector4 = record
  {$REGION 'Internal Declarations'}
  private
    function GetComponent(const AIndex: Integer): Integer; inline;
    procedure SetComponent(const AIndex: Integer; const Value: Integer); inline;
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the four elements (X, Y, Z and W) to 0. }
    procedure Init; overload; inline;

    { Sets the four elements (X, Y, Z and W) to A.

      Parameters:
        A: the value to set the three elements to. }
    procedure Init(const A: Integer); overload; inline;

    { Sets the four elements (X, Y, Z and W) to A1, A2, A3 and A4 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the value to set the third element to.
        A4: the value to set the fourth element to. }
    procedure Init(const A1, A2, A3, A4: Integer); overload; inline;

    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other. }
    class operator Equal(const A, B: TIVector4): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TIVector4): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y, -A.Z, -A.W)) }
    class operator Negative(const A: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B, A.Z + B, A.W + B) }
    class operator Add(const A: TIVector4; const B: Integer): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y, A + B.Z, A + B.W) }
    class operator Add(const A: Integer; const B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y, A.Z + B.Z, A.W + B.W) }
    class operator Add(const A, B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B, A.Z - B, A.W - B) }
    class operator Subtract(const A: TIVector4; const B: Integer): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y, A - B.Z, A - B.W) }
    class operator Subtract(const A: Integer; const B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y, A.Z - B.Z, A.W - B.W) }
    class operator Subtract(const A, B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B, A.W * B) }
    class operator Multiply(const A: TIVector4; const B: Integer): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y, A * B.Z, A * B.W) }
    class operator Multiply(const A: Integer; const B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Multiplies two vectors component-wise.

      Returns:
        (A.X * B.X, A.Y * B.Y, A.Z * B.Z, A.W * B.W) }
    class operator Multiply(const A, B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a vector by a scalar value.

      Returns:
        (A.X div B, A.Y div B, A.Z div B, A.W div B) }
    class operator IntDivide(const A: TIVector4; const B: Integer): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides a scalar value by a vector.

      Returns:
        (A div B.X, A div B.Y, A div B.Z, A div B.W) }
    class operator IntDivide(const A: Integer; const B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Divides two vectors component-wise.

      Returns:
        (A.X div B.X, A.Y div B.Y, A.Z div B.Z, A.W div B.W) }
    class operator IntDivide(const A, B: TIVector4): TIVector4; {$IFDEF FM_INLINE}inline;{$ENDIF}

    { Whether this is a zero vector.

      Returns:
        True if X, Y, Z and W are 0 }
    function IsZero: Boolean; inline;

    { Converts this vector to a floatint-point vector }
    function ToVector4: TVector4; inline;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0-3). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Integer read GetComponent write SetComponent; default;
  public
    case Byte of
      { X, Y, Z and W components of the vector. Aliases for C[0], C[1], C[2]
        and C[3]. }
      0: (X, Y, Z, W: Integer);

      { Red, Green, Blue and Alpha components of the vector. Aliases for C[0],
        C[1], C[2] and C[3]. }
      1: (R, G, B, A: Integer);

      { S, T, P and Q components of the vector. Aliases for C[0], C[1], C[2] and
        C[3]. }
      2: (S, T, P, Q: Integer);

      { The four components of the vector. }
      3: (C: array [0..3] of Integer);
  end;
  PIVector4 = ^TIVector4;

type
  { Adds common constants of type TVector4 }
  _TVector4Helper = record helper for TVector4
  public const
    Zero : TVector4 = (X: 0; Y: 0; Z: 0; W: 0);
    One  : TVector4 = (X: 1; Y: 1; Z: 1; W: 1);
    UnitX: TVector4 = (X: 1; Y: 0; Z: 0; W: 0);
    UnitY: TVector4 = (X: 0; Y: 1; Z: 0; W: 0);
    UnitZ: TVector4 = (X: 0; Y: 0; Z: 1; W: 0);
    UnitW: TVector4 = (X: 0; Y: 0; Z: 0; W: 1);
  public
    { Rounds the components of the vector towards negative infinity.

      Returns:
        The rounded vector. }
    function Floor: TIVector4; inline;

    { Rounds the components of the vector towards positive infinity.

      Returns:
        The rounded vector. }
    function Ceiling: TIVector4; inline;

    { Rounds the components of the vector towards 0.

      Returns:
        The rounded vector. }
    function Truncate: TIVector4; inline;

    { Rounds the components of the vector towards the nearest integer.

      Returns:
        The rounded vector.

      If a component is exactly between two integer values (if the fraction is
      0.5), then it is set to the even number }
    function Round: TIVector4; inline;
  end;

{******************************************************}
{* Helper functions for creating vectors and matrices *}
{* Note that these are (much) less efficient than the *}
{* respective Init methods                            *}
{******************************************************}

{***** TVector2 *****}

{ Creates a 2D zero-vector.

  @bold(Note): it is more efficient to use TVector2.Init instead. }
function Vector2: TVector2; overload; inline;

{ Creates a 2D vector with the two elements (X and Y) set to A.

  Parameters:
    A: the value to set the two elements to.

  @bold(Note): it is more efficient to use TVector2.Init instead. }
function Vector2(const A: Single): TVector2; overload; inline;

{ Creates a 2D vector with the two elements (X and Y) set to A1 and A2
  respectively.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.

  @bold(Note): it is more efficient to use TVector2.Init instead. }
function Vector2(const A1, A2: Single): TVector2; overload; inline;

{ Creates a 2D vector using the first to elements (X and Y) of a 3D vector.

  Parameters:
    AVector: the source vector

  @bold(Note): it is more efficient to use TVector2.Init instead. }
function Vector2(const AVector: TVector3): TVector2; overload; inline;

{ Creates a 2D vector using the first two elements (X and Y) of a 4D vector.

  Parameters:
    AVector: the source vector

  @bold(Note): it is more efficient to use TVector2.Init instead. }
function Vector2(const AVector: TVector4): TVector2; overload; inline;

{***** TVector3 *****}

{ Creates a 3D zero-vector.

  @bold(Note): it is more efficient to use TVector3.Init instead. }
function Vector3: TVector3; overload;

{ Creates a 3D vector with the three elements (X, Y and Z) set to A.

  Parameters:
    A: the value to set the three elements to.

  @bold(Note): it is more efficient to use TVector3.Init instead. }
function Vector3(const A: Single): TVector3; overload;

{ Creates a 3D vector with the three elements (X, Y and Z) set to A1, A2 and A3
  respectively.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.
    A3: the value to set the third element to.

  @bold(Note): it is more efficient to use TVector3.Init instead. }
function Vector3(const A1, A2, A3: Single): TVector3; overload;

{ Creates a 3D vector with the first two elements from a 2D vector, and the
  third element from a scalar.

  Parameters:
    A1: the vector to use for the first two elements.
    A2: the value to set the third element to.

  @bold(Note): it is more efficient to use TVector3.Init instead. }
function Vector3(const A1: TVector2; const A2: Single): TVector3; overload;

{ Creates a 3D vector with the first element from a scaler, and the last two
  elements from a 2D vector.

  Parameters:
    A1: the value to set the first element to.
    A2: the vector to use for the last two elements.

  @bold(Note): it is more efficient to use TVector3.Init instead. }
function Vector3(const A1: Single; const A2: TVector2): TVector3; overload;

{ Creates a 3D vector using the first three elements (X, Y and Z) of a 4D vector.

  Parameters:
    AVector: the source vector

  @bold(Note): it is more efficient to use TVector3.Init instead. }
function Vector3(const AVector: TVector4): TVector3; overload;

{***** TVector4 *****}

{ Creates a 4D zero-vector.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4: TVector4; overload;

{ Creates a 4D vector with the four elements (X, Y, Z and W) set to A.

  Parameters:
    A: the value to set the four elements to.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A: Single): TVector4; overload;

{ Creates a 4D vector with the four elements (X, Y, Z and W) set to A1, A2, A3
  and A4 respectively.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.
    A3: the value to set the third element to.
    A4: the value to set the fourth element to.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1, A2, A3, A4: Single): TVector4; overload;

{ Creates a 4D vector with the first two elements from a 2D vector, and the last
  two elements from two scalars.

  Parameters:
    A1: the vector to use for the first two elements.
    A2: the value to set the third element to.
    A3: the value to set the fourth element to.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1: TVector2; const A2, A3: Single): TVector4; overload;

{ Creates a 4D vector with the first and last elements from two scalars, and the
  middle two elements from a 2D vector.

  Parameters:
    A1: the value to set the first element to.
    A2: the vector to use for the second and third elements.
    A3: the value to set the fourth element to.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1: Single; const A2: TVector2; const A3: Single): TVector4; overload;

{ Creates a 4D vector with the first two elements from two scalars and the last
  two elements from a 2D vector.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.
    A3: the vector to use for the last two elements.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1, A2: Single; const A3: TVector2): TVector4; overload;

{ Creates a 4D vector with the first two elements and last two elements from two
  2D vectors.

  Parameters:
    A1: the vector to use for the first two elements.
    A2: the vector to use for the last two elements.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1, A2: TVector2): TVector4; overload;

{ Creates a 4D vector with the first three elements from a 3D vector, and the
  fourth element from a scalar.

  Parameters:
    A1: the vector to use for the first three elements.
    A2: the value to set the fourth element to.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1: TVector3; const A2: Single): TVector4; overload;

{ Creates a 4D vector with the first element from a scaler, and the last three
  elements from a 3D vector.

  Parameters:
    A1: the value to set the first element to.
    A2: the vector to use for the last three elements.

  @bold(Note): it is more efficient to use TVector4.Init instead. }
function Vector4(const A1: Single; const A2: TVector3): TVector4; overload;

{***** TQuaternion *****}

{ Creates an identity quaternion (with X, Y and Z set to 0 and W set to 1).

  @bold(Note): it is more efficient to use TQuaternion.Init instead. }
function Quaternion: TQuaternion; overload;

{ Creates a quaternion with the given components.

  Parameters:
    AX: the X-component.
    AY: the Y-component.
    AZ: the Z-component.
    AW: the W-component.

  @bold(Note): it is more efficient to use TQuaternion.Init instead. }
function Quaternion(const AX, AY, AZ, AW: Single): TQuaternion; overload;

{ Creates a quaternion from the given axis vector and the angle around that
  axis in radians.

  Parameters:
    AAxis: The axis.
    AAngleRadians: The angle in radians.

  @bold(Note): it is more efficient to use TQuaternion.Init instead. }
function Quaternion(const AAxis: TVector3; const AAngleRadians: Single): TQuaternion; overload;

{***** TMatrix2 *****}

{ Creates a 2x2 identity matrix

  @bold(Note): it is more efficient to use TMatrix2.Init instead. }
function Matrix2: TMatrix2; overload;

{ Creates a 2x2 matrix fill with zeros and sets the diagonal.

  Parameters:
    ADiagonal: the value to use for the diagonal. Use 1 for an identity matrix.

  @bold(Note): it is more efficient to use TMatrix2.Init instead. }
function Matrix2(const ADiagonal: Single): TMatrix2; overload;

{ Creates a 2x2 matrix using two row vectors.

  Parameters:
    ARow0: the first row of the matrix.
    ARow1: the second row of the matrix.

  @bold(Note): it is more efficient to use TMatrix2.Init instead. }
function Matrix2(const ARow0, ARow1: TVector2): TMatrix2; overload;

{ Creates a 2x2 matrix with explicit values.

  Parameters:
    A11-A12: the values of the matrix elements, in row-major order.

  @bold(Note): it is more efficient to use TMatrix2.Init instead. }
function Matrix2(const A11, A12, A21, A22: Single): TMatrix2; overload;

{ Creates a 2x2 using the top-left corner of a 3x3 matrix.
  The remaining values of the source matrix are not used.

  Parameters:
    AMatrix: the source 3x3 matrix.

  @bold(Note): it is more efficient to use TMatrix2.Init instead. }
function Matrix2(const AMatrix: TMatrix3): TMatrix2; overload;

{ Creates a 2x2 using the top-left corner of a 4x4 matrix.
  The remaining values of the source matrix are not used.

  Parameters:
    AMatrix: the source 4x4  matrix.

  @bold(Note): it is more efficient to use TMatrix2.Init instead. }
function Matrix2(const AMatrix: TMatrix4): TMatrix2; overload;

{***** TMatrix3 *****}

{ Creates a 3x3 identity matrix

  @bold(Note): it is more efficient to use TMatrix3.Init instead. }
function Matrix3: TMatrix3; overload;

{ Creates a 3x3 matrix fill with zeros and sets the diagonal.

  Parameters:
    ADiagonal: the value to use for the diagonal. Use 1 for an identity matrix.

  @bold(Note): it is more efficient to use TMatrix3.Init instead. }
function Matrix3(const ADiagonal: Single): TMatrix3; overload;

{ Creates a 3x3 matrix using three row vectors.

  Parameters:
    ARow0: the first row of the matrix.
    ARow1: the second row of the matrix.
    ARow2: the third row of the matrix.

  @bold(Note): it is more efficient to use TMatrix3.Init instead. }
function Matrix3(const ARow0, ARow1, ARow2: TVector3): TMatrix3; overload;

{ Creates a 3x3 matrix with explicit values.

  Parameters:
    A11-A33: the values of the matrix elements, in row-major order.

  @bold(Note): it is more efficient to use TMatrix3.Init instead. }
function Matrix3(const A11, A12, A13, A21, A22, A23, A31, A32, A33: Single): TMatrix3; overload;

{ Creates a 3x3 matrix by copying a 2x2 matrix to the top-left corner of the 3x3
  matrix, and setting the remaining elements according to an identity matrix.

  Parameters:
    AMatrix: the source 2x2 matrix.

  @bold(Note): it is more efficient to use TMatrix3.Init instead. }
function Matrix3(const AMatrix: TMatrix2): TMatrix3; overload;

{ Creates a 3x3 using the top-left corner of a 4x4 matrix.
  The remaining values of the source matrix are not used.

  Parameters:
    AMatrix: the 4x4 source matrix.

  @bold(Note): it is more efficient to use TMatrix3.Init instead. }
function Matrix3(const AMatrix: TMatrix4): TMatrix3; overload;

{***** TMatrix4 *****}

{ Creates a 4x4 identity matrix

  @bold(Note): it is more efficient to use TMatrix4.Init instead. }
function Matrix4: TMatrix4; overload;

{ Creates a 4x4 matrix fill with zeros and sets the diagonal.

  Parameters:
    ADiagonal: the value to use for the diagonal. Use 1 for an identity matrix.

  @bold(Note): it is more efficient to use TMatrix4.Init instead. }
function Matrix4(const ADiagonal: Single): TMatrix4; overload;

{ Creates a 4x4 matrix using four row vectors.

  Parameters:
    ARow0: the first row of the matrix.
    ARow1: the second row of the matrix.
    ARow2: the third row of the matrix.
    ARow3: the fourth row of the matrix.

  @bold(Note): it is more efficient to use TMatrix4.Init instead. }
function Matrix4(const ARow0, ARow1, ARow2, ARow3: TVector4): TMatrix4; overload;

{ Creates a 4x4 matrix with explicit values.

  Parameters:
    A11-A44: the values of the matrix elements, in row-major order.

  @bold(Note): it is more efficient to use TMatrix4.Init instead. }
function Matrix4(const A11, A12, A13, A14, A21, A22, A23, A24, A31, A32, A33,
  A34, A41, A42, A43, A44: Single): TMatrix4; overload;

{ Creates a 4x4 matrix by copying a 2x2 matrix to the top-left corner of the 4x4
  matrix, and setting the remaining elements according to an identity matrix.

  Parameters:
    AMatrix: the source 2x2 matrix.

  @bold(Note): it is more efficient to use TMatrix4.Init instead. }
function Matrix4(const AMatrix: TMatrix2): TMatrix4; overload;

{ Creates a 4x4 matrix by copying a 3x3 matrix to the top-left corner of the 4x4
  matrix, and setting the remaining elements according to an identity matrix.

  Parameters:
    AMatrix: the source 3x3 matrix.

  @bold(Note): it is more efficient to use TMatrix4.Init instead. }
function Matrix4(const AMatrix: TMatrix3): TMatrix4; overload;

{***** TIVector2 *****}

{ Creates a 2D zero-vector.

  @bold(Note): it is more efficient to use TIVector2.Init instead. }
function IVector2: TIVector2; overload; inline;

{ Creates a 2D vector with the two elements (X and Y) set to A.

  Parameters:
    A: the value to set the two elements to.

  @bold(Note): it is more efficient to use TIVector2.Init instead. }
function IVector2(const A: Integer): TIVector2; overload; inline;

{ Creates a 2D vector with the two elements (X and Y) set to A1 and A2
  respectively.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.

  @bold(Note): it is more efficient to use TIVector2.Init instead. }
function IVector2(const A1, A2: Integer): TIVector2; overload; inline;

{***** TIVector3 *****}

{ Creates a 3D zero-vector.

  @bold(Note): it is more efficient to use TIVector3.Init instead. }
function IVector3: TIVector3; overload;

{ Creates a 3D vector with the three elements (X, Y and Z) set to A.

  Parameters:
    A: the value to set the three elements to.

  @bold(Note): it is more efficient to use TIVector3.Init instead. }
function IVector3(const A: Integer): TIVector3; overload;

{ Creates a 3D vector with the three elements (X, Y and Z) set to A1, A2 and A3
  respectively.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.
    A3: the value to set the third element to.

  @bold(Note): it is more efficient to use TIVector3.Init instead. }
function IVector3(const A1, A2, A3: Integer): TIVector3; overload;

{***** TIVector4 *****}

{ Creates a 4D zero-vector.

  @bold(Note): it is more efficient to use TIVector4.Init instead. }
function IVector4: TIVector4; overload;

{ Creates a 4D vector with the four elements (X, Y, Z and W) set to A.

  Parameters:
    A: the value to set the four elements to.

  @bold(Note): it is more efficient to use TIVector4.Init instead. }
function IVector4(const A: Integer): TIVector4; overload;

{ Creates a 4D vector with the four elements (X, Y, Z and W) set to A1, A2, A3
  and A4 respectively.

  Parameters:
    A1: the value to set the first element to.
    A2: the value to set the second element to.
    A3: the value to set the third element to.
    A4: the value to set the fourth element to.

  @bold(Note): it is more efficient to use TIVector4.Init instead. }
function IVector4(const A1, A2, A3, A4: Integer): TIVector4; overload;

{******************************************************}
{* Angle and Trigonometry Functions                   *}
{******************************************************}

{ Converts degrees to radians.

  Parameters:
    ADegrees: number of degrees.

  Returns:
    ADegrees converted to radians. }
function Radians(const ADegrees: Single): Single; overload; inline;
function Radians(const ADegrees: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Radians(const ADegrees: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Radians(const ADegrees: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Converts radians to degrees.

  Parameters:
    ARadians: number of radians.

  Returns:
    ARadians converted to degrees. }
function Degrees(const ARadians: Single): Single; overload; inline;
function Degrees(const ARadians: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Degrees(const ARadians: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Degrees(const ARadians: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the sine of an angle.

  Parameters:
    ARadians: the angle in radians.

  Returns:
    The sine of the given angle.

  @bold(Note): You probably want to use FastSin instead, which is much faster
  but still very accurate to about +/-4000 radians (or +/-230,000 degrees). }
function Sin(const ARadians: Single): Single; overload; inline;
function Sin(const ARadians: TVector2): TVector2; overload; inline;
function Sin(const ARadians: TVector3): TVector3; overload; inline;
function Sin(const ARadians: TVector4): TVector4; overload; inline;

{ Calculates the cosine of an angle.

  Parameters:
    ARadians: the angle in radians.

  Returns:
    The cosine of the given angle.

  @bold(Note): You probably want to use FastCos instead, which is much faster
  but still very accurate to about +/-4000 radians (or +/-230,000 degrees). }
function Cos(const ARadians: Single): Single; overload; inline;
function Cos(const ARadians: TVector2): TVector2; overload; inline;
function Cos(const ARadians: TVector3): TVector3; overload; inline;
function Cos(const ARadians: TVector4): TVector4; overload; inline;

{ Calculates the sine and cosine of an angle. This is faster than calling Sin
  and Cos separately.

  Parameters:
    ARadians: the angle in radians.
    ASin: is set to the sine of the angle.
    ACos: is set to the cosine of the angle.

  @bold(Note): You probably want to use FastSinCos instead, which is much faster
  but still very accurate to about +/-4000 radians (or +/-230,000 degrees). }
procedure SinCos(const ARadians: Single; out ASin, ACos: Single); overload;
procedure SinCos(const ARadians: TVector2; out ASin, ACos: TVector2); overload;
procedure SinCos(const ARadians: TVector3; out ASin, ACos: TVector3); overload;
procedure SinCos(const ARadians: TVector4; out ASin, ACos: TVector4); overload;

{ Calculates the tangent of an angle.

  Parameters:
    ARadians: the angle in radians.

  Returns:
    The tangent of the given angle.

  @bold(Note): You probably want to use FastTan instead, which is much faster
  but still very accurate to about +/-4000 radians (or +/-230,000 degrees). }
function Tan(const ARadians: Single): Single; overload; inline;
function Tan(const ARadians: TVector2): TVector2; overload; inline;
function Tan(const ARadians: TVector3): TVector3; overload; inline;
function Tan(const ARadians: TVector4): TVector4; overload; inline;

{ Calculates the angle whose sine is A.

  Parameters:
    A: the sine whose angle to calculate. Results are undefined if (A < -1) or
      (A > 1).

  Returns:
    The angle in radians, in the range [-Pi/2..Pi/2] }
function ArcSin(const A: Single): Single; overload; inline;
function ArcSin(const A: TVector2): TVector2; overload; inline;
function ArcSin(const A: TVector3): TVector3; overload; inline;
function ArcSin(const A: TVector4): TVector4; overload; inline;

{ Calculates the angle whose cosine is A.

  Parameters:
    A: the cosine whose angle to calculate. Results are undefined if (A < -1) or
      (A > 1).

  Returns:
    The angle in radians, in the range [0..Pi] }
function ArcCos(const A: Single): Single; overload; inline;
function ArcCos(const A: TVector2): TVector2; overload; inline;
function ArcCos(const A: TVector3): TVector3; overload; inline;
function ArcCos(const A: TVector4): TVector4; overload; inline;

{ Calculates the angle whose tangent is A.

  Parameters:
    A: the tangent whose angle to calculate.

  Returns:
    The angle in radians, in the range [-Pi/2..Pi/2] }
function ArcTan(const A: Single): Single; overload; inline;
function ArcTan(const A: TVector2): TVector2; overload; inline;
function ArcTan(const A: TVector3): TVector3; overload; inline;
function ArcTan(const A: TVector4): TVector4; overload; inline;

{ Calculates the principal value of the arctangent of Y/X, expressed in radians.

  Parameters:
    Y: proportion of the Y-coordinate.
    X: proportion of the X-coordinate.

  Returns:
    The angle in radians, in the range [-Pi..Pi] }
function ArcTan2(const Y, X: Single): Single; overload; inline;
function ArcTan2(const Y, X: TVector2): TVector2; overload; inline;
function ArcTan2(const Y, X: TVector3): TVector3; overload; inline;
function ArcTan2(const Y, X: TVector4): TVector4; overload; inline;

{ Calculates a hyperbolic sine.

  Parameters:
    A: the value.

  Returns:
    The hyperbolic sine of A. }
function Sinh(const A: Single): Single; overload; inline;
function Sinh(const A: TVector2): TVector2; overload; inline;
function Sinh(const A: TVector3): TVector3; overload; inline;
function Sinh(const A: TVector4): TVector4; overload; inline;

{ Calculates a hyperbolic cosine.

  Parameters:
    A: the value.

  Returns:
    The hyperbolic cosine of A. }
function Cosh(const A: Single): Single; overload; inline;
function Cosh(const A: TVector2): TVector2; overload; inline;
function Cosh(const A: TVector3): TVector3; overload; inline;
function Cosh(const A: TVector4): TVector4; overload; inline;

{ Calculates a hyperbolic tangent.

  Parameters:
    A: the value.

  Returns:
    The hyperbolic tangent of A. }
function Tanh(const A: Single): Single; overload; inline;
function Tanh(const A: TVector2): TVector2; overload; inline;
function Tanh(const A: TVector3): TVector3; overload; inline;
function Tanh(const A: TVector4): TVector4; overload; inline;

{ Calculates an inverse hyperbolic sine.

  Parameters:
    A: the value.

  Returns:
    The inverse hyperbolic sine of A. }
function ArcSinh(const A: Single): Single; overload; inline;
function ArcSinh(const A: TVector2): TVector2; overload; inline;
function ArcSinh(const A: TVector3): TVector3; overload; inline;
function ArcSinh(const A: TVector4): TVector4; overload; inline;

{ Calculates an inverse hyperbolic cosine.

  Parameters:
    A: the value.

  Returns:
    The inverse hyperbolic cosine of A. }
function ArcCosh(const A: Single): Single; overload; inline;
function ArcCosh(const A: TVector2): TVector2; overload; inline;
function ArcCosh(const A: TVector3): TVector3; overload; inline;
function ArcCosh(const A: TVector4): TVector4; overload; inline;

{ Calculates an inverse hyperbolic tangent.

  Parameters:
    A: the value.

  Returns:
    The inverse hyperbolic tangent of A. }
function ArcTanh(const A: Single): Single; overload; inline;
function ArcTanh(const A: TVector2): TVector2; overload; inline;
function ArcTanh(const A: TVector3): TVector3; overload; inline;
function ArcTanh(const A: TVector4): TVector4; overload; inline;

{******************************************************}
{* Exponential Functions                              *}
{******************************************************}

{ Calculates ABase raised to the AExponent power.

  Parameters:
    ABase: the base value. Must be >= 0.
    AExponent: the exponent value.

  Returns:
    ABase raised to the AExponent power. Results are undefined if both ABase=0
    and AExponent<=0.

  @bold(Note): Consider using FastPower instead, which is much faster, but at a
  maximum relative error of about 0.2%. }
function Power(const ABase, AExponent: Single): Single; overload; inline;
function Power(const ABase, AExponent: TVector2): TVector2; overload; inline;
function Power(const ABase, AExponent: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Power(const ABase, AExponent: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a natural exponentiation (that is, e raised to a given power).

  Parameters:
    A: the value

  Returns:
    The natural exponentation of A (e raised to the power of A).

  @bold(Note): Consider using FastExp instead, which is much faster, but at a
  maximum absolute error of about 0.00001. }
function Exp(const A: Single): Single; overload; inline;
function Exp(const A: TVector2): TVector2; overload; inline;
function Exp(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Exp(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a natural logarithm.

  Parameters:
    A: the value. Results are undefined if A <= 0.

  Returns:
    The natural logarithm of A (that is, the value B so that A equals e raised
    to the power of B)

  @bold(Note): Consider using FastLn instead, which is much faster, but at a
  maximum absolute error of about 0.00003. }
function Ln(const A: Single): Single; overload; inline;
function Ln(const A: TVector2): TVector2; overload; inline;
function Ln(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Ln(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates 2 raised to a power.

  Parameters:
    A: the value

  Returns:
    2 raised to the power of A.

  @bold(Note): Consider using FastExp2 instead, which is much faster, but less
  accurate. }
function Exp2(const A: Single): Single; overload; inline;
function Exp2(const A: TVector2): TVector2; overload; inline;
function Exp2(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Exp2(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a base 2 logarithm.

  Parameters:
    A: the value. Results are undefined if A <= 0.

  Returns:
    The base 2 logarithm of A (that is, the value B so that A equals 2 raised
    to the power of B)

  @bold(Note): Consider using FastLog2 instead, which is much faster, but at a
  maximum absolute error of about 0.0002. }
function Log2(const A: Single): Single; overload; inline;
function Log2(const A: TVector2): TVector2; overload; inline;
function Log2(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Log2(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a square root.

  Parameters:
    A: the value. Results are undefined if A < 0.

  Returns:
    The square root of A.

  @bold(Note): If you plan to divide a certain value by the returned square
  root, then consider using InverseSqrt instead. That version is usually faster
  to calculate and you can replace an expensive division with a faster
  multiplication.  }
function Sqrt(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Sqrt(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Sqrt(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Sqrt(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates an inverse square root.

  Parameters:
    A: the value. Results are undefined if A <= 0.

  Returns:
    1/Sqrt(A)

  @bold(Note): You can use this function if you need to divide a given value by
  a square root. The inverse square root is usually faster to calculate, and you
  can replace an expensive division with a faster multiplication.

  @bold(Note): The SIMD optimized versions of these functions use an
  approximation, resulting in a very small error. }
function InverseSqrt(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function InverseSqrt(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function InverseSqrt(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function InverseSqrt(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{******************************************************}
{* Fast Approximate Functions                         *}
{******************************************************}

{ These functions are usually (much) faster than their counterparts, but are
  less accurate. For gaming and animation, this loss in accuracy is perfectly
  acceptible and outweighed by the increase in speed.

  These functions use approximations as described in:
    http://gallium.inria.fr/blog/fast-vectorizable-math-approx/
    http://www.machinedlearnings.com/2011/06/fast-approximate-logarithm-exponential.html
    http://gruntthepeon.free.fr/ssemath/ }

{ Calculates the sine of an angle.

  Parameters:
    ARadians: the angle in radians.

  Returns:
    The (approximate) sine of the given angle.

  @bold(Note): This function provides excellent precisions when ARadians is
  about the range [-4000..4000] (about +/-230,000 degrees) }
function FastSin(const ARadians: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastSin(const ARadians: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastSin(const ARadians: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastSin(const ARadians: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the cosine of an angle.

  Parameters:
    ARadians: the angle in radians.

  Returns:
    The (approximate) cosine of the given angle.

  @bold(Note): This function provides excellent precisions when ARadians is
  about the range [-4000..4000] (about +/-230,000 degrees) }
function FastCos(const ARadians: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastCos(const ARadians: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastCos(const ARadians: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastCos(const ARadians: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the sine and cosine of an angle. This is faster than calling
  FastSin and FastCos separately.

  Parameters:
    ARadians: the angle in radians.
    ASin: is set to the (approximate) sine of the angle.
    ACos: is set to the (approximate) cosine of the angle.

  @bold(Note): This function provides excellent precisions when ARadians is
  about the range [-4000..4000] (about +/-230,000 degrees) }
procedure FastSinCos(const ARadians: Single; out ASin, ACos: Single); overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
procedure FastSinCos(const ARadians: TVector2; out ASin, ACos: TVector2); overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
procedure FastSinCos(const ARadians: TVector3; out ASin, ACos: TVector3); overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
procedure FastSinCos(const ARadians: TVector4; out ASin, ACos: TVector4); overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the tangent of an angle.

  Parameters:
    ARadians: the angle in radians.

  Returns:
    The (approximate) tangent of the given angle.

  @bold(Note): This function provides excellent precisions when ARadians is
  about the range [-4000..4000] (about +/-230,000 degrees) }
function FastTan(const ARadians: Single): Single; overload;
function FastTan(const ARadians: TVector2): TVector2; overload;
function FastTan(const ARadians: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastTan(const ARadians: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the principal value of the arctangent of Y/X, expressed in radians.

  Parameters:
    Y: proportion of the Y-coordinate.
    X: proportion of the X-coordinate.

  Returns:
    The (approximate) angle in radians, in the range [-Pi..Pi] }
function FastArcTan2(const Y, X: Single): Single; overload;
function FastArcTan2(const Y, X: TVector2): TVector2; overload;
function FastArcTan2(const Y, X: TVector3): TVector3; overload;
function FastArcTan2(const Y, X: TVector4): TVector4; overload;

{ Calculates ABase raised to the AExponent power.

  Parameters:
    ABase: the base value. Must be >= 0.
    AExponent: the exponent value.

  Returns:
    (Approximate) ABase raised to the AExponent power. Results are undefined if
    both ABase=0 and AExponent<=0.

  @bold(Note): The error depends on the magnitude of the result. The relative
  error is at most about 0.2% }
function FastPower(const ABase, AExponent: Single): Single; overload; inline;
function FastPower(const ABase, AExponent: TVector2): TVector2; overload; inline;
function FastPower(const ABase, AExponent: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastPower(const ABase, AExponent: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a natural exponentiation (that is, e raised to a given power).

  Parameters:
    A: the value

  Returns:
    The (approximate) natural exponentation of A (e raised to the power of A)

  @bold(Note): Maximum absolute error is about 0.00001 }
function FastExp(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastExp(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastExp(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastExp(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a natural logarithm.

  Parameters:
    A: the value. Results are undefined if A <= 0.

  Returns:
    The (approximate) natural logarithm of A (that is, the value B so that A
    equals e raised to the power of B)

  @bold(Note): Maximum absolute error is about 0.00003. }
function FastLn(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastLn(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastLn(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastLn(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a base 2 logarithm.

  Parameters:
    A: the value. Results are undefined if A <= 0.

  Returns:
    The (approximate) base 2 logarithm of A (that is, the value B so that A
    equals 2 raised to the power of B)

  @bold(Note): Maximum absolute error is about 0.0002 }
function FastLog2(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastLog2(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastLog2(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastLog2(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates 2 raised to a power.

  Parameters:
    A: the value. Must be in the range [-127..127] for valid results.

  Returns:
    (Approximate) 2 raised to the power of A.

  @bold(Note): If A needs to be outside of the range [-127..127], then use Exp2
  instead. }
function FastExp2(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastExp2(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastExp2(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FastExp2(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{******************************************************}
{* Common Functions                                   *}
{******************************************************}

{ Calculates an absolute value.

  Parameters:
    A: the value.

  Returns:
    A if A >= 0, otherwise -A. }
function Abs(const A: Single): Single; overload; inline;
function Abs(const A: TVector2): TVector2; overload; inline;
function Abs(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Abs(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the sign of a value.

  Parameters:
    A: the value.

  Returns:
    -1.0 if A < 0, 0.0 if A = 0, or 1.0 if A > 0. }
function Sign(const A: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Sign(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Sign(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Sign(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Rounds a value towards negative infinity.

  Parameters:
    A: the value.

  Returns:
    A value equal to the nearest integer that is less than or equal to A. }
function Floor(const A: Single): Integer; overload; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}
function Floor(const A: TVector2): TIVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Floor(const A: TVector3): TIVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Floor(const A: TVector4): TIVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Rounds a value towards 0.

  Parameters:
    A: the value.

  Returns:
    The value A rounded towards 0. That is, with its fractional part removed. }
function Trunc(const A: Single): Integer; overload; inline;
function Trunc(const A: TVector2): TIVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Trunc(const A: TVector3): TIVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Trunc(const A: TVector4): TIVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Rounds a value towards its nearest integer.

  Parameters:
    A: the value.

  Returns:
    The integer value closest to A. If A is exactly between two integer values
    (if the fraction is 0.5), then the result is the even number. }
function Round(const A: Single): Integer; overload; inline;
function Round(const A: TVector2): TIVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Round(const A: TVector3): TIVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Round(const A: TVector4): TIVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Rounds a value towards positive infinity.

  Parameters:
    A: the value.

  Returns:
    A value equal to the nearest integer that is greater than or equal to A. }
function Ceil(const A: Single): Integer; overload; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}
function Ceil(const A: TVector2): TIVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Ceil(const A: TVector3): TIVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Ceil(const A: TVector4): TIVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Returns the fractional part of a number.

  Parameters:
    A: the value.

  Returns:
    The fractional part of A, calculated as to A - Trunc(A) }
function Frac(const A: Single): Single; overload; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}
function Frac(const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Frac(const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Frac(const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Modulus. Calculates the remainder of a floating-point division.

  Parameters:
    A: the dividend.
    B: the divisor.

  Returns:
    The remainder of A / B, calculated as A - B * Trunc(A / B)

  @bold(Note): When used with vectors, B can be a scalar or a vector. }
function FMod(const A, B: Single): Single; overload; inline;
function FMod(const A: TVector2; const B: Single): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FMod(const A, B: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FMod(const A: TVector3; const B: Single): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FMod(const A, B: TVector3): TVector3; overload; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}
function FMod(const A: TVector4; const B: Single): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FMod(const A, B: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Splits a floating-point value into its integer and fractional parts.

  Parameters:
    A: the value to split.
    B: is set to the integer part of A

  Returns:
    The fractional part of A.

  @bold(Note): Both the return value and output parameter B will have the same
  sign as A. }
function ModF(const A: Single; out B: Integer): Single; overload; {$IF Defined(FM_INLINE) or Defined(CPUX64)}inline;{$ENDIF}
function ModF(const A: TVector2; out B: TIVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function ModF(const A: TVector3; out B: TIVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function ModF(const A: TVector4; out B: TIVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the minimum of two values.

  Parameters:
    A: the first value.
    B: the second value.

  Returns:
    The minimum of A and B.

  @bold(Note): When used with vectors, B can be a scalar or a vector. }
function Min(const A, B: Single): Single; overload; inline;
function Min(const A: TVector2; const B: Single): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Min(const A, B: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Min(const A: TVector3; const B: Single): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Min(const A, B: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Min(const A: TVector4; const B: Single): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Min(const A, B: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates the maximum of two values.

  Parameters:
    A: the first value.
    B: the second value.

  Returns:
    The maximum of A and B.

  @bold(Note): When used with vectors, B can be a scalar or a vector. }
function Max(const A, B: Single): Single; overload; inline;
function Max(const A: TVector2; const B: Single): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Max(const A, B: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Max(const A: TVector3; const B: Single): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Max(const A, B: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Max(const A: TVector4; const B: Single): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Max(const A, B: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Clamps a given value into a range.

  Parameters:
    A: the value to clamp.
    AMin: the minimum value of the range.
    AMax: the maximum value of the range. Must be >= AMin.

  Returns:
    A clamped to the range [AMin..AMax]. Results are undefined if AMin > AMax.
    No error checking is performed for this situation.

  @bold(Note): When used with vectors, AMin and AMax can be scalars or vectors. }
function EnsureRange(const A, AMin, AMax: Single): Single; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function EnsureRange(const A: TVector2; const AMin, AMax: Single): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function EnsureRange(const A, AMin, AMax: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function EnsureRange(const A: TVector3; const AMin, AMax: Single): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function EnsureRange(const A, AMin, AMax: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function EnsureRange(const A: TVector4; const AMin, AMax: Single): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function EnsureRange(const A, AMin, AMax: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Calculates a linear blend between two values, using on a progress value.

  Parameters:
    A: the first value.
    B: the second value.
    T: the progress value, usually between 0.0 and 1.0.

  Returns:
    A value interpolated between A and B, as controlled by T. If T=0, then A
    is returned. If T=1 then B is returned. For values in between 0 and 1, the
    result is linearly interpolated with the formula "A * (1 - T) + (B * T)".

  @bold(Note): When used with vectors, T can be a scalar or a vector. }
function Mix(const A, B, T: Single): Single; overload; inline;
function Mix(const A, B: TVector2; const T: Single): TVector2; overload; inline;
function Mix(const A, B, T: TVector2): TVector2; overload; inline;
function Mix(const A, B: TVector3; const T: Single): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Mix(const A, B, T: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Mix(const A, B: TVector4; const T: Single): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Mix(const A, B, T: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Step function.

  Parameters:
    AEdge: the edge value.
    A: the value to check.

  Returns:
    0.0 if A < AEdge. Otherwise it returns 1.0.

  @bold(Note): When used with vectors, AEdge can be a scalar or a vector. }
function Step(const AEdge, A: Single): Single; overload; inline;
function Step(const AEdge: Single; const A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Step(const AEdge, A: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Step(const AEdge: Single; const A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Step(const AEdge, A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Step(const AEdge: Single; const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function Step(const AEdge, A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Performs smooth Hermite interpolation between 0 and 1.

  Parameters:
    AEdge0: the left value of the edge.
    AEdge1: the right value of the edge.
    A: the value used to control the interpolation.

  Returns:
    0.0 if A <= AEdge0 and 1.0 if A >= AEdge1. Otherwise it performs a smooth
    Hermite interpolation between 0 and 1, based on the position of A between
    AEdge0 and AEdge1. This is useful in cases where you would want a threshold
    function with a smooth transition (as compared to the Step function). The
    graph would show a curve increasing slowly from 0.0, the speeding up towards
    0.5 and finally slowing down towards 1.0.

  @bold(Note): The interpolation is calculated using the algorithm:

      <source>
      T := EnsureRange((A - AEdge0) / (AEdge1 - AEdge0), 0, 1);
      Result := T * T * (3 - 2 * T);
      </source>

    Results are undefined if AEdge0 >= AEdge1. When used with vectors, AEdge0
    and AEdge1 can be scalars or vectors. }
function SmoothStep(const AEdge0, AEdge1, A: Single): Single; overload; inline;
function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector2): TVector2; overload; inline;
function SmoothStep(const AEdge0, AEdge1, A: TVector2): TVector2; overload; inline;
function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector3): TVector3; overload; inline;
function SmoothStep(const AEdge0, AEdge1, A: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function SmoothStep(const AEdge0, AEdge1, A: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{ Fused Multiply and Add (if available).

  Parameters:
    A: the first value.
    B: the second value.
    C: the third value.

  Returns:
    (A * B) + C

  @bold(Note): On ARM platforms (iOS and Android), the calculation is performed
  with as a single (fused) operation. This provides better precision (because it
  skips the intermediate rounding).

  On other platforms, this is not really a fused operation, but just a separate
  muliplication and addition. }
function FMA(const A, B, C: Single): Single; overload; inline;
function FMA(const A, B, C: TVector2): TVector2; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FMA(const A, B, C: TVector3): TVector3; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}
function FMA(const A, B, C: TVector4): TVector4; overload; {$IFDEF FM_INLINE}inline;{$ENDIF}

{******************************************************}
{* Matrix Functions                                   *}
{******************************************************}

{ Treats the first parameter C as a column vector (matrix with one column) and
  the second parameter R as a row vector (matrix with one row) and does a linear
  algebraic matrix multiply C * R, yielding a matrix whose number of rows and
  columns matches that of the two vectors.

  Parameters:
    C: the column vector.
    R: the row vector.

  Returns:
    The outer product of C and R. }
function OuterProduct(const C, R: TVector2): TMatrix2; overload;
function OuterProduct(const C, R: TVector3): TMatrix3; overload;
function OuterProduct(const C, R: TVector4): TMatrix4; overload;

{******************************************************}
{* Configuration Functions                            *}
{******************************************************}

{ Disables floating-point exceptions. Instead invalid floating-point operations
  will return one of the following values:
  * 0: if underflow occurs (if the value is smaller than can be represented
      using floating-point). For example by evaluating "0.5 * MinSingle".
  * MaxSingle/MaxDouble: if there is not enough precision available.
      For example by evaluating "MaxSingle + 1".
  * +/-INF: when a division by zero or overflow occurs. For example by
      evaluating "Value / 0" or "MaxSingle * 2".
  * +/-NAN: when an invalid operation occurs. For example by evaluating
      "Sqrt(-1)"

  @bold(Note): On some platforms, this only disables exceptions on the thread
  that calls this routine. So in multi-threaded scenarios, it is best to call
  this routine in the Execute block of every thread where you want to ignore
  floating point exceptions.

  @bold(Note): For more fine-grained control over which exception types to
  disable, use the SetExceptionMask and/or SetSSEExceptionMask functions in the
  System.Math unit.}
procedure DisableFloatingPointExceptions;

{ Restore the floating-point exception flags to the state before you called
  DisableFloatingPointExceptions }
procedure RestoreFloatingPointExceptions;

{$INCLUDE 'Neslib.FastMath.Internal.inc'}

implementation

// Platform-independent implementations
{$INCLUDE 'Neslib.FastMath.Common.inc'}

{$IF Defined(FM_PASCAL)}
  // Pascal implementations
  {$INCLUDE 'Neslib.FastMath.Pascal.inc'}
{$ELSEIF Defined(FM_X86)}
  // 32-bit SSE2 implementations
  {$INCLUDE 'Neslib.FastMath.Sse2_32.inc'}
{$ELSEIF Defined(FM_X64)}
  // 64-bit SSE2 implementations
  {$IF Defined(MACOS64)}
    {$INCLUDE 'Neslib.FastMath.Sse2_64.MacOS.inc'}
  {$ELSE}
    {$INCLUDE 'Neslib.FastMath.Sse2_64.inc'}
  {$ENDIF}
{$ELSEIF Defined(FM_ARM)}
  // Arm NEON/Arm64 implementations
  {$INCLUDE 'Neslib.FastMath.Arm.inc'}
{$ENDIF}

end.
