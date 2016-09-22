unit System.Functions.TPointF.PerfTests;

interface

uses
  System.Types,
  System.Math,
  PerformanceTest;

type
  TFunctionsPointFPerfTests = class(TPerformanceTest)
  private
    FPtA: TPointF;
    FPtB: TPointF;
    FPtC: TPointF;
    FA: Single;
  protected
    procedure Setup; override;
  published
    [TestName('Length(TPointF)')]
    procedure TestLength;

    [TestName('Distance(TPointF, TPointF)')]
    procedure TestDistance;

    [TestName('Dot(TPointF, TPointF)')]
    procedure TestDot;

    [TestName('Normalize(TPointF)')]
    procedure TestNormalize;

    [TestName('Reflect(TPointF, TPointF)')]
    procedure TestReflect;
  end;

implementation

{ TFunctionsPointFPerfTests }

procedure TFunctionsPointFPerfTests.Setup;
begin
  inherited;
  FPtA := PointF(1.2, 2.3);
  FPtB := PointF(3.4, 4.5);
  FPtC := PointF(0, 0);
end;

procedure TFunctionsPointFPerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FPtA.Distance(FPtB);
end;

procedure TFunctionsPointFPerfTests.TestDot;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FPtA.DotProduct(FPtB);
end;

procedure TFunctionsPointFPerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FPtA.Length;
end;

procedure TFunctionsPointFPerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtB := FPtA.Normalize;
end;

procedure TFunctionsPointFPerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtC := FPtA.Reflect(FPtB);
end;

end.
