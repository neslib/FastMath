const
  {$IFDEF FM_COLUMN_MAJOR}
  LIB_FASTMATH = 'FastMathMacOS64CM.obj';
  {$ELSE}
  LIB_FASTMATH = 'FastMathMacOS64RM.obj';
  {$ENDIF}

{ Angle and Trigonometry Functions }

function Radians(const ADegrees: Single): Single;
begin
  Result := ADegrees * (Pi / 180);
end;

function Radians(const ADegrees: TVector2): TVector2; external LIB_FASTMATH name 'radians_vector2';
function Radians(const ADegrees: TVector3): TVector3; external LIB_FASTMATH name 'radians_vector3';
function Radians(const ADegrees: TVector4): TVector4; external LIB_FASTMATH name 'radians_vector4';

function Degrees(const ARadians: Single): Single;
begin
  Result := ARadians * (180 / Pi);
end;

function Degrees(const ARadians: TVector2): TVector2; external LIB_FASTMATH name 'degrees_vector2';
function Degrees(const ARadians: TVector3): TVector3; external LIB_FASTMATH name 'degrees_vector3';
function Degrees(const ARadians: TVector4): TVector4; external LIB_FASTMATH name 'degrees_vector4';

{ Exponential Functions }

function Sqrt(const A: Single): Single; external LIB_FASTMATH name 'sqrt_single';
function Sqrt(const A: TVector2): TVector2; external LIB_FASTMATH name 'sqrt_vector2';
function Sqrt(const A: TVector3): TVector3; external LIB_FASTMATH name 'sqrt_vector3';
function Sqrt(const A: TVector4): TVector4; external LIB_FASTMATH name 'sqrt_vector4';

function InverseSqrt(const A: Single): Single; external LIB_FASTMATH name 'inverse_sqrt_single';
function InverseSqrt(const A: TVector2): TVector2; external LIB_FASTMATH name 'inverse_sqrt_vector2';
function InverseSqrt(const A: TVector3): TVector3; external LIB_FASTMATH name 'inverse_sqrt_vector3';
function InverseSqrt(const A: TVector4): TVector4; external LIB_FASTMATH name 'inverse_sqrt_vector4';

{ Fast approximate Functions }

function FastSin(const ARadians: Single): Single; external LIB_FASTMATH name 'fast_sin_single';
function FastSin(const ARadians: TVector2): TVector2; external LIB_FASTMATH name 'fast_sin_vector2';
function FastSin(const ARadians: TVector3): TVector3; external LIB_FASTMATH name 'fast_sin_vector3';
function FastSin(const ARadians: TVector4): TVector4; external LIB_FASTMATH name 'fast_sin_vector4';

function FastCos(const ARadians: Single): Single; external LIB_FASTMATH name 'fast_cos_single';
function FastCos(const ARadians: TVector2): TVector2; external LIB_FASTMATH name 'fast_cos_vector2';
function FastCos(const ARadians: TVector3): TVector3; external LIB_FASTMATH name 'fast_cos_vector3';
function FastCos(const ARadians: TVector4): TVector4; external LIB_FASTMATH name 'fast_cos_vector4';

procedure FastSinCos(const ARadians: Single; out ASin, ACos: Single); external LIB_FASTMATH name 'fast_sin_cos_single';
procedure FastSinCos(const ARadians: TVector2; out ASin, ACos: TVector2); external LIB_FASTMATH name 'fast_sin_cos_vector2';
procedure FastSinCos(const ARadians: TVector3; out ASin, ACos: TVector3); external LIB_FASTMATH name 'fast_sin_cos_vector3';
procedure FastSinCos(const ARadians: TVector4; out ASin, ACos: TVector4); external LIB_FASTMATH name 'fast_sin_cos_vector4';

function FastExp(const A: Single): Single; external LIB_FASTMATH name 'fast_exp_single';
function FastExp(const A: TVector2): TVector2; external LIB_FASTMATH name 'fast_exp_vector2';
function FastExp(const A: TVector3): TVector3; external LIB_FASTMATH name 'fast_exp_vector3';
function FastExp(const A: TVector4): TVector4; external LIB_FASTMATH name 'fast_exp_vector4';

function FastLn(const A: Single): Single; external LIB_FASTMATH name 'fast_ln_single';
function FastLn(const A: TVector2): TVector2; external LIB_FASTMATH name 'fast_ln_vector2';
function FastLn(const A: TVector3): TVector3; external LIB_FASTMATH name 'fast_ln_vector3';
function FastLn(const A: TVector4): TVector4; external LIB_FASTMATH name 'fast_ln_vector4';

function FastLog2(const A: Single): Single; external LIB_FASTMATH name 'fast_log2_single';
function FastLog2(const A: TVector2): TVector2; external LIB_FASTMATH name 'fast_log2_vector2';
function FastLog2(const A: TVector3): TVector3; external LIB_FASTMATH name 'fast_log2_vector3';
function FastLog2(const A: TVector4): TVector4; external LIB_FASTMATH name 'fast_log2_vector4';

function FastExp2(const A: Single): Single; external LIB_FASTMATH name 'fast_exp2_single';
function FastExp2(const A: TVector2): TVector2; external LIB_FASTMATH name 'fast_exp2_vector2';
function FastExp2(const A: TVector3): TVector3; external LIB_FASTMATH name 'fast_exp2_vector3';
function FastExp2(const A: TVector4): TVector4; external LIB_FASTMATH name 'fast_exp2_vector4';

{ Common Functions }

function Abs(const A: Single): Single;
begin
  Result := System.Abs(A);
end;

function Abs(const A: TVector2): TVector2;
begin
  Result.Init(System.Abs(A.X), System.Abs(A.Y));
end;

function Abs(const A: TVector3): TVector3; external LIB_FASTMATH name 'abs_vector3';
function Abs(const A: TVector4): TVector4; external LIB_FASTMATH name 'abs_vector4';

function Sign(const A: Single): Single; external LIB_FASTMATH name 'sign_single';
function Sign(const A: TVector2): TVector2; external LIB_FASTMATH name 'sign_vector2';
function Sign(const A: TVector3): TVector3; external LIB_FASTMATH name 'sign_vector3';
function Sign(const A: TVector4): TVector4; external LIB_FASTMATH name 'sign_vector4';

function Floor(const A: Single): Integer;
begin
  Result := System.Math.Floor(A);
end;

function Floor(const A: TVector2): TIVector2; external LIB_FASTMATH name 'floor_vector2';
function Floor(const A: TVector3): TIVector3; external LIB_FASTMATH name 'floor_vector3';
function Floor(const A: TVector4): TIVector4; external LIB_FASTMATH name 'floor_vector4';

function Trunc(const A: Single): Integer;
begin
  Result := System.Trunc(A);
end;

function Trunc(const A: TVector2): TIVector2; external LIB_FASTMATH name 'trunc_vector2';
function Trunc(const A: TVector3): TIVector3; external LIB_FASTMATH name 'trunc_vector3';
function Trunc(const A: TVector4): TIVector4; external LIB_FASTMATH name 'trunc_vector4';

function Round(const A: Single): Integer;
begin
  Result := System.Round(A);
end;

function Round(const A: TVector2): TIVector2; external LIB_FASTMATH name 'round_vector2';
function Round(const A: TVector3): TIVector3; external LIB_FASTMATH name 'round_vector3';
function Round(const A: TVector4): TIVector4; external LIB_FASTMATH name 'round_vector4';

function Ceil(const A: Single): Integer;
begin
  Result := System.Math.Ceil(A);
end;

function Ceil(const A: TVector2): TIVector2; external LIB_FASTMATH name 'ceil_vector2';
function Ceil(const A: TVector3): TIVector3; external LIB_FASTMATH name 'ceil_vector3';
function Ceil(const A: TVector4): TIVector4; external LIB_FASTMATH name 'ceil_vector4';

function Frac(const A: Single): Single;
begin
  Result := System.Frac(A);
end;

function Frac(const A: TVector2): TVector2; external LIB_FASTMATH name 'frac_vector2';
function Frac(const A: TVector3): TVector3; external LIB_FASTMATH name 'frac_vector3';
function Frac(const A: TVector4): TVector4; external LIB_FASTMATH name 'frac_vector4';

function FMod(const A, B: Single): Single;
begin
  Result := A - (B * Trunc(A / B));
end;

function FMod(const A: TVector2; const B: Single): TVector2; external LIB_FASTMATH name 'fmod_vector2_single';
function FMod(const A, B: TVector2): TVector2; external LIB_FASTMATH name 'fmod_vector2';
function FMod(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'fmod_vector3_single';
function FMod(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'fmod_vector3';
function FMod(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'fmod_vector4_single';
function FMod(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'fmod_vector4';

function ModF(const A: Single; out B: Integer): Single;
begin
  B := Trunc(A);
  Result := Frac(A);
end;

function ModF(const A: TVector2; out B: TIVector2): TVector2; external LIB_FASTMATH name 'modf_vector2';
function ModF(const A: TVector3; out B: TIVector3): TVector3; external LIB_FASTMATH name 'modf_vector3';
function ModF(const A: TVector4; out B: TIVector4): TVector4; external LIB_FASTMATH name 'modf_vector4';

function Min(const A: TVector2; const B: Single): TVector2; external LIB_FASTMATH name 'min_vector2_single';
function Min(const A, B: TVector2): TVector2; external LIB_FASTMATH name 'min_vector2';
function Min(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'min_vector3_single';
function Min(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'min_vector3';
function Min(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'min_vector4_single';
function Min(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'min_vector4';

function Max(const A: TVector2; const B: Single): TVector2; external LIB_FASTMATH name 'max_vector2_single';
function Max(const A, B: TVector2): TVector2; external LIB_FASTMATH name 'max_vector2';
function Max(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'max_vector3_single';
function Max(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'max_vector3';
function Max(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'max_vector4_single';
function Max(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'max_vector4';

function EnsureRange(const A, AMin, AMax: Single): Single; external LIB_FASTMATH name 'ensure_range_single';
function EnsureRange(const A: TVector2; const AMin, AMax: Single): TVector2; external LIB_FASTMATH name 'ensure_range_vector2_single';
function EnsureRange(const A, AMin, AMax: TVector2): TVector2; external LIB_FASTMATH name 'ensure_range_vector2';
function EnsureRange(const A: TVector3; const AMin, AMax: Single): TVector3; external LIB_FASTMATH name 'ensure_range_vector3_single';
function EnsureRange(const A, AMin, AMax: TVector3): TVector3; external LIB_FASTMATH name 'ensure_range_vector3';
function EnsureRange(const A: TVector4; const AMin, AMax: Single): TVector4; external LIB_FASTMATH name 'ensure_range_vector4_single';
function EnsureRange(const A, AMin, AMax: TVector4): TVector4; external LIB_FASTMATH name 'ensure_range_vector4';

function Mix(const A, B: TVector2; const T: Single): TVector2;
begin
  Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T));
end;

function Mix(const A, B, T: TVector2): TVector2;
begin
  Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y));
end;

function Mix(const A, B: TVector3; const T: Single): TVector3; external LIB_FASTMATH name 'mix_vector3_single';
function Mix(const A, B, T: TVector3): TVector3; external LIB_FASTMATH name 'mix_vector3';
function Mix(const A, B: TVector4; const T: Single): TVector4; external LIB_FASTMATH name 'mix_vector4_single';
function Mix(const A, B, T: TVector4): TVector4; external LIB_FASTMATH name 'mix_vector4';

function Step(const AEdge: Single; const A: TVector2): TVector2; external LIB_FASTMATH name 'step_single_vector2';
function Step(const AEdge, A: TVector2): TVector2; external LIB_FASTMATH name 'step_vector2';
function Step(const AEdge: Single; const A: TVector3): TVector3; external LIB_FASTMATH name 'step_single_vector3';
function Step(const AEdge, A: TVector3): TVector3; external LIB_FASTMATH name 'step_vector3';
function Step(const AEdge: Single; const A: TVector4): TVector4; external LIB_FASTMATH name 'step_single_vector4';
function Step(const AEdge, A: TVector4): TVector4; external LIB_FASTMATH name 'step_vector4';

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector2): TVector2;
begin
  Result.Init(SmoothStep(AEdge0, AEdge1, A.X), SmoothStep(AEdge0, AEdge1, A.Y));
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector2): TVector2;
begin
  Result.Init(SmoothStep(AEdge0.X, AEdge1.X, A.X), SmoothStep(AEdge0.Y, AEdge1.Y, A.Y));
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector3): TVector3; external LIB_FASTMATH name 'smooth_step_single_vector3';
function SmoothStep(const AEdge0, AEdge1, A: TVector3): TVector3; external LIB_FASTMATH name 'smooth_step_vector3';
function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector4): TVector4; external LIB_FASTMATH name 'smooth_step_single_vector4';
function SmoothStep(const AEdge0, AEdge1, A: TVector4): TVector4; external LIB_FASTMATH name 'smooth_step_vector4';

function FMA(const A, B, C: TVector2): TVector2; external LIB_FASTMATH name 'fma_vector2';
function FMA(const A, B, C: TVector3): TVector3; external LIB_FASTMATH name 'fma_vector3';
function FMA(const A, B, C: TVector4): TVector4; external LIB_FASTMATH name 'fma_vector4';

{ Matrix functions }

function OuterProduct(const C, R: TVector2): TMatrix2; external LIB_FASTMATH name 'outer_product_matrix2';
function OuterProduct(const C, R: TVector3): TMatrix3; external LIB_FASTMATH name 'outer_product_matrix3';
function OuterProduct(const C, R: TVector4): TMatrix4; external LIB_FASTMATH name 'outer_product_matrix4';

{ TVector2 }

class operator TVector2.Add(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TVector2.Add(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
end;

class operator TVector2.Add(const A, B: TVector2): TVector2;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

function TVector2.Distance(const AOther: TVector2): Single;
begin
  Result := (Self - AOther).Length;
end;

function TVector2.DistanceSquared(const AOther: TVector2): Single;
begin
  Result := (Self - AOther).LengthSquared;
end;

class operator TVector2.Divide(const A: TVector2; const B: Single): TVector2; external LIB_FASTMATH name 'vector2_div_single';
class operator TVector2.Divide(const A: Single; const B: TVector2): TVector2; external LIB_FASTMATH name 'single_div_vector2';
class operator TVector2.Divide(const A, B: TVector2): TVector2; external LIB_FASTMATH name 'vector2_div_vector2';

function TVector2.Dot(const AOther: TVector2): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y);
end;

function TVector2.FaceForward(const I, NRef: TVector2): TVector2;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

function TVector2.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function TVector2.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

class operator TVector2.Multiply(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TVector2.Multiply(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
end;

class operator TVector2.Multiply(const A, B: TVector2): TVector2;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

function TVector2.NormalizeFast: TVector2; external LIB_FASTMATH name 'vector2_normalize_fast';

function TVector2.Reflect(const N: TVector2): TVector2;
begin
  Result := Self - ((2 * N.Dot(Self)) * N);
end;

function TVector2.Refract(const N: TVector2; const Eta: Single): TVector2;
var
  D, K: Single;
begin
  D := N.Dot(Self);
  K := 1 - Eta * Eta * (1 - D * D);
  if (K < 0) then
    Result.Init
  else
    Result := (Eta * Self) - ((Eta * D + Sqrt(K)) * N);
end;

procedure TVector2.SetNormalizedFast; external LIB_FASTMATH name 'vector2_set_normalized_fast';

class operator TVector2.Subtract(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TVector2.Subtract(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
end;

class operator TVector2.Subtract(const A, B: TVector2): TVector2;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

{ TVector3 }

class operator TVector3.Add(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'vector3_add_single';
class operator TVector3.Add(const A: Single; const B: TVector3): TVector3; external LIB_FASTMATH name 'single_add_vector3';
class operator TVector3.Add(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'vector3_add_vector3';

function TVector3.Distance(const AOther: TVector3): Single; external LIB_FASTMATH name 'vector3_distance';
function TVector3.DistanceSquared(const AOther: TVector3): Single; external LIB_FASTMATH name 'vector3_distance_squared';

class operator TVector3.Divide(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'vector3_div_single';
class operator TVector3.Divide(const A: Single; const B: TVector3): TVector3; external LIB_FASTMATH name 'single_div_vector3';
class operator TVector3.Divide(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'vector3_div_vector3';

function TVector3.Cross(const AOther: TVector3): TVector3;
begin
  Result.X := (Y * AOther.Z) - (AOther.Y * Z);
  Result.Y := (Z * AOther.X) - (AOther.Z * X);
  Result.Z := (X * AOther.Y) - (AOther.X * Y);
end;

function TVector3.Dot(const AOther: TVector3): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z);
end;

function TVector3.FaceForward(const I, NRef: TVector3): TVector3;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

function TVector3.GetLength: Single; external LIB_FASTMATH name 'vector3_get_length';
function TVector3.GetLengthSquared: Single; external LIB_FASTMATH name 'vector3_get_length_squared';

class operator TVector3.Multiply(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'vector3_mul_single';
class operator TVector3.Multiply(const A: Single; const B: TVector3): TVector3; external LIB_FASTMATH name 'single_mul_vector3';
class operator TVector3.Multiply(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'vector3_mul_vector3';

class operator TVector3.Negative(const A: TVector3): TVector3;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
end;

function TVector3.NormalizeFast: TVector3; external LIB_FASTMATH name 'vector3_normalize_fast';
procedure TVector3.SetNormalizedFast; external LIB_FASTMATH name 'vector3_set_normalized_fast';

function TVector3.Reflect(const N: TVector3): TVector3; external LIB_FASTMATH name 'vector3_reflect';
function TVector3.Refract(const N: TVector3; const Eta: Single): TVector3; external LIB_FASTMATH name 'vector3_refract';

class operator TVector3.Subtract(const A: TVector3; const B: Single): TVector3; external LIB_FASTMATH name 'vector3_sub_single';
class operator TVector3.Subtract(const A: Single; const B: TVector3): TVector3; external LIB_FASTMATH name 'single_sub_vector3';
class operator TVector3.Subtract(const A, B: TVector3): TVector3; external LIB_FASTMATH name 'vector3_sub_vector3';

{ TVector4 }

class operator TVector4.Add(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'vector4_add_single';
class operator TVector4.Add(const A: Single; const B: TVector4): TVector4; external LIB_FASTMATH name 'single_add_vector4';
class operator TVector4.Add(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'vector4_add_vector4';

function TVector4.Distance(const AOther: TVector4): Single; external LIB_FASTMATH name 'vector4_distance';
function TVector4.DistanceSquared(const AOther: TVector4): Single; external LIB_FASTMATH name 'vector4_distance_squared';

class operator TVector4.Divide(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'vector4_div_single';
class operator TVector4.Divide(const A: Single; const B: TVector4): TVector4; external LIB_FASTMATH name 'single_div_vector4';
class operator TVector4.Divide(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'vector4_div_vector4';

function TVector4.Dot(const AOther: TVector4): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z) + (W * AOther.W);
end;

function TVector4.FaceForward(const I, NRef: TVector4): TVector4; external LIB_FASTMATH name 'vector4_face_forward';

function TVector4.GetLength: Single; external LIB_FASTMATH name 'vector4_get_length';
function TVector4.GetLengthSquared: Single; external LIB_FASTMATH name 'vector4_get_length_squared';

class operator TVector4.Multiply(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'vector4_mul_single';
class operator TVector4.Multiply(const A: Single; const B: TVector4): TVector4; external LIB_FASTMATH name 'single_mul_vector4';
class operator TVector4.Multiply(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'vector4_mul_vector4';

class operator TVector4.Negative(const A: TVector4): TVector4; external LIB_FASTMATH name 'vector4_negative';

function TVector4.NormalizeFast: TVector4; external LIB_FASTMATH name 'vector4_normalize_fast';
procedure TVector4.SetNormalizedFast; external LIB_FASTMATH name 'vector4_set_normalized_fast';

function TVector4.Reflect(const N: TVector4): TVector4; external LIB_FASTMATH name 'vector4_reflect';
function TVector4.Refract(const N: TVector4; const Eta: Single): TVector4; external LIB_FASTMATH name 'vector4_refract';

class operator TVector4.Subtract(const A: TVector4; const B: Single): TVector4; external LIB_FASTMATH name 'vector4_sub_single';
class operator TVector4.Subtract(const A: Single; const B: TVector4): TVector4; external LIB_FASTMATH name 'single_sub_vector4';
class operator TVector4.Subtract(const A, B: TVector4): TVector4; external LIB_FASTMATH name 'vector4_sub_vector4';

{ TQuaternion }

class operator TQuaternion.Add(const A, B: TQuaternion): TQuaternion;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

function TQuaternion.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end;

function TQuaternion.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z) + (W * W);
end;

class operator TQuaternion.Multiply(const A: TQuaternion; const B: Single): TQuaternion;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TQuaternion.Multiply(const A: Single; const B: TQuaternion): TQuaternion;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
  Result.W := A * B.W;
end;

class operator TQuaternion.Multiply(const A, B: TQuaternion): TQuaternion;
begin
  Result.X := (A.W * B.X) + (A.X * B.W) + (A.Y * B.Z) - (A.Z * B.Y);
  Result.Y := (A.W * B.Y) + (A.Y * B.W) + (A.Z * B.X) - (A.X * B.Z);
  Result.Z := (A.W * B.Z) + (A.Z * B.W) + (A.X * B.Y) - (A.Y * B.X);
  Result.W := (A.W * B.W) - (A.X * B.X) - (A.Y * B.Y) - (A.Z * B.Z);
end;

function TQuaternion.NormalizeFast: TQuaternion;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

procedure TQuaternion.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

{ TMatrix 2 }

class operator TMatrix2.Add(const A: TMatrix2; const B: Single): TMatrix2;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
end;

class operator TMatrix2.Add(const A: Single; const B: TMatrix2): TMatrix2;
begin
  Result.V[0] := A + B.V[0];
  Result.V[1] := A + B.V[1];
end;

class operator TMatrix2.Add(const A, B: TMatrix2): TMatrix2;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
end;

function TMatrix2.CompMult(const AOther: TMatrix2): TMatrix2;
var
  I: Integer;
begin
  for I := 0 to 1 do
    Result.V[I] := V[I] * AOther.V[I];
end;

class operator TMatrix2.Divide(const A: Single; const B: TMatrix2): TMatrix2;
begin
  Result.V[0] := A / B.V[0];
  Result.V[1] := A / B.V[1];
end;

class operator TMatrix2.Divide(const A: TMatrix2; const B: Single): TMatrix2;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
end;

class operator TMatrix2.Multiply(const A: Single; const B: TMatrix2): TMatrix2;
begin
  Result.V[0] := A * B.V[0];
  Result.V[1] := A * B.V[1];
end;

class operator TMatrix2.Multiply(const A: TMatrix2; const B: Single): TMatrix2;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
end;

class operator TMatrix2.Multiply(const A: TVector2; const B: TMatrix2): TVector2;
begin
  Result.X := (A.X * B.M[0,0]) + (A.Y * B.M[0,1]);
  Result.Y := (A.X * B.M[1,0]) + (A.Y * B.M[1,1]);
end;

class operator TMatrix2.Multiply(const A: TMatrix2; const B: TVector2): TVector2;
begin
  Result.X := (A.M[0,0] * B.X) + (A.M[1,0] * B.Y);
  Result.Y := (A.M[0,1] * B.X) + (A.M[1,1] * B.Y);
end;

class operator TMatrix2.Multiply(const A, B: TMatrix2): TMatrix2;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[1,0] * B.M[0,1]);
  Result.M[0,1] := (A.M[0,1] * B.M[0,0]) + (A.M[1,1] * B.M[0,1]);
  Result.M[1,0] := (A.M[0,0] * B.M[1,0]) + (A.M[1,0] * B.M[1,1]);
  Result.M[1,1] := (A.M[0,1] * B.M[1,0]) + (A.M[1,1] * B.M[1,1]);
end;

class operator TMatrix2.Negative(const A: TMatrix2): TMatrix2;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
end;

procedure TMatrix2.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix2.Subtract(const A: TMatrix2; const B: Single): TMatrix2;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
end;

class operator TMatrix2.Subtract(const A, B: TMatrix2): TMatrix2;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
end;

class operator TMatrix2.Subtract(const A: Single; const B: TMatrix2): TMatrix2;
begin
  Result.V[0] := A - B.V[0];
  Result.V[1] := A - B.V[1];
end;

function TMatrix2.Transpose: TMatrix2;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
end;

{ TMatrix3 }

class operator TMatrix3.Add(const A: TMatrix3; const B: Single): TMatrix3;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
end;

class operator TMatrix3.Add(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A + B.V[0];
  Result.V[1] := A + B.V[1];
  Result.V[2] := A + B.V[2];
end;

class operator TMatrix3.Add(const A, B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
end;

function TMatrix3.CompMult(const AOther: TMatrix3): TMatrix3;
var
  I: Integer;
begin
  for I := 0 to 2 do
    Result.V[I] := V[I] * AOther.V[I];
end;

class operator TMatrix3.Divide(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A / B.V[0];
  Result.V[1] := A / B.V[1];
  Result.V[2] := A / B.V[2];
end;

class operator TMatrix3.Divide(const A: TMatrix3; const B: Single): TMatrix3;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
end;

class operator TMatrix3.Multiply(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A * B.V[0];
  Result.V[1] := A * B.V[1];
  Result.V[2] := A * B.V[2];
end;

class operator TMatrix3.Multiply(const A: TMatrix3; const B: Single): TMatrix3;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
end;

{$IFDEF FM_COLUMN_MAJOR}
class operator TMatrix3.Multiply(const A: TMatrix3; const B: TVector3): TVector3;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[1,0]) + (B.Z * A.M[2,0]);
  Result.Y := (B.X * A.M[0,1]) + (B.Y * A.M[1,1]) + (B.Z * A.M[2,1]);
  Result.Z := (B.X * A.M[0,2]) + (B.Y * A.M[1,2]) + (B.Z * A.M[2,2]);
end;

class operator TMatrix3.Multiply(const A: TVector3; const B: TMatrix3): TVector3;
begin
  Result.X := (B.M[0,0] * A.X) + (B.M[0,1] * A.Y) + (B.M[0,2] * A.Z);
  Result.Y := (B.M[1,0] * A.X) + (B.M[1,1] * A.Y) + (B.M[1,2] * A.Z);
  Result.Z := (B.M[2,0] * A.X) + (B.M[2,1] * A.Y) + (B.M[2,2] * A.Z);
end;
{$ELSE}
class operator TMatrix3.Multiply(const A: TMatrix3; const B: TVector3): TVector3;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]);
end;

class operator TMatrix3.Multiply(const A: TVector3; const B: TMatrix3): TVector3;
begin
  Result.X := (B.M[0,0] * A.X) + (B.M[1,0] * A.Y) + (B.M[2,0] * A.Z);
  Result.Y := (B.M[0,1] * A.X) + (B.M[1,1] * A.Y) + (B.M[2,1] * A.Z);
  Result.Z := (B.M[0,2] * A.X) + (B.M[1,2] * A.Y) + (B.M[2,2] * A.Z);
end;
{$ENDIF}

class operator TMatrix3.Multiply(const A, B: TMatrix3): TMatrix3;
var
  A00, A01, A02, A10, A11, A12, A20, A21, A22: Single;
  B00, B01, B02, B10, B11, B12, B20, B21, B22: Single;
begin
  A00 := A.M[0,0];
  A01 := A.M[0,1];
  A02 := A.M[0,2];
  A10 := A.M[1,0];
  A11 := A.M[1,1];
  A12 := A.M[1,2];
  A20 := A.M[2,0];
  A21 := A.M[2,1];
  A22 := A.M[2,2];

  B00 := B.M[0,0];
  B01 := B.M[0,1];
  B02 := B.M[0,2];
  B10 := B.M[1,0];
  B11 := B.M[1,1];
  B12 := B.M[1,2];
  B20 := B.M[2,0];
  B21 := B.M[2,1];
  B22 := B.M[2,2];

  {$IFDEF FM_COLUMN_MAJOR}
  Result.M[0,0] := (A00 * B00) + (A10 * B01) + (A20 * B02);
  Result.M[0,1] := (A01 * B00) + (A11 * B01) + (A21 * B02);
  Result.M[0,2] := (A02 * B00) + (A12 * B01) + (A22 * B02);
  Result.M[1,0] := (A00 * B10) + (A10 * B11) + (A20 * B12);
  Result.M[1,1] := (A01 * B10) + (A11 * B11) + (A21 * B12);
  Result.M[1,2] := (A02 * B10) + (A12 * B11) + (A22 * B12);
  Result.M[2,0] := (A00 * B20) + (A10 * B21) + (A20 * B22);
  Result.M[2,1] := (A01 * B20) + (A11 * B21) + (A21 * B22);
  Result.M[2,2] := (A02 * B20) + (A12 * B21) + (A22 * B22);
  {$ELSE}
  Result.M[0,0] := (A00 * B00) + (A01 * B10) + (A02 * B20);
  Result.M[0,1] := (A00 * B01) + (A01 * B11) + (A02 * B21);
  Result.M[0,2] := (A00 * B02) + (A01 * B12) + (A02 * B22);
  Result.M[1,0] := (A10 * B00) + (A11 * B10) + (A12 * B20);
  Result.M[1,1] := (A10 * B01) + (A11 * B11) + (A12 * B21);
  Result.M[1,2] := (A10 * B02) + (A11 * B12) + (A12 * B22);
  Result.M[2,0] := (A20 * B00) + (A21 * B10) + (A22 * B20);
  Result.M[2,1] := (A20 * B01) + (A21 * B11) + (A22 * B21);
  Result.M[2,2] := (A20 * B02) + (A21 * B12) + (A22 * B22);
  {$ENDIF}
end;

class operator TMatrix3.Negative(const A: TMatrix3): TMatrix3;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
end;

procedure TMatrix3.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix3.Subtract(const A: TMatrix3; const B: Single): TMatrix3;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
end;

class operator TMatrix3.Subtract(const A, B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
end;

class operator TMatrix3.Subtract(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A - B.V[0];
  Result.V[1] := A - B.V[1];
  Result.V[2] := A - B.V[2];
end;

function TMatrix3.Transpose: TMatrix3;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
end;

{ TMatrix 4 }

class operator TMatrix4.Add(const A: TMatrix4; const B: Single): TMatrix4;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
  Result.V[3] := A.V[3] + B;
end;

class operator TMatrix4.Add(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A + B.V[0];
  Result.V[1] := A + B.V[1];
  Result.V[2] := A + B.V[2];
  Result.V[3] := A + B.V[3];
end;

class operator TMatrix4.Add(const A, B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
  Result.V[3] := A.V[3] + B.V[3];
end;

function TMatrix4.CompMult(const AOther: TMatrix4): TMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := V[I] * AOther.V[I];
end;

class operator TMatrix4.Divide(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A / B.V[0];
  Result.V[1] := A / B.V[1];
  Result.V[2] := A / B.V[2];
  Result.V[3] := A / B.V[3];
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: Single): TMatrix4;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
  Result.V[3] := A.V[3] * InvB;
end;

function TMatrix4.Inverse: TMatrix4;
var
  C00, C02, C03, C04, C06, C07, C08, C10, C11: Single;
  C12, C14, C15, C16, C18, C19, C20, C22, C23: Single;
  F0, F1, F2, F3, F4, F5, V0, V1, V2, V3, I0, I1, I2, I3, SA, SB, Row, Dot: TVector4;
  Inv: TMatrix4;
  OneOverDeterminant: Single;
begin
  C00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  C02 := (M[1,2] * M[3,3]) - (M[3,2] * M[1,3]);
  C03 := (M[1,2] * M[2,3]) - (M[2,2] * M[1,3]);

  C04 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  C06 := (M[1,1] * M[3,3]) - (M[3,1] * M[1,3]);
  C07 := (M[1,1] * M[2,3]) - (M[2,1] * M[1,3]);

  C08 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  C10 := (M[1,1] * M[3,2]) - (M[3,1] * M[1,2]);
  C11 := (M[1,1] * M[2,2]) - (M[2,1] * M[1,2]);

  C12 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  C14 := (M[1,0] * M[3,3]) - (M[3,0] * M[1,3]);
  C15 := (M[1,0] * M[2,3]) - (M[2,0] * M[1,3]);

  C16 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  C18 := (M[1,0] * M[3,2]) - (M[3,0] * M[1,2]);
  C19 := (M[1,0] * M[2,2]) - (M[2,0] * M[1,2]);

  C20 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);
  C22 := (M[1,0] * M[3,1]) - (M[3,0] * M[1,1]);
  C23 := (M[1,0] * M[2,1]) - (M[2,0] * M[1,1]);

  F0 := Vector4(C00, C00, C02, C03);
  F1 := Vector4(C04, C04, C06, C07);
  F2 := Vector4(C08, C08, C10, C11);
  F3 := Vector4(C12, C12, C14, C15);
  F4 := Vector4(C16, C16, C18, C19);
  F5 := Vector4(C20, C20, C22, C23);

  V0 := Vector4(M[1,0], M[0,0], M[0,0], M[0,0]);
  V1 := Vector4(M[1,1], M[0,1], M[0,1], M[0,1]);
  V2 := Vector4(M[1,2], M[0,2], M[0,2], M[0,2]);
  V3 := Vector4(M[1,3], M[0,3], M[0,3], M[0,3]);

  I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
  I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
  I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
  I3 := (V0 * F2) - (V1 * F4) + (V2 * F5);

  SA := Vector4(+1, -1, +1, -1);
  SB := Vector4(-1, +1, -1, +1);

  Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB);

  Row := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
  Dot := V[0] * Row;

  OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W));
  Result := Inv * OneOverDeterminant;
end;

class operator TMatrix4.Multiply(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A * B.V[0];
  Result.V[1] := A * B.V[1];
  Result.V[2] := A * B.V[2];
  Result.V[3] := A * B.V[3];
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: Single): TMatrix4;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
  Result.V[3] := A.V[3] * B;
end;

{$IFDEF FM_COLUMN_MAJOR}
class operator TMatrix4.Multiply(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result.X := (A.X * B.M[0,0]) + (A.Y * B.M[0,1]) + (A.Z * B.M[0,2]) + (A.W * B.M[0,3]);
  Result.Y := (A.X * B.M[1,0]) + (A.Y * B.M[1,1]) + (A.Z * B.M[1,2]) + (A.W * B.M[1,3]);
  Result.Z := (A.X * B.M[2,0]) + (A.Y * B.M[2,1]) + (A.Z * B.M[2,2]) + (A.W * B.M[2,3]);
  Result.W := (A.X * B.M[3,0]) + (A.Y * B.M[3,1]) + (A.Z * B.M[3,2]) + (A.W * B.M[3,3]);
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[1,0]) + (B.Z * A.M[2,0]) + (B.W * A.M[3,0]);
  Result.Y := (B.X * A.M[0,1]) + (B.Y * A.M[1,1]) + (B.Z * A.M[2,1]) + (B.W * A.M[3,1]);
  Result.Z := (B.X * A.M[0,2]) + (B.Y * A.M[1,2]) + (B.Z * A.M[2,2]) + (B.W * A.M[3,2]);
  Result.W := (B.X * A.M[0,3]) + (B.Y * A.M[1,3]) + (B.Z * A.M[2,3]) + (B.W * A.M[3,3]);
end;

class operator TMatrix4.Multiply(const A, B: TMatrix4): TMatrix4;
begin
  Result.M[0,0] := (B.M[0,0] * A.M[0,0]) + (B.M[0,1] * A.M[1,0]) + (B.M[0,2] * A.M[2,0]) + (B.M[0,3] * A.M[3,0]);
  Result.M[0,1] := (B.M[0,0] * A.M[0,1]) + (B.M[0,1] * A.M[1,1]) + (B.M[0,2] * A.M[2,1]) + (B.M[0,3] * A.M[3,1]);
  Result.M[0,2] := (B.M[0,0] * A.M[0,2]) + (B.M[0,1] * A.M[1,2]) + (B.M[0,2] * A.M[2,2]) + (B.M[0,3] * A.M[3,2]);
  Result.M[0,3] := (B.M[0,0] * A.M[0,3]) + (B.M[0,1] * A.M[1,3]) + (B.M[0,2] * A.M[2,3]) + (B.M[0,3] * A.M[3,3]);

  Result.M[1,0] := (B.M[1,0] * A.M[0,0]) + (B.M[1,1] * A.M[1,0]) + (B.M[1,2] * A.M[2,0]) + (B.M[1,3] * A.M[3,0]);
  Result.M[1,1] := (B.M[1,0] * A.M[0,1]) + (B.M[1,1] * A.M[1,1]) + (B.M[1,2] * A.M[2,1]) + (B.M[1,3] * A.M[3,1]);
  Result.M[1,2] := (B.M[1,0] * A.M[0,2]) + (B.M[1,1] * A.M[1,2]) + (B.M[1,2] * A.M[2,2]) + (B.M[1,3] * A.M[3,2]);
  Result.M[1,3] := (B.M[1,0] * A.M[0,3]) + (B.M[1,1] * A.M[1,3]) + (B.M[1,2] * A.M[2,3]) + (B.M[1,3] * A.M[3,3]);

  Result.M[2,0] := (B.M[2,0] * A.M[0,0]) + (B.M[2,1] * A.M[1,0]) + (B.M[2,2] * A.M[2,0]) + (B.M[2,3] * A.M[3,0]);
  Result.M[2,1] := (B.M[2,0] * A.M[0,1]) + (B.M[2,1] * A.M[1,1]) + (B.M[2,2] * A.M[2,1]) + (B.M[2,3] * A.M[3,1]);
  Result.M[2,2] := (B.M[2,0] * A.M[0,2]) + (B.M[2,1] * A.M[1,2]) + (B.M[2,2] * A.M[2,2]) + (B.M[2,3] * A.M[3,2]);
  Result.M[2,3] := (B.M[2,0] * A.M[0,3]) + (B.M[2,1] * A.M[1,3]) + (B.M[2,2] * A.M[2,3]) + (B.M[2,3] * A.M[3,3]);

  Result.M[3,0] := (B.M[3,0] * A.M[0,0]) + (B.M[3,1] * A.M[1,0]) + (B.M[3,2] * A.M[2,0]) + (B.M[3,3] * A.M[3,0]);
  Result.M[3,1] := (B.M[3,0] * A.M[0,1]) + (B.M[3,1] * A.M[1,1]) + (B.M[3,2] * A.M[2,1]) + (B.M[3,3] * A.M[3,1]);
  Result.M[3,2] := (B.M[3,0] * A.M[0,2]) + (B.M[3,1] * A.M[1,2]) + (B.M[3,2] * A.M[2,2]) + (B.M[3,3] * A.M[3,2]);
  Result.M[3,3] := (B.M[3,0] * A.M[0,3]) + (B.M[3,1] * A.M[1,3]) + (B.M[3,2] * A.M[2,3]) + (B.M[3,3] * A.M[3,3]);
end;
{$ELSE}
class operator TMatrix4.Multiply(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result.X := (B.M[0,0] * A.X) + (B.M[1,0] * A.Y) + (B.M[2,0] * A.Z) + (B.M[3,0] * A.W);
  Result.Y := (B.M[0,1] * A.X) + (B.M[1,1] * A.Y) + (B.M[2,1] * A.Z) + (B.M[3,1] * A.W);
  Result.Z := (B.M[0,2] * A.X) + (B.M[1,2] * A.Y) + (B.M[2,2] * A.Z) + (B.M[3,2] * A.W);
  Result.W := (B.M[0,3] * A.X) + (B.M[1,3] * A.Y) + (B.M[2,3] * A.Z) + (B.M[3,3] * A.W);
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]) + (B.W * A.M[0,3]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]) + (B.W * A.M[1,3]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]) + (B.W * A.M[2,3]);
  Result.W := (B.X * A.M[3,0]) + (B.Y * A.M[3,1]) + (B.Z * A.M[3,2]) + (B.W * A.M[3,3]);
end;

class operator TMatrix4.Multiply(const A, B: TMatrix4): TMatrix4;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[0,1] * B.M[1,0]) + (A.M[0,2] * B.M[2,0]) + (A.M[0,3] * B.M[3,0]);
  Result.M[0,1] := (A.M[0,0] * B.M[0,1]) + (A.M[0,1] * B.M[1,1]) + (A.M[0,2] * B.M[2,1]) + (A.M[0,3] * B.M[3,1]);
  Result.M[0,2] := (A.M[0,0] * B.M[0,2]) + (A.M[0,1] * B.M[1,2]) + (A.M[0,2] * B.M[2,2]) + (A.M[0,3] * B.M[3,2]);
  Result.M[0,3] := (A.M[0,0] * B.M[0,3]) + (A.M[0,1] * B.M[1,3]) + (A.M[0,2] * B.M[2,3]) + (A.M[0,3] * B.M[3,3]);

  Result.M[1,0] := (A.M[1,0] * B.M[0,0]) + (A.M[1,1] * B.M[1,0]) + (A.M[1,2] * B.M[2,0]) + (A.M[1,3] * B.M[3,0]);
  Result.M[1,1] := (A.M[1,0] * B.M[0,1]) + (A.M[1,1] * B.M[1,1]) + (A.M[1,2] * B.M[2,1]) + (A.M[1,3] * B.M[3,1]);
  Result.M[1,2] := (A.M[1,0] * B.M[0,2]) + (A.M[1,1] * B.M[1,2]) + (A.M[1,2] * B.M[2,2]) + (A.M[1,3] * B.M[3,2]);
  Result.M[1,3] := (A.M[1,0] * B.M[0,3]) + (A.M[1,1] * B.M[1,3]) + (A.M[1,2] * B.M[2,3]) + (A.M[1,3] * B.M[3,3]);

  Result.M[2,0] := (A.M[2,0] * B.M[0,0]) + (A.M[2,1] * B.M[1,0]) + (A.M[2,2] * B.M[2,0]) + (A.M[2,3] * B.M[3,0]);
  Result.M[2,1] := (A.M[2,0] * B.M[0,1]) + (A.M[2,1] * B.M[1,1]) + (A.M[2,2] * B.M[2,1]) + (A.M[2,3] * B.M[3,1]);
  Result.M[2,2] := (A.M[2,0] * B.M[0,2]) + (A.M[2,1] * B.M[1,2]) + (A.M[2,2] * B.M[2,2]) + (A.M[2,3] * B.M[3,2]);
  Result.M[2,3] := (A.M[2,0] * B.M[0,3]) + (A.M[2,1] * B.M[1,3]) + (A.M[2,2] * B.M[2,3]) + (A.M[2,3] * B.M[3,3]);

  Result.M[3,0] := (A.M[3,0] * B.M[0,0]) + (A.M[3,1] * B.M[1,0]) + (A.M[3,2] * B.M[2,0]) + (A.M[3,3] * B.M[3,0]);
  Result.M[3,1] := (A.M[3,0] * B.M[0,1]) + (A.M[3,1] * B.M[1,1]) + (A.M[3,2] * B.M[2,1]) + (A.M[3,3] * B.M[3,1]);
  Result.M[3,2] := (A.M[3,0] * B.M[0,2]) + (A.M[3,1] * B.M[1,2]) + (A.M[3,2] * B.M[2,2]) + (A.M[3,3] * B.M[3,2]);
  Result.M[3,3] := (A.M[3,0] * B.M[0,3]) + (A.M[3,1] * B.M[1,3]) + (A.M[3,2] * B.M[2,3]) + (A.M[3,3] * B.M[3,3]);
end;
{$ENDIF}

class operator TMatrix4.Negative(const A: TMatrix4): TMatrix4;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
  Result.V[3] := -A.V[3];
end;

procedure TMatrix4.SetInversed;
begin
  Self := Inverse;
end;

procedure TMatrix4.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix4.Subtract(const A: TMatrix4; const B: Single): TMatrix4;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
  Result.V[3] := A.V[3] - B;
end;

class operator TMatrix4.Subtract(const A, B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
  Result.V[3] := A.V[3] - B.V[3];
end;

class operator TMatrix4.Subtract(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A - B.V[0];
  Result.V[1] := A - B.V[1];
  Result.V[2] := A - B.V[2];
  Result.V[3] := A - B.V[3];
end;

function TMatrix4.Transpose: TMatrix4;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];
  Result.M[0,3] := M[3,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];
  Result.M[1,3] := M[3,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
  Result.M[2,3] := M[3,2];

  Result.M[3,0] := M[0,3];
  Result.M[3,1] := M[1,3];
  Result.M[3,2] := M[2,3];
  Result.M[3,3] := M[3,3];
end;
