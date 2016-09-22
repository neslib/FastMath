unit PerformanceTest;

interface

uses
  System.Types,
  System.Classes,
  System.Math.Vectors,
  System.Messaging,
  Neslib.FastMath;

type
  TPerformanceTestMessage = class(TMessage)
  {$REGION 'Internal Declarations'}
  private
    FTestName: String;
    FDurationInMilliseconds: Double;
  {$ENDREGION 'Internal Declarations'}
  public
    constructor Create(const ATestName: String;
      const ADurationInMilliseconds: Double);

    property TestName: String read FTestName;
    property DurationInMilliseconds: Double read FDurationInMilliseconds;
  end;

type
  TestNameAttribute = class(TCustomAttribute)
  {$REGION 'Internal Declarations'}
  private
    FTestName: String;
    FTimeScale: Integer;
  {$ENDREGION 'Internal Declarations'}
  public
    constructor Create(const ATestName: String; const ATimeScale: Integer = 1);

    property TestName: String read FTestName;
    property TimeScale: Integer read FTimeScale;
  end;

type
  {$M+}
  TPerformanceTest = class abstract
  protected const
    {$IFDEF CPUARM}
    LOOP_COUNT_SMALL = 100000;
    LOOP_COUNT_LARGE = 1000000;
    {$ELSE}
    LOOP_COUNT_SMALL = 1000000;
    LOOP_COUNT_LARGE = 10000000;
    {$ENDIF}
  protected
    procedure Setup; virtual;
  public
    constructor Create; virtual;
    function Run: Integer;
  end;
  TPerformanceTestClass = class of TPerformanceTest;
  {$M-}

type
  TPerformanceTestThread = class(TThread)
  private
    FNumTests: Integer;
  protected
    procedure Execute; override;
  public
    property NumTests: Integer read FNumTests;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  System.Rtti,
  System.TypInfo,
  System.SysUtils,
  System.Diagnostics,
  FMain;

type
  TTestMethod = procedure of Object;

{ TPerformanceTestMessage }

constructor TPerformanceTestMessage.Create(const ATestName: String;
  const ADurationInMilliseconds: Double);
begin
  inherited Create;
  FTestName := ATestName;
  FDurationInMilliseconds := ADurationInMilliseconds;
end;

{ TestNameAttribute }

constructor TestNameAttribute.Create(const ATestName: String;
  const ATimeScale: Integer);
begin
  inherited Create;
  FTestName := ATestName;
  FTimeScale := ATimeScale;
end;

{ TPerformanceTest }

constructor TPerformanceTest.Create;
begin
  inherited;
end;

function TPerformanceTest.Run: Integer;
var
  Context: TRttiContext;
  TestType: TRttiType;
  Method: TRttiMethod;
  TestMethod: TTestMethod;
  TestMethodRec: TMethod absolute TestMethod;
  Stopwatch: TStopwatch;
  MilliSeconds: Double;
  Attr: TCustomAttribute;
  TestName: String;
  TimeScale: Integer;
begin
  Result := 0;
  Context := TRttiContext.Create;
  TestType := Context.GetType(ClassType);
  if (TestType = nil) then
    raise Exception.Create('Internal test error: cannot get class type');

  TestMethodRec.Data := Self;
  for Method in TestType.GetMethods do
  begin
    if (Method.Visibility = TMemberVisibility.mvPublished)
      and (Method.ReturnType = nil) and (Method.GetParameters = nil)
      and (not Method.IsConstructor) and (not Method.IsDestructor)
      and (not Method.IsClassMethod) and (not Method.IsStatic) then
    begin
      TestMethodRec.Code := Method.CodeAddress;

      TestName := '';
      TimeScale := 1;
      for Attr in Method.GetAttributes do
      begin
        if (Attr is TestNameAttribute) then
        begin
          TestName := TestNameAttribute(Attr).TestName;
          TimeScale := TestNameAttribute(Attr).TimeScale;
        end;
      end;
      if (TestName = '') then
        TestName := ClassName + '.' + Method.Name;

      Setup;
      Stopwatch := TStopwatch.StartNew;
      TestMethod();
      MilliSeconds := Stopwatch.Elapsed.TotalMilliseconds;

      TMessageManager.DefaultManager.SendMessage(Self,
        TPerformanceTestMessage.Create(TestName, MilliSeconds * TimeScale));

      Inc(Result);
    end;
  end;
end;

procedure TPerformanceTest.Setup;
begin
  { No default implementation }
end;

{ TPerformanceTestThread }

procedure TPerformanceTestThread.Execute;
var
  PerfTestClass: TPerformanceTestClass;
  PerfTest: TPerformanceTest;
  NumTests: Integer;
begin
  {$IFDEF MSWINDOWS}
  { Run performance tests on a single core with highest priority }
  SetThreadAffinityMask(GetCurrentThread, 1 shl 2);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_HIGHEST);
  {$ENDIF}
  DisableFloatingPointExceptions; // For this thread
  NumTests := 0;
  for PerfTestClass in PERFORMANCE_TESTS do
  begin
    PerfTest := PerfTestClass.Create;
    try
      Inc(NumTests, PerfTest.Run);
    finally
      PerfTest.Free;
    end;
  end;
  FNumTests := NumTests;
end;

end.
