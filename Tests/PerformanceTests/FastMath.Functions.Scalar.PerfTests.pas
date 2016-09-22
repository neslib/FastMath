unit FastMath.Functions.Scalar.PerfTests;

interface

uses
  System.Math,
  PerformanceTest,
  Neslib.FastMath;

type
  TFunctionsScalarPerfTests = class(TPerformanceTest)
  private
    FA: Single;
    FB: Single;
    FC: Single;
    FD: Single;
    FI: Integer;
  protected
    procedure Setup; override;
  published
    [TestName('Radians(Scalar)')]
    procedure TestRadians;

    [TestName('Degrees(Scalar)')]
    procedure TestDegrees;

    [TestName('Sin(Scalar)')]
    procedure TestSin;

    [TestName('FastSin(Scalar)')]
    procedure TestFastSin;

    [TestName('Cos(Scalar)')]
    procedure TestCos;

    [TestName('FastCos(Scalar)')]
    procedure TestFastCos;

    [TestName('SinCos(Scalar)')]
    procedure TestSinCos;

    [TestName('FastSinCos(Scalar)')]
    procedure TestFastSinCos;

    [TestName('Tan(Scalar)')]
    procedure TestTan;

    [TestName('FastTan(Scalar)')]
    procedure TestFastTan;

    [TestName('ArcSin(Scalar)')]
    procedure TestArcSin;

    [TestName('ArcCos(Scalar)')]
    procedure TestArcCos;

    [TestName('ArcTan(Scalar)')]
    procedure TestArcTan;

    [TestName('ArcTan2(Scalar, Scalar)')]
    procedure TestArcTan2;

    [TestName('FastArcTan2(Scalar, Scalar)')]
    procedure TestFastArcTan2;

    [TestName('Sinh(Scalar)')]
    procedure TestSinh;

    [TestName('Cosh(Scalar)')]
    procedure TestCosh;

    [TestName('Tanh(Scalar)')]
    procedure TestTanh;

    [TestName('ArcSinh(Scalar)')]
    procedure TestArcSinh;

    [TestName('ArcCosh(Scalar)')]
    procedure TestArcCosh;

    [TestName('ArcTanh(Scalar)')]
    procedure TestArcTanh;

    [TestName('Power(Scalar, Scalar)')]
    procedure TestPower;

    [TestName('FastPower(Scalar, Scalar)')]
    procedure TestFastPower;

    [TestName('Exp(Scalar)')]
    procedure TestExp;

    [TestName('FastExp(Scalar)')]
    procedure TestFastExp;

    [TestName('Ln(Scalar)')]
    procedure TestLn;

    [TestName('FastLn(Scalar)')]
    procedure TestFastLn;

    [TestName('Exp2(Scalar)')]
    procedure TestExp2;

    [TestName('FastExp2(Scalar)')]
    procedure TestFastExp2;

    [TestName('Log2(Scalar)')]
    procedure TestLog2;

    [TestName('FastLog2(Scalar)')]
    procedure TestFastLog2;

    [TestName('Sqrt(Scalar)')]
    procedure TestSqrt;

    [TestName('InverseSqrt(Scalar)')]
    procedure TestInverseSqrt;

    [TestName('Abs(Scalar)')]
    procedure TestAbs;

    [TestName('Sign(Scalar)')]
    procedure TestSign;

    [TestName('Floor(Scalar)')]
    procedure TestFloor;

    [TestName('Trunc(Scalar)')]
    procedure TestTrunc;

    [TestName('Round(Scalar)')]
    procedure TestRound;

    [TestName('Ceil(Scalar)')]
    procedure TestCeil;

    [TestName('Frac(Scalar)')]
    procedure TestFrac;

    [TestName('FMod(Scalar, Scalar)')]
    procedure TestFMod;

    [TestName('ModF(Scalar, Scalar)')]
    procedure TestModF;

    [TestName('Min(Scalar, Scalar)')]
    procedure TestMin;

    [TestName('Max(Scalar, Scalar)')]
    procedure TestMax;

    [TestName('EnsureRange(Scalar, Scalar, Scalar)')]
    procedure TestEnsureRange;

    [TestName('Mix(Scalar, Scalar, Scalar)')]
    procedure TestMix;

    [TestName('Step(Scalar, Scalar)')]
    procedure TestStep;

    [TestName('SmoothStep(Scalar, Scalar, Scalar)')]
    procedure TestSmoothStep;

    [TestName('FMA(Scalar, Scalar, Scalar)')]
    procedure TestFMA;
  end;

implementation

{ TFunctionsScalarPerfTests }

procedure TFunctionsScalarPerfTests.Setup;
begin
  inherited;
  FA := 1.2;
  FB := 0.3;
  FC := 0.7;
end;

procedure TFunctionsScalarPerfTests.TestAbs;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Abs(FA);
end;

procedure TFunctionsScalarPerfTests.TestArcCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.ArcCos(FA);
end;

procedure TFunctionsScalarPerfTests.TestArcCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.ArcCosh(FA);
end;

procedure TFunctionsScalarPerfTests.TestArcSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.ArcSin(FA);
end;

procedure TFunctionsScalarPerfTests.TestArcSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.ArcSinh(FA);
end;

procedure TFunctionsScalarPerfTests.TestArcTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := ArcTan(FA);
end;

procedure TFunctionsScalarPerfTests.TestArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Neslib.FastMath.ArcTan2(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestArcTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.ArcTanh(FA);
end;

procedure TFunctionsScalarPerfTests.TestCeil;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FI := Neslib.FastMath.Ceil(FA);
end;

procedure TFunctionsScalarPerfTests.TestEnsureRange;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FD := Neslib.FastMath.EnsureRange(FA, FB, FC);
end;

procedure TFunctionsScalarPerfTests.TestCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Cos(FA);
end;

procedure TFunctionsScalarPerfTests.TestCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.Cosh(FA);
end;

procedure TFunctionsScalarPerfTests.TestDegrees;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Degrees(FA);
end;

procedure TFunctionsScalarPerfTests.TestExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Exp(FA);
end;

procedure TFunctionsScalarPerfTests.TestExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Exp2(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Neslib.FastMath.FastArcTan2(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestFastCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FastCos(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FastExp(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FastExp2(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FastLn(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.FastLog2(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := FastPower(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestFastSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FastSin(FA);
end;

procedure TFunctionsScalarPerfTests.TestFastSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FastSinCos(FA, FB, FC);
end;

procedure TFunctionsScalarPerfTests.TestFastTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FastTan(FA);
end;

procedure TFunctionsScalarPerfTests.TestFloor;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FI := Neslib.FastMath.Floor(FA);
end;

procedure TFunctionsScalarPerfTests.TestFMA;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FD := FMA(FB, FC, FA);
end;

procedure TFunctionsScalarPerfTests.TestFrac;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Frac(FA);
end;

procedure TFunctionsScalarPerfTests.TestInverseSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := InverseSqrt(FA);
end;

procedure TFunctionsScalarPerfTests.TestLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Ln(FA);
end;

procedure TFunctionsScalarPerfTests.TestLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.Log2(FA);
end;

procedure TFunctionsScalarPerfTests.TestMax;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Neslib.FastMath.Max(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestMin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Neslib.FastMath.Min(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestMix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FD := Mix(FA, FB, FC);
end;

procedure TFunctionsScalarPerfTests.TestFMod;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Neslib.FastMath.FMod(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestModF;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := ModF(FA, FI);
end;

procedure TFunctionsScalarPerfTests.TestPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Neslib.FastMath.Power(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestRadians;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Radians(FA);
end;

procedure TFunctionsScalarPerfTests.TestRound;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FI := Round(FA);
end;

procedure TFunctionsScalarPerfTests.TestSign;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.Sign(FA);
end;

procedure TFunctionsScalarPerfTests.TestSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Sin(FA);
end;

procedure TFunctionsScalarPerfTests.TestSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    Neslib.FastMath.SinCos(FA, FB, FC);
end;

procedure TFunctionsScalarPerfTests.TestSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.Sinh(FA);
end;

procedure TFunctionsScalarPerfTests.TestSmoothStep;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FD := SmoothStep(FB, FC, FA);
end;

procedure TFunctionsScalarPerfTests.TestSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Sqrt(FA);
end;

procedure TFunctionsScalarPerfTests.TestStep;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FC := Step(FA, FB);
end;

procedure TFunctionsScalarPerfTests.TestTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.Tan(FA);
end;

procedure TFunctionsScalarPerfTests.TestTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := Neslib.FastMath.Tanh(FA);
end;

procedure TFunctionsScalarPerfTests.TestTrunc;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FI := Trunc(FA);
end;

end.
