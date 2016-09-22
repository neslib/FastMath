unit FastMath.TVector4.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TVector4Tests = class(TUnitTest)
  published
    procedure TestSize;
    procedure TestConstructors;
    procedure TestImplicit;
    procedure TestComponents;
    procedure TestConstants;
    procedure TestEquality;
    procedure TestAdd;
    procedure TestSubtract;
    procedure TestMultiply;
    procedure TestDivide;
    procedure TestNegative;
    procedure TestLength;
    procedure TestLengthSquared;
    procedure TestDistance;
    procedure TestDistanceSquared;
    procedure TestDot;
    procedure TestOffset;
    procedure TestNormalize;
    procedure TestNormalizeFast;
    procedure TestSetNormalized;
    procedure TestSetNormalizedFast;
    procedure TestFaceForward;
    procedure TestReflect;
    procedure TestRefract;
    procedure TestLimit;
    procedure TestLimitSquared;
    procedure TestSetLimit;
    procedure TestSetLimitSquared;
    procedure TestClamp;
    procedure TestSetClamped;
    procedure TestIsNormalized;
    procedure TestIsZero;
    procedure TestIsParallel;
    procedure TestHasSameDirection;
    procedure TestHasOppositeDirection;
    procedure TestIsCollinear;
    procedure TestIsCollinearOpposite;
    procedure TestIsPerpendicular;
    procedure TestEquals;
    procedure TestLerp;
    procedure TestSetLerp;
  end;

implementation

uses
  System.Math.Vectors;

{ TVector4Tests }

procedure TVector4Tests.TestAdd;
var
  A, B, C: TVector4;
begin
  A := Vector4(2, 3, 4, 5);
  C := A + 1;
  CheckEquals(3, 4, 5, 6, C);

  A := Vector4(4, 5, 6, 7);
  C := 1 + A;
  CheckEquals(5, 6, 7, 8, C);

  A := Vector4(6, 7, 8, 9);
  B := Vector4(-1, -3, -5, -7);
  C := A + B;
  CheckEquals(5, 4, 3, 2, C);
end;

procedure TVector4Tests.TestClamp;
var
  V: TVector4;
begin
  V := Vector4(-2, 3, -4, 5).Clamp(7, 8);
  CheckEquals(-2, 3, -4, 5, V);

  V := Vector4(-4, 6, -8, 10).Clamp(7, 7.34846);
  CheckEquals(-2, 3, -4, 5, V);

  V := Vector4(-1, 1.5, -2, 2.5).Clamp(7.34846, 8);
  CheckEquals(-2, 3, -4, 5, V);
end;

procedure TVector4Tests.TestComponents;
var
  A: TVector4;
begin
  A := Vector4(1, 2, 3, 4);
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);
  CheckEquals(3, A[2]);
  CheckEquals(4, A[3]);

  A[3] := A[2] * 2;
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);
  CheckEquals(3, A[2]);
  CheckEquals(6, A[3]);
end;

procedure TVector4Tests.TestConstants;
begin
  CheckEquals(0, 0, 0, 0, TVector4.Zero);
  CheckEquals(1, 1, 1, 1, TVector4.One);
  CheckEquals(1, 0, 0, 0, TVector4.UnitX);
  CheckEquals(0, 1, 0, 0, TVector4.UnitY);
  CheckEquals(0, 0, 1, 0, TVector4.UnitZ);
  CheckEquals(0, 0, 0, 1, TVector4.UnitW);
end;

procedure TVector4Tests.TestConstructors;
var
  A: TVector4;
  B: TVector2;
  C: TVector3;
begin
  A := Vector4;
  CheckEquals(0, 0, 0, 0, A);

  A := Vector4(1);
  CheckEquals(1, 1, 1, 1, A);

  A := Vector4(2, 3, 4, 5);
  CheckEquals(2, A.X);
  CheckEquals(3, A.Y);
  CheckEquals(4, A.Z);
  CheckEquals(5, A.W);
  CheckEquals(2, A.R);
  CheckEquals(3, A.G);
  CheckEquals(4, A.B);
  CheckEquals(5, A.A);
  CheckEquals(2, A.S);
  CheckEquals(3, A.T);
  CheckEquals(4, A.P);
  CheckEquals(5, A.Q);

  B := Vector2(4, 5);
  A := Vector4(1, 2, B);
  CheckEquals(1, 2, 4, 5, A);

  A := Vector4(1, B, 2);
  CheckEquals(1, 4, 5, 2, A);

  A := Vector4(B, 1, 2);
  CheckEquals(4, 5, 1, 2, A);

  A := Vector4(B, B);
  CheckEquals(4, 5, 4, 5, A);

  C := Vector3(7, 8, 9);
  A := Vector4(C, 1);
  CheckEquals(7, 8, 9, 1, A);

  A := Vector4(1, C);
  CheckEquals(1, 7, 8, 9, A);

  A.Init;
  CheckEquals(0, 0, 0, 0, A);

  A.Init(1);
  CheckEquals(1, 1, 1, 1, A);

  A.Init(2, 3, 4, 5);
  CheckEquals(2, 3, 4, 5, A);
end;

procedure TVector4Tests.TestDistance;
begin
  CheckEquals(7.34846, Vector4(3, 5, 7, 9).Distance(Vector4(1, 2, 3, 4)));
end;

procedure TVector4Tests.TestDistanceSquared;
begin
  CheckEquals(54, Vector4(3, 5, 7, 9).DistanceSquared(Vector4(1, 2, 3, 4)));
end;

procedure TVector4Tests.TestDivide;
var
  A, B, C: TVector4;
begin
  A := Vector4(20, 21, 22, 23);
  C := A / 2;
  CheckEquals(10, 10.5, 11, 11.5, C);

  A := Vector4(4, 8, 16, 32);
  C := 2 / A;
  CheckEquals(0.5, 0.25, 0.125, 0.0625, C);

  A := Vector4(24, 25, 27, 28);
  B := Vector4(-3, -5, -3, -4);
  C := A / B;
  CheckEquals(-8, -5, -9, -7, C);
end;

procedure TVector4Tests.TestDot;
begin
  CheckEquals(4, Vector4(2, -3, 4, -5).Dot(Vector4(-9, -8, 7, 6)));
end;

procedure TVector4Tests.TestEquality;
var
  A, B: TVector4;
begin
  A := Vector4(1.1);
  B := Vector4(1.1);
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := Vector4(1.1, 2.2, 3.3, 4.4);
  B := Vector4(1.2, 2.2, 3.3, 4.4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := Vector4(1.1, 2.2, 3.3, 4.4);
  B := Vector4(1.1, 2.3, 3.3, 4.4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := Vector4(1.1, 2.2, 3.3, 4.4);
  B := Vector4(1.1, 2.2, 3.4, 4.4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := Vector4(1.1, 2.2, 3.3, 4.4);
  B := Vector4(1.1, 2.2, 3.3, 4.5);
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TVector4Tests.TestEquals;
begin
  CheckTrue(Vector4(1, 1, 1, 1).Equals(Vector4(1, 1, 1, 1)));
  CheckTrue(Vector4(-1, 1, 1, -1).Equals(Vector4(-1, 1, 1, -1)));
  CheckFalse(Vector4(1, -1, -1, 1).Equals(Vector4(1, -1, -1, 1.0001)));
  CheckTrue(Vector4(1, -1, -1, 1).Equals(Vector4(1, -1, -1, 1.0001), 0.0002));
end;

procedure TVector4Tests.TestFaceForward;
var
  V: TVector4;
begin
  V := Vector4(1, 2, 3, 4).FaceForward(Vector4(2, 3, 4, 5), Vector4(4, 5, 6, 7));
  CheckEquals(-1, -2, -3, -4, V);
end;

procedure TVector4Tests.TestHasOppositeDirection;
begin
  CheckTrue(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(-2, -2, -2, -2)));
  CheckTrue(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(-1, -1, -1, 1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(1, -1, -1, -1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(-1, 1, -1, -1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(-1, -1, 1, -1)));

  CheckFalse(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(-1, 1, 1, 1)));
  CheckFalse(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(1, -1, 1, 1)));
  CheckFalse(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(1, 1, -1, 1)));
  CheckFalse(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(1, 1, 1, -1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasOppositeDirection(Vector4(-1, -1, -1, -1)));
end;

procedure TVector4Tests.TestHasSameDirection;
begin
  CheckTrue(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(2, 2, 2, 2)));
  CheckTrue(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(-1, 1, 1, 1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(1, -1, 1, 1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(1, 1, -1, 1)));
  CheckTrue(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(1, 1, 1, -1)));

  CheckFalse(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(-1, -1, 1, 1)));
  CheckFalse(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(1, -1, -1, 1)));
  CheckFalse(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(-1, 1, -1, -1)));
  CheckFalse(Vector4(1, 1, 1, 1).HasSameDirection(Vector4(-1, -1, -1, -1)));
end;

procedure TVector4Tests.TestImplicit;
var
  A: TVector4;
  V: TVector3D;
begin
  A.Init(1.1, 2.2, 3.3, 4.4);
  V := A;
  CheckEquals(1.1, V.X);
  CheckEquals(2.2, V.Y);
  CheckEquals(3.3, V.Z);
  CheckEquals(4.4, V.W);

  V := Vector3D(5, 6, 7, 8);
  A := V;
  CheckEquals(5, 6, 7, 8, A);
end;

procedure TVector4Tests.TestIsCollinear;
begin
  CheckTrue(Vector4(1, 1, 1, 10).IsCollinear(Vector4(1, 1, 1, 20)));
  CheckTrue(Vector4(1, 1, 1, 11).IsCollinear(Vector4(2, 2, 2, 21)));
  CheckFalse(Vector4(1, 1, 1, 12).IsCollinear(Vector4(-1, -1, -1, 22)));
  CheckFalse(Vector4(1, 1, 1, 13).IsCollinear(Vector4(-3, -3, -3, 23)));
  CheckFalse(Vector4(1, 1, 1, 14).IsCollinear(Vector4(1, -1, 1, 24)));
end;

procedure TVector4Tests.TestIsCollinearOpposite;
begin
  CheckFalse(Vector4(1, 1, 1, 10).IsCollinearOpposite(Vector4(1, 1, 1, 20)));
  CheckFalse(Vector4(1, 1, 1, 11).IsCollinearOpposite(Vector4(2, 2, 2, 21)));
  CheckTrue(Vector4(1, 1, 1, 12).IsCollinearOpposite(Vector4(-1, -1, -1, 22)));
  CheckTrue(Vector4(1, 1, 1, 13).IsCollinearOpposite(Vector4(-3, -3, -3, 23)));
  CheckFalse(Vector4(1, 1, 1, 14).IsCollinearOpposite(Vector4(1, -1, 1, 24)));
end;

procedure TVector4Tests.TestIsNormalized;
begin
  CheckTrue(Vector4(1, 0, 0, 0).IsNormalized);
  CheckTrue(Vector4(0, 1, 0, 0).IsNormalized);
  CheckTrue(Vector4(0, 0, 1, 0).IsNormalized);
  CheckTrue(Vector4(0, 0, 0, 1).IsNormalized);
  CheckFalse(Vector4(1, 0, 1, 0).IsNormalized);
  CheckTrue(Vector4(0.5, 0.5, 0.5, 0.5).IsNormalized);

  CheckFalse(Vector4(1, 1, 0, 0).IsNormalized(0.1));
  CheckTrue(Vector4(0.57735, 0.57735, 0.57735, 0).IsNormalized(0.000001));
end;

procedure TVector4Tests.TestIsParallel;
begin
  CheckTrue(Vector4(1, 1, 1, 10).IsParallel(Vector4(1, 1, 1, 20)));
  CheckTrue(Vector4(1, 1, 1, 11).IsParallel(Vector4(2, 2, 2, 21)));
  CheckTrue(Vector4(1, 1, 1, 12).IsParallel(Vector4(-1, -1, -1, 22)));
  CheckTrue(Vector4(1, 1, 1, 13).IsParallel(Vector4(-3, -3, -3, 23)));
  CheckFalse(Vector4(1, 1, 1, 14).IsParallel(Vector4(1, -1, 1, 24)));

  CheckTrue(Vector4(0, 0, 0, 15).IsParallel(Vector4(0, 0, 0, 25)));
  CheckTrue(Vector4(1, 1, 1, 16).IsParallel(Vector4(0, 0, 0, 26)));
end;

procedure TVector4Tests.TestIsPerpendicular;
begin
  CheckFalse(Vector4(1, 1, 1, 10).IsPerpendicular(Vector4(1, 1, 1, 20)));
  CheckFalse(Vector4(1, 1, 1, 11).IsPerpendicular(Vector4(2, 2, 2, 21)));
  CheckFalse(Vector4(1, 1, 1, 12).IsPerpendicular(Vector4(-1, -1, -1, 22)));
  CheckFalse(Vector4(1, 1, 1, 13).IsPerpendicular(Vector4(-3, -3, -3, 23)));

  CheckTrue(Vector4(1, 0, 0, 14).IsPerpendicular(Vector4(0, 2, 0, 24)));
  CheckTrue(Vector4(1, 0, 0, 15).IsPerpendicular(Vector4(0, 0, 2, 25)));
  CheckTrue(Vector4(0, 1, 0, 16).IsPerpendicular(Vector4(1, 0, 0, 26)));
  CheckTrue(Vector4(0, 1, 0, 17).IsPerpendicular(Vector4(0, 0, 1, 27)));
  CheckTrue(Vector4(0, 0, 1, 18).IsPerpendicular(Vector4(3, 0, 0, 28)));
  CheckTrue(Vector4(0, 0, 1, 19).IsPerpendicular(Vector4(0, 3, 0, 29)));
end;

procedure TVector4Tests.TestIsZero;
begin
  CheckTrue(Vector4(0, 0, 0, 0).IsZero);
  CheckFalse(Vector4(1, 0, 0, 0).IsZero);
  CheckFalse(Vector4(0, 1, 0, 0).IsZero);
  CheckFalse(Vector4(0, 0, 1, 0).IsZero);
  CheckFalse(Vector4(0, 0, 0, 1).IsZero);
  CheckFalse(Vector4(0.0001, 0.0001, 0.0001, 0.0001).IsZero);

  CheckFalse(Vector4(1, 0, 0, 0).IsZero(0.1));
  CheckTrue(Vector4(0.0001, 0.0001, 0.0001, 0.0001).IsZero(0.0000001));
end;

procedure TVector4Tests.TestLength;
var
  V: TVector4;
begin
  CheckEquals(0, Vector4(0, 0, 0, 0).Length);
  CheckEquals(1, Vector4(-1, 0, 0, 0).Length);
  CheckEquals(1, Vector4(0, 1, 0, 0).Length);
  CheckEquals(1, Vector4(0, 0, -1, 0).Length);
  CheckEquals(1, Vector4(0, 0, 0, 1).Length);
  CheckEquals(7.34846, Vector4(2, 3, -4, -5).Length);

  V := Vector4(0, 0, 0, 0);
  V.Length := 5;
  CheckEquals(0, 0, 0, 0, V);

  V := Vector4(2, 3, -4, 5);
  V.Length := 14.69692;
  CheckEquals(4, 6, -8, 10, V);

  V.Length := 14.69692;
  CheckEquals(4, 6, -8, 10, V);
end;

procedure TVector4Tests.TestLengthSquared;
var
  V: TVector4;
begin
  CheckEquals(0, Vector4(0, 0, 0, 0).LengthSquared);
  CheckEquals(1, Vector4(-1, 0, 0, 0).LengthSquared);
  CheckEquals(1, Vector4(0, 1, 0, 0).LengthSquared);
  CheckEquals(1, Vector4(0, 0, -1, 0).LengthSquared);
  CheckEquals(1, Vector4(0, 0, 0, 1).LengthSquared);
  CheckEquals(54, Vector4(2, 3, -4, -5).LengthSquared);

  V := Vector4(0, 0, 0, 0);
  V.LengthSquared := 5;
  CheckEquals(0, 0, 0, 0, V);

  V := Vector4(2, 3, -4, 5);
  V.LengthSquared := 215.9994574864;
  CheckEquals(4, 6, -8, 10, V);

  V.LengthSquared := 215.9994574864;
  CheckEquals(4, 6, -8, 10, V);
end;

procedure TVector4Tests.TestLerp;
var
  Src, Target, V: TVector4;
begin
  Src := Vector4(1, 2, 3, 4);
  Target := Vector4(3, 6, 5, 4);
  V := Src.Lerp(Target, 0.5);
  CheckEquals(2, 4, 4, 4, V);
end;

procedure TVector4Tests.TestLimit;
var
  V: TVector4;
begin
  V := Vector4(-4, 6, -8, 10).Limit(7.34846);
  CheckEquals(-2, 3, -4, 5, V);

  V := V.Limit(8);
  CheckEquals(-2, 3, -4, 5, V);
end;

procedure TVector4Tests.TestLimitSquared;
var
  V: TVector4;
begin
  V := Vector4(-4, 6, -8, 10).LimitSquared(54);
  CheckEquals(-2, 3, -4, 5, V);

  V := V.LimitSquared(55);
  CheckEquals(-2, 3, -4, 5, V);
end;

procedure TVector4Tests.TestSetClamped;
var
  V: TVector4;
begin
  V := Vector4(-2, 3, -4, 5);
  V.SetClamped(7, 8);
  CheckEquals(-2, 3, -4, 5, V);

  V := Vector4(-4, 6, -8, 10);
  V.SetClamped(7, 7.34846);
  CheckEquals(-2, 3, -4, 5, V);

  V := Vector4(-1, 1.5, -2, 2.5);
  V.SetClamped(7.34846, 8);
  CheckEquals(-2, 3, -4, 5, V);
end;

procedure TVector4Tests.TestSetLerp;
var
  Target, V: TVector4;
begin
  V := Vector4(1, 2, 3, 4);
  Target := Vector4(3, 6, 5, 4);
  V.SetLerp(Target, 0.5);
  CheckEquals(2, 4, 4, 4, V);
end;

procedure TVector4Tests.TestSetLimit;
var
  V: TVector4;
begin
  V := Vector4(-4, 6, -8, 10);
  V.SetLimit(7.34846);
  CheckEquals(-2, 3, -4, 5, V);

  V.SetLimit(8);
  CheckEquals(-2, 3, -4, 5, V);
end;

procedure TVector4Tests.TestSetLimitSquared;
var
  V: TVector4;
begin
  V := Vector4(-4, 6, -8, 10);
  V.SetLimitSquared(54);
  CheckEquals(-2, 3, -4, 5, V);

  V.SetLimitSquared(55);
  CheckEquals(-2, 3, -4, 5, V);
end;

procedure TVector4Tests.TestMultiply;
var
  A, B, C: TVector4;
begin
  A := Vector4(14, 15, 16, 17);
  C := A * 2;
  CheckEquals(28, 30, 32, 34, C);

  A := Vector4(16, 17, 18, 19);
  C := 2 * A;
  CheckEquals(32, 34, 36, 38, C);

  A := Vector4(18, 19, 20, 21);
  B := Vector4(-1, -3, -2, -4);
  C := A * B;
  CheckEquals(-18, -57, -40, -84, C);
end;

procedure TVector4Tests.TestNegative;
var
  A, B: TVector4;
begin
  A := Vector4(26, 27, -28, -29);
  B := -A;
  CheckEquals(-26, -27, 28, 29, B);
end;

procedure TVector4Tests.TestNormalize;
begin
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, Vector4(-2, -3, -4, -5).Normalize);
end;

procedure TVector4Tests.TestNormalizeFast;
begin
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, Vector4(-2, -3, -4, -5).NormalizeFast);
end;

procedure TVector4Tests.TestOffset;
var
  A: TVector4;
begin
  A.Init(1, 2, 3, 4);
  A.Offset(3, 4, 5, 6);
  CheckEquals(4, 6, 8, 10, A);
  A.Offset(Vector4(2, 1, 3, 4));
  CheckEquals(6, 7, 11, 14, A);
end;

procedure TVector4Tests.TestReflect;
var
  V: TVector4;
begin
  V := Vector4(1, -1, 2, 4).Reflect(Vector4(0, 1, 3, -5));
  CheckEquals(1, 29, 92, -146, V);
end;

procedure TVector4Tests.TestRefract;
var
  V: TVector4;
begin
  V := Vector4(0, -1, 2, -3).Refract(Vector4(-2, 3, 4, -5), 0.1);
  CheckEquals(8.46766, -12.80149, -16.73532, 20.86915, V);

  V := Vector4(0, 0, 0, 1).Refract(Vector4(0, 0, 1, 0), 1.1);
  CheckEquals(0, 0, 0, 0, V);
end;

procedure TVector4Tests.TestSetNormalized;
var
  V: TVector4;
begin
  V := Vector4(-2, -3, -4, -5);
  V.SetNormalized;
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, V);
end;

procedure TVector4Tests.TestSetNormalizedFast;
var
  V: TVector4;
begin
  V := Vector4(-2, -3, -4, -5);
  V.SetNormalizedFast;
  CheckEquals(-0.27216, -0.40824, -0.54433, -0.68041, V);
end;

procedure TVector4Tests.TestSize;
begin
  CheckEquals(16, SizeOf(TVector4));
end;

procedure TVector4Tests.TestSubtract;
var
  A, B, C: TVector4;
begin
  A := Vector4(8, 9, 10, 11);
  C := A - 1;
  CheckEquals(7, 8, 9, 10, C);

  A := Vector4(10, 11, 12, 13);
  C := 1 - A;
  CheckEquals(-9, -10, -11, -12, C);

  A := Vector4(12, 13, 14, 15);
  B := Vector4(-1, -3, 2, 5);
  C := A - B;
  CheckEquals(13, 16, 12, 10, C);
end;

end.
