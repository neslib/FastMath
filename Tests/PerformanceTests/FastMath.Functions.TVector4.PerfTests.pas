unit FastMath.Functions.TVector4.PerfTests;

interface

uses
  System.Math,
  PerformanceTest,
  Neslib.FastMath;

type
  TFunctionsVector4PerfTests = class(TPerformanceTest)
  private
    FVecA: TVector4;
    FVecB: TVector4;
    FVecC: TVector4;
    FVecD: TVector4;
    FVecI: TIVector4;
    FA: Single;
    FB: Single;
  protected
    procedure Setup; override;
  published
    [TestName('Radians(TVector4)')]
    procedure TestRadians;

    [TestName('Degrees(TVector4)')]
    procedure TestDegrees;

    [TestName('Sin(TVector4)')]
    procedure TestSin;

    [TestName('FastSin(TVector4)')]
    procedure TestFastSin;

    [TestName('Cos(TVector4)')]
    procedure TestCos;

    [TestName('FastCos(TVector4)')]
    procedure TestFastCos;

    [TestName('SinCos(TVector4)')]
    procedure TestSinCos;

    [TestName('FastSinCos(TVector4)')]
    procedure TestFastSinCos;

    [TestName('Tan(TVector4)')]
    procedure TestTan;

    [TestName('FastTan(TVector4)')]
    procedure TestFastTan;

    [TestName('ArcSin(TVector4)')]
    procedure TestArcSin;

    [TestName('ArcCos(TVector4)')]
    procedure TestArcCos;

    [TestName('ArcTan(TVector4)')]
    procedure TestArcTan;

    [TestName('ArcTan2(TVector4, TVector4)')]
    procedure TestArcTan2;

    [TestName('FastArcTan2(TVector4, TVector4)')]
    procedure TestFastArcTan2;

    [TestName('Sinh(TVector4)')]
    procedure TestSinh;

    [TestName('Cosh(TVector4)')]
    procedure TestCosh;

    [TestName('Tanh(TVector4)')]
    procedure TestTanh;

    [TestName('ArcSinh(TVector4)')]
    procedure TestArcSinh;

    [TestName('ArcCosh(TVector4)')]
    procedure TestArcCosh;

    [TestName('ArcTanh(TVector4)')]
    procedure TestArcTanh;

    [TestName('Power(TVector4, TVector4)')]
    procedure TestPower;

    [TestName('FastPower(TVector4, TVector4)')]
    procedure TestFastPower;

    [TestName('Exp(TVector4)')]
    procedure TestExp;

    [TestName('FastExp(TVector4)')]
    procedure TestFastExp;

    [TestName('Ln(TVector4)')]
    procedure TestLn;

    [TestName('FastLn(TVector4)')]
    procedure TestFastLn;

    [TestName('Exp2(TVector4)')]
    procedure TestExp2;

    [TestName('FastExp2(TVector4)')]
    procedure TestFastExp2;

    [TestName('Log2(TVector4)')]
    procedure TestLog2;

    [TestName('FastLog2(TVector4)')]
    procedure TestFastLog2;

    [TestName('Sqrt(TVector4)')]
    procedure TestSqrt;

    [TestName('InverseSqrt(TVector4)')]
    procedure TestInverseSqrt;

    [TestName('Abs(TVector4)')]
    procedure TestAbs;

    [TestName('Sign(TVector4)')]
    procedure TestSign;

    [TestName('Floor(TVector4)')]
    procedure TestFloor;

    [TestName('Trunc(TVector4)')]
    procedure TestTrunc;

    [TestName('Round(TVector4)')]
    procedure TestRound;

    [TestName('Ceil(TVector4)')]
    procedure TestCeil;

    [TestName('Frac(TVector4)')]
    procedure TestFrac;

    [TestName('FMod(TVector4, TVector4)')]
    procedure TestFModVectorVector;

    [TestName('ModF(TVector4, TVector4)')]
    procedure TestModF;

    [TestName('Min(TVector4, TVector4)')]
    procedure TestMinVectorVector;

    [TestName('Max(TVector4, TVector4)')]
    procedure TestMaxVectorVector;

    [TestName('EnsureRange(TVector4, TVector4, TVector4)')]
    procedure TestEnsureRangeVectorVectorVector;

    [TestName('Mix(TVector4, TVector4, TVector4)')]
    procedure TestMixVectorVectorVector;

    [TestName('Step(TVector4, TVector4)')]
    procedure TestStepVectorVector;

    [TestName('SmoothStep(TVector4, TVector4, TVector4)')]
    procedure TestSmoothStepVectorVectorVector;

    [TestName('FMA(TVector4, TVector4, TVector4)')]
    procedure TestFMA;

    [TestName('FMod(TVector4, Scalar)')]
    procedure TestFModVectorScalar;

    [TestName('Min(TVector4, Scalar)')]
    procedure TestMinVectorScalar;

    [TestName('Max(TVector4, Scalar)')]
    procedure TestMaxVectorScalar;

    [TestName('EnsureRange(TVector4, Scalar, Scalar)')]
    procedure TestEnsureRangeVectorScalarScalar;

    [TestName('Mix(TVector4, TVector4, Scalar)')]
    procedure TestMixVectorVectorScalar;

    [TestName('Step(Scalar, TVector4)')]
    procedure TestStepScalarVector;

    [TestName('SmoothStep(Scalar, Scalar, TVector4)')]
    procedure TestSmoothStepScalarScalarVector;
  end;

implementation

{ TFunctionsVector4PerfTests }

procedure TFunctionsVector4PerfTests.Setup;
begin
  inherited;
  FVecA.Init(1.2, 2.3, 3.4, 4.5);
  FVecB.Init(5.6, 6.7, 7.8, 8.9);
  FVecC.Init(9.10, 10.11, 11.12, 12.13);
  FA := 5.6;
  FB := 6.7;
end;

procedure TFunctionsVector4PerfTests.TestAbs;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Abs(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestArcCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcCos(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestArcCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcCosh(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestArcSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcSin(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestArcSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcSinh(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestArcTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcTan(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Neslib.FastMath.ArcTan2(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestArcTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcTanh(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestCeil;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Ceil(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestEnsureRangeVectorScalarScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := EnsureRange(FVecA, FA, FB);
end;

procedure TFunctionsVector4PerfTests.TestEnsureRangeVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := EnsureRange(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector4PerfTests.TestCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Cos(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Cosh(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestDegrees;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Degrees(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Exp(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Exp2(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Neslib.FastMath.FastArcTan2(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestFastCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastCos(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastExp(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastExp2(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastLn(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Neslib.FastMath.FastLog2(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FastPower(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestFastSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastSin(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFastSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FastSinCos(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector4PerfTests.TestFastTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastTan(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFloor;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Floor(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFMA;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FMA(FVecB, FVecC, FVecA);
end;

procedure TFunctionsVector4PerfTests.TestFrac;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Frac(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestInverseSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := InverseSqrt(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Ln(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Log2(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestMaxVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Max(FVecA, FA);
end;

procedure TFunctionsVector4PerfTests.TestMaxVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Max(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestMinVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Min(FVecA, FA);
end;

procedure TFunctionsVector4PerfTests.TestMinVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Min(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestMixVectorVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := Mix(FVecA, FVecB, FA);
end;

procedure TFunctionsVector4PerfTests.TestMixVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := Mix(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector4PerfTests.TestFModVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FMod(FVecA, FA);
end;

procedure TFunctionsVector4PerfTests.TestFModVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FMod(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestModF;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := ModF(FVecA, FVecI);
end;

procedure TFunctionsVector4PerfTests.TestPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Power(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestRadians;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Radians(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestRound;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Round(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestSign;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sign(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sin(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    SinCos(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector4PerfTests.TestSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sinh(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestSmoothStepScalarScalarVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := SmoothStep(FA, FB, FVecA);
end;

procedure TFunctionsVector4PerfTests.TestSmoothStepVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := SmoothStep(FVecB, FVecC, FVecA);
end;

procedure TFunctionsVector4PerfTests.TestSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sqrt(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestStepScalarVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Step(FA, FVecA);
end;

procedure TFunctionsVector4PerfTests.TestStepVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Step(FVecA, FVecB);
end;

procedure TFunctionsVector4PerfTests.TestTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Tan(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Tanh(FVecA);
end;

procedure TFunctionsVector4PerfTests.TestTrunc;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Trunc(FVecA);
end;

end.
