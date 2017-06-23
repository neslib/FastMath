unit FastMath.TMatrix2.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TMatrix2Tests = class(TUnitTest)
  published
    procedure TestSize;
    procedure TestConstructors;
    {$IFDEF FM_COLUMN_MAJOR}
    procedure TestColumns;
    {$ELSE}
    procedure TestRows;
    {$ENDIF}
    procedure TestComponents;
    procedure TestConstants;
    procedure TestEquality;
    procedure TestAdd;
    procedure TestSubtract;
    procedure TestMultiply;
    procedure TestDivide;
    procedure TestNegative;
    procedure TestCompMult;
    procedure TestTranspose;
    procedure TestSetTransposed;
    procedure TestDeterminant;
    procedure TestInverse;
  end;

implementation

{ TMatrix2Tests }

procedure TMatrix2Tests.TestEquality;
var
  A, B: TMatrix2;
begin
  A := Matrix2(2);
  B := Matrix2(Vector2(2, 0),
               Vector2(0, 2));
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := Matrix2(2);
  B := Matrix2(Vector2(2, 0),
               Vector2(0, 2.2));
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TMatrix2Tests.TestAdd;
var
  A, B, C: TMatrix2;
begin
  A := Matrix2( 1, -2,
               -3,  4);
  C := A + 1;
  CheckEquals(2, -1, C.V[0]);
  CheckEquals(-2, 5, C.V[1]);

  C := 2 + A;
  CheckEquals(3, 0, C.V[0]);
  CheckEquals(-1, 6, C.V[1]);

  B := Matrix2(5, -6,
               7, -8);
  C := A + B;
  CheckEquals(6, -8, C.V[0]);
  CheckEquals(4, -4, C.V[1]);
end;

procedure TMatrix2Tests.TestCompMult;
var
  A, B, C: TMatrix2;
begin
  A := Matrix2(1, 2,
               3, 4);
  B := Matrix2(2, 3,
               4, 5);
  C := A.CompMult(B);
  CheckEquals(2, 6, C.V[0]);
  CheckEquals(12, 20, C.V[1]);
end;

procedure TMatrix2Tests.TestConstants;
begin
  CheckEquals(0, 0, TMatrix2.Zero.V[0]);
  CheckEquals(0, 0, TMatrix2.Zero.V[1]);

  CheckEquals(1, 0, TMatrix2.Identity.V[0]);
  CheckEquals(0, 1, TMatrix2.Identity.V[1]);
end;

procedure TMatrix2Tests.TestConstructors;
var
  A: TMatrix2;
  B: TMatrix3;
  C: TMatrix4;
begin
  A := Matrix2;
  CheckEquals(1, 0, A.V[0]);
  CheckEquals(0, 1, A.V[1]);

  A := Matrix2(2);
  CheckEquals(2, 0, A.V[0]);
  CheckEquals(0, 2, A.V[1]);

  A := Matrix2(Vector2(0, 1),
               Vector2(2, 3));
  CheckEquals(0, 1, A.V[0]);
  CheckEquals(2, 3, A.V[1]);

  A := Matrix2(4, 5,
               6, 7);
  CheckEquals(4, 5, A.V[0]);
  CheckEquals(6, 7, A.V[1]);

  B := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  A := Matrix2(B);
  CheckEquals(1, 2, A.V[0]);
  CheckEquals(4, 5, A.V[1]);

  C := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  A := Matrix2(C);
  CheckEquals(1, 2, A.V[0]);
  CheckEquals(5, 6, A.V[1]);

  A.Init;
  CheckEquals(1, 0, A.V[0]);
  CheckEquals(0, 1, A.V[1]);

  A.Init(2);
  CheckEquals(2, 0, A.V[0]);
  CheckEquals(0, 2, A.V[1]);

  A.Init(Vector2(0, 1),
         Vector2(2, 3));
  CheckEquals(0, 1, A.V[0]);
  CheckEquals(2, 3, A.V[1]);

  A.Init(4, 5,
         6, 7);
  CheckEquals(4, 5, A.V[0]);
  CheckEquals(6, 7, A.V[1]);
end;

procedure TMatrix2Tests.TestDeterminant;
var
  M: TMatrix2;
begin
  M := Matrix2( 1, -2,
               -3,  4);
  CheckEquals(-2, M.Determinant);
end;

procedure TMatrix2Tests.TestDivide;
var
  A, B, C: TMatrix2;
  D, E: TVector2;
begin
  A := Matrix2( 1, -2,
               -3,  4);
  C := A / 2;
  CheckEquals(0.5, -1, C.V[0]);
  CheckEquals(-1.5, 2, C.V[1]);

  C := -3 / A;
  CheckEquals(-3, 1.5, C.V[0]);
  CheckEquals(1, -0.75, C.V[1]);

  D := Vector2(5, -6);
  E := A / D;
  CheckEquals(-1, -2, E);

  E := D / A;
  CheckEquals(-4, -4.5, E);

  B := Matrix2(5, -6,
               7, -8);
  C := A / B;
  CheckEquals(-13, 20, C.V[0]);
  CheckEquals(-11, 17, C.V[1]);

  C := B / A;
  CheckEquals(-17, 20, C.V[0]);
  CheckEquals(-11, 13, C.V[1]);
end;

procedure TMatrix2Tests.TestInverse;
var
  A, B, C: TMatrix2;
begin
  A := Matrix2(1, 2,
               3, 4);
  B := A.Inverse;
  CheckEquals(-2, 1, B.V[0]);
  CheckEquals(1.5, -0.5, B.V[1]);

  C := A * B;
  CheckEquals(1, 0, C.V[0]);
  CheckEquals(0, 1, C.V[1]);

  B := A / A;
  CheckEquals(1, 0, B.V[0]);
  CheckEquals(0, 1, B.V[1]);
end;

procedure TMatrix2Tests.TestMultiply;
var
  A, B, C: TMatrix2;
  D, E: TVector2;
begin
  A := Matrix2( 1, -2,
               -3,  4);
  C := A * 2;
  CheckEquals(2, -4, C.V[0]);
  CheckEquals(-6, 8, C.V[1]);

  C := -3 * A;
  CheckEquals(-3, 6, C.V[0]);
  CheckEquals(9, -12, C.V[1]);

  D := Vector2(5, -6);
  E := A * D;
  CheckEquals(23, -34, E);

  E := D * A;
  CheckEquals(17, -39, E);

  B := Matrix2(5, -6,
               7, -8);
  C := A * B;
  CheckEquals(23, -34, C.V[0]);
  CheckEquals(31, -46, C.V[1]);

  C := B * A;
  CheckEquals(-9, 10, C.V[0]);
  CheckEquals(13, -14, C.V[1]);
end;

procedure TMatrix2Tests.TestNegative;
var
  A, B: TMatrix2;
begin
  A := Matrix2(1, -2,
               3, -4);
  B := -A;
  CheckEquals(-1, 2, B.V[0]);
  CheckEquals(-3, 4, B.V[1]);
end;

procedure TMatrix2Tests.TestSetTransposed;
var
  A: TMatrix2;
begin
  A := Matrix2(0, 1,
               2, 3);
  A.SetTransposed;
  CheckEquals(0, 2, A.V[0]);
  CheckEquals(1, 3, A.V[1]);
end;

procedure TMatrix2Tests.TestSize;
begin
  CheckEquals(16, SizeOf(TMatrix2));
end;

procedure TMatrix2Tests.TestSubtract;
var
  A, B, C: TMatrix2;
begin
  A := Matrix2( 1, -2,
               -3,  4);
  C := A - 1;
  CheckEquals(0, -3, C.V[0]);
  CheckEquals(-4, 3, C.V[1]);

  C := 2 - A;
  CheckEquals(1, 4, C.V[0]);
  CheckEquals(5, -2, C.V[1]);

  B := Matrix2(5, -6,
               7, -8);
  C := A - B;
  CheckEquals(-4, 4, C.V[0]);
  CheckEquals(-10, 12, C.V[1]);
end;

procedure TMatrix2Tests.TestTranspose;
var
  A, B: TMatrix2;
begin
  A := Matrix2(0, 1,
               2, 3);
  B := A.Transpose;
  CheckEquals(0, 2, B.V[0]);
  CheckEquals(1, 3, B.V[1]);
end;

{$IFDEF FM_COLUMN_MAJOR}
procedure TMatrix2Tests.TestColumns;
var
  A: TMatrix2;
  I: Integer;
begin
  A := Matrix2(1, 2,
               3, 4);
  CheckTrue(A.Columns[0] = Vector2(1, 2));
  CheckTrue(A.Columns[1] = Vector2(3, 4));

  for I := 0 to 1 do
    A.Columns[I] := A.Columns[I] * 2;

  CheckEquals(2, A[0,0]);
  CheckEquals(4, A[0,1]);
  CheckEquals(6, A[1,0]);
  CheckEquals(8, A[1,1]);
end;

procedure TMatrix2Tests.TestComponents;
var
  A: TMatrix2;
  Row, Col: Integer;
begin
  A := Matrix2(1, 2,
               3, 4);
  CheckEquals(1, A[0,0]);
  CheckEquals(2, A[0,1]);
  CheckEquals(3, A[1,0]);
  CheckEquals(4, A[1,1]);

  for Col := 0 to 1 do
    for Row := 0 to 1 do
      A[Col,Row] := A[Col,Row] * 2;

  CheckTrue(A.Columns[0] = Vector2(2, 4));
  CheckTrue(A.Columns[1] = Vector2(6, 8));
end;
{$ELSE}
procedure TMatrix2Tests.TestComponents;
var
  A: TMatrix2;
  Row, Col: Integer;
begin
  A := Matrix2(1, 2,
               3, 4);
  CheckEquals(1, A[0,0]);
  CheckEquals(2, A[0,1]);
  CheckEquals(3, A[1,0]);
  CheckEquals(4, A[1,1]);

  for Row := 0 to 1 do
    for Col := 0 to 1 do
      A[Row,Col] := A[Row,Col] * 2;

  CheckTrue(A.Rows[0] = Vector2(2, 4));
  CheckTrue(A.Rows[1] = Vector2(6, 8));
end;

procedure TMatrix2Tests.TestRows;
var
  A: TMatrix2;
  I: Integer;
begin
  A := Matrix2(1, 2,
               3, 4);
  CheckTrue(A.Rows[0] = Vector2(1, 2));
  CheckTrue(A.Rows[1] = Vector2(3, 4));

  for I := 0 to 1 do
    A.Rows[I] := A.Rows[I] * 2;

  CheckEquals(2, A[0,0]);
  CheckEquals(4, A[0,1]);
  CheckEquals(6, A[1,0]);
  CheckEquals(8, A[1,1]);
end;
{$ENDIF}

end.
