var
  PrevFloatingPointExceptions: TArithmeticExceptionMask = DefaultExceptionFlags;

{$WARN SYMBOL_PLATFORM OFF}
procedure DisableFloatingPointExceptions;
begin
  PrevFloatingPointExceptions := SetExceptionMask(exAllArithmeticExceptions);
end;

procedure RestoreFloatingPointExceptions;
begin
  SetExceptionMask(PrevFloatingPointExceptions);
end;
{$WARN SYMBOL_PLATFORM ON}

{ Vector2 }

function Vector2: TVector2;
begin
  Result.Init;
end;

function Vector2(const A: Single): TVector2;
begin
  Result.Init(A);
end;

function Vector2(const A1, A2: Single): TVector2;
begin
  Result.Init(A1, A2);
end;

function Vector2(const AVector: TVector3): TVector2;
begin
  Result.Init(AVector.X, AVector.Y);
end;

function Vector2(const AVector: TVector4): TVector2;
begin
  Result.Init(AVector.X, AVector.Y);
end;

{ Vector3 }

function Vector3: TVector3;
begin
  Result.Init;
end;

function Vector3(const A: Single): TVector3;
begin
  Result.Init(A);
end;

function Vector3(const A1, A2, A3: Single): TVector3;
begin
  Result.Init(A1, A2, A3);
end;

function Vector3(const A1: TVector2; const A2: Single): TVector3;
begin
  Result.Init(A1, A2);
end;

function Vector3(const A1: Single; const A2: TVector2): TVector3;
begin
  Result.Init(A1, A2);
end;

function Vector3(const AVector: TVector4): TVector3;
begin
  Result.Init(AVector.X, AVector.Y, AVector.Z);
end;

{ Vector4 }

function Vector4: TVector4;
begin
  Result.Init;
end;

function Vector4(const A: Single): TVector4;
begin
  Result.Init(A);
end;

function Vector4(const A1, A2, A3, A4: Single): TVector4;
begin
  Result.Init(A1, A2, A3, A4);
end;

function Vector4(const A1: TVector2; const A2, A3: Single): TVector4;
begin
  Result.Init(A1, A2, A3);
end;

function Vector4(const A1: Single; const A2: TVector2; const A3: Single): TVector4;
begin
  Result.Init(A1, A2, A3);
end;

function Vector4(const A1, A2: Single; const A3: TVector2): TVector4;
begin
  Result.Init(A1, A2, A3);
end;

function Vector4(const A1, A2: TVector2): TVector4;
begin
  Result.Init(A1, A2);
end;

function Vector4(const A1: TVector3; const A2: Single): TVector4;
begin
  Result.Init(A1, A2);
end;

function Vector4(const A1: Single; const A2: TVector3): TVector4;
begin
  Result.Init(A1, A2);
end;

{ Quaternion }

function Quaternion: TQuaternion;
begin
  Result.Init;
end;

function Quaternion(const AX, AY, AZ, AW: Single): TQuaternion; overload;
begin
  Result.Init(AX, AY, AZ, AW);
end;

function Quaternion(const AAxis: TVector3; const AAngleRadians: Single): TQuaternion; overload;
begin
  Result.Init(AAxis, AAngleRadians);
end;

{ Matrix2 }

function Matrix2: TMatrix2;
begin
  Result.Init;
end;

function Matrix2(const ADiagonal: Single): TMatrix2;
begin
  Result.Init(ADiagonal);
end;

function Matrix2(const ARow0, ARow1: TVector2): TMatrix2;
begin
  Result.Init(ARow0, ARow1);
end;

function Matrix2(const A11, A12, A21, A22: Single): TMatrix2;
begin
  Result.Init(A11, A12, A21, A22);
end;

function Matrix2(const AMatrix: TMatrix3): TMatrix2;
begin
  Result.V[0] := Vector2(AMatrix.V[0]);
  Result.V[1] := Vector2(AMatrix.V[1]);
end;

function Matrix2(const AMatrix: TMatrix4): TMatrix2;
begin
  Result.V[0] := Vector2(AMatrix.V[0]);
  Result.V[1] := Vector2(AMatrix.V[1]);
end;

{ Matrix3 }

function Matrix3: TMatrix3;
begin
  Result.Init;
end;

function Matrix3(const ADiagonal: Single): TMatrix3;
begin
  Result.Init(ADiagonal);
end;

function Matrix3(const ARow0, ARow1, ARow2: TVector3): TMatrix3;
begin
  Result.Init(ARow0, ARow1, ARow2);
end;

function Matrix3(const A11, A12, A13, A21, A22, A23, A31, A32, A33: Single): TMatrix3;
begin
  Result.Init(A11, A12, A13, A21, A22, A23, A31, A32, A33);
end;

function Matrix3(const AMatrix: TMatrix2): TMatrix3;
begin
  Result.V[0] := Vector3(AMatrix.V[0], 0);
  Result.V[1] := Vector3(AMatrix.V[1], 0);
  Result.V[2] := Vector3(0, 0, 1);
end;

function Matrix3(const AMatrix: TMatrix4): TMatrix3;
begin
  Result.V[0] := Vector3(AMatrix.V[0]);
  Result.V[1] := Vector3(AMatrix.V[1]);
  Result.V[2] := Vector3(AMatrix.V[2]);
end;

{ Matrix4 }

function Matrix4: TMatrix4;
begin
  Result.Init;
end;

function Matrix4(const ADiagonal: Single): TMatrix4;
begin
  Result.Init(ADiagonal);;
end;

function Matrix4(const ARow0, ARow1, ARow2, ARow3: TVector4): TMatrix4;
begin
  Result.Init(ARow0, ARow1, ARow2, ARow3);
end;

function Matrix4(const A11, A12, A13, A14, A21, A22, A23, A24, A31, A32, A33,
  A34, A41, A42, A43, A44: Single): TMatrix4;
begin
  Result.Init(A11, A12, A13, A14, A21, A22, A23, A24, A31, A32, A33, A34, A41,
    A42, A43, A44);
end;

function Matrix4(const AMatrix: TMatrix2): TMatrix4;
begin
  Result.V[0].Init(AMatrix.V[0], 0, 0);
  Result.V[1].Init(AMatrix.V[1], 0, 0);
  Result.V[2].Init(0, 0, 1, 0);
  Result.V[3].Init(0, 0, 0, 1);
end;

function Matrix4(const AMatrix: TMatrix3): TMatrix4;
begin
  Result.V[0].Init(AMatrix.V[0], 0);
  Result.V[1].Init(AMatrix.V[1], 0);
  Result.V[2].Init(AMatrix.V[2], 0);
  Result.V[3].Init(0, 0, 0, 1);
end;

{ IVector2 }

function IVector2: TIVector2;
begin
  Result.Init;
end;

function IVector2(const A: Integer): TIVector2;
begin
  Result.Init(A);
end;

function IVector2(const A1, A2: Integer): TIVector2;
begin
  Result.Init(A1, A2);
end;

{ IVector3 }

function IVector3: TIVector3;
begin
  Result.Init;
end;

function IVector3(const A: Integer): TIVector3;
begin
  Result.Init(A);
end;

function IVector3(const A1, A2, A3: Integer): TIVector3;
begin
  Result.Init(A1, A2, A3);
end;

{ IVector4 }

function IVector4: TIVector4;
begin
  Result.Init;
end;

function IVector4(const A: Integer): TIVector4;
begin
  Result.Init(A);
end;

function IVector4(const A1, A2, A3, A4: Integer): TIVector4;
begin
  Result.Init(A1, A2, A3, A4);
end;

{ Angle and Trigonometry Functions }

function Sin(const ARadians: Single): Single;
begin
  Result := System.Sin(ARadians);
end;

function Sin(const ARadians: TVector2): TVector2;
begin
  Result.Init(System.Sin(ARadians.X), System.Sin(ARadians.Y));
end;

function Sin(const ARadians: TVector3): TVector3;
begin
  Result.Init(System.Sin(ARadians.X), System.Sin(ARadians.Y), System.Sin(ARadians.Z));
end;

function Sin(const ARadians: TVector4): TVector4;
begin
  Result.Init(System.Sin(ARadians.X), System.Sin(ARadians.Y), System.Sin(ARadians.Z), System.Sin(ARadians.W));
end;

function Cos(const ARadians: Single): Single;
begin
  Result := System.Cos(ARadians);
end;

function Cos(const ARadians: TVector2): TVector2;
begin
  Result.Init(System.Cos(ARadians.X), System.Cos(ARadians.Y));
end;

function Cos(const ARadians: TVector3): TVector3;
begin
  Result.Init(System.Cos(ARadians.X), System.Cos(ARadians.Y), System.Cos(ARadians.Z));
end;

function Cos(const ARadians: TVector4): TVector4;
begin
  Result.Init(System.Cos(ARadians.X), System.Cos(ARadians.Y), System.Cos(ARadians.Z), System.Cos(ARadians.W));
end;

procedure SinCos(const ARadians: Single; out ASin, ACos: Single);
begin
  System.Math.SinCos(ARadians, ASin, ACos);
end;

procedure SinCos(const ARadians: TVector2; out ASin, ACos: TVector2);
begin
  System.Math.SinCos(ARadians.X, ASin.X, ACos.X);
  System.Math.SinCos(ARadians.Y, ASin.Y, ACos.Y);
end;

procedure SinCos(const ARadians: TVector3; out ASin, ACos: TVector3);
begin
  System.Math.SinCos(ARadians.X, ASin.X, ACos.X);
  System.Math.SinCos(ARadians.Y, ASin.Y, ACos.Y);
  System.Math.SinCos(ARadians.Z, ASin.Z, ACos.Z);
end;

procedure SinCos(const ARadians: TVector4; out ASin, ACos: TVector4);
begin
  System.Math.SinCos(ARadians.X, ASin.X, ACos.X);
  System.Math.SinCos(ARadians.Y, ASin.Y, ACos.Y);
  System.Math.SinCos(ARadians.Z, ASin.Z, ACos.Z);
  System.Math.SinCos(ARadians.W, ASin.W, ACos.W);
end;

function Tan(const ARadians: Single): Single;
begin
  Result := System.Tangent(ARadians);
end;

function Tan(const ARadians: TVector2): TVector2;
begin
  Result.Init(System.Tangent(ARadians.X), System.Tangent(ARadians.Y));
end;

function Tan(const ARadians: TVector3): TVector3;
begin
  Result.Init(System.Tangent(ARadians.X), System.Tangent(ARadians.Y), System.Tangent(ARadians.Z));
end;

function Tan(const ARadians: TVector4): TVector4;
begin
  Result.Init(System.Tangent(ARadians.X), System.Tangent(ARadians.Y), System.Tangent(ARadians.Z), System.Tangent(ARadians.W));
end;

function ArcSin(const A: Single): Single;
begin
  Result := System.Math.ArcSin(A);
end;

function ArcSin(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.ArcSin(A.X), System.Math.ArcSin(A.Y));
end;

function ArcSin(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.ArcSin(A.X), System.Math.ArcSin(A.Y), System.Math.ArcSin(A.Z));
end;

function ArcSin(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.ArcSin(A.X), System.Math.ArcSin(A.Y), System.Math.ArcSin(A.Z), System.Math.ArcSin(A.W));
end;

function ArcCos(const A: Single): Single;
begin
  Result := System.Math.ArcCos(A);
end;

function ArcCos(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.ArcCos(A.X), System.Math.ArcCos(A.Y));
end;

function ArcCos(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.ArcCos(A.X), System.Math.ArcCos(A.Y), System.Math.ArcCos(A.Z));
end;

function ArcCos(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.ArcCos(A.X), System.Math.ArcCos(A.Y), System.Math.ArcCos(A.Z), System.Math.ArcCos(A.W));
end;

function ArcTan(const A: Single): Single;
begin
  Result := System.ArcTan(A);
end;

function ArcTan(const A: TVector2): TVector2;
begin
  Result.Init(System.ArcTan(A.X), System.ArcTan(A.Y));
end;

function ArcTan(const A: TVector3): TVector3;
begin
  Result.Init(System.ArcTan(A.X), System.ArcTan(A.Y), System.ArcTan(A.Z));
end;

function ArcTan(const A: TVector4): TVector4;
begin
  Result.Init(System.ArcTan(A.X), System.ArcTan(A.Y), System.ArcTan(A.Z), System.ArcTan(A.W));
end;

function ArcTan2(const Y, X: Single): Single;
begin
  Result := System.Math.ArcTan2(Y, X);
end;

function ArcTan2(const Y, X: TVector2): TVector2;
begin
  Result.Init(System.Math.ArcTan2(Y.X, X.X), System.Math.ArcTan2(Y.Y, X.Y));
end;

function ArcTan2(const Y, X: TVector3): TVector3;
begin
  Result.Init(System.Math.ArcTan2(Y.X, X.X), System.Math.ArcTan2(Y.Y, X.Y), System.Math.ArcTan2(Y.Z, X.Z));
end;

function ArcTan2(const Y, X: TVector4): TVector4;
begin
  Result.Init(System.Math.ArcTan2(Y.X, X.X), System.Math.ArcTan2(Y.Y, X.Y), System.Math.ArcTan2(Y.Z, X.Z), System.Math.ArcTan2(Y.W, X.W));
end;

function Sinh(const A: Single): Single;
begin
  Result := System.Math.Sinh(A);
end;

function Sinh(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.Sinh(A.X), System.Math.Sinh(A.Y));
end;

function Sinh(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.Sinh(A.X), System.Math.Sinh(A.Y), System.Math.Sinh(A.Z));
end;

function Sinh(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.Sinh(A.X), System.Math.Sinh(A.Y), System.Math.Sinh(A.Z), System.Math.Sinh(A.W));
end;

function Cosh(const A: Single): Single;
begin
  Result := System.Math.Cosh(A);
end;

function Cosh(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.Cosh(A.X), System.Math.Cosh(A.Y));
end;

function Cosh(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.Cosh(A.X), System.Math.Cosh(A.Y), System.Math.Cosh(A.Z));
end;

function Cosh(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.Cosh(A.X), System.Math.Cosh(A.Y), System.Math.Cosh(A.Z), System.Math.Cosh(A.W));
end;

function Tanh(const A: Single): Single;
begin
  Result := System.Math.Tanh(A);
end;

function Tanh(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.Tanh(A.X), System.Math.Tanh(A.Y));
end;

function Tanh(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.Tanh(A.X), System.Math.Tanh(A.Y), System.Math.Tanh(A.Z));
end;

function Tanh(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.Tanh(A.X), System.Math.Tanh(A.Y), System.Math.Tanh(A.Z), System.Math.Tanh(A.W));
end;

function ArcSinh(const A: Single): Single;
begin
  Result := System.Math.ArcSinh(A);
end;

function ArcSinh(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.ArcSinh(A.X), System.Math.ArcSinh(A.Y));
end;

function ArcSinh(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.ArcSinh(A.X), System.Math.ArcSinh(A.Y), System.Math.ArcSinh(A.Z));
end;

function ArcSinh(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.ArcSinh(A.X), System.Math.ArcSinh(A.Y), System.Math.ArcSinh(A.Z), System.Math.ArcSinh(A.W));
end;

function ArcCosh(const A: Single): Single;
begin
  Result := System.Math.ArcCosh(A);
end;

function ArcCosh(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.ArcCosh(A.X), System.Math.ArcCosh(A.Y));
end;

function ArcCosh(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.ArcCosh(A.X), System.Math.ArcCosh(A.Y), System.Math.ArcCosh(A.Z));
end;

function ArcCosh(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.ArcCosh(A.X), System.Math.ArcCosh(A.Y), System.Math.ArcCosh(A.Z), System.Math.ArcCosh(A.W));
end;

function ArcTanh(const A: Single): Single;
begin
  Result := System.Math.ArcTanh(A);
end;

function ArcTanh(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.ArcTanh(A.X), System.Math.ArcTanh(A.Y));
end;

function ArcTanh(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.ArcTanh(A.X), System.Math.ArcTanh(A.Y), System.Math.ArcTanh(A.Z));
end;

function ArcTanh(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.ArcTanh(A.X), System.Math.ArcTanh(A.Y), System.Math.ArcTanh(A.Z), System.Math.ArcTanh(A.W));
end;

{ Exponential Functions }

function Power(const ABase, AExponent: Single): Single;
begin
  Result := System.Math.Power(ABase, AExponent);
end;

function Power(const ABase, AExponent: TVector2): TVector2;
begin
  Result.Init(System.Math.Power(ABase.X, AExponent.X), System.Math.Power(ABase.Y, AExponent.Y));
end;

function Power(const ABase, AExponent: TVector3): TVector3;
begin
  Result.Init(System.Math.Power(ABase.X, AExponent.X), System.Math.Power(ABase.Y, AExponent.Y), System.Math.Power(ABase.Z, AExponent.Z));
end;

function Power(const ABase, AExponent: TVector4): TVector4;
begin
  Result.Init(System.Math.Power(ABase.X, AExponent.X), System.Math.Power(ABase.Y, AExponent.Y), System.Math.Power(ABase.Z, AExponent.Z), System.Math.Power(ABase.W, AExponent.W));
end;

function Exp(const A: Single): Single;
begin
  Result := System.Exp(A);
end;

function Exp(const A: TVector2): TVector2;
begin
  Result.Init(System.Exp(A.X), System.Exp(A.Y));
end;

function Exp(const A: TVector3): TVector3;
begin
  Result.Init(System.Exp(A.X), System.Exp(A.Y), System.Exp(A.Z));
end;

function Exp(const A: TVector4): TVector4;
begin
  Result.Init(System.Exp(A.X), System.Exp(A.Y), System.Exp(A.Z), System.Exp(A.W));
end;

function Ln(const A: Single): Single;
begin
  Result := System.Ln(A);
end;

function Ln(const A: TVector2): TVector2;
begin
  Result.Init(System.Ln(A.X), System.Ln(A.Y));
end;

function Ln(const A: TVector3): TVector3;
begin
  Result.Init(System.Ln(A.X), System.Ln(A.Y), System.Ln(A.Z));
end;

function Ln(const A: TVector4): TVector4;
begin
  Result.Init(System.Ln(A.X), System.Ln(A.Y), System.Ln(A.Z), System.Ln(A.W));
end;

function Exp2(const A: Single): Single;
begin
  Result := System.Math.Power(2, A);
end;

function Exp2(const A: TVector2): TVector2;
begin
  Result.Init(Exp2(A.X), Exp2(A.Y));
end;

function Exp2(const A: TVector3): TVector3;
begin
  Result.Init(Exp2(A.X), Exp2(A.Y), Exp2(A.Z));
end;

function Exp2(const A: TVector4): TVector4;
begin
  Result.Init(Exp2(A.X), Exp2(A.Y), Exp2(A.Z), Exp2(A.W));
end;

function Log2(const A: Single): Single;
begin
  Result := System.Math.Log2(A);
end;

function Log2(const A: TVector2): TVector2;
begin
  Result.Init(System.Math.Log2(A.X), System.Math.Log2(A.Y));
end;

function Log2(const A: TVector3): TVector3;
begin
  Result.Init(System.Math.Log2(A.X), System.Math.Log2(A.Y), System.Math.Log2(A.Z));
end;

function Log2(const A: TVector4): TVector4;
begin
  Result.Init(System.Math.Log2(A.X), System.Math.Log2(A.Y), System.Math.Log2(A.Z), System.Math.Log2(A.W));
end;

{ Fast approximate Functions }

function FastPower(const ABase, AExponent: Single): Single;
begin
  Result := FastExp2(AExponent * FastLog2(ABase));
end;

function FastPower(const ABase, AExponent: TVector2): TVector2;
begin
  Result := FastExp2(AExponent * FastLog2(ABase));
end;

function FastPower(const ABase, AExponent: TVector3): TVector3;
begin
  Result := FastExp2(AExponent * FastLog2(ABase));
end;

function FastPower(const ABase, AExponent: TVector4): TVector4;
begin
  Result := FastExp2(AExponent * FastLog2(ABase));
end;

function FastTan(const ARadians: Single): Single;
var
  S, C: Single;
begin
  FastSinCos(ARadians, S, C);
  Result := S / C;
end;

function FastTan(const ARadians: TVector2): TVector2;
var
  S, C: TVector2;
begin
  FastSinCos(ARadians, S, C);
  Result := S / C;
end;

function FastTan(const ARadians: TVector3): TVector3;
var
  S, C: TVector3;
begin
  FastSinCos(ARadians, S, C);
  Result := S / C;
end;

function FastTan(const ARadians: TVector4): TVector4;
var
  S, C: TVector4;
begin
  FastSinCos(ARadians, S, C);
  Result := S / C;
end;

function FastArcTan2(const Y, X: Single): Single;
var
  Z: Single;
begin
  if (X = 0) then
  begin
    if (Y > 0) then
      Exit(0.5 * Pi);
    if (Y = 0) then
      Exit(0);
    Exit(-0.5 * Pi);
  end;

  Z := Y / X;
  if (Abs(Z) < 1) then
  begin
    Result := Z / (1.0 + 0.28 * Z * Z);
    if (X < 0) then
    begin
      if (Y < 0) then
        Result := Result - Pi
      else
        Result := Result + Pi;
    end;
  end
  else
  begin
    Result := (0.5 * Pi) - Z / (Z * Z + 0.28);
    if (Y < 0) then
      Result := Result - Pi;
  end;
end;

function FastArcTan2(const Y, X: TVector2): TVector2;
begin
  Result.Init(FastArcTan2(Y.X, X.X), FastArcTan2(Y.Y, X.Y));
end;

function FastArcTan2(const Y, X: TVector3): TVector3;
begin
  Result.Init(FastArcTan2(Y.X, X.X), FastArcTan2(Y.Y, X.Y), FastArcTan2(Y.Z, X.Z));
end;

function FastArcTan2(const Y, X: TVector4): TVector4;
begin
  Result.Init(FastArcTan2(Y.X, X.X), FastArcTan2(Y.Y, X.Y), FastArcTan2(Y.Z, X.Z), FastArcTan2(Y.W, X.W));
end;

{ Common functions }

function Min(const A, B: Single): Single;
begin
  Result := System.Math.Min(A, B);
end;

function Max(const A, B: Single): Single;
begin
  Result := System.Math.Max(A, B);
end;

function Mix(const A, B, T: Single): Single;
begin
//  Result := (A * (1 - T)) + (B * T);
  Result := A + (T * (B - A)); // Faster
end;

function Step(const AEdge, A: Single): Single;
begin
  if (A < AEdge) then
    Result := 0
  else
    Result := 1;
end;

function SmoothStep(const AEdge0, AEdge1, A: Single): Single;
var
  Temp: Single;
begin
  Assert(AEdge1 > AEdge0);
  if (A < AEdge0) then
    Result := 0
  else if (A > AEdge1) then
    Result := 1
  else
  begin
    Temp := (A - AEdge0) / (AEdge1 - AEdge0);
    Result := Temp * Temp * (3 - (2 * Temp));
  end;
end;

function FMA(const A, B, C: Single): Single;
begin
  Result := (A * B) + C;
end;

{ TVector2 }

function TVector2.AngleTo(const ATarget: TVector2): Single;
begin
  Result := Neslib.FastMath.ArcTan2(Cross(ATarget), Dot(ATarget));
end;

function TVector2.Clamp(const AMinLength, AMaxLength: Single): TVector2;
var
  LenSq, EdgeSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq = 0) then
    Exit(Self);

  EdgeSq := AMaxLength * AMaxLength;
  if (LenSq > EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  EdgeSq := AMinLength * AMinLength;
  if (LenSq < EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  Result := Self;
end;

function TVector2.Cross(const AOther: TVector2): Single;
begin
  Result := (X * AOther.Y) - (Y * AOther.X);
end;

class operator TVector2.Equal(const A, B: TVector2): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y);
end;

function TVector2.Equals(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X - AOther.X) <= ATolerance)
        and (Abs(Y - AOther.Y) <= ATolerance);
end;

function TVector2.GetAngle: Single;
begin
  Result := Neslib.FastMath.ArcTan2(Y, X)
end;

function TVector2.GetComponent(const AIndex: Integer): Single;
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  Result := C[AIndex];
end;

function TVector2.HasSameDirection(const AOther: TVector2): Boolean;
begin
  Result := (Dot(AOther) > 0);
end;

function TVector2.HasOppositeDirection(const AOther: TVector2): Boolean;
begin
  Result := (Dot(AOther) < 0);
end;

class operator TVector2.Implicit(const A: TPointF): TVector2;
begin
  Result.X := A.X;
  Result.Y := A.Y;
end;

class operator TVector2.Implicit(const A: TVector2): TPointF;
begin
  Result.X := A.X;
  Result.Y := A.Y;
end;

procedure TVector2.Init;
begin
  X := 0;
  Y := 0;
end;

procedure TVector2.Init(const A: Single);
begin
  X := A;
  Y := A;
end;

procedure TVector2.Init(const A1, A2: Single);
begin
  X := A1;
  Y := A2;
end;

procedure TVector2.Init(const APoint: TPoint);
begin
  X := APoint.X;
  Y := APoint.Y;
end;

function TVector2.IsCollinear(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (Dot(AOther) > 0);
end;

function TVector2.IsCollinearOpposite(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (Dot(AOther) < 0);
end;

function TVector2.IsNormalized: Boolean;
begin
  Result := IsNormalized(0.000000001);
end;

function TVector2.IsNormalized(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(LengthSquared - 1.0) < AErrorMargin);
end;

function TVector2.IsParallel(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X * AOther.Y - Y * AOther.X) <= ATolerance);
end;

function TVector2.IsPerpendicular(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := (Abs(Dot(AOther)) <= ATolerance);
end;

function TVector2.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0);
end;

function TVector2.IsZero(const AErrorMargin: Single): Boolean;
begin
  Result := (LengthSquared < AErrorMargin);
end;

function TVector2.Lerp(const ATarget: TVector2; const AAlpha: Single): TVector2;
begin
  Result := Mix(Self, ATarget, AAlpha);
end;

function TVector2.Limit(const AMaxLength: Single): TVector2;
begin
  Result := LimitSquared(AMaxLength * AMaxLength);
end;

function TVector2.LimitSquared(const AMaxLengthSquared: Single): TVector2;
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq > AMaxLengthSquared) then
    Result := Self * Sqrt(AMaxLengthSquared / LenSq)
  else
    Result := Self;
end;

class operator TVector2.Negative(const A: TVector2): TVector2;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

function TVector2.Normalize: TVector2;
begin
  Result := Self / Length;
end;

class operator TVector2.NotEqual(const A, B: TVector2): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y);
end;

procedure TVector2.Offset(const ADeltaX, ADeltaY: Single);
begin
  X := X + ADeltaX;
  Y := Y + ADeltaY;
end;

procedure TVector2.Offset(const ADelta: TVector2);
begin
  Self := Self + ADelta;
end;

function TVector2.Rotate(const ARadians: Single): TVector2;
var
  S, C: Single;
begin
  FastSinCos(ARadians, S, C);
  Result.X := (X * C) - (Y * S);
  Result.Y := (X * S) + (Y * C);
end;

function TVector2.Rotate90CCW: TVector2;
begin
  Result.X := -Y;
  Result.Y := X;
end;

function TVector2.Rotate90CW: TVector2;
begin
  Result.X := Y;
  Result.Y := -X;
end;

procedure TVector2.SetLerp(const ATarget: TVector2; const AAlpha: Single);
begin
  Self := Mix(Self, ATarget, AAlpha);
end;

procedure TVector2.SetNormalized;
begin
  Self := Self / Length;
end;

procedure TVector2.SetRotated90CCW;
begin
  Self := Rotate90CCW;
end;

procedure TVector2.SetRotated90CW;
begin
  Self := Rotate90CW;
end;

procedure TVector2.SetAngle(const AValue: Single);
begin
  X := Length;
  Y := 0;
  SetRotated(AValue);
end;

procedure TVector2.SetClamped(const AMinLength, AMaxLength: Single);
begin
  Self := Clamp(AMinLength, AMaxLength);
end;

procedure TVector2.SetComponent(const AIndex: Integer; const Value: Single);
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  C[AIndex] := Value;
end;

procedure TVector2.SetLength(const AValue: Single);
begin
  SetLengthSquared(AValue * AValue);
end;

procedure TVector2.SetLengthSquared(const AValue: Single);
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq <> 0) and (LenSq <> AValue) then
    Self := Self * Sqrt(AValue / LenSq);
end;

procedure TVector2.SetLimit(const AMaxLength: Single);
begin
  Self := LimitSquared(AMaxLength * AMaxLength);
end;

procedure TVector2.SetLimitSquared(const AMaxLengthSquared: Single);
begin
  Self := LimitSquared(AMaxLengthSquared);
end;

procedure TVector2.SetRotated(const ARadians: Single);
begin
  Self := Rotate(ARadians);
end;

{ _TVector2Helper }

function _TVector2Helper.Floor: TIVector2;
begin
  Result := Neslib.FastMath.Floor(Self);
end;

function _TVector2Helper.Ceiling: TIVector2;
begin
  Result := Neslib.FastMath.Ceil(Self);
end;

function _TVector2Helper.Truncate: TIVector2;
begin
  Result := Neslib.FastMath.Trunc(Self);
end;

function _TVector2Helper.Round: TIVector2;
begin
  Result := Neslib.FastMath.Round(Self);
end;

{ TVector3 }

function TVector3.Clamp(const AMinLength, AMaxLength: Single): TVector3;
var
  LenSq, EdgeSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq = 0) then
    Exit(Self);

  EdgeSq := AMaxLength * AMaxLength;
  if (LenSq > EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  EdgeSq := AMinLength * AMinLength;
  if (LenSq < EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  Result := Self;
end;

class operator TVector3.Equal(const A, B: TVector3): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

function TVector3.Equals(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X - AOther.X) <= ATolerance)
        and (Abs(Y - AOther.Y) <= ATolerance)
        and (Abs(Z - AOther.Z) <= ATolerance);
end;

function TVector3.GetComponent(const AIndex: Integer): Single;
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  Result := C[AIndex];
end;

function TVector3.HasSameDirection(const AOther: TVector3): Boolean;
begin
  Result := (Dot(AOther) > 0);
end;

function TVector3.HasOppositeDirection(const AOther: TVector3): Boolean;
begin
  Result := (Dot(AOther) < 0);
end;

class operator TVector3.Implicit(const A: TPoint3D): TVector3;
begin
  Result.X := A.X;
  Result.Y := A.Y;
  Result.Z := A.Z;
end;

class operator TVector3.Implicit(const A: TVector3): TPoint3D;
begin
  Result.X := A.X;
  Result.Y := A.Y;
  Result.Z := A.Z;
end;

procedure TVector3.Init(const A: Single);
begin
  X := A;
  Y := A;
  Z := A;
end;

procedure TVector3.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
end;

procedure TVector3.Init(const A1, A2, A3: Single);
begin
  X := A1;
  Y := A2;
  Z := A3;
end;

procedure TVector3.Init(const A1: Single; const A2: TVector2);
begin
  X := A1;
  Y := A2.X;
  Z := A2.Y;
end;

procedure TVector3.Init(const A1: TVector2; const A2: Single);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A2;
end;

function TVector3.IsCollinear(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (Dot(AOther) > 0);
end;

function TVector3.IsCollinearOpposite(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (Dot(AOther) < 0);
end;

function TVector3.IsNormalized: Boolean;
begin
  Result := IsNormalized(0.000000001);
end;

function TVector3.IsNormalized(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(LengthSquared - 1.0) < AErrorMargin);
end;

function TVector3.IsParallel(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
  Result := ((Vector3(Y * AOther.Z - Z * AOther.Y,
                      Z * AOther.X - X * AOther.Z,
                      X * AOther.Y - Y * AOther.X).LengthSquared) <= ATolerance);
end;

function TVector3.IsPerpendicular(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
  Result := (Abs(Dot(AOther)) <= ATolerance);
end;

function TVector3.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0);
end;

function TVector3.IsZero(const AErrorMargin: Single): Boolean;
begin
  Result := (LengthSquared < AErrorMargin);
end;

function TVector3.Lerp(const ATarget: TVector3; const AAlpha: Single): TVector3;
begin
  Result := Mix(Self, ATarget, AAlpha);
end;

function TVector3.Limit(const AMaxLength: Single): TVector3;
begin
  Result := LimitSquared(AMaxLength * AMaxLength);
end;

function TVector3.LimitSquared(const AMaxLengthSquared: Single): TVector3;
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq > AMaxLengthSquared) then
    Result := Self * Sqrt(AMaxLengthSquared / LenSq)
  else
    Result := Self;
end;

function TVector3.Normalize: TVector3;
begin
  Result := Self / Length;
end;

class operator TVector3.NotEqual(const A, B: TVector3): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

procedure TVector3.Offset(const ADeltaX, ADeltaY, ADeltaZ: Single);
begin
  X := X + ADeltaX;
  Y := Y + ADeltaY;
  Z := Z + ADeltaZ;
end;

procedure TVector3.Offset(const ADelta: TVector3);
begin
  Self := Self + ADelta;
end;

procedure TVector3.SetClamped(const AMinLength, AMaxLength: Single);
begin
  Self := Clamp(AMinLength, AMaxLength);
end;

procedure TVector3.SetComponent(const AIndex: Integer; const Value: Single);
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  C[AIndex] := Value;
end;

procedure TVector3.SetLength(const AValue: Single);
begin
  SetLengthSquared(AValue * AValue);
end;

procedure TVector3.SetLengthSquared(const AValue: Single);
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq <> 0) and (LenSq <> AValue) then
    Self := Self * Sqrt(AValue / LenSq);
end;

procedure TVector3.SetLerp(const ATarget: TVector3; const AAlpha: Single);
begin
  Self := Mix(Self, ATarget, AAlpha);
end;

procedure TVector3.SetLimit(const AMaxLength: Single);
begin
  Self := LimitSquared(AMaxLength * AMaxLength);
end;

procedure TVector3.SetLimitSquared(const AMaxLengthSquared: Single);
begin
  Self := LimitSquared(AMaxLengthSquared);
end;

procedure TVector3.SetNormalized;
begin
  Self := Self / Length;
end;

{ _TVector3Helper }

function _TVector3Helper.Floor: TIVector3;
begin
  Result := Neslib.FastMath.Floor(Self);
end;

function _TVector3Helper.Ceiling: TIVector3;
begin
  Result := Neslib.FastMath.Ceil(Self);
end;

function _TVector3Helper.Truncate: TIVector3;
begin
  Result := Neslib.FastMath.Trunc(Self);
end;

function _TVector3Helper.Round: TIVector3;
begin
  Result := Neslib.FastMath.Round(Self);
end;

{ TVector4 }

function TVector4.Clamp(const AMinLength, AMaxLength: Single): TVector4;
var
  LenSq, EdgeSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq = 0) then
    Exit(Self);

  EdgeSq := AMaxLength * AMaxLength;
  if (LenSq > EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  EdgeSq := AMinLength * AMinLength;
  if (LenSq < EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  Result := Self;
end;

class operator TVector4.Equal(const A, B: TVector4): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

function TVector4.Equals(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X - AOther.X) <= ATolerance)
        and (Abs(Y - AOther.Y) <= ATolerance)
        and (Abs(Z - AOther.Z) <= ATolerance)
        and (Abs(W - AOther.W) <= ATolerance);
end;

function TVector4.GetComponent(const AIndex: Integer): Single;
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  Result := C[AIndex];
end;

function TVector4.HasSameDirection(const AOther: TVector4): Boolean;
begin
  Result := (((X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z)) > 0);
end;

function TVector4.HasOppositeDirection(const AOther: TVector4): Boolean;
begin
  Result := (((X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z)) < 0);
end;

class operator TVector4.Implicit(const A: TVector3D): TVector4;
begin
  Result.X := A.X;
  Result.Y := A.Y;
  Result.Z := A.Z;
  Result.W := A.W;
end;

class operator TVector4.Implicit(const A: TVector4): TVector3D;
begin
  Result.X := A.X;
  Result.Y := A.Y;
  Result.Z := A.Z;
  Result.W := A.W;
end;

procedure TVector4.Init(const A1, A2, A3, A4: Single);
begin
  X := A1;
  Y := A2;
  Z := A3;
  W := A4;
end;

procedure TVector4.Init(const A: Single);
begin
  X := A;
  Y := A;
  Z := A;
  W := A;
end;

procedure TVector4.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 0;
end;

procedure TVector4.Init(const A1: TVector2; const A2, A3: Single);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A2;
  W := A3;
end;

procedure TVector4.Init(const A1, A2: TVector2);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A2.X;
  W := A2.Y;
end;

procedure TVector4.Init(const A1, A2: Single; const A3: TVector2);
begin
  X := A1;
  Y := A2;
  Z := A3.X;
  W := A3.Y;
end;

procedure TVector4.Init(const A1: Single; const A2: TVector2; const A3: Single);
begin
  X := A1;
  Y := A2.X;
  Z := A2.Y;
  W := A3;
end;

procedure TVector4.Init(const A1: TVector3; const A2: Single);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A1.Z;
  W := A2;
end;

procedure TVector4.Init(const A1: Single; const A2: TVector3);
begin
  X := A1;
  Y := A2.X;
  Z := A2.Y;
  W := A2.Z;
end;

function TVector4.IsCollinear(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (HasSameDirection(AOther));
end;

function TVector4.IsCollinearOpposite(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (HasOppositeDirection(AOther));
end;

function TVector4.IsNormalized: Boolean;
begin
  Result := IsNormalized(0.000000001);
end;

function TVector4.IsNormalized(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(LengthSquared - 1.0) < AErrorMargin);
end;

function TVector4.IsParallel(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := ((Vector3(Y * AOther.Z - Z * AOther.Y,
                      Z * AOther.X - X * AOther.Z,
                      X * AOther.Y - Y * AOther.X).LengthSquared) <= ATolerance);
end;

function TVector4.IsPerpendicular(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := (Abs((X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z)) <= ATolerance);
end;

function TVector4.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0) and (W = 0);
end;

function TVector4.IsZero(const AErrorMargin: Single): Boolean;
begin
  Result := (LengthSquared < AErrorMargin);
end;

function TVector4.Lerp(const ATarget: TVector4; const AAlpha: Single): TVector4;
begin
  Result := Mix(Self, ATarget, AAlpha);
end;

function TVector4.Limit(const AMaxLength: Single): TVector4;
begin
  Result := LimitSquared(AMaxLength * AMaxLength);
end;

function TVector4.LimitSquared(const AMaxLengthSquared: Single): TVector4;
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq > AMaxLengthSquared) then
    Result := Self * Sqrt(AMaxLengthSquared / LenSq)
  else
    Result := Self;
end;

function TVector4.Normalize: TVector4;
begin
  Result := Self / Length;
end;

class operator TVector4.NotEqual(const A, B: TVector4): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

procedure TVector4.Offset(const ADeltaX, ADeltaY, ADeltaZ, ADeltaW: Single);
begin
  X := X + ADeltaX;
  Y := Y + ADeltaY;
  Z := Z + ADeltaZ;
  W := W + ADeltaW;
end;

procedure TVector4.Offset(const ADelta: TVector4);
begin
  Self := Self + ADelta;
end;

procedure TVector4.SetClamped(const AMinLength, AMaxLength: Single);
begin
  Self := Clamp(AMinLength, AMaxLength);
end;

procedure TVector4.SetComponent(const AIndex: Integer; const Value: Single);
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  C[AIndex] := Value;
end;

procedure TVector4.SetLength(const AValue: Single);
begin
  SetLengthSquared(AValue * AValue);
end;

procedure TVector4.SetLengthSquared(const AValue: Single);
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq <> 0) and (LenSq <> AValue) then
    Self := Self * Sqrt(AValue / LenSq);
end;

procedure TVector4.SetLerp(const ATarget: TVector4; const AAlpha: Single);
begin
  Self := Mix(Self, ATarget, AAlpha);
end;

procedure TVector4.SetLimit(const AMaxLength: Single);
begin
  Self := LimitSquared(AMaxLength * AMaxLength);
end;

procedure TVector4.SetLimitSquared(const AMaxLengthSquared: Single);
begin
  Self := LimitSquared(AMaxLengthSquared);
end;

procedure TVector4.SetNormalized;
begin
  Self := Self / Length;
end;

{ _TVector4Helper }

function _TVector4Helper.Floor: TIVector4;
begin
  Result := Neslib.FastMath.Floor(Self);
end;

function _TVector4Helper.Ceiling: TIVector4;
begin
  Result := Neslib.FastMath.Ceil(Self);
end;

function _TVector4Helper.Truncate: TIVector4;
begin
  Result := Neslib.FastMath.Trunc(Self);
end;

function _TVector4Helper.Round: TIVector4;
begin
  Result := Neslib.FastMath.Round(Self);
end;

{ TQuaternion }

function TQuaternion.Conjugate: TQuaternion;
begin
  Result.X := -X;
  Result.Y := -Y;
  Result.Z := -Z;
  Result.W := W;
end;

class operator TQuaternion.Implicit(const A: TQuaternion3D): TQuaternion;
begin
  Result.X := A.V[0];
  Result.Y := A.V[1];
  Result.Z := A.V[2];
  Result.W := A.V[3];
end;

class operator TQuaternion.Implicit(const A: TQuaternion): TQuaternion3D;
begin
  Result.V[0] := A.X;
  Result.V[1] := A.Y;
  Result.V[2] := A.Z;
  Result.V[3] := A.W;
end;

procedure TQuaternion.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 1;
end;

procedure TQuaternion.Init(const AX, AY, AZ, AW: Single);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := AW;
end;

procedure TQuaternion.Init(const AAxis: TVector3; const AAngleRadians: Single);
var
  D, S, C: Single;
begin
  D := AAxis.Length;
  if (D = 0) then
  begin
    Init;
    Exit;
  end;

  D := 1 / D;
  FastSinCos(AAngleRadians * 0.5, S, C);
  X := D * AAxis.X * S;
  Y := D * AAxis.Y * S;
  Z := D * AAxis.Z * S;
  W := C;
  SetNormalized;
end;

procedure TQuaternion.Init(const AYaw, APitch, ARoll: Single);
var
  A, S, C: TVector4;
  CYSP, SYCP, CYCP, SYSP: Single;
begin
  A.Init(APitch * 0.5, AYaw * 0.5, ARoll * 0.5, 0);
  FastSinCos(A, S, C);

  CYSP := C.Y * S.X;
  SYCP := S.Y * C.X;
  CYCP := C.Y * C.X;
  SYSP := S.Y * S.X;

  X := (CYSP * C.Z) + (SYCP * S.Z);
  Y := (SYCP * C.Z) - (CYSP * S.Z);
  Z := (CYCP * S.Z) - (SYSP * C.Z);
  W := (CYCP * C.Z) + (SYSP * S.Z);
end;

procedure TQuaternion.Init(const AMatrix: TMatrix4);
var
  Trace, S: double;
begin
  Trace := AMatrix.m11 + AMatrix.m22 + AMatrix.m33;
  if (Trace > EPSILON) then
  begin
    S := 0.5 / Sqrt(Trace + 1.0);
    X := (AMatrix.m23 - AMatrix.m32) * S;
    Y := (AMatrix.m31 - AMatrix.m13) * S;
    Z := (AMatrix.m12 - AMatrix.m21) * S;
    W := 0.25 / S;
  end
  else if (AMatrix.m11 > AMatrix.m22) and (AMatrix.m11 > AMatrix.m33) then
  begin
    S := Sqrt(Neslib.FastMath.Max(EPSILON, 1 + AMatrix.m11 - AMatrix.m22 - AMatrix.m33)) * 2.0;
    X := 0.25 * S;
    Y := (AMatrix.m12 + AMatrix.m21) / S;
    Z := (AMatrix.m31 + AMatrix.m13) / S;
    W := (AMatrix.m23 - AMatrix.m32) / S;
  end
  else if (AMatrix.m22 > AMatrix.m33) then
  begin
    S := Sqrt(Neslib.FastMath.Max(EPSILON, 1 + AMatrix.m22 - AMatrix.m11 - AMatrix.m33)) * 2.0;
    X := (AMatrix.m12 + AMatrix.m21) / S;
    Y := 0.25 * S;
    Z := (AMatrix.m23 + AMatrix.m32) / S;
    W := (AMatrix.m31 - AMatrix.m13) / S;
  end else
  begin
    S := Sqrt(Neslib.FastMath.Max(EPSILON, 1 + AMatrix.m33 - AMatrix.m11 - AMatrix.m22)) * 2.0;
    X := (AMatrix.m31 + AMatrix.m13) / S;
    Y := (AMatrix.m23 + AMatrix.m32) / S;
    Z := 0.25 * S;
    W := (AMatrix.m12 - AMatrix.m21) / S;
  end;
  SetNormalized;
end;

function TQuaternion.IsIdentity: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0) and (W = 1);
end;

function TQuaternion.IsIdentity(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(X) <= AErrorMargin) and (Abs(Y) <= AErrorMargin)
    and (Abs(Z) <= AErrorMargin) and ((Abs(W) - 1) <= AErrorMargin)
end;

function TQuaternion.Normalize: TQuaternion;
begin
  Result := Self * (1 / Length);
end;

procedure TQuaternion.SetConjugate;
begin
  X := -X;
  Y := -Y;
  Z := -Z;
end;

procedure TQuaternion.SetNormalized;
begin
  Self := Self * (1 / Length);
end;

function TQuaternion.ToMatrix: TMatrix4;
var
  Q: TQuaternion;
  XX, XY, XZ, XW, YY, YZ, YW, ZZ, ZW: Single;
begin
  Q := Normalize;
  XX := Q.X * Q.X;
  XY := Q.X * Q.Y;
  XZ := Q.X * Q.Z;
  XW := Q.X * Q.W;
  YY := Q.Y * Q.Y;
  YZ := Q.Y * Q.Z;
  YW := Q.Y * Q.W;
  ZZ := Q.Z * Q.Z;
  ZW := Q.Z * Q.W;

  Result.Init(
    1 - 2 * (YY + ZZ), 2 * (XY + ZW), 2 * (XZ - YW), 0,
    2 * (XY - ZW), 1 - 2 * (XX + ZZ), 2 * (YZ + XW), 0,
    2 * (XZ + YW), 2 * (YZ - XW), 1 - 2 * (XX + YY), 0,
    0, 0, 0, 1);
end;

{ TMatrix2 }

class operator TMatrix2.Divide(const A, B: TMatrix2): TMatrix2;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix2.Divide(const A: TVector2; const B: TMatrix2): TVector2;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix2.Divide(const A: TMatrix2; const B: TVector2): TVector2;
begin
  Result := A.Inverse * B;
end;

function TMatrix2.GetDeterminant: Single;
begin
  Result :=
    + (M[0,0] * M[1,1])
    - (M[1,0] * M[0,1]);
end;

function TMatrix2.Inverse: TMatrix2;
var
  OneOverDeterminant: Single;
begin
  OneOverDeterminant := 1 / Determinant;
  Result.M[0,0] := +M[1,1] * OneOverDeterminant;
  Result.M[0,1] := -M[0,1] * OneOverDeterminant;
  Result.M[1,0] := -M[1,0] * OneOverDeterminant;
  Result.M[1,1] := +M[0,0] * OneOverDeterminant;
end;

procedure TMatrix2.SetInversed;
begin
  Self := Inverse;
end;

class operator TMatrix2.Equal(const A, B: TMatrix2): Boolean;
begin
  Result := (A.V[0] = B.V[0]) and (A.V[1] = B.V[1]);
end;

procedure TMatrix2.Init(const ADiagonal: Single);
begin
  V[0].Init(ADiagonal, 0);
  V[1].Init(0, ADiagonal);
end;

procedure TMatrix2.Init;
begin
  V[0].Init(1, 0);
  V[1].Init(0, 1);
end;

procedure TMatrix2.Init(const A11, A12, A21, A22: Single);
begin
  V[0].Init(A11, A12);
  V[1].Init(A21, A22);
end;

class operator TMatrix2.NotEqual(const A, B: TMatrix2): Boolean;
begin
  Result := (A.V[0] <> B.V[0]) or (A.V[1] <> B.V[1]);
end;

{$IFDEF FM_COLUMN_MAJOR}
function TMatrix2.GetColumn(const AIndex: Integer): TVector2;
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  Result := C[AIndex];
end;

function TMatrix2.GetComponent(const AColumn, ARow: Integer): Single;
begin
  Assert((AColumn >= 0) and (AColumn < 2));
  Assert((ARow >= 0) and (ARow < 2));
  Result := M[AColumn, ARow];
end;

procedure TMatrix2.Init(const AColumn0, AColumn1: TVector2);
begin
  C[0] := AColumn0;
  C[1] := AColumn1;
end;

class operator TMatrix3.Implicit(const A: TMatrix): TMatrix3;
var
  M: TMatrix3 absolute A;
begin
  Result := M.Transpose;
end;

class operator TMatrix3.Implicit(const A: TMatrix3): TMatrix;
var
  M: TMatrix3 absolute Result;
begin
  M := A.Transpose;
end;

procedure TMatrix2.SetColumn(const AIndex: Integer; const Value: TVector2);
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  C[AIndex] := Value;
end;

procedure TMatrix2.SetComponent(const AColumn, ARow: Integer; const Value: Single);
begin
  Assert((AColumn >= 0) and (AColumn < 2));
  Assert((ARow >= 0) and (ARow < 2));
  M[AColumn, ARow] := Value;
end;
{$ELSE}
function TMatrix2.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Assert((ARow >= 0) and (ARow < 2));
  Assert((AColumn >= 0) and (AColumn < 2));
  Result := M[ARow, AColumn];
end;

function TMatrix2.GetRow(const AIndex: Integer): TVector2;
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  Result := R[AIndex];
end;

class operator TMatrix3.Implicit(const A: TMatrix): TMatrix3;
begin
  Move(A, Result, SizeOf(A));
end;

class operator TMatrix3.Implicit(const A: TMatrix3): TMatrix;
begin
  Move(A, Result, SizeOf(A));
end;

procedure TMatrix2.Init(const ARow0, ARow1: TVector2);
begin
  R[0] := ARow0;
  R[1] := ARow1;
end;

procedure TMatrix2.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  Assert((ARow >= 0) and (ARow < 2));
  Assert((AColumn >= 0) and (AColumn < 2));
  M[ARow, AColumn] := Value;
end;

procedure TMatrix2.SetRow(const AIndex: Integer; const Value: TVector2);
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  R[AIndex] := Value;
end;
{$ENDIF}

{ TMatrix3 }

class operator TMatrix3.Divide(const A, B: TMatrix3): TMatrix3;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix3.Divide(const A: TVector3; const B: TMatrix3): TVector3;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix3.Divide(const A: TMatrix3; const B: TVector3): TVector3;
begin
  Result := A.Inverse * B;
end;

function TMatrix3.GetDeterminant: Single;
begin
  Result :=
    + (M[0,0] * ((M[1,1] * M[2,2]) - (M[2,1] * M[1,2])))
    - (M[0,1] * ((M[1,0] * M[2,2]) - (M[2,0] * M[1,2])))
    + (M[0,2] * ((M[1,0] * M[2,1]) - (M[2,0] * M[1,1])));
end;

function TMatrix3.Inverse: TMatrix3;
var
  OneOverDeterminant: Single;
begin
  OneOverDeterminant := 1 / Determinant;
  Result.M[0,0] := + ((M[1,1] * M[2,2]) - (M[2,1] * M[1,2])) * OneOverDeterminant;
  Result.M[1,0] := - ((M[1,0] * M[2,2]) - (M[2,0] * M[1,2])) * OneOverDeterminant;
  Result.M[2,0] := + ((M[1,0] * M[2,1]) - (M[2,0] * M[1,1])) * OneOverDeterminant;
  Result.M[0,1] := - ((M[0,1] * M[2,2]) - (M[2,1] * M[0,2])) * OneOverDeterminant;
  Result.M[1,1] := + ((M[0,0] * M[2,2]) - (M[2,0] * M[0,2])) * OneOverDeterminant;
  Result.M[2,1] := - ((M[0,0] * M[2,1]) - (M[2,0] * M[0,1])) * OneOverDeterminant;
  Result.M[0,2] := + ((M[0,1] * M[1,2]) - (M[1,1] * M[0,2])) * OneOverDeterminant;
  Result.M[1,2] := - ((M[0,0] * M[1,2]) - (M[1,0] * M[0,2])) * OneOverDeterminant;
  Result.M[2,2] := + ((M[0,0] * M[1,1]) - (M[1,0] * M[0,1])) * OneOverDeterminant;
end;

procedure TMatrix3.SetInversed;
begin
  Self := Inverse;
end;

class operator TMatrix3.Equal(const A, B: TMatrix3): Boolean;
begin
  Result := (A.V[0] = B.V[0]) and (A.V[1] = B.V[1]) and (A.V[2] = B.V[2]);
end;

procedure TMatrix3.Init(const ADiagonal: Single);
begin
  V[0].Init(ADiagonal, 0, 0);
  V[1].Init(0, ADiagonal, 0);
  V[2].Init(0, 0, ADiagonal);
end;

procedure TMatrix3.Init;
begin
  V[0].Init(1, 0, 0);
  V[1].Init(0, 1, 0);
  V[2].Init(0, 0, 1);
end;

procedure TMatrix3.Init(const AMatrix: TMatrix2);
begin
  V[0].Init(AMatrix.V[0], 0);
  V[1].Init(AMatrix.V[1], 0);
  V[2].Init(0, 0, 1);
end;

procedure TMatrix3.Init(const A11, A12, A13, A21, A22, A23, A31, A32,
  A33: Single);
begin
  V[0].Init(A11, A12, A13);
  V[1].Init(A21, A22, A23);
  V[2].Init(A31, A32, A33);
end;

procedure TMatrix3.InitScaling(const AScale: Single);
begin
  V[0].Init(AScale, 0, 0);
  V[1].Init(0, AScale, 0);
  V[2].Init(0, 0, 1);
end;

procedure TMatrix3.InitScaling(const AScaleX, AScaleY: Single);
begin
  V[0].Init(AScaleX, 0, 0);
  V[1].Init(0, AScaleY, 0);
  V[2].Init(0, 0, 1);
end;

procedure TMatrix3.InitScaling(const AScale: TVector2);
begin
  V[0].Init(AScale.X, 0, 0);
  V[1].Init(0, AScale.Y, 0);
  V[2].Init(0, 0, 1);
end;

procedure TMatrix3.InitTranslation(const ADeltaX, ADeltaY: Single);
begin
  V[0].Init(1, 0, 0);
  V[1].Init(0, 1, 0);
  V[2].Init(ADeltaX, ADeltaY, 1);
end;

procedure TMatrix3.InitTranslation(const ADelta: TVector2);
begin
  V[0].Init(1, 0, 0);
  V[1].Init(0, 1, 0);
  V[2].Init(ADelta.X, ADelta.Y, 1);
end;

class operator TMatrix3.NotEqual(const A, B: TMatrix3): Boolean;
begin
  Result := (A.V[0] <> B.V[0]) or (A.V[1] <> B.V[1]) or (A.V[2] <> B.V[2]);
end;

{$IFDEF FM_COLUMN_MAJOR}
function TMatrix3.GetColumn(const AIndex: Integer): TVector3;
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  Result := C[AIndex];
end;

function TMatrix3.GetComponent(const AColumn, ARow: Integer): Single;
begin
  Assert((AColumn >= 0) and (AColumn < 3));
  Assert((ARow >= 0) and (ARow < 3));
  Result := M[AColumn, ARow];
end;

procedure TMatrix3.Init(const AColumn0, AColumn1, AColumn2: TVector3);
begin
  C[0] := AColumn0;
  C[1] := AColumn1;
  C[2] := AColumn2;
end;

procedure TMatrix3.InitRotation(const AAngle: Single);
var
  S, C: Single;
begin
  FastSinCos(AAngle, S, C);
  Self.C[0].Init(C, S, 0);
  Self.C[1].Init(-S, C, 0);
  Self.C[2].Init(0, 0, 1);
end;

procedure TMatrix3.SetColumn(const AIndex: Integer; const Value: TVector3);
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  C[AIndex] := Value;
end;

procedure TMatrix3.SetComponent(const AColumn, ARow: Integer; const Value: Single);
begin
  Assert((AColumn >= 0) and (AColumn < 3));
  Assert((ARow >= 0) and (ARow < 3));
  M[AColumn, ARow] := Value;
end;
{$ELSE}
function TMatrix3.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Assert((ARow >= 0) and (ARow < 3));
  Assert((AColumn >= 0) and (AColumn < 3));
  Result := M[ARow, AColumn];
end;

function TMatrix3.GetRow(const AIndex: Integer): TVector3;
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  Result := R[AIndex];
end;

procedure TMatrix3.Init(const ARow0, ARow1, ARow2: TVector3);
begin
  R[0] := ARow0;
  R[1] := ARow1;
  R[2] := ARow2;
end;

procedure TMatrix3.InitRotation(const AAngle: Single);
var
  S, C: Single;
begin
  FastSinCos(AAngle, S, C);
  R[0].Init(C, S, 0);
  R[1].Init(-S, C, 0);
  R[2].Init(0, 0, 1);
end;

procedure TMatrix3.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  Assert((ARow >= 0) and (ARow < 3));
  Assert((AColumn >= 0) and (AColumn < 3));
  M[ARow, AColumn] := Value;
end;

procedure TMatrix3.SetRow(const AIndex: Integer; const Value: TVector3);
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  R[AIndex] := Value;
end;
{$ENDIF}

{ TMatrix4 }

class operator TMatrix4.Divide(const A, B: TMatrix4): TMatrix4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result := A.Inverse * B;
end;

function TMatrix4.GetDeterminant: Single;
var
  F00, F01, F02, F03, F04, F05: Single;
  C: TVector4;
begin
  F00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  F01 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  F02 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  F03 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  F04 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  F05 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);

  C.X := + ((M[1,1] * F00) - (M[1,2] * F01) + (M[1,3] * F02));
  C.Y := - ((M[1,0] * F00) - (M[1,2] * F03) + (M[1,3] * F04));
  C.Z := + ((M[1,0] * F01) - (M[1,1] * F03) + (M[1,3] * F05));
  C.W := - ((M[1,0] * F02) - (M[1,1] * F04) + (M[1,2] * F05));

  Result := (M[0,0] * C.X) + (M[0,1] * C.Y) + (M[0,2] * C.Z) + (M[0,3] * C.W);
end;

class operator TMatrix4.Equal(const A, B: TMatrix4): Boolean;
begin
  Result := (A.V[0] = B.V[0]) and (A.V[1] = B.V[1]) and (A.V[2] = B.V[2]) and (A.V[3] = B.V[3]);
end;

procedure TMatrix4.Init(const ADiagonal: Single);
begin
  V[0].Init(ADiagonal, 0, 0, 0);
  V[1].Init(0, ADiagonal, 0, 0);
  V[2].Init(0, 0, ADiagonal, 0);
  V[3].Init(0, 0, 0, ADiagonal);
end;

procedure TMatrix4.Init;
begin
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.Init(const A11, A12, A13, A14, A21, A22, A23, A24, A31, A32,
  A33, A34, A41, A42, A43, A44: Single);
begin
  V[0].Init(A11, A12, A13, A14);
  V[1].Init(A21, A22, A23, A24);
  V[2].Init(A31, A32, A33, A34);
  V[3].Init(A41, A42, A43, A44);
end;

procedure TMatrix4.Init(const AMatrix: TMatrix2);
begin
  V[0].Init(AMatrix.V[0], 0, 0);
  V[1].Init(AMatrix.V[1], 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.Init(const AMatrix: TMatrix3);
begin
  V[0].Init(AMatrix.V[0], 0);
  V[1].Init(AMatrix.V[1], 0);
  V[2].Init(AMatrix.V[2], 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitLookAtLH(const ACameraPosition, ACameraTarget,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := (ACameraTarget - ACameraPosition).Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

procedure TMatrix4.InitLookAtRH(const ACameraPosition, ACameraTarget,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := (ACameraPosition - ACameraTarget).Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

procedure TMatrix4.InitLookAtDirLH(const ACameraPosition, ACameraDirection,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := -ACameraDirection.Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

procedure TMatrix4.InitLookAtDirRH(const ACameraPosition, ACameraDirection,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := ACameraDirection.Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

procedure TMatrix4.InitScaling(const AScale: Single);
begin
  V[0].Init(AScale, 0, 0, 0);
  V[1].Init(0, AScale, 0, 0);
  V[2].Init(0, 0, AScale, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitScaling(const AScaleX, AScaleY, AScaleZ: Single);
begin
  V[0].Init(AScaleX, 0, 0, 0);
  V[1].Init(0, AScaleY, 0, 0);
  V[2].Init(0, 0, AScaleZ, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitScaling(const AScale: TVector3);
begin
  V[0].Init(AScale.X, 0, 0, 0);
  V[1].Init(0, AScale.Y, 0, 0);
  V[2].Init(0, 0, AScale.Z, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitTranslation(const ADeltaX, ADeltaY, ADeltaZ: Single);
begin
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(ADeltaX, ADeltaY, ADeltaZ, 1);
end;

procedure TMatrix4.InitTranslation(const ADelta: TVector3);
begin
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(ADelta.X, ADelta.Y, ADelta.Z, 1);
end;

class operator TMatrix4.NotEqual(const A, B: TMatrix4): Boolean;
begin
  Result := (A.V[0] <> B.V[0]) or (A.V[1] <> B.V[1]) or (A.V[2] <> B.V[2]) or (A.V[3] <> B.V[3]);
end;

procedure TMatrix4.InitRotationX(const AAngle: Single);
var
  S, C: Single;
begin
  FastSinCos(AAngle, S, C);
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, C, S, 0);
  V[2].Init(0, -S, C, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitRotationY(const AAngle: Single);
var
  S, C: Single;
begin
  FastSinCos(AAngle, S, C);
  V[0].Init(C, 0, -S, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(S, 0, C, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitRotationZ(const AAngle: Single);
var
  S, C: Single;
begin
  FastSinCos(AAngle, S, C);
  V[0].Init(C, S, 0, 0);
  V[1].Init(-S, C, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitRotation(const AAxis: TVector3; const AAngle: Single);
var
  S, C, C1: Single;
  N: TVector3;
begin
  FastSinCos(AAngle, S, C);
  C1 := 1 - C;
  N := AAxis.Normalize;

  V[0].Init((C1 * N.X * N.X) + C,
            (C1 * N.X * N.Y) + (N.Z * S),
            (C1 * N.Z * N.X) - (N.Y * S), 0);


  V[1].Init((C1 * N.X * N.Y) - (N.Z * S),
            (C1 * N.Y * N.Y) + C,
            (C1 * N.Y * N.Z) + (N.X * S), 0);

  V[2].Init((C1 * N.Z * N.X) + (N.Y * S),
            (C1 * N.Y * N.Z) - (N.X * S),
            (C1 * N.Z * N.Z) + C, 0);

  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitRotationYawPitchRoll(const AYaw, APitch, ARoll: Single);
var
  A, S, C: TVector4;
begin
  A.Init(APitch, AYaw, ARoll, 0);
  FastSinCos(A, S, C);

  V[0].Init((C.Y * C.Z) + (S.X * S.Y * S.Z),
            (C.Y * S.X * S.Z) - (C.Z * S.Y),
            -C.X * S.Z, 0);

  V[1].Init(C.X * S.Y,
            C.X * C.Y,
            S.X, 0);

  V[2].Init((C.Y * S.Z) - (C.Z * S.X * S.Y),
           (-C.Z * C.Y * S.X) - (S.Z * S.Y),
             C.X * C.Z, 0);

  V[3].Init(0, 0, 0, 1);
end;

procedure TMatrix4.InitRotationHeadingPitchBank(const AHeading, APitch, ABank: Single);
var
  A, S, C: TVector4;
begin
  A.Init(AHeading, APitch, ABank, 0);
  FastSinCos(A, S, C);

  V[0].Init((C.X * C.Z) + (S.X * S.Y * S.Z),
           (-C.X * S.Z) + (S.X * S.Y * C.Z),
             S.X * C.Y, 0);

  V[1].Init(S.Z * C.Y,
            C.Y * C.Z,
           -S.Y, 0);

  V[2].Init((-S.X * C.Z) + (C.X * S.Y * S.Z),
             (S.Z * S.X) + (C.X * S.Y * C.Z),
              C.X * C.Y, 0);

  V[3].Init(0, 0, 0, 1);
end;

{$IFDEF FM_COLUMN_MAJOR}
function TMatrix4.GetColumn(const AIndex: Integer): TVector4;
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  Result := C[AIndex];
end;

function TMatrix4.GetComponent(const AColumn, ARow: Integer): Single;
begin
  Assert((AColumn >= 0) and (AColumn < 4));
  Assert((ARow >= 0) and (ARow < 4));
  Result := M[AColumn, ARow];
end;

procedure TMatrix4.Init(const AColumn0, AColumn1, AColumn2, AColumn3: TVector4);
begin
  C[0] := AColumn0;
  C[1] := AColumn1;
  C[2] := AColumn2;
  C[3] := AColumn3;
end;

procedure TMatrix4.InitOrthoLH(const AWidth, AHeight, AZNearPlane,
  AZFarPlane: Single);
begin
  C[0].Init(2 / AWidth, 0, 0, 0);
  C[1].Init(0, 2 / AHeight, 0, 0);
  C[2].Init(0, 0, 2 / (AZFarPlane - AZNearPlane), 0);
  C[3].Init(-1, -1, -(AZFarPlane + AZNearPlane) / (AZFarPlane - AZNearPlane), 1);
end;

procedure TMatrix4.InitOrthoRH(const AWidth, AHeight, AZNearPlane,
  AZFarPlane: Single);
begin
  C[0].Init(2 / AWidth, 0, 0, 0);
  C[1].Init(0, 2 / AHeight, 0, 0);
  C[2].Init(0, 0, -2 / (AZFarPlane - AZNearPlane), 0);
  C[3].Init(-1, -1, -(AZFarPlane + AZNearPlane) / (AZFarPlane - AZNearPlane), 1);
end;

procedure TMatrix4.InitOrthoOffCenterLH(const ALeft, ATop, ARight, ABottom,
  AZNearPlane, AZFarPlane: Single);
begin
  C[0].Init(2 / (ARight - ALeft), 0, 0, 0);
  C[1].Init(0, 2 / (ATop - ABottom), 0, 0);
  C[2].Init(0, 0, 2 / (AZFarPlane - AZNearPlane), 0);
  C[3].Init(-(ALeft + ARight) / (ARight - ALeft),
            -(ATop + ABottom) / (ATop - ABottom),
            -(AZFarPlane + AZNearPlane) / (AZFarPlane - AZNearPlane), 1);
end;

procedure TMatrix4.InitOrthoOffCenterRH(const ALeft, ATop, ARight, ABottom,
  AZNearPlane, AZFarPlane: Single);
begin
  C[0].Init(2 / (ARight - ALeft), 0, 0, 0);
  C[1].Init(0, 2 / (ATop - ABottom), 0, 0);
  C[2].Init(0, 0, -2 / (AZFarPlane - AZNearPlane), 0);
  C[3].Init(-(ALeft + ARight) / (ARight - ALeft),
            -(ATop + ABottom) / (ATop - ABottom),
            -(AZFarPlane + AZNearPlane) / (AZFarPlane - AZNearPlane), 1);
end;

procedure TMatrix4.InitPerspectiveFovLH(const AFieldOfView, AAspectRatio,
  ANearPlaneDistance, AFarPlaneDistance: Single; const AHorizontalFOV: Boolean);
var
  XScale, YScale: Single;
begin
  if (AHorizontalFOV) then
  begin
    XScale := 1 / FastTan(0.5 * AFieldOfView);
    YScale := XScale / AAspectRatio;
  end
  else
  begin
    YScale := 1 / FastTan(0.5 * AFieldOfView);
    XScale := YScale / AAspectRatio;
  end;

  C[0].Init(XScale, 0, 0, 0);
  C[1].Init(0, YScale, 0, 0);
  C[2].Init(0, 0, (AFarPlaneDistance + ANearPlaneDistance) / (AFarPlaneDistance - ANearPlaneDistance), 1);
  C[3].Init(0, 0, (-2 * ANearPlaneDistance * AFarPlaneDistance) / (AFarPlaneDistance - ANearPlaneDistance), 0);
end;

procedure TMatrix4.InitPerspectiveFovRH(const AFieldOfView, AAspectRatio,
  ANearPlaneDistance, AFarPlaneDistance: Single; const AHorizontalFOV: Boolean);
var
  XScale, YScale: Single;
begin
  if (AHorizontalFOV) then
  begin
    XScale := 1 / FastTan(0.5 * AFieldOfView);
    YScale := XScale / AAspectRatio;
  end
  else
  begin
    YScale := 1 / FastTan(0.5 * AFieldOfView);
    XScale := YScale / AAspectRatio;
  end;

  C[0].Init(XScale, 0, 0, 0);
  C[1].Init(0, YScale, 0, 0);
  C[2].Init(0, 0, -(AFarPlaneDistance + ANearPlaneDistance) / (AFarPlaneDistance - ANearPlaneDistance), -1);
  C[3].Init(0, 0, (-2 * ANearPlaneDistance * AFarPlaneDistance) / (AFarPlaneDistance - ANearPlaneDistance), 0);
end;

class operator TMatrix4.Implicit(const A: TMatrix3D): TMatrix4;
var
  M: TMatrix4 absolute A;
begin
  Result := M.Transpose;
end;

class operator TMatrix4.Implicit(const A: TMatrix4): TMatrix3D;
var
  M: TMatrix4 absolute Result;
begin
  M := A.Transpose;
end;

procedure TMatrix4.SetComponent(const AColumn, ARow: Integer; const Value: Single);
begin
  Assert((AColumn >= 0) and (AColumn < 4));
  Assert((ARow >= 0) and (ARow < 4));
  M[AColumn, ARow] := Value;
end;

procedure TMatrix4.SetColumn(const AIndex: Integer; const Value: TVector4);
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  C[AIndex] := Value;
end;
{$ELSE}
function TMatrix4.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Assert((ARow >= 0) and (ARow < 4));
  Assert((AColumn >= 0) and (AColumn < 4));
  Result := M[ARow, AColumn];
end;

function TMatrix4.GetRow(const AIndex: Integer): TVector4;
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  Result := R[AIndex];
end;

procedure TMatrix4.Init(const ARow0, ARow1, ARow2, ARow3: TVector4);
begin
  R[0] := ARow0;
  R[1] := ARow1;
  R[2] := ARow2;
  R[3] := ARow3;
end;

procedure TMatrix4.InitOrthoLH(const AWidth, AHeight, AZNearPlane,
  AZFarPlane: Single);
begin
  R[0].Init(2 / AWidth, 0, 0, 0);
  R[1].Init(0, 2 / AHeight, 0, 0);
  R[2].Init(0, 0, 1 / (AZFarPlane - AZNearPlane), 0);
  R[3].Init(0, AZNearPlane / (AZNearPlane - AZFarPlane), 0, 1);
end;

procedure TMatrix4.InitOrthoRH(const AWidth, AHeight, AZNearPlane,
  AZFarPlane: Single);
begin
  R[0].Init(2 / AWidth, 0, 0, 0);
  R[1].Init(0, 2 / AHeight, 0, 0);
  R[2].Init(0, 0, 1 / (AZNearPlane - AZFarPlane), 0);
  R[3].Init(0, AZNearPlane / (AZNearPlane - AZFarPlane), 0, 1);
end;

procedure TMatrix4.InitOrthoOffCenterLH(const ALeft, ATop, ARight, ABottom,
  AZNearPlane, AZFarPlane: Single);
begin
  R[0].Init(2 / (ARight - ALeft), 0, 0, 0);
  R[1].Init(0, 2 / (ATop - ABottom), 0, 0);
  R[2].Init(0, 0, 1 / (AZFarPlane - AZNearPlane), 0);
  R[3].Init((ALeft + ARight) / (ALeft - ARight),
            (ATop + ABottom) / (ABottom - ATop),
            AZNearPlane / (AZNearPlane - AZFarPlane), 1);
end;

procedure TMatrix4.InitOrthoOffCenterRH(const ALeft, ATop, ARight, ABottom,
  AZNearPlane, AZFarPlane: Single);
begin
  R[0].Init(2 / (ARight - ALeft), 0, 0, 0);
  R[1].Init(0, 2 / (ATop - ABottom), 0, 0);
  R[2].Init(0, 0, 1 / (AZNearPlane - AZFarPlane), 0);
  R[3].Init((ALeft + ARight) / (ALeft - ARight),
            (ATop + ABottom) / (ABottom - ATop),
            AZNearPlane / (AZNearPlane - AZFarPlane), 1);
end;

procedure TMatrix4.InitPerspectiveFovLH(const AFieldOfView, AAspectRatio,
  ANearPlaneDistance, AFarPlaneDistance: Single; const AHorizontalFOV: Boolean);
var
  XScale, YScale: Single;
begin
  if (AHorizontalFOV) then
  begin
    XScale := 1 / FastTan(0.5 * AFieldOfView);
    YScale := XScale / AAspectRatio;
  end
  else
  begin
    YScale := 1 / FastTan(0.5 * AFieldOfView);
    XScale := YScale / AAspectRatio;
  end;

  R[0].Init(XScale, 0, 0, 0);
  R[1].Init(0, YScale, 0, 0);
  R[2].Init(0, 0, AFarPlaneDistance / (AFarPlaneDistance - ANearPlaneDistance), 1);
  R[3].Init(0, 0, (-ANearPlaneDistance * AFarPlaneDistance) / (AFarPlaneDistance - ANearPlaneDistance), 0);
end;

procedure TMatrix4.InitPerspectiveFovRH(const AFieldOfView, AAspectRatio,
  ANearPlaneDistance, AFarPlaneDistance: Single; const AHorizontalFOV: Boolean);
var
  XScale, YScale: Single;
begin
  if (AHorizontalFOV) then
  begin
    XScale := 1 / FastTan(0.5 * AFieldOfView);
    YScale := XScale / AAspectRatio;
  end
  else
  begin
    YScale := 1 / FastTan(0.5 * AFieldOfView);
    XScale := YScale / AAspectRatio;
  end;

  R[0].Init(XScale, 0, 0, 0);
  R[1].Init(0, YScale, 0, 0);
  R[2].Init(0, 0, AFarPlaneDistance / (ANearPlaneDistance - AFarPlaneDistance), -1);
  R[3].Init(0, 0, (ANearPlaneDistance * AFarPlaneDistance) / (ANearPlaneDistance - AFarPlaneDistance), 0);
end;

procedure TMatrix4.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  Assert((ARow >= 0) and (ARow < 4));
  Assert((AColumn >= 0) and (AColumn < 4));
  M[ARow, AColumn] := Value;
end;

class operator TMatrix4.Implicit(const A: TMatrix3D): TMatrix4;
begin
  Move(A, Result, SizeOf(TMatrix4));
end;

class operator TMatrix4.Implicit(const A: TMatrix4): TMatrix3D;
begin
  Move(A, Result, SizeOf(TMatrix4));
end;

procedure TMatrix4.SetRow(const AIndex: Integer; const Value: TVector4);
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  R[AIndex] := Value;
end;
{$ENDIF}

{ _TMatrix2Helper }

procedure _TMatrix2Helper.Init(const AMatrix: TMatrix3);
begin
  V[0].Init(AMatrix.V[0].X, AMatrix.V[0].Y);
  V[1].Init(AMatrix.V[1].X, AMatrix.V[1].Y);
end;

procedure _TMatrix2Helper.Init(const AMatrix: TMatrix4);
begin
  V[0].Init(AMatrix.V[0].X, AMatrix.V[0].Y);
  V[1].Init(AMatrix.V[1].X, AMatrix.V[1].Y);
end;

{ _TMatrix3Helper }

procedure _TMatrix3Helper.Init(const AMatrix: TMatrix4);
begin
  V[0].Init(AMatrix.V[0].X, AMatrix.V[0].Y, AMatrix.V[0].Z);
  V[1].Init(AMatrix.V[1].X, AMatrix.V[1].Y, AMatrix.V[1].Z);
  V[2].Init(AMatrix.V[2].X, AMatrix.V[2].Y, AMatrix.V[2].Z);
end;

{ TIVector2 }

class operator TIVector2.Add(const A: TIVector2; const B: Integer): TIVector2;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TIVector2.Add(const A: Integer; const B: TIVector2): TIVector2;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
end;

class operator TIVector2.Add(const A, B: TIVector2): TIVector2;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TIVector2.Equal(const A, B: TIVector2): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y);
end;

function TIVector2.GetComponent(const AIndex: Integer): Integer;
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  Result := C[AIndex];
end;

class operator TIVector2.Implicit(const A: TPoint): TIVector2;
begin
  Result.X := A.X;
  Result.Y := A.Y;
end;

class operator TIVector2.Implicit(const A: TIVector2): TPoint;
begin
  Result.X := A.X;
  Result.Y := A.Y;
end;

procedure TIVector2.Init;
begin
  X := 0;
  Y := 0;
end;

procedure TIVector2.Init(const A: Integer);
begin
  X := A;
  Y := A;
end;

procedure TIVector2.Init(const A1, A2: Integer);
begin
  X := A1;
  Y := A2;
end;

class operator TIVector2.IntDivide(const A: TIVector2; const B: Integer): TIVector2;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
end;

class operator TIVector2.IntDivide(const A: Integer; const B: TIVector2): TIVector2;
begin
  Result.X := A div B.X;
  Result.Y := A div B.Y;
end;

class operator TIVector2.IntDivide(const A, B: TIVector2): TIVector2;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
end;

function TIVector2.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0);
end;

class operator TIVector2.Multiply(const A: TIVector2; const B: Integer): TIVector2;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TIVector2.Multiply(const A: Integer; const B: TIVector2): TIVector2;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
end;

class operator TIVector2.Multiply(const A, B: TIVector2): TIVector2;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TIVector2.Negative(const A: TIVector2): TIVector2;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TIVector2.NotEqual(const A, B: TIVector2): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y);
end;

procedure TIVector2.SetComponent(const AIndex: Integer; const Value: Integer);
begin
  Assert((AIndex >= 0) and (AIndex < 2));
  C[AIndex] := Value;
end;

class operator TIVector2.Subtract(const A: TIVector2; const B: Integer): TIVector2;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TIVector2.Subtract(const A: Integer; const B: TIVector2): TIVector2;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
end;

class operator TIVector2.Subtract(const A, B: TIVector2): TIVector2;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

function TIVector2.ToVector2: TVector2;
begin
  Result.Init(X, Y);
end;

{ TIVector3 }

class operator TIVector3.Add(const A: TIVector3; const B: Integer): TIVector3;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
end;

class operator TIVector3.Add(const A: Integer; const B: TIVector3): TIVector3;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
  Result.Z := A + B.Z;
end;

class operator TIVector3.Add(const A, B: TIVector3): TIVector3;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
end;

class operator TIVector3.Equal(const A, B: TIVector3): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

function TIVector3.GetComponent(const AIndex: Integer): Integer;
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  Result := C[AIndex];
end;

procedure TIVector3.Init(const A: Integer);
begin
  X := A;
  Y := A;
  Z := A;
end;

procedure TIVector3.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
end;

procedure TIVector3.Init(const A1, A2, A3: Integer);
begin
  X := A1;
  Y := A2;
  Z := A3;
end;

class operator TIVector3.IntDivide(const A: TIVector3; const B: Integer): TIVector3;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
  Result.Z := A.Z div B;
end;

class operator TIVector3.IntDivide(const A: Integer; const B: TIVector3): TIVector3;
begin
  Result.X := A div B.X;
  Result.Y := A div B.Y;
  Result.Z := A div B.Z;
end;

class operator TIVector3.IntDivide(const A, B: TIVector3): TIVector3;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
  Result.Z := A.Z div B.Z;
end;

function TIVector3.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0);
end;

class operator TIVector3.Multiply(const A: TIVector3; const B: Integer): TIVector3;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
end;

class operator TIVector3.Multiply(const A: Integer; const B: TIVector3): TIVector3;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
end;

class operator TIVector3.Multiply(const A, B: TIVector3): TIVector3;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
end;

class operator TIVector3.Negative(const A: TIVector3): TIVector3;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
end;

class operator TIVector3.NotEqual(const A, B: TIVector3): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

procedure TIVector3.SetComponent(const AIndex: Integer; const Value: Integer);
begin
  Assert((AIndex >= 0) and (AIndex < 3));
  C[AIndex] := Value;
end;

class operator TIVector3.Subtract(const A: TIVector3; const B: Integer): TIVector3;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
end;

class operator TIVector3.Subtract(const A: Integer; const B: TIVector3): TIVector3;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
  Result.Z := A - B.Z;
end;

class operator TIVector3.Subtract(const A, B: TIVector3): TIVector3;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
end;

function TIVector3.ToVector3: TVector3;
begin
  Result.Init(X, Y, Z);
end;

{ TIVector4 }

class operator TIVector4.Add(const A: TIVector4; const B: Integer): TIVector4;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TIVector4.Add(const A: Integer; const B: TIVector4): TIVector4;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
  Result.Z := A + B.Z;
  Result.W := A + B.W;
end;

class operator TIVector4.Add(const A, B: TIVector4): TIVector4;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TIVector4.Equal(const A, B: TIVector4): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

function TIVector4.GetComponent(const AIndex: Integer): Integer;
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  Result := C[AIndex];
end;

procedure TIVector4.Init(const A1, A2, A3, A4: Integer);
begin
  X := A1;
  Y := A2;
  Z := A3;
  W := A4;
end;

procedure TIVector4.Init(const A: Integer);
begin
  X := A;
  Y := A;
  Z := A;
  W := A;
end;

procedure TIVector4.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 0;
end;

class operator TIVector4.IntDivide(const A: TIVector4; const B: Integer): TIVector4;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
  Result.Z := A.Z div B;
  Result.W := A.W div B;
end;

class operator TIVector4.IntDivide(const A: Integer; const B: TIVector4): TIVector4;
begin
  Result.X := A div B.X;
  Result.Y := A div B.Y;
  Result.Z := A div B.Z;
  Result.W := A div B.W;
end;

class operator TIVector4.IntDivide(const A, B: TIVector4): TIVector4;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
  Result.Z := A.Z div B.Z;
  Result.W := A.W div B.W;
end;

function TIVector4.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0) and (W = 0);
end;

class operator TIVector4.Multiply(const A: TIVector4; const B: Integer): TIVector4;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TIVector4.Multiply(const A: Integer; const B: TIVector4): TIVector4;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
  Result.W := A * B.W;
end;

class operator TIVector4.Multiply(const A, B: TIVector4): TIVector4;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TIVector4.Negative(const A: TIVector4): TIVector4;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

class operator TIVector4.NotEqual(const A, B: TIVector4): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

procedure TIVector4.SetComponent(const AIndex: Integer; const Value: Integer);
begin
  Assert((AIndex >= 0) and (AIndex < 4));
  C[AIndex] := Value;
end;

class operator TIVector4.Subtract(const A: TIVector4; const B: Integer): TIVector4;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TIVector4.Subtract(const A: Integer; const B: TIVector4): TIVector4;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
  Result.Z := A - B.Z;
  Result.W := A - B.W;
end;

class operator TIVector4.Subtract(const A, B: TIVector4): TIVector4;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

function TIVector4.ToVector4: TVector4;
begin
  Result.Init(X, Y, Z, W);
end;
