unit FastMath.TMatrix4.Tests;

interface

uses
  System.Math.Vectors,
  UnitTest,
  Neslib.FastMath;

type
  TMatrix4Tests = class(TUnitTest)
  private
    procedure CheckEquals(const AExpected: TMatrix3D; const AActual: TMatrix4); overload;
  published
    procedure TestSize;
    procedure TestConstructors;
    procedure TestTransformConstructors;
    procedure TestImplicit;
    procedure TestCameraConstructors;
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

{ TMatrix4Tests }

procedure TMatrix4Tests.CheckEquals(const AExpected: TMatrix3D;
  const AActual: TMatrix4);
begin
  CheckEquals(AExpected.m11, AActual.m11);
  CheckEquals(AExpected.m12, AActual.m12);
  CheckEquals(AExpected.m13, AActual.m13);
  CheckEquals(AExpected.m14, AActual.m14);

  CheckEquals(AExpected.m21, AActual.m21);
  CheckEquals(AExpected.m22, AActual.m22);
  CheckEquals(AExpected.m23, AActual.m23);
  CheckEquals(AExpected.m24, AActual.m24);

  CheckEquals(AExpected.m31, AActual.m31);
  CheckEquals(AExpected.m32, AActual.m32);
  CheckEquals(AExpected.m33, AActual.m33);
  CheckEquals(AExpected.m34, AActual.m34);

  CheckEquals(AExpected.m41, AActual.m41);
  CheckEquals(AExpected.m42, AActual.m42);
  CheckEquals(AExpected.m43, AActual.m43);
  CheckEquals(AExpected.m44, AActual.m44);
end;

procedure TMatrix4Tests.TestEquality;
var
  A, B: TMatrix4;
begin
  A := Matrix4(2);
  B := Matrix4(Vector4(2, 0, 0, 0),
               Vector4(0, 2, 0, 0),
               Vector4(0, 0, 2, 0),
               Vector4(0, 0, 0, 2));
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := Matrix4(2);
  B := Matrix4(Vector4(2, 0, 0, 0),
               Vector4(0, 2, 0, 0),
               Vector4(0, 0, 2, 0),
               Vector4(0.1, 0, 0, 2));
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TMatrix4Tests.TestAdd;
var
  A, B, C: TMatrix4;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  C := A + 1;
  CheckEquals(2, 3, 4, 5, C.V[0]);
  CheckEquals(6, 7, 8, 9, C.V[1]);
  CheckEquals(10, 11, 12, 13, C.V[2]);
  CheckEquals(14, 15, 16, 17, C.V[3]);

  C := 2 + A;
  CheckEquals(3, 4, 5, 6, C.V[0]);
  CheckEquals(7, 8, 9, 10, C.V[1]);
  CheckEquals(11, 12, 13, 14, C.V[2]);
  CheckEquals(15, 16, 17, 18, C.V[3]);

  B := Matrix4( 5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16,
               17, 18, 19, 20);
  C := A + B;
  CheckEquals(6, 8, 10, 12, C.V[0]);
  CheckEquals(14, 16, 18, 20, C.V[1]);
  CheckEquals(22, 24, 26, 28, C.V[2]);
  CheckEquals(30, 32, 34, 36, C.V[3]);
end;

procedure TMatrix4Tests.TestCompMult;
var
  A, B, C: TMatrix4;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  B := Matrix4( 2,  3,  4,  5,
                6,  7,  8,  9,
               10, 11, 12, 13,
               14, 15, 16, 17);
  C := A.CompMult(B);
  CheckEquals(2, 6, 12, 20, C.V[0]);
  CheckEquals(30, 42, 56, 72, C.V[1]);
  CheckEquals(90, 110, 132, 156, C.V[2]);
  CheckEquals(182, 210, 240, 272, C.V[3]);
end;

procedure TMatrix4Tests.TestConstants;
begin
  CheckEquals(0, 0, 0, 0, TMatrix4.Zero.V[0]);
  CheckEquals(0, 0, 0, 0, TMatrix4.Zero.V[1]);
  CheckEquals(0, 0, 0, 0, TMatrix4.Zero.V[2]);
  CheckEquals(0, 0, 0, 0, TMatrix4.Zero.V[3]);

  CheckEquals(1, 0, 0, 0, TMatrix4.Identity.V[0]);
  CheckEquals(0, 1, 0, 0, TMatrix4.Identity.V[1]);
  CheckEquals(0, 0, 1, 0, TMatrix4.Identity.V[2]);
  CheckEquals(0, 0, 0, 1, TMatrix4.Identity.V[3]);
end;

procedure TMatrix4Tests.TestConstructors;
var
  A: TMatrix4;
  B: TMatrix2;
  C: TMatrix3;
begin
  A := Matrix4;
  CheckEquals(1, 0, 0, 0, A.V[0]);
  CheckEquals(0, 1, 0, 0, A.V[1]);
  CheckEquals(0, 0, 1, 0, A.V[2]);
  CheckEquals(0, 0, 0, 1, A.V[3]);

  A := Matrix4(2);
  CheckEquals(2, 0, 0, 0, A.V[0]);
  CheckEquals(0, 2, 0, 0, A.V[1]);
  CheckEquals(0, 0, 2, 0, A.V[2]);
  CheckEquals(0, 0, 0, 2, A.V[3]);

  A := Matrix4(Vector4(0, 1, 2, 3),
               Vector4(4, 5, 6, 7),
               Vector4(8, 9, 10, 11),
               Vector4(12, 13, 14, 15));
  CheckEquals(0, 1, 2, 3, A.V[0]);
  CheckEquals(4, 5, 6, 7, A.V[1]);
  CheckEquals(8, 9, 10, 11, A.V[2]);
  CheckEquals(12, 13, 14, 15, A.V[3]);

  A := Matrix4( 4,  5,  6,  7,
                8,  9, 10, 11,
               12, 13, 14, 15,
               16, 17, 18, 19);
  CheckEquals(4, 5, 6, 7, A.V[0]);
  CheckEquals(8, 9, 10, 11, A.V[1]);
  CheckEquals(12, 13, 14, 15, A.V[2]);
  CheckEquals(16, 17, 18, 19, A.V[3]);

  B := Matrix2(1, 2,
               3, 4);
  A := Matrix4(B);
  CheckEquals(1, 2, 0, 0, A.V[0]);
  CheckEquals(3, 4, 0, 0, A.V[1]);
  CheckEquals(0, 0, 1, 0, A.V[2]);
  CheckEquals(0, 0, 0, 1, A.V[3]);

  C := Matrix3(1, 2, 3,
               4, 5, 6,
               7, 8, 9);
  A := Matrix4(C);
  CheckEquals(1, 2, 3, 0, A.V[0]);
  CheckEquals(4, 5, 6, 0, A.V[1]);
  CheckEquals(7, 8, 9, 0, A.V[2]);
  CheckEquals(0, 0, 0, 1, A.V[3]);

  A.Init;
  CheckEquals(1, 0, 0, 0, A.V[0]);
  CheckEquals(0, 1, 0, 0, A.V[1]);
  CheckEquals(0, 0, 1, 0, A.V[2]);
  CheckEquals(0, 0, 0, 1, A.V[3]);

  A.Init(2);
  CheckEquals(2, 0, 0, 0, A.V[0]);
  CheckEquals(0, 2, 0, 0, A.V[1]);
  CheckEquals(0, 0, 2, 0, A.V[2]);
  CheckEquals(0, 0, 0, 2, A.V[3]);

  A.Init(Vector4(0, 1, 2, 3),
         Vector4(4, 5, 6, 7),
         Vector4(8, 9, 10, 11),
         Vector4(12, 13, 14, 15));
  CheckEquals(0, 1, 2, 3, A.V[0]);
  CheckEquals(4, 5, 6, 7, A.V[1]);
  CheckEquals(8, 9, 10, 11, A.V[2]);
  CheckEquals(12, 13, 14, 15, A.V[3]);

  A.Init( 4,  5,  6,  7,
          8,  9, 10, 11,
         12, 13, 14, 15,
         16, 17, 18, 19);
  CheckEquals(4, 5, 6, 7, A.V[0]);
  CheckEquals(8, 9, 10, 11, A.V[1]);
  CheckEquals(12, 13, 14, 15, A.V[2]);
  CheckEquals(16, 17, 18, 19, A.V[3]);
end;

procedure TMatrix4Tests.TestDeterminant;
var
  DM: TMatrix3D;
  M: TMatrix4;
begin
  DM := TMatrix3D.Create(  1, -2,  -3,   4,
                           5, -6,  -7,   8,
                           9, 10, -11, -12,
                         -13, 14,  15,  16);

  M :=           Matrix4(  1, -2,  -3,   4,
                           5, -6,  -7,   8,
                           9, 10, -11, -12,
                         -13, 14,  15,  16);

  CheckEquals(DM.Determinant, M.Determinant);
end;

procedure TMatrix4Tests.TestInverse;
var
  DA, DB: TMatrix3D;
  A, B, C: TMatrix4;
begin
  DA := TMatrix3D.Create(0.6, 0.2, 0.3, 0.4,
                         0.2, 0.7, 0.5, 0.3,
                         0.3, 0.5, 0.7, 0.2,
                         0.4, 0.3, 0.2, 0.6);

  A :=           Matrix4(0.6, 0.2, 0.3, 0.4,
                         0.2, 0.7, 0.5, 0.3,
                         0.3, 0.5, 0.7, 0.2,
                         0.4, 0.3, 0.2, 0.6);
  DB := DA.Inverse;
  B := A.Inverse;
  CheckEquals(DB.M[0], B.V[0]);
  CheckEquals(DB.M[1], B.V[1]);
  CheckEquals(DB.M[2], B.V[2]);
  CheckEquals(DB.M[3], B.V[3]);

  C := A * B;
  CheckEquals(1, 0, 0, 0, C.V[0]);
  CheckEquals(0, 1, 0, 0, C.V[1]);
  CheckEquals(0, 0, 1, 0, C.V[2]);
  CheckEquals(0, 0, 0, 1, C.V[3]);

  B := A / A;
  CheckEquals(1, 0, 0, 0, B.V[0]);
  CheckEquals(0, 1, 0, 0, B.V[1]);
  CheckEquals(0, 0, 1, 0, B.V[2]);
  CheckEquals(0, 0, 0, 1, B.V[3]);
end;

procedure TMatrix4Tests.TestNegative;
var
  A, B: TMatrix4;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  B := -A;
  CheckEquals(-1, -2, -3, -4, B.V[0]);
  CheckEquals(-5, -6, -7, -8, B.V[1]);
  CheckEquals(-9, -10, -11, -12, B.V[2]);
  CheckEquals(-13, -14, -15, -16, B.V[3]);
end;

procedure TMatrix4Tests.TestSetTransposed;
var
  A: TMatrix4;
begin
  A := Matrix4( 0,  1,  2,  3,
                4,  5,  6,  7,
                8,  9, 10, 11,
               12, 13, 14, 15);
  A.SetTransposed;
  CheckEquals(0, 4, 8, 12, A.V[0]);
  CheckEquals(1, 5, 9, 13, A.V[1]);
  CheckEquals(2, 6, 10, 14, A.V[2]);
  CheckEquals(3, 7, 11, 15, A.V[3]);
end;

procedure TMatrix4Tests.TestSize;
begin
  CheckEquals(64, SizeOf(TMatrix4));
end;

procedure TMatrix4Tests.TestSubtract;
var
  A, B, C: TMatrix4;
begin
  A := Matrix4 (1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  C := A - 1;
  CheckEquals(0, 1, 2, 3, C.V[0]);
  CheckEquals(4, 5, 6, 7, C.V[1]);
  CheckEquals(8, 9, 10, 11, C.V[2]);
  CheckEquals(12, 13, 14, 15, C.V[3]);

  C := 2 - A;
  CheckEquals(1, 0, -1, -2, C.V[0]);
  CheckEquals(-3, -4, -5, -6, C.V[1]);
  CheckEquals(-7, -8, -9, -10, C.V[2]);
  CheckEquals(-11, -12, -13, -14, C.V[3]);

  B := Matrix4( 5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16,
               17, 18, 19, 20);
  C := A - B;
  CheckEquals(-4, -4, -4, -4, C.V[0]);
  CheckEquals(-4, -4, -4, -4, C.V[1]);
  CheckEquals(-4, -4, -4, -4, C.V[2]);
  CheckEquals(-4, -4, -4, -4, C.V[3]);
end;

procedure TMatrix4Tests.TestTransformConstructors;
var
  A: TMatrix4;
  M: TMatrix3D;
begin
  A.InitScaling(2);
  M := TMatrix3D.CreateScaling(Point3D(2, 2, 2));
  CheckEquals(M, A);

  A.InitScaling(3, 4, 5);
  M := TMatrix3D.CreateScaling(Point3D(3, 4, 5));
  CheckEquals(M, A);

  A.InitScaling(Vector3(4, 5, 6));
  M := TMatrix3D.CreateScaling(Point3D(4, 5, 6));
  CheckEquals(M, A);

  A.InitTranslation(5, 6, 7);
  M := TMatrix3D.CreateTranslation(Point3D(5, 6, 7));
  CheckEquals(M, A);

  A.InitTranslation(Vector3(6, 7, 8));
  M := TMatrix3D.CreateTranslation(Point3D(6, 7, 8));
  CheckEquals(M, A);

  A.InitRotationX(1);
  M := TMatrix3D.CreateRotationX(1);
  CheckEquals(M, A);

  A.InitRotationY(2);
  M := TMatrix3D.CreateRotationY(2);
  CheckEquals(M, A);

  A.InitRotationZ(3);
  M := TMatrix3D.CreateRotationZ(3);
  CheckEquals(M, A);

  A.InitRotation(Vector3(1, 2, 3), 4);
  M := TMatrix3D.CreateRotation(Point3D(1, 2, 3), 4);
  CheckEquals(M, A);

  A.InitRotationYawPitchRoll(1, 2, 3);
  M := TMatrix3D.CreateRotationYawPitchRoll(1, 2, 3);
  CheckEquals(M, A);

  A.InitRotationHeadingPitchBank(4, 5, 6);
  M := TMatrix3D.CreateRotationHeadingPitchBank(4, 5, 6);
  CheckEquals(M, A);
end;

procedure TMatrix4Tests.TestTranspose;
var
  A, B: TMatrix4;
begin
  A := Matrix4( 0,  1,  2,  3,
                4,  5,  6,  7,
                8,  9, 10, 11,
               12, 13, 14, 15);
  B := A.Transpose;
  CheckEquals(0, 4, 8, 12, B.V[0]);
  CheckEquals(1, 5, 9, 13, B.V[1]);
  CheckEquals(2, 6, 10, 14, B.V[2]);
  CheckEquals(3, 7, 11, 15, B.V[3]);
end;

{$IFDEF FM_COLUMN_MAJOR}
procedure TMatrix4Tests.TestCameraConstructors;
var
  A: TMatrix4;
  M: TMatrix3D;
begin
  A.InitLookAtLH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtLH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitLookAtRH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtRH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitLookAtDirLH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtDirLH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitLookAtDirRH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtDirRH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitOrthoLH(4, 5, 0.5, 50);
  CheckEquals(0.5, 0, 0, 0, A.V[0]);
  CheckEquals(0, 0.4, 0, 0, A.V[1]);
  CheckEquals(0, 0, 0.0404040404, 0, A.V[2]);
  CheckEquals(-1, -1, -1.02020204, 1, A.V[3]);

  A.InitOrthoRH(4, 5, 0.5, 50);
  CheckEquals(0.5, 0, 0, 0, A.V[0]);
  CheckEquals(0, 0.4, 0, 0, A.V[1]);
  CheckEquals(0, 0, -0.0404040404, 0, A.V[2]);
  CheckEquals(-1, -1, -1.02020204, 1, A.V[3]);

  A.InitOrthoOffCenterLH(1, 2, 3, 4, 0.5, 50);
  CheckEquals(1, 0, 0, 0, A.V[0]);
  CheckEquals(0, -1, 0, 0, A.V[1]);
  CheckEquals(0, 0, 0.0404040404, 0, A.V[2]);
  CheckEquals(-2, 3, -1.02020204, 1, A.V[3]);

  A.InitOrthoOffCenterRH(1, 2, 3, 4, 0.5, 50);
  CheckEquals(1, 0, 0, 0, A.V[0]);
  CheckEquals(0, -1, 0, 0, A.V[1]);
  CheckEquals(0, 0, -0.0404040404, 0, A.V[2]);
  CheckEquals(-2, 3, -1.02020204, 1, A.V[3]);

  A.InitPerspectiveFovLH(1, 1.5, 0.2, 20, False);
  CheckEquals(1.22032511, 0, 0, 0, A.V[0]);
  CheckEquals(0, 1.83048773, 0, 0, A.V[1]);
  CheckEquals(0, 0, 1.02020204, 1, A.V[2]);
  CheckEquals(0, 0, -0.404040396, 0, A.V[3]);

  A.InitPerspectiveFovLH(1, 1.5, 0.2, 20, True);
  CheckEquals(1.83048773, 0, 0, 0, A.V[0]);
  CheckEquals(0, 1.22032511, 0, 0, A.V[1]);
  CheckEquals(0, 0, 1.02020204, 1, A.V[2]);
  CheckEquals(0, 0, -0.404040396, 0, A.V[3]);

  A.InitPerspectiveFovRH(1, 1.5, 0.2, 20, False);
  CheckEquals(1.22032511, 0, 0, 0, A.V[0]);
  CheckEquals(0, 1.83048773, 0, 0, A.V[1]);
  CheckEquals(0, 0, -1.02020204, -1, A.V[2]);
  CheckEquals(0, 0, -0.404040396, 0, A.V[3]);

  A.InitPerspectiveFovRH(1, 1.5, 0.2, 20, True);
  CheckEquals(1.83048773, 0, 0, 0, A.V[0]);
  CheckEquals(0, 1.22032511, 0, 0, A.V[1]);
  CheckEquals(0, 0, -1.02020204, -1, A.V[2]);
  CheckEquals(0, 0, -0.404040396, 0, A.V[3]);
end;

procedure TMatrix4Tests.TestComponents;
var
  A: TMatrix4;
  Row, Col: Integer;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  CheckEquals(1, A[0,0]);
  CheckEquals(2, A[0,1]);
  CheckEquals(3, A[0,2]);
  CheckEquals(4, A[0,3]);
  CheckEquals(5, A[1,0]);
  CheckEquals(6, A[1,1]);
  CheckEquals(7, A[1,2]);
  CheckEquals(8, A[1,3]);
  CheckEquals(9, A[2,0]);
  CheckEquals(10, A[2,1]);
  CheckEquals(11, A[2,2]);
  CheckEquals(12, A[2,3]);
  CheckEquals(13, A[3,0]);
  CheckEquals(14, A[3,1]);
  CheckEquals(15, A[3,2]);
  CheckEquals(16, A[3,3]);

  for Col := 0 to 3 do
    for Row := 0 to 3 do
      A[Col,Row] := A[Col,Row] * 2;

  CheckTrue(A.Columns[0] = Vector4(2, 4, 6, 8));
  CheckTrue(A.Columns[1] = Vector4(10, 12, 14, 16));
  CheckTrue(A.Columns[2] = Vector4(18, 20, 22, 24));
  CheckTrue(A.Columns[3] = Vector4(26, 28, 30, 32));
end;

procedure TMatrix4Tests.TestDivide;
var
  A, B, C: TMatrix4;
  D, E: TVector4;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  C := A / 2;
  CheckEquals(0.5, 1.0, 1.5, 2.0, C.Columns[0]);
  CheckEquals(2.5, 3.0, 3.5, 4.0, C.Columns[1]);
  CheckEquals(4.5, 5.0, 5.5, 6.0, C.Columns[2]);
  CheckEquals(6.5, 7.0, 7.5, 8.0, C.Columns[3]);

  C := 3 / A;
  CheckEquals(3.00000, 1.50000, 1.00000, 0.75000, C.Columns[0]);
  CheckEquals(0.60000, 0.50000, 0.42857, 0.37500, C.Columns[1]);
  CheckEquals(0.33333, 0.30000, 0.27272, 0.25000, C.Columns[2]);
  CheckEquals(0.23076, 0.21428, 0.20000, 0.18750, C.Columns[3]);

  A := Matrix4(6, 2, 3, 4,
               2, 7, 5, 3,
               3, 5, 7, 2,
               4, 3, 2, 6);
  D := Vector4(5, -6, 7, -8);
  E := A / D;
  CheckEquals(1.95087, -2.03508, 2.29824, -2.38245, E);

  E := D / A;
  CheckEquals(1.95087, -2.03508, 2.29824, -2.38245, E);

  B := Matrix4(4, 2, 7, 5,
               3, 3, 5, 7,
               2, 4, 3, 2,
               6, 6, 2, 3);
  C := A / B;
  CheckEquals( 0.651785791, -1.50000000, -2.00000024, 1.000000000, C.Columns[0]);
  CheckEquals( 0.044642783,  1.50000000,  2.00000000, 0.000000000, C.Columns[1]);
  CheckEquals( 0.982142925,  0.00000000,  1.00000012, 0.000000000, C.Columns[2]);
  CheckEquals(-0.714285791,  1.00000000,  0.00000000, 0.000000000, C.Columns[3]);

  C := B / A;
  CheckEquals(0.000000000, -1.17894757,  2.35789442,  1.76842117, C.Columns[0]);
  CheckEquals(0.000000000, -0.84210527,  1.68421078,  2.26315784, C.Columns[1]);
  CheckEquals(0.000000000,  1.15789473, -1.31578934, -1.73684192, C.Columns[2]);
  CheckEquals(1.000000000,  1.82105243, -1.64210546, -1.23157930, C.Columns[3]);
end;

procedure TMatrix4Tests.TestMultiply;
var
  DA, DB: TMatrix3D;
  A, B, C: TMatrix4;
  D, E: TVector4;
begin
  DA := TMatrix3D.Create( 1,  2,  3,  4,
                          5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16);

  A :=           Matrix4( 1,  2,  3,  4,
                          5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16);
  C := A * 2;
  CheckEquals( 2,  4,  6,  8, C.Columns[0]);
  CheckEquals(10, 12, 14, 16, C.Columns[1]);
  CheckEquals(18, 20, 22, 24, C.Columns[2]);
  CheckEquals(26, 28, 30, 32, C.Columns[3]);

  C := -3 * A;
  CheckEquals( -3,  -6,  -9, -12, C.Columns[0]);
  CheckEquals(-15, -18, -21, -24, C.Columns[1]);
  CheckEquals(-27, -30, -33, -36, C.Columns[2]);
  CheckEquals(-39, -42, -45, -48, C.Columns[3]);

  D := Vector4(5, 6, 7, 8);
  E := A * D;
  CheckEquals(202, 228, 254, 280, E);

  E := D * A;
  CheckEquals(70, 174, 278, 382, E);

  DB := TMatrix3D.Create( 5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16,
                         17, 18, 19, 20);

  B := Matrix4          ( 5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16,
                         17, 18, 19, 20);
  C := A * B;
  CheckEquals(202, 228, 254, 280, C.Columns[0]);
  CheckEquals(314, 356, 398, 440, C.Columns[1]);
  CheckEquals(426, 484, 542, 600, C.Columns[2]);
  CheckEquals(538, 612, 686, 760, C.Columns[3]);

  C := B * A;
  CheckEquals(130, 140, 150, 160, C.Columns[0]);
  CheckEquals(306, 332, 358, 384, C.Columns[1]);
  CheckEquals(482, 524, 566, 608, C.Columns[2]);
  CheckEquals(658, 716, 774, 832, C.Columns[3]);
end;

procedure TMatrix4Tests.TestColumns;
var
  A: TMatrix4;
  I: Integer;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  CheckTrue(A.Columns[0] = Vector4(1, 2, 3, 4));
  CheckTrue(A.Columns[1] = Vector4(5, 6, 7, 8));
  CheckTrue(A.Columns[2] = Vector4(9, 10, 11, 12));
  CheckTrue(A.Columns[3] = Vector4(13, 14, 15, 16));

  for I := 0 to 3 do
    A.Columns[I] := A.Columns[I] * 2;

  CheckEquals( 2, A[0,0]);
  CheckEquals( 4, A[0,1]);
  CheckEquals( 6, A[0,2]);
  CheckEquals( 8, A[0,3]);
  CheckEquals(10, A[1,0]);
  CheckEquals(12, A[1,1]);
  CheckEquals(14, A[1,2]);
  CheckEquals(16, A[1,3]);
  CheckEquals(18, A[2,0]);
  CheckEquals(20, A[2,1]);
  CheckEquals(22, A[2,2]);
  CheckEquals(24, A[2,3]);
  CheckEquals(26, A[3,0]);
  CheckEquals(28, A[3,1]);
  CheckEquals(30, A[3,2]);
  CheckEquals(32, A[3,3]);
end;

procedure TMatrix4Tests.TestImplicit;
var
  FM: TMatrix4;
  DM: TMatrix3D;
begin
  DM := TMatrix3D.Create(11, 12, 13, 14,
                         15, 16, 17, 18,
                         19, 20, 21, 22,
                         23, 24, 25, 26);
  FM := DM;
  CheckEquals(11, 15, 19, 23, FM.Columns[0]);
  CheckEquals(12, 16, 20, 24, FM.Columns[1]);
  CheckEquals(13, 17, 21, 25, FM.Columns[2]);
  CheckEquals(14, 18, 22, 26, FM.Columns[3]);

  FM := Matrix4( 0,  1,  2,  3,
                 4,  5,  6,  7,
                 8,  9, 10, 11,
                12, 13, 14, 15);

  DM := FM;
  CheckEquals(0, DM.M[0].X);
  CheckEquals(4, DM.M[0].Y);
  CheckEquals(8, DM.M[0].Z);
  CheckEquals(12, DM.M[0].W);
  CheckEquals(1, DM.M[1].X);
  CheckEquals(5, DM.M[1].Y);
  CheckEquals(9, DM.M[1].Z);
  CheckEquals(13, DM.M[1].W);
  CheckEquals(2, DM.M[2].X);
  CheckEquals(6, DM.M[2].Y);
  CheckEquals(10, DM.M[2].Z);
  CheckEquals(14, DM.M[2].W);
  CheckEquals(3, DM.M[3].X);
  CheckEquals(7, DM.M[3].Y);
  CheckEquals(11, DM.M[3].Z);
  CheckEquals(15, DM.M[3].W);
end;
{$ELSE}
procedure TMatrix4Tests.TestCameraConstructors;
var
  A: TMatrix4;
  M: TMatrix3D;
begin
  A.InitLookAtLH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtLH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitLookAtRH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtRH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitLookAtDirLH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtDirLH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitLookAtDirRH(Vector3(1, 2, 3), Vector3(6, 5, 4), Vector3(9, 7, 8));
  M := TMatrix3D.CreateLookAtDirRH(Point3D(1, 2, 3), Point3D(6, 5, 4), Point3D(9, 7, 8));
  CheckEquals(M, A);

  A.InitOrthoLH(4, 5, 0.5, 50);
  M := TMatrix3D.CreateOrthoLH(4, 5, 0.5, 50);
  CheckEquals(M, A);

  A.InitOrthoRH(4, 5, 0.5, 50);
  M := TMatrix3D.CreateOrthoRH(4, 5, 0.5, 50);
  CheckEquals(M, A);

  A.InitOrthoOffCenterLH(1, 2, 3, 4, 0.5, 50);
  M := TMatrix3D.CreateOrthoOffCenterLH(1, 2, 3, 4, 0.5, 50);
  CheckEquals(M, A);

  A.InitOrthoOffCenterRH(1, 2, 3, 4, 0.5, 50);
  M := TMatrix3D.CreateOrthoOffCenterRH(1, 2, 3, 4, 0.5, 50);
  CheckEquals(M, A);

  A.InitPerspectiveFovLH(1, 1.5, 0.2, 20, False);
  M := TMatrix3D.CreatePerspectiveFovLH(1, 1.5, 0.2, 20, False);
  CheckEquals(M, A);

  A.InitPerspectiveFovLH(1, 1.5, 0.2, 20, True);
  M := TMatrix3D.CreatePerspectiveFovLH(1, 1.5, 0.2, 20, True);
  CheckEquals(M, A);

  A.InitPerspectiveFovRH(1, 1.5, 0.2, 20, False);
  M := TMatrix3D.CreatePerspectiveFovRH(1, 1.5, 0.2, 20, False);
  CheckEquals(M, A);

  A.InitPerspectiveFovRH(1, 1.5, 0.2, 20, True);
  M := TMatrix3D.CreatePerspectiveFovRH(1, 1.5, 0.2, 20, True);
  CheckEquals(M, A);
end;

procedure TMatrix4Tests.TestComponents;
var
  A: TMatrix4;
  Row, Col: Integer;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  CheckEquals(1, A[0,0]);
  CheckEquals(2, A[0,1]);
  CheckEquals(3, A[0,2]);
  CheckEquals(4, A[0,3]);
  CheckEquals(5, A[1,0]);
  CheckEquals(6, A[1,1]);
  CheckEquals(7, A[1,2]);
  CheckEquals(8, A[1,3]);
  CheckEquals(9, A[2,0]);
  CheckEquals(10, A[2,1]);
  CheckEquals(11, A[2,2]);
  CheckEquals(12, A[2,3]);
  CheckEquals(13, A[3,0]);
  CheckEquals(14, A[3,1]);
  CheckEquals(15, A[3,2]);
  CheckEquals(16, A[3,3]);

  for Row := 0 to 3 do
    for Col := 0 to 3 do
      A[Row,Col] := A[Row,Col] * 2;

  CheckTrue(A.Rows[0] = Vector4(2, 4, 6, 8));
  CheckTrue(A.Rows[1] = Vector4(10, 12, 14, 16));
  CheckTrue(A.Rows[2] = Vector4(18, 20, 22, 24));
  CheckTrue(A.Rows[3] = Vector4(26, 28, 30, 32));
end;

procedure TMatrix4Tests.TestDivide;
var
  A, B, C: TMatrix4;
  D, E: TVector4;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  C := A / 2;
  CheckEquals(0.5, 1.0, 1.5, 2.0, C.Rows[0]);
  CheckEquals(2.5, 3.0, 3.5, 4.0, C.Rows[1]);
  CheckEquals(4.5, 5.0, 5.5, 6.0, C.Rows[2]);
  CheckEquals(6.5, 7.0, 7.5, 8.0, C.Rows[3]);

  C := 3 / A;
  CheckEquals(3.00000, 1.50000, 1.00000, 0.75000, C.Rows[0]);
  CheckEquals(0.60000, 0.50000, 0.42857, 0.37500, C.Rows[1]);
  CheckEquals(0.33333, 0.30000, 0.27272, 0.25000, C.Rows[2]);
  CheckEquals(0.23076, 0.21428, 0.20000, 0.18750, C.Rows[3]);

  A := Matrix4(6, 2, 3, 4,
               2, 7, 5, 3,
               3, 5, 7, 2,
               4, 3, 2, 6);
  D := Vector4(5, -6, 7, -8);
  E := A / D;
  CheckEquals(1.95087, -2.03508, 2.29824, -2.38245, E);

  E := D / A;
  CheckEquals(1.95087, -2.03508, 2.29824, -2.38245, E);

  B := Matrix4(4, 2, 7, 5,
               3, 3, 5, 7,
               2, 4, 3, 2,
               6, 6, 2, 3);
  C := A / B;
  CheckEquals( 0.68452,  0.04761, -1.31547,  0.95833, C.Rows[0]);
  CheckEquals(-0.22321,  0.07142,  2.27678, -0.31250, C.Rows[1]);
  CheckEquals( 0.79166, -0.66666,  1.79166, -0.29166, C.Rows[2]);
  CheckEquals(-0.28273,  1.02380, -0.78273,  0.60416, C.Rows[3]);

  C := B / A;
  CheckEquals(-0.83508, -1.59649,  2.07017,  1.49824, C.Rows[0]);
  CheckEquals(-1.24561, -1.17543,  1.49122,  2.08771, C.Rows[1]);
  CheckEquals( 0.23508,  0.59649, -0.07017, -0.09824, C.Rows[2]);
  CheckEquals( 2.02456,  2.01754, -1.64912, -1.30877, C.Rows[3]);
end;

procedure TMatrix4Tests.TestImplicit;
var
  FM: TMatrix4;
  DM: TMatrix3D;
begin
  DM := TMatrix3D.Create(11, 12, 13, 14,
                         15, 16, 17, 18,
                         19, 20, 21, 22,
                         23, 24, 25, 26);
  FM := DM;
  CheckEquals(11, 12, 13, 14, FM.Rows[0]);
  CheckEquals(15, 16, 17, 18, FM.Rows[1]);
  CheckEquals(19, 20, 21, 22, FM.Rows[2]);
  CheckEquals(23, 24, 25, 26, FM.Rows[3]);

  FM := Matrix4( 0,  1,  2,  3,
                 4,  5,  6,  7,
                 8,  9, 10, 11,
                12, 13, 14, 15);

  DM := FM;
  CheckEquals(0, DM.M[0].X);
  CheckEquals(1, DM.M[0].Y);
  CheckEquals(2, DM.M[0].Z);
  CheckEquals(3, DM.M[0].W);
  CheckEquals(4, DM.M[1].X);
  CheckEquals(5, DM.M[1].Y);
  CheckEquals(6, DM.M[1].Z);
  CheckEquals(7, DM.M[1].W);
  CheckEquals(8, DM.M[2].X);
  CheckEquals(9, DM.M[2].Y);
  CheckEquals(10, DM.M[2].Z);
  CheckEquals(11, DM.M[2].W);
  CheckEquals(12, DM.M[3].X);
  CheckEquals(13, DM.M[3].Y);
  CheckEquals(14, DM.M[3].Z);
  CheckEquals(15, DM.M[3].W);
end;

procedure TMatrix4Tests.TestMultiply;
var
  DA, DB, DC: TMatrix3D;
  DD, DE: TVector3D;
  A, B, C: TMatrix4;
  D, E: TVector4;
begin
  DA := TMatrix3D.Create( 1,  2,  3,  4,
                          5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16);

  A :=           Matrix4( 1,  2,  3,  4,
                          5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16);
  C := A * 2;
  CheckEquals( 2,  4,  6,  8, C.Rows[0]);
  CheckEquals(10, 12, 14, 16, C.Rows[1]);
  CheckEquals(18, 20, 22, 24, C.Rows[2]);
  CheckEquals(26, 28, 30, 32, C.Rows[3]);

  C := -3 * A;
  CheckEquals( -3,  -6,  -9, -12, C.Rows[0]);
  CheckEquals(-15, -18, -21, -24, C.Rows[1]);
  CheckEquals(-27, -30, -33, -36, C.Rows[2]);
  CheckEquals(-39, -42, -45, -48, C.Rows[3]);

  D := Vector4(5, 6, 7, 8);
  E := A * D;
  CheckEquals(70, 174, 278, 382, E);

  DD := Vector3D(5, 6, 7, 8);
  DE := DD * DA;
  E := D * A;
  CheckEquals(DE, E);

  DB := TMatrix3D.Create( 5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16,
                         17, 18, 19, 20);

  B := Matrix4          ( 5,  6,  7,  8,
                          9, 10, 11, 12,
                         13, 14, 15, 16,
                         17, 18, 19, 20);
  DC := DA * DB;
  C := A * B;
  CheckEquals(DC.M[0], C.Rows[0]);
  CheckEquals(DC.M[1], C.Rows[1]);
  CheckEquals(DC.M[2], C.Rows[2]);
  CheckEquals(DC.M[3], C.Rows[3]);

  DC := DB * DA;
  C := B * A;
  CheckEquals(DC.M[0], C.Rows[0]);
  CheckEquals(DC.M[1], C.Rows[1]);
  CheckEquals(DC.M[2], C.Rows[2]);
  CheckEquals(DC.M[3], C.Rows[3]);
end;

procedure TMatrix4Tests.TestRows;
var
  A: TMatrix4;
  I: Integer;
begin
  A := Matrix4( 1,  2,  3,  4,
                5,  6,  7,  8,
                9, 10, 11, 12,
               13, 14, 15, 16);
  CheckTrue(A.Rows[0] = Vector4(1, 2, 3, 4));
  CheckTrue(A.Rows[1] = Vector4(5, 6, 7, 8));
  CheckTrue(A.Rows[2] = Vector4(9, 10, 11, 12));
  CheckTrue(A.Rows[3] = Vector4(13, 14, 15, 16));

  for I := 0 to 3 do
    A.Rows[I] := A.Rows[I] * 2;

  CheckEquals( 2, A[0,0]);
  CheckEquals( 4, A[0,1]);
  CheckEquals( 6, A[0,2]);
  CheckEquals( 8, A[0,3]);
  CheckEquals(10, A[1,0]);
  CheckEquals(12, A[1,1]);
  CheckEquals(14, A[1,2]);
  CheckEquals(16, A[1,3]);
  CheckEquals(18, A[2,0]);
  CheckEquals(20, A[2,1]);
  CheckEquals(22, A[2,2]);
  CheckEquals(24, A[2,3]);
  CheckEquals(26, A[3,0]);
  CheckEquals(28, A[3,1]);
  CheckEquals(30, A[3,2]);
  CheckEquals(32, A[3,3]);
end;
{$ENDIF}

end.
