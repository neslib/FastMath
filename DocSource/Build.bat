set PASCOC=..\..\PasDocEx\bin\pasdoc
set SOURCE=sources.txt
set OPTIONS=--name "FastMath" --title "FastMath" --auto-abstract --auto-link --visible-members public,published,automated --include "..\FastMath\"
del ..\Doc\%FORMAT%\*.* /q
del ..\Doc\%FORMAT%\tipuesearch\*.* /q
%PASCOC% --format %FORMAT% --output ..\Doc\%FORMAT% --css %FORMAT%.css --introduction=introduction.txt --conclusion=conclusion.txt --source %SOURCE% %OPTIONS% %SEARCH%