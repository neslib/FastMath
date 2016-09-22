unit System.TMatrix3D.PerfTests;

interface

uses
  System.Math.Vectors,
  PerformanceTest;

type
  TMatrix3DPerfTests = class(TPerformanceTest)
  private
    FMatA: TMatrix3D;
    FMatB: TMatrix3D;
    FMatC: TMatrix3D;
    FVecA: TVector3D;
    FVecB: TVector3D;
    FA: Single;
  protected
    procedure Setup; override;
  published
    [TestName('TVector3D * TMatrix3D')]
    procedure TestVectorMulMatrix;

    [TestName('TMatrix3D * TMatrix3D')]
    procedure TestMatrixMulMatrix;

    [TestName('TMatrix3D.Transpose')]
    procedure TestTranspose;

    [TestName('TMatrix3D.Determinant')]
    procedure TestDeterminant;

    [TestName('TMatrix3D.Inverse')]
    procedure TestInverse;
  end;

implementation

{ TMatrix3DPerfTests }

procedure TMatrix3DPerfTests.Setup;
begin
  inherited;
  FMatA := TMatrix3D.Create(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
  FMatB := TMatrix3D.Create(5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);
  FVecA := TVector3D.Create(5, 6, 7, 8);
end;

procedure TMatrix3DPerfTests.TestDeterminant;
var
  I: Integer;
begin
  FMatA := TMatrix3D.Create(1, -2, -3, 4, 5, -6, -7, 8, 9, 10, -11, -12, -13, 14, 15, 16);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FMatA.Determinant;
end;

procedure TMatrix3DPerfTests.TestInverse;
var
  I: Integer;
begin
  FMatA := TMatrix3D.Create(0.6, 0.2, 0.3, 0.4, 0.2, 0.7, 0.5, 0.3, 0.3, 0.5, 0.7, 0.2, 0.4, 0.3, 0.2, 0.6);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Inverse;
end;

procedure TMatrix3DPerfTests.TestTranspose;
var
  I: Integer;
begin
  FMatA := TMatrix3D.Create(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Transpose;
end;

procedure TMatrix3DPerfTests.TestMatrixMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FMatB;
end;

procedure TMatrix3DPerfTests.TestVectorMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA * FMatA;
end;

end.
