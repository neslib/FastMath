unit FastMath.TIVector3.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TIVector3Tests = class(TUnitTest)
  published
    procedure TestSize;
    procedure TestConstructors;
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

{ TIVector3Tests }

procedure TIVector3Tests.TestAdd;
var
  A, B, C: TIVector3;
begin
  A := IVector3(2, 3, 4);
  C := A + 1;
  CheckEquals(3, 4, 5, C);

  A := IVector3(4, 5, 6);
  C := 1 + A;
  CheckEquals(5, 6, 7, C);

  A := IVector3(6, 7, 8);
  B := IVector3(-1, -3, -5);
  C := A + B;
  CheckEquals(5, 4, 3, C);
end;

procedure TIVector3Tests.TestComponents;
var
  A: TIVector3;
begin
  A := IVector3(1, 2, 3);
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);
  CheckEquals(3, A[2]);

  A[2] := A[1] * 2;
  CheckEquals(1, A[0]);
  CheckEquals(2, A[1]);
  CheckEquals(4, A[2]);
end;

procedure TIVector3Tests.TestConstructors;
var
  A: TIVector3;
begin
  A := IVector3;
  CheckEquals(0, 0, 0, A);

  A := IVector3(1);
  CheckEquals(1, 1, 1, A);

  A := IVector3(2, 3, 4);
  CheckEquals(2, A.X);
  CheckEquals(3, A.Y);
  CheckEquals(4, A.Z);
  CheckEquals(2, A.R);
  CheckEquals(3, A.G);
  CheckEquals(4, A.B);
  CheckEquals(2, A.S);
  CheckEquals(3, A.T);
  CheckEquals(4, A.P);

  A.Init;
  CheckEquals(0, 0, 0, A);

  A.Init(1);
  CheckEquals(1, 1, 1, A);

  A.Init(2, 3, 4);
  CheckEquals(2, 3, 4, A);
end;

procedure TIVector3Tests.TestDivide;
var
  A, B, C: TIVector3;
begin
  A := IVector3(20, 21, 22);
  C := A div 2;
  CheckEquals(10, 10, 11, C);

  A := IVector3(4, 8, 16);
  C := 20 div A;
  CheckEquals(5, 2, 1, C);

  A := IVector3(24, 25, 27);
  B := IVector3(-3, -5, -3);
  C := A div B;
  CheckEquals(-8, -5, -9, C);
end;

procedure TIVector3Tests.TestEquality;
var
  A, B: TIVector3;
begin
  A := IVector3(1);
  B := IVector3(1);
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := IVector3(2, 3, 4);
  B := IVector3(3, 3, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := IVector3(2, 3, 4);
  B := IVector3(2, 4, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := IVector3(2, 3, 4);
  B := IVector3(2, 3, 5);
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TIVector3Tests.TestIsZero;
begin
  CheckTrue(IVector3(0, 0, 0).IsZero);
  CheckFalse(IVector3(1, 0, 0).IsZero);
  CheckFalse(IVector3(0, 1, 0).IsZero);
  CheckFalse(IVector3(0, 0, 1).IsZero);
end;

procedure TIVector3Tests.TestMultiply;
var
  A, B, C: TIVector3;
begin
  A := IVector3(14, 15, 16);
  C := A * 2;
  CheckEquals(28, 30, 32, C);

  A := IVector3(16, 17, 18);
  C := 2 * A;
  CheckEquals(32, 34, 36, C);

  A := IVector3(18, 19, 20);
  B := IVector3(-1, -3, -2);
  C := A * B;
  CheckEquals(-18, -57, -40, C);
end;

procedure TIVector3Tests.TestNegative;
var
  A, B: TIVector3;
begin
  A := IVector3(26, 27, -28);
  B := -A;
  CheckEquals(-26, -27, 28, B);
end;

procedure TIVector3Tests.TestSize;
begin
  CheckEquals(12, SizeOf(TIVector3));
end;

procedure TIVector3Tests.TestSubtract;
var
  A, B, C: TIVector3;
begin
  A := IVector3(8, 9, 10);
  C := A - 1;
  CheckEquals(7, 8, 9, C);

  A := IVector3(10, 11, 12);
  C := 1 - A;
  CheckEquals(-9, -10, -11, C);

  A := IVector3(12, 13, 14);
  B := IVector3(-1, -3, 2);
  C := A - B;
  CheckEquals(13, 16, 12, C);
end;

end.
