unit FastMath.MatrixFunctions.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TMatrixFunctionsTests = class(TUnitTest)
  published
    procedure TestOuterProduct;
  end;

implementation

{ TMatrixFunctionsTests }

{$IFDEF FM_COLUMN_MAJOR}
procedure TMatrixFunctionsTests.TestOuterProduct;
var
  M2: TMatrix2;
  M3: TMatrix3;
  M4: TMatrix4;
begin
  M2 := OuterProduct(Vector2(2, 3),
                     Vector2(3, 4));
  CheckEquals(6, 9, M2.Columns[0]);
  CheckEquals(8, 12, M2.Columns[1]);

  M3 := OuterProduct(Vector3(2, -3, 4),
                     Vector3(-3, 4, 5));
  CheckEquals(-6, 9, -12, M3.Columns[0]);
  CheckEquals(8, -12, 16, M3.Columns[1]);
  CheckEquals(10, -15, 20, M3.Columns[2]);

  M4 := OuterProduct(Vector4(2, -3, 4, -5),
                     Vector4(-3, 4, 5, -6));
  CheckEquals(-6, 9, -12, 15, M4.Columns[0]);
  CheckEquals(8, -12, 16, -20, M4.Columns[1]);
  CheckEquals(10, -15, 20, -25, M4.Columns[2]);
  CheckEquals(-12, 18, -24, 30, M4.Columns[3]);
end;
{$ELSE}
procedure TMatrixFunctionsTests.TestOuterProduct;
var
  M2: TMatrix2;
  M3: TMatrix3;
  M4: TMatrix4;
begin
  M2 := OuterProduct(Vector2(2, 3),
                     Vector2(3, 4));
  CheckEquals(6, 8, M2.Rows[0]);
  CheckEquals(9, 12, M2.Rows[1]);

  M3 := OuterProduct(Vector3(2, -3, 4),
                     Vector3(-3, 4, 5));
  CheckEquals(-6, 8, 10, M3.Rows[0]);
  CheckEquals(9, -12, -15, M3.Rows[1]);
  CheckEquals(-12, 16, 20, M3.Rows[2]);

  M4 := OuterProduct(Vector4(2, -3, 4, -5),
                     Vector4(-3, 4, 5, -6));
  CheckEquals(-6, 8, 10, -12, M4.Rows[0]);
  CheckEquals(9, -12, -15, 18, M4.Rows[1]);
  CheckEquals(-12, 16, 20, -24, M4.Rows[2]);
  CheckEquals(15, -20, -25, 30, M4.Rows[3]);
end;
{$ENDIF}

end.
