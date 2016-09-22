unit System.TVector3D.PerfTests;

interface

uses
  System.Math.Vectors,
  PerformanceTest;

type
  TVector3DPerfTests = class(TPerformanceTest)
  private
    FVecA: TVector3D;
    FVecB: TVector3D;
    FVecC: TVector3D;
    FA: Boolean;
    FB: Single;
  protected
    procedure Setup; override;
  published
    [TestName('TVector3D = TVector3D')]
    procedure TestVectorEqualVector;

    [TestName('TVector3D <> TVector3D')]
    procedure TestVectorNotEqualVector;

    [TestName('-TVector3D')]
    procedure TestNegativeVector;

    [TestName('TVector3D + TVector3D')]
    procedure TestVectorAddVector;

    [TestName('TVector3D - TVector3D')]
    procedure TestVectorSubVector;

    [TestName('TVector3D * Scalar')]
    procedure TestVectorMulScalar;

    [TestName('Scalar * TVector3D')]
    procedure TestScalarMulVector;

    [TestName('TVector3D * TVector3D')]
    procedure TestVectorMulVector;

    [TestName('TVector3D / Scalar')]
    procedure TestVectorDivScalar;

    [TestName('TVector3D.Length')]
    procedure TestLength;

    [TestName('TVector3D.Distance(TVector3D)')]
    procedure TestDistance;

    [TestName('TVector3D.Normalize')]
    procedure TestNormalize;
  end;

implementation

{ TVector3DPerfTests }

procedure TVector3DPerfTests.Setup;
begin
  inherited;
  FVecA := Vector3D(1.1, 2.2, 3.3, 4.4);
  FVecB := Vector3D(5.5, 6.6, 7.7, 8.8);
end;

procedure TVector3DPerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FVecA.Distance(FVecB);
end;

procedure TVector3DPerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FVecA.Length;
end;

procedure TVector3DPerfTests.TestNegativeVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecB := -FVecA;
end;

procedure TVector3DPerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA.Normalize;
end;

procedure TVector3DPerfTests.TestScalarMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := 5.5 * FVecA;
end;

procedure TVector3DPerfTests.TestVectorAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA + FVecB;
end;

procedure TVector3DPerfTests.TestVectorDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA / 5.5;
end;

procedure TVector3DPerfTests.TestVectorEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FA := (FVecA = FVecB);
end;

procedure TVector3DPerfTests.TestVectorMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * 5.5;
end;

procedure TVector3DPerfTests.TestVectorMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA * FVecB;
end;

procedure TVector3DPerfTests.TestVectorNotEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FA := (FVecA <> FVecB);
end;

procedure TVector3DPerfTests.TestVectorSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FVecC := FVecA - FVecB;
end;

end.
