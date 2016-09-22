unit FastMath.TIVector4.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TIVector4Tests = class(TUnitTest)
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

{ TIVector4Tests }

procedure TIVector4Tests.TestAdd;
var
  A, B, C: TIVector4;
begin
  A := IVector4(2, 3, 4, 5);
  C := A + 1;
  CheckEquals(3, 4, 5, 6, C);

  A := IVector4(4, 5, 6, 7);
  C := 1 + A;
  CheckEquals(5, 6, 7, 8, C);

  A := IVector4(6, 7, 8, 9);
  B := IVector4(-1, -3, -5, -7);
  C := A + B;
  CheckEquals(5, 4, 3, 2, C);
end;

procedure TIVector4Tests.TestComponents;
var
  A: TIVector4;
begin
  A := IVector4(1, 2, 3, 4);
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

procedure TIVector4Tests.TestConstructors;
var
  A: TIVector4;
begin
  A := IVector4;
  CheckEquals(0, 0, 0, 0, A);

  A := IVector4(1);
  CheckEquals(1, 1, 1, 1, A);

  A := IVector4(2, 3, 4, 5);
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

  A.Init;
  CheckEquals(0, 0, 0, 0, A);

  A.Init(1);
  CheckEquals(1, 1, 1, 1, A);

  A.Init(2, 3, 4, 5);
  CheckEquals(2, 3, 4, 5, A);
end;

procedure TIVector4Tests.TestDivide;
var
  A, B, C: TIVector4;
begin
  A := IVector4(20, 21, 22, 23);
  C := A div 2;
  CheckEquals(10, 10, 11, 11, C);

  A := IVector4(4, 8, 16, 32);
  C := 20 div A;
  CheckEquals(5, 2, 1, 0, C);

  A := IVector4(24, 25, 27, 28);
  B := IVector4(-3, -5, -3, -4);
  C := A div B;
  CheckEquals(-8, -5, -9, -7, C);
end;

procedure TIVector4Tests.TestEquality;
var
  A, B: TIVector4;
begin
  A := IVector4(1);
  B := IVector4(1);
  CheckTrue(A = B);
  CheckFalse(A <> B);

  A := IVector4(1, 2, 3, 4);
  B := IVector4(2, 2, 3, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := IVector4(1, 2, 3, 4);
  B := IVector4(1, 3, 3, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := IVector4(1, 2, 3, 4);
  B := IVector4(1, 2, 4, 4);
  CheckFalse(A = B);
  CheckTrue(A <> B);

  A := IVector4(1, 2, 3, 4);
  B := IVector4(1, 2, 3, 5);
  CheckFalse(A = B);
  CheckTrue(A <> B);
end;

procedure TIVector4Tests.TestIsZero;
begin
  CheckTrue(IVector4(0, 0, 0, 0).IsZero);
  CheckFalse(IVector4(1, 0, 0, 0).IsZero);
  CheckFalse(IVector4(0, 1, 0, 0).IsZero);
  CheckFalse(IVector4(0, 0, 1, 0).IsZero);
  CheckFalse(IVector4(0, 0, 0, 1).IsZero);
end;

procedure TIVector4Tests.TestMultiply;
var
  A, B, C: TIVector4;
begin
  A := IVector4(14, 15, 16, 17);
  C := A * 2;
  CheckEquals(28, 30, 32, 34, C);

  A := IVector4(16, 17, 18, 19);
  C := 2 * A;
  CheckEquals(32, 34, 36, 38, C);

  A := IVector4(18, 19, 20, 21);
  B := IVector4(-1, -3, -2, -4);
  C := A * B;
  CheckEquals(-18, -57, -40, -84, C);
end;

procedure TIVector4Tests.TestNegative;
var
  A, B: TIVector4;
begin
  A := IVector4(26, 27, -28, -29);
  B := -A;
  CheckEquals(-26, -27, 28, 29, B);
end;

procedure TIVector4Tests.TestSize;
begin
  CheckEquals(16, SizeOf(TIVector4));
end;

procedure TIVector4Tests.TestSubtract;
var
  A, B, C: TIVector4;
begin
  A := IVector4(8, 9, 10, 11);
  C := A - 1;
  CheckEquals(7, 8, 9, 10, C);

  A := IVector4(10, 11, 12, 13);
  C := 1 - A;
  CheckEquals(-9, -10, -11, -12, C);

  A := IVector4(12, 13, 14, 15);
  B := IVector4(-1, -3, 2, 5);
  C := A - B;
  CheckEquals(13, 16, 12, 10, C);
end;

end.
