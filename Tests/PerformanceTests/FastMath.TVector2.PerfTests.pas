unit FastMath.TVector2.PerfTests;

interface

uses
  PerformanceTest,
  Neslib.FastMath;

type
  TVector2PerfTests = class(TPerformanceTest)
  private
    FVecA: TVector2;
    FVecB: TVector2;
    FVecC: TVector2;
    FVecD: TVector2;
    FA: Single;
    FB: Boolean;
  protected
    procedure Setup; override;
  published
    [TestName('TVector2 = TVector2')]
    procedure TestVectorEqualVector;

    [TestName('TVector2 <> TVector2')]
    procedure TestVectorNotEqualVector;

    [TestName('-TVector2')]
    procedure TestNegativeVector;

    [TestName('TVector2 + Scalar')]
    procedure TestVectorAddScalar;

    [TestName('Scalar + TVector2')]
    procedure TestScalarAddVector;

    [TestName('TVector2 + TVector2')]
    procedure TestVectorAddVector;

    [TestName('TVector2 - Scalar')]
    procedure TestVectorSubScalar;

    [TestName('Scalar - TVector2')]
    procedure TestScalarSubVector;

    [TestName('TVector2 - TVector2')]
    procedure TestVectorSubVector;

    [TestName('TVector2 * Scalar')]
    procedure TestVectorMulScalar;

    [TestName('Scalar * TVector2')]
    procedure TestScalarMulVector;

    [TestName('TVector2 * TVector2')]
    procedure TestVectorMulVector;

    [TestName('TVector2 / Scalar')]
    procedure TestVectorDivScalar;

    [TestName('Scalar / TVector2')]
    procedure TestScalarDivVector;

    [TestName('TVector2 / TVector2')]
    procedure TestVectorDivVector;

    [TestName('TVector2.Length')]
    procedure TestLength;

    [TestName('TVector2.Distance(TVector2)')]
    procedure TestDistance;

    [TestName('TVector2.DistanceSquared(TVector2)')]
    procedure TestDistanceSquared;

    [TestName('TVector2.Dot(TVector2)')]
    procedure TestDot;

    [TestName('TVector2.Cross(TVector2)')]
    procedure TestCross;

    [TestName('TVector2.Normalize')]
    procedure TestNormalize;

    [TestName('TVector2.FaceForward(TVector2, TVector2)')]
    procedure TestFaceForward;

    [TestName('TVector2.Reflect(TVector2)')]
    procedure TestReflect;

    [TestName('TVector2.Refract(TVector2, TVector2)')]
    procedure TestRefract;
  end;

implementation

{ TVector2PerfTests }

procedure TVector2PerfTests.Setup;
begin
  inherited;
  FVecA.Init(1.2, 2.3);
  FVecB.Init(3.4, 4.5);
  FVecC.Init(5.6, 6.7);
  FVecD.Init;
end;

procedure TVector2PerfTests.TestCross;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Cross(FVecB);
end;

procedure TVector2PerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Distance(FVecB);
end;

procedure TVector2PerfTests.TestDistanceSquared;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.DistanceSquared(FVecB);
end;

procedure TVector2PerfTests.TestDot;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Dot(FVecB);
end;

procedure TVector2PerfTests.TestFaceForward;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FVecB.FaceForward(FVecC, FVecA);
end;

procedure TVector2PerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Length;
end;

procedure TVector2PerfTests.TestNegativeVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecB := -FVecA;
end;

procedure TVector2PerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA.Normalize;
end;

procedure TVector2PerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecC := FVecA.Reflect(FVecB);
end;

procedure TVector2PerfTests.TestRefract;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecD := FVecA.Refract(FVecB, 5.5);
end;

procedure TVector2PerfTests.TestScalarAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 + FVecA;
end;

procedure TVector2PerfTests.TestScalarDivVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 / FVecA;
end;

procedure TVector2PerfTests.TestScalarMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 * FVecA;
end;

procedure TVector2PerfTests.TestScalarSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 - FVecA;
end;

procedure TVector2PerfTests.TestVectorAddScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + 5.5;
end;

procedure TVector2PerfTests.TestVectorAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + FVecB;
end;

procedure TVector2PerfTests.TestVectorDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / 5.5;
end;

procedure TVector2PerfTests.TestVectorDivVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / FVecB;
end;

procedure TVector2PerfTests.TestVectorEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FB := (FVecA = FVecB);
end;

procedure TVector2PerfTests.TestVectorMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * 5.5;
end;

procedure TVector2PerfTests.TestVectorMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * FVecB;
end;

procedure TVector2PerfTests.TestVectorNotEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FB := (FVecA <> FVecB);
end;

procedure TVector2PerfTests.TestVectorSubScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - 5.5;
end;

procedure TVector2PerfTests.TestVectorSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - FVecB;
end;

end.
