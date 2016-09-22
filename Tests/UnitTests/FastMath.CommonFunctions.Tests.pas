unit FastMath.CommonFunctions.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TCommonFunctionsTests = class(TUnitTest)
  published
    procedure TestAbs;
    procedure TestSign;
    procedure TestFloor;
    procedure TestTrunc;
    procedure TestRound;
    procedure TestCeil;
    procedure TestFrac;
    procedure TestFMod;
    procedure TestModF;
    procedure TestMin;
    procedure TestMax;
    procedure TestEnsureRange;
    procedure TestMix;
    procedure TestStep;
    procedure TestSmoothStep;
    procedure TestFMA;
  end;

implementation

uses
  System.Math;

{ TCommonFunctionsTests }

procedure TCommonFunctionsTests.TestAbs;
begin
  TestT( 0.00, 0.00, Abs, Abs, Abs, Abs);
  TestT( 1.23, 1.23, Abs, Abs, Abs, Abs);
  TestT(-1.23, 1.23, Abs, Abs, Abs, Abs);

  TestT( SMALL_VALUE, SMALL_VALUE, Abs, Abs, Abs, Abs);
  TestT(-SMALL_VALUE, SMALL_VALUE, Abs, Abs, Abs, Abs);
  TestT( LARGE_VALUE, LARGE_VALUE, Abs, Abs, Abs, Abs);
  TestT(-LARGE_VALUE, LARGE_VALUE, Abs, Abs, Abs, Abs);
end;

procedure TCommonFunctionsTests.TestCeil;
begin
  TestTrU(-3.9, -3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU(-3.5, -3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU(-3.1, -3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU(-3.0, -3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU( 0.0,  0, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU( 2.0,  2, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU( 2.1,  3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU( 2.5,  3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU( 2.9,  3, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);

  TestTrU( SMALL_VALUE, 1, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU(-SMALL_VALUE, 0, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU( MEDIUM_VALUE,  987655, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
  TestTrU(-MEDIUM_VALUE, -987654, Neslib.FastMath.Ceil, Ceil, Ceil, Ceil);
end;

procedure TCommonFunctionsTests.TestEnsureRange;
begin
  TestTTT(-1.1, -2, 2, -1.1, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT( 1.1, -2, 2,  1.1, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT(-1.1, -1, 1, -1.0, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT( 1.1, -1, 1,  1.0, EnsureRange, EnsureRange, EnsureRange, EnsureRange);

  TestTTT( 1.23e-13, -SMALL_VALUE, SMALL_VALUE,  1.23e-13, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT( 1.23e-11, -SMALL_VALUE, SMALL_VALUE,  SMALL_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT(-1.23e-13, -SMALL_VALUE, SMALL_VALUE, -1.23e-13, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT(-1.23e-11, -SMALL_VALUE, SMALL_VALUE, -SMALL_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);

  TestTTT( 1234567890987, -LARGE_VALUE, LARGE_VALUE,  1234567890987, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT( 1234567890988, -LARGE_VALUE, LARGE_VALUE,  LARGE_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT(-1234567890987, -LARGE_VALUE, LARGE_VALUE, -1234567890987, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTTT(-1234567890988, -LARGE_VALUE, LARGE_VALUE, -LARGE_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);

  TestTFF(-1.1, -2, 2, -1.1, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF( 1.1, -2, 2,  1.1, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF(-1.1, -1, 1, -1.0, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF( 1.1, -1, 1,  1.0, EnsureRange, EnsureRange, EnsureRange, EnsureRange);

  TestTFF( 1.23e-13, -SMALL_VALUE, SMALL_VALUE,  1.23e-13, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF( 1.23e-11, -SMALL_VALUE, SMALL_VALUE,  SMALL_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF(-1.23e-13, -SMALL_VALUE, SMALL_VALUE, -1.23e-13, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF(-1.23e-11, -SMALL_VALUE, SMALL_VALUE, -SMALL_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);

  TestTFF( 1234567890987, -LARGE_VALUE, LARGE_VALUE,  1234567890987, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF( 1234567890988, -LARGE_VALUE, LARGE_VALUE,  LARGE_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF(-1234567890987, -LARGE_VALUE, LARGE_VALUE, -1234567890987, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
  TestTFF(-1234567890988, -LARGE_VALUE, LARGE_VALUE, -LARGE_VALUE, EnsureRange, EnsureRange, EnsureRange, EnsureRange);
end;

procedure TCommonFunctionsTests.TestFloor;
begin
  TestTrU(-3.9, -4, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU(-3.5, -4, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU(-3.1, -4, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU(-3.0, -3, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU( 0.0,  0, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU( 2.0,  2, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU( 2.1,  2, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU( 2.5,  2, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU( 2.9,  2, Neslib.FastMath.Floor, Floor, Floor, Floor);

  TestTrU( SMALL_VALUE,  0, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU(-SMALL_VALUE, -1, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU( MEDIUM_VALUE,  987654, Neslib.FastMath.Floor, Floor, Floor, Floor);
  TestTrU(-MEDIUM_VALUE, -987655, Neslib.FastMath.Floor, Floor, Floor, Floor);
end;

procedure TCommonFunctionsTests.TestFMA;
begin
  TestTTT(0, 0, 0,  0, FMA, FMA, FMA, FMA);
  TestTTT(2, 0, 0,  0, FMA, FMA, FMA, FMA);
  TestTTT(0, 2, 0,  0, FMA, FMA, FMA, FMA);
  TestTTT(0, 0, 2,  2, FMA, FMA, FMA, FMA);
  TestTTT(3, 0, 4,  4, FMA, FMA, FMA, FMA);
  TestTTT(2, 3, 4, 10, FMA, FMA, FMA, FMA);

  TestTTT( SMALL_VALUE, 2,  SMALL_VALUE,  SMALL_VALUE * 3, FMA, FMA, FMA, FMA);
  TestTTT(-SMALL_VALUE, 2, -SMALL_VALUE, -SMALL_VALUE * 3, FMA, FMA, FMA, FMA);
  TestTTT( LARGE_VALUE, 2,  LARGE_VALUE,  LARGE_VALUE * 3, FMA, FMA, FMA, FMA);
  TestTTT(-LARGE_VALUE, 2, -LARGE_VALUE, -LARGE_VALUE * 3, FMA, FMA, FMA, FMA);
end;

procedure TCommonFunctionsTests.TestFrac;
begin
  TestT(-2.5, -0.5, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT(-2.0,  0.0, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT( 0.0,  0.0, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT( 2.0,  0.0, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT( 2.1,  0.1, Neslib.FastMath.Frac, Frac, Frac, Frac);

  TestT( SMALL_VALUE,  0.23e-12, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT(-SMALL_VALUE, -0.23e-12, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT( MEDIUM_VALUE,  0.3125, Neslib.FastMath.Frac, Frac, Frac, Frac);
  TestT(-MEDIUM_VALUE, -0.3125, Neslib.FastMath.Frac, Frac, Frac, Frac);
end;

procedure TCommonFunctionsTests.TestMax;
begin
  TestTT(-1.1, -1.2, -1.1, Max, Max, Max, Max);
  TestTT(-1.2, -1.1, -1.1, Max, Max, Max, Max);
  TestTT(-1.3, -1.3, -1.3, Max, Max, Max, Max);
  TestTT( 1.1,  1.2,  1.2, Max, Max, Max, Max);
  TestTT( 1.2,  1.1,  1.2, Max, Max, Max, Max);
  TestTT( 1.3,  1.3,  1.3, Max, Max, Max, Max);

  TestTT( SMALL_VALUE,  1.23e-11,  1.23e-11, Max, Max, Max, Max);
  TestTT( SMALL_VALUE,  1.23e-13,  SMALL_VALUE, Max, Max, Max, Max);
  TestTT(-SMALL_VALUE, -1.23e-11, -SMALL_VALUE, Max, Max, Max, Max);
  TestTT(-SMALL_VALUE, -1.23e-13, -1.23e-13, Max, Max, Max, Max);

  TestTT( LARGE_VALUE,  1234567890988,  1234567890988, Max, Max, Max, Max);
  TestTT( LARGE_VALUE,  1234567890986,  LARGE_VALUE, Max, Max, Max, Max);
  TestTT(-LARGE_VALUE, -1234567890988, -LARGE_VALUE, Max, Max, Max, Max);
  TestTT(-LARGE_VALUE, -1234567890986, -1234567890986, Max, Max, Max, Max);

  TestTF(-1.1, -1.2, -1.1, Max, Max, Max, Max);
  TestTF(-1.2, -1.1, -1.1, Max, Max, Max, Max);
  TestTF(-1.3, -1.3, -1.3, Max, Max, Max, Max);
  TestTF( 1.1,  1.2,  1.2, Max, Max, Max, Max);
  TestTF( 1.2,  1.1,  1.2, Max, Max, Max, Max);
  TestTF( 1.3,  1.3,  1.3, Max, Max, Max, Max);

  TestTF( SMALL_VALUE,  1.23e-11,  1.23e-11, Max, Max, Max, Max);
  TestTF( SMALL_VALUE,  1.23e-13,  SMALL_VALUE, Max, Max, Max, Max);
  TestTF(-SMALL_VALUE, -1.23e-11, -SMALL_VALUE, Max, Max, Max, Max);
  TestTF(-SMALL_VALUE, -1.23e-13, -1.23e-13, Max, Max, Max, Max);

  TestTF( LARGE_VALUE,  1234567890988,  1234567890988, Max, Max, Max, Max);
  TestTF( LARGE_VALUE,  1234567890986,  LARGE_VALUE, Max, Max, Max, Max);
  TestTF(-LARGE_VALUE, -1234567890988, -LARGE_VALUE, Max, Max, Max, Max);
  TestTF(-LARGE_VALUE, -1234567890986, -1234567890986, Max, Max, Max, Max);
end;

procedure TCommonFunctionsTests.TestMin;
begin
  TestTT(-1.1, -1.2, -1.2, Min, Min, Min, Min);
  TestTT(-1.2, -1.1, -1.2, Min, Min, Min, Min);
  TestTT(-1.3, -1.3, -1.3, Min, Min, Min, Min);
  TestTT( 1.1,  1.2,  1.1, Min, Min, Min, Min);
  TestTT( 1.2,  1.1,  1.1, Min, Min, Min, Min);
  TestTT( 1.3,  1.3,  1.3, Min, Min, Min, Min);

  TestTT( SMALL_VALUE,  1.23e-11,  SMALL_VALUE, Min, Min, Min, Min);
  TestTT( SMALL_VALUE,  1.23e-13,  1.23e-13, Min, Min, Min, Min);
  TestTT(-SMALL_VALUE, -1.23e-11, -1.23e-11, Min, Min, Min, Min);
  TestTT(-SMALL_VALUE, -1.23e-13, -SMALL_VALUE, Min, Min, Min, Min);

  TestTT( LARGE_VALUE,  1234567890988,  LARGE_VALUE, Min, Min, Min, Min);
  TestTT( LARGE_VALUE,  1234567890986,  1234567890986, Min, Min, Min, Min);
  TestTT(-LARGE_VALUE, -1234567890988, -1234567890988, Min, Min, Min, Min);
  TestTT(-LARGE_VALUE, -1234567890986, -LARGE_VALUE, Min, Min, Min, Min);

  TestTF(-1.1, -1.2, -1.2, Min, Min, Min, Min);
  TestTF(-1.2, -1.1, -1.2, Min, Min, Min, Min);
  TestTF(-1.3, -1.3, -1.3, Min, Min, Min, Min);
  TestTF( 1.1,  1.2,  1.1, Min, Min, Min, Min);
  TestTF( 1.2,  1.1,  1.1, Min, Min, Min, Min);
  TestTF( 1.3,  1.3,  1.3, Min, Min, Min, Min);

  TestTF( SMALL_VALUE,  1.23e-11,  SMALL_VALUE, Min, Min, Min, Min);
  TestTF( SMALL_VALUE,  1.23e-13,  1.23e-13, Min, Min, Min, Min);
  TestTF(-SMALL_VALUE, -1.23e-11, -1.23e-11, Min, Min, Min, Min);
  TestTF(-SMALL_VALUE, -1.23e-13, -SMALL_VALUE, Min, Min, Min, Min);

  TestTF( LARGE_VALUE,  1234567890988,  LARGE_VALUE, Min, Min, Min, Min);
  TestTF( LARGE_VALUE,  1234567890986,  1234567890986, Min, Min, Min, Min);
  TestTF(-LARGE_VALUE, -1234567890988, -1234567890988, Min, Min, Min, Min);
  TestTF(-LARGE_VALUE, -1234567890986, -LARGE_VALUE, Min, Min, Min, Min);
end;

procedure TCommonFunctionsTests.TestMix;
begin
  TestTTT(2, 4, 0.00, 2.0, Mix, Mix, Mix, Mix);
  TestTTT(2, 4, 0.25, 2.5, Mix, Mix, Mix, Mix);
  TestTTT(2, 4, 0.50, 3.0, Mix, Mix, Mix, Mix);
  TestTTT(2, 4, 0.75, 3.5, Mix, Mix, Mix, Mix);
  TestTTT(2, 4, 1.00, 4.0, Mix, Mix, Mix, Mix);

  TestTTT(-SMALL_VALUE, SMALL_VALUE, 0.5, 0, Mix, Mix, Mix, Mix);
  TestTTT(-SMALL_VALUE, SMALL_VALUE, 0.0, -SMALL_VALUE, Mix, Mix, Mix, Mix);
  TestTTT(-SMALL_VALUE, SMALL_VALUE, 1.0,  SMALL_VALUE, Mix, Mix, Mix, Mix);
  TestTTT(-LARGE_VALUE, LARGE_VALUE, 0.5, 0, Mix, Mix, Mix, Mix);
  TestTTT(-LARGE_VALUE, LARGE_VALUE, 0.0, -LARGE_VALUE, Mix, Mix, Mix, Mix);
  TestTTT(-LARGE_VALUE, LARGE_VALUE, 1.0,  LARGE_VALUE, Mix, Mix, Mix, Mix);

  TestTTF(2, 4, 0.00, 2.0, Mix, Mix, Mix, Mix);
  TestTTF(2, 4, 0.25, 2.5, Mix, Mix, Mix, Mix);
  TestTTF(2, 4, 0.50, 3.0, Mix, Mix, Mix, Mix);
  TestTTF(2, 4, 0.75, 3.5, Mix, Mix, Mix, Mix);
  TestTTF(2, 4, 1.00, 4.0, Mix, Mix, Mix, Mix);

  TestTTF(-SMALL_VALUE, SMALL_VALUE, 0.5, 0, Mix, Mix, Mix, Mix);
  TestTTF(-SMALL_VALUE, SMALL_VALUE, 0.0, -SMALL_VALUE, Mix, Mix, Mix, Mix);
  TestTTF(-SMALL_VALUE, SMALL_VALUE, 1.0,  SMALL_VALUE, Mix, Mix, Mix, Mix);
  TestTTF(-LARGE_VALUE, LARGE_VALUE, 0.5, 0, Mix, Mix, Mix, Mix);
  TestTTF(-LARGE_VALUE, LARGE_VALUE, 0.0, -LARGE_VALUE, Mix, Mix, Mix, Mix);
  TestTTF(-LARGE_VALUE, LARGE_VALUE, 1.0,  LARGE_VALUE, Mix, Mix, Mix, Mix);
end;

procedure TCommonFunctionsTests.TestFMod;
begin
  TestTT( 3,  2,  1, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTT(-3,  2, -1, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTT( 3, -2,  1, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTT(-3, -2, -1, Neslib.FastMath.FMod, FMod, FMod, FMod);

  TestTT( 4,  2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTT(-4,  2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTT( 4, -2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTT(-4, -2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);

  TestTF( 3,  2,  1, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTF(-3,  2, -1, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTF( 3, -2,  1, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTF(-3, -2, -1, Neslib.FastMath.FMod, FMod, FMod, FMod);

  TestTF( 4,  2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTF(-4,  2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTF( 4, -2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
  TestTF(-4, -2,  0, Neslib.FastMath.FMod, FMod, FMod, FMod);
end;

procedure TCommonFunctionsTests.TestModF;
begin
  TestToU( 2.5,  0.5,  2, ModF, ModF, ModF, ModF);
  TestToU( 2.0,  0.0,  2, ModF, ModF, ModF, ModF);
  TestToU(-2.5, -0.5, -2, ModF, ModF, ModF, ModF);
  TestToU(-2.0,  0.0, -2, ModF, ModF, ModF, ModF);
end;

procedure TCommonFunctionsTests.TestRound;
begin
  TestTrU(-3.9, -4, Round, Round, Round, Round);
  TestTrU(-3.5, -4, Round, Round, Round, Round);
  TestTrU(-3.1, -3, Round, Round, Round, Round);
  TestTrU(-3.0, -3, Round, Round, Round, Round);
  TestTrU( 0.0,  0, Round, Round, Round, Round);
  TestTrU( 2.0,  2, Round, Round, Round, Round);
  TestTrU( 2.1,  2, Round, Round, Round, Round);
  TestTrU( 2.5,  2, Round, Round, Round, Round);
  TestTrU( 2.9,  3, Round, Round, Round, Round);

  TestTrU( SMALL_VALUE, 0, Round, Round, Round, Round);
  TestTrU(-SMALL_VALUE, 0, Round, Round, Round, Round);
  TestTrU( MEDIUM_VALUE,  987654, Round, Round, Round, Round);
  TestTrU(-MEDIUM_VALUE, -987654, Round, Round, Round, Round);
end;

procedure TCommonFunctionsTests.TestSign;
begin
  TestT(  0,  0, Neslib.FastMath.Sign, Sign, Sign, Sign);
  TestT(-Pi, -1, Neslib.FastMath.Sign, Sign, Sign, Sign);
  TestT( Pi,  1, Neslib.FastMath.Sign, Sign, Sign, Sign);

  TestT( SMALL_VALUE,  1, Neslib.FastMath.Sign, Sign, Sign, Sign);
  TestT(-SMALL_VALUE, -1, Neslib.FastMath.Sign, Sign, Sign, Sign);
  TestT( MEDIUM_VALUE,  1, Neslib.FastMath.Sign, Sign, Sign, Sign);
  TestT(-MEDIUM_VALUE, -1, Neslib.FastMath.Sign, Sign, Sign, Sign);
end;

procedure TCommonFunctionsTests.TestSmoothStep;
begin
  TestTTT(3, 7, 2, 0.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(3, 7, 3, 0.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(3, 7, 4, 0.15625, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(3, 7, 5, 0.50000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(3, 7, 6, 0.84375, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(3, 7, 7, 1.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(3, 7, 8, 1.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);

  TestTTT(-SMALL_VALUE, SMALL_VALUE, -0.1, 0.0, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(-SMALL_VALUE, SMALL_VALUE,  0.0, 0.5, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(-SMALL_VALUE, SMALL_VALUE,  0.1, 1.0, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(-LARGE_VALUE, LARGE_VALUE, -2000000000000, 0, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(-LARGE_VALUE, LARGE_VALUE,  0, 0.5, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestTTT(-LARGE_VALUE, LARGE_VALUE,  2000000000000, 1, SmoothStep, SmoothStep, SmoothStep, SmoothStep);

  TestFFT(3, 7, 2, 0.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(3, 7, 3, 0.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(3, 7, 4, 0.15625, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(3, 7, 5, 0.50000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(3, 7, 6, 0.84375, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(3, 7, 7, 1.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(3, 7, 8, 1.00000, SmoothStep, SmoothStep, SmoothStep, SmoothStep);

  TestFFT(-SMALL_VALUE, SMALL_VALUE, -0.1, 0.0, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(-SMALL_VALUE, SMALL_VALUE,  0.0, 0.5, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(-SMALL_VALUE, SMALL_VALUE,  0.1, 1.0, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(-LARGE_VALUE, LARGE_VALUE, -2000000000000, 0, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(-LARGE_VALUE, LARGE_VALUE,  0, 0.5, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
  TestFFT(-LARGE_VALUE, LARGE_VALUE,  2000000000000, 1, SmoothStep, SmoothStep, SmoothStep, SmoothStep);
end;

procedure TCommonFunctionsTests.TestStep;
begin
  TestTT(3, 2, 0, Step, Step, Step, Step);
  TestTT(3, 3, 1, Step, Step, Step, Step);
  TestTT(3, 4, 1, Step, Step, Step, Step);

  TestTT( SMALL_VALUE,  1.23e-11, 1, Step, Step, Step, Step);
  TestTT( SMALL_VALUE,  1.23e-13, 0, Step, Step, Step, Step);
  TestTT(-SMALL_VALUE, -1.23e-11, 0, Step, Step, Step, Step);
  TestTT(-SMALL_VALUE, -1.23e-13, 1, Step, Step, Step, Step);
  TestTT( LARGE_VALUE,  1234567890988, 1, Step, Step, Step, Step);
  TestTT( LARGE_VALUE,  1234560000000, 0, Step, Step, Step, Step);
  TestTT(-LARGE_VALUE, -1234570000000, 0, Step, Step, Step, Step);
  TestTT(-LARGE_VALUE, -1234567890986, 1, Step, Step, Step, Step);

  TestFT(3, 2, 0, Step, Step, Step, Step);
  TestFT(3, 3, 1, Step, Step, Step, Step);
  TestFT(3, 4, 1, Step, Step, Step, Step);

  TestFT( SMALL_VALUE,  1.23e-11, 1, Step, Step, Step, Step);
  TestFT( SMALL_VALUE,  1.23e-13, 0, Step, Step, Step, Step);
  TestFT(-SMALL_VALUE, -1.23e-11, 0, Step, Step, Step, Step);
  TestFT(-SMALL_VALUE, -1.23e-13, 1, Step, Step, Step, Step);
  TestFT( LARGE_VALUE,  1234567890988, 1, Step, Step, Step, Step);
  TestFT( LARGE_VALUE,  1234560000000, 0, Step, Step, Step, Step);
  TestFT(-LARGE_VALUE, -1234570000000, 0, Step, Step, Step, Step);
  TestFT(-LARGE_VALUE, -1234567890986, 1, Step, Step, Step, Step);
end;

procedure TCommonFunctionsTests.TestTrunc;
begin
  TestTrU(-3.9, -3, Trunc, Trunc, Trunc, Trunc);
  TestTrU(-3.5, -3, Trunc, Trunc, Trunc, Trunc);
  TestTrU(-3.1, -3, Trunc, Trunc, Trunc, Trunc);
  TestTrU(-3.0, -3, Trunc, Trunc, Trunc, Trunc);
  TestTrU( 0.0,  0, Trunc, Trunc, Trunc, Trunc);
  TestTrU( 2.0,  2, Trunc, Trunc, Trunc, Trunc);
  TestTrU( 2.1,  2, Trunc, Trunc, Trunc, Trunc);
  TestTrU( 2.5,  2, Trunc, Trunc, Trunc, Trunc);
  TestTrU( 2.9,  2, Trunc, Trunc, Trunc, Trunc);

  TestTrU( SMALL_VALUE, 0, Trunc, Trunc, Trunc, Trunc);
  TestTrU(-SMALL_VALUE, 0, Trunc, Trunc, Trunc, Trunc);
  TestTrU( MEDIUM_VALUE,  987654, Trunc, Trunc, Trunc, Trunc);
  TestTrU(-MEDIUM_VALUE, -987654, Trunc, Trunc, Trunc, Trunc);
end;

end.
