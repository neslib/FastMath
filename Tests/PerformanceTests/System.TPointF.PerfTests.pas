unit System.TPointF.PerfTests;

interface

uses
  PerformanceTest,
  System.Types;

type
  TPointFPerfTests = class(TPerformanceTest)
  private
    FPtA: TPointF;
    FPtB: TPointF;
    FPtC: TPointF;
    FA: Boolean;
    FB: Single;
  protected
    procedure Setup; override;
  published
    [TestName('TPointF = TPointF')]
    procedure TestVectorEqualVector;

    [TestName('TPointF <> TPointF')]
    procedure TestVectorNotEqualVector;

    [TestName('-TPointF')]
    procedure TestNegativeVector;

    [TestName('TPointF + TPointF')]
    procedure TestVectorAddVector;

    [TestName('TPointF - TPointF')]
    procedure TestVectorSubVector;

    [TestName('TPointF * Scalar')]
    procedure TestVectorMulScalar;

    [TestName('Scalar * TPointF')]
    procedure TestScalarMulVector;

    [TestName('TPointF * TPointF')]
    procedure TestVectorMulVector;

    [TestName('TPointF / Scalar')]
    procedure TestVectorDivScalar;

    [TestName('TPointF.Length')]
    procedure TestLength;

    [TestName('TPointF.Distance(TPointF)')]
    procedure TestDistance;

    [TestName('TPointF.DotProduct(TPointF)')]
    procedure TestDotProduct;

    [TestName('TPointF.CrossProduct(TPointF)')]
    procedure TestCrossProduct;

    [TestName('TPointF.Normalize')]
    procedure TestNormalize;

    [TestName('TPointF.Reflect(TPointF)')]
    procedure TestReflect;
  end;

implementation

{ TPointFPerfTests }

procedure TPointFPerfTests.Setup;
begin
  inherited;
  FPtA := PointF(1.1, 2.2);
  FPtB := PointF(5.5, 6.6);
end;

procedure TPointFPerfTests.TestCrossProduct;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.CrossProduct(FPtB);
end;

procedure TPointFPerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.Distance(FPtB);
end;

procedure TPointFPerfTests.TestDotProduct;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.DotProduct(FPtB);
end;

procedure TPointFPerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := FPtA.Length;
end;

procedure TPointFPerfTests.TestNegativeVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtB := -FPtA;
end;

procedure TPointFPerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtB := FPtA.Normalize;
end;

procedure TPointFPerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtC := FPtA.Reflect(FPtB);
end;

procedure TPointFPerfTests.TestScalarMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := 5.5 * FPtA;
end;

procedure TPointFPerfTests.TestVectorAddVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA + FPtB;
end;

procedure TPointFPerfTests.TestVectorDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA / 5.5;
end;

procedure TPointFPerfTests.TestVectorEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FA := (FPtA = FPtB);
end;

procedure TPointFPerfTests.TestVectorMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA * 5.5;
end;

procedure TPointFPerfTests.TestVectorMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA * FPtB;
end;

procedure TPointFPerfTests.TestVectorNotEqualVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FA := (FPtA <> FPtB);
end;

procedure TPointFPerfTests.TestVectorSubVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_LARGE - 1 do
    FPtC := FPtA - FPtB;
end;

end.
