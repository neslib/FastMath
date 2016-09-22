#if __LP64__
    .text
    .align 4
    .globl _outer_product_matrix4
    .globl _neg_matrix4
    .globl _matrix4_add_scalar, _scalar_add_matrix4, _matrix4_add_matrix4
    .globl _matrix4_sub_scalar, _scalar_sub_matrix4, _matrix4_sub_matrix4
    .globl _matrix4_mul_scalar, _scalar_mul_matrix4, _matrix4_mul_vector4, _vector4_mul_matrix4, _matrix4_mul_matrix4
    .globl _matrix4_div_scalar, _scalar_div_matrix4
    .globl _matrix4_comp_mult, _matrix4_transpose,  _matrix4_inverse

_outer_product_matrix4: // (const C, R: TVector4; out Result: TMatrix4);
    ld1.4s      {v0}, [x1]         // R.W R.Z R.Y R.X
    ld1.4s      {v1}, [x0]         // C.W C.Z C.Y C.X

    dup.4s      v2, v1[0]          // C.X (4x)
    dup.4s      v3, v1[1]          // C.Y (4x)
    dup.4s      v4, v1[2]          // C.Z (4x)
    dup.4s      v5, v1[3]          // C.W (4x)

    fmul.4s     v2, v2, v0         // R * C.X
    fmul.4s     v3, v3, v0         // R * C.Y
    fmul.4s     v4, v4, v0         // R * C.Z
    fmul.4s     v5, v5, v0         // R * C.W

    st1.4s      {v2-v5}, [x2]
    ret

_neg_matrix4: // (const A: TMatrix4; out Result: TMatrix4);
    ld1.4s      {v0-v3}, [x0]
    fneg.4s     v0, v0
    fneg.4s     v1, v1
    fneg.4s     v2, v2
    fneg.4s     v3, v3
    st1.4s      {v0-v3}, [x1]
    ret

_matrix4_add_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fadd.4s     v0, v0, v4
    fadd.4s     v1, v1, v4
    fadd.4s     v2, v2, v4
    fadd.4s     v3, v3, v4
    st1.4s      {v0-v3}, [x1]
    ret

_scalar_add_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fadd.4s     v0, v0, v4
    fadd.4s     v1, v1, v4
    fadd.4s     v2, v2, v4
    fadd.4s     v3, v3, v4
    st1.4s      {v0-v3}, [x1]
    ret

_matrix4_add_matrix4: // (const A, B: TMatrix4; out Result: TMatrix4);
    ld1.4s      {v0-v3}, [x0]
    ld1.4s      {v4-v7}, [x1]
    fadd.4s     v0, v0, v4
    fadd.4s     v1, v1, v5
    fadd.4s     v2, v2, v6
    fadd.4s     v3, v3, v7
    st1.4s      {v0-v3}, [x2]
    ret

_matrix4_sub_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fsub.4s     v0, v0, v4
    fsub.4s     v1, v1, v4
    fsub.4s     v2, v2, v4
    fsub.4s     v3, v3, v4
    st1.4s      {v0-v3}, [x1]
    ret

_scalar_sub_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fsub.4s     v0, v4, v0
    fsub.4s     v1, v4, v1
    fsub.4s     v2, v4, v2
    fsub.4s     v3, v4, v3
    st1.4s      {v0-v3}, [x1]
    ret

_matrix4_sub_matrix4: // (const A, B: TMatrix4; out Result: TMatrix4);
    ld1.4s      {v0-v3}, [x0]
    ld1.4s      {v4-v7}, [x1]
    fsub.4s     v0, v0, v4
    fsub.4s     v1, v1, v5
    fsub.4s     v2, v2, v6
    fsub.4s     v3, v3, v7
    st1.4s      {v0-v3}, [x2]
    ret

_matrix4_mul_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fmul.4s     v0, v0, v4
    fmul.4s     v1, v1, v4
    fmul.4s     v2, v2, v4
    fmul.4s     v3, v3, v4
    st1.4s      {v0-v3}, [x1]
    ret

_scalar_mul_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fmul.4s     v0, v0, v4
    fmul.4s     v1, v1, v4
    fmul.4s     v2, v2, v4
    fmul.4s     v3, v3, v4
    st1.4s      {v0-v3}, [x1]
    ret

_vector4_mul_matrix4: // (const A: TVector4; const B: TMatrix4; out Result: TVector4);
    ld4.4s      {v0-v3}, [x1]  // v0: B30 B20 B10 B00 (deinterleaved)
                               // v1: B31 B21 B11 B01
                               // v2: B32 B22 B12 B02
                               // v3: B33 B23 B13 B03
    ld1.4s      {v4}, [x0]     // v4: A.W A.Z A.Y A.X

    fmul.4s     v0, v0, v4     // (A.W*B30) (A.Z*B20) (A.Y*B10) (A.X*B00)
    fmul.4s     v1, v1, v4     // (A.W*B31) (A.Z*B21) (A.Y*B11) (A.X*B01)
    fmul.4s     v2, v2, v4     // (A.W*B32) (A.Z*B22) (A.Y*B12) (A.X*B02)
    fmul.4s     v3, v3, v4     // (A.W*B33) (A.Z*B23) (A.Y*B13) (A.X*B03)

    faddp.4s    v0, v0, v1     // (A.W*B31)+(A.Z*B21) (A.Y*B11)+(A.X*B01) (A.W*B30)+(A.Z*B20) (A.Y*B10)+(A.X*B00)
    faddp.4s    v2, v2, v3     // (A.W*B33)+(A.Z*B23) (A.Y*B13)+(A.X*B03) (A.W*B32)+(A.Z*B22) (A.Y*B12)+(A.X*B02)
    faddp.4s    v0, v0, v2
    st1.4s      {v0}, [x2]
    ret

_matrix4_mul_vector4: // (const A: TMatrix4; const B: TVector4; out Result: TVector4);
    ld1.4s      {v4}, [x1]     // v4: B.W B.Z B.Y B.X
    ld1.4s      {v0-v3}, [x0]  // v0: A03 A02 A01 A00
                               // v1: A13 A12 A11 A10
                               // v2: A23 A22 A21 A20
                               // v3: A33 A32 A31 A30

    fmul.4s     v0, v0, v4     // (B.W*A03) (B.Z*A02) (B.Y*A01) (B.X*A00)
    fmul.4s     v1, v1, v4     // (B.W*A13) (B.Z*A12) (B.Y*A11) (B.X*A10)
    fmul.4s     v2, v2, v4     // (B.W*A23) (B.Z*A22) (B.Y*A21) (B.X*A20)
    fmul.4s     v3, v3, v4     // (B.W*A33) (B.Z*A32) (B.Y*A31) (B.X*A30)

    faddp.4s    v0, v0, v1     // (B.W*A13)+(B.Z*A12) (B.Y*A11)+(B.X*A10) (B.W*A03)+(B.Z*A02) (B.Y*A01)+(B.X*A00)
    faddp.4s    v2, v2, v3     // (B.W*A33)+(B.Z*A32) (B.Y*A31)+(B.X*A30) (B.W*A23) (B.Z*A22)+(B.Y*A21) (B.X*A20)
    faddp.4s    v0, v0, v2
    st1.4s      {v0}, [x2]
    ret

_matrix4_mul_matrix4: // (const A, B: TMatrix4; out Result: TMatrix4);
    // Implemented as 4 Vector*Matrix calculations
    ld4.4s      {v0-v3}, [x1]  // v0: A30 A20 A10 A00 (deinterleaved)
                               // v1: A31 A21 A11 A01
                               // v2: A32 A22 A12 A02
                               // v3: A33 A23 A13 A03
    ld1.4s      {v4-v7}, [x0]  // v4: B03 B02 B01 B00
                               // v5: B13 B12 B11 B10
                               // v6: B23 B22 B21 B20
                               // v7: B33 B32 B31 B30

    // A.R[0] * B
    fmul.4s     v16, v0, v4
    fmul.4s     v17, v1, v4
    fmul.4s     v18, v2, v4
    fmul.4s     v19, v3, v4
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v19
    faddp.4s    v20, v16, v18

    // A.R[1] * B
    fmul.4s     v16, v0, v5
    fmul.4s     v17, v1, v5
    fmul.4s     v18, v2, v5
    fmul.4s     v19, v3, v5
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v19
    faddp.4s    v21, v16, v18

    // A.R[2] * B
    fmul.4s     v16, v0, v6
    fmul.4s     v17, v1, v6
    fmul.4s     v18, v2, v6
    fmul.4s     v19, v3, v6
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v19
    faddp.4s    v22, v16, v18

    // A.R[3] * B
    fmul.4s     v16, v0, v7
    fmul.4s     v17, v1, v7
    fmul.4s     v18, v2, v7
    fmul.4s     v19, v3, v7
    faddp.4s    v16, v16, v17
    faddp.4s    v18, v18, v19
    faddp.4s    v23, v16, v18

    st1.4s      {v20-v23}, [x2]
    ret

_matrix4_div_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fdiv.4s     v0, v0, v4
    fdiv.4s     v1, v1, v4
    fdiv.4s     v2, v2, v4
    fdiv.4s     v3, v3, v4
    st1.4s      {v0-v3}, [x1]
    ret

_scalar_div_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    dup.4s      v4, v0[0]
    ld1.4s      {v0-v3}, [x0]
    fdiv.4s     v0, v4, v0
    fdiv.4s     v1, v4, v1
    fdiv.4s     v2, v4, v2
    fdiv.4s     v3, v4, v3
    st1.4s      {v0-v3}, [x1]
    ret

_matrix4_comp_mult: // (const A, B: TMatrix4; out Result: TMatrix4);
    ld1.4s      {v0-v3}, [x0]
    ld1.4s      {v4-v7}, [x1]
    fmul.4s     v0, v0, v4
    fmul.4s     v1, v1, v5
    fmul.4s     v2, v2, v6
    fmul.4s     v3, v3, v7
    st1.4s      {v0-v3}, [x2]
    ret

_matrix4_transpose: // (const A: TMatrix4; out Result: TMatrix4);
    /*                   Original:    M03 M02 M01 M00
                                      M13 M12 M11 M10
                                      M23 M22 M21 M20
                                      M33 M32 M31 M30 */
    ld4.4s      {v0-v3}, [x0]  // v0: M30 M20 M10 M00 (deinterleaved)
                               // v1: M31 M21 M11 M01
                               // v2: M32 M22 M12 M02
                               // v3: M33 M23 M13 M03
    st1.4s      {v0-v3}, [x1]
    ret

TO03131313:
    .byte 28, 29, 30, 31, 28, 29, 30, 31, 28, 29, 30, 31, 12, 13, 14, 15
TO02021212:
    .byte 24, 25, 26, 27, 24, 25, 26, 27, 8, 9, 10, 11, 8, 9, 10, 11
TO02121212:
    .byte 24, 25, 26, 27, 24, 25, 26, 27, 24, 25, 26, 27, 8, 9, 10, 11
TO03031313:
    .byte 28, 29, 30, 31, 28, 29, 30, 31, 12, 13, 14, 15, 12, 13, 14, 15
TO01011111:
    .byte 20, 21, 22, 23, 20, 21, 22, 23, 4, 5, 6, 7, 4, 5, 6, 7
TO01111111:
    .byte 20, 21, 22, 23, 20, 21, 22, 23, 20, 21, 22, 23, 4, 5, 6, 7
TO00001010:
    .byte 16, 17, 18, 19, 16, 17, 18, 19, 0, 1, 2, 3, 0, 1, 2, 3
TO00101010:
    .byte 16, 17, 18, 19, 16, 17, 18, 19, 16, 17, 18, 19, 0, 1, 2, 3
SA:
    .float 1.0, -1.0, 1.0, -1.0
SB:
    .float -1.0, 1.0, -1.0, 1.0

_matrix4_inverse: // (const A: TMatrix4; out Result: TMatrix4);
    adr         x2, TO03131313
    ld1.4s      {v0-v3}, [x0]        //  v0: M03 M02 M01 M00
                                     //  v1: M13 M12 M11 M10
                                     //  v2: M23 M22 M21 M20
                                     //  v3: M33 M32 M31 M30
    ld1.4s      {v24-v27}, [x2], #64 // v24: Pick M[R+0,3] M[R+1,3] M[R+1,3] M[R+1,3]
                                     // v25: Pick M[R+0,2] M[R+0,2] M[R+1,2] M[R+1,2]
                                     // v26: Pick M[R+0,2] M[R+1,2] M[R+1,2] M[R+1,2]
                                     // v27: Pick M[R+0,3] M[R+0,3] M[R+1,3] M[R+1,3]
    ld1.4s      {v28-v31}, [x2], #64 // v28: Pick M[R+0,1] M[R+0,1] M[R+1,1] M[R+1,1]
                                     // v29: Pick M[R+0,1] M[R+1,1] M[R+1,1] M[R+1,1]
                                     // v30: Pick M[R+0,0] M[R+0,0] M[R+1,0] M[R+1,0]
                                     // v31: Pick M[R+0,0] M[R+1,0] M[R+1,0] M[R+1,0]

    /* C00 := (A.M[2,2] * A.M[3,3]) - (A.M[3,2] * A.M[2,3]);
       C02 := (A.M[1,2] * A.M[3,3]) - (A.M[3,2] * A.M[1,3]);
       C03 := (A.M[1,2] * A.M[2,3]) - (A.M[2,2] * A.M[1,3]);
       F0 := Vector4(C00, C00, C02, C03); */
    tbl.16b     v4, {v2, v3}, v24  // M23 M33 M33 M33
    tbl.16b     v5, {v1, v2}, v25  // M12 M12 M22 M22
    tbl.16b     v6, {v2, v3}, v26  // M22 M32 M32 M32
    tbl.16b     v7, {v1, v2}, v27  // M13 M13 M23 M23
    fmul.4s     v18, v4, v5        // (M12 * M23) (M12 * M33) (M22 * M33) (M22 * M33)
    fmls.4s     v18, v6, v7        // v18=F0: C03=(M12*M23)-(M22*M13), C02=(M12*M33)-(M32*M13), C00=(M22*M33)-(M32*M23), C00=(M22*M33)-(M32*M23)

    /* C04 := (A.M[2,1] * A.M[3,3]) - (A.M[3,1] * A.M[2,3]);
       C06 := (A.M[1,1] * A.M[3,3]) - (A.M[3,1] * A.M[1,3]);
       C07 := (A.M[1,1] * A.M[2,3]) - (A.M[2,1] * A.M[1,3]);
       F1 := Vector4(C04, C04, C06, C07); */
    tbl.16b     v24, {v1, v2}, v28  // M11 M11 M21 M21
    tbl.16b     v25, {v2, v3}, v29  // M21 M31 M31 M31
    fmul.4s     v19, v4, v24        // (M11 * M23) (M11 * M33) (M21 * M33) (M21 * M33)
    fmls.4s     v19, v25, v7        // v19=F1: C07=(M11*M23)-(M21*M13), C06=(M11*M33)-(M31*M13), C04=(M21*M33)-(M31*M23), C04=(M21*M33)-(M31*M23)

    /* C08 := (A.M[2,1] * A.M[3,2]) - (A.M[3,1] * A.M[2,2]);
       C10 := (A.M[1,1] * A.M[3,2]) - (A.M[3,1] * A.M[1,2]);
       C11 := (A.M[1,1] * A.M[2,2]) - (A.M[2,1] * A.M[1,2]);
       F2 := Vector4(C08, C08, C10, C11); */
    fmul.4s     v20, v6, v24        // (M11 * M22) (M11 * M32) (M21 * M32) (M21 * M32)
    fmls.4s     v20, v25, v5        // v20=F2: C11=(M11*M22)-(M21*M12), C10=(M11*M32)-(M31*M12), C08=(M21*M32)-(M31*M22), C08=(M21*M32)-(M31*M22)

    /* C12 := (A.M[2,0] * A.M[3,3]) - (A.M[3,0] * A.M[2,3]);
       C14 := (A.M[1,0] * A.M[3,3]) - (A.M[3,0] * A.M[1,3]);
       C15 := (A.M[1,0] * A.M[2,3]) - (A.M[2,0] * A.M[1,3]);
       F3 := Vector4(C12, C12, C14, C15); */
    tbl.16b     v26, {v1, v2}, v30 // M10 M10 M20 M20
    tbl.16b     v27, {v2, v3}, v31 // M20 M30 M30 M30
    fmul.4s     v21, v4, v26       // (M10 * M23) (M10 * M33) (M20 * M33) (M20 * M33)
    fmls.4s     v21, v27, v7       // v21=F3: C15=(M10*M23)-(M20*M13), C14=(M10*M33)-(M30*M13), C12=(M20*M33)-(M30*M23), C12=(M20*M33)-(M30*M23)

    /* C16 := (A.M[2,0] * A.M[3,2]) - (A.M[3,0] * A.M[2,2]);
       C18 := (A.M[1,0] * A.M[3,2]) - (A.M[3,0] * A.M[1,2]);
       C19 := (A.M[1,0] * A.M[2,2]) - (A.M[2,0] * A.M[1,2]);
       F4 := Vector4(C16, C16, C18, C19); */
    fmul.4s     v22, v6, v26       // (M10 * M22) (M10 * M32) (M20 * M32) (M20 * M32)
    fmls.4s     v22, v27, v5       // v22=F4: C19=(M10*M22)-(M20*M12), C18=(M10*M32)-(M30*M12), C16=(M20*M32)-(M30*M22), C16=(M20*M32)-(M30*M22)

    /* C20 := (A.M[2,0] * A.M[3,1]) - (A.M[3,0] * A.M[2,1]);
       C22 := (A.M[1,0] * A.M[3,1]) - (A.M[3,0] * A.M[1,1]);
       C23 := (A.M[1,0] * A.M[2,1]) - (A.M[2,0] * A.M[1,1]);
       F5 := Vector4(C20, C20, C22, C23); */
    fmul.4s     v23, v25, v26       // (M10 * M21) (M10 * M31) (M20 * M31) (M20 * M31)
    fmls.4s     v23, v27, v24       // v23=F5: C23=(M10*M21)-(M20*M11), C22=(M10*M31)-(M30*M11), C20=(M20*M31)-(M30*M21), C20=(M20*M31)-(M30*M21)

    /* V0 := Vector4(A.M[1,0], A.M[0,0], A.M[0,0], A.M[0,0]);
       V1 := Vector4(A.M[1,1], A.M[0,1], A.M[0,1], A.M[0,1]);
       V2 := Vector4(A.M[1,2], A.M[0,2], A.M[0,2], A.M[0,2]);
       V3 := Vector4(A.M[1,3], A.M[0,3], A.M[0,3], A.M[0,3]); */
    dup.4s      v24, v0[0]         // M00 M00 M00 M00
    dup.4s      v25, v0[1]         // M01 M01 M01 M00
    dup.4s      v26, v0[2]         // M02 M02 M02 M00
    dup.4s      v27, v0[3]         // M03 M03 M03 M00
    mov.s       v24[0], v1[0]      // v24=V0: M00 M00 M00 M10
    mov.s       v25[0], v1[1]      // v25=V1: M01 M01 M01 M10
    mov.s       v26[0], v1[2]      // v26=V2: M02 M02 M02 M10
    mov.s       v27[0], v1[3]      // v27=V3: M03 M03 M03 M10

    /* I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
       I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
       I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
       I3 := (V0 * F2) - (V1 * F4) + (V2 * F5); */
    fmul.4s     v28, v25, v18      // V1 * F0
    fmul.4s     v29, v24, v18      // V0 * F0
    fmul.4s     v30, v24, v19      // V0 * F1
    fmul.4s     v31, v24, v20      // V0 * F2
    fmls.4s     v28, v26, v19      // (V1 * F0) - (V2 * F1)
    fmls.4s     v29, v26, v21      // (V0 * F0) - (V2 * F3)
    fmls.4s     v30, v25, v21      // (V0 * F1) - (V1 * F3)
    fmls.4s     v31, v25, v22      // (V0 * F2) - (V1 * F4)
    fmla.4s     v28, v27, v20      // v28=I0 := (V1 * F0) - (V2 * F1) + (V3 * F2)
    fmla.4s     v29, v27, v22      // v29=I1 := (V0 * F0) - (V2 * F3) + (V3 * F4)
    fmla.4s     v30, v27, v23      // v30=I2 := (V0 * F1) - (V1 * F3) + (V3 * F5)
    fmla.4s     v31, v26, v23      // v31=I3 := (V0 * F2) - (V1 * F4) + (V2 * F5)

    /* SA := Vector4(+1, -1, +1, -1);
       SB := Vector4(-1, +1, -1, +1);
       Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB); */
    ld1.4s      {v16-v17}, [x2]    // v16=SA, v17=SB
    fmul.4s     v28, v28, v16
    fmul.4s     v29, v29, v17
    fmul.4s     v30, v30, v16
    fmul.4s     v31, v31, v17      // Inv=v28-v31

    /* Col := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
       Dot := A.R[0] * Col; */
    mov.s       v1[0], v28[0]
    mov.s       v1[1], v29[0]
    mov.s       v1[2], v30[0]
    mov.s       v1[3], v31[0]
    fmul.4s     v0, v0, v1         // v0=Dot := A.R[0] * Col

    /* OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W)); */
    faddp.4s    v0, v0, v0         // Dot.W+Dot.Z Dot.Y+Dot.X (2x)
    faddp.4s    v0, v0, v0         // Det=Dot.W+Dot.Z+Dot.Y+Dot.X (4x)

    // Calculate 1/Det (see RECIP_MED in macros_32.S for details)
    frecpe.4s   v1, v0             // X(0)=Approximate 1/Det
    frecps.4s   v2, v1, v0         // 2 - Det * X(0)
    fmul.4s     v1, v1, v2         // X(1)=X(0) * (2 - Det * X(0))
    frecps.4s   v2, v1, v0         // 2 - Det * X(1)
    fmul.4s     v0, v1, v2         // X(2)=X(1) * (2 - Det * X(1)) (4x)

    /* Result := Inv * OneOverDeterminant; */
    fmul.4s     v28, v28, v0
    fmul.4s     v29, v29, v0
    fmul.4s     v30, v30, v0
    fmul.4s     v31, v31, v0

    st1.4s      {v28-v31}, [x1]
    ret

#endif // __LP64__