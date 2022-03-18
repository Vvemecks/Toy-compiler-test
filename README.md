# Toy-compiler-test
Simple toy compiler using flex, bison and LLVM

## 概述
该项目对如下示例代码进行编译，主函数只包含一行返回语句，返回宇宙终极答案 `42`

```C
int main()
{
    return 42;
}
```

生成抽象语法树与 `LLVM IR` 部分过于复杂，该项目并不能实现编译的完整过程

## 词法分析
使用 `flex` 进行词法分析，词法定义文件 [tokens.l](tokens.l)，其中主要定义了匹配规则，例如

```C
%%

"int"                                           KEYWORD_TOKEN(TINT); return TINT;
"return"                                        KEYWORD_TOKEN(TRETURN); return TRETURN;

[a-zA-Z_][a-zA-Z0-9_]*                          STRING_TOKEN; return TIDENTIFIER;
[0-9]+                                          INT_TOKEN; return TINTEGER;

"("                                             return TLPAREN;
")"                                             return TRPAREN;

%%
```

## 语法分析
使用 `bison` 进行语法分析，语法定义文件 [parser.y](parser.y)，其中主要定义了语法结构，类似于 `BNF` 范式，例如

```C
%%

func_decl: TINT ident TLPAREN TRPAREN block { printf("func_decl %s 'int ()'\n", $2); }

ident: TIDENTIFIER { $$ = $1; printf("id = %s\n", $1); }
value: TINTEGER { $$ = $1; printf("val = %d\n", $1); }

%%
```

上述语法规则非常简陋，每一步直接输出匹配的结果，编译之后运行，输入示例代码文件，得到输出结果如下，可以观察到每一步匹配的过程

```C
id = main
val = 42
return_stmt 42
compound_stmt
func_decl main 'int ()'
```

## 抽象语法树
生成抽象语法树并将抽象语法树转为 `LLVM IR` 的过程非常复杂，需要使用 `C/C++` 描述抽象语法树的结构并实现 `CodeGen` 方法，并且需要联系 `flex` 与 `bison`，在词法分析与语法分析的同时进行，也就是说上述展示的词法分析与语法分析得不到任何有用的结果，这里使用 `clang` 输出抽象语法树，简化之后如下

```C
`-FunctionDecl 0x1359f40 <source.c:1:1, line:4:1> line:1:5 main 'int ()'
  `-CompoundStmt 0x135a058 <line:2:1, line:4:1>
    `-ReturnStmt 0x135a048 <line:3:2, col:9>
      `-IntegerLiteral 0x135a028 <col:9> 'int' 42
```

## 中间代码
由于生成 `LLVM IR` 过程较为复杂，直接手动编写如下 `LLVM IR` 文件，前两行与平台相关，可以看到核心部分只有一行 `ret` 代码

```C
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i32 @main() {
	ret i32 42
}
```

## 汇编代码
使用 `llc` 将上述 `LLVM IR` 转为汇编代码，如下
```asm
	.text
	.file	"main.ll"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	movl	$42, %eax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
```

## 可执行文件
直接使用 `clang` 编译上述汇编文件，得到可执行文件，运行后使用 `echo $?` 查看返回值，得到 `42`

## 参考
[北航软件学院编译原理实验](https://www.buaasecompiling.cn/)

[LLVM IR入门指南](https://github.com/Evian-Zhang/llvm-ir-tutorial)

[Writing Your Own Toy Compiler Using Flex, Bison and LLVM](https://gnuu.org/2009/09/18/writing-your-own-toy-compiler/)
