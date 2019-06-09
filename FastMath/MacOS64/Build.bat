nasm -f macho64 -Ox FastMathMacOS64.asm -o ..\FastMathMacOS64RM.obj
nasm -f macho64 -Ox -DFM_COLUMN_MAJOR FastMathMacOS64.asm -o ..\FastMathMacOS64CM.obj