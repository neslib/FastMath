unit FastMath.TIVector2.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TIVector2Tests = class(TUnitTest)
  published
    procedure TestSize;
    procedure TestConstructors;
    procedure TestImplicit;
    procedure TestComponents;
    procedure TestEquality;
    procedure TestAdd;
    procedure TestSubtract;
    procedure TestMultiply;
    procedure TestDivide;
    procedure TestNegative;
    procedure TestIsZero;
  end;

implementation

uses
  System.Math,
  System.Types;

{ TIVector2Tests }

procedure TIVector2Tests.TestAdd;
var
  A, B, C: TIVector2;
begin
  A := IVector2(2, 3);
  C := A + 1;
  CheckEquals(3, 4, C);

  A := IVector2(4, 5);
  C := 1 + A;
  CheckEquals(5, 6, C);

  A := IVector2(6, 7);
  B := IVector2(-1, -3);
  C := A + B;
  CheckEquals(5, 4, C);
end;

procedure TIVector2Tests.TestComponents;
var
  A: TIVector2;
begin
  A := IVector2(1, 2);
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);

  A[0] := A[1] * 2;
  CheckEquals(4, A[0]);
  CheckEquals(2, A[1]);
end;

procedure TIVector2Tests.TestConstructors;
var
  A: TIVector2;
begin
  A := IVector2;
  CheckEquals(0, 0, A);

  A := IVector2(1);
  CheckEquals(1, 1, A);

  A := IVector2(2, 3);
  CheckEquals(2, A.X);
  CheckEquals(3, A.Y);
  CheckEquals(2, A.R);
  CheckEquals(3, A.G);
  CheckEquals(2, A.S);
  CheckEquals(3, A.T);

  A.Init;
  CheckEquals(0, 0, A);

  A.Init(1);
  CheckEquals(1, 1, A);

  A.Init(2, 3);
  CheckEquals(2, 3, A);
end;

procedure TIVector2Tests.TestDivide;
var
  A, B, C: TIVector2;
begin
  A := IVector2(20, 21);
  C := A div 2;
  CheckEquals(10, 10, C);

  A := IVector2(4, 8);
  C := 10 div A;
  CheckEquals(2, 1, C);

  A := IVector2(24, 25);
  B := IVector2(-3, -5);
  C := A div B;
  CheckEquals(-8, -5, C);
end;

procedure TIVector2Tests.TestEquality;
var
  A, B: TIVector2;
begin
  A := IVector2(1);
  B := IVector2(1);
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := IVector2(2, 3);
  B := IVector2(3, 3);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := IVector2(2, 3);
  B := IVector2(2, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TIVector2Tests.TestImplicit;
var
  V: TIVector2;
  P: TPoint;
begin
  V.Init(1, 2);
  P := V;
  CheckEquals(1, P.X);
  CheckEquals(2, P.Y);

  P := Point(3, 4);
  V := P;
  CheckEquals(3, 4, V);
end;

procedure TIVector2Tests.TestIsZero;
begin
  CheckTrue(IVector2(0, 0).IsZero);
  CheckFalse(IVector2(1, 0).IsZero);
  CheckFalse(IVector2(0, 1).IsZero);
end;

procedure TIVector2Tests.TestMultiply;
var
  A, B, C: TIVector2;
begin
  A := IVector2(14, 15);
  C := A * 2;
  CheckEquals(28, 30, C);

  A := IVector2(16, 17);
  C := 2 * A;
  CheckEquals(32, 34, C);

  A := IVector2(18, 19);
  B := IVector2(-1, -3);
  C := A * B;
  CheckEquals(-18, -57, C);
end;

procedure TIVector2Tests.TestNegative;
var
  A, B: TIVector2;
begin
  A := IVector2(26, 27);
  B := -A;
  CheckEquals(-26, -27, B);
end;

procedure TIVector2Tests.TestSize;
begin
  CheckEquals(8, SizeOf(TIVector2));
end;

procedure TIVector2Tests.TestSubtract;
var
  A, B, C: TIVector2;
begin
  A := IVector2(8, 9);
  C := A - 1;
  CheckEquals(7, 8, C);

  A := IVector2(10, 11);
  C := 1 - A;
  CheckEquals(-9, -10, C);

  A := IVector2(12, 13);
  B := IVector2(-1, -3);
  C := A - B;
  CheckEquals(13, 16, C);
end;

end.
