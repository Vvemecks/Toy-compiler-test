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

## `flex` 词法分析
