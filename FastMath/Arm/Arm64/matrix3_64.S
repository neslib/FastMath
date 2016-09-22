#if __LP64__
    .text
    .align 4
    .include "../Arm64/macros_64.S"
    .globl _outer_product_matrix3
    .globl _neg_matrix3
    .globl _matrix3_add_scalar, _scalar_add_matrix3, _matrix3_add_matrix3
    .globl _matrix3_sub_scalar, _scalar_sub_matrix3, _matrix3_sub_matrix3
    .globl _matrix3_mul_scalar, _scalar_mul_matrix3, _matrix3_mul_vector3, _vector3_mul_matrix3, _matrix3_mul_matrix3
    .globl _matrix3_div_scalar, _scalar_div_matrix3
    .globl _matrix3_comp_mult, _matrix3_transpose

_outer_product_matrix3: // (const C, R: TVector3; out Result: TMatrix3);
    LOAD3       v0, x1             // R.W R.Z R.Y R.X
    LOAD3       v1, x0             // C.W C.Z C.Y C.X

    dup.4s      v2, v1[0]          // C.X (4x)
    dup.4s      v3, v1[1]          // C.Y (4x)
    dup.4s      v4, v1[2]          // C.Z (4x)

    fmul.4s     v2, v2, v0         // R * C.X
    fmul.4s     v3, v3, v0         // R * C.Y
    fmul.4s     v4, v4, v0         // R * C.Z

    STORE3WB    v2, x2
    STORE3WB    v3, x2
    STORE3      v4, x2
    ret

_neg_matrix3: // (const A: TMatrix3; out Result: TMatrix3);
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fneg.4s     v0, v0
    fneg.4s     v1, v1
    fneg        s2, s2
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_matrix3_add_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fadd.4s     v0, v0, v4
    fadd.4s     v1, v1, v4
    fadd        s2, s2, s4
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_scalar_add_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fadd.4s     v0, v0, v4
    fadd.4s     v1, v1, v4
    fadd        s2, s2, s4
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_matrix3_add_matrix3: // (const A, B: TMatrix3; out Result: TMatrix3);
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    ld1.4s      {v4-v5}, [x1], 32
    ldr         s6, [x1]
    fadd.4s     v0, v0, v4
    fadd.4s     v1, v1, v5
    fadd        s2, s2, s6
    st1.4s      {v0-v1}, [x2], 32
    str         s2, [x2]
    ret

_matrix3_sub_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fsub.4s     v0, v0, v4
    fsub.4s     v1, v1, v4
    fsub        s2, s2, s4
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_scalar_sub_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fsub.4s     v0, v4, v0
    fsub.4s     v1, v4, v1
    fsub        s2, s4, s2
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_matrix3_sub_matrix3: // (const A, B: TMatrix3; out Result: TMatrix3);
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    ld1.4s      {v4-v5}, [x1], 32
    ldr         s6, [x1]
    fsub.4s     v0, v0, v4
    fsub.4s     v1, v1, v5
    fsub        s2, s2, s6
    st1.4s      {v0-v1}, [x2], 32
    str         s2, [x2]
    ret

_matrix3_mul_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fmul.4s     v0, v0, v4
    fmul.4s     v1, v1, v4
    fmul        s2, s2, s4
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_scalar_mul_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fmul.4s     v0, v0, v4
    fmul.4s     v1, v1, v4
    fmul        s2, s2, s4
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

DEINTERLEAVE:
    .byte 0, 1, 2, 3, 16, 17, 18, 19, 32, 33, 34, 35, 65, 65, 65, 65
    .byte 4, 5, 6, 7, 20, 21, 22, 23, 36, 37, 38, 39, 65, 65, 65, 65
    .byte 8, 9, 10, 11, 24, 25, 26, 27, 40, 41, 42, 43, 65, 65, 65, 65

_vector3_mul_matrix3: // (const A: TVector3; const B: TMatrix3; out Result: TVector3);
    adr         x3, DEINTERLEAVE
    LOAD3WB     v5, x1           // v5: # B02 B01 B00
    LOAD3WB     v6, x1           // v6: # B12 B11 B10
    LOAD3       v7, x1           // v7: # B22 B21 B20
    ld1.4s      {v16-v18}, [x3]  // De-interleave lookup table
    LOAD3       v4, x0           // v4: # A.Z A.Y A.X
    tbl.16b     v0, {v5-v7}, v16 // v0: 0 B20 B10 B00
    tbl.16b     v1, {v5-v7}, v17 // v1: 0 B21 B11 B01
    tbl.16b     v2, {v5-v7}, v18 // v2: 0 B22 B12 B02

    fmul.4s     v0, v0, v4       // 0 (A.Z*B20) (A.Y*B10) (A.X*B00)
    fmul.4s     v1, v1, v4       // 0 (A.Z*B21) (A.Y*B11) (A.X*B01)
    fmul.4s     v2, v2, v4       // 0 (A.Z*B22) (A.Y*B12) (A.X*B02)

    faddp.4s    v0, v0, v1       // (0)+(A.Z*B21) (A.Y*B11)+(A.X*B01) (0)+(A.Z*B20) (A.Y*A10)+(A.X*B00)
    faddp.4s    v2, v2, v2       // (0)+(A.Z*B23) (A.Y*B13)+(A.X*B03) (0)+(A.Z*B22) (A.Y*A12)+(A.X*B02)
    faddp.4s    v0, v0, v2
    STORE3      v0, x2
    ret

_matrix3_mul_vector3: // (const A: TMatrix3; const B: TVector3; out Result: TVector3);
    LOAD3       v4, x1         // v4: ### B.Z B.Y B.X
    eor.16b     v5, v5, v5
    mov.s       v4[3], v5[0]   // v4:   0 B.Z B.Y B.X
    LOAD3WB     v0, x0         // v0: ### A02 A01 A00
    LOAD3WB     v1, x0         // v1: ### A12 A11 A10
    LOAD3       v2, x0         // v2: ### A22 A21 A20

    fmul.4s     v0, v0, v4     // (0*###) (B.Z*A02) (B.Y*A01) (B.X*A00)
    fmul.4s     v1, v1, v4     // (0*###) (B.Z*A12) (B.Y*A11) (B.X*A10)
    fmul.4s     v2, v2, v4     // (0*###) (B.Z*A22) (B.Y*A21) (B.X*A20)

    faddp.4s    v0, v0, v1     // (0)+(B.Z*A12) (B.Y*A11)+(B.X*A10) (0)+(B.Z*A02) (B.Y*A01)+(B.X*A00)
    faddp.4s    v2, v2, v2     // (0)+(B.Z*A32) (B.Y*A31)+(B.X*A30) (0) (B.Z*A22)+(B.Y*A21) (B.X*A20)
    faddp.4s    v0, v0, v2
    STORE3      v0, x2
    ret

_matrix3_mul_matrix3: // (const A, B: TMatrix3; out Result: TMatrix3);
    // Implemented as 3 Vector*Matrix calculations
    adr         x3, DEINTERLEAVE
    LOAD3WB     v5, x1           // v5: # B02 B01 B00
    LOAD3WB     v6, x1           // v6: # B12 B11 B10
    LOAD3       v7, x1           // v7: # B22 B21 B20
    ld1.4s      {v16-v18}, [x3]  // De-interleave lookup table
    tbl.16b     v0, {v5-v7}, v16 // v0: 0 B20 B10 B00
    tbl.16b     v1, {v5-v7}, v17 // v1: 0 B21 B11 B01
    tbl.16b     v2, {v5-v7}, v18 // v2: 0 B22 B12 B02
    LOAD3WB     v4, x0           // v4: # A02 A01 A00
    LOAD3WB     v5, x0           // v5: # A12 A11 A10
    LOAD3       v6, x0           // v6: # A22 A21 A20

    // A.R[0] * B
    fmul.4s     v16, v0, v4
    fmul.4s     v17, v1, v4
    fmul.4s     v18, v2, v4
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v18
    faddp.4s    v20, v16, v18

    // A.R[1] * B
    fmul.4s     v16, v0, v5
    fmul.4s     v17, v1, v5
    fmul.4s     v18, v2, v5
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v18
    faddp.4s    v21, v16, v18

    // A.R[2] * B
    fmul.4s     v16, v0, v6
    fmul.4s     v17, v1, v6
    fmul.4s     v18, v2, v6
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v18
    faddp.4s    v22, v16, v18

    STORE3WB    v20, x2
    STORE3WB    v21, x2
    STORE3      v22, x2
    ret

_matrix3_div_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fdiv.4s     v0, v0, v4
    fdiv.4s     v1, v1, v4
    fdiv        s2, s2, s4
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_scalar_div_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    fdiv.4s     v0, v4, v0
    fdiv.4s     v1, v4, v1
    fdiv        s2, s4, s2
    st1.4s      {v0-v1}, [x1], 32
    str         s2, [x1]
    ret

_matrix3_comp_mult: // (const A, B: TMatrix3; out Result: TMatrix3);
    ld1.4s      {v0-v1}, [x0], 32
    ldr         s2, [x0]
    ld1.4s      {v4-v5}, [x1], 32
    ldr         s6, [x1]
    fmul.4s     v0, v0, v4
    fmul.4s     v1, v1, v5
    fmul        s2, s2, s6
    st1.4s      {v0-v1}, [x2], 32
    str         s2, [x2]
    ret

_matrix3_transpose: // (const A: TMatrix3; out Result: TMatrix3);
    /*                   Original:    M03 M02 M01 M00
                                      M13 M12 M11 M10
                                      M23 M22 M21 M20
                                      M33 M32 M31 M30 */
    adr         x3, DEINTERLEAVE
    LOAD3WB     v5, x0           // v5: # M02 M01 M00
    LOAD3WB     v6, x0           // v6: # M12 M11 M10
    LOAD3       v7, x0           // v7: # M22 M21 M20
    ld1.4s      {v16-v18}, [x3]  // De-interleave lookup table
    tbl.16b     v0, {v5-v7}, v16 // v0: 0 M20 M10 M00
    tbl.16b     v1, {v5-v7}, v17 // v1: 0 M21 M11 M01
    tbl.16b     v2, {v5-v7}, v18 // v2: 0 M22 M12 M02
    STORE3WB    v0, x1
    STORE3WB    v1, x1
    STORE3      v2, x1
    ret

#endif // __LP64__