unit System.Functions.TVector3D.PerfTests;

interface

uses
  System.Math.Vectors,
  PerformanceTest;

type
  TFunctionsVector3DPerfTests = class(TPerformanceTest)
  private
    FVecA: TVector3D;
    FVecB: TVector3D;
    FVecC: TVector3D;
    FA: Single;
  protected
    procedure Setup; override;
  published
    [TestName('Length(TVector3D)')]
    procedure TestLength;

    [TestName('Distance(TVector3D, TVector3D)')]
    procedure TestDistance;

    [TestName('Normalize(TVector3D)')]
    procedure TestNormalize;
  end;

implementation

{ TFunctionsVector3DPerfTests }

procedure TFunctionsVector3DPerfTests.Setup;
begin
  inherited;
  FVecA := Vector3D(1.2, 2.3, 3.4, 4.5);
  FVecB := Vector3D(5.6, 6.7, 7.8, 8.9);
  FVecC := Vector3D(0, 0, 0, 1);
end;

procedure TFunctionsVector3DPerfTests.TestDistance;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Distance(FVecB);
end;

procedure TFunctionsVector3DPerfTests.TestLength;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FVecA.Length;
end;

procedure TFunctionsVector3DPerfTests.TestNormalize;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA.Normalize;
end;

end.
