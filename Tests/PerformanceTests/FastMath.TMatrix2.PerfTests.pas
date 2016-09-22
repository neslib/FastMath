unit FastMath.TMatrix2.PerfTests;

interface

uses
  PerformanceTest,
  Neslib.FastMath;

type
  TMatrix2PerfTests = class(TPerformanceTest)
  private
    FMatA: TMatrix2;
    FMatB: TMatrix2;
    FMatC: TMatrix2;
    FVecA: TVector2;
    FVecB: TVector2;
    FA: Single;
    FB: Boolean;
  protected
    procedure Setup; override;
  published
    [TestName('TMatrix2 = TMatrix2')]
    procedure TestMatrixEqualMatrix;

    [TestName('TMatrix2 <> TMatrix2')]
    procedure TestMatrixNotEqualMatrix;

    [TestName('-TMatrix2')]
    procedure TestNegativeMatrix;

    [TestName('TMatrix2 + Scalar')]
    procedure TestMatrixAddScalar;

    [TestName('Scalar + TMatrix2')]
    procedure TestScalarAddMatrix;

    [TestName('TMatrix2 + TMatrix2')]
    procedure TestMatrixAddMatrix;

    [TestName('TMatrix2 - Scalar')]
    procedure TestMatrixSubScalar;

    [TestName('Scalar - TMatrix2')]
    procedure TestScalarSubMatrix;

    [TestName('TMatrix2 - TMatrix2')]
    procedure TestMatrixSubMatrix;

    [TestName('TMatrix2 * Scalar')]
    procedure TestMatrixMulScalar;

    [TestName('Scalar * TMatrix2')]
    procedure TestScalarMulMatrix;

    [TestName('TMatrix2 * TVector2')]
    procedure TestMatrixMulVector;

    [TestName('TVector2 * TMatrix2')]
    procedure TestVectorMulMatrix;

    [TestName('TMatrix2 * TMatrix2')]
    procedure TestMatrixMulMatrix;

    [TestName('TMatrix2 / Scalar')]
    procedure TestMatrixDivScalar;

    [TestName('Scalar / TMatrix2')]
    procedure TestScalarDivMatrix;

    [TestName('TMatrix2 / TVector2', 100)]
    procedure TestMatrixDivVector;

    [TestName('TVector2 / TMatrix2', 100)]
    procedure TestVectorDivMatrix;

    [TestName('TMatrix2 / TMatrix2', 100)]
    procedure TestMatrixDivMatrix;

    [TestName('TMatrix2.CompMult(TMatrix2)')]
    procedure TestCompMult;

    [TestName('OuterProduct(TVector2, TVector2)')]
    procedure TestOuterProduct;

    [TestName('TMatrix2.Transpose')]
    procedure TestTranspose;

    [TestName('TMatrix2.Determinant')]
    procedure TestDeterminant;

    [TestName('TMatrix2.Inverse')]
    procedure TestInverse;
  end;

implementation

{ TMatrix2PerfTests }

procedure TMatrix2PerfTests.Setup;
begin
  inherited;
  FMatA := Matrix2(1, 2, 3, 4);
  FMatB := Matrix2(5, 6, 7, 8);
  FVecA := Vector2(5, 6);
  FA := 5;
end;

procedure TMatrix2PerfTests.TestCompMult;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA.CompMult(FMatB);
end;

procedure TMatrix2PerfTests.TestDeterminant;
var
  I: Integer;
begin
  FMatA.Init(1, -2, -3, 4);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FA := FMatA.Determinant;
end;

procedure TMatrix2PerfTests.TestInverse;
var
  FMatA, FMatB: TMatrix2;
  I: Integer;
begin
  FMatA.Init(1, 2, 3, 4);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Inverse;
end;

procedure TMatrix2PerfTests.TestMatrixAddMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA + FMatB;
end;

procedure TMatrix2PerfTests.TestMatrixAddScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA + FA;
end;

procedure TMatrix2PerfTests.TestMatrixDivMatrix;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 100) - 1 do
    FMatC := FMatA / FMatB;
end;

procedure TMatrix2PerfTests.TestMatrixDivScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA / FA;
end;

procedure TMatrix2PerfTests.TestMatrixDivVector;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 100) - 1 do
    FVecB := FMatA / FVecA;
end;

procedure TMatrix2PerfTests.TestMatrixEqualMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := (FMatA = FMatB);
end;

procedure TMatrix2PerfTests.TestMatrixMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FMatB;
end;

procedure TMatrix2PerfTests.TestMatrixMulScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA * FA;
end;

procedure TMatrix2PerfTests.TestMatrixMulVector;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FMatA * FVecA;
end;

procedure TMatrix2PerfTests.TestMatrixNotEqualMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FB := (FMatA <> FMatB);
end;

procedure TMatrix2PerfTests.TestMatrixSubMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA - FMatB;
end;

procedure TMatrix2PerfTests.TestMatrixSubScalar;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FMatA - FA;
end;

procedure TMatrix2PerfTests.TestNegativeMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := -FMatA;
end;

procedure TMatrix2PerfTests.TestScalarAddMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA + FMatA;
end;

procedure TMatrix2PerfTests.TestOuterProduct;
var
  I: Integer;
begin
  FVecA.Init(2, 3);
  FVecB.Init(3, 4);
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := OuterProduct(FVecA, FVecB);
end;

procedure TMatrix2PerfTests.TestScalarDivMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA / FMatA;
end;

procedure TMatrix2PerfTests.TestScalarMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA * FMatA;
end;

procedure TMatrix2PerfTests.TestScalarSubMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatC := FA - FMatA;
end;

procedure TMatrix2PerfTests.TestTranspose;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FMatB := FMatA.Transpose;
end;

procedure TMatrix2PerfTests.TestVectorDivMatrix;
var
  I: Integer;
begin
  for I := 0 to (LOOP_COUNT_SMALL div 100) - 1 do
    FVecB := FVecA / FMatA;
end;

procedure TMatrix2PerfTests.TestVectorMulMatrix;
var
  I: Integer;
begin
  for I := 0 to LOOP_COUNT_SMALL - 1 do
    FVecB := FVecA * FMatA;
end;

end.
