  .option pic2
  .text
  .globl _foo
_foo:
  nop

  .globl foo0
  .type foo0, @function
foo0:
  nop

  .globl foo1
  .type foo1, @function
foo1:
  nop

  .data
  .globl data0
  .type data0, @object
data0:
  .word 0

  .globl data1
  .type data1, @object
data1:
  .word 0
