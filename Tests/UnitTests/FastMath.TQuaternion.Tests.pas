unit FastMath.TQuaternion.Tests;

interface

uses
  System.Math.Vectors,
  UnitTest,
  Neslib.FastMath;

type
  TQuaternionTests = class(TUnitTest)
  private
    procedure CheckEquals(const AExpected: TQuaternion3D; const AActual: TQuaternion); overload;
  published
    procedure TestSize;
    procedure TestConstructors;
    procedure TestImplicit;
    procedure TestConstants;
    procedure TestAdd;
    procedure TestMultiply;
    procedure TestConjugate;
    procedure TestSetConjugate;
    procedure TestToMatrix;
    procedure TestIsIdentity;
    procedure TestInitFromMatrix;
    procedure TestLength;
    procedure TestLengthSquared;
    procedure TestNormalize;
    procedure TestNormalizeFast;
    procedure TestSetNormalized;
    procedure TestSetNormalizedFast;
  end;

implementation

{ TQuaternionTests }

procedure TQuaternionTests.CheckEquals(const AExpected: TQuaternion3D;
  const AActual: TQuaternion);
begin
  CheckEquals(AExpected.ImagPart.X, AActual.X);
  CheckEquals(AExpected.ImagPart.Y, AActual.Y);
  CheckEquals(AExpected.ImagPart.Z, AActual.Z);
  CheckEquals(AExpected.RealPart, AActual.W);
end;

procedure TQuaternionTests.TestAdd;
var
  A, B, C: TQuaternion;
begin
  A := Quaternion(-1, 2, 3, -4);
  B := Quaternion(6, -7, 8, -9);
  C := A + B;
  CheckEquals(5, -5, 11, -13, C);
end;

procedure TQuaternionTests.TestConjugate;
var
  A: TQuaternion;
begin
  A := Quaternion(1, -2, -3, 4).Conjugate;
  CheckEquals(-1, 2, 3, 4, A);
end;

procedure TQuaternionTests.TestConstants;
begin
  CheckEquals(0, 0, 0, 1, TQuaternion.Identity);
end;

procedure TQuaternionTests.TestConstructors;
var
  A: TQuaternion;
  Q: TQuaternion3D;
begin
  A := Quaternion;
  CheckEquals(0, 0, 0, 1, A);

  A := Quaternion(1, 2, 3, 4);
  CheckEquals(1, 2, 3, 4, A);

  A := Quaternion(Vector3(1, 2, 3), Radians(45));
  Q := TQuaternion3D.Create(Point3D(1, 2, 3), Radians(45));
  CheckEquals(0.102276, 0.204553, 0.306829, 0.923880, A);
  CheckEquals(Q, A);

  A.Init(Radians(30), Radians(45), Radians(60));
  Q := TQuaternion3D.Create(Radians(30), Radians(45), Radians(60));
  CheckEquals(0.439680, 0.022260, 0.360423, 0.822363, A);
  CheckEquals(Q, A);

  A.Init(1, 2, 3, 4);
  CheckEquals(1, 2, 3, 4, A);
end;

procedure TQuaternionTests.TestImplicit;
var
  FQ: TQuaternion;
  DQ: TQuaternion3D;
begin
  DQ.ImagPart := Point3D(2, 3, 4);
  DQ.RealPart := 5;
  FQ := DQ;
  CheckEquals(2, 3, 4, 5, FQ);

  FQ.Init(1.1, 2.2, 3.3, 4.4);
  DQ := FQ;
  CheckEquals(1.1, DQ.ImagPart.X);
  CheckEquals(2.2, DQ.ImagPart.Y);
  CheckEquals(3.3, DQ.ImagPart.Z);
  CheckEquals(4.4, DQ.RealPart);
end;

procedure TQuaternionTests.TestInitFromMatrix;
var
  M: TMatrix4;
  A: TQuaternion;
  DM: TMatrix3D;
  DQ: TQuaternion3D;
begin
  M := Matrix4( -1,  2,  -3, 4,
                -5, -6,  -7, 8,
                -9, 10, -11, 12,
               -13, 14, -15, 16);
  A.Init(M);

  DM := TMatrix3D.Create( -1,  2,  -3,  4,
                          -5, -6,  -7,  8,
                          -9, 10, -11, 12,
                         -13, 14, -15, 16);
  DQ := TQuaternion3D.Create(DM);

  CheckEquals(DQ, A);
end;

procedure TQuaternionTests.TestIsIdentity;
var
  A: TQuaternion;
begin
  CheckTrue(TQuaternion.Identity.IsIdentity);

  A := Quaternion;
  CheckTrue(A.IsIdentity);

  A := Quaternion(0, 0, 0, 0);
  CheckFalse(A.IsIdentity);

  A := Quaternion(1, 0, 0, 1);
  CheckFalse(A.IsIdentity);

  A := Quaternion(0, 0.01, 0, 0.99);
  CheckFalse(A.IsIdentity);

  A := Quaternion(0, 0.01, 0, 0.99);
  CheckTrue(A.IsIdentity(0.01));
end;

procedure TQuaternionTests.TestLength;
begin
  CheckEquals(7.34846, Quaternion(2, 3, -4, -5).Length);
end;

procedure TQuaternionTests.TestLengthSquared;
begin
  CheckEquals(54, Quaternion(2, 3, -4, -5).LengthSquared);
end;

procedure TQuaternionTests.TestMultiply;
var
  A, B, C: TQuaternion;
  DA, DB, DC: TQuaternion3D;
begin
  A := Quaternion(-1, 2, 3, -4);
  DA.ImagPart := Point3D(-1, 2, 3);
  DA.RealPart := -4;

  B := A * -2.5;
  CheckEquals(2.5, -5, -7.5, 10, B);

  B := 1.5 * A;
  CheckEquals(-1.5, 3, 4.5, -6, B);

  B := Quaternion(6, -7, 8, -9);
  DB.ImagPart := Point3D(6, -7, 8);
  DB.RealPart := -9;

  C := A * B;
  DC := DA * DB;
  CheckEquals(22, 36, -64, 32, C);
  CheckEquals(DC, C);

  C := B * A;
  DC := DB * DA;
  CheckEquals(-52, -16, -54, 32, C);
  CheckEquals(DC, C);
end;

procedure TQuaternionTests.TestNormalize;
begin
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, Quaternion(-2, -3, -4, -5).Normalize);
end;

procedure TQuaternionTests.TestNormalizeFast;
begin
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, Quaternion(-2, -3, -4, -5).NormalizeFast);
end;

procedure TQuaternionTests.TestSetConjugate;
var
  A: TQuaternion;
begin
  A := Quaternion(-1, 2, 3, -4);
  A.SetConjugate;
  CheckEquals(1, -2, -3, -4, A);
end;

procedure TQuaternionTests.TestSetNormalized;
var
  Q: TQuaternion;
begin
  Q := Quaternion(-2, -3, -4, -5);
  Q.SetNormalized;
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, Q);
end;

procedure TQuaternionTests.TestSetNormalizedFast;
var
  Q: TQuaternion;
begin
  Q := Quaternion(-2, -3, -4, -5);
  Q.SetNormalizedFast;
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, Q);
end;

procedure TQuaternionTests.TestSize;
begin
  CheckEquals(16, SizeOf(TQuaternion));
end;

procedure TQuaternionTests.TestToMatrix;
var
  A: TQuaternion;
  M: TMatrix4;
  DQ: TQuaternion3D;
  DM: TMatrix3D;
begin
  A := Quaternion(-2, 3, -4, 5);
  M := A.ToMatrix;

  DQ.ImagPart := Point3D(-2, 3, -4);
  DQ.RealPart := 5;
  DM := DQ;

  CheckEquals(DM.m11, M.m11);
  CheckEquals(DM.m12, M.m12);
  CheckEquals(DM.m13, M.m13);
  CheckEquals(DM.m14, M.m14);

  CheckEquals(DM.m21, M.m21);
  CheckEquals(DM.m22, M.m22);
  CheckEquals(DM.m23, M.m23);
  CheckEquals(DM.m24, M.m24);

  CheckEquals(DM.m31, M.m31);
  CheckEquals(DM.m32, M.m32);
  CheckEquals(DM.m33, M.m33);
  CheckEquals(DM.m34, M.m34);

  CheckEquals(DM.m41, M.m41);
  CheckEquals(DM.m42, M.m42);
  CheckEquals(DM.m43, M.m43);
  CheckEquals(DM.m44, M.m44);
end;

end.
