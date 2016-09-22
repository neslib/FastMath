unit FastMath.TVector2.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TVector2Tests = class(TUnitTest)
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
    procedure TestRotate;
    procedure TestRotate90CCW;
    procedure TestRotate90CW;
    procedure TestSetRotated;
    procedure TestSetRotated90CCW;
    procedure TestSetRotated90CC;
    procedure TestAngle;
    procedure TestAngleTo;
    procedure TestLerp;
    procedure TestSetLerp;
  end;

implementation

uses
  System.Math,
  System.Types;

{ TVector2Tests }

procedure TVector2Tests.TestAdd;
var
  A, B, C: TVector2;
begin
  A := Vector2(2, 3);
  C := A + 1;
  CheckEquals(3, 4, C);

  A := Vector2(4, 5);
  C := 1 + A;
  CheckEquals(5, 6, C);

  A := Vector2(6, 7);
  B := Vector2(-1, -3);
  C := A + B;
  CheckEquals(5, 4, C);
end;

procedure TVector2Tests.TestAngle;
var
  V: TVector2;
begin
  V := Vector2(10, 0);
  CheckEquals(Radians(0), V.Angle);

  V := Vector2(10, 10);
  CheckEquals(Radians(45), V.Angle);

  V := Vector2(0, 10);
  CheckEquals(Radians(90), V.Angle);

  V := Vector2(-10, 10);
  CheckEquals(Radians(135), V.Angle);

  V := Vector2(-10, 0);
  CheckEquals(Radians(180), V.Angle);

  V := Vector2(-10, -10);
  CheckEquals(Radians(-135), V.Angle);

  V := Vector2(0, -10);
  CheckEquals(Radians(-90), V.Angle);

  V := Vector2(10, -10);
  CheckEquals(Radians(-45), V.Angle);

  V := Vector2(3, 4);
  V.Angle := 0;
  CheckEquals(5, 0, V);

  V := Vector2(3, 4);
  V.Angle := Radians(90);
  CheckEquals(0, 5, V);

  V := Vector2(3, 4);
  V.Angle := Radians(180);
  CheckEquals(-5, 0, V);

  V := Vector2(3, 4);
  V.Angle := Radians(270);
  CheckEquals(0, -5, V);
end;

procedure TVector2Tests.TestAngleTo;
var
  Src, Target: TVector2;
begin
  Src := Vector2(10, 0);
  Target := Vector2(5, 5);
  CheckEquals(Radians(45), Src.AngleTo(Target));

  Src := Vector2(-10, 10);
  Target := Vector2(0, 5);
  CheckEquals(Radians(-45), Src.AngleTo(Target));
end;

procedure TVector2Tests.TestClamp;
var
  V: TVector2;
begin
  V := Vector2(-3, 4).Clamp(4, 6);
  CheckEquals(-3, 4, V);

  V := Vector2(-6, 8).Clamp(4, 5);
  CheckEquals(-3, 4, V);

  V := Vector2(-1.5, 2).Clamp(5, 6);
  CheckEquals(-3, 4, V);
end;

procedure TVector2Tests.TestComponents;
var
  A: TVector2;
begin
  A := Vector2(1, 2);
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);

  A[0] := A[1] * 2;
  CheckEquals(4, A[0]);
  CheckEquals(2, A[1]);
end;

procedure TVector2Tests.TestConstants;
begin
  CheckEquals(0, 0, TVector2.Zero);
  CheckEquals(1, 1, TVector2.One);
  CheckEquals(1, 0, TVector2.UnitX);
  CheckEquals(0, 1, TVector2.UnitY);
end;

procedure TVector2Tests.TestConstructors;
var
  A: TVector2;
  B: TVector3;
  C: TVector4;
begin
  A := Vector2;
  CheckEquals(0, 0, A);

  A := Vector2(1);
  CheckEquals(1, 1, A);

  A := Vector2(2, 3);
  CheckEquals(2, A.X);
  CheckEquals(3, A.Y);
  CheckEquals(2, A.R);
  CheckEquals(3, A.G);
  CheckEquals(2, A.S);
  CheckEquals(3, A.T);

  B := Vector3(4, 5, 6);
  A := Vector2(B);
  CheckEquals(4, 5, A);

  C := Vector4(7, 8, 9, 10);
  A := Vector2(C);
  CheckEquals(7, 8, A);

  A.Init;
  CheckEquals(0, 0, A);

  A.Init(1);
  CheckEquals(1, 1, A);

  A.Init(2, 3);
  CheckEquals(2, A.X);
  CheckEquals(3, A.Y);

  A.Init(2, 3);
  CheckEquals(2, 3, A);

  A.Init(Point(6, 7));
  CheckEquals(6, 7, A);
end;

procedure TVector2Tests.TestCross;
begin
  CheckEquals(-2, Vector2(2, 3).Cross(Vector2(4, 5)));
end;

procedure TVector2Tests.TestDistance;
begin
  CheckEquals(5, Vector2(1, 2).Distance(Vector2(4, 6)));
end;

procedure TVector2Tests.TestDistanceSquared;
begin
  CheckEquals(25, Vector2(1, 2).DistanceSquared(Vector2(4, 6)));
end;

procedure TVector2Tests.TestDivide;
var
  A, B, C: TVector2;
begin
  A := Vector2(20, 21);
  C := A / 2;
  CheckEquals(10, 10.5, C);

  A := Vector2(4, 8);
  C := 2 / A;
  CheckEquals(0.5, 0.25, C);

  A := Vector2(24, 25);
  B := Vector2(-3, -5);
  C := A / B;
  CheckEquals(-8, -5, C);
end;

procedure TVector2Tests.TestDot;
begin
  CheckEquals(22, Vector2(2, 3).Dot(Vector2(5, 4)));
end;

procedure TVector2Tests.TestEquality;
var
  A, B: TVector2;
begin
  A := Vector2(1);
  B := Vector2(1);
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := Vector2(2, 3);
  B := Vector2(3, 3);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := Vector2(2, 3);
  B := Vector2(2, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TVector2Tests.TestEquals;
begin
  CheckTrue(Vector2(1, 1).Equals(Vector2(1, 1)));
  CheckTrue(Vector2(-1, 1).Equals(Vector2(-1, 1)));
  CheckFalse(Vector2(1, -1).Equals(Vector2(1, -1.0001)));
  CheckTrue(Vector2(1, -1).Equals(Vector2(1, -1.0001), 0.0002));
end;

procedure TVector2Tests.TestFaceForward;
var
  V: TVector2;
begin
  V := Vector2(1, -2).FaceForward(Vector2(2, -3), Vector2(4, 5));
  CheckEquals(1, -2, V);
end;

procedure TVector2Tests.TestHasOppositeDirection;
begin
  CheckTrue(Vector2(1, 1).HasOppositeDirection(Vector2(-2, -2)));
  CheckTrue(Vector2(1, 1).HasOppositeDirection(Vector2(-1.1, 1)));
  CheckTrue(Vector2(1, 1).HasOppositeDirection(Vector2(1, -1.1)));

  CheckFalse(Vector2(1, 1).HasOppositeDirection(Vector2(-1, 1)));
  CheckFalse(Vector2(1, 1).HasOppositeDirection(Vector2(1, -1)));
  CheckTrue(Vector2(1, 1).HasOppositeDirection(Vector2(-1, -1)));
end;

procedure TVector2Tests.TestHasSameDirection;
begin
  CheckTrue(Vector2(1, 1).HasSameDirection(Vector2(2, 2)));
  CheckTrue(Vector2(1, 1).HasSameDirection(Vector2(-0.9, 1)));
  CheckTrue(Vector2(1, 1).HasSameDirection(Vector2(1, -0.9)));

  CheckFalse(Vector2(1, 1).HasSameDirection(Vector2(-1, 1)));
  CheckFalse(Vector2(1, 1).HasSameDirection(Vector2(1, -1)));
  CheckFalse(Vector2(1, 1).HasSameDirection(Vector2(-1, -1)));
end;

procedure TVector2Tests.TestImplicit;
var
  V: TVector2;
  P: TPointF;
begin
  V.Init(1, 2);
  P := V;
  CheckEquals(1, P.X);
  CheckEquals(2, P.Y);

  P := PointF(3, 4);
  V := P;
  CheckEquals(3, 4, V);
end;

procedure TVector2Tests.TestIsCollinear;
begin
  CheckTrue(Vector2(1, 1).IsCollinear(Vector2(1, 1)));
  CheckTrue(Vector2(1, 1).IsCollinear(Vector2(2, 2)));
  CheckFalse(Vector2(1, 1).IsCollinear(Vector2(-1, -1)));
  CheckFalse(Vector2(1, 1).IsCollinear(Vector2(-3, -3)));
  CheckFalse(Vector2(1, 1).IsCollinear(Vector2(1, -1)));
end;

procedure TVector2Tests.TestIsCollinearOpposite;
begin
  CheckFalse(Vector2(1, 1).IsCollinearOpposite(Vector2(1, 1)));
  CheckFalse(Vector2(1, 1).IsCollinearOpposite(Vector2(2, 2)));
  CheckTrue(Vector2(1, 1).IsCollinearOpposite(Vector2(-1, -1)));
  CheckTrue(Vector2(1, 1).IsCollinearOpposite(Vector2(-3, -3)));
  CheckFalse(Vector2(1, 1).IsCollinearOpposite(Vector2(1, -1)));
end;

procedure TVector2Tests.TestIsNormalized;
begin
  CheckTrue(Vector2(1, 0).IsNormalized);
  CheckTrue(Vector2(0, 1).IsNormalized);
  CheckFalse(Vector2(1, 1).IsNormalized);
  CheckFalse(Vector2(0.7071, 0.7071).IsNormalized);

  CheckFalse(Vector2(1, 1).IsNormalized(0.1));
  CheckTrue(Vector2(0.7071, 0.7071).IsNormalized(0.0001));
end;

procedure TVector2Tests.TestIsParallel;
begin
  CheckTrue(Vector2(1, 1).IsParallel(Vector2(1, 1)));
  CheckTrue(Vector2(1, 1).IsParallel(Vector2(2, 2)));
  CheckTrue(Vector2(1, 1).IsParallel(Vector2(-1, -1)));
  CheckTrue(Vector2(1, 1).IsParallel(Vector2(-3, -3)));
  CheckFalse(Vector2(1, 1).IsParallel(Vector2(1, -1)));

  CheckTrue(Vector2(0, 0).IsParallel(Vector2(0, 0)));
  CheckTrue(Vector2(1, 1).IsParallel(Vector2(0, 0)));
end;

procedure TVector2Tests.TestIsPerpendicular;
begin
  CheckFalse(Vector2(1, 1).IsPerpendicular(Vector2(1, 1)));
  CheckFalse(Vector2(1, 1).IsPerpendicular(Vector2(2, 2)));
  CheckFalse(Vector2(1, 1).IsPerpendicular(Vector2(-1, -1)));
  CheckFalse(Vector2(1, 1).IsPerpendicular(Vector2(-3, -3)));

  CheckTrue(Vector2(1, 1).IsPerpendicular(Vector2(1, -1)));
  CheckTrue(Vector2(1, 1).IsPerpendicular(Vector2(-2, 2)));
end;

procedure TVector2Tests.TestIsZero;
begin
  CheckTrue(Vector2(0, 0).IsZero);
  CheckFalse(Vector2(1, 0).IsZero);
  CheckFalse(Vector2(0, 1).IsZero);
  CheckFalse(Vector2(0.0001, 0.0001).IsZero);

  CheckFalse(Vector2(1, 0).IsZero(0.1));
  CheckTrue(Vector2(0.0001, 0.0001).IsZero(0.0000001));
end;

procedure TVector2Tests.TestLength;
var
  V: TVector2;
begin
  CheckEquals(0, Vector2(0, 0).Length);
  CheckEquals(1, Vector2(1, 0).Length);
  CheckEquals(1, Vector2(0, -1).Length);
  CheckEquals(5, Vector2(-3, -4).Length);

  V := Vector2(0, 0);
  V.Length := 5;
  CheckEquals(0, 0, V);

  V := Vector2(3, -4);
  V.Length := 10;
  CheckEquals(6, -8, V);

  V.Length := 10;
  CheckEquals(6, -8, V);
end;

procedure TVector2Tests.TestLengthSquared;
var
  V: TVector2;
begin
  CheckEquals(0, Vector2(0, 0).LengthSquared);
  CheckEquals(1, Vector2(1, 0).LengthSquared);
  CheckEquals(1, Vector2(0, -1).LengthSquared);
  CheckEquals(25, Vector2(-3, -4).LengthSquared);

  V := Vector2(0, 0);
  V.LengthSquared := 5;
  CheckEquals(0, 0, V);

  V := Vector2(3, -4);
  V.LengthSquared := 100;
  CheckEquals(6, -8, V);

  V.LengthSquared := 100;
  CheckEquals(6, -8, V);
end;

procedure TVector2Tests.TestLerp;
var
  Src, Target, V: TVector2;
begin
  Src := Vector2(1, 2);
  Target := Vector2(3, 6);
  V := Src.Lerp(Target, 0.25);
  CheckEquals(1.5, 3, V);
end;

procedure TVector2Tests.TestLimit;
var
  V: TVector2;
begin
  V := Vector2(-6, 8).Limit(5);
  CheckEquals(-3, 4, V);

  V := V.Limit(6);
  CheckEquals(-3, 4, V);
end;

procedure TVector2Tests.TestLimitSquared;
var
  V: TVector2;
begin
  V := Vector2(-6, 8).LimitSquared(25);
  CheckEquals(-3, 4, V);

  V := V.LimitSquared(26);
  CheckEquals(-3, 4, V);
end;

procedure TVector2Tests.TestSetClamped;
var
  V: TVector2;
begin
  V := Vector2(-3, 4);
  V.SetClamped(4, 6);
  CheckEquals(-3, 4, V);

  V := Vector2(-6, 8);
  V.SetClamped(4, 5);
  CheckEquals(-3, 4, V);

  V := Vector2(-1.5, 2);
  V.SetClamped(5, 6);
  CheckEquals(-3, 4, V);
end;

procedure TVector2Tests.TestSetLerp;
var
  Target, V: TVector2;
begin
  V := Vector2(1, 2);
  Target := Vector2(3, 6);
  V.SetLerp(Target, 0.25);
  CheckEquals(1.5, 3, V);
end;

procedure TVector2Tests.TestSetLimit;
var
  V: TVector2;
begin
  V := Vector2(-6, 8);
  V.SetLimit(5);
  CheckEquals(-3, 4, V);

  V.SetLimit(6);
  CheckEquals(-3, 4, V);
end;

procedure TVector2Tests.TestSetLimitSquared;
var
  V: TVector2;
begin
  V := Vector2(-6, 8);
  V.SetLimitSquared(25);
  CheckEquals(-3, 4, V);

  V.SetLimitSquared(26);
  CheckEquals(-3, 4, V);
end;

procedure TVector2Tests.TestMultiply;
var
  A, B, C: TVector2;
begin
  A := Vector2(14, 15);
  C := A * 2;
  CheckEquals(28, 30, C);

  A := Vector2(16, 17);
  C := 2 * A;
  CheckEquals(32, 34, C);

  A := Vector2(18, 19);
  B := Vector2(-1, -3);
  C := A * B;
  CheckEquals(-18, -57, C);
end;

procedure TVector2Tests.TestNegative;
var
  A, B: TVector2;
begin
  A := Vector2(26, 27);
  B := -A;
  CheckEquals(-26, -27, B);
end;

procedure TVector2Tests.TestNormalize;
begin
  CheckEquals(0, 1, Vector2(0, 0.1).Normalize);
  CheckEquals(0, -1, Vector2(0, -2.3).Normalize);

  CheckEquals(1, 0, Vector2(0.1, 0).Normalize);
  CheckEquals(-1, 0, Vector2(-2.3, 0).Normalize);

  CheckEquals(0.6, 0.8, Vector2(3, 4).Normalize);
  CheckEquals(-0.6, 0.8, Vector2(-3, 4).Normalize);
  CheckEquals(0.6, -0.8, Vector2(3, -4).Normalize);
  CheckEquals(-0.6, -0.8, Vector2(-3, -4).Normalize);
end;

procedure TVector2Tests.TestNormalizeFast;
begin
  CheckEquals(0, 1, Vector2(0, 0.1).NormalizeFast);
  CheckEquals(0, -1, Vector2(0, -2.3).NormalizeFast);

  CheckEquals(1, 0, Vector2(0.1, 0).NormalizeFast);
  CheckEquals(-1, 0, Vector2(-2.3, 0).NormalizeFast);

  CheckEquals(0.6, 0.8, Vector2(3, 4).NormalizeFast);
  CheckEquals(-0.6, 0.8, Vector2(-3, 4).NormalizeFast);
  CheckEquals(0.6, -0.8, Vector2(3, -4).NormalizeFast);
  CheckEquals(-0.6, -0.8, Vector2(-3, -4).NormalizeFast);
end;

procedure TVector2Tests.TestOffset;
var
  A: TVector2;
begin
  A.Init(1, 2);
  A.Offset(3, 4);
  CheckEquals(4, 6, A);
  A.Offset(Vector2(2, 1));
  CheckEquals(6, 7, A);
end;

procedure TVector2Tests.TestReflect;
var
  V: TVector2;
begin
  V := Vector2(1, -1).Reflect(Vector2(0, 1));
  CheckEquals(1, 1, V);
end;

procedure TVector2Tests.TestRefract;
var
  V: TVector2;
begin
  V := Vector2(0, -1).Refract(Vector2(-2, 3), 0.3);
  CheckEquals(0.82297, -1.53446, V);

  V := Vector2(0, -1).Refract(Vector2(1, 0), 4);
  CheckEquals(0, 0, V);
end;

procedure TVector2Tests.TestRotate;
var
  V: TVector2;
begin
  V := Vector2(2, 1).Rotate(Radians(90));
  CheckEquals(-1, 2, V);

  V := V.Rotate(Radians(90));
  CheckEquals(-2, -1, V);

  V := V.Rotate(Radians(90));
  CheckEquals(1, -2, V);

  V := V.Rotate(Radians(90));
  CheckEquals(2, 1, V);
end;

procedure TVector2Tests.TestRotate90CCW;
var
  V: TVector2;
begin
  V := Vector2(1, 2).Rotate90CCW;
  CheckEquals(-2, 1, V);
end;

procedure TVector2Tests.TestRotate90CW;
var
  V: TVector2;
begin
  V := Vector2(1, 2).Rotate90CW;
  CheckEquals(2, -1, V);
end;

procedure TVector2Tests.TestSetNormalized;
var
  V: TVector2;
begin
  V := Vector2(-3, 4);
  V.SetNormalized;
  CheckEquals(-0.6, 0.8, V);
end;

procedure TVector2Tests.TestSetNormalizedFast;
var
  V: TVector2;
begin
  V := Vector2(-3, 4);
  V.SetNormalizedFast;
  CheckEquals(-0.6, 0.8, V);
end;

procedure TVector2Tests.TestSetRotated;
var
  V: TVector2;
begin
  V := Vector2(2, 1);
  V.SetRotated(Radians(90));
  CheckEquals(-1, 2, V);

  V.SetRotated(Radians(90));
  CheckEquals(-2, -1, V);

  V.SetRotated(Radians(90));
  CheckEquals(1, -2, V);

  V.SetRotated(Radians(90));
  CheckEquals(2, 1, V);
end;

procedure TVector2Tests.TestSetRotated90CC;
var
  V: TVector2;
begin
  V := Vector2(1, 2);
  V.SetRotated90CW;
  CheckEquals(2, -1, V);
end;

procedure TVector2Tests.TestSetRotated90CCW;
var
  V: TVector2;
begin
  V := Vector2(1, 2);
  V.SetRotated90CCW;
  CheckEquals(-2, 1, V);
end;

procedure TVector2Tests.TestSize;
begin
  CheckEquals(8, SizeOf(TVector2));
end;

procedure TVector2Tests.TestSubtract;
var
  A, B, C: TVector2;
begin
  A := Vector2(8, 9);
  C := A - 1;
  CheckEquals(7, 8, C);

  A := Vector2(10, 11);
  C := 1 - A;
  CheckEquals(-9, -10, C);

  A := Vector2(12, 13);
  B := Vector2(-1, -3);
  C := A - B;
  CheckEquals(13, 16, C);
end;

end.
