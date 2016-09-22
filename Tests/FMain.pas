unit FMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Messaging,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  Neslib.FastMath,
  UnitTest,
  FastMath.TVector2.Tests,
  FastMath.TVector3.Tests,
  FastMath.TVector4.Tests,
  FastMath.TQuaternion.Tests,
  FastMath.TMatrix2.Tests,
  FastMath.TMatrix3.Tests,
  FastMath.TMatrix4.Tests,
  FastMath.TIVector2.Tests,
  FastMath.TIVector3.Tests,
  FastMath.TIVector4.Tests,
  FastMath.TrigFunctions.Tests,
  FastMath.ExponentialFunctions.Tests,
  FastMath.CommonFunctions.Tests,
  FastMath.MatrixFunctions.Tests,
  PerformanceTest,
  FastMath.TVector2.PerfTests,
  FastMath.TVector3.PerfTests,
  FastMath.TVector4.PerfTests,
  FastMath.TMatrix2.PerfTests,
  FastMath.TMatrix3.PerfTests,
  FastMath.TMatrix4.PerfTests,
  FastMath.Functions.Scalar.PerfTests,
  FastMath.Functions.TVector2.PerfTests,
  FastMath.Functions.TVector3.PerfTests,
  FastMath.Functions.TVector4.PerfTests,
  System.TPointF.PerfTests,
  System.TPoint3D.PerfTests,
  System.TVector3D.PerfTests,
  System.TMatrix.PerfTests,
  System.TMatrix3D.PerfTests,
  System.Functions.TPointF.PerfTests,
  System.Functions.TPoint3D.PerfTests,
  System.Functions.TVector3D.PerfTests;

type
  TFormMain = class(TForm)
    ButtonUnitTests: TButton;
    Memo: TMemo;
    GridPanelLayout: TGridPanelLayout;
    ButtonPerformanceTests: TButton;
    procedure ButtonUnitTestsClick(Sender: TObject);
    procedure ButtonPerformanceTestsClick(Sender: TObject);
  private
    { Private declarations }
    FCSVWriter: TStreamWriter;
    FResults: TStringList;
    procedure TestFailedListener(const Sender: TObject; const M: TMessage);
    procedure PerformanceTestListener(const Sender: TObject; const M: TMessage);
    procedure ScrollToEnd;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormMain: TFormMain;

const
  UNIT_TESTS: array [0..13] of TUnitTestClass = (
    TVector2Tests, TVector3Tests, TVector4Tests, TQuaternionTests,
    TMatrix2Tests, TMatrix3Tests, TMatrix4Tests,
    TIVector2Tests, TIVector3Tests, TIVector4Tests,
    TTrigFunctionsTests, TExponentialFunctionsTests,
    TCommonFunctionsTests, TMatrixFunctionsTests);{}

const
  PERFORMANCE_TESTS: array [0..17] of TPerformanceTestClass = (
    TPointFPerfTests, TVector2PerfTests,
    TPoint3DPerfTests, TVector3PerfTests,
    TVector3DPerfTests, TVector4PerfTests,
    TMatrix2PerfTests,
    TMatrixPerfTests, TMatrix3PerfTests,
    TMatrix3DPerfTests, TMatrix4PerfTests,
    TFunctionsScalarPerfTests,
    TFunctionsPointFPerfTests, TFunctionsVector2PerfTests,
    TFunctionsPoint3DPerfTests, TFunctionsVector3PerfTests,
    TFunctionsVector3DPerfTests, TFunctionsVector4PerfTests);{}

{const
  UNIT_TESTS: array [0..0] of TUnitTestClass = (
    TExponentialFunctionsTests);{}

{const
  PERFORMANCE_TESTS: array [0..0] of TPerformanceTestClass = (
    TVector2PerfTests);{}

implementation

uses
  System.Math,
  System.IOUtils;

{$R *.fmx}

{ TFormMain }

procedure TFormMain.ButtonPerformanceTestsClick(Sender: TObject);
var
  CSVPath: String;
  Thread: TPerformanceTestThread;
  NumTests: Integer;
begin
  Memo.Lines.Clear;
  Memo.Lines.Add('Testing. Please wait...');
  FCSVWriter := nil;
  FResults := nil;
  GridPanelLayout.Enabled := False;
  Application.ProcessMessages;
  try
    CSVPath := FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now);
    CSVPath := 'FastMath-' + CSVPath + '.csv';
    CSVPath := TPath.Combine(TPath.GetDocumentsPath, CSVPath);
    FCSVWriter := TStreamWriter.Create(CSVPath);

    FResults := TStringList.Create;

    Thread := TPerformanceTestThread.Create(False);
    try
      Thread.WaitFor;
      NumTests := Thread.NumTests;
    finally
      Thread.DisposeOf;
    end;

    Memo.Lines := FResults;
    Memo.Lines.Add(Format('%d tests completed.', [NumTests]));
    ScrollToEnd;
  finally
    FResults.Free;
    FCSVWriter.Free;
    GridPanelLayout.Enabled := True;
  end;
end;

procedure TFormMain.ButtonUnitTestsClick(Sender: TObject);
var
  UnitTestClass: TUnitTestClass;
  UnitTest: TUnitTest;
  NumFailed, NumPassed: Integer;
begin
  Memo.Lines.Clear;
  GridPanelLayout.Enabled := False;
  try
    NumFailed := 0;
    NumPassed := 0;
    for UnitTestClass in UNIT_TESTS do
    begin
      UnitTest := UnitTestClass.Create;
      try
        UnitTest.Run;
        Inc(NumFailed, UnitTest.ChecksFailed);
        Inc(NumPassed, UnitTest.ChecksPassed);
      finally
        UnitTest.Free;
      end;
    end;
    Memo.Lines.Add(Format('%d checks completed. %d passed, %d failed',
      [NumPassed + NumFailed, NumPassed, NumFailed]));
  finally
    GridPanelLayout.Enabled := True;
  end;
end;

constructor TFormMain.Create(AOwner: TComponent);
begin
  inherited;
  ReportMemoryLeaksOnShutdown := True;
  DisableFloatingPointExceptions;
  TMessageManager.DefaultManager.SubscribeToMessage(TTestFailedMessage, TestFailedListener);
  TMessageManager.DefaultManager.SubscribeToMessage(TPerformanceTestMessage, PerformanceTestListener);
end;

destructor TFormMain.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TPerformanceTestMessage, PerformanceTestListener);
  TMessageManager.DefaultManager.Unsubscribe(TTestFailedMessage, TestFailedListener);
  inherited;
end;

procedure TFormMain.PerformanceTestListener(const Sender: TObject;
  const M: TMessage);
var
  PerfTestMsg: TPerformanceTestMessage absolute M;
begin
  Assert(M is TPerformanceTestMessage);
  FResults.Add(Format('%s: %.3f ms',
    [PerfTestMsg.TestName, PerfTestMsg.DurationInMilliseconds]));

  if Assigned(FCSVWriter) then
    FCSVWriter.WriteLine('"%s", %.3f',
      [PerfTestMsg.TestName, PerfTestMsg.DurationInMilliseconds]);
end;

procedure TFormMain.ScrollToEnd;
begin
  Memo.SelStart := Memo.Text.Length;
end;

procedure TFormMain.TestFailedListener(const Sender: TObject;
  const M: TMessage);
var
  FailedMsg: TTestFailedMessage absolute M;
begin
  Assert(M is TTestFailedMessage);
  Memo.Lines.Add(Format('%s.%s: %s',
    [FailedMsg.TestClassName, FailedMsg.TestMethodName, FailedMsg.Message]));
  ScrollToEnd;
  Application.ProcessMessages;
end;

end.
