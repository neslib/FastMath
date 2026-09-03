nasm -f macho64 -Ox FastMathX64.asm -o ..\FastMathMacOS64RM.obj
nasm -f macho64 -Ox -DFM_COLUMN_MAJOR FastMathX64.asm -o ..\FastMathMacOS64CM.obj
nasm -f elf64 -Ox FastMathX64.asm -o ..\FastMathLinux64RM.obj
nasm -f elf64 -Ox -DFM_COLUMN_MAJOR FastMathX64.asm -o ..\FastMathLinux64CM.obj