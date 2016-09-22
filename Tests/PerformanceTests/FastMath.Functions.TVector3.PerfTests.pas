unit FastMath.Functions.TVector3.PerfTests;

interface

uses
  System.Math,
  PerformanceTest,
  Neslib.FastMath;

type
  TFunctionsVector3PerfTests = class(TPerformanceTest)
  private
    FVecA: TVector3;
    FVecB: TVector3;
    FVecC: TVector3;
    FVecD: TVector3;
    FVecI: TIVector3;
    FA: Single;
    FB: Single;
  protected
    procedure Setup; override;
  published
    [TestName('Radians(TVector3)')]
    procedure TestRadians;

    [TestName('Degrees(TVector3)')]
    procedure TestDegrees;

    [TestName('Sin(TVector3)')]
    procedure TestSin;

    [TestName('FastSin(TVector3)')]
    procedure TestFastSin;

    [TestName('Cos(TVector3)')]
    procedure TestCos;

    [TestName('FastCos(TVector3)')]
    procedure TestFastCos;

    [TestName('SinCos(TVector3)')]
    procedure TestSinCos;

    [TestName('FastSinCos(TVector3)')]
    procedure TestFastSinCos;

    [TestName('Tan(TVector3)')]
    procedure TestTan;

    [TestName('FastTan(TVector3)')]
    procedure TestFastTan;

    [TestName('ArcSin(TVector3)')]
    procedure TestArcSin;

    [TestName('ArcCos(TVector3)')]
    procedure TestArcCos;

    [TestName('ArcTan(TVector3)')]
    procedure TestArcTan;

    [TestName('ArcTan2(TVector3, TVector3)')]
    procedure TestArcTan2;

    [TestName('FastArcTan2(TVector3, TVector3)')]
    procedure TestFastArcTan2;

    [TestName('Sinh(TVector3)')]
    procedure TestSinh;

    [TestName('Cosh(TVector3)')]
    procedure TestCosh;

    [TestName('Tanh(TVector3)')]
    procedure TestTanh;

    [TestName('ArcSinh(TVector3)')]
    procedure TestArcSinh;

    [TestName('ArcCosh(TVector3)')]
    procedure TestArcCosh;

    [TestName('ArcTanh(TVector3)')]
    procedure TestArcTanh;

    [TestName('Power(TVector3, TVector3)')]
    procedure TestPower;

    [TestName('FastPower(TVector3, TVector3)')]
    procedure TestFastPower;

    [TestName('Exp(TVector3)')]
    procedure TestExp;

    [TestName('FastExp(TVector3)')]
    procedure TestFastExp;

    [TestName('Ln(TVector3)')]
    procedure TestLn;

    [TestName('FastLn(TVector3)')]
    procedure TestFastLn;

    [TestName('Exp2(TVector3)')]
    procedure TestExp2;

    [TestName('FastExp2(TVector3)')]
    procedure TestFastExp2;

    [TestName('Log2(TVector3)')]
    procedure TestLog2;

    [TestName('FastLog2(TVector3)')]
    procedure TestFastLog2;

    [TestName('Sqrt(TVector3)')]
    procedure TestSqrt;

    [TestName('InverseSqrt(TVector3)')]
    procedure TestInverseSqrt;

    [TestName('Abs(TVector3)')]
    procedure TestAbs;

    [TestName('Sign(TVector3)')]
    procedure TestSign;

    [TestName('Floor(TVector3)')]
    procedure TestFloor;

    [TestName('Trunc(TVector3)')]
    procedure TestTrunc;

    [TestName('Round(TVector3)')]
    procedure TestRound;

    [TestName('Ceil(TVector3)')]
    procedure TestCeil;

    [TestName('Frac(TVector3)')]
    procedure TestFrac;

    [TestName('FMod(TVector3, TVector3)')]
    procedure TestFModVectorVector;

    [TestName('ModF(TVector3, TVector3)')]
    procedure TestModF;

    [TestName('Min(TVector3, TVector3)')]
    procedure TestMinVectorVector;

    [TestName('Max(TVector3, TVector3)')]
    procedure TestMaxVectorVector;

    [TestName('EnsureRange(TVector3, TVector3, TVector3)')]
    procedure TestEnsureRangeVectorVectorVector;

    [TestName('Mix(TVector3, TVector3, TVector3)')]
    procedure TestMixVectorVectorVector;

    [TestName('Step(TVector3, TVector3)')]
    procedure TestStepVectorVector;

    [TestName('SmoothStep(TVector3, TVector3, TVector3)')]
    procedure TestSmoothStepVectorVectorVector;

    [TestName('FMA(TVector3, TVector3, TVector3)')]
    procedure TestFMA;

    [TestName('FMod(TVector3, Scalar)')]
    procedure TestFModVectorScalar;

    [TestName('Min(TVector3, Scalar)')]
    procedure TestMinVectorScalar;

    [TestName('Max(TVector3, Scalar)')]
    procedure TestMaxVectorScalar;

    [TestName('EnsureRange(TVector3, Scalar, Scalar)')]
    procedure TestEnsureRangeVectorScalarScalar;

    [TestName('Mix(TVector3, TVector3, Scalar)')]
    procedure TestMixVectorVectorScalar;

    [TestName('Step(Scalar, TVector3)')]
    procedure TestStepScalarVector;

    [TestName('SmoothStep(Scalar, Scalar, TVector3)')]
    procedure TestSmoothStepScalarScalarVector;
  end;

implementation

{ TFunctionsVector3PerfTests }

procedure TFunctionsVector3PerfTests.Setup;
begin
  inherited;
  FVecA.Init(1.2, 2.3, 3.4);
  FVecB.Init(4.5, 5.6, 6.7);
  FVecC.Init(7.8, 8.9, 9.1);
  FA := 4.5;
  FB := 5.6;
end;

procedure TFunctionsVector3PerfTests.TestAbs;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Abs(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestArcCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcCos(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestArcCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcCosh(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestArcSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcSin(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestArcSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcSinh(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestArcTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcTan(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Neslib.FastMath.ArcTan2(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestArcTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcTanh(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestCeil;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Ceil(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestEnsureRangeVectorScalarScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := EnsureRange(FVecA, FA, FB);
end;

procedure TFunctionsVector3PerfTests.TestEnsureRangeVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := EnsureRange(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector3PerfTests.TestCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Cos(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Cosh(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestDegrees;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Degrees(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Exp(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Exp2(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Neslib.FastMath.FastArcTan2(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestFastCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastCos(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastExp(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastExp2(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastLn(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Neslib.FastMath.FastLog2(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FastPower(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestFastSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastSin(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFastSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FastSinCos(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector3PerfTests.TestFastTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastTan(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFloor;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Floor(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFMA;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FMA(FVecB, FVecC, FVecA);
end;

procedure TFunctionsVector3PerfTests.TestFrac;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Frac(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestInverseSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := InverseSqrt(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Ln(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Log2(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestMaxVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Max(FVecA, FA);
end;

procedure TFunctionsVector3PerfTests.TestMaxVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Max(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestMinVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Min(FVecA, FA);
end;

procedure TFunctionsVector3PerfTests.TestMinVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Min(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestMixVectorVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := Mix(FVecA, FVecB, FA);
end;

procedure TFunctionsVector3PerfTests.TestMixVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := Mix(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector3PerfTests.TestFModVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FMod(FVecA, FA);
end;

procedure TFunctionsVector3PerfTests.TestFModVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FMod(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestModF;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := ModF(FVecA, FVecI);
end;

procedure TFunctionsVector3PerfTests.TestPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Power(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestRadians;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Radians(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestRound;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Round(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestSign;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sign(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sin(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    SinCos(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector3PerfTests.TestSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sinh(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestSmoothStepScalarScalarVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := SmoothStep(FA, FB, FVecA);
end;

procedure TFunctionsVector3PerfTests.TestSmoothStepVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := SmoothStep(FVecB, FVecC, FVecA);
end;

procedure TFunctionsVector3PerfTests.TestSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sqrt(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestStepScalarVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Step(FA, FVecA);
end;

procedure TFunctionsVector3PerfTests.TestStepVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Step(FVecA, FVecB);
end;

procedure TFunctionsVector3PerfTests.TestTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Tan(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Tanh(FVecA);
end;

procedure TFunctionsVector3PerfTests.TestTrunc;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Trunc(FVecA);
end;

end.
