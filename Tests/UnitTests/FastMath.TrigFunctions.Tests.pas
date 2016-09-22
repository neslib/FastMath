unit FastMath.TrigFunctions.Tests;

interface

uses
  UnitTest,
  Neslib.FastMath;

type
  TTrigFunctionsTests = class(TUnitTest)
  published
    procedure TestRadians;
    procedure TestDegrees;
    procedure TestSin;
    procedure TestCos;
    procedure TestSinCos;
    procedure TestTan;
    procedure TestArcSin;
    procedure TestArcCos;
    procedure TestArcTan;
    procedure TestArcTan2;
    procedure TestSinh;
    procedure TestCosh;
    procedure TestTanh;
    procedure TestArcSinh;
    procedure TestArcCosh;
    procedure TestArcTanh;
    procedure TestFastCos;
    procedure TestFastSin;
    procedure TestFastTan;
    procedure TestFastSinCos;
    procedure TestFastArcTan2;
  end;

implementation

uses
  System.Math;

{ TTrigFunctionsTests }

procedure TTrigFunctionsTests.TestArcCos;
begin
  TestT( 0, Radians(  90), ArcCos, ArcCos, ArcCos, ArcCos);
  TestT( 1, Radians(   0), ArcCos, ArcCos, ArcCos, ArcCos);
  TestT(-1, Radians( 180), ArcCos, ArcCos, ArcCos, ArcCos);

  TestT( SMALL_VALUE, System.Math.ArcCos( SMALL_VALUE), ArcCos, ArcCos, ArcCos, ArcCos);
  TestT(-SMALL_VALUE, System.Math.ArcCos(-SMALL_VALUE), ArcCos, ArcCos, ArcCos, ArcCos);
end;

procedure TTrigFunctionsTests.TestArcCosh;
begin
  TestT( 1, 0.00000, Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
  TestT( 2, 1.31695, Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);

  TestT( SMALL_VALUE, System.Math.ArcCosh( SMALL_VALUE), Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
  TestT(-SMALL_VALUE, System.Math.ArcCosh(-SMALL_VALUE), Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
  TestT( MEDIUM_VALUE, System.Math.ArcCosh( MEDIUM_VALUE), Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
  TestT(-MEDIUM_VALUE, System.Math.ArcCosh(-MEDIUM_VALUE), Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
  TestT( LARGE_VALUE, System.Math.ArcCosh( LARGE_VALUE), Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
  TestT(-LARGE_VALUE, System.Math.ArcCosh(-LARGE_VALUE), Neslib.FastMath.ArcCosh, ArcCosh, ArcCosh, ArcCosh);
end;

procedure TTrigFunctionsTests.TestArcSin;
begin
  TestT( 0, Radians(  0), ArcSin, ArcSin, ArcSin, ArcSin);
  TestT( 1, Radians( 90), ArcSin, ArcSin, ArcSin, ArcSin);
  TestT(-1, Radians(-90), ArcSin, ArcSin, ArcSin, ArcSin);

  TestT( SMALL_VALUE, System.Math.ArcSin( SMALL_VALUE), ArcSin, ArcSin, ArcSin, ArcSin);
  TestT(-SMALL_VALUE, System.Math.ArcSin(-SMALL_VALUE), ArcSin, ArcSin, ArcSin, ArcSin);
end;

procedure TTrigFunctionsTests.TestArcSinh;
begin
  TestT(-1, -0.88137, Neslib.FastMath.ArcSinh, ArcSinh, ArcSinh, ArcSinh);
  TestT( 0,  0.00000, Neslib.FastMath.ArcSinh, ArcSinh, ArcSinh, ArcSinh);
  TestT( 1,  0.88137, Neslib.FastMath.ArcSinh, ArcSinh, ArcSinh, ArcSinh);

  TestT( SMALL_VALUE, System.Math.ArcSinh( SMALL_VALUE), Neslib.FastMath.ArcSinh, ArcSinh, ArcSinh, ArcSinh);
  TestT(-SMALL_VALUE, System.Math.ArcSinh(-SMALL_VALUE), Neslib.FastMath.ArcSinh, ArcSinh, ArcSinh, ArcSinh);
end;

procedure TTrigFunctionsTests.TestArcTan;
begin
  TestT( 0, Radians(   0), Neslib.FastMath.ArcTan, ArcTan, ArcTan, ArcTan);
  TestT( 1, Radians(  45), Neslib.FastMath.ArcTan, ArcTan, ArcTan, ArcTan);
  TestT(-1, Radians( -45), Neslib.FastMath.ArcTan, ArcTan, ArcTan, ArcTan);

  TestT( SMALL_VALUE, System.ArcTan( SMALL_VALUE), Neslib.FastMath.ArcTan, ArcTan, ArcTan, ArcTan);
  TestT(-SMALL_VALUE, System.ArcTan(-SMALL_VALUE), Neslib.FastMath.ArcTan, ArcTan, ArcTan, ArcTan);
end;

procedure TTrigFunctionsTests.TestArcTan2;
begin
  TestTT(0, 0, Radians(0), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);

  TestTT(0, 10, Radians(0), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);
  TestTT(10, 0, Radians(90), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);

  TestTT(0, -10, Radians(180), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);
  TestTT(-10, 0, Radians(-90), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);

  TestTT(10, 10, Radians(45), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);
  TestTT(10, -10, Radians(135), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);
  TestTT(-10, 10, Radians(-45), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);
  TestTT(-10, -10, Radians(-135), Neslib.FastMath.ArcTan2, ArcTan2, ArcTan2, ArcTan2);
end;

procedure TTrigFunctionsTests.TestArcTanh;
begin
  TestT(-0.5, -0.54930, Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT( 0.0,  0.00000, Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT( 0.5,  0.54930, Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);

  TestT( SMALL_VALUE, System.Math.ArcTanh( SMALL_VALUE), Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT(-SMALL_VALUE, System.Math.ArcTanh(-SMALL_VALUE), Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT( MEDIUM_VALUE, System.Math.ArcTanh( MEDIUM_VALUE), Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT(-MEDIUM_VALUE, System.Math.ArcTanh(-MEDIUM_VALUE), Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT( LARGE_VALUE, System.Math.ArcTanh( LARGE_VALUE), Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
  TestT(-LARGE_VALUE, System.Math.ArcTanh(-LARGE_VALUE), Neslib.FastMath.ArcTanh, ArcTanh, ArcTanh, ArcTanh);
end;

procedure TTrigFunctionsTests.TestCos;
begin
  TestT(Radians(-360),  1,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(-270),  0,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(-180), -1,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(-150), -0.86602, Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(-120), -0.5,     Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( -90),  0,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( -60),  0.5,     Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( -30),  0.86602, Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(   0),  1,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(  30),  0.86602, Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(  60),  0.5,     Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians(  90),  0,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( 120), -0.5,     Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( 150), -0.86602, Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( 180), -1,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( 270),  0,       Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(Radians( 360),  1,       Neslib.FastMath.Cos, Cos, Cos, Cos);

  TestT( SMALL_VALUE, System.Cos( SMALL_VALUE), Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(-SMALL_VALUE, System.Cos(-SMALL_VALUE), Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT( MEDIUM_VALUE, System.Cos( MEDIUM_VALUE), Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(-MEDIUM_VALUE, System.Cos(-MEDIUM_VALUE), Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT( LARGE_VALUE, System.Cos( LARGE_VALUE), Neslib.FastMath.Cos, Cos, Cos, Cos);
  TestT(-LARGE_VALUE, System.Cos(-LARGE_VALUE), Neslib.FastMath.Cos, Cos, Cos, Cos);
end;

procedure TTrigFunctionsTests.TestCosh;
begin
  TestT(-1, 1.54308, Neslib.FastMath.Cosh, Cosh, Cosh, Cosh);
  TestT( 0, 1.00000, Neslib.FastMath.Cosh, Cosh, Cosh, Cosh);
  TestT( 1, 1.54308, Neslib.FastMath.Cosh, Cosh, Cosh, Cosh);

  TestT( SMALL_VALUE, System.Math.Cosh( SMALL_VALUE), Neslib.FastMath.Cosh, Cosh, Cosh, Cosh);
  TestT(-SMALL_VALUE, System.Math.Cosh(-SMALL_VALUE), Neslib.FastMath.Cosh, Cosh, Cosh, Cosh);
end;

procedure TTrigFunctionsTests.TestDegrees;
begin
  TestT(-2.0 * Pi, -360, Degrees, Degrees, Degrees, Degrees);
  TestT(-1.5 * Pi, -270, Degrees, Degrees, Degrees, Degrees);
  TestT(      -Pi, -180, Degrees, Degrees, Degrees, Degrees);
  TestT(-0.5 * Pi,  -90, Degrees, Degrees, Degrees, Degrees);
  TestT(        0,    0, Degrees, Degrees, Degrees, Degrees);
  TestT( 0.5 * Pi,   90, Degrees, Degrees, Degrees, Degrees);
  TestT(       Pi,  180, Degrees, Degrees, Degrees, Degrees);
  TestT( 1.5 * Pi,  270, Degrees, Degrees, Degrees, Degrees);
  TestT( 2.0 * Pi,  360, Degrees, Degrees, Degrees, Degrees);

  TestT( SMALL_VALUE, RadToDeg( SMALL_VALUE), Degrees, Degrees, Degrees, Degrees);
  TestT(-SMALL_VALUE, RadToDeg(-SMALL_VALUE), Degrees, Degrees, Degrees, Degrees);
  TestT( MEDIUM_VALUE, RadToDeg( MEDIUM_VALUE), Degrees, Degrees, Degrees, Degrees);
  TestT(-MEDIUM_VALUE, RadToDeg(-MEDIUM_VALUE), Degrees, Degrees, Degrees, Degrees);
  TestT( LARGE_VALUE, RadToDeg( LARGE_VALUE), Degrees, Degrees, Degrees, Degrees);
  TestT(-LARGE_VALUE, RadToDeg(-LARGE_VALUE), Degrees, Degrees, Degrees, Degrees);
end;

procedure TTrigFunctionsTests.TestFastArcTan2;
var
  I, J: Integer;
  X, Y, Expected: Single;
begin
  for I := -200 to 200 do
  begin
    X := 0.01 * I;
    for J := -200 to 200 do
    begin
      Y := 0.01 * J;
      Expected := System.Math.ArcTan2(Y, X);
      TestTT(Y, X, Expected, FastArcTan2, FastArcTan2, FastArcTan2, FastArcTan2, 0.005);
    end;
  end;
end;

procedure TTrigFunctionsTests.TestFastCos;
var
  Deg: Integer;
  Rad, Expected: Single;
begin
  for Deg := -1000 to 1000 do
  begin
    Rad := Radians(Deg);
    Expected := System.Cos(Rad);
    TestT(Rad, Expected, FastCos, FastCos, FastCos, FastCos);
  end;

  TestT( SMALL_VALUE, System.Cos( SMALL_VALUE), FastCos, FastCos, FastCos, FastCos);
  TestT(-SMALL_VALUE, System.Cos(-SMALL_VALUE), FastCos, FastCos, FastCos, FastCos);
  TestT( 4000, System.Cos( 4000), FastCos, FastCos, FastCos, FastCos);
  TestT(-4000, System.Cos(-4000), FastCos, FastCos, FastCos, FastCos);
end;

procedure TTrigFunctionsTests.TestFastSin;
var
  Deg: Integer;
  Rad, Expected: Single;
begin
  for Deg := -1000 to 1000 do
  begin
    Rad := Radians(Deg);
    Expected := System.Sin(Rad);
    TestT(Rad, Expected, FastSin, FastSin, FastSin, FastSin);
  end;

  TestT( SMALL_VALUE, System.Sin( SMALL_VALUE), FastSin, FastSin, FastSin, FastSin);
  TestT(-SMALL_VALUE, System.Sin(-SMALL_VALUE), FastSin, FastSin, FastSin, FastSin);
  TestT( 4000, System.Sin( 4000), FastSin, FastSin, FastSin, FastSin);
  TestT(-4000, System.Sin(-4000), FastSin, FastSin, FastSin, FastSin);
end;

procedure TTrigFunctionsTests.TestFastSinCos;
var
  Deg: Integer;
  Rad, ExpSin, ExpCos: Single;
begin
  for Deg := -1000 to 1000 do
  begin
    Rad := Radians(Deg);
    System.Math.SinCos(Rad, ExpSin, ExpCos);
    TestToToT(Rad, ExpSin, ExpCos, FastSinCos, FastSinCos, FastSinCos, FastSinCos);
  end;

  TestToToT( SMALL_VALUE, System.Sin( SMALL_VALUE), System.Cos( SMALL_VALUE), FastSinCos, FastSinCos, FastSinCos, FastSinCos);
  TestToToT(-SMALL_VALUE, System.Sin(-SMALL_VALUE), System.Cos(-SMALL_VALUE), FastSinCos, FastSinCos, FastSinCos, FastSinCos);
  TestToToT( 4000, System.Sin( 4000), System.Cos( 4000), FastSinCos, FastSinCos, FastSinCos, FastSinCos);
  TestToToT(-4000, System.Sin(-4000), System.Cos(-4000), FastSinCos, FastSinCos, FastSinCos, FastSinCos);
end;

procedure TTrigFunctionsTests.TestFastTan;
var
  Deg: Integer;
  Rad, Expected: Single;
begin
  for Deg := -180 to 180 do
  begin
    if (Abs(Deg) <> 90) then
    begin
      Rad := Radians(Deg);
      Expected := System.Tangent(Rad);
      TestT(Rad, Expected, FastTan, FastTan, FastTan, FastTan, 0.08);
    end;
  end;

  TestT( SMALL_VALUE, System.Tangent( SMALL_VALUE), FastTan, FastTan, FastTan, FastTan);
  TestT(-SMALL_VALUE, System.Tangent(-SMALL_VALUE), FastTan, FastTan, FastTan, FastTan);
  TestT( 4000, System.Tangent( 4000), FastTan, FastTan, FastTan, FastTan, 0.08);
  TestT(-4000, System.Tangent(-4000), FastTan, FastTan, FastTan, FastTan, 0.08);
end;

procedure TTrigFunctionsTests.TestRadians;
begin
  TestT(-360, -6.28318, Radians, Radians, Radians, Radians);
  TestT(-270, -4.71238, Radians, Radians, Radians, Radians);
  TestT(-180, -3.14159, Radians, Radians, Radians, Radians);
  TestT( -90, -1.57079, Radians, Radians, Radians, Radians);
  TestT(   0,  0.00000, Radians, Radians, Radians, Radians);
  TestT(  90,  1.57079, Radians, Radians, Radians, Radians);
  TestT( 180,  3.14159, Radians, Radians, Radians, Radians);
  TestT( 270,  4.71238, Radians, Radians, Radians, Radians);
  TestT( 360,  6.28318, Radians, Radians, Radians, Radians);

  TestT( SMALL_VALUE, DegToRad( SMALL_VALUE), Radians, Radians, Radians, Radians);
  TestT(-SMALL_VALUE, DegToRad(-SMALL_VALUE), Radians, Radians, Radians, Radians);
  TestT( MEDIUM_VALUE, DegToRad( MEDIUM_VALUE), Radians, Radians, Radians, Radians);
  TestT(-MEDIUM_VALUE, DegToRad(-MEDIUM_VALUE), Radians, Radians, Radians, Radians);
  TestT( LARGE_VALUE, DegToRad( LARGE_VALUE), Radians, Radians, Radians, Radians);
  TestT(-LARGE_VALUE, DegToRad(-LARGE_VALUE), Radians, Radians, Radians, Radians);
end;

procedure TTrigFunctionsTests.TestSin;
begin
  TestT(Radians(-360),  0, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians(-270),  1, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians(-180),  0, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians( -90), -1, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians(   0),  0, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians(  90),  1, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians( 180),  0, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians( 270), -1, Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(Radians( 360),  0, Neslib.FastMath.Sin, Sin, Sin, Sin);

  TestT( SMALL_VALUE, System.Sin( SMALL_VALUE), Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(-SMALL_VALUE, System.Sin(-SMALL_VALUE), Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT( MEDIUM_VALUE, System.Sin( MEDIUM_VALUE), Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(-MEDIUM_VALUE, System.Sin(-MEDIUM_VALUE), Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT( LARGE_VALUE, System.Sin( LARGE_VALUE), Neslib.FastMath.Sin, Sin, Sin, Sin);
  TestT(-LARGE_VALUE, System.Sin(-LARGE_VALUE), Neslib.FastMath.Sin, Sin, Sin, Sin);
end;

procedure TTrigFunctionsTests.TestSinCos;
begin
  TestToToT(Radians(-360),  0,  1, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians(-270),  1,  0, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians(-180),  0, -1, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians( -90), -1,  0, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians(   0),  0,  1, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians(  90),  1,  0, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians( 180),  0, -1, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians( 270), -1,  0, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(Radians( 360),  0,  1, Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);

  TestToToT( SMALL_VALUE, System.Sin( SMALL_VALUE), System.Cos( SMALL_VALUE), Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(-SMALL_VALUE, System.Sin(-SMALL_VALUE), System.Cos(-SMALL_VALUE), Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT( MEDIUM_VALUE, System.Sin( MEDIUM_VALUE), System.Cos( MEDIUM_VALUE), Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(-MEDIUM_VALUE, System.Sin(-MEDIUM_VALUE), System.Cos(-MEDIUM_VALUE), Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT( LARGE_VALUE, System.Sin( LARGE_VALUE), System.Cos( LARGE_VALUE), Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
  TestToToT(-LARGE_VALUE, System.Sin(-LARGE_VALUE), System.Cos(-LARGE_VALUE), Neslib.FastMath.SinCos, SinCos, SinCos, SinCos);
end;

procedure TTrigFunctionsTests.TestSinh;
begin
  TestT(-1, -1.17520, Neslib.FastMath.Sinh, Sinh, Sinh, Sinh);
  TestT( 0,  0.00000, Neslib.FastMath.Sinh, Sinh, Sinh, Sinh);
  TestT( 1,  1.17520, Neslib.FastMath.Sinh, Sinh, Sinh, Sinh);

  TestT( SMALL_VALUE, System.Math.Sinh( SMALL_VALUE), Neslib.FastMath.Sinh, Sinh, Sinh, Sinh);
  TestT(-SMALL_VALUE, System.Math.Sinh(-SMALL_VALUE), Neslib.FastMath.Sinh, Sinh, Sinh, Sinh);
end;

procedure TTrigFunctionsTests.TestTan;
begin
  TestT(Radians(-180),  0, Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(Radians(-135),  1, Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(Radians( -45), -1, Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(Radians(   0),  0, Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(Radians(  45),  1, Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(Radians( 135), -1, Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(Radians( 180), -0, Neslib.FastMath.Tan, Tan, Tan, Tan);

  TestT( SMALL_VALUE, System.Tangent( SMALL_VALUE), Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(-SMALL_VALUE, System.Tangent(-SMALL_VALUE), Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT( MEDIUM_VALUE, System.Tangent( MEDIUM_VALUE), Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(-MEDIUM_VALUE, System.Tangent(-MEDIUM_VALUE), Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT( LARGE_VALUE, System.Tangent( LARGE_VALUE), Neslib.FastMath.Tan, Tan, Tan, Tan);
  TestT(-LARGE_VALUE, System.Tangent(-LARGE_VALUE), Neslib.FastMath.Tan, Tan, Tan, Tan);
end;

procedure TTrigFunctionsTests.TestTanh;
begin
  TestT(-1, -0.76159, Neslib.FastMath.Tanh, Tanh, Tanh, Tanh);
  TestT( 0,  0.00000, Neslib.FastMath.Tanh, Tanh, Tanh, Tanh);
  TestT( 1,  0.76159, Neslib.FastMath.Tanh, Tanh, Tanh, Tanh);

  TestT( SMALL_VALUE, System.Math.Tanh( SMALL_VALUE), Neslib.FastMath.Tanh, Tanh, Tanh, Tanh);
  TestT(-SMALL_VALUE, System.Math.Tanh(-SMALL_VALUE), Neslib.FastMath.Tanh, Tanh, Tanh, Tanh);
end;

end.
