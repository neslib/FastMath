program FastMathTests;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMain in 'FMain.pas' {FormMain},
  UnitTest in 'UnitTests\UnitTest.pas',
  PerformanceTest in 'PerformanceTests\PerformanceTest.pas',
  FastMath.CommonFunctions.Tests in 'UnitTests\FastMath.CommonFunctions.Tests.pas',
  FastMath.ExponentialFunctions.Tests in 'UnitTests\FastMath.ExponentialFunctions.Tests.pas',
  FastMath.MatrixFunctions.Tests in 'UnitTests\FastMath.MatrixFunctions.Tests.pas',
  FastMath.TMatrix2.Tests in 'UnitTests\FastMath.TMatrix2.Tests.pas',
  FastMath.TMatrix3.Tests in 'UnitTests\FastMath.TMatrix3.Tests.pas',
  FastMath.TMatrix4.Tests in 'UnitTests\FastMath.TMatrix4.Tests.pas',
  FastMath.TrigFunctions.Tests in 'UnitTests\FastMath.TrigFunctions.Tests.pas',
  FastMath.TVector2.Tests in 'UnitTests\FastMath.TVector2.Tests.pas',
  FastMath.TVector3.Tests in 'UnitTests\FastMath.TVector3.Tests.pas',
  FastMath.TVector4.Tests in 'UnitTests\FastMath.TVector4.Tests.pas',
  FastMath.Functions.Scalar.PerfTests in 'PerformanceTests\FastMath.Functions.Scalar.PerfTests.pas',
  FastMath.Functions.TVector2.PerfTests in 'PerformanceTests\FastMath.Functions.TVector2.PerfTests.pas',
  FastMath.Functions.TVector3.PerfTests in 'PerformanceTests\FastMath.Functions.TVector3.PerfTests.pas',
  FastMath.Functions.TVector4.PerfTests in 'PerformanceTests\FastMath.Functions.TVector4.PerfTests.pas',
  FastMath.TMatrix2.PerfTests in 'PerformanceTests\FastMath.TMatrix2.PerfTests.pas',
  FastMath.TMatrix3.PerfTests in 'PerformanceTests\FastMath.TMatrix3.PerfTests.pas',
  FastMath.TMatrix4.PerfTests in 'PerformanceTests\FastMath.TMatrix4.PerfTests.pas',
  FastMath.TVector2.PerfTests in 'PerformanceTests\FastMath.TVector2.PerfTests.pas',
  FastMath.TVector3.PerfTests in 'PerformanceTests\FastMath.TVector3.PerfTests.pas',
  FastMath.TVector4.PerfTests in 'PerformanceTests\FastMath.TVector4.PerfTests.pas',
  System.TPointF.PerfTests in 'PerformanceTests\System.TPointF.PerfTests.pas',
  System.Functions.TPointF.PerfTests in 'PerformanceTests\System.Functions.TPointF.PerfTests.pas',
  System.TPoint3D.PerfTests in 'PerformanceTests\System.TPoint3D.PerfTests.pas',
  System.Functions.TPoint3D.PerfTests in 'PerformanceTests\System.Functions.TPoint3D.PerfTests.pas',
  System.TVector3D.PerfTests in 'PerformanceTests\System.TVector3D.PerfTests.pas',
  System.Functions.TVector3D.PerfTests in 'PerformanceTests\System.Functions.TVector3D.PerfTests.pas',
  System.TMatrix3D.PerfTests in 'PerformanceTests\System.TMatrix3D.PerfTests.pas',
  System.TMatrix.PerfTests in 'PerformanceTests\System.TMatrix.PerfTests.pas',
  FastMath.TQuaternion.Tests in 'UnitTests\FastMath.TQuaternion.Tests.pas',
  FastMath.TIVector2.Tests in 'UnitTests\FastMath.TIVector2.Tests.pas',
  FastMath.TIVector3.Tests in 'UnitTests\FastMath.TIVector3.Tests.pas',
  FastMath.TIVector4.Tests in 'UnitTests\FastMath.TIVector4.Tests.pas',
  Neslib.FastMath in '..\FastMath\Neslib.FastMath.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
