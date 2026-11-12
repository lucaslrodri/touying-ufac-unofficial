// Body of the `elements/code-langs` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== The languages of the theme: programming and hardware
Each with its logo in the pill, under its short keys too (`m` is MATLAB, `s` Assembly):
#grid(columns: (1fr, 1fr), column-gutter: .8em, row-gutter: .35em,
  ```m
  y = x.^2;
  ```,
  ```c
  PORTB |= 1;
  ```,
  ```cpp
  std::vector<int> v;
  ```,
  ```ino
  void loop() {}
  ```,
  ```rust
  let v: f32 = 3.3;
  ```,
  ```fortran
  X = A + B
  ```,
  ```r
  summary(x)
  ```,
  ```s
  mov eax, 1
  ```,
  ```x86
  push rbp
  ```,
  ```arm
  MOV R0, #1
  ```,
  ```riscv
  addi a0, a0, 1
  ```,
  ```vhdl
  y <= a and b;
  ```,
)

== The languages of the theme: hardware, documents and the console
A console session (`console`) goes in the gray box of the output, without numbers:
#grid(columns: (1fr, 1fr), column-gutter: .8em, row-gutter: .35em,
  ```verilog
  assign y = a & b;
  ```,
  ```sv
  logic [7:0] q;
  ```,
  ```latex
  \frac{a}{b}
  ```,
  ```lean
  example : 1 + 1 = 2 := rfl
  ```,
  ```md
  # Title
  ```,
  ```html
  <p>Hi</p>
  ```,
  ```js
  const x = 1;
  ```,
  ```ts
  let x: number = 1;
  ```,
  ```scad
  cube([10, 10, 5]);
  ```,
  ```console
  $ typst compile slides.typ
  ```,
)
