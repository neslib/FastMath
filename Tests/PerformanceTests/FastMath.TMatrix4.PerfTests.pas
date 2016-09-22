unit FastMath.TMatrix4.PerfTests;

interface

uses
  PerformanceTest,
  Neslib.FastMath;

type
  TMatrix4PerfTests = class(TPerformanceTest)
  private
    FMatA: TMatrix4;
    FMatB: TMatrix4;
    FMatC: TMatrix4;
    FVecA: TVector4;
    FVecB: TVector4;
    FA: Single;
    FB: Boolean;
  protected
    procedure Setup; override;
  published
    [TestName('TMatrix4 = TMatrix4')]
    procedure TestMatrixEqualMatrix;

    [TestName('TMatrix4 <> TMatrix4')]
    procedure TestMatrixNotEqualMatrix;

    [TestName('-TMatrix4')]
    procedure TestNegativeMatrix;

    [TestName('TMatrix4 + Scalar')]
    procedure TestMatrixAddScalar;

    [TestName('Scalar + TMatrix4')]
    procedure TestScalarAddMatrix;

    [TestName('TMatrix4 + TMatrix4')]
    procedure TestMatrixAddMatrix;

    [TestName('TMatrix4 - Scalar')]
    procedure TestMatrixSubScalar;

    [TestName('Scalar - TMatrix4')]
    procedure TestScalarSubMatrix;

    [TestName('TMatrix4 - TMatrix4')]
    procedure TestMatrixSubMatrix;

    [TestName('TMatrix4 * Scalar')]
    procedure TestMatrixMulScalar;

    [TestName('Scalar * TMatrix4')]
    procedure TestScalarMulMatrix;

    [TestName('TMatrix4 * TVector4')]
    procedure TestMatrixMulVector;

    [TestName('TVector4 * TMatrix4')]
    procedure TestVectorMulMatrix;

    [TestName('TMatrix4 * TMatrix4')]
    procedure TestMatrixMulMatrix;

    [TestName('TMatrix4 / Scalar')]
    procedure TestMatrixDivScalar;

    [TestName('Scalar / TMatrix4')]
    procedure TestScalarDivMatrix;

    [TestName('TMatrix4 / TVector4', 10)]
    procedure TestMatrixDivVector;

    [TestName('TVector4 / TMatrix4', 10)]
    procedure TestVectorDivMatrix;

    [TestName('TMatrix4 / TMatrix4', 10)]
    procedure TestMatrixDivMatrix;

    [TestName('TMatrix4.CompMult(TMatrix4)')]
    procedure TestCompMult;

    [TestName('OuterProduct(TVector4, TVector4)')]
    procedure TestOuterProduct;

    [TestName('TMatrix4.Transpose')]
    procedure TestTranspose;

    [TestName('TMatrix4.Determinant')]
    procedure TestDeterminant;

    [TestName('TMatrix4.Inverse')]
    procedure TestInverse;
  end;

implementation

{ TMatrix4PerfTests }

procedure TMatrix4PerfTests.Setup;
begin
  inherited;
  FMatA := Matrix4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
  FMatB := Matrix4(5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);
  FVecA := Vector4(5, 6, 7, 8);
  FA := 5;
end;

procedure TMatrix4PerfTests.TestCompMult;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA.CompMult(FMatB);
end;

procedure TMatrix4PerfTests.TestDeterminant;
var
  I: Integer;
begin
  FMatA.Init(1, -2, -3, 4, 5, -6, -7, 8, 9, 10, -11, -12, -13, 14, 15, 16);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FMatA.Determinant;
end;

procedure TMatrix4PerfTests.TestInverse;
var
  I: Integer;
begin
  FMatA.Init(0.6, 0.2, 0.3, 0.4, 0.2, 0.7, 0.5, 0.3, 0.3, 0.5, 0.7, 0.2, 0.4, 0.3, 0.2, 0.6);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Inverse;
end;

procedure TMatrix4PerfTests.TestMatrixAddMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA + FMatB;
end;

procedure TMatrix4PerfTests.TestMatrixAddScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA + FA;
end;

procedure TMatrix4PerfTests.TestMatrixDivMatrix;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 10) - 1 do
    FMatC := FMatA / FMatB;
end;

procedure TMatrix4PerfTests.TestMatrixDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA / FA;
end;

procedure TMatrix4PerfTests.TestMatrixDivVector;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 10) - 1 do
    FVecB := FMatA / FVecA;
end;

procedure TMatrix4PerfTests.TestMatrixEqualMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := (FMatA = FMatB);
end;

procedure TMatrix4PerfTests.TestMatrixMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FMatB;
end;

procedure TMatrix4PerfTests.TestMatrixMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FA;
end;

procedure TMatrix4PerfTests.TestMatrixMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FMatA * FVecA;
end;

procedure TMatrix4PerfTests.TestMatrixNotEqualMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := (FMatA <> FMatB);
end;

procedure TMatrix4PerfTests.TestMatrixSubMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA - FMatB;
end;

procedure TMatrix4PerfTests.TestMatrixSubScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA - FA;
end;

procedure TMatrix4PerfTests.TestNegativeMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := -FMatA;
end;

procedure TMatrix4PerfTests.TestOuterProduct;
var
  I: Integer;
begin
  FVecA.Init(2, 3, 4, 5);
  FVecB.Init(3, 4, 5, 6);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := OuterProduct(FVecA, FVecB);
end;

procedure TMatrix4PerfTests.TestScalarAddMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA + FMatA;
end;

procedure TMatrix4PerfTests.TestScalarDivMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA / FMatA;
end;

procedure TMatrix4PerfTests.TestScalarMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA * FMatA;
end;

procedure TMatrix4PerfTests.TestScalarSubMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA - FMatA;
end;

procedure TMatrix4PerfTests.TestTranspose;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Transpose;
end;

procedure TMatrix4PerfTests.TestVectorDivMatrix;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 10) - 1 do
    FVecB := FVecA / FMatA;
end;

procedure TMatrix4PerfTests.TestVectorMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA * FMatA;
end;

end.
