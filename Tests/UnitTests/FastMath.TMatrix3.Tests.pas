unit FastMath.TMatrix3.Tests;

interface

uses
  System.Math.Vectors,
  UnitTest,
  Neslib.FastMath;

type
  TMatrix3Tests = class(TUnitTest)
  private
    procedure CheckEquals(const AExpected: TMatrix; const AActual: TMatrix3); overload;
  published
    procedure TestSize;
    procedure TestConstructors;
    procedure TestTransformConstructors;
    procedure TestImplicit;
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

{ TMatrix3Tests }

procedure TMatrix3Tests.CheckEquals(const AExpected: TMatrix;
  const AActual: TMatrix3);
begin
  CheckEquals(AExpected.m11, AActual.m11);
  CheckEquals(AExpected.m12, AActual.m12);
  CheckEquals(AExpected.m13, AActual.m13);

  CheckEquals(AExpected.m21, AActual.m21);
  CheckEquals(AExpected.m22, AActual.m22);
  CheckEquals(AExpected.m23, AActual.m23);

  CheckEquals(AExpected.m31, AActual.m31);
  CheckEquals(AExpected.m32, AActual.m32);
  CheckEquals(AExpected.m33, AActual.m33);
end;

procedure TMatrix3Tests.TestEquality;
var
  A, B: TMatrix3;
begin
  A := Matrix3(2);
  B := Matrix3(Vector3(2, 0, 0),
               Vector3(0, 2, 0),
               Vector3(0, 0, 2));
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := Matrix3(2);
  B := Matrix3(Vector3(2, 0, 0),
               Vector3(0, 2, 0),
               Vector3(0, 0.1, 2));
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TMatrix3Tests.TestAdd;
var
  A, B, C: TMatrix3;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  C := A + 1;
  CheckEquals(2, 3, 4, C.V[0]);
  CheckEquals(5, 6, 7, C.V[1]);
  CheckEquals(8, 9, 10, C.V[2]);

  C := 2 + A;
  CheckEquals(3, 4, 5, C.V[0]);
  CheckEquals(6, 7, 8, C.V[1]);
  CheckEquals(9, 10, 11, C.V[2]);

  B := Matrix3( 5,  6,  7,
                8,  9, 10,
               11, 12, 13);
  C := A + B;
  CheckEquals(6, 8, 10, C.V[0]);
  CheckEquals(12, 14, 16, C.V[1]);
  CheckEquals(18, 20, 22, C.V[2]);
end;

procedure TMatrix3Tests.TestCompMult;
var
  A, B, C: TMatrix3;
begin
  A := Matrix3(1, 2,  3,
               4, 5,  6,
               7, 8,  9);
  B := Matrix3(2, 3,  4,
               5, 6,  7,
               8, 9, 10);
  C := A.CompMult(B);
  CheckEquals(2, 6, 12, C.V[0]);
  CheckEquals(20, 30, 42, C.V[1]);
  CheckEquals(56, 72, 90, C.V[2]);
end;

procedure TMatrix3Tests.TestConstants;
begin
  CheckEquals(0, 0, 0, TMatrix3.Zero.V[0]);
  CheckEquals(0, 0, 0, TMatrix3.Zero.V[1]);
  CheckEquals(0, 0, 0, TMatrix3.Zero.V[2]);

  CheckEquals(1, 0, 0, TMatrix3.Identity.V[0]);
  CheckEquals(0, 1, 0, TMatrix3.Identity.V[1]);
  CheckEquals(0, 0, 1, TMatrix3.Identity.V[2]);
end;

procedure TMatrix3Tests.TestConstructors;
var
  A: TMatrix3;
  B: TMatrix2;
  C: TMatrix4;
begin
  A := Matrix3;
  CheckEquals(1, 0, 0, A.V[0]);
  CheckEquals(0, 1, 0, A.V[1]);
  CheckEquals(0, 0, 1, A.V[2]);

  A := Matrix3(2);
  CheckEquals(2, 0, 0, A.V[0]);
  CheckEquals(0, 2, 0, A.V[1]);
  CheckEquals(0, 0, 2, A.V[2]);

  A := Matrix3(Vector3(0, 1, 2),
               Vector3(3, 4, 5),
               Vector3(6, 7, 8));
  CheckEquals(0, 1, 2, A.V[0]);
  CheckEquals(3, 4, 5, A.V[1]);
  CheckEquals(6, 7, 8, A.V[2]);

  A := Matrix3( 4,  5,  6,
                7,  8,  9,
               10, 11, 12);
  CheckEquals(4, 5, 6, A.V[0]);
  CheckEquals(7, 8, 9, A.V[1]);
  CheckEquals(10, 11, 12, A.V[2]);

  B := Matrix2(1, 2,
               3, 4);
  A := Matrix3(B);
  CheckEquals(1, 2, 0, A.V[0]);
  CheckEquals(3, 4, 0, A.V[1]);
  CheckEquals(0, 0, 1, A.V[2]);

  C := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  A := Matrix3(C);
  CheckEquals(1, 2, 3, A.V[0]);
  CheckEquals(5, 6, 7, A.V[1]);
  CheckEquals(9, 10, 11, A.V[2]);

  A.Init;
  CheckEquals(1, 0, 0, A.V[0]);
  CheckEquals(0, 1, 0, A.V[1]);
  CheckEquals(0, 0, 1, A.V[2]);

  A.Init(2);
  CheckEquals(2, 0, 0, A.V[0]);
  CheckEquals(0, 2, 0, A.V[1]);
  CheckEquals(0, 0, 2, A.V[2]);

  A.Init(Vector3(0, 1, 2),
         Vector3(3, 4, 5),
         Vector3(6, 7, 8));
  CheckEquals(0, 1, 2, A.V[0]);
  CheckEquals(3, 4, 5, A.V[1]);
  CheckEquals(6, 7, 8, A.V[2]);

  A.Init( 4,  5,  6,
          7,  8,  9,
         10, 11, 12);
  CheckEquals(4, 5, 6, A.V[0]);
  CheckEquals(7, 8, 9, A.V[1]);
  CheckEquals(10, 11, 12, A.V[2]);
end;

procedure TMatrix3Tests.TestDeterminant;
var
  DM: TMatrix;
  M: TMatrix3;
begin
  DM.M[0] := Vector( 1, -2, -3);
  DM.M[1] := Vector( 4,  5, -6);
  DM.M[2] := Vector(-7,  8,  9);

  M :=      Matrix3( 1, -2, -3,
                     4,  5, -6,
                    -7,  8,  9);

  CheckEquals(DM.Determinant, M.Determinant);
end;

procedure TMatrix3Tests.TestInverse;
var
  DA, DB: TMatrix;
  A, B, C: TMatrix3;
begin
  DA.M[0] := Vector(0.6, 0.2, 0.3);
  DA.M[1] := Vector(0.2, 0.7, 0.5);
  DA.M[2] := Vector(0.3, 0.5, 0.7);

  A :=      Matrix3(0.6, 0.2, 0.3,
                    0.2, 0.7, 0.5,
                    0.3, 0.5, 0.7);

  DB := DA.Inverse;
  B := A.Inverse;
  CheckEquals(DB.M[0], B.V[0]);
  CheckEquals(DB.M[1], B.V[1]);
  CheckEquals(DB.M[2], B.V[2]);

  C := A * B;
  CheckEquals(1, 0, 0, C.V[0]);
  CheckEquals(0, 1, 0, C.V[1]);
  CheckEquals(0, 0, 1, C.V[2]);

  B := A / A;
  CheckEquals(1, 0, 0, B.V[0]);
  CheckEquals(0, 1, 0, B.V[1]);
  CheckEquals(0, 0, 1, B.V[2]);
end;

procedure TMatrix3Tests.TestNegative;
var
  A, B: TMatrix3;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  B := -A;
  CheckEquals(-1, -2, -3, B.V[0]);
  CheckEquals(-4, -5, -6, B.V[1]);
  CheckEquals(-7, -8, -9, B.V[2]);
end;

procedure TMatrix3Tests.TestSetTransposed;
var
  A: TMatrix3;
begin
  A := Matrix3(0, 1, 2,
               3, 4, 5,
               6, 7, 8);
  A.SetTransposed;
  CheckEquals(0, 3, 6, A.V[0]);
  CheckEquals(1, 4, 7, A.V[1]);
  CheckEquals(2, 5, 8, A.V[2]);
end;

procedure TMatrix3Tests.TestSize;
begin
  CheckEquals(3 * 3 * 4, SizeOf(TMatrix3));
end;

procedure TMatrix3Tests.TestSubtract;
var
  A, B, C: TMatrix3;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  C := A - 1;
  CheckEquals(0, 1, 2, C.V[0]);
  CheckEquals(3, 4, 5, C.V[1]);
  CheckEquals(6, 7, 8, C.V[2]);

  C := 2 - A;
  CheckEquals(1, 0, -1, C.V[0]);
  CheckEquals(-2, -3, -4, C.V[1]);
  CheckEquals(-5, -6, -7, C.V[2]);

  B := Matrix3(5, 6, 7,
               8, 9, 10,
               11, 12, 13);
  C := A - B;
  CheckEquals(-4, -4, -4, C.V[0]);
  CheckEquals(-4, -4, -4, C.V[1]);
  CheckEquals(-4, -4, -4, C.V[2]);
end;

procedure TMatrix3Tests.TestTransformConstructors;
var
  A: TMatrix3;
  M: TMatrix;
begin
  A.InitRotation(1);
  M := TMatrix.CreateRotation(1);
  CheckEquals(M, A);

  A.InitScaling(2);
  M := TMatrix.CreateScaling(2, 2);
  CheckEquals(M, A);

  A.InitScaling(3, 4);
  M := TMatrix.CreateScaling(3, 4);
  CheckEquals(M, A);

  A.InitScaling(Vector2(4, 5));
  M := TMatrix.CreateScaling(4, 5);
  CheckEquals(M, A);

  A.InitTranslation(5, 6);
  M := TMatrix.CreateTranslation(5, 6);
  CheckEquals(M, A);

  A.InitTranslation(Vector2(6, 7));
  M := TMatrix.CreateTranslation(6, 7);
  CheckEquals(M, A);
end;

procedure TMatrix3Tests.TestTranspose;
var
  A, B: TMatrix3;
begin
  A := Matrix3(0, 1, 2,
               3, 4, 5,
               6, 7, 8);
  B := A.Transpose;
  CheckEquals(0, 3, 6, B.V[0]);
  CheckEquals(1, 4, 7, B.V[1]);
  CheckEquals(2, 5, 8, B.V[2]);
end;

{$IFDEF FM_COLUMN_MAJOR}
procedure TMatrix3Tests.TestComponents;
var
  A: TMatrix3;
  Row, Col: Integer;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  CheckEquals(1, A[0,0]);
  CheckEquals(2, A[0,1]);
  CheckEquals(3, A[0,2]);
  CheckEquals(4, A[1,0]);
  CheckEquals(5, A[1,1]);
  CheckEquals(6, A[1,2]);
  CheckEquals(7, A[2,0]);
  CheckEquals(8, A[2,1]);
  CheckEquals(9, A[2,2]);

  for Col := 0 to 2 do
    for Row := 0 to 2 do
      A[Col,Row] := A[Col,Row] * 2;

  CheckTrue(A.Columns[0] = Vector3(2, 4, 6));
  CheckTrue(A.Columns[1] = Vector3(8, 10, 12));
  CheckTrue(A.Columns[2] = Vector3(14, 16, 18));
end;

procedure TMatrix3Tests.TestDivide;
var
  A, B, C: TMatrix3;
  D, E: TVector3;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  C := A / 2;
  CheckEquals(0.5, 1.0, 1.5, C.Columns[0]);
  CheckEquals(2.0, 2.5, 3.0, C.Columns[1]);
  CheckEquals(3.5, 4.0, 4.5, C.Columns[2]);

  C := 3 / A;
  CheckEquals(3.00000, 1.50000, 1.00000, C.Columns[0]);
  CheckEquals(0.75000, 0.60000, 0.50000, C.Columns[1]);
  CheckEquals(0.42857, 0.37500, 0.33333, C.Columns[2]);

  A := Matrix3(6,  2, 3,
               2,  7, 5,
               3,  5, 7);
  D := Vector3(5, -6, 7);
  E := A / D;
  CheckEquals(0.32743, -3.19469, 3.14159, E);

  E := D / A;
  CheckEquals(0.32743, -3.19469, 3.14159, E);

  B := Matrix3(7, 5, 3, 5, 7, 2, 3, 2, 6);
  C := A / B;
  C.SetTransposed;
  CheckEquals( 1.30088, -0.66371,  0.07079, C.Columns[0]);
  CheckEquals(-1.30088,  1.66371,  0.92920, C.Columns[1]);
  CheckEquals(-0.73451,  0.88495,  1.23893, C.Columns[2]);

  C := B / A;
  C.SetTransposed;
  CheckEquals( 1.23893,  0.88495, -0.73451, C.Columns[0]);
  CheckEquals( 0.92920,  1.66371, -1.30088, C.Columns[1]);
  CheckEquals( 0.07079, -0.66371,  1.30088, C.Columns[2]);
end;

procedure TMatrix3Tests.TestImplicit;
var
  FM: TMatrix3;
  DM: TMatrix;
begin
  DM.M[0] := TVector.Create(13, 14, 15);
  DM.M[1] := TVector.Create(16, 17, 18);
  DM.M[2] := TVector.Create(19, 20, 21);
  FM := DM;
  CheckEquals(13, 16, 19, FM.Columns[0]);
  CheckEquals(14, 17, 20, FM.Columns[1]);
  CheckEquals(15, 18, 21, FM.Columns[2]);

  FM := Matrix3(1, 2, 3,
                4, 5, 6,
                7, 8, 9);
  DM := FM;
  CheckEquals(1, DM.m11);
  CheckEquals(4, DM.m12);
  CheckEquals(7, DM.m13);
  CheckEquals(2, DM.m21);
  CheckEquals(5, DM.m22);
  CheckEquals(8, DM.m23);
  CheckEquals(3, DM.m31);
  CheckEquals(6, DM.m32);
  CheckEquals(9, DM.m33);
end;

procedure TMatrix3Tests.TestMultiply;
var
  A, B, C: TMatrix3;
  D, E: TVector3;
begin
  A :=      Matrix3(1, 2, 3,
                    4, 5, 6,
                    7, 8, 9);

  C := A * 2;
  CheckEquals( 2,  4,  6, C.Columns[0]);
  CheckEquals( 8, 10, 12, C.Columns[1]);
  CheckEquals(14, 16, 18, C.Columns[2]);

  C := -3 * A;
  CheckEquals( -3,  -6,  -9, C.Columns[0]);
  CheckEquals(-12, -15, -18, C.Columns[1]);
  CheckEquals(-21, -24, -27, C.Columns[2]);

  D := Vector3(5, 6, 7);
  E := A * D;
  CheckEquals(78, 96, 114, E);

  E := D * A;
  CheckEquals(38, 92, 146, E);

  B :=      Matrix3( 5,  6,  7,
                     8,  9, 10,
                    11, 12, 13);

  C  := A  * B;
  CheckEquals( 78,  96, 114, C.Columns[0]);
  CheckEquals(114, 141, 168, C.Columns[1]);
  CheckEquals(150, 186, 222, C.Columns[2]);

  C  := B  * A;
  CheckEquals( 54,  60,  66, C.Columns[0]);
  CheckEquals(126, 141, 156, C.Columns[1]);
  CheckEquals(198, 222, 246, C.Columns[2]);
end;

procedure TMatrix3Tests.TestColumns;
var
  A: TMatrix3;
  I: Integer;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  CheckTrue(A.Columns[0] = Vector3(1, 2, 3));
  CheckTrue(A.Columns[1] = Vector3(4, 5, 6));
  CheckTrue(A.Columns[2] = Vector3(7, 8, 9));

  for I := 0 to 2 do
    A.Columns[I] := A.Columns[I] * 2;

  CheckEquals( 2, A[0,0]);
  CheckEquals( 4, A[0,1]);
  CheckEquals( 6, A[0,2]);
  CheckEquals( 8, A[1,0]);
  CheckEquals(10, A[1,1]);
  CheckEquals(12, A[1,2]);
  CheckEquals(14, A[2,0]);
  CheckEquals(16, A[2,1]);
  CheckEquals(18, A[2,2]);
end;
{$ELSE}
procedure TMatrix3Tests.TestComponents;
var
  A: TMatrix3;
  Row, Col: Integer;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  CheckEquals(1, A[0,0]);
  CheckEquals(2, A[0,1]);
  CheckEquals(3, A[0,2]);
  CheckEquals(4, A[1,0]);
  CheckEquals(5, A[1,1]);
  CheckEquals(6, A[1,2]);
  CheckEquals(7, A[2,0]);
  CheckEquals(8, A[2,1]);
  CheckEquals(9, A[2,2]);

  for Row := 0 to 2 do
    for Col := 0 to 2 do
      A[Row,Col] := A[Row,Col] * 2;

  CheckTrue(A.Rows[0] = Vector3(2, 4, 6));
  CheckTrue(A.Rows[1] = Vector3(8, 10, 12));
  CheckTrue(A.Rows[2] = Vector3(14, 16, 18));
end;

procedure TMatrix3Tests.TestDivide;
var
  A, B, C: TMatrix3;
  D, E: TVector3;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  C := A / 2;
  CheckEquals(0.5, 1.0, 1.5, C.Rows[0]);
  CheckEquals(2.0, 2.5, 3.0, C.Rows[1]);
  CheckEquals(3.5, 4.0, 4.5, C.Rows[2]);

  C := 3 / A;
  CheckEquals(3.00000, 1.50000, 1.00000, C.Rows[0]);
  CheckEquals(0.75000, 0.60000, 0.50000, C.Rows[1]);
  CheckEquals(0.42857, 0.37500, 0.33333, C.Rows[2]);

  A := Matrix3(6,  2, 3,
               2,  7, 5,
               3,  5, 7);
  D := Vector3(5, -6, 7);
  E := A / D;
  CheckEquals(0.32743, -3.19469, 3.14159, E);

  E := D / A;
  CheckEquals(0.32743, -3.19469, 3.14159, E);

  B := Matrix3(7, 5, 3, 5, 7, 2, 3, 2, 6);
  C := A / B;
  CheckEquals( 1.30088, -0.66371,  0.07079, C.Rows[0]);
  CheckEquals(-1.30088,  1.66371,  0.92920, C.Rows[1]);
  CheckEquals(-0.73451,  0.88495,  1.23893, C.Rows[2]);

  C := B / A;
  CheckEquals( 1.23893,  0.88495, -0.73451, C.Rows[0]);
  CheckEquals( 0.92920,  1.66371, -1.30088, C.Rows[1]);
  CheckEquals( 0.07079, -0.66371,  1.30088, C.Rows[2]);
end;

procedure TMatrix3Tests.TestImplicit;
var
  FM: TMatrix3;
  DM: TMatrix;
begin
  DM.M[0] := TVector.Create(13, 14, 15);
  DM.M[1] := TVector.Create(16, 17, 18);
  DM.M[2] := TVector.Create(19, 20, 21);
  FM := DM;
  CheckEquals(13, 14, 15, FM.Rows[0]);
  CheckEquals(16, 17, 18, FM.Rows[1]);
  CheckEquals(19, 20, 21, FM.Rows[2]);

  FM := Matrix3(1, 2, 3,
                4, 5, 6,
                7, 8, 9);
  DM := FM;
  CheckEquals(1, DM.m11);
  CheckEquals(2, DM.m12);
  CheckEquals(3, DM.m13);
  CheckEquals(4, DM.m21);
  CheckEquals(5, DM.m22);
  CheckEquals(6, DM.m23);
  CheckEquals(7, DM.m31);
  CheckEquals(8, DM.m32);
  CheckEquals(9, DM.m33);
end;

procedure TMatrix3Tests.TestMultiply;
var
  DA, DB, DC: TMatrix;
  DD, DE: TVector;
  A, B, C: TMatrix3;
  D, E: TVector3;
begin
  DA.M[0] := Vector(1, 2, 3);
  DA.M[1] := Vector(4, 5, 6);
  DA.M[2] := Vector(7, 8, 9);

  A :=      Matrix3(1, 2, 3,
                    4, 5, 6,
                    7, 8, 9);

  C := A * 2;
  CheckEquals( 2,  4,  6, C.Rows[0]);
  CheckEquals( 8, 10, 12, C.Rows[1]);
  CheckEquals(14, 16, 18, C.Rows[2]);

  C := -3 * A;
  CheckEquals( -3,  -6,  -9, C.Rows[0]);
  CheckEquals(-12, -15, -18, C.Rows[1]);
  CheckEquals(-21, -24, -27, C.Rows[2]);

  D := Vector3(5, 6, 7);
  E := A * D;
  CheckEquals(38, 92, 146, E);

  DD := Vector (5, 6, 7);
  DE := DD * DA;
  E  := D  * A;
  CheckEquals(DE, E);

  DB.M[0] := Vector( 5,  6,  7);
  DB.M[1] := Vector( 8,  9, 10);
  DB.M[2] := Vector(11, 12, 13);

  B :=      Matrix3( 5,  6,  7,
                     8,  9, 10,
                    11, 12, 13);

  DC := DA * DB;
  C  := A  * B;
  CheckEquals(DC.M[0], C.Rows[0]);
  CheckEquals(DC.M[1], C.Rows[1]);
  CheckEquals(DC.M[2], C.Rows[2]);

  DC := DB * DA;
  C  := B  * A;
  CheckEquals(DC.M[0], C.Rows[0]);
  CheckEquals(DC.M[1], C.Rows[1]);
  CheckEquals(DC.M[2], C.Rows[2]);
end;

procedure TMatrix3Tests.TestRows;
var
  A: TMatrix3;
  I: Integer;
begin
  A := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  CheckTrue(A.Rows[0] = Vector3(1, 2, 3));
  CheckTrue(A.Rows[1] = Vector3(4, 5, 6));
  CheckTrue(A.Rows[2] = Vector3(7, 8, 9));

  for I := 0 to 2 do
    A.Rows[I] := A.Rows[I] * 2;

  CheckEquals( 2, A[0,0]);
  CheckEquals( 4, A[0,1]);
  CheckEquals( 6, A[0,2]);
  CheckEquals( 8, A[1,0]);
  CheckEquals(10, A[1,1]);
  CheckEquals(12, A[1,2]);
  CheckEquals(14, A[2,0]);
  CheckEquals(16, A[2,1]);
  CheckEquals(18, A[2,2]);
end;
{$ENDIF}

end.
