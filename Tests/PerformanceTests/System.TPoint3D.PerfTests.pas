unit System.TPoint3D.PerfTests;

interface

uses
  System.Math,
  System.Math.Vectors,
  PerformanceTest;

type
  TPoint3DPerfTests = class(TPerformanceTest)
  private
    FPtA: TPoint3D;
    FPtB: TPoint3D;
    FPtC: TPoint3D;
    FA: Boolean;
    FB: Single;
  protected
    procedure Setup; override;
  published
    [TestName('TPoint3D = TPoint3D')]
    procedure TestVectorEqualVector;

    [TestName('TPoint3D <> TPoint3D')]
    procedure TestVectorNotEqualVector;

    [TestName('-TPoint3D')]
    procedure TestNegativeVector;

    [TestName('TPoint3D + TPoint3D')]
    procedure TestVectorAddVector;

    [TestName('TPoint3D - TPoint3D')]
    procedure TestVectorSubVector;

    [TestName('TPoint3D * Scalar')]
    procedure TestVectorMulScalar;

    [TestName('Scalar * TPoint3D')]
    procedure TestScalarMulVector;

    [TestName('TPoint3D * TPoint3D')]
    procedure TestVectorMulVector;

    [TestName('TPoint3D / Scalar')]
    procedure TestVectorDivScalar;

    [TestName('TPoint3D.Length')]
    procedure TestLength;

    [TestName('TPoint3D.Distance(TPoint3D)')]
    procedure TestDistance;

    [TestName('TPoint3D.DotProduct(TPoint3D)')]
    procedure TestDotProduct;

    [TestName('TPoint3D.CrossProduct(TPoint3D)')]
    procedure TestCrossProduct;

    [TestName('TPoint3D.Normalize')]
    procedure TestNormalize;

    [TestName('TPoint3D.Reflect(TPoint3D)')]
    procedure TestReflect;
  end;

implementation

{ TPoint3DPerfTests }

procedure TPoint3DPerfTests.Setup;
begin
  inherited;
  FPtA := Point3D(1.1, 2.2, 3.3);
  FPtB := Point3D(5.5, 6.6, 7.7);
end;

procedure TPoint3DPerfTests.TestCrossProduct;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtC := FPtA.CrossProduct(FPtB);
end;

procedure TPoint3DPerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.Distance(FPtB);
end;

procedure TPoint3DPerfTests.TestDotProduct;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.DotProduct(FPtB);
end;

procedure TPoint3DPerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.Length;
end;

procedure TPoint3DPerfTests.TestNegativeVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtB := -FPtA;
end;

procedure TPoint3DPerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtB := FPtA.Normalize;
end;

procedure TPoint3DPerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtC := FPtA.Reflect(FPtB);
end;

procedure TPoint3DPerfTests.TestScalarMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := 5.5 * FPtA;
end;

procedure TPoint3DPerfTests.TestVectorAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA + FPtB;
end;

procedure TPoint3DPerfTests.TestVectorDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA / 5.5;
end;

procedure TPoint3DPerfTests.TestVectorEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FA := (FPtA = FPtB);
end;

procedure TPoint3DPerfTests.TestVectorMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA * 5.5;
end;

procedure TPoint3DPerfTests.TestVectorMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA * FPtB;
end;

procedure TPoint3DPerfTests.TestVectorNotEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FA := (FPtA <> FPtB);
end;

procedure TPoint3DPerfTests.TestVectorSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA - FPtB;
end;

end.
