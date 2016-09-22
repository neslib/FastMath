unit UnitTest;

interface

uses
  System.SysUtils,
  System.Messaging,
  System.Math.Vectors,
  Neslib.FastMath;

type
  TTestFailedMessage = class(TMessage)
  {$REGION 'Internal Declarations'}
  private
    FTestClassName: String;
    FTestMethodName: String;
    FMessage: String;
  {$ENDREGION 'Internal Declarations'}
  public
    constructor Create(const ATestClassName, ATestMethodName, AMessage: String);

    property TestClassName: String read FTestClassName;
    property TestMethodName: String read FTestMethodName;
    property Message: String read FMessage;
  end;

type
  TFuncT<T> = function(const A: T): T;
  TFuncTT<T> = function(const A, B: T): T;
  TFuncTTT<T> = function(const A, B, C: T): T;
  TFuncTF<T> = function(const A: T; const B: Single): T;
  TFuncTFF<T> = function(const A: T; const B, C: Single): T;
  TFuncTTF<T> = function(const A, B: T; const C: Single): T;
  TFuncFT<T> = function(const A: Single; const B: T): T;
  TFuncFFT<T> = function(const A, B: Single; const C: T): T;
  TFuncToT<T> = function(const A: T; out B: T): T;
  TProcToToT<T> = procedure(const A: T; out B, C: T);
  TFuncTrU<T, U> = function(const A: T): U;
  TFuncToU<T, U> = function(const A: T; out B: U): T;

type
  {$M+}
  TUnitTest = class
  {$REGION 'Internal Declarations'}
  protected const
    { Value used to test calculations of small values }
    SMALL_VALUE: Single = 1.23e-12;

    { Value used to test calculations of medium size values. The integral part
      of this value fits into a signed 32-bit integer. It this magnitude, a
      single-precision floating-point value is only accurate at 1 decimal
      digit. }
    MEDIUM_VALUE: Single = 987654.3125;

    { Value used to test calculations of large values. At this magnitude, a
      single-precision floating-point value cannot accurately represent integer
      values anymore (let alone fractional values). In fact, the value below
      actually represents 1234567954432. }
    LARGE_VALUE: Single = 1234567890987;
  private
    FCurrentTestMethodName: String;
    FChecksPassed: Integer;
    FChecksFailed: Integer;
    FChecksTotal: Integer;
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure Fail(const AMsg: String); overload;
    procedure Fail(const AMsg: String; const AArgs: array of const); overload;

    procedure CheckEquals(const AExpected, AActual: Integer;
      const AMsg: String = ''); overload;
    procedure CheckEquals(const AExpected, AActual: Single;
      const AMsg: String = ''; const AEpsilon: Single = 0); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY: Single;
      const AActual: TVector2; const AEpsilon: Single = 0); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY: Integer;
      const AActual: TIVector2); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY, AExpectedZ: Single;
      const AActual: TVector3; const AEpsilon: Single = 0); overload;
    procedure CheckEquals(const AExpected: TVector;
      const AActual: TVector3; const AEpsilon: Single = 0); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY, AExpectedZ: Integer;
      const AActual: TIVector3); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY, AExpectedZ,
      AExpectedW: Single; const AActual: TVector4; const AEpsilon: Single = 0); overload;
    procedure CheckEquals(const AExpected: TVector3D;
      const AActual: TVector4; const AEpsilon: Single = 0); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY, AExpectedZ,
      AExpectedW: Integer; const AActual: TIVector4); overload;
    procedure CheckEquals(const AExpectedX, AExpectedY, AExpectedZ,
      AExpectedW: Single; const AActual: TQuaternion; const AEpsilon: Single = 0); overload;

    procedure CheckTrue(const ACondition: Boolean);
    procedure CheckFalse(const ACondition: Boolean);
  protected
    procedure TestT(const A, AExp: Single;
      const AFuncFloat: TFuncT<Single>; const AFuncVec2: TFuncT<TVector2>;
      const AFuncVec3: TFuncT<TVector3>; const AFuncVec4: TFuncT<TVector4>;
      const AEpsilon: Single = 0);

    procedure TestTT(const A, B, AExp: Single;
      const AFuncFloat: TFuncTT<Single>; const AFuncVec2: TFuncTT<TVector2>;
      const AFuncVec3: TFuncTT<TVector3>; const AFuncVec4: TFuncTT<TVector4>;
      const AEpsilon: Single = 0);

    procedure TestTTT(const A, B, C, AExp: Single;
      const AFuncFloat: TFuncTTT<Single>; const AFuncVec2: TFuncTTT<TVector2>;
      const AFuncVec3: TFuncTTT<TVector3>; const AFuncVec4: TFuncTTT<TVector4>);

    procedure TestTF(const A, B, AExp: Single;
      const AFuncFloat: TFuncTF<Single>; const AFuncVec2: TFuncTF<TVector2>;
      const AFuncVec3: TFuncTF<TVector3>; const AFuncVec4: TFuncTF<TVector4>);

    procedure TestTFF(const A, B, C, AExp: Single;
      const AFuncFloat: TFuncTFF<Single>; const AFuncVec2: TFuncTFF<TVector2>;
      const AFuncVec3: TFuncTFF<TVector3>; const AFuncVec4: TFuncTFF<TVector4>);

    procedure TestTTF(const A, B, C, AExp: Single;
      const AFuncFloat: TFuncTTF<Single>; const AFuncVec2: TFuncTTF<TVector2>;
      const AFuncVec3: TFuncTTF<TVector3>; const AFuncVec4: TFuncTTF<TVector4>);

    procedure TestFT(const A, B, AExp: Single;
      const AFuncFloat: TFuncFT<Single>; const AFuncVec2: TFuncFT<TVector2>;
      const AFuncVec3: TFuncFT<TVector3>; const AFuncVec4: TFuncFT<TVector4>);

    procedure TestFFT(const A, B, C, AExp: Single;
      const AFuncFloat: TFuncFFT<Single>; const AFuncVec2: TFuncFFT<TVector2>;
      const AFuncVec3: TFuncFFT<TVector3>; const AFuncVec4: TFuncFFT<TVector4>);

    procedure TestToT(const A, AExp, AOut: Single;
      const AFuncFloat: TFuncToT<Single>; const AFuncVec2: TFuncToT<TVector2>;
      const AFuncVec3: TFuncToT<TVector3>; const AFuncVec4: TFuncToT<TVector4>);

    procedure TestToToT(const A, AExpB, AExpC: Single;
      const AFuncFloat: TProcToToT<Single>; const AFuncVec2: TProcToToT<TVector2>;
      const AFuncVec3: TProcToToT<TVector3>; const AFuncVec4: TProcToToT<TVector4>);

    procedure TestTrU(const A: Single; const AExp: Integer;
      const AFuncFloat: TFuncTrU<Single, Integer>;
      const AFuncVec2: TFuncTrU<TVector2, TIVector2>;
      const AFuncVec3: TFuncTrU<TVector3, TIVector3>;
      const AFuncVec4: TFuncTrU<TVector4, TIVector4>);

    procedure TestToU(const A, AExp: Single; const AOut: Integer;
      const AFuncFloat: TFuncToU<Single, Integer>;
      const AFuncVec2: TFuncToU<TVector2, TIVector2>;
      const AFuncVec3: TFuncToU<TVector3, TIVector3>;
      const AFuncVec4: TFuncToU<TVector4, TIVector4>);
  public
    constructor Create; virtual;
    procedure Run;

    property ChecksPassed: Integer read FChecksPassed;
    property ChecksFailed: Integer read FChecksFailed;
  end;
  TUnitTestClass = class of TUnitTest;
  {$M-}

implementation

uses
  System.Math,
  System.Rtti,
  System.TypInfo;

{ TTestFailedMessage }

constructor TTestFailedMessage.Create(const ATestClassName, ATestMethodName,
  AMessage: String);
begin
  inherited Create;
  FTestClassName := ATestClassName;
  FTestMethodName := ATestMethodName;
  FMessage := AMessage;
end;

{ TUnitTest }

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY: Single;
  const AActual: TVector2; const AEpsilon: Single);
begin
  CheckEquals(AExpectedX, AActual.X, 'X', AEpsilon);
  CheckEquals(AExpectedY, AActual.Y, 'Y', AEpsilon);
end;

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY,
  AExpectedZ: Single; const AActual: TVector3; const AEpsilon: Single);
begin
  CheckEquals(AExpectedX, AActual.X, 'X', AEpsilon);
  CheckEquals(AExpectedY, AActual.Y, 'Y', AEpsilon);
  CheckEquals(AExpectedZ, AActual.Z, 'Z', AEpsilon);
end;

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY, AExpectedZ,
  AExpectedW: Single; const AActual: TVector4; const AEpsilon: Single);
begin
  CheckEquals(AExpectedX, AActual.X, 'X', AEpsilon);
  CheckEquals(AExpectedY, AActual.Y, 'Y', AEpsilon);
  CheckEquals(AExpectedZ, AActual.Z, 'Z', AEpsilon);
  CheckEquals(AExpectedW, AActual.W, 'W', AEpsilon);
end;

procedure TUnitTest.CheckEquals(const AExpected, AActual: Integer;
  const AMsg: String);
begin
  Inc(FChecksTotal);
  if (AExpected <> AActual) then
    Fail('%s: Expected: %d, Actual: %d', [AMsg, AExpected, AActual]);
end;

procedure TUnitTest.CheckEquals(const AExpected, AActual: Single;
  const AMsg: String; const AEpsilon: Single);
var
  ExpectedIsExtreme, ActualIsExtreme, OK: Boolean;
begin
  Inc(FChecksTotal);

  { FastMath treats all extreme values (Infinite and Nan) the same. }
  ExpectedIsExtreme := IsInfinite(AExpected) or IsNan(AExpected);
  ActualIsExtreme := IsInfinite(AActual) or IsNan(AActual);
  if (ExpectedIsExtreme) then
    OK := ActualIsExtreme
  else if (ActualIsExtreme) then
    OK := ExpectedIsExtreme
  else if (AEpsilon = 0) then
    OK := SameValue(AExpected, AActual)
  else
    OK := (Abs(AExpected - AActual) <= AEpsilon);

  if (not OK) then
    Fail('%s: Expected: %.6f, Actual: %.6f', [AMsg, AExpected, AActual]);
end;

procedure TUnitTest.CheckFalse(const ACondition: Boolean);
begin
  Inc(FChecksTotal);
  if (ACondition) then
    Fail('Expected False but was True');
end;

procedure TUnitTest.CheckTrue(const ACondition: Boolean);
begin
  Inc(FChecksTotal);
  if (not ACondition) then
    Fail('Expected True but was False');
end;

constructor TUnitTest.Create;
begin
  inherited;
end;

procedure TUnitTest.Fail(const AMsg: String; const AArgs: array of const);
begin
  Fail(Format(AMsg, AArgs));
end;

procedure TUnitTest.Fail(const AMsg: String);
begin
  Inc(FChecksFailed);
  TMessageManager.DefaultManager.SendMessage(Self,
    TTestFailedMessage.Create(ClassName, FCurrentTestMethodName, AMsg));
end;

procedure TUnitTest.Run;
var
  Context: TRttiContext;
  TestType: TRttiType;
  Method: TRttiMethod;
begin
  FChecksPassed := 0;
  FChecksFailed := 0;
  FChecksTotal := 0;
  FCurrentTestMethodName := '';
  Context := TRttiContext.Create;
  TestType := Context.GetType(ClassType);
  if (TestType = nil) then
    Fail('Internal test error: cannot get test class type');

  for Method in TestType.GetMethods do
  begin
    if (Method.Visibility = TMemberVisibility.mvPublished)
      and (Method.ReturnType = nil) and (Method.GetParameters = nil)
      and (not Method.IsConstructor) and (not Method.IsDestructor)
      and (not Method.IsClassMethod) and (not Method.IsStatic) then
    begin
      FCurrentTestMethodName := Method.Name;
      Method.Invoke(Self, []);
    end;
  end;
  FChecksPassed := FChecksTotal - FChecksFailed;
end;

procedure TUnitTest.TestFFT(const A, B, C, AExp: Single;
  const AFuncFloat: TFuncFFT<Single>; const AFuncVec2: TFuncFFT<TVector2>;
  const AFuncVec3: TFuncFFT<TVector3>; const AFuncVec4: TFuncFFT<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B, C);
  CheckEquals(AExp, S);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(A, B, Vector2(C, C));
  CheckEquals(AExp, AExp, V2);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(A, B, Vector3(C, C, C));
  CheckEquals(AExp, AExp, AExp, V3);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(A, B, Vector4(C, C, C, C));
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.TestFT(const A, B, AExp: Single;
  const AFuncFloat: TFuncFT<Single>; const AFuncVec2: TFuncFT<TVector2>;
  const AFuncVec3: TFuncFT<TVector3>; const AFuncVec4: TFuncFT<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B);
  CheckEquals(AExp, S);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(A, Vector2(B, B));
  CheckEquals(AExp, AExp, V2);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(A, Vector3(B, B, B));
  CheckEquals(AExp, AExp, AExp, V3);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(A, Vector4(B, B, B, B));
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.TestT(const A, AExp: Single;
  const AFuncFloat: TFuncT<Single>; const AFuncVec2: TFuncT<TVector2>;
  const AFuncVec3: TFuncT<TVector3>; const AFuncVec4: TFuncT<TVector4>;
  const AEpsilon: Single);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  { We use the (seemingly unnecessary) variables S, V2, V3 and V4 here to make
    sure the CPU/FPU/SIMD registers don't "accidentally" have correct values. }
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A);
  CheckEquals(AExp, S, '', AEpsilon);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A));
  CheckEquals(AExp, AExp, V2, AEpsilon);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A));
  CheckEquals(AExp, AExp, AExp, V3, AEpsilon);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A));
  CheckEquals(AExp, AExp, AExp, AExp, V4, AEpsilon);
end;

procedure TUnitTest.TestTF(const A, B, AExp: Single;
  const AFuncFloat: TFuncTF<Single>; const AFuncVec2: TFuncTF<TVector2>;
  const AFuncVec3: TFuncTF<TVector3>; const AFuncVec4: TFuncTF<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B);
  CheckEquals(AExp, S);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A), B);
  CheckEquals(AExp, AExp, V2);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A), B);
  CheckEquals(AExp, AExp, AExp, V3);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A), B);
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.TestTFF(const A, B, C, AExp: Single;
  const AFuncFloat: TFuncTFF<Single>; const AFuncVec2: TFuncTFF<TVector2>;
  const AFuncVec3: TFuncTFF<TVector3>; const AFuncVec4: TFuncTFF<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B, C);
  CheckEquals(AExp, S);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A), B, C);
  CheckEquals(AExp, AExp, V2);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A), B, C);
  CheckEquals(AExp, AExp, AExp, V3);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A), B, C);
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.TestToT(const A, AExp, AOut: Single;
  const AFuncFloat: TFuncToT<Single>; const AFuncVec2: TFuncToT<TVector2>;
  const AFuncVec3: TFuncToT<TVector3>; const AFuncVec4: TFuncToT<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(AExp, AFuncFloat(A, S));
  CheckEquals(S, AOut);

  V2 := Vector2(0, 0);
  CheckEquals(AExp, AExp,
    AFuncVec2(Vector2(A, A), V2));
  CheckEquals(V2.X, V2.Y, Vector2(AOut, AOut));

  V3 := Vector3(0, 0, 0);
  CheckEquals(AExp, AExp, AExp,
    AFuncVec3(Vector3(A, A, A), V3));
  CheckEquals(V3.X, V3.Y, V3.Z, Vector3(AOut, AOut, AOut));

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(AExp, AExp, AExp, AExp,
    AFuncVec4(Vector4(A, A, A, A), V4));
  CheckEquals(V4.X, V4.Y, V4.Z, V4.W, Vector4(AOut, AOut, AOut, AOut));
end;

procedure TUnitTest.TestToToT(const A, AExpB, AExpC: Single;
  const AFuncFloat: TProcToToT<Single>; const AFuncVec2: TProcToToT<TVector2>;
  const AFuncVec3: TProcToToT<TVector3>; const AFuncVec4: TProcToToT<TVector4>);
var
  BF, CF: Single;
  B2, C2: TVector2;
  B3, C3: TVector3;
  B4, C4: TVector4;
begin
  BF := 0; CF := 0;
  AFuncFloat(A, BF, CF);
  CheckEquals(AExpB, BF);
  CheckEquals(AExpC, CF);

  B2 := Vector2(0, 0); C2 := Vector2(0, 0);
  AFuncVec2(Vector2(A, A), B2, C2);
  CheckEquals(AExpB, AExpB, B2);
  CheckEquals(AExpC, AExpC, C2);

  B3 := Vector3(0, 0, 0); C3 := Vector3(0, 0, 0);
  AFuncVec3(Vector3(A, A, A), B3, C3);
  CheckEquals(AExpB, AExpB, AExpB, B3);
  CheckEquals(AExpC, AExpC, AExpC, C3);

  B4 := Vector4(0, 0, 0, 0); C4 := Vector4(0, 0, 0, 0);
  AFuncVec4(Vector4(A, A, A, A), B4, C4);
  CheckEquals(AExpB, AExpB, AExpB, AExpB, B4);
  CheckEquals(AExpC, AExpC, AExpC, AExpC, C4);
end;

procedure TUnitTest.TestToU(const A, AExp: Single; const AOut: Integer;
  const AFuncFloat: TFuncToU<Single, Integer>;
  const AFuncVec2: TFuncToU<TVector2, TIVector2>;
  const AFuncVec3: TFuncToU<TVector3, TIVector3>;
  const AFuncVec4: TFuncToU<TVector4, TIVector4>);
var
  I: Integer;
  V2, V2O: TIVector2;
  V3, V3O: TIVector3;
  V4, V4O: TIVector4;
begin
  I := 0;
  CheckEquals(AExp, AFuncFloat(A, I));
  CheckEquals(I, AOut);

  V2.Init(0, 0);
  V2O.Init(AOut, AOut);
  CheckEquals(AExp, AExp,
    AFuncVec2(Vector2(A, A), V2));
  CheckEquals(V2O.X, V2O.Y, V2);

  V3.Init(0, 0, 0);
  V3O.Init(AOut, AOut, AOut);
  CheckEquals(AExp, AExp, AExp,
    AFuncVec3(Vector3(A, A, A), V3));
  CheckEquals(V3O.X, V3O.Y, V3O.Z, V3);

  V4.Init(0, 0, 0, 0);
  V4O.Init(AOut, AOut, AOut, AOut);
  CheckEquals(AExp, AExp, AExp, AExp,
    AFuncVec4(Vector4(A, A, A, A), V4));
  CheckEquals(V4O.X, V4O.Y, V4O.Z, V4O.W, V4);
end;

procedure TUnitTest.TestTrU(const A: Single; const AExp: Integer;
  const AFuncFloat: TFuncTrU<Single, Integer>;
  const AFuncVec2: TFuncTrU<TVector2, TIVector2>;
  const AFuncVec3: TFuncTrU<TVector3, TIVector3>;
  const AFuncVec4: TFuncTrU<TVector4, TIVector4>);
var
  I: Integer;
  V2: TIVector2;
  V3: TIVector3;
  V4: TIVector4;
begin
  I := 0;
  CheckEquals(0, I);
  I := AFuncFloat(A);
  CheckEquals(AExp, I);

  V2.Init(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A));
  CheckEquals(AExp, AExp, V2);

  V3.Init(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A));
  CheckEquals(AExp, AExp, AExp, V3);

  V4.Init(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A));
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.TestTT(const A, B, AExp: Single;
  const AFuncFloat: TFuncTT<Single>; const AFuncVec2: TFuncTT<TVector2>;
  const AFuncVec3: TFuncTT<TVector3>; const AFuncVec4: TFuncTT<TVector4>;
  const AEpsilon: Single);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B);
  CheckEquals(AExp, S, '', AEpsilon);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A), Vector2(B, B));
  CheckEquals(AExp, AExp, V2, AEpsilon);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A), Vector3(B, B, B));
  CheckEquals(AExp, AExp, AExp, V3, AEpsilon);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A), Vector4(B, B, B, B));
  CheckEquals(AExp, AExp, AExp, AExp, V4, AEpsilon);
end;

procedure TUnitTest.TestTTF(const A, B, C, AExp: Single;
  const AFuncFloat: TFuncTTF<Single>; const AFuncVec2: TFuncTTF<TVector2>;
  const AFuncVec3: TFuncTTF<TVector3>; const AFuncVec4: TFuncTTF<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B, C);
  CheckEquals(AExp, S);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A), Vector2(B, B), C);
  CheckEquals(AExp, AExp, V2);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A), Vector3(B, B, B), C);
  CheckEquals(AExp, AExp, AExp, V3);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A), Vector4(B, B, B, B), C);
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.TestTTT(const A, B, C, AExp: Single;
  const AFuncFloat: TFuncTTT<Single>; const AFuncVec2: TFuncTTT<TVector2>;
  const AFuncVec3: TFuncTTT<TVector3>; const AFuncVec4: TFuncTTT<TVector4>);
var
  S: Single;
  V2: TVector2;
  V3: TVector3;
  V4: TVector4;
begin
  S := 0;
  CheckEquals(0, S);
  S := AFuncFloat(A, B, C);
  CheckEquals(AExp, S);

  V2 := Vector2(0, 0);
  CheckEquals(0, V2.X);
  V2 := AFuncVec2(Vector2(A, A), Vector2(B, B), Vector2(C, C));
  CheckEquals(AExp, AExp, V2);

  V3 := Vector3(0, 0, 0);
  CheckEquals(0, V3.X);
  V3 := AFuncVec3(Vector3(A, A, A), Vector3(B, B, B), Vector3(C, C, C));
  CheckEquals(AExp, AExp, AExp, V3);

  V4 := Vector4(0, 0, 0, 0);
  CheckEquals(0, V4.X);
  V4 := AFuncVec4(Vector4(A, A, A, A), Vector4(B, B, B, B), Vector4(C, C, C, C));
  CheckEquals(AExp, AExp, AExp, AExp, V4);
end;

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY, AExpectedZ,
  AExpectedW: Single; const AActual: TQuaternion; const AEpsilon: Single);
begin
  CheckEquals(AExpectedX, AActual.X, 'X', AEpsilon);
  CheckEquals(AExpectedY, AActual.Y, 'Y', AEpsilon);
  CheckEquals(AExpectedZ, AActual.Z, 'Z', AEpsilon);
  CheckEquals(AExpectedW, AActual.W, 'W', AEpsilon);
end;

procedure TUnitTest.CheckEquals(const AExpected: TVector3D;
  const AActual: TVector4; const AEpsilon: Single);
begin
  CheckEquals(AExpected.X, AActual.X, 'X', AEpsilon);
  CheckEquals(AExpected.Y, AActual.Y, 'Y', AEpsilon);
  CheckEquals(AExpected.Z, AActual.Z, 'Z', AEpsilon);
  CheckEquals(AExpected.W, AActual.W, 'W', AEpsilon);
end;

procedure TUnitTest.CheckEquals(const AExpected: TVector;
  const AActual: TVector3; const AEpsilon: Single);
begin
  CheckEquals(AExpected.X, AActual.X, 'X', AEpsilon);
  CheckEquals(AExpected.Y, AActual.Y, 'Y', AEpsilon);
  CheckEquals(AExpected.W, AActual.Z, 'Z', AEpsilon);
end;

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY, AExpectedZ,
  AExpectedW: Integer; const AActual: TIVector4);
begin
  CheckEquals(AExpectedX, AActual.X, 'X');
  CheckEquals(AExpectedY, AActual.Y, 'Y');
  CheckEquals(AExpectedZ, AActual.Z, 'Z');
  CheckEquals(AExpectedW, AActual.W, 'W');
end;

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY,
  AExpectedZ: Integer; const AActual: TIVector3);
begin
  CheckEquals(AExpectedX, AActual.X, 'X');
  CheckEquals(AExpectedY, AActual.Y, 'Y');
  CheckEquals(AExpectedZ, AActual.Z, 'Z');
end;

procedure TUnitTest.CheckEquals(const AExpectedX, AExpectedY: Integer;
  const AActual: TIVector2);
begin
  CheckEquals(AExpectedX, AActual.X, 'X');
  CheckEquals(AExpectedY, AActual.Y, 'Y');
end;

end.
