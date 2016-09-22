unit FastMath.Functions.TVector2.PerfTests;

interface

uses
  System.Math,
  PerformanceTest,
  Neslib.FastMath;

type
  TFunctionsVector2PerfTests = class(TPerformanceTest)
  private
    FVecA: TVector2;
    FVecB: TVector2;
    FVecC: TVector2;
    FVecD: TVector2;
    FVecI: TIVector2;
    FA: Single;
    FB: Single;
  protected
    procedure Setup; override;
  published
    [TestName('Radians(TVector2)')]
    procedure TestRadians;

    [TestName('Degrees(TVector2)')]
    procedure TestDegrees;

    [TestName('Sin(TVector2)')]
    procedure TestSin;

    [TestName('FastSin(TVector2)')]
    procedure TestFastSin;

    [TestName('Cos(TVector2)')]
    procedure TestCos;

    [TestName('FastCos(TVector2)')]
    procedure TestFastCos;

    [TestName('SinCos(TVector2)')]
    procedure TestSinCos;

    [TestName('FastSinCos(TVector2)')]
    procedure TestFastSinCos;

    [TestName('Tan(TVector2)')]
    procedure TestTan;

    [TestName('FastTan(TVector2)')]
    procedure TestFastTan;

    [TestName('ArcSin(TVector2)')]
    procedure TestArcSin;

    [TestName('ArcCos(TVector2)')]
    procedure TestArcCos;

    [TestName('ArcTan(TVector2)')]
    procedure TestArcTan;

    [TestName('ArcTan2(TVector2, TVector2)')]
    procedure TestArcTan2;

    [TestName('FastArcTan2(TVector2, TVector2)')]
    procedure TestFastArcTan2;

    [TestName('Sinh(TVector2)')]
    procedure TestSinh;

    [TestName('Cosh(TVector2)')]
    procedure TestCosh;

    [TestName('Tanh(TVector2)')]
    procedure TestTanh;

    [TestName('ArcSinh(TVector2)')]
    procedure TestArcSinh;

    [TestName('ArcCosh(TVector2)')]
    procedure TestArcCosh;

    [TestName('ArcTanh(TVector2)')]
    procedure TestArcTanh;

    [TestName('Power(TVector2, TVector2)')]
    procedure TestPower;

    [TestName('FastPower(TVector2, TVector2)')]
    procedure TestFastPower;

    [TestName('Exp(TVector2)')]
    procedure TestExp;

    [TestName('FastExp(TVector2)')]
    procedure TestFastExp;

    [TestName('Ln(TVector2)')]
    procedure TestLn;

    [TestName('FastLn(TVector2)')]
    procedure TestFastLn;

    [TestName('Exp2(TVector2)')]
    procedure TestExp2;

    [TestName('FastExp2(TVector2)')]
    procedure TestFastExp2;

    [TestName('Log2(TVector2)')]
    procedure TestLog2;

    [TestName('FastLog2(TVector2)')]
    procedure TestFastLog2;

    [TestName('Sqrt(TVector2)')]
    procedure TestSqrt;

    [TestName('InverseSqrt(TVector2)')]
    procedure TestInverseSqrt;

    [TestName('Abs(TVector2)')]
    procedure TestAbs;

    [TestName('Sign(TVector2)')]
    procedure TestSign;

    [TestName('Floor(TVector2)')]
    procedure TestFloor;

    [TestName('Trunc(TVector2)')]
    procedure TestTrunc;

    [TestName('Round(TVector2)')]
    procedure TestRound;

    [TestName('Ceil(TVector2)')]
    procedure TestCeil;

    [TestName('Frac(TVector2)')]
    procedure TestFrac;

    [TestName('FMod(TVector2, TVector2)')]
    procedure TestFModVectorVector;

    [TestName('ModF(TVector2, TVector2)')]
    procedure TestModF;

    [TestName('Min(TVector2, TVector2)')]
    procedure TestMinVectorVector;

    [TestName('Max(TVector2, TVector2)')]
    procedure TestMaxVectorVector;

    [TestName('EnsureRange(TVector2, TVector2, TVector2)')]
    procedure TestEnsureRangeVectorVectorVector;

    [TestName('Mix(TVector2, TVector2, TVector2)')]
    procedure TestMixVectorVectorVector;

    [TestName('Step(TVector2, TVector2)')]
    procedure TestStepVectorVector;

    [TestName('SmoothStep(TVector2, TVector2, TVector2)')]
    procedure TestSmoothStepVectorVectorVector;

    [TestName('FMA(TVector2, TVector2, TVector2)')]
    procedure TestFMA;

    [TestName('FMod(TVector2, Scalar)')]
    procedure TestFModVectorScalar;

    [TestName('Min(TVector2, Scalar)')]
    procedure TestMinVectorScalar;

    [TestName('Max(TVector2, Scalar)')]
    procedure TestMaxVectorScalar;

    [TestName('EnsureRange(TVector2, Scalar, Scalar)')]
    procedure TestEnsureRangeVectorScalarScalar;

    [TestName('Mix(TVector2, TVector2, Scalar)')]
    procedure TestMixVectorVectorScalar;

    [TestName('Step(Scalar, TVector2)')]
    procedure TestStepScalarVector;

    [TestName('SmoothStep(Scalar, Scalar, TVector2)')]
    procedure TestSmoothStepScalarScalarVector;
  end;

implementation

{ TFunctionsVector2PerfTests }

procedure TFunctionsVector2PerfTests.Setup;
begin
  inherited;
  FVecA.Init(1.2, 2.3);
  FVecB.Init(3.4, 4.5);
  FVecC.Init(5.6, 6.7);
  FA := 2;
  FB := 3;
end;

procedure TFunctionsVector2PerfTests.TestAbs;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Abs(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestArcCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcCos(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestArcCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcCosh(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestArcSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcSin(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestArcSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcSinh(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestArcTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcTan(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Neslib.FastMath.ArcTan2(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestArcTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := ArcTanh(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestCeil;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Ceil(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestEnsureRangeVectorScalarScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := EnsureRange(FVecA, FA, FB);
end;

procedure TFunctionsVector2PerfTests.TestEnsureRangeVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := EnsureRange(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector2PerfTests.TestCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Cos(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestCosh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Cosh(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestDegrees;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Degrees(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Exp(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Exp2(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastArcTan2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Neslib.FastMath.FastArcTan2(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestFastCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastCos(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastExp;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastExp(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastExp2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastExp2(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastLn(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Neslib.FastMath.FastLog2(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FastPower(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestFastSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastSin(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFastSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FastSinCos(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector2PerfTests.TestFastTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FastTan(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFloor;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Floor(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFMA;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FMA(FVecB, FVecC, FVecA);
end;

procedure TFunctionsVector2PerfTests.TestFrac;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Frac(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestInverseSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := InverseSqrt(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestLn;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Ln(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestLog2;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Log2(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestMaxVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Max(FVecA, FA);
end;

procedure TFunctionsVector2PerfTests.TestMaxVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Max(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestMinVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Min(FVecA, FA);
end;

procedure TFunctionsVector2PerfTests.TestMinVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Min(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestMixVectorVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := Mix(FVecA, FVecB, FA);
end;

procedure TFunctionsVector2PerfTests.TestMixVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := Mix(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector2PerfTests.TestFModVectorScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FMod(FVecA, FA);
end;

procedure TFunctionsVector2PerfTests.TestFModVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FMod(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestModF;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := ModF(FVecA, FVecI);
end;

procedure TFunctionsVector2PerfTests.TestPower;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Power(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestRadians;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Radians(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestRound;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Round(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestSign;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sign(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestSin;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sin(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestSinCos;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    SinCos(FVecA, FVecB, FVecC);
end;

procedure TFunctionsVector2PerfTests.TestSinh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sinh(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestSmoothStepScalarScalarVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := SmoothStep(FA, FB, FVecA);
end;

procedure TFunctionsVector2PerfTests.TestSmoothStepVectorVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := SmoothStep(FVecB, FVecC, FVecA);
end;

procedure TFunctionsVector2PerfTests.TestSqrt;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Sqrt(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestStepScalarVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Step(FB, FVecA);
end;

procedure TFunctionsVector2PerfTests.TestStepVectorVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := Step(FVecA, FVecB);
end;

procedure TFunctionsVector2PerfTests.TestTan;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Tan(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestTanh;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := Tanh(FVecA);
end;

procedure TFunctionsVector2PerfTests.TestTrunc;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecI := Trunc(FVecA);
end;

end.
