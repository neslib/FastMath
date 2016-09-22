unit FastMath.TVector3.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TVector3Tests = class(TUnitTest)
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
    procedure TestCross;
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

{ TVector3Tests }

procedure TVector3Tests.TestAdd;
var
  A, B, C: TVector3;
begin
  A := Vector3(2, 3, 4);
  C := A + 1;
  CheckEquals(3, 4, 5, C);

  A := Vector3(4, 5, 6);
  C := 1 + A;
  CheckEquals(5, 6, 7, C);

  A := Vector3(6, 7, 8);
  B := Vector3(-1, -3, -5);
  C := A + B;
  CheckEquals(5, 4, 3, C);
end;

procedure TVector3Tests.TestClamp;
var
  V: TVector3;
begin
  V := Vector3(2, -3, 4).Clamp(5, 6);
  CheckEquals(2, -3, 4, V);

  V := Vector3(4, -6, 8).Clamp(5, 5.38516);
  CheckEquals(2, -3, 4, V);

  V := Vector3(1, -1.5, 2).Clamp(5.38516, 6);
  CheckEquals(2, -3, 4, V);
end;

procedure TVector3Tests.TestComponents;
var
  A: TVector3;
begin
  A := Vector3(1, 2, 3);
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);
  CheckEquals(3, A[2]);

  A[2] := A[1] * 2;
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);
  CheckEquals(4, A[2]);
end;

procedure TVector3Tests.TestConstants;
begin
  CheckEquals(0, 0, 0, TVector3.Zero);
  CheckEquals(1, 1, 1, TVector3.One);
  CheckEquals(1, 0, 0, TVector3.UnitX);
  CheckEquals(0, 1, 0, TVector3.UnitY);
  CheckEquals(0, 0, 1, TVector3.UnitZ);
end;

procedure TVector3Tests.TestConstructors;
var
  A: TVector3;
  B: TVector2;
  C: TVector4;
begin
  A := Vector3;
  CheckEquals(0, 0, 0, A);

  A := Vector3(1);
  CheckEquals(1, 1, 1, A);

  A := Vector3(2, 3, 4);
  CheckEquals(2, A.X);
  CheckEquals(3, A.Y);
  CheckEquals(4, A.Z);
  CheckEquals(2, A.R);
  CheckEquals(3, A.G);
  CheckEquals(4, A.B);
  CheckEquals(2, A.S);
  CheckEquals(3, A.T);
  CheckEquals(4, A.P);

  B := Vector2(4, 5);
  A := Vector3(B, 1);
  CheckEquals(4, 5, 1, A);

  A := Vector3(1, B);
  CheckEquals(1, 4, 5, A);

  C := Vector4(7, 8, 9, 10);
  A := Vector3(C);
  CheckEquals(7, 8, 9, A);

  A.Init;
  CheckEquals(0, 0, 0, A);

  A.Init(1);
  CheckEquals(1, 1, 1, A);

  A.Init(2, 3, 4);
  CheckEquals(2, 3, 4, A);
end;

procedure TVector3Tests.TestCross;
var
  A, B, C: TVector3;
begin
  A := Vector3( 1, -2, 3);
  B := Vector3(-4, -5, 6);
  C := A.Cross(B);

  CheckEquals(  3, C.X);
  CheckEquals(-18, C.Y);
  CheckEquals(-13, C.Z);
end;

procedure TVector3Tests.TestDistance;
begin
  CheckEquals(5.38516, Vector3(1, 2, 3).Distance(Vector3(3, 5, 7)));
end;

procedure TVector3Tests.TestDistanceSquared;
begin
  CheckEquals(29, Vector3(1, 2, 3).DistanceSquared(Vector3(3, 5, 7)));
end;

procedure TVector3Tests.TestDivide;
var
  A, B, C: TVector3;
begin
  A := Vector3(20, 21, 22);
  C := A / 2;
  CheckEquals(10, 10.5, 11, C);

  A := Vector3(4, 8, 16);
  C := 2 / A;
  CheckEquals(0.5, 0.25, 0.125, C);

  A := Vector3(24, 25, 27);
  B := Vector3(-3, -5, -3);
  C := A / B;
  CheckEquals(-8, -5, -9, C);
end;

procedure TVector3Tests.TestDot;
begin
  CheckEquals(52, Vector3(2, 3, 4).Dot(Vector3(7, 6, 5)));
end;

procedure TVector3Tests.TestEquality;
var
  A, B: TVector3;
begin
  A := Vector3(1);
  B := Vector3(1);
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := Vector3(2, 3, 4);
  B := Vector3(3, 3, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := Vector3(2, 3, 4);
  B := Vector3(2, 4, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := Vector3(2, 3, 4);
  B := Vector3(2, 3, 5);
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TVector3Tests.TestEquals;
begin
  CheckTrue(Vector3(1, 1, 1).Equals(Vector3(1, 1, 1)));
  CheckTrue(Vector3(-1, 1, 1).Equals(Vector3(-1, 1, 1)));
  CheckFalse(Vector3(1, -1, -1).Equals(Vector3(1, -1, -1.0001)));
  CheckTrue(Vector3(1, -1, -1).Equals(Vector3(1, -1, -1.0001), 0.0002));
end;

procedure TVector3Tests.TestFaceForward;
var
  V: TVector3;
begin
  V := Vector3(0, 0, 1).FaceForward(Vector3(1, 0, 1), Vector3(0, 0, 1));
  CheckEquals(0, 0, -1, V);
end;

procedure TVector3Tests.TestHasOppositeDirection;
begin
  CheckTrue(Vector3(1, 1, 1).HasOppositeDirection(Vector3(-2, -2, -2)));
  CheckTrue(Vector3(1, 1, 1).HasOppositeDirection(Vector3(-1, -1, 1)));
  CheckTrue(Vector3(1, 1, 1).HasOppositeDirection(Vector3(1, -1, -1)));
  CheckTrue(Vector3(1, 1, 1).HasOppositeDirection(Vector3(-1, 1, -1)));

  CheckFalse(Vector3(1, 1, 1).HasOppositeDirection(Vector3(-1, 1, 1)));
  CheckFalse(Vector3(1, 1, 1).HasOppositeDirection(Vector3(1, -1, 1)));
  CheckFalse(Vector3(1, 1, 1).HasOppositeDirection(Vector3(1, 1, -1)));
  CheckTrue(Vector3(1, 1, 1).HasOppositeDirection(Vector3(-1, -1, -1)));
end;

procedure TVector3Tests.TestHasSameDirection;
begin
  CheckTrue(Vector3(1, 1, 1).HasSameDirection(Vector3(2, 2, 2)));
  CheckTrue(Vector3(1, 1, 1).HasSameDirection(Vector3(-1, 1, 1)));
  CheckTrue(Vector3(1, 1, 1).HasSameDirection(Vector3(1, -1, 1)));
  CheckTrue(Vector3(1, 1, 1).HasSameDirection(Vector3(1, 1, -1)));

  CheckFalse(Vector3(1, 1, 1).HasSameDirection(Vector3(-1, -1, 1)));
  CheckFalse(Vector3(1, 1, 1).HasSameDirection(Vector3(1, -1, -1)));
  CheckFalse(Vector3(1, 1, 1).HasSameDirection(Vector3(-1, 1, -1)));
  CheckFalse(Vector3(1, 1, 1).HasSameDirection(Vector3(-1, -1, -1)));
end;

procedure TVector3Tests.TestImplicit;
var
  V: TVector3;
  P: TPoint3D;
begin
  V.Init(1.1, 2.2, 3.3);
  P := V;
  CheckEquals(1.1, P.X);
  CheckEquals(2.2, P.Y);
  CheckEquals(3.3, P.Z);

  P := Point3D(4, 5, 6);
  V := P;
  CheckEquals(4, 5, 6, V);
end;

procedure TVector3Tests.TestIsCollinear;
begin
  CheckTrue(Vector3(1, 1, 1).IsCollinear(Vector3(1, 1, 1)));
  CheckTrue(Vector3(1, 1, 1).IsCollinear(Vector3(2, 2, 2)));
  CheckFalse(Vector3(1, 1, 1).IsCollinear(Vector3(-1, -1, -1)));
  CheckFalse(Vector3(1, 1, 1).IsCollinear(Vector3(-3, -3, -3)));
  CheckFalse(Vector3(1, 1, 1).IsCollinear(Vector3(1, -1, 1)));
end;

procedure TVector3Tests.TestIsCollinearOpposite;
begin
  CheckFalse(Vector3(1, 1, 1).IsCollinearOpposite(Vector3(1, 1, 1)));
  CheckFalse(Vector3(1, 1, 1).IsCollinearOpposite(Vector3(2, 2, 2)));
  CheckTrue(Vector3(1, 1, 1).IsCollinearOpposite(Vector3(-1, -1, -1)));
  CheckTrue(Vector3(1, 1, 1).IsCollinearOpposite(Vector3(-3, -3, -3)));
  CheckFalse(Vector3(1, 1, 1).IsCollinearOpposite(Vector3(1, -1, 1)));
end;

procedure TVector3Tests.TestIsNormalized;
begin
  CheckTrue(Vector3(1, 0, 0).IsNormalized);
  CheckTrue(Vector3(0, 1, 0).IsNormalized);
  CheckTrue(Vector3(0, 0, 1).IsNormalized);
  CheckFalse(Vector3(1, 1, 0).IsNormalized);
  CheckFalse(Vector3(0.57735, 0.57735, 0.57735).IsNormalized);

  CheckFalse(Vector3(1, 1, 0).IsNormalized(0.1));
  CheckTrue(Vector3(0.57735, 0.57735, 0.57735).IsNormalized(0.000001));
end;

procedure TVector3Tests.TestIsParallel;
begin
  CheckTrue(Vector3(1, 1, 1).IsParallel(Vector3(1, 1, 1)));
  CheckTrue(Vector3(1, 1, 1).IsParallel(Vector3(2, 2, 2)));
  CheckTrue(Vector3(1, 1, 1).IsParallel(Vector3(-1, -1, -1)));
  CheckTrue(Vector3(1, 1, 1).IsParallel(Vector3(-3, -3, -3)));
  CheckFalse(Vector3(1, 1, 1).IsParallel(Vector3(1, -1, 1)));

  CheckTrue(Vector3(0, 0, 0).IsParallel(Vector3(0, 0, 0)));
  CheckTrue(Vector3(1, 1, 1).IsParallel(Vector3(0, 0, 0)));
end;

procedure TVector3Tests.TestIsPerpendicular;
begin
  CheckFalse(Vector3(1, 1, 1).IsPerpendicular(Vector3(1, 1, 1)));
  CheckFalse(Vector3(1, 1, 1).IsPerpendicular(Vector3(2, 2, 2)));
  CheckFalse(Vector3(1, 1, 1).IsPerpendicular(Vector3(-1, -1, -1)));
  CheckFalse(Vector3(1, 1, 1).IsPerpendicular(Vector3(-3, -3, -3)));

  CheckTrue(Vector3(1, 0, 0).IsPerpendicular(Vector3(0, 2, 0)));
  CheckTrue(Vector3(1, 0, 0).IsPerpendicular(Vector3(0, 0, 2)));
  CheckTrue(Vector3(0, 1, 0).IsPerpendicular(Vector3(1, 0, 0)));
  CheckTrue(Vector3(0, 1, 0).IsPerpendicular(Vector3(0, 0, 1)));
  CheckTrue(Vector3(0, 0, 1).IsPerpendicular(Vector3(3, 0, 0)));
  CheckTrue(Vector3(0, 0, 1).IsPerpendicular(Vector3(0, 3, 0)));
end;

procedure TVector3Tests.TestIsZero;
begin
  CheckTrue(Vector3(0, 0, 0).IsZero);
  CheckFalse(Vector3(1, 0, 0).IsZero);
  CheckFalse(Vector3(0, 1, 0).IsZero);
  CheckFalse(Vector3(0, 0, 1).IsZero);
  CheckFalse(Vector3(0.0001, 0.0001, 0.0001).IsZero);

  CheckFalse(Vector3(1, 0, 0).IsZero(0.1));
  CheckTrue(Vector3(0.0001, 0.0001, 0.0001).IsZero(0.0000001));
end;

procedure TVector3Tests.TestLength;
var
  V: TVector3;
begin
  CheckEquals(0, Vector3(0, 0, 0).Length);
  CheckEquals(1, Vector3(1, 0, 0).Length);
  CheckEquals(1, Vector3(0, -1, 0).Length);
  CheckEquals(1, Vector3(0, 0, 1).Length);
  CheckEquals(5.38516, Vector3(-2, 3, -4).Length);

  V := Vector3(0, 0, 0);
  V.Length := 5;
  CheckEquals(0, 0, 0, V);

  V := Vector3(2, 3, -4);
  V.Length := 10.77032;
  CheckEquals(4, 6, -8, V);

  V.Length := 10.77032;
  CheckEquals(4, 6, -8, V);
end;

procedure TVector3Tests.TestLengthSquared;
var
  V: TVector3;
begin
  CheckEquals(0, Vector3(0, 0, 0).LengthSquared);
  CheckEquals(1, Vector3(1, 0, 0).LengthSquared);
  CheckEquals(1, Vector3(0, -1, 0).LengthSquared);
  CheckEquals(1, Vector3(0, 0, 1).LengthSquared);
  CheckEquals(29, Vector3(-2, 3, -4).LengthSquared);

  V := Vector3(0, 0, 0);
  V.LengthSquared := 5;
  CheckEquals(0, 0, 0, V);

  V := Vector3(2, 3, -4);
  V.LengthSquared := 115.9997929024;
  CheckEquals(4, 6, -8, V);

  V.LengthSquared := 115.9997929024;
  CheckEquals(4, 6, -8, V);
end;

procedure TVector3Tests.TestLerp;
var
  Src, Target, V: TVector3;
begin
  Src := Vector3(1, 2, 3);
  Target := Vector3(3, 6, 5);
  V := Src.Lerp(Target, 0.75);
  CheckEquals(2.5, 5, 4.5, V);
end;

procedure TVector3Tests.TestLimit;
var
  V: TVector3;
begin
  V := Vector3(4, -6, 8).Limit(5.38516);
  CheckEquals(2, -3, 4, V);

  V := V.Limit(6);
  CheckEquals(2, -3, 4, V);
end;

procedure TVector3Tests.TestLimitSquared;
var
  V: TVector3;
begin
  V := Vector3(4, -6, 8).LimitSquared(29);
  CheckEquals(2, -3, 4, V);

  V := V.LimitSquared(30);
  CheckEquals(2, -3, 4, V);
end;

procedure TVector3Tests.TestSetClamped;
var
  V: TVector3;
begin
  V := Vector3(2, -3, 4);
  V.SetClamped(5, 6);
  CheckEquals(2, -3, 4, V);

  V := Vector3(4, -6, 8);
  V.SetClamped(5, 5.38516);
  CheckEquals(2, -3, 4, V);

  V := Vector3(1, -1.5, 2);
  V.SetClamped(5.38516, 6);
  CheckEquals(2, -3, 4, V);
end;

procedure TVector3Tests.TestSetLerp;
var
  Target, V: TVector3;
begin
  V := Vector3(1, 2, 3);
  Target := Vector3(3, 6, 5);
  V.SetLerp(Target, 0.75);
  CheckEquals(2.5, 5, 4.5, V);
end;

procedure TVector3Tests.TestSetLimit;
var
  V: TVector3;
begin
  V := Vector3(4, -6, 8);
  V.SetLimit(5.38516);
  CheckEquals(2, -3, 4, V);

  V.SetLimit(6);
  CheckEquals(2, -3, 4, V);
end;

procedure TVector3Tests.TestSetLimitSquared;
var
  V: TVector3;
begin
  V := Vector3(4, -6, 8);
  V.SetLimitSquared(29);
  CheckEquals(2, -3, 4, V);

  V.SetLimitSquared(30);
  CheckEquals(2, -3, 4, V);
end;

procedure TVector3Tests.TestMultiply;
var
  A, B, C: TVector3;
begin
  A := Vector3(14, 15, 16);
  C := A * 2;
  CheckEquals(28, 30, 32, C);

  A := Vector3(16, 17, 18);
  C := 2 * A;
  CheckEquals(32, 34, 36, C);

  A := Vector3(18, 19, 20);
  B := Vector3(-1, -3, -2);
  C := A * B;
  CheckEquals(-18, -57, -40, C);
end;

procedure TVector3Tests.TestNegative;
var
  A, B: TVector3;
begin
  A := Vector3(26, 27, -28);
  B := -A;
  CheckEquals(-26, -27, 28, B);
end;

procedure TVector3Tests.TestNormalize;
begin
  CheckEquals(0.37139, 0.55708, 0.74278, Vector3(2, 3, 4).Normalize);
end;

procedure TVector3Tests.TestNormalizeFast;
begin
  CheckEquals(0.37139, 0.55708, 0.74278, Vector3(2, 3, 4).NormalizeFast, 0.0002);
end;

procedure TVector3Tests.TestOffset;
var
  A: TVector3;
begin
  A.Init(1, 2, 3);
  A.Offset(3, 4, 5);
  CheckEquals(4, 6, 8, A);
  A.Offset(Vector3(2, 1, 3));
  CheckEquals(6, 7, 11, A);
end;

procedure TVector3Tests.TestReflect;
var
  V: TVector3;
begin
  V := Vector3(1, -1, 2).Reflect(Vector3(0, 1, 3));
  CheckEquals(1, -11, -28, V);
end;

procedure TVector3Tests.TestRefract;
var
  V: TVector3;
begin
  V := Vector3(0, -1, 2).Refract(Vector3(-2, 3, 4), 0.6);
  CheckEquals(12.20967, -18.91450, -23.21933, V);
end;

procedure TVector3Tests.TestSetNormalized;
var
  V: TVector3;
begin
  V := Vector3(2, 3, 4);
  V.SetNormalized;
  CheckEquals(0.37139, 0.55708, 0.74278, V);
end;

procedure TVector3Tests.TestSetNormalizedFast;
var
  V: TVector3;
begin
  V := Vector3(2, 3, 4);
  V.SetNormalizedFast;
  CheckEquals(0.37139, 0.55708, 0.74278, V, 0.0002);
end;

procedure TVector3Tests.TestSize;
begin
  CheckEquals(12, SizeOf(TVector3));
end;

procedure TVector3Tests.TestSubtract;
var
  A, B, C: TVector3;
begin
  A := Vector3(8, 9, 10);
  C := A - 1;
  CheckEquals(7, 8, 9, C);

  A := Vector3(10, 11, 12);
  C := 1 - A;
  CheckEquals(-9, -10, -11, C);

  A := Vector3(12, 13, 14);
  B := Vector3(-1, -3, 2);
  C := A - B;
  CheckEquals(13, 16, 12, C);
end;

end.
