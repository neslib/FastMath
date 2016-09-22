unit FastMath.TMatrix3.PerfTests;

interface

uses
  PerformanceTest,
  Neslib.FastMath;

type
  TMatrix3PerfTests = class(TPerformanceTest)
  private
    FMatA: TMatrix3;
    FMatB: TMatrix3;
    FMatC: TMatrix3;
    FVecA: TVector3;
    FVecB: TVector3;
    FA: Single;
    FB: Boolean;
  protected
    procedure Setup; override;
  published
    [TestName('TMatrix3 = TMatrix3')]
    procedure TestMatrixEqualMatrix;

    [TestName('TMatrix3 <> TMatrix3')]
    procedure TestMatrixNotEqualMatrix;

    [TestName('-TMatrix3')]
    procedure TestNegativeMatrix;

    [TestName('TMatrix3 + Scalar')]
    procedure TestMatrixAddScalar;

    [TestName('Scalar + TMatrix3')]
    procedure TestScalarAddMatrix;

    [TestName('TMatrix3 + TMatrix3')]
    procedure TestMatrixAddMatrix;

    [TestName('TMatrix3 - Scalar')]
    procedure TestMatrixSubScalar;

    [TestName('Scalar - TMatrix3')]
    procedure TestScalarSubMatrix;

    [TestName('TMatrix3 - TMatrix3')]
    procedure TestMatrixSubMatrix;

    [TestName('TMatrix3 * Scalar')]
    procedure TestMatrixMulScalar;

    [TestName('Scalar * TMatrix3')]
    procedure TestScalarMulMatrix;

    [TestName('TMatrix3 * TVector3')]
    procedure TestMatrixMulVector;

    [TestName('TVector3 * TMatrix3')]
    procedure TestVectorMulMatrix;

    [TestName('TMatrix3 * TMatrix3')]
    procedure TestMatrixMulMatrix;

    [TestName('TMatrix3 / Scalar')]
    procedure TestMatrixDivScalar;

    [TestName('Scalar / TMatrix3')]
    procedure TestScalarDivMatrix;

    [TestName('TMatrix3 / TVector3', 100)]
    procedure TestMatrixDivVector;

    [TestName('TVector3 / TMatrix3', 100)]
    procedure TestVectorDivMatrix;

    [TestName('TMatrix3 / TMatrix3', 100)]
    procedure TestMatrixDivMatrix;

    [TestName('TMatrix3.CompMult(TMatrix3)')]
    procedure TestCompMult;

    [TestName('OuterProduct(TVector3, TVector3)')]
    procedure TestOuterProduct;

    [TestName('TMatrix3.Transpose')]
    procedure TestTranspose;

    [TestName('TMatrix3.Determinant')]
    procedure TestDeterminant;

    [TestName('TMatrix3.Inverse')]
    procedure TestInverse;
  end;

implementation

{ TMatrix3PerfTests }

procedure TMatrix3PerfTests.Setup;
begin
  inherited;
  FMatA := Matrix3(1, 2, 3, 4, 5, 6, 7, 8, 9);
  FMatB := Matrix3(5, 6, 7, 8, 9, 10, 11, 12, 13);
  FVecA := Vector3(5, 6, 7);
  FA := 5;
end;

procedure TMatrix3PerfTests.TestCompMult;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA.CompMult(FMatB);
end;

procedure TMatrix3PerfTests.TestDeterminant;
var
  I: Integer;
begin
  FMatA.Init(1, -2, -3, 4, 5, -6, -7, 8, 9);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FMatA.Determinant;
end;

procedure TMatrix3PerfTests.TestInverse;
var
  I: Integer;
begin
  FMatA.Init(0.6, 0.2, 0.3, 0.2, 0.7, 0.5, 0.3, 0.5, 0.7);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Inverse;
end;

procedure TMatrix3PerfTests.TestMatrixAddMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA + FMatB;
end;

procedure TMatrix3PerfTests.TestMatrixAddScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA + FA;
end;

procedure TMatrix3PerfTests.TestMatrixDivMatrix;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 100) - 1 do
    FMatC := FMatA / FMatB;
end;

procedure TMatrix3PerfTests.TestMatrixDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA / FA;
end;

procedure TMatrix3PerfTests.TestMatrixDivVector;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 100) - 1 do
    FVecB := FMatA / FVecA;
end;

procedure TMatrix3PerfTests.TestMatrixEqualMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := (FMatA = FMatB);
end;

procedure TMatrix3PerfTests.TestMatrixMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FMatB;
end;

procedure TMatrix3PerfTests.TestMatrixMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FA;
end;

procedure TMatrix3PerfTests.TestMatrixMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FMatA * FVecA;
end;

procedure TMatrix3PerfTests.TestMatrixNotEqualMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := (FMatA <> FMatB);
end;

procedure TMatrix3PerfTests.TestMatrixSubMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA - FMatB;
end;

procedure TMatrix3PerfTests.TestMatrixSubScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA - FA;
end;

procedure TMatrix3PerfTests.TestNegativeMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := -FMatA;
end;

procedure TMatrix3PerfTests.TestOuterProduct;
var
  I: Integer;
begin
  FVecA.Init(2, 3, 4);
  FVecB.Init(3, 4, 5);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := OuterProduct(FVecA, FVecB);
end;

procedure TMatrix3PerfTests.TestScalarAddMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA + FMatA;
end;

procedure TMatrix3PerfTests.TestScalarDivMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA / FMatA;
end;

procedure TMatrix3PerfTests.TestScalarMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA * FMatA;
end;

procedure TMatrix3PerfTests.TestScalarSubMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA - FMatA;
end;

procedure TMatrix3PerfTests.TestTranspose;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Transpose;
end;

procedure TMatrix3PerfTests.TestVectorDivMatrix;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 100) - 1 do
    FVecB := FVecA / FMatA;
end;

procedure TMatrix3PerfTests.TestVectorMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA * FMatA;
end;

end.
