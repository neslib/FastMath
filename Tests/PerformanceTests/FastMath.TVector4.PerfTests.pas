unit FastMath.TVector4.PerfTests;

interface

uses
  PerformanceTest,
  Neslib.FastMath;

type
  TVector4PerfTests = class(TPerformanceTest)
  private
    FVecA: TVector4;
    FVecB: TVector4;
    FVecC: TVector4;
    FVecD: TVector4;
    FA: Single;
    FB: Boolean;
  protected
    procedure Setup; override;
  published
    [TestName('TVector4 = TVector4')]
    procedure TestVectorEqualVector;

    [TestName('TVector4 <> TVector4')]
    procedure TestVectorNotEqualVector;

    [TestName('-TVector4')]
    procedure TestNegativeVector;

    [TestName('TVector4 + Scalar')]
    procedure TestVectorAddScalar;

    [TestName('Scalar + TVector4')]
    procedure TestScalarAddVector;

    [TestName('TVector4 + TVector4')]
    procedure TestVectorAddVector;

    [TestName('TVector4 - Scalar')]
    procedure TestVectorSubScalar;

    [TestName('Scalar - TVector4')]
    procedure TestScalarSubVector;

    [TestName('TVector4 - TVector4')]
    procedure TestVectorSubVector;

    [TestName('TVector4 * Scalar')]
    procedure TestVectorMulScalar;

    [TestName('Scalar * TVector4')]
    procedure TestScalarMulVector;

    [TestName('TVector4 * TVector4')]
    procedure TestVectorMulVector;

    [TestName('TVector4 / Scalar')]
    procedure TestVectorDivScalar;

    [TestName('Scalar / TVector4')]
    procedure TestScalarDivVector;

    [TestName('TVector4 / TVector4')]
    procedure TestVectorDivVector;

    [TestName('TVector4.Length')]
    procedure TestLength;

    [TestName('TVector4.Distance(TVector4)')]
    procedure TestDistance;

    [TestName('TVector4.DistanceSquared(TVector4)')]
    procedure TestDistanceSquared;

    [TestName('TVector4.Dot(TVector4)')]
    procedure TestDot;

    [TestName('TVector4.Normalize')]
    procedure TestNormalize;

    [TestName('TVector4.FaceForward(TVector4, TVector4)')]
    procedure TestFaceForward;

    [TestName('TVector4.Reflect(TVector4)')]
    procedure TestReflect;

    [TestName('TVector4.Refract(TVector4, TVector4)')]
    procedure TestRefract;
  end;

implementation

{ TVector4PerfTests }

procedure TVector4PerfTests.Setup;
begin
  inherited;
  FVecA.Init(1.2, 2.3, 3.4, 4.5);
  FVecB.Init(5.6, 6.7, 7.8, 8.9);
  FVecC.Init(9.10, 10.11, 11.12, 12.13);
  FVecD.Init;
end;

procedure TVector4PerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Distance(FVecB);
end;

procedure TVector4PerfTests.TestDistanceSquared;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.DistanceSquared(FVecB);
end;

procedure TVector4PerfTests.TestDot;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Dot(FVecB);
end;

procedure TVector4PerfTests.TestFaceForward;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FVecB.FaceForward(FVecC, FVecA);
end;

procedure TVector4PerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Length;
end;

procedure TVector4PerfTests.TestNegativeVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecB := -FVecA;
end;

procedure TVector4PerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA.Normalize;
end;

procedure TVector4PerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FVecA.Reflect(FVecB);
end;

procedure TVector4PerfTests.TestRefract;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FVecA.Refract(FVecB, 9.1);
end;

procedure TVector4PerfTests.TestScalarAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 + FVecA;
end;

procedure TVector4PerfTests.TestScalarDivVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecB / FVecA;
end;

procedure TVector4PerfTests.TestScalarMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 * FVecA;
end;

procedure TVector4PerfTests.TestScalarSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 - FVecA;
end;

procedure TVector4PerfTests.TestVectorAddScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + 5.5;
end;

procedure TVector4PerfTests.TestVectorAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + FVecB;
end;

procedure TVector4PerfTests.TestVectorDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / 5.5;
end;

procedure TVector4PerfTests.TestVectorDivVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / FVecB;
end;

procedure TVector4PerfTests.TestVectorEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FB := (FVecA = FVecB);
end;

procedure TVector4PerfTests.TestVectorMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * 5.5;
end;

procedure TVector4PerfTests.TestVectorMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * FVecB;
end;

procedure TVector4PerfTests.TestVectorNotEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FB := (FVecA <> FVecB);
end;

procedure TVector4PerfTests.TestVectorSubScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - 5.5;
end;

procedure TVector4PerfTests.TestVectorSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - FVecB;
end;

end.
