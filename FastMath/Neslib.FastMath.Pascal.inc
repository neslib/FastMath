{ Angle and Trigonometry Functions }

function Radians(const ADegrees: Single): Single;
begin
  Result := ADegrees * (Pi / 180);
end;

function Radians(const ADegrees: TVector2): TVector2;
begin
  Result.Init(Radians(ADegrees.X), Radians(ADegrees.Y));
end;

function Radians(const ADegrees: TVector3): TVector3;
begin
  Result.Init(Radians(ADegrees.X), Radians(ADegrees.Y), Radians(ADegrees.Z));
end;

function Radians(const ADegrees: TVector4): TVector4;
begin
  Result.Init(Radians(ADegrees.X), Radians(ADegrees.Y), Radians(ADegrees.Z), Radians(ADegrees.W));
end;

function Degrees(const ARadians: Single): Single;
begin
  Result := ARadians * (180 / Pi);
end;

function Degrees(const ARadians: TVector2): TVector2;
begin
  Result.Init(Degrees(ARadians.X), Degrees(ARadians.Y));
end;

function Degrees(const ARadians: TVector3): TVector3;
begin
  Result.Init(Degrees(ARadians.X), Degrees(ARadians.Y), Degrees(ARadians.Z));
end;

function Degrees(const ARadians: TVector4): TVector4;
begin
  Result.Init(Degrees(ARadians.X), Degrees(ARadians.Y), Degrees(ARadians.Z), Degrees(ARadians.W));
end;

{ Exponential Functions }

function Sqrt(const A: Single): Single;
begin
  Result := System.Sqrt(A);
end;

function Sqrt(const A: TVector2): TVector2;
begin
  Result.Init(System.Sqrt(A.X), System.Sqrt(A.Y));
end;

function Sqrt(const A: TVector3): TVector3;
begin
  Result.Init(System.Sqrt(A.X), System.Sqrt(A.Y), System.Sqrt(A.Z));
end;

function Sqrt(const A: TVector4): TVector4;
begin
  Result.Init(System.Sqrt(A.X), System.Sqrt(A.Y), System.Sqrt(A.Z), System.Sqrt(A.W));
end;

function InverseSqrt(const A: Single): Single;
begin
  Result := 1 / Sqrt(A)
end;

function InverseSqrt(const A: TVector2): TVector2;
begin
  Result.Init(InverseSqrt(A.X), InverseSqrt(A.Y));
end;

function InverseSqrt(const A: TVector3): TVector3;
begin
  Result.Init(InverseSqrt(A.X), InverseSqrt(A.Y), InverseSqrt(A.Z));
end;

function InverseSqrt(const A: TVector4): TVector4;
begin
  Result.Init(InverseSqrt(A.X), InverseSqrt(A.Y), InverseSqrt(A.Z), InverseSqrt(A.W));
end;

{ Fast approximate Functions }

function FastSin(const ARadians: Single): Single;
const
  FOPI = 1.27323954473516;
  SINCOF_P0 = -1.9515295891E-4;
  SINCOF_P1 = 8.3321608736E-3;
  SINCOF_P2 = -1.6666654611E-1;
  COSCOF_P0 = 2.443315711809948E-005;
  COSCOF_P1 = -1.388731625493765E-003;
  COSCOF_P2 = 4.166664568298827E-002;
var
  X, Y, Z: Single;
  XBits: Cardinal absolute X;
  YBits: Cardinal absolute Y;
  SignBit: Cardinal;
  J: Integer;
begin
  X := ARadians;
  SignBit := XBits and $80000000;
  XBits := XBits and $7FFFFFFF;

  J := Trunc(FOPI * X);
  J := (J + 1) and (not 1);
  Y := J;

  J := J and 7;
  if (J > 3) then
  begin
    SignBit := SignBit xor $80000000;
    Dec(J, 4);
  end;

  X := X - Y * (0.25 * Pi);
  Z := X * X;
  if (J = 1) or (J = 2) then
  begin
    Y := COSCOF_P0 * Z + COSCOF_P1;
    Y := Y * Z + COSCOF_P2;
    Y := Y * (Z * Z);
    Y := Y - 0.5 * Z + 1;
  end
  else
  begin
    Y := SINCOF_P0 * Z + SINCOF_P1;
    Y := Y * Z + SINCOF_P2;
    Y := Y * (Z * X);
    Y := Y + X;
  end;

  YBits := YBits xor SignBit;
  Result := Y;
end;

function FastSin(const ARadians: TVector2): TVector2;
begin
  Result.Init(FastSin(ARadians.X), FastSin(ARadians.Y));
end;

function FastSin(const ARadians: TVector3): TVector3;
begin
  Result.Init(FastSin(ARadians.X), FastSin(ARadians.Y), FastSin(ARadians.Z));
end;

function FastSin(const ARadians: TVector4): TVector4;
begin
  Result.Init(FastSin(ARadians.X), FastSin(ARadians.Y), FastSin(ARadians.Z), FastSin(ARadians.W));
end;

function FastCos(const ARadians: Single): Single;
const
  FOPI = 1.27323954473516;
  SINCOF_P0 = -1.9515295891E-4;
  SINCOF_P1 = 8.3321608736E-3;
  SINCOF_P2 = -1.6666654611E-1;
  COSCOF_P0 = 2.443315711809948E-005;
  COSCOF_P1 = -1.388731625493765E-003;
  COSCOF_P2 = 4.166664568298827E-002;
var
  X, Y, Z: Single;
  XBits: Cardinal absolute X;
  YBits: Cardinal absolute Y;
  SignBit: Cardinal;
  J: Integer;
begin
  X := ARadians;
  SignBit := 0;
  XBits := XBits and $7FFFFFFF;

  J := Trunc(FOPI * X);
  J := (J + 1) and (not 1);
  Y := J;

  J := J and 7;
  if (J > 3) then
  begin
    SignBit := $80000000;
    Dec(J, 4);
  end;

  if (J > 1) then
    SignBit := SignBit xor $80000000;

  X := X - Y * (0.25 * Pi);
  Z := X * X;
  if (J = 1) or (J = 2) then
  begin
    Y := SINCOF_P0 * Z + SINCOF_P1;
    Y := Y * Z + SINCOF_P2;
    Y := Y * (Z * X);
    Y := Y + X;
  end
  else
  begin
    Y := COSCOF_P0 * Z + COSCOF_P1;
    Y := Y * Z + COSCOF_P2;
    Y := Y * (Z * Z);
    Y := Y - 0.5 * Z + 1;
  end;

  YBits := YBits xor SignBit;
  Result := Y;
end;

function FastCos(const ARadians: TVector2): TVector2;
begin
  Result.Init(FastCos(ARadians.X), FastCos(ARadians.Y));
end;

function FastCos(const ARadians: TVector3): TVector3;
begin
  Result.Init(FastCos(ARadians.X), FastCos(ARadians.Y), FastCos(ARadians.Z));
end;

function FastCos(const ARadians: TVector4): TVector4;
begin
  Result.Init(FastCos(ARadians.X), FastCos(ARadians.Y), FastCos(ARadians.Z), FastCos(ARadians.W));
end;

procedure FastSinCos(const ARadians: Single; out ASin, ACos: Single);
const
  FOPI = 1.27323954473516;
  SINCOF_P0 = -1.9515295891E-4;
  SINCOF_P1 = 8.3321608736E-3;
  SINCOF_P2 = -1.6666654611E-1;
  COSCOF_P0 = 2.443315711809948E-005;
  COSCOF_P1 = -1.388731625493765E-003;
  COSCOF_P2 = 4.166664568298827E-002;
var
  ASinBits: Cardinal absolute ASin;
  ACosBits: Cardinal absolute ACos;
  SignBitSin, SwapSignBitSin, SignBitCos: Cardinal;
  X, Y, Y2, Z: Single;
  XBits: Cardinal absolute X;
  J: Integer;
begin
  X := ARadians;
  SignBitSin := (XBits and $80000000);
  XBits := XBits and $7FFFFFFF;
  J := (Trunc(FOPI * X) + 1) and (not 1);
  Y := J;
  SwapSignBitSin := (J and 4) shl 29;

  X := X - Y * (0.25 * Pi);

  SignBitCos := (4 and (not (J - 2))) shl 29;
  SignBitSin := SignBitSin xor SwapSignBitSin;

  Z := X * X;

  Y := COSCOF_P0 * Z + COSCOF_P1;
  Y := Y * Z + COSCOF_P2;
  Y := Y * (Z * Z) - (0.5 * Z) + 1;

  Y2 := SINCOF_P0 * Z + SINCOF_P1;
  Y2 := Y2 * Z + SINCOF_P2;
  Y2 := Y2 * (Z * X) + X;

  if ((J and 2) = 0) then
  begin
    ASin := Y2;
    ACos := Y;
  end
  else
  begin
    ASin := Y;
    ACos := Y2;
  end;

  ASinBits := ASinBits xor SignBitSin;
  ACosBits := ACosBits xor SignBitCos;
end;

procedure FastSinCos(const ARadians: TVector2; out ASin, ACos: TVector2);
begin
  FastSinCos(ARadians.X, ASin.X, ACos.X);
  FastSinCos(ARadians.Y, ASin.Y, ACos.Y);
end;

procedure FastSinCos(const ARadians: TVector3; out ASin, ACos: TVector3);
begin
  FastSinCos(ARadians.X, ASin.X, ACos.X);
  FastSinCos(ARadians.Y, ASin.Y, ACos.Y);
  FastSinCos(ARadians.Z, ASin.Z, ACos.Z);
end;

procedure FastSinCos(const ARadians: TVector4; out ASin, ACos: TVector4);
begin
  FastSinCos(ARadians.X, ASin.X, ACos.X);
  FastSinCos(ARadians.Y, ASin.Y, ACos.Y);
  FastSinCos(ARadians.Z, ASin.Z, ACos.Z);
  FastSinCos(ARadians.W, ASin.W, ACos.W);
end;

function FastExp(const A: Single): Single;
const
  EXP_CST = 2139095040.0;
var
  Val, B: Single;
  IVal: Integer;
  XU, XU2: record
    case Byte of
      0: (I: Integer);
      1: (S: Single);
  end;
begin
  Val := 12102203.1615614 * A + 1065353216.0;

  if (Val >= EXP_CST) then
    Val := EXP_CST;

  if (Val > 0) then
    IVal := Trunc(Val)
  else
    IVal := 0;

  XU.I := IVal and $7F800000;
  XU2.I := (IVal and $007FFFFF) or $3F800000;
  B := XU2.S;

  Result := XU.S *
    ( 0.509964287281036376953125 + B *
    ( 0.3120158612728118896484375 + B *
    ( 0.1666135489940643310546875 + B *
    (-2.12528370320796966552734375e-3 + B *
      1.3534179888665676116943359375e-2))));
end;

function FastExp(const A: TVector2): TVector2;
begin
  Result.Init(FastExp(A.X), FastExp(A.Y));
end;

function FastExp(const A: TVector3): TVector3;
begin
  Result.Init(FastExp(A.X), FastExp(A.Y), FastExp(A.Z));
end;

function FastExp(const A: TVector4): TVector4;
begin
  Result.Init(FastExp(A.X), FastExp(A.Y), FastExp(A.Z), FastExp(A.W));
end;

function FastLn(const A: Single): Single;
var
  Exp, AddCst, X, X2: Single;
  Val: record
    case Byte of
      0: (S: Single);
      1: (I: Integer);
  end;
begin
  Val.S := A;
  Exp := Val.I shr 23;
  if (A > 0) then
    AddCst := -89.93423858
  else
    AddCst := NegInfinity;

  Val.I := (Val.I and $007FFFFF) or $3F800000;
  X := Val.S;
  X2 := X * X;

  Result :=
    (3.3977745 * X + AddCst) +
    X2 * ((X - 2.2744832) +
    X2 * (0.024982445 * X - 0.24371102)) +
    0.69314718055995 * Exp;
end;

function FastLn(const A: TVector2): TVector2;
begin
  Result.Init(FastLn(A.X), FastLn(A.Y));
end;

function FastLn(const A: TVector3): TVector3;
begin
  Result.Init(FastLn(A.X), FastLn(A.Y), FastLn(A.Z));
end;

function FastLn(const A: TVector4): TVector4;
begin
  Result.Init(FastLn(A.X), FastLn(A.Y), FastLn(A.Z), FastLn(A.W));
end;

function FastLog2(const A: Single): Single;
var
  MX, VX: record
  case Byte of
    0: (S: Single);
    1: (I: UInt32);
  end;
begin
  VX.S := A;
  MX.I := (VX.I and $007FFFFF) or $3F000000;
  Result := VX.I * 1.1920928955078125e-7;
  Result := Result
    - 124.22551499
    - 1.498030302 * MX.S
    - 1.72587999 / (0.3520887068 + MX.S);
end;

function FastLog2(const A: TVector2): TVector2;
begin
  Result.Init(FastLog2(A.X), FastLog2(A.Y));
end;

function FastLog2(const A: TVector3): TVector3;
begin
  Result.Init(FastLog2(A.X), FastLog2(A.Y), FastLog2(A.Z));
end;

function FastLog2(const A: TVector4): TVector4;
begin
  Result.Init(FastLog2(A.X), FastLog2(A.Y), FastLog2(A.Z), FastLog2(A.W));
end;

function FastExp2(const A: Single): Single;
var
  Offset, Z: Single;
  V: record
  case Byte of
    0: (S: Single);
    1: (I: UInt32);
  end;
begin
  if (A < 0) then
    Offset := 1
  else
    Offset := 0;
  Z := A - Trunc(A) + Offset;
  V.I := Trunc((1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z));
  Result := V.S;
end;

function FastExp2(const A: TVector2): TVector2;
begin
  Result.Init(FastExp2(A.X), FastExp2(A.Y));
end;

function FastExp2(const A: TVector3): TVector3;
begin
  Result.Init(FastExp2(A.X), FastExp2(A.Y), FastExp2(A.Z));
end;

function FastExp2(const A: TVector4): TVector4;
begin
  Result.Init(FastExp2(A.X), FastExp2(A.Y), FastExp2(A.Z), FastExp2(A.W));
end;

{ Common Functions }

function Abs(const A: Single): Single;
begin
  Result := System.Abs(A);
end;

function Abs(const A: TVector2): TVector2;
begin
  Result.Init(System.Abs(A.X), System.Abs(A.Y));
end;

function Abs(const A: TVector3): TVector3;
begin
  Result.Init(System.Abs(A.X), System.Abs(A.Y), System.Abs(A.Z));
end;

function Abs(const A: TVector4): TVector4;
begin
  Result.Init(System.Abs(A.X), System.Abs(A.Y), System.Abs(A.Z), System.Abs(A.W));
end;

function Sign(const A: Single): Single;
begin
  Result := System.Math.Sign(A);
end;

function Sign(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.Sign(A.X), System.Math.Sign(A.Y));
end;

function Sign(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.Sign(A.X), System.Math.Sign(A.Y), System.Math.Sign(A.Z));
end;

function Sign(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.Sign(A.X), System.Math.Sign(A.Y), System.Math.Sign(A.Z), System.Math.Sign(A.W));
end;

function Floor(const A: Single): Integer;
begin
  Result := System.Math.Floor(A);
end;

function Floor(const A: TVector2): TIVector2;
begin
  Result.Init(System.Math.Floor(A.X), System.Math.Floor(A.Y));
end;

function Floor(const A: TVector3): TIVector3;
begin
  Result.Init(System.Math.Floor(A.X), System.Math.Floor(A.Y), System.Math.Floor(A.Z));
end;

function Floor(const A: TVector4): TIVector4;
begin
  Result.Init(System.Math.Floor(A.X), System.Math.Floor(A.Y), System.Math.Floor(A.Z), System.Math.Floor(A.W));
end;

function Trunc(const A: Single): Integer;
begin
  Result := System.Trunc(A);
end;

function Trunc(const A: TVector2): TIVector2;
begin
  Result.Init(System.Trunc(A.X), System.Trunc(A.Y));
end;

function Trunc(const A: TVector3): TIVector3;
begin
  Result.Init(System.Trunc(A.X), System.Trunc(A.Y), System.Trunc(A.Z));
end;

function Trunc(const A: TVector4): TIVector4;
begin
  Result.Init(System.Trunc(A.X), System.Trunc(A.Y), System.Trunc(A.Z), System.Trunc(A.W));
end;

function Round(const A: Single): Integer;
begin
  Result := System.Round(A);
end;

function Round(const A: TVector2): TIVector2;
begin
  Result.Init(System.Round(A.X), System.Round(A.Y));
end;

function Round(const A: TVector3): TIVector3;
begin
  Result.Init(System.Round(A.X), System.Round(A.Y), System.Round(A.Z));
end;

function Round(const A: TVector4): TIVector4;
begin
  Result.Init(System.Round(A.X), System.Round(A.Y), System.Round(A.Z), System.Round(A.W));
end;

function Ceil(const A: Single): Integer;
begin
  Result := System.Math.Ceil(A);
end;

function Ceil(const A: TVector2): TIVector2;
begin
  Result.Init(System.Math.Ceil(A.X), System.Math.Ceil(A.Y));
end;

function Ceil(const A: TVector3): TIVector3;
begin
  Result.Init(System.Math.Ceil(A.X), System.Math.Ceil(A.Y), System.Math.Ceil(A.Z));
end;

function Ceil(const A: TVector4): TIVector4;
begin
  Result.Init(System.Math.Ceil(A.X), System.Math.Ceil(A.Y), System.Math.Ceil(A.Z), System.Math.Ceil(A.W));
end;

function Frac(const A: Single): Single;
begin
  Result := System.Frac(A);
end;

function Frac(const A: TVector2): TVector2;
begin
  Result.Init(System.Frac(A.X), System.Frac(A.Y));
end;

function Frac(const A: TVector3): TVector3;
begin
  Result.Init(System.Frac(A.X), System.Frac(A.Y), System.Frac(A.Z));
end;

function Frac(const A: TVector4): TVector4;
begin
  Result.Init(System.Frac(A.X), System.Frac(A.Y), System.Frac(A.Z), System.Frac(A.W));
end;

function FMod(const A, B: Single): Single;
begin
  Result := A - (B * Trunc(A / B));
end;

function FMod(const A: TVector2; const B: Single): TVector2;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B), Neslib.FastMath.FMod(A.Y, B));
end;

function FMod(const A, B: TVector2): TVector2;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B.X), Neslib.FastMath.FMod(A.Y, B.Y));
end;

function FMod(const A: TVector3; const B: Single): TVector3;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B), Neslib.FastMath.FMod(A.Y, B), Neslib.FastMath.FMod(A.Z, B));
end;

function FMod(const A, B: TVector3): TVector3;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B.X), Neslib.FastMath.FMod(A.Y, B.Y), Neslib.FastMath.FMod(A.Z, B.Z));
end;

function FMod(const A: TVector4; const B: Single): TVector4;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B), Neslib.FastMath.FMod(A.Y, B), Neslib.FastMath.FMod(A.Z, B), Neslib.FastMath.FMod(A.W, B));
end;

function FMod(const A, B: TVector4): TVector4;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B.X), Neslib.FastMath.FMod(A.Y, B.Y), Neslib.FastMath.FMod(A.Z, B.Z), Neslib.FastMath.FMod(A.W, B.W));
end;

function ModF(const A: Single; out B: Integer): Single;
begin
  B := Trunc(A);
  Result := Frac(A);
end;

function ModF(const A: TVector2; out B: TIVector2): TVector2;
begin
  Result.Init(ModF(A.X, B.X), ModF(A.Y, B.Y));
end;

function ModF(const A: TVector3; out B: TIVector3): TVector3;
begin
  Result.Init(ModF(A.X, B.X), ModF(A.Y, B.Y), ModF(A.Z, B.Z));
end;

function ModF(const A: TVector4; out B: TIVector4): TVector4;
begin
  Result.Init(ModF(A.X, B.X), ModF(A.Y, B.Y), ModF(A.Z, B.Z), ModF(A.W, B.W));
end;

function Min(const A: TVector2; const B: Single): TVector2;
begin
  Result.Init(System.Math.Min(A.X, B), System.Math.Min(A.Y, B));
end;

function Min(const A, B: TVector2): TVector2;
begin
  Result.Init(System.Math.Min(A.X, B.X), System.Math.Min(A.Y, B.Y));
end;

function Min(const A: TVector3; const B: Single): TVector3;
begin
  Result.Init(System.Math.Min(A.X, B), System.Math.Min(A.Y, B), System.Math.Min(A.Z, B));
end;

function Min(const A, B: TVector3): TVector3;
begin
  Result.Init(System.Math.Min(A.X, B.X), System.Math.Min(A.Y, B.Y), System.Math.Min(A.Z, B.Z));
end;

function Min(const A: TVector4; const B: Single): TVector4;
begin
  Result.Init(System.Math.Min(A.X, B), System.Math.Min(A.Y, B), System.Math.Min(A.Z, B), System.Math.Min(A.W, B));
end;

function Min(const A, B: TVector4): TVector4;
begin
  Result.Init(System.Math.Min(A.X, B.X), System.Math.Min(A.Y, B.Y), System.Math.Min(A.Z, B.Z), System.Math.Min(A.W, B.W));
end;

function Max(const A: TVector2; const B: Single): TVector2;
begin
  Result.Init(System.Math.Max(A.X, B), System.Math.Max(A.Y, B));
end;

function Max(const A, B: TVector2): TVector2;
begin
  Result.Init(System.Math.Max(A.X, B.X), System.Math.Max(A.Y, B.Y));
end;

function Max(const A: TVector3; const B: Single): TVector3;
begin
  Result.Init(System.Math.Max(A.X, B), System.Math.Max(A.Y, B), System.Math.Max(A.Z, B));
end;

function Max(const A, B: TVector3): TVector3;
begin
  Result.Init(System.Math.Max(A.X, B.X), System.Math.Max(A.Y, B.Y), System.Math.Max(A.Z, B.Z));
end;

function Max(const A: TVector4; const B: Single): TVector4;
begin
  Result.Init(System.Math.Max(A.X, B), System.Math.Max(A.Y, B), System.Math.Max(A.Z, B), System.Math.Max(A.W, B));
end;

function Max(const A, B: TVector4): TVector4;
begin
  Result.Init(System.Math.Max(A.X, B.X), System.Math.Max(A.Y, B.Y), System.Math.Max(A.Z, B.Z), System.Math.Max(A.W, B.W));
end;

function EnsureRange(const A, AMin, AMax: Single): Single;
begin
  Result := System.Math.EnsureRange(A, AMin, AMax);
end;

function EnsureRange(const A: TVector2; const AMin, AMax: Single): TVector2;
begin
  Result.Init(System.Math.EnsureRange(A.X, AMin, AMax), System.Math.EnsureRange(A.Y, AMin, AMax));
end;

function EnsureRange(const A, AMin, AMax: TVector2): TVector2;
begin
  Result.Init(System.Math.EnsureRange(A.X, AMin.X, AMax.X), System.Math.EnsureRange(A.Y, AMin.Y, AMax.Y));
end;

function EnsureRange(const A: TVector3; const AMin, AMax: Single): TVector3;
begin
  Result.Init(System.Math.EnsureRange(A.X, AMin, AMax), System.Math.EnsureRange(A.Y, AMin, AMax), System.Math.EnsureRange(A.Z, AMin, AMax));
end;

function EnsureRange(const A, AMin, AMax: TVector3): TVector3;
begin
  Result.Init(System.Math.EnsureRange(A.X, AMin.X, AMax.X), System.Math.EnsureRange(A.Y, AMin.Y, AMax.Y), System.Math.EnsureRange(A.Z, AMin.Z, AMax.Z));
end;

function EnsureRange(const A: TVector4; const AMin, AMax: Single): TVector4;
begin
  Result.Init(System.Math.EnsureRange(A.X, AMin, AMax), System.Math.EnsureRange(A.Y, AMin, AMax), System.Math.EnsureRange(A.Z, AMin, AMax), System.Math.EnsureRange(A.W, AMin, AMax));
end;

function EnsureRange(const A, AMin, AMax: TVector4): TVector4;
begin
  Result.Init(System.Math.EnsureRange(A.X, AMin.X, AMax.X), System.Math.EnsureRange(A.Y, AMin.Y, AMax.Y), System.Math.EnsureRange(A.Z, AMin.Z, AMax.Z), System.Math.EnsureRange(A.W, AMin.W, AMax.W));
end;

function Mix(const A, B: TVector2; const T: Single): TVector2;
begin
  Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T));
end;

function Mix(const A, B, T: TVector2): TVector2;
begin
  Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y));
end;

function Mix(const A, B: TVector3; const T: Single): TVector3;
begin
  Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T), Mix(A.Z, B.Z, T));
end;

function Mix(const A, B, T: TVector3): TVector3;
begin
  Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y), Mix(A.Z, B.Z, T.Z));
end;

function Mix(const A, B: TVector4; const T: Single): TVector4;
begin
  Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T), Mix(A.Z, B.Z, T), Mix(A.W, B.W, T));
end;

function Mix(const A, B, T: TVector4): TVector4;
begin
  Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y), Mix(A.Z, B.Z, T.Z), Mix(A.W, B.W, T.W));
end;

function Step(const AEdge: Single; const A: TVector2): TVector2;
begin
  Result.Init(Step(AEdge, A.X), Step(AEdge, A.Y));
end;

function Step(const AEdge, A: TVector2): TVector2;
begin
  Result.Init(Step(AEdge.X, A.X), Step(AEdge.Y, A.Y));
end;

function Step(const AEdge: Single; const A: TVector3): TVector3;
begin
  Result.Init(Step(AEdge, A.X), Step(AEdge, A.Y), Step(AEdge, A.Z));
end;

function Step(const AEdge, A: TVector3): TVector3;
begin
  Result.Init(Step(AEdge.X, A.X), Step(AEdge.Y, A.Y), Step(AEdge.Z, A.Z));
end;

function Step(const AEdge: Single; const A: TVector4): TVector4;
begin
  Result.Init(Step(AEdge, A.X), Step(AEdge, A.Y), Step(AEdge, A.Z), Step(AEdge, A.W));
end;

function Step(const AEdge, A: TVector4): TVector4;
begin
  Result.Init(Step(AEdge.X, A.X), Step(AEdge.Y, A.Y), Step(AEdge.Z, A.Z), Step(AEdge.W, A.W));
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

function SmoothStep(const AEdge0, AEdge1, A: TVector4): TVector4;
begin
  Result.Init(SmoothStep(AEdge0.X, AEdge1.X, A.X), SmoothStep(AEdge0.Y, AEdge1.Y, A.Y), SmoothStep(AEdge0.Z, AEdge1.Z, A.Z), SmoothStep(AEdge0.W, AEdge1.W, A.W));
end;

function FMA(const A, B, C: TVector2): TVector2;
begin
  Result.Init(FMA(A.X, B.X, C.X), FMA(A.Y, B.Y, C.Y));
end;

function FMA(const A, B, C: TVector3): TVector3;
begin
  Result.Init(FMA(A.X, B.X, C.X), FMA(A.Y, B.Y, C.Y), FMA(A.Z, B.Z, C.Z));
end;

function FMA(const A, B, C: TVector4): TVector4;
begin
  Result.Init(FMA(A.X, B.X, C.X), FMA(A.Y, B.Y, C.Y), FMA(A.Z, B.Z, C.Z), FMA(A.W, B.W, C.W));
end;

{ Matrix functions }

{$IFDEF FM_COLUMN_MAJOR}
function OuterProduct(const C, R: TVector2): TMatrix2;
var
  I: Integer;
begin
  for I := 0 to 1 do
    Result.C[I] := C * R.C[I];
end;

function OuterProduct(const C, R: TVector3): TMatrix3;
var
  I: Integer;
begin
  for I := 0 to 2 do
    Result.C[I] := C * R.C[I];
end;

function OuterProduct(const C, R: TVector4): TMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.C[I] := C * R.C[I];
end;
{$ELSE}
function OuterProduct(const C, R: TVector2): TMatrix2;
var
  I: Integer;
begin
  for I := 0 to 1 do
    Result.R[I] := R * C.C[I];
end;

function OuterProduct(const C, R: TVector3): TMatrix3;
var
  I: Integer;
begin
  for I := 0 to 2 do
    Result.R[I] := R * C.C[I];
end;

function OuterProduct(const C, R: TVector4): TMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.R[I] := R * C.C[I];
end;
{$ENDIF}

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

class operator TVector2.Divide(const A: TVector2; const B: Single): TVector2;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.X := A.X * InvB;
  Result.Y := A.Y * InvB;
end;

class operator TVector2.Divide(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A / B.X;
  Result.Y := A / B.Y;
end;

class operator TVector2.Divide(const A, B: TVector2): TVector2;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

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

function TVector2.NormalizeFast: TVector2;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

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

procedure TVector2.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

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

class operator TVector3.Add(const A: TVector3; const B: Single): TVector3;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
end;

class operator TVector3.Add(const A: Single; const B: TVector3): TVector3;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
  Result.Z := A + B.Z;
end;

class operator TVector3.Add(const A, B: TVector3): TVector3;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
end;

function TVector3.Distance(const AOther: TVector3): Single;
begin
  Result := (Self - AOther).Length;
end;

function TVector3.DistanceSquared(const AOther: TVector3): Single;
begin
  Result := (Self - AOther).LengthSquared;
end;

class operator TVector3.Divide(const A: TVector3; const B: Single): TVector3;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.X := A.X * InvB;
  Result.Y := A.Y * InvB;
  Result.Z := A.Z * InvB;
end;

class operator TVector3.Divide(const A: Single; const B: TVector3): TVector3;
begin
  Result.X := A / B.X;
  Result.Y := A / B.Y;
  Result.Z := A / B.Z;
end;

class operator TVector3.Divide(const A, B: TVector3): TVector3;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
  Result.Z := A.Z / B.Z;
end;

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

function TVector3.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z));
end;

function TVector3.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z);
end;

class operator TVector3.Multiply(const A: TVector3; const B: Single): TVector3;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
end;

class operator TVector3.Multiply(const A: Single; const B: TVector3): TVector3;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
end;

class operator TVector3.Multiply(const A, B: TVector3): TVector3;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
end;

class operator TVector3.Negative(const A: TVector3): TVector3;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
end;

function TVector3.NormalizeFast: TVector3;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

function TVector3.Reflect(const N: TVector3): TVector3;
begin
  Result := Self - ((2 * N.Dot(Self)) * N);
end;

function TVector3.Refract(const N: TVector3; const Eta: Single): TVector3;
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

procedure TVector3.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

class operator TVector3.Subtract(const A: TVector3; const B: Single): TVector3;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
end;

class operator TVector3.Subtract(const A: Single; const B: TVector3): TVector3;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
  Result.Z := A - B.Z;
end;

class operator TVector3.Subtract(const A, B: TVector3): TVector3;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
end;

{ TVector4 }

class operator TVector4.Add(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TVector4.Add(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
  Result.Z := A + B.Z;
  Result.W := A + B.W;
end;

class operator TVector4.Add(const A, B: TVector4): TVector4;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

function TVector4.Distance(const AOther: TVector4): Single;
begin
  Result := (Self - AOther).Length;
end;

function TVector4.DistanceSquared(const AOther: TVector4): Single;
begin
  Result := (Self - AOther).LengthSquared;
end;

class operator TVector4.Divide(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TVector4.Divide(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A / B.X;
  Result.Y := A / B.Y;
  Result.Z := A / B.Z;
  Result.W := A / B.W;
end;

class operator TVector4.Divide(const A, B: TVector4): TVector4;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
  Result.Z := A.Z / B.Z;
  Result.W := A.W / B.W;
end;

function TVector4.Dot(const AOther: TVector4): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z) + (W * AOther.W);
end;

function TVector4.FaceForward(const I, NRef: TVector4): TVector4;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

function TVector4.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end;

function TVector4.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z) + (W * W);
end;

class operator TVector4.Multiply(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TVector4.Multiply(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
  Result.W := A * B.W;
end;

class operator TVector4.Multiply(const A, B: TVector4): TVector4;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TVector4.Negative(const A: TVector4): TVector4;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

function TVector4.NormalizeFast: TVector4;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

function TVector4.Reflect(const N: TVector4): TVector4;
begin
  Result := Self - ((2 * N.Dot(Self)) * N);
end;

function TVector4.Refract(const N: TVector4; const Eta: Single): TVector4;
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

procedure TVector4.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

class operator TVector4.Subtract(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TVector4.Subtract(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
  Result.Z := A - B.Z;
  Result.W := A - B.W;
end;

class operator TVector4.Subtract(const A, B: TVector4): TVector4;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

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
