{ Angle and Trigonometry Functions }

function Radians(const ADegrees: Single): Single;
begin
  Result := _radians_scalar(ADegrees);
end;

function Radians(const ADegrees: TVector2): TVector2;
begin
  _radians_vector2(@ADegrees, @Result);
end;

function Radians(const ADegrees: TVector3): TVector3;
begin
  _radians_vector3(@ADegrees, @Result);
end;

function Radians(const ADegrees: TVector4): TVector4;
begin
  _radians_vector4(@ADegrees, @Result);
end;

function Degrees(const ARadians: Single): Single;
begin
  Result := _degrees_scalar(ARadians);
end;

function Degrees(const ARadians: TVector2): TVector2;
begin
  _degrees_vector2(@ARadians, @Result);
end;

function Degrees(const ARadians: TVector3): TVector3;
begin
  _degrees_vector3(@ARadians, @Result);
end;

function Degrees(const ARadians: TVector4): TVector4;
begin
  _degrees_vector4(@ARadians, @Result);
end;

{ Exponential Functions }

function Sqrt(const A: Single): Single;
begin
  Result := _sqrt_scalar(A);
end;

function Sqrt(const A: TVector2): TVector2;
begin
  _sqrt_vector2(@A, @Result);
end;

function Sqrt(const A: TVector3): TVector3;
begin
  _sqrt_vector3(@A, @Result);
end;

function Sqrt(const A: TVector4): TVector4;
begin
  _sqrt_vector4(@A, @Result);
end;

function InverseSqrt(const A: Single): Single;
begin
  Result := _inverse_sqrt_scalar(A);
end;

function InverseSqrt(const A: TVector2): TVector2;
begin
  _inverse_sqrt_vector2(@A, @Result);
end;

function InverseSqrt(const A: TVector3): TVector3;
begin
  _inverse_sqrt_vector3(@A, @Result);
end;

function InverseSqrt(const A: TVector4): TVector4;
begin
  _inverse_sqrt_vector4(@A, @Result);
end;

{ Fast approximate Functions }

function FastSin(const ARadians: Single): Single;
var
  C: Single;
begin
  _fast_sincos_scalar(ARadians, @Result, @C);
end;

function FastSin(const ARadians: TVector2): TVector2;
var
  C: TVector2;
begin
  _fast_sincos_vector2(@ARadians, @Result, @C);
end;

function FastSin(const ARadians: TVector3): TVector3;
var
  C: TVector3;
begin
  _fast_sincos_vector3(@ARadians, @Result, @C);
end;

function FastSin(const ARadians: TVector4): TVector4;
var
  C: TVector4;
begin
  _fast_sincos_vector4(@ARadians, @Result, @C);
end;

function FastCos(const ARadians: Single): Single;
var
  S: Single;
begin
  _fast_sincos_scalar(ARadians, @S, @Result);
end;

function FastCos(const ARadians: TVector2): TVector2;
var
  S: TVector2;
begin
  _fast_sincos_vector2(@ARadians, @S, @Result);
end;

function FastCos(const ARadians: TVector3): TVector3;
var
  S: TVector3;
begin
  _fast_sincos_vector3(@ARadians, @S, @Result);
end;

function FastCos(const ARadians: TVector4): TVector4;
var
  S: TVector4;
begin
  _fast_sincos_vector4(@ARadians, @S, @Result);
end;

procedure FastSinCos(const ARadians: Single; out ASin, ACos: Single);
begin
  _fast_sincos_scalar(ARadians, @ASin, @ACos);
end;

procedure FastSinCos(const ARadians: TVector2; out ASin, ACos: TVector2);
begin
  _fast_sincos_vector2(@ARadians, @ASin, @ACos);
end;

procedure FastSinCos(const ARadians: TVector3; out ASin, ACos: TVector3);
begin
  _fast_sincos_vector3(@ARadians, @ASin, @ACos);
end;

procedure FastSinCos(const ARadians: TVector4; out ASin, ACos: TVector4);
begin
  _fast_sincos_vector4(@ARadians, @ASin, @ACos);
end;

function FastExp(const A: Single): Single;
begin
  Result := _fast_exp_scalar(A);
end;

function FastExp(const A: TVector2): TVector2;
begin
  _fast_exp_vector2(@A, @Result);
end;

function FastExp(const A: TVector3): TVector3;
begin
  _fast_exp_vector3(@A, @Result);
end;

function FastExp(const A: TVector4): TVector4;
begin
  _fast_exp_vector4(@A, @Result);
end;

function FastLn(const A: Single): Single;
begin
  Result := _fast_ln_scalar(A);
end;

function FastLn(const A: TVector2): TVector2;
begin
  _fast_ln_vector2(@A, @Result);
end;

function FastLn(const A: TVector3): TVector3;
begin
  _fast_ln_vector3(@A, @Result);
end;

function FastLn(const A: TVector4): TVector4;
begin
  _fast_ln_vector4(@A, @Result);
end;

function FastLog2(const A: Single): Single;
begin
  Result := _fast_log2_scalar(A);
end;

function FastLog2(const A: TVector2): TVector2;
begin
  _fast_log2_vector2(@A, @Result);
end;

function FastLog2(const A: TVector3): TVector3;
begin
  _fast_log2_vector3(@A, @Result);
end;

function FastLog2(const A: TVector4): TVector4;
begin
  _fast_log2_vector4(@A, @Result);
end;

function FastExp2(const A: Single): Single;
begin
  Result := _fast_exp2_scalar(A);
end;

function FastExp2(const A: TVector2): TVector2;
begin
  _fast_exp2_vector2(@A, @Result);
end;

function FastExp2(const A: TVector3): TVector3;
begin
  _fast_exp2_vector3(@A, @Result);
end;

function FastExp2(const A: TVector4): TVector4;
begin
  _fast_exp2_vector4(@A, @Result);
end;

{ Common Functions }

function Abs(const A: Single): Single;
begin
  Result := _abs_scalar(A);
end;

function Abs(const A: TVector2): TVector2;
begin
  _abs_vector2(@A, @Result);
end;

function Abs(const A: TVector3): TVector3;
begin
  _abs_vector3(@A, @Result);
end;

function Abs(const A: TVector4): TVector4;
begin
  _abs_vector4(@A, @Result);
end;

function Sign(const A: Single): Single;
begin
  Result := _sign_scalar(A);
end;

function Sign(const A: TVector2): TVector2;
begin
  _sign_vector2(@A, @Result);
end;

function Sign(const A: TVector3): TVector3;
begin
  _sign_vector3(@A, @Result);
end;

function Sign(const A: TVector4): TVector4;
begin
  _sign_vector4(@A, @Result);
end;

function Floor(const A: Single): Integer;
begin
  Result := _floor_scalar(A);
end;

function Floor(const A: TVector2): TIVector2;
begin
  _floor_vector2(@A, @Result);
end;

function Floor(const A: TVector3): TIVector3;
begin
  _floor_vector3(@A, @Result);
end;

function Floor(const A: TVector4): TIVector4;
begin
  _floor_vector4(@A, @Result);
end;

function Trunc(const A: Single): Integer;
begin
  Result := _trunc_scalar(A);
end;

function Trunc(const A: TVector2): TIVector2;
begin
  _trunc_vector2(@A, @Result);
end;

function Trunc(const A: TVector3): TIVector3;
begin
  _trunc_vector3(@A, @Result);
end;

function Trunc(const A: TVector4): TIVector4;
begin
  _trunc_vector4(@A, @Result);
end;

function Round(const A: Single): Integer;
begin
  Result := _round_scalar(A);
end;

function Round(const A: TVector2): TIVector2;
begin
  _round_vector2(@A, @Result);
end;

function Round(const A: TVector3): TIVector3;
begin
  _round_vector3(@A, @Result);
end;

function Round(const A: TVector4): TIVector4;
begin
  _round_vector4(@A, @Result);
end;

function Ceil(const A: Single): Integer;
begin
  Result := _ceil_scalar(A);
end;

function Ceil(const A: TVector2): TIVector2;
begin
  _ceil_vector2(@A, @Result);
end;

function Ceil(const A: TVector3): TIVector3;
begin
  _ceil_vector3(@A, @Result);
end;

function Ceil(const A: TVector4): TIVector4;
begin
  _ceil_vector4(@A, @Result);
end;

function Frac(const A: Single): Single;
begin
  Result := _frac_scalar(A);
end;

function Frac(const A: TVector2): TVector2;
begin
  _frac_vector2(@A, @Result);
end;

function Frac(const A: TVector3): TVector3;
begin
  _frac_vector3(@A, @Result);
end;

function Frac(const A: TVector4): TVector4;
begin
  _frac_vector4(@A, @Result);
end;

function FMod(const A, B: Single): Single;
begin
  Result := _fmod_scalar(A, B);
end;

function FMod(const A: TVector2; const B: Single): TVector2;
begin
  _fmod_vector2_scalar(@A, B, @Result);
end;

function FMod(const A, B: TVector2): TVector2;
begin
  _fmod_vector2(@A, @B, @Result);
end;

function FMod(const A: TVector3; const B: Single): TVector3;
begin
  _fmod_vector3_scalar(@A, B, @Result);
end;

function FMod(const A, B: TVector3): TVector3;
begin
  _fmod_vector3(@A, @B, @Result);
end;

function FMod(const A: TVector4; const B: Single): TVector4;
begin
  _fmod_vector4_scalar(@A, B, @Result);
end;

function FMod(const A, B: TVector4): TVector4;
begin
  _fmod_vector4(@A, @B, @Result);
end;

function ModF(const A: Single; out B: Integer): Single;
begin
  Result := _modf_scalar(A, @B);
end;

function ModF(const A: TVector2; out B: TIVector2): TVector2;
begin
  _modf_vector2(@A, @B, @Result);
end;

function ModF(const A: TVector3; out B: TIVector3): TVector3;
begin
  _modf_vector3(@A, @B, @Result);
end;

function ModF(const A: TVector4; out B: TIVector4): TVector4;
begin
  _modf_vector4(@A, @B, @Result);
end;

function Min(const A: TVector2; const B: Single): TVector2;
begin
  _min_vector2_scalar(@A, B, @Result);
end;

function Min(const A, B: TVector2): TVector2;
begin
  _min_vector2(@A, @B, @Result);
end;

function Min(const A: TVector3; const B: Single): TVector3;
begin
  _min_vector3_scalar(@A, B, @Result);
end;

function Min(const A, B: TVector3): TVector3;
begin
  _min_vector3(@A, @B, @Result);
end;

function Min(const A: TVector4; const B: Single): TVector4;
begin
  _min_vector4_scalar(@A, B, @Result);
end;

function Min(const A, B: TVector4): TVector4;
begin
  _min_vector4(@A, @B, @Result);
end;

function Max(const A: TVector2; const B: Single): TVector2;
begin
  _max_vector2_scalar(@A, B, @Result);
end;

function Max(const A, B: TVector2): TVector2;
begin
  _max_vector2(@A, @B, @Result);
end;

function Max(const A: TVector3; const B: Single): TVector3;
begin
  _max_vector3_scalar(@A, B, @Result);
end;

function Max(const A, B: TVector3): TVector3;
begin
  _max_vector3(@A, @B, @Result);
end;

function Max(const A: TVector4; const B: Single): TVector4;
begin
  _max_vector4_scalar(@A, B, @Result);
end;

function Max(const A, B: TVector4): TVector4;
begin
  _max_vector4(@A, @B, @Result);
end;

function EnsureRange(const A, AMin, AMax: Single): Single;
begin
  Result := _ensure_range_scalar(A, AMin, AMax);
end;

function EnsureRange(const A: TVector2; const AMin, AMax: Single): TVector2;
begin
  _ensure_range_vector2_scalar(@A, AMin, AMax, @Result);
end;

function EnsureRange(const A, AMin, AMax: TVector2): TVector2;
begin
  _ensure_range_vector2(@A, @AMin, @AMax, @Result);
end;

function EnsureRange(const A: TVector3; const AMin, AMax: Single): TVector3;
begin
  _ensure_range_vector3_scalar(@A, AMin, AMax, @Result);
end;

function EnsureRange(const A, AMin, AMax: TVector3): TVector3;
begin
  _ensure_range_vector3(@A, @AMin, @AMax, @Result);
end;

function EnsureRange(const A: TVector4; const AMin, AMax: Single): TVector4;
begin
  _ensure_range_vector4_scalar(@A, AMin, AMax, @Result);
end;

function EnsureRange(const A, AMin, AMax: TVector4): TVector4;
begin
  _ensure_range_vector4(@A, @AMin, @AMax, @Result);
end;

function Mix(const A, B: TVector2; const T: Single): TVector2;
begin
  _mix_vector2_scalar(@A, @B, T, @Result);
end;

function Mix(const A, B, T: TVector2): TVector2;
begin
  _mix_vector2(@A, @B, @T, @Result);
end;

function Mix(const A, B: TVector3; const T: Single): TVector3;
begin
  _mix_vector3_scalar(@A, @B, T, @Result);
end;

function Mix(const A, B, T: TVector3): TVector3;
begin
  _mix_vector3(@A, @B, @T, @Result);
end;

function Mix(const A, B: TVector4; const T: Single): TVector4;
begin
  _mix_vector4_scalar(@A, @B, T, @Result);
end;

function Mix(const A, B, T: TVector4): TVector4;
begin
  _mix_vector4(@A, @B, @T, @Result);
end;

function Step(const AEdge: Single; const A: TVector2): TVector2;
begin
  _step_scalar_vector2(AEdge, @A, @Result);
end;

function Step(const AEdge, A: TVector2): TVector2;
begin
  _step_vector2(@AEdge, @A, @Result);
end;

function Step(const AEdge: Single; const A: TVector3): TVector3;
begin
  _step_scalar_vector3(AEdge, @A, @Result);
end;

function Step(const AEdge, A: TVector3): TVector3;
begin
  _step_vector3(@AEdge, @A, @Result);
end;

function Step(const AEdge: Single; const A: TVector4): TVector4;
begin
  _step_scalar_vector4(AEdge, @A, @Result);
end;

function Step(const AEdge, A: TVector4): TVector4;
begin
  _step_vector4(@AEdge, @A, @Result);
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector2): TVector2;
begin
  Result.Init(SmoothStep(AEdge0, AEdge1, A.X), SmoothStep(AEdge0, AEdge1, A.Y));
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector2): TVector2;
begin
  Result.Init(SmoothStep(AEdge0.X, AEdge1.X, A.X), SmoothStep(AEdge0.Y, AEdge1.Y, A.Y));
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector3): TVector3;
begin
  Result.Init(SmoothStep(AEdge0, AEdge1, A.X), SmoothStep(AEdge0, AEdge1, A.Y), SmoothStep(AEdge0, AEdge1, A.Z));
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector3): TVector3;
begin
  Result.Init(SmoothStep(AEdge0.X, AEdge1.X, A.X), SmoothStep(AEdge0.Y, AEdge1.Y, A.Y), SmoothStep(AEdge0.Z, AEdge1.Z, A.Z));
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector4): TVector4;
begin
  Result.Init(SmoothStep(AEdge0, AEdge1, A.X), SmoothStep(AEdge0, AEdge1, A.Y), SmoothStep(AEdge0, AEdge1, A.Z), SmoothStep(AEdge0, AEdge1, A.W));
end;

{function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector2): TVector2;
begin
  _smoothstep_scalar_vector2(AEdge0, AEdge1, @A, @Result);
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector2): TVector2;
begin
  _smoothstep_vector2(@AEdge0, @AEdge1, @A, @Result);
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector3): TVector3;
begin
  _smoothstep_scalar_vector3(AEdge0, AEdge1, @A, @Result);
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector3): TVector3;
begin
  _smoothstep_vector3(@AEdge0, @AEdge1, @A, @Result);
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector4): TVector4;
begin
  _smoothstep_scalar_vector4(AEdge0, AEdge1, @A, @Result);
end;}

function SmoothStep(const AEdge0, AEdge1, A: TVector4): TVector4;
begin
  _smoothstep_vector4(@AEdge0, @AEdge1, @A, @Result);
end;

function FMA(const A, B, C: TVector2): TVector2;
begin
  _fma_vector2(@A, @B, @C, @Result);
end;

function FMA(const A, B, C: TVector3): TVector3;
begin
  _fma_vector3(@A, @B, @C, @Result);
end;

function FMA(const A, B, C: TVector4): TVector4;
begin
  _fma_vector4(@A, @B, @C, @Result);
end;

{ Matrix functions }

function OuterProduct(const C, R: TVector2): TMatrix2;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _outer_product_matrix2(@R, @C, @Result);
  {$ELSE}
  _outer_product_matrix2(@C, @R, @Result);
  {$ENDIF}
end;

function OuterProduct(const C, R: TVector3): TMatrix3;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _outer_product_matrix3(@R, @C, @Result);
  {$ELSE}
  _outer_product_matrix3(@C, @R, @Result);
  {$ENDIF}
end;

function OuterProduct(const C, R: TVector4): TMatrix4;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _outer_product_matrix4(@R, @C, @Result);
  {$ELSE}
  _outer_product_matrix4(@C, @R, @Result);
  {$ENDIF}
end;

{ TVector2 }

class operator TVector2.Add(const A: TVector2; const B: Single): TVector2;
begin
  _vector2_add_scalar(@A, B, @Result);
end;

class operator TVector2.Add(const A: Single; const B: TVector2): TVector2;
begin
  _scalar_add_vector2(A, @B, @Result);
end;

class operator TVector2.Add(const A, B: TVector2): TVector2;
begin
  _vector2_add_vector2(@A, @B, @Result);
end;

function TVector2.Distance(const AOther: TVector2): Single;
begin
  Result := _vector2_distance(@Self, @AOther);
end;

function TVector2.DistanceSquared(const AOther: TVector2): Single;
begin
  Result := _vector2_distance_squared(@Self, @AOther);
end;

class operator TVector2.Divide(const A: TVector2; const B: Single): TVector2;
begin
  _vector2_div_scalar(@A, B, @Result);
end;

class operator TVector2.Divide(const A: Single; const B: TVector2): TVector2;
begin
  _scalar_div_vector2(A, @B, @Result);
end;

class operator TVector2.Divide(const A, B: TVector2): TVector2;
begin
  _vector2_div_vector2(@A, @B, @Result);
end;

function TVector2.Dot(const AOther: TVector2): Single;
begin
  Result := _vector2_dot(@Self, @AOther);
end;

function TVector2.FaceForward(const I, NRef: TVector2): TVector2;
begin
  _vector2_faceforward(@Self, @I, @NRef, @Result);
end;

function TVector2.GetLength: Single;
begin
  Result := _vector2_length(@Self);
end;

function TVector2.GetLengthSquared: Single;
begin
  Result := _vector2_dot(@Self, @Self);
end;

class operator TVector2.Multiply(const A: TVector2; const B: Single): TVector2;
begin
  _vector2_mul_scalar(@A, B, @Result);
end;

class operator TVector2.Multiply(const A: Single; const B: TVector2): TVector2;
begin
  _scalar_mul_vector2(A, @B, @Result);
end;

class operator TVector2.Multiply(const A, B: TVector2): TVector2;
begin
  _vector2_mul_vector2(@A, @B, @Result);
end;

function TVector2.NormalizeFast: TVector2;
begin
  _vector2_normalize_fast(@Self, @Result);
end;

function TVector2.Reflect(const N: TVector2): TVector2;
begin
  _vector2_reflect(@Self, @N, @Result);
end;

function TVector2.Refract(const N: TVector2; const Eta: Single): TVector2;
begin
  _vector2_refract(@Self, @N, Eta, @Result);
end;

procedure TVector2.SetNormalizedFast;
begin
  _vector2_normalize_fast(@Self, @Self);
end;

class operator TVector2.Subtract(const A: TVector2; const B: Single): TVector2;
begin
  _vector2_sub_scalar(@A, B, @Result);
end;

class operator TVector2.Subtract(const A: Single; const B: TVector2): TVector2;
begin
  _scalar_sub_vector2(A, @B, @Result);
end;

class operator TVector2.Subtract(const A, B: TVector2): TVector2;
begin
  _vector2_sub_vector2(@A, @B, @Result);
end;

{ TVector3 }

class operator TVector3.Add(const A: TVector3; const B: Single): TVector3;
begin
  _vector3_add_scalar(@A, B, @Result);
end;

class operator TVector3.Add(const A: Single; const B: TVector3): TVector3;
begin
  _scalar_add_vector3(A, @B, @Result);
end;

class operator TVector3.Add(const A, B: TVector3): TVector3;
begin
  _vector3_add_vector3(@A, @B, @Result);
end;

function TVector3.Distance(const AOther: TVector3): Single;
begin
  Result := _vector3_distance(@Self, @AOther);
end;

function TVector3.DistanceSquared(const AOther: TVector3): Single;
begin
  Result := _vector3_distance_squared(@Self, @AOther);
end;

function TVector3.Cross(const AOther: TVector3): TVector3;
begin
  _vector3_cross(@Self, @AOther, @Result);
end;

class operator TVector3.Divide(const A: TVector3; const B: Single): TVector3;
begin
  _vector3_div_scalar(@A, B, @Result);
end;

class operator TVector3.Divide(const A: Single; const B: TVector3): TVector3;
begin
  _scalar_div_vector3(A, @B, @Result);
end;

class operator TVector3.Divide(const A, B: TVector3): TVector3;
begin
  _vector3_div_vector3(@A, @B, @Result);
end;

function TVector3.Dot(const AOther: TVector3): Single;
begin
  Result := _vector3_dot(@Self, @AOther);
end;

function TVector3.FaceForward(const I, NRef: TVector3): TVector3;
begin
  _vector3_faceforward(@Self, @I, @NRef, @Result);
end;

function TVector3.GetLength: Single;
begin
  Result := _vector3_length(@Self);
end;

function TVector3.GetLengthSquared: Single;
begin
  Result := _vector3_dot(@Self, @Self);
end;

class operator TVector3.Multiply(const A: TVector3; const B: Single): TVector3;
begin
  _vector3_mul_scalar(@A, B, @Result);
end;

class operator TVector3.Multiply(const A: Single; const B: TVector3): TVector3;
begin
  _scalar_mul_vector3(A, @B, @Result);
end;

class operator TVector3.Multiply(const A, B: TVector3): TVector3;
begin
  _vector3_mul_vector3(@A, @B, @Result);
end;

class operator TVector3.Negative(const A: TVector3): TVector3;
begin
  _neg_vector3(@A, @Result);
end;

function TVector3.NormalizeFast: TVector3;
begin
  _vector3_normalize_fast(@Self, @Result);
end;

function TVector3.Reflect(const N: TVector3): TVector3;
begin
  _vector3_reflect(@Self, @N, @Result);
end;

function TVector3.Refract(const N: TVector3; const Eta: Single): TVector3;
begin
  _vector3_refract(@Self, @N, Eta, @Result);
end;

procedure TVector3.SetNormalizedFast;
begin
  _vector3_normalize_fast(@Self, @Self);
end;

class operator TVector3.Subtract(const A: TVector3; const B: Single): TVector3;
begin
  _vector3_sub_scalar(@A, B, @Result);
end;

class operator TVector3.Subtract(const A: Single; const B: TVector3): TVector3;
begin
  _scalar_sub_vector3(A, @B, @Result);
end;

class operator TVector3.Subtract(const A, B: TVector3): TVector3;
begin
  _vector3_sub_vector3(@A, @B, @Result);
end;

{ TVector4 }

class operator TVector4.Add(const A: TVector4; const B: Single): TVector4;
begin
  _vector4_add_scalar(@A, B, @Result);
end;

class operator TVector4.Add(const A: Single; const B: TVector4): TVector4;
begin
  _scalar_add_vector4(A, @B, @Result);
end;

class operator TVector4.Add(const A, B: TVector4): TVector4;
begin
  _vector4_add_vector4(@A, @B, @Result);
end;

function TVector4.Distance(const AOther: TVector4): Single;
begin
  Result := _vector4_distance(@Self, @AOther);
end;

function TVector4.DistanceSquared(const AOther: TVector4): Single;
begin
  Result := _vector4_distance_squared(@Self, @AOther);
end;

class operator TVector4.Divide(const A: TVector4; const B: Single): TVector4;
begin
  _vector4_div_scalar(@A, B, @Result);
end;

class operator TVector4.Divide(const A: Single; const B: TVector4): TVector4;
begin
  _scalar_div_vector4(A, @B, @Result);
end;

class operator TVector4.Divide(const A, B: TVector4): TVector4;
begin
  _vector4_div_vector4(@A, @B, @Result);
end;

function TVector4.Dot(const AOther: TVector4): Single;
begin
  Result := _vector4_dot(@Self, @AOther);
end;

function TVector4.FaceForward(const I, NRef: TVector4): TVector4;
begin
  _vector4_faceforward(@Self, @I, @NRef, @Result);
end;

function TVector4.GetLength: Single;
begin
  Result := _vector4_length(@Self);
end;

function TVector4.GetLengthSquared: Single;
begin
  Result := _vector4_dot(@Self, @Self);
end;

class operator TVector4.Multiply(const A: TVector4; const B: Single): TVector4;
begin
  _vector4_mul_scalar(@A, B, @Result);
end;

class operator TVector4.Multiply(const A: Single; const B: TVector4): TVector4;
begin
  _scalar_mul_vector4(A, @B, @Result);
end;

class operator TVector4.Multiply(const A, B: TVector4): TVector4;
begin
  _vector4_mul_vector4(@A, @B, @Result);
end;

class operator TVector4.Negative(const A: TVector4): TVector4;
begin
  _neg_vector4(@A, @Result);
end;

function TVector4.NormalizeFast: TVector4;
begin
  _vector4_normalize_fast(@Self, @Result);
end;

function TVector4.Reflect(const N: TVector4): TVector4;
begin
  _vector4_reflect(@Self, @N, @Result);
end;

function TVector4.Refract(const N: TVector4; const Eta: Single): TVector4;
begin
  _vector4_refract(@Self, @N, Eta, @Result);
end;

procedure TVector4.SetNormalizedFast;
begin
  _vector4_normalize_fast(@Self, @Self);
end;

class operator TVector4.Subtract(const A: TVector4; const B: Single): TVector4;
begin
  _vector4_sub_scalar(@A, B, @Result);
end;

class operator TVector4.Subtract(const A: Single; const B: TVector4): TVector4;
begin
  _scalar_sub_vector4(A, @B, @Result);
end;

class operator TVector4.Subtract(const A, B: TVector4): TVector4;
begin
  _vector4_sub_vector4(@A, @B, @Result);
end;

{ TQuaternion }

{ Most implementations here are the same as for TVector4 }

class operator TQuaternion.Add(const A, B: TQuaternion): TQuaternion;
begin
  _vector4_add_vector4(@A, @B, @Result);
end;

function TQuaternion.GetLength: Single;
begin
  Result := _vector4_length(@Self);
end;

function TQuaternion.GetLengthSquared: Single;
begin
  Result := _vector4_dot(@Self, @Self);
end;

class operator TQuaternion.Multiply(const A: TQuaternion; const B: Single): TQuaternion;
begin
  _vector4_mul_scalar(@A, B, @Result);
end;

class operator TQuaternion.Multiply(const A: Single; const B: TQuaternion): TQuaternion;
begin
  _scalar_mul_vector4(A, @B, @Result);
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
  _vector4_normalize_fast(@Self, @Result);
end;

procedure TQuaternion.SetNormalizedFast;
begin
  _vector4_normalize_fast(@Self, @Self);
end;

{ TMatrix 2 }

class operator TMatrix2.Add(const A: TMatrix2; const B: Single): TMatrix2;
begin
  _matrix2_add_scalar(@A, B, @Result);
end;

class operator TMatrix2.Add(const A: Single; const B: TMatrix2): TMatrix2;
begin
  _scalar_add_matrix2(A, @B, @Result);
end;

class operator TMatrix2.Add(const A, B: TMatrix2): TMatrix2;
begin
  _matrix2_add_matrix2(@A, @B, @Result);
end;

function TMatrix2.CompMult(const AOther: TMatrix2): TMatrix2;
begin
  _matrix2_comp_mult(@Self, @AOther, @Result);
end;

class operator TMatrix2.Divide(const A: Single; const B: TMatrix2): TMatrix2;
begin
  _scalar_div_matrix2(A, @B, @Result);
end;

class operator TMatrix2.Divide(const A: TMatrix2; const B: Single): TMatrix2;
begin
  _matrix2_div_scalar(@A, B, @Result);
end;

class operator TMatrix2.Multiply(const A: TMatrix2; const B: Single): TMatrix2;
begin
  _matrix2_mul_scalar(@A, B, @Result);
end;

class operator TMatrix2.Multiply(const A: Single; const B: TMatrix2): TMatrix2;
begin
  _scalar_mul_matrix2(A, @B, @Result);
end;

class operator TMatrix2.Multiply(const A: TVector2; const B: TMatrix2): TVector2;
begin
  _vector2_mul_matrix2(@A, @B, @Result);
end;

class operator TMatrix2.Multiply(const A: TMatrix2; const B: TVector2): TVector2;
begin
  _matrix2_mul_vector2(@A, @B, @Result);
end;

class operator TMatrix2.Multiply(const A, B: TMatrix2): TMatrix2;
begin
  _matrix2_mul_matrix2(@A, @B, @Result);
end;

class operator TMatrix2.Negative(const A: TMatrix2): TMatrix2;
begin
  _neg_matrix2(@A, @Result);
end;

procedure TMatrix2.SetTransposed;
begin
  _matrix2_transpose(@Self, @Self);
end;

class operator TMatrix2.Subtract(const A: TMatrix2; const B: Single): TMatrix2;
begin
  _matrix2_sub_scalar(@A, B, @Result);
end;

class operator TMatrix2.Subtract(const A: Single; const B: TMatrix2): TMatrix2;
begin
  _scalar_sub_matrix2(A, @B, @Result);
end;

class operator TMatrix2.Subtract(const A, B: TMatrix2): TMatrix2;
begin
  _matrix2_sub_matrix2(@A, @B, @Result);
end;

function TMatrix2.Transpose: TMatrix2;
begin
  _matrix2_transpose(@Self, @Result);
end;

{ TMatrix3 }

class operator TMatrix3.Add(const A: TMatrix3; const B: Single): TMatrix3;
begin
  _matrix3_add_scalar(@A, B, @Result);
end;

class operator TMatrix3.Add(const A: Single; const B: TMatrix3): TMatrix3;
begin
  _scalar_add_matrix3(A, @B, @Result);
end;

class operator TMatrix3.Add(const A, B: TMatrix3): TMatrix3;
begin
  _matrix3_add_matrix3(@A, @B, @Result);
end;

function TMatrix3.CompMult(const AOther: TMatrix3): TMatrix3;
begin
  _matrix3_comp_mult(@Self, @AOther, @Result);
end;

class operator TMatrix3.Divide(const A: TMatrix3; const B: Single): TMatrix3;
begin
  _matrix3_div_scalar(@A, B, @Result);
end;

class operator TMatrix3.Divide(const A: Single; const B: TMatrix3): TMatrix3;
begin
  _scalar_div_matrix3(A, @B, @Result);
end;

class operator TMatrix3.Multiply(const A: TMatrix3; const B: Single): TMatrix3;
begin
  _matrix3_mul_scalar(@A, B, @Result);
end;

class operator TMatrix3.Multiply(const A: Single; const B: TMatrix3): TMatrix3;
begin
  _scalar_mul_matrix3(A, @B, @Result);
end;

class operator TMatrix3.Multiply(const A: TVector3; const B: TMatrix3): Tvector3;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _matrix3_mul_vector3(@B, @A, @Result);
  {$ELSE}
  _vector3_mul_matrix3(@A, @B, @Result);
  {$ENDIF}
end;

class operator TMatrix3.Multiply(const A: TMatrix3; const B: Tvector3): Tvector3;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _vector3_mul_matrix3(@B, @A, @Result);
  {$ELSE}
  _matrix3_mul_vector3(@A, @B, @Result);
  {$ENDIF}
end;

class operator TMatrix3.Multiply(const A, B: TMatrix3): TMatrix3;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _matrix3_mul_matrix3(@B, @A, @Result);
  {$ELSE}
  _matrix3_mul_matrix3(@A, @B, @Result);
  {$ENDIF}
end;

class operator TMatrix3.Negative(const A: TMatrix3): TMatrix3;
begin
  _neg_matrix3(@A, @Result);
end;

procedure TMatrix3.SetTransposed;
begin
  _matrix3_transpose(@Self, @Self);
end;

class operator TMatrix3.Subtract(const A: TMatrix3; const B: Single): TMatrix3;
begin
  _matrix3_sub_scalar(@A, B, @Result);
end;

class operator TMatrix3.Subtract(const A: Single; const B: TMatrix3): TMatrix3;
begin
  _scalar_sub_matrix3(A, @B, @Result);
end;

class operator TMatrix3.Subtract(const A, B: TMatrix3): TMatrix3;
begin
  _matrix3_sub_matrix3(@A, @B, @Result);
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
{function TMatrix3.Transpose: TMatrix3;
begin
  _matrix3_transpose(@Self, @Result);
end;}

{ TMatrix4 }

class operator TMatrix4.Add(const A: TMatrix4; const B: Single): TMatrix4;
begin
  _matrix4_add_scalar(@A, B, @Result);
end;

class operator TMatrix4.Add(const A: Single; const B: TMatrix4): TMatrix4;
begin
  _scalar_add_matrix4(A, @B, @Result);
end;

class operator TMatrix4.Add(const A, B: TMatrix4): TMatrix4;
begin
  _matrix4_add_matrix4(@A, @B, @Result);
end;

function TMatrix4.CompMult(const AOther: TMatrix4): TMatrix4;
begin
  _matrix4_comp_mult(@Self, @AOther, @Result);
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: Single): TMatrix4;
begin
  _matrix4_div_scalar(@A, B, @Result);
end;

class operator TMatrix4.Divide(const A: Single; const B: TMatrix4): TMatrix4;
begin
  _scalar_div_matrix4(A, @B, @Result);
end;

function TMatrix4.Inverse: TMatrix4;
begin
  _matrix4_inverse(@Self, @Result);
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: Single): TMatrix4;
begin
  _matrix4_mul_scalar(@A, B, @Result);
end;

class operator TMatrix4.Multiply(const A: Single; const B: TMatrix4): TMatrix4;
begin
  _scalar_mul_matrix4(A, @B, @Result);
end;

class operator TMatrix4.Multiply(const A: TVector4; const B: TMatrix4): TVector4;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _matrix4_mul_vector4(@B, @A, @Result);
  {$ELSE}
  _vector4_mul_matrix4(@A, @B, @Result);
  {$ENDIF}
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: TVector4): TVector4;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _vector4_mul_matrix4(@B, @A, @Result);
  {$ELSE}
  _matrix4_mul_vector4(@A, @B, @Result);
  {$ENDIF}
end;

class operator TMatrix4.Multiply(const A, B: TMatrix4): TMatrix4;
begin
  {$IFDEF FM_COLUMN_MAJOR}
  _matrix4_mul_matrix4(@B, @A, @Result);
  {$ELSE}
  _matrix4_mul_matrix4(@A, @B, @Result);
  {$ENDIF}
end;

class operator TMatrix4.Negative(const A: TMatrix4): TMatrix4;
begin
  _neg_matrix4(@A, @Result);
end;

procedure TMatrix4.SetInversed;
begin
  _matrix4_inverse(@Self, @Self);
end;

procedure TMatrix4.SetTransposed;
begin
  _matrix4_transpose(@Self, @Self);
end;

class operator TMatrix4.Subtract(const A: TMatrix4; const B: Single): TMatrix4;
begin
  _matrix4_sub_scalar(@A, B, @Result);
end;

class operator TMatrix4.Subtract(const A: Single; const B: TMatrix4): TMatrix4;
begin
  _scalar_sub_matrix4(A, @B, @Result);
end;

class operator TMatrix4.Subtract(const A, B: TMatrix4): TMatrix4;
begin
  _matrix4_sub_matrix4(@A, @B, @Result);
end;

function TMatrix4.Transpose: TMatrix4;
begin
  _matrix4_transpose(@Self, @Result);
end;
