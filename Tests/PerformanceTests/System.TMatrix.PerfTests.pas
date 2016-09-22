unit System.TMatrix.PerfTests;

interface

uses
  System.Math.Vectors,
  PerformanceTest;

type
  TMatrixPerfTests = class(TPerformanceTest)
  private
    FMatA: TMatrix;
    FMatB: TMatrix;
    FMatC: TMatrix;
    FPtA: TPoint3D;
    FPtB: TPoint3D;
    FA: Single;
  protected
    procedure Setup; override;
  private
    class function CreateMatrix(const A00, A01, A02, A10, A11, A12, A20, A21, A22: Single): TMatrix; static;
  published
    [TestName('TPoint3D * TMatrix')]
    procedure TestVectorMulMatrix;

    [TestName('TMatrix * TMatrix')]
    procedure TestMatrixMulMatrix;

    [TestName('TMatrix.Determinant')]
    procedure TestDeterminant;

    [TestName('TMatrix.Inverse')]
    procedure TestInverse;
  end;

implementation

{ TMatrixPerfTests }

class function TMatrixPerfTests.CreateMatrix(const A00, A01, A02, A10, A11, A12,
  A20, A21, A22: Single): TMatrix;
begin
  Result.m11 := A00;
  Result.m12 := A01;
  Result.m13 := A02;
  Result.m21 := A10;
  Result.m22 := A11;
  Result.m23 := A12;
  Result.m31 := A20;
  Result.m32 := A21;
  Result.m33 := A22;
end;

procedure TMatrixPerfTests.Setup;
begin
  inherited;
  FMatA := CreateMatrix(1, 2, 3, 4, 5, 6, 7, 8, 9);
  FMatB := CreateMatrix(5, 6, 7, 8, 9, 10, 11, 12, 13);
  FPtA := Point3D(5, 6, 7);
  FPtB := Point3D(0, 0, 0);
end;

procedure TMatrixPerfTests.TestDeterminant;
var
  I: Integer;
begin
  FMatA := CreateMatrix(1, -2, -3, 4, 5, -6, -7, 8, 9);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FMatA.Determinant;
end;

procedure TMatrixPerfTests.TestInverse;
var
  I: Integer;
begin
  FMatA := CreateMatrix(0.6, 0.2, 0.3, 0.2, 0.7, 0.5, 0.3, 0.5, 0.7);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Inverse;
end;

procedure TMatrixPerfTests.TestMatrixMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FMatB;
end;

procedure TMatrixPerfTests.TestVectorMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FPtB := FPtA * FMatA;
end;

end.
