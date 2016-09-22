unit FastMath.TVector3.PerfTests;

interface

uses
  PerformanceTest,
  Neslib.FastMath;

type
  TVector3PerfTests = class(TPerformanceTest)
  private
    FVecA: TVector3;
    FVecB: TVector3;
    FVecC: TVector3;
    FVecD: TVector3;
    FA: Single;
    FB: Boolean;
  protected
    procedure Setup; override;
  published
    [TestName('TVector3 = TVector3')]
    procedure TestVectorEqualVector;

    [TestName('TVector3 <> TVector3')]
    procedure TestVectorNotEqualVector;

    [TestName('-TVector3')]
    procedure TestNegativeVector;

    [TestName('TVector3 + Scalar')]
    procedure TestVectorAddScalar;

    [TestName('Scalar + TVector3')]
    procedure TestScalarAddVector;

    [TestName('TVector3 + TVector3')]
    procedure TestVectorAddVector;

    [TestName('TVector3 - Scalar')]
    procedure TestVectorSubScalar;

    [TestName('Scalar - TVector3')]
    procedure TestScalarSubVector;

    [TestName('TVector3 - TVector3')]
    procedure TestVectorSubVector;

    [TestName('TVector3 * Scalar')]
    procedure TestVectorMulScalar;

    [TestName('Scalar * TVector3')]
    procedure TestScalarMulVector;

    [TestName('TVector3 * TVector3')]
    procedure TestVectorMulVector;

    [TestName('TVector3 / Scalar')]
    procedure TestVectorDivScalar;

    [TestName('Scalar / TVector3')]
    procedure TestScalarDivVector;

    [TestName('TVector3 / TVector3')]
    procedure TestVectorDivVector;

    [TestName('TVector3.Length')]
    procedure TestLength;

    [TestName('TVector3.Distance(TVector3)')]
    procedure TestDistance;

    [TestName('TVector3.DistanceSquared(TVector3)')]
    procedure TestDistanceSquared;

    [TestName('TVector3.Dot(TVector3)')]
    procedure TestDot;

    [TestName('TVector3.Cross(TVector3)')]
    procedure TestCross;

    [TestName('TVector3.Normalize')]
    procedure TestNormalize;

    [TestName('TVector3.FaceForward(TVector3, TVector3)')]
    procedure TestFaceForward;

    [TestName('TVector3.Reflect(TVector3)')]
    procedure TestReflect;

    [TestName('TVector3.Refract(TVector3, TVector3)')]
    procedure TestRefract;
  end;

implementation

{ TVector3PerfTests }

procedure TVector3PerfTests.Setup;
begin
  inherited;
  FVecA.Init(1.2, 2.3, 3.4);
  FVecB.Init(4.5, 5.6, 6.7);
  FVecC.Init(7.8, 8.9, 9.1);
  FVecD.Init;
end;

procedure TVector3PerfTests.TestCross;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FVecA.Cross(FVecB);
end;

procedure TVector3PerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Distance(FVecB);
end;

procedure TVector3PerfTests.TestDistanceSquared;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.DistanceSquared(FVecB);
end;

procedure TVector3PerfTests.TestDot;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Dot(FVecB);
end;

procedure TVector3PerfTests.TestFaceForward;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FVecB.FaceForward(FVecC, FVecA);
end;

procedure TVector3PerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Length;
end;

procedure TVector3PerfTests.TestNegativeVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecB := -FVecA;
end;

procedure TVector3PerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA.Normalize;
end;

procedure TVector3PerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FVecA.Reflect(FVecB);
end;

procedure TVector3PerfTests.TestRefract;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FVecA.Refract(FVecB, 7.8);
end;

procedure TVector3PerfTests.TestScalarAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 + FVecA;
end;

procedure TVector3PerfTests.TestScalarDivVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 / FVecA;
end;

procedure TVector3PerfTests.TestScalarMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 * FVecA;
end;

procedure TVector3PerfTests.TestScalarSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 - FVecA;
end;

procedure TVector3PerfTests.TestVectorAddScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + 5.5;
end;

procedure TVector3PerfTests.TestVectorAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + FVecB;
end;

procedure TVector3PerfTests.TestVectorDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / 5.5;
end;

procedure TVector3PerfTests.TestVectorDivVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / FVecB;
end;

procedure TVector3PerfTests.TestVectorEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FB := (FVecA = FVecB);
end;

procedure TVector3PerfTests.TestVectorMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * 5.5;
end;

procedure TVector3PerfTests.TestVectorMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * FVecB;
end;

procedure TVector3PerfTests.TestVectorNotEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FB := (FVecA <> FVecB);
end;

procedure TVector3PerfTests.TestVectorSubScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - 5.5;
end;

procedure TVector3PerfTests.TestVectorSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - FVecB;
end;

end.
