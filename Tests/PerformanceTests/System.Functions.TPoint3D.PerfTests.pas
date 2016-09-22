unit System.Functions.TPoint3D.PerfTests;

interface

uses
  System.Math.Vectors,
  PerformanceTest;

type
  TFunctionsPoint3DPerfTests = class(TPerformanceTest)
  private
    FPtA: TPoint3D;
    FPtB: TPoint3D;
    FPtC: TPoint3D;
    FA: Single;
  protected
    procedure Setup; override;
  published
    [TestName('Length(TPoint3D)')]
    procedure TestLength;

    [TestName('Distance(TPoint3D, TPoint3D)')]
    procedure TestDistance;

    [TestName('Dot(TPoint3D, TPoint3D)')]
    procedure TestDot;

    [TestName('Cross(TPoint3D, TPoint3D)')]
    procedure TestCross;

    [TestName('Normalize(TPoint3D)')]
    procedure TestNormalize;

    [TestName('Reflect(TPoint3D, TPoint3D)')]
    procedure TestReflect;
  end;

implementation

{ TFunctionsPoint3DPerfTests }

procedure TFunctionsPoint3DPerfTests.Setup;
begin
  inherited;
  FPtA := Point3D(1.2, 2.3, 3.4);
  FPtB := Point3D(4.5, 5.6, 6.7);
  FPtC := Point3D(0, 0, 0);
end;

procedure TFunctionsPoint3DPerfTests.TestCross;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtC := FPtA.CrossProduct(FPtB);
end;

procedure TFunctionsPoint3DPerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FPtA.Distance(FPtB);
end;

procedure TFunctionsPoint3DPerfTests.TestDot;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FPtA.DotProduct(FPtB);
end;

procedure TFunctionsPoint3DPerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FPtA.Length;
end;

procedure TFunctionsPoint3DPerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtB := FPtA.Normalize;
end;

procedure TFunctionsPoint3DPerfTests.TestReflect;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtC := FPtA.Reflect(FPtB);
end;

end.
