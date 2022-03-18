flex: tokens.l
	flex -o tokens.c tokens.l
bison: parser.y
	bison -d -o parser.c parser.y
toy:
	flex -o tokens.c tokens.l
	bison -d -o parser.c parser.y
	gcc parser.c parser.h tokens.c -o toy
ast: source.c
	clang -Xclang -ast-dump -fsyntax-only source.c
ir: source.c
	clang -S -emit-llvm source.c
asm: main.ll
	llc main.ll
target: main.s
	clang main.s
