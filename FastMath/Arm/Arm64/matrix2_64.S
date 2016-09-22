#if __LP64__
    .text
    .align 4
    .globl _outer_product_matrix2
    .globl _neg_matrix2
    .globl _matrix2_add_scalar, _scalar_add_matrix2, _matrix2_add_matrix2
    .globl _matrix2_sub_scalar, _scalar_sub_matrix2, _matrix2_sub_matrix2
    .globl _matrix2_mul_scalar, _scalar_mul_matrix2, _matrix2_mul_vector2, _vector2_mul_matrix2, _matrix2_mul_matrix2
    .globl _matrix2_div_scalar, _scalar_div_matrix2
    .globl _matrix2_comp_mult, _matrix2_transpose

_outer_product_matrix2: // (const C, R: TVector2; out Result: TMatrix2);
    ld1.2s      {v0}, [x1]         //         R.Y R.X
    ld1.2s      {v1}, [x0]         //         C.Y C.X
    dup.2d      v0, v0[0]          // R.Y R.X R.Y R.X
    zip1.4s     v1, v1, v1         // C.Y C.Y C.X C.X
    fmul.4s     v0, v0, v1         // (R.Y*C.Y) (R.X*C.Y) (R.Y*C.X) (R.X*C.X)
    st1.4s      {v0}, [x2]
    ret

_neg_matrix2: // (const A: TMatrix2; out Result: TMatrix2);
    ld1.4s      {v0}, [x0]
    fneg.4s     v0, v0
    st1.4s      {v0}, [x1]
    ret

_matrix2_add_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fadd.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_add_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fadd.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_matrix2_add_matrix2: // (const A, B: TMatrix2; out Result: TMatrix2);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fadd.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_matrix2_sub_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fsub.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_sub_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fsub.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_matrix2_sub_matrix2: // (const A, B: TMatrix2; out Result: TMatrix2);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fsub.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_matrix2_mul_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_mul_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_vector2_mul_matrix2: // (const A: TVector2; const B: TMatrix2; out Result: TVector2);
    ld1.2s      {v0}, [x0] // A.Y A.X
    dup.2d      v0, v0[0]  // A.Y A.X A.Y A.X
    ld1.4s      {v1}, [x1] // B11 B10 B01 B00
    fmul.4s     v0, v0, v1 // (A.Y*B11) (A.X*B10) (A.Y*B01) (A.X*B00)
    faddp.4s    v0, v0, v0 // (A.Y*B11)+(A.X*B10) (A.Y*B01)+(A.X*B00)
    st1.2s      {v0}, [x2]
    ret

_matrix2_mul_vector2: // (const A: TMatrix2; const B: TVector2; out Result: TVector2);
    ld2.2s      {v0-v1}, [x0] // v0: # # A10 A00 (deinterleaved)
                              // v1: # # A11 A01
    ld1.2s      {v2}, [x1]    // v2: # # B.Y B.X
    fmul.2s     v0, v0, v2    // # # (A10*B.Y) (A00*B.X)
    fmul.2s     v1, v1, v2    // # # (A11*B.Y) (A01*B.X)
    mov.d       v0[1], v1[0]  // (A11*B.Y) (A01*B.X) (A10*B.Y) (A00*B.X)
    faddp.4s    v0, v0, v0    // (A11*B.Y)+(A01*B.X) (A10*B.Y)+(A00*B.X)
    st1.2s      {v0}, [x2]
    ret

_matrix2_mul_matrix2: // (const A, B: TMatrix2; out Result: TMatrix2);
    // Implemented as 2 Matrix*Vector calculations
    ld2.2s      {v0-v1}, [x0] // v0: # # A10 A00 (deinterleaved)
                              // v1: # # A11 A01
    ld1.4s      {v2}, [x1]    // B11 B10 B01 B00
    mov.d       v0[1], v1[0]  // A11 A01 A10 A00

    // A * B.C[0]
    dup.2d      v1, v2[0]     // B01 B00 B01 B00
    fmul.4s     v1, v0, v1    // (A11*B01) (A01*B00) (A10*B01) (A00*B00)

    // A * B.C[0]
    dup.2d      v2, v2[1]     // B11 B10 B11 B10
    fmul.4s     v2, v0, v2    // (A11*B11) (A01*B10) (A10*B11) (A00*B10)

    faddp.4s    v0, v1, v2    // (A11*B11)+(A01*B10) (A10*B11)+(A00*B10) (A11*B01)+(A01*B00) (A10*B01)+(A00*B00)
    st1.4s      {v0}, [x2]
    ret

_matrix2_div_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fdiv.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_div_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fdiv.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_matrix2_comp_mult: // (const A, B: TMatrix2; out Result: TMatrix2);
    ld1.4s      {v0}, [x0] // Contains entire matrix A
    ld1.4s      {v1}, [x1] // Contains entire matrix B
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_matrix2_transpose: // (const A: TMatrix2; out Result: TMatrix2);
    ld2.2s      {v0-v1}, [x0] // v0: # # A10 A00 (deinterleaved)
                              // v1: # # A11 A01
    st1.2s      {v0-v1}, [x1]
    ret

#endif // __LP64__