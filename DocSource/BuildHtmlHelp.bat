@echo off
set FORMAT=HtmlHelp
set HHC="%ProgramFiles(x86)%\HTML Help Workshop\hhc"
set SEARCH=
call Build.bat
%HHC% ..\Doc\HtmlHelp\FastMath.hhp
copy ..\Doc\HtmlHelp\FastMath.chm ..\Doc\ /y
..\Doc\FastMath.chm
pause