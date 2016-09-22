unit FastMath.ExponentialFunctions.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TExponentialFunctionsTests = class(TUnitTest)
  published
    procedure TestPower;
    procedure TestExp;
    procedure TestLn;
    procedure TestExp2;
    procedure TestLog2;
    procedure TestSqrt;
    procedure TestInverseSqrt;
    procedure TestFastExp;
    procedure TestFastLn;
    procedure TestFastLog2;
    procedure TestFastExp2;
    procedure TestFastPower;
  end;

implementation

uses
  System.Math;

{ TExponentialFunctionsTests }

procedure TExponentialFunctionsTests.TestExp;
begin
  TestT(-1, 0.36788, Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT( 0, 1.00000, Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT( 1, 2.71828, Neslib.FastMath.Exp, Exp, Exp, Exp);

  TestT( SMALL_VALUE, System.Exp( SMALL_VALUE), Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT(-SMALL_VALUE, System.Exp(-SMALL_VALUE), Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT( MEDIUM_VALUE, System.Exp( MEDIUM_VALUE), Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT(-MEDIUM_VALUE, System.Exp(-MEDIUM_VALUE), Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT( LARGE_VALUE, System.Exp( LARGE_VALUE), Neslib.FastMath.Exp, Exp, Exp, Exp);
  TestT(-LARGE_VALUE, System.Exp(-LARGE_VALUE), Neslib.FastMath.Exp, Exp, Exp, Exp);
end;

procedure TExponentialFunctionsTests.TestExp2;
begin
  TestT(-1, 0.5, Exp2, Exp2, Exp2, Exp2);
  TestT( 0, 1.0, Exp2, Exp2, Exp2, Exp2);
  TestT( 1, 2.0, Exp2, Exp2, Exp2, Exp2);

  TestT( SMALL_VALUE, System.Math.Power(2,  SMALL_VALUE), Exp2, Exp2, Exp2, Exp2);
  TestT(-SMALL_VALUE, System.Math.Power(2, -SMALL_VALUE), Exp2, Exp2, Exp2, Exp2);
  TestT( MEDIUM_VALUE, System.Math.Power(2,  MEDIUM_VALUE), Exp2, Exp2, Exp2, Exp2);
  TestT(-MEDIUM_VALUE, System.Math.Power(2, -MEDIUM_VALUE), Exp2, Exp2, Exp2, Exp2);
  TestT( LARGE_VALUE, System.Math.Power(2,  LARGE_VALUE), Exp2, Exp2, Exp2, Exp2);
  TestT(-LARGE_VALUE, System.Math.Power(2, -LARGE_VALUE), Exp2, Exp2, Exp2, Exp2);
end;

procedure TExponentialFunctionsTests.TestFastExp;
var
  I: Integer;
  Val, Expected: Single;
begin
  for I := -100 to 100 do
  begin
    Val := 0.1 * I;
    Expected := System.Exp(Val);
    TestT(Val, Expected, FastExp, FastExp, FastExp, FastExp);
  end;

  TestT( SMALL_VALUE, System.Exp( SMALL_VALUE), FastExp, FastExp, FastExp, FastExp);
  TestT(-SMALL_VALUE, System.Exp(-SMALL_VALUE), FastExp, FastExp, FastExp, FastExp);
  TestT( MEDIUM_VALUE, System.Exp( MEDIUM_VALUE), FastExp, FastExp, FastExp, FastExp);
  TestT(-MEDIUM_VALUE, System.Exp(-MEDIUM_VALUE), FastExp, FastExp, FastExp, FastExp);
  TestT( LARGE_VALUE, System.Exp( LARGE_VALUE), FastExp, FastExp, FastExp, FastExp);
  TestT(-LARGE_VALUE, System.Exp(-LARGE_VALUE), FastExp, FastExp, FastExp, FastExp);
end;

procedure TExponentialFunctionsTests.TestFastExp2;
var
  I: Integer;
  Val, Expected: Single;
begin
  for I := -1269 to 1269 do
  begin
    Val := I * 0.1;
    Expected := System.Math.Power(2, Val);
    TestT(Val, Expected, FastExp2, FastExp2, FastExp2, FastExp2);
  end;

  TestT( SMALL_VALUE, System.Math.Power(2,  SMALL_VALUE), FastExp2, FastExp2, FastExp2, FastExp2);
  TestT(-SMALL_VALUE, System.Math.Power(2, -SMALL_VALUE), FastExp2, FastExp2, FastExp2, FastExp2);

  { FastExp2 does not work for values outside the range -127..127 }
end;

procedure TExponentialFunctionsTests.TestFastLn;
var
  I: Integer;
  Val, Expected: Single;
begin
  for I := 1 to 200 do
  begin
    Val := 0.1 * I;
    Expected := System.Ln(Val);
    TestT(Val, Expected, FastLn, FastLn, FastLn, FastLn);
  end;

  TestT( SMALL_VALUE, System.Ln( SMALL_VALUE), FastLn, FastLn, FastLn, FastLn);
  TestT(-SMALL_VALUE, System.Ln(-SMALL_VALUE), FastLn, FastLn, FastLn, FastLn);
  TestT( MEDIUM_VALUE, System.Ln( MEDIUM_VALUE), FastLn, FastLn, FastLn, FastLn);
  TestT(-MEDIUM_VALUE, System.Ln(-MEDIUM_VALUE), FastLn, FastLn, FastLn, FastLn);
  TestT( LARGE_VALUE, System.Ln( LARGE_VALUE), FastLn, FastLn, FastLn, FastLn);
  TestT(-LARGE_VALUE, System.Ln(-LARGE_VALUE), FastLn, FastLn, FastLn, FastLn);
end;

procedure TExponentialFunctionsTests.TestFastLog2;
var
  I: Integer;
  Val, Expected: Single;
begin
  for I := 1 to 200 do
  begin
    Val := 0.1 * I;
    Expected := System.Math.Log2(Val);
    TestT(Val, Expected, FastLog2, FastLog2, FastLog2, FastLog2, 0.0002);
  end;

  TestT(SMALL_VALUE, System.Math.Log2(SMALL_VALUE), FastLog2, FastLog2, FastLog2, FastLog2);
  TestT(MEDIUM_VALUE, System.Math.Log2(MEDIUM_VALUE), FastLog2, FastLog2, FastLog2, FastLog2);
  TestT(LARGE_VALUE, System.Math.Log2(LARGE_VALUE), FastLog2, FastLog2, FastLog2, FastLog2);
end;

procedure TExponentialFunctionsTests.TestFastPower;
var
  B, E: Integer;
  Base, Exp, Expected: Single;
begin
  for B := 1 to 100 do
  begin
    Base := B * 0.1;
    for E := -100 to 100 do
    begin
      Exp := E * 0.1;
      Expected := System.Math.Power(Base, Exp);
      TestTT(Base, Exp, Expected, FastPower, FastPower, FastPower, FastPower, Abs(Expected * 0.002));
    end;
  end;

  TestTT(SMALL_VALUE,  SMALL_VALUE, System.Math.Power(SMALL_VALUE,  SMALL_VALUE), FastPower, FastPower, FastPower, FastPower);
  TestTT(SMALL_VALUE, -SMALL_VALUE, System.Math.Power(SMALL_VALUE, -SMALL_VALUE), FastPower, FastPower, FastPower, FastPower);
  TestTT(MEDIUM_VALUE,  SMALL_VALUE, System.Math.Power(MEDIUM_VALUE,  SMALL_VALUE), FastPower, FastPower, FastPower, FastPower);
  TestTT(MEDIUM_VALUE, -SMALL_VALUE, System.Math.Power(MEDIUM_VALUE, -SMALL_VALUE), FastPower, FastPower, FastPower, FastPower);
  TestTT(LARGE_VALUE,  SMALL_VALUE, System.Math.Power(LARGE_VALUE,  SMALL_VALUE), FastPower, FastPower, FastPower, FastPower);
  TestTT(LARGE_VALUE, -SMALL_VALUE, System.Math.Power(LARGE_VALUE, -SMALL_VALUE), FastPower, FastPower, FastPower, FastPower);
  TestTT(SMALL_VALUE,  3, System.Math.Power(SMALL_VALUE,  3), FastPower, FastPower, FastPower, FastPower);
  TestTT(SMALL_VALUE, -3, System.Math.Power(SMALL_VALUE, -3), FastPower, FastPower, FastPower, FastPower);
end;

procedure TExponentialFunctionsTests.TestInverseSqrt;
begin
  TestT(0.25000, 2.00000, InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt, 0.0005);
  TestT(0.44444, 1.50000, InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt, 0.0005);
  TestT(1.00000, 1.00000, InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt, 0.0005);
  TestT(2.00000, 0.70710, InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt, 0.0005);

  TestT(SMALL_VALUE, 1 / System.Sqrt(SMALL_VALUE), InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt, 100);
  TestT(MEDIUM_VALUE, 1 / System.Sqrt(MEDIUM_VALUE), InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt);
  TestT(LARGE_VALUE, 1 / System.Sqrt(LARGE_VALUE), InverseSqrt, InverseSqrt, InverseSqrt, InverseSqrt);
end;

procedure TExponentialFunctionsTests.TestLn;
begin
  TestT(0.36788, -1, Neslib.FastMath.Ln, Ln, Ln, Ln);
  TestT(1.00000,  0, Neslib.FastMath.Ln, Ln, Ln, Ln);
  TestT(2.71828,  1, Neslib.FastMath.Ln, Ln, Ln, Ln);

  TestT(SMALL_VALUE, System.Ln(SMALL_VALUE), Neslib.FastMath.Ln, Ln, Ln, Ln);
  TestT(MEDIUM_VALUE, System.Ln(MEDIUM_VALUE), Neslib.FastMath.Ln, Ln, Ln, Ln);
  TestT(LARGE_VALUE, System.Ln(LARGE_VALUE), Neslib.FastMath.Ln, Ln, Ln, Ln);
end;

procedure TExponentialFunctionsTests.TestLog2;
begin
  TestT(0.5, -1, Neslib.FastMath.Log2, Log2, Log2, Log2);
  TestT(1.0,  0, Neslib.FastMath.Log2, Log2, Log2, Log2);
  TestT(2.0,  1, Neslib.FastMath.Log2, Log2, Log2, Log2);

  TestT(SMALL_VALUE, System.Math.Log2(SMALL_VALUE), Neslib.FastMath.Log2, Log2, Log2, Log2);
  TestT(MEDIUM_VALUE, System.Math.Log2(MEDIUM_VALUE), Neslib.FastMath.Log2, Log2, Log2, Log2);
  TestT(LARGE_VALUE, System.Math.Log2(LARGE_VALUE), Neslib.FastMath.Log2, Log2, Log2, Log2);
end;

procedure TExponentialFunctionsTests.TestPower;
begin
  TestTT(0,  1.0, 0.00000, Power, Power, Power, Power);
  TestTT(1,  1.0, 1.00000, Power, Power, Power, Power);
  TestTT(2,  3.0, 8.00000, Power, Power, Power, Power);
  TestTT(2, -3.0, 0.12500, Power, Power, Power, Power);
  TestTT(2,  1.5, 2.82842, Power, Power, Power, Power);
  TestTT(2, -1.5, 0.35355, Power, Power, Power, Power);

  TestTT(SMALL_VALUE,  SMALL_VALUE, System.Math.Power(SMALL_VALUE,  SMALL_VALUE), Power, Power, Power, Power);
  TestTT(SMALL_VALUE, -SMALL_VALUE, System.Math.Power(SMALL_VALUE, -SMALL_VALUE), Power, Power, Power, Power);
  TestTT(MEDIUM_VALUE,  SMALL_VALUE, System.Math.Power(MEDIUM_VALUE,  SMALL_VALUE), Power, Power, Power, Power);
  TestTT(MEDIUM_VALUE, -SMALL_VALUE, System.Math.Power(MEDIUM_VALUE, -SMALL_VALUE), Power, Power, Power, Power);
  TestTT(LARGE_VALUE,  SMALL_VALUE, System.Math.Power(LARGE_VALUE,  SMALL_VALUE), Power, Power, Power, Power);
  TestTT(LARGE_VALUE, -SMALL_VALUE, System.Math.Power(LARGE_VALUE, -SMALL_VALUE), Power, Power, Power, Power);
  TestTT(SMALL_VALUE,  3, System.Math.Power(SMALL_VALUE,  3), Power, Power, Power, Power);
  TestTT(SMALL_VALUE, -3, System.Math.Power(SMALL_VALUE, -3), Power, Power, Power, Power);
end;

procedure TExponentialFunctionsTests.TestSqrt;
begin
  TestT(0.00, 0.00000, Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
  TestT(1.00, 1.00000, Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
  TestT(2.00, 1.41421, Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
  TestT(2.25, 1.50000, Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
  TestT(4.00, 2.00000, Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);

  TestT(SMALL_VALUE, System.Sqrt(SMALL_VALUE), Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
  TestT(MEDIUM_VALUE, System.Sqrt(MEDIUM_VALUE), Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
  TestT(LARGE_VALUE, System.Sqrt(LARGE_VALUE), Neslib.FastMath.Sqrt, Sqrt, Sqrt, Sqrt);
end;

end.
