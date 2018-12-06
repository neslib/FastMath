#if! __LP64__

#if ANDROID
    .arch armv7-a
    .fpu neon
#endif
#if FORCE_THUMB
    .thumb
#endif
    .text
    .align 4
    .include "../Arm32/macros_32.S"
    .globl _outer_product_matrix4
    .globl _neg_matrix4
    .globl _matrix4_add_scalar, _scalar_add_matrix4, _matrix4_add_matrix4
    .globl _matrix4_sub_scalar, _scalar_sub_matrix4, _matrix4_sub_matrix4
    .globl _matrix4_mul_scalar, _scalar_mul_matrix4, _matrix4_mul_vector4, _vector4_mul_matrix4, _matrix4_mul_matrix4
    .globl _matrix4_div_scalar, _scalar_div_matrix4
    .globl _matrix4_comp_mult, _matrix4_transpose,  _matrix4_inverse
    
_outer_product_matrix4: // (const C, R: TVector4; out Result: TMatrix4);
    vld1.32     {q0}, [r1]         // R.W R.Z R.Y R.X
    vld1.32     {q1}, [r0]         // C.W C.Z C.Y C.X

    vdup.32     q8, d2[0]          // C.X (4x)
    vdup.32     q9, d2[1]          // C.Y (4x)
    vdup.32     q10, d3[0]         // C.Z (4x)
    vdup.32     q11, d3[1]         // C.W (4x)

    vmul.f32    q8, q8, q0         // R * C.X
    vmul.f32    q9, q9, q0         // R * C.Y
    vmul.f32    q10, q10, q0       // R * C.Z
    vmul.f32    q11, q11, q0       // R * C.W

    vst1.f32    {q8-q9}, [r2]!
    vst1.f32    {q10-q11}, [r2]
    bx          lr

_neg_matrix4: // (const A: TMatrix4; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]! // row 0-1
    vld1.32     {q2-q3}, [r0]  // row 2-3
    vneg.f32    q0, q0
    vneg.f32    q1, q1
    vneg.f32    q2, q2
    vneg.f32    q3, q3
    vst1.f32    {q0-q1}, [r1]!
    vst1.f32    {q2-q3}, [r1]
    bx          lr

_matrix4_add_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]! // row 0-1
    vld1.32     {q2-q3}, [r0]  // row 2-3
    vdup.f32    q8, r1
    vadd.f32    q0, q0, q8
    vadd.f32    q1, q1, q8
    vadd.f32    q2, q2, q8
    vadd.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_scalar_add_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    vdup.f32    q8, r0
    vld1.32     {q0-q1}, [r1]! // row 0-1
    vld1.32     {q2-q3}, [r1]  // row 2-3
    vadd.f32    q0, q0, q8
    vadd.f32    q1, q1, q8
    vadd.f32    q2, q2, q8
    vadd.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_matrix4_add_matrix4: // (const A, B: TMatrix4; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]!   // A0-1
    vld1.32     {q2-q3}, [r0]    // A2-3
    vld1.32     {q8-q9}, [r1]!   // B0-1
    vld1.32     {q10-q11}, [r1]  // B2-3
    vadd.f32    q0, q0, q8
    vadd.f32    q1, q1, q9
    vadd.f32    q2, q2, q10
    vadd.f32    q3, q3, q11
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_matrix4_sub_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]! // row 0-1
    vld1.32     {q2-q3}, [r0]  // row 2-3
    vdup.f32    q8, r1
    vsub.f32    q0, q0, q8
    vsub.f32    q1, q1, q8
    vsub.f32    q2, q2, q8
    vsub.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_scalar_sub_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    vdup.f32    q8, r0
    vld1.32     {q0-q1}, [r1]! // row 0-1
    vld1.32     {q2-q3}, [r1]  // row 2-3
    vsub.f32    q0, q8, q0
    vsub.f32    q1, q8, q1
    vsub.f32    q2, q8, q2
    vsub.f32    q3, q8, q3
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_matrix4_sub_matrix4: // (const A, B: TMatrix4; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]!   // A0-1
    vld1.32     {q2-q3}, [r0]    // A2-3
    vld1.32     {q8-q9}, [r1]!   // B0-1
    vld1.32     {q10-q11}, [r1]  // B2-3
    vsub.f32    q0, q0, q8
    vsub.f32    q1, q1, q9
    vsub.f32    q2, q2, q10
    vsub.f32    q3, q3, q11
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_matrix4_mul_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]! // row 0-1
    vld1.32     {q2-q3}, [r0]  // row 2-3
    vdup.f32    q8, r1
    vmul.f32    q0, q0, q8
    vmul.f32    q1, q1, q8
    vmul.f32    q2, q2, q8
    vmul.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_scalar_mul_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    vdup.f32    q8, r0
    vld1.32     {q0-q1}, [r1]! // row 0-1
    vld1.32     {q2-q3}, [r1]  // row 2-3
    vmul.f32    q0, q0, q8
    vmul.f32    q1, q1, q8
    vmul.f32    q2, q2, q8
    vmul.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_vector4_mul_matrix4: // (const A: TVector4; const B: TMatrix4; out Result: TVector4);
    vld4.32     {d0, d2, d4, d6}, [r1]! // q0: B30 B20 B10 B00 (deinterleaved)
                                        // q1: B31 B21 B11 B01
    vld4.32     {d1, d3, d5, d7}, [r1]  // q2: B32 B22 B12 B02
                                        // q3: B33 B23 B13 B03
    vld1.32     {q8}, [r0]              // q8: A.W A.Z A.Y A.X
    vmul.f32    q0, q0, q8     // (A.W*B30) (A.Z*B20) (A.Y*B10) (A.X*B00)
    vmul.f32    q1, q1, q8     // (A.W*B31) (A.Z*B21) (A.Y*B11) (A.X*B01)
    vmul.f32    q2, q2, q8     // (A.W*B32) (A.Z*B22) (A.Y*B12) (A.X*B02)
    vmul.f32    q3, q3, q8     // (A.W*B33) (A.Z*B23) (A.Y*B13) (A.X*B03)
    vpadd.f32   d0, d0, d1     // (A.W*B30)+(A.Z*B20) (A.Y*B10)+(A.X*B00)
    vpadd.f32   d2, d2, d3     // (A.W*B31)+(A.Z*B21) (A.Y*B11)+(A.X*B01)
    vpadd.f32   d4, d4, d5     // (A.W*B32)+(A.Z*B22) (A.Y*B12)+(A.X*B02)
    vpadd.f32   d6, d6, d7     // (A.W*B33)+(A.Z*B23) (A.Y*B13)+(A.X*B03)
    vpadd.f32   d0, d0, d2
    vpadd.f32   d1, d4, d6
    vst1.32     {q0}, [r2]
    bx          lr

_matrix4_mul_vector4: // (const A: TMatrix4; const B: TVector4; out Result: TVector4);
    vld1.32     {q8}, [r1]     // q8: B.W B.Z B.Y B.X
    vld1.32     {q0-q1}, [r0]! // q0: A03 A02 A01 A00
                               // q1: A13 A12 A11 A10
    vld1.32     {q2-q3}, [r0]  // q2: A23 A22 A21 A20
                               // q3: A33 A32 A31 A30
    vmul.f32    q0, q0, q8     // (B.W*A03) (B.Z*A02) (B.Y*A01) (B.X*A00)
    vmul.f32    q1, q1, q8     // (B.W*A13) (B.Z*A12) (B.Y*A11) (B.X*A10)
    vmul.f32    q2, q2, q8     // (B.W*A23) (B.Z*A22) (B.Y*A21) (B.X*A20)
    vmul.f32    q3, q3, q8     // (B.W*A33) (B.Z*A32) (B.Y*A31) (B.X*A30)
    vpadd.f32   d0, d0, d1     // (B.W*A03)+(B.Z*A02) (B.Y*A01)+(B.X*A00)
    vpadd.f32   d2, d2, d3     // (B.W*A13)+(B.Z*A12) (B.Y*A11)+(B.X*A10)
    vpadd.f32   d4, d4, d5     // (B.W*A23)+(B.Z*A22) (B.Y*A21)+(B.X*A20)
    vpadd.f32   d6, d6, d7     // (B.W*A33)+(B.Z*A32) (B.Y*A31)+(B.X*A30)
    vpadd.f32   d0, d0, d2
    vpadd.f32   d1, d4, d6
    vst1.32     {q0}, [r2]
    bx          lr

_matrix4_mul_matrix4: // (const A, B: TMatrix4; out Result: TMatrix4);
    // Implemented as 4 Vector*Matrix calculations
    vld4.32     {d0, d2, d4, d6}, [r1]! //  q0: B30 B20 B10 B00 (deinterleaved)
                                        //  q1: B31 B21 B11 B01
    vld4.32     {d1, d3, d5, d7}, [r1]  //  q2: B32 B22 B12 B02
                                        //  q3: B33 B23 B13 B03
    vld1.32     {q8-q9}, [r0]!          //  q8: A03 A02 A01 A00
                                        //  q9: A13 A12 A11 A10
    vld1.32     {q10-q11}, [r0]         // q10: A23 A22 A21 A20
                                        // q11: A33 A32 A31 A30

    // A.R[0] * B
    vmul.f32    q12, q0, q8
    vmul.f32    q13, q1, q8
    vmul.f32    q14, q2, q8
    vmul.f32    q15, q3, q8
    vpadd.f32   d24, d24, d25
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d30, d30, d31
    vpadd.f32   d24, d24, d26
    vpadd.f32   d25, d28, d30
    vst1.32     {q12}, [r2]!

    // A.R[1] * B
    vmul.f32    q12, q0, q9
    vmul.f32    q13, q1, q9
    vmul.f32    q14, q2, q9
    vmul.f32    q15, q3, q9
    vpadd.f32   d24, d24, d25
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d30, d30, d31
    vpadd.f32   d24, d24, d26
    vpadd.f32   d25, d28, d30
    vst1.32     {q12}, [r2]!

    // A.R[2] * B
    vmul.f32    q12, q0, q10
    vmul.f32    q13, q1, q10
    vmul.f32    q14, q2, q10
    vmul.f32    q15, q3, q10
    vpadd.f32   d24, d24, d25
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d30, d30, d31
    vpadd.f32   d24, d24, d26
    vpadd.f32   d25, d28, d30
    vst1.32     {q12}, [r2]!

    // A.R[3] * B
    vmul.f32    q12, q0, q11
    vmul.f32    q13, q1, q11
    vmul.f32    q14, q2, q11
    vmul.f32    q15, q3, q11
    vpadd.f32   d24, d24, d25
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d30, d30, d31
    vpadd.f32   d24, d24, d26
    vpadd.f32   d25, d28, d30
    vst1.32     {q12}, [r2]!

    bx          lr

_matrix4_div_scalar: // (const A: TMatrix4; const B: Single; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]! // row 0-1
    vld1.32     {q2-q3}, [r0]  // row 2-3
    vdup.f32    q8, r1
    RECIPQ_MED  q8, q8         // 1 / B
    vmul.f32    q0, q0, q8
    vmul.f32    q1, q1, q8
    vmul.f32    q2, q2, q8
    vmul.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_scalar_div_matrix4: // (const A: Single; const B: TMatrix4; out Result: TMatrix4);
    vdup.f32    q8, r0
    vld1.32     {q0-q1}, [r1]! // row 0-1
    vld1.32     {q2-q3}, [r1]  // row 2-3
    RECIPQ_MED  q0, q0         // 1 / B0
    RECIPQ_MED  q1, q1         // 1 / B1
    RECIPQ_MED  q2, q2         // 1 / B2
    RECIPQ_MED  q3, q3         // 1 / B3
    vmul.f32    q0, q0, q8
    vmul.f32    q1, q1, q8
    vmul.f32    q2, q2, q8
    vmul.f32    q3, q3, q8
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_matrix4_comp_mult: // (const A, B: TMatrix4; out Result: TMatrix4);
    vld1.32     {q0-q1}, [r0]!  // A, Rows 0-1
    vld1.32     {q2-q3}, [r0]   // A, Rows 2-3
    vld1.32     {q8-q9}, [r1]!  // B, Rows 0-1
    vld1.32     {q10-q11}, [r1] // B, Rows 2-3
    vmul.f32    q0, q0, q8
    vmul.f32    q1, q1, q9
    vmul.f32    q2, q2, q10
    vmul.f32    q3, q3, q11
    vst1.f32    {q0-q1}, [r2]!
    vst1.f32    {q2-q3}, [r2]
    bx          lr

_matrix4_transpose: // (const A: TMatrix4; out Result: TMatrix4);
    /*                           Original:    M03 M02 M01 M00
                                              M13 M12 M11 M10
                                              M23 M22 M21 M20
                                              M33 M32 M31 M30 */
    vld4.32     {d0, d2, d4, d6}, [r0]! // q0=M30 M20 M10 M00 (deinterleaved)
                                        // q1=M31 M21 M11 M01
    vld4.32     {d1, d3, d5, d7}, [r0]  // q2=M32 M22 M12 M02
                                        // q3=M33 M23 M13 M03
    vst1.32     {q0-q1}, [r1]!
    vst1.32     {q2-q3}, [r1]
    bx          lr

_matrix4_inverse: // (const A: TMatrix4; out Result: TMatrix4);
    vpush       {q4-q7}
    mov         r2, r0
    vld1.32     {q4-q5}, [r0]! // q4   d9=M03 M02   d8=M01 M00
                               // q5  d11=M13 M12  d10=M11 M10
    vld1.32     {q6-q7}, [r0]  // q6  d13=M23 M22  d12=M21 M20
                               // q7  d15=M33 M32  d14=M31 M30

    /* C00 := (A.M[2,2] * A.M[3,3]) - (A.M[3,2] * A.M[2,3]);
       C02 := (A.M[1,2] * A.M[3,3]) - (A.M[3,2] * A.M[1,3]);
       C03 := (A.M[1,2] * A.M[2,3]) - (A.M[2,2] * A.M[1,3]);
       F0 := Vector4(C00, C00, C02, C03); */
    vdup.32     q0, d15[1]     // q0   d1=M33 M33   d0=M33 M33
    vmov        s3, s27        // q0   d1=M23 M33   d0=M33 M33
    vdup.32     d2, d13[0]
    vdup.32     d3, d11[0]     // q1   d3=M12 M12   d2=M22 M22
    vdup.32     q2, d15[0]     // q2   d5=M32 M32   d4=M32 M32
    vmov        s11, s26       // q2   d5=M22 M32   d4=M32 M32
    vdup.32     d6, d13[1]
    vdup.32     d7, d11[1]     // q3   d7=M13 M13   d6=M23 M23
    vmov        q12, q0
    vmov        q13, q1
    vmov        q14, q2
    vmov        q15, q3
    vmul.f32    q8, q0, q1     // (M12 * M23) (M12 * M33) (M22 * M33) (M22 * M33)
    vmls.f32    q8, q2, q3     // q8=F0: C03=(M12*M23)-(M22*M13), C02=(M12*M33)-(M32*M13), C00=(M22*M33)-(M32*M23), C00=(M22*M33)-(M32*M23)

    /* C04 := (A.M[2,1] * A.M[3,3]) - (A.M[3,1] * A.M[2,3]);
       C06 := (A.M[1,1] * A.M[3,3]) - (A.M[3,1] * A.M[1,3]);
       C07 := (A.M[1,1] * A.M[2,3]) - (A.M[2,1] * A.M[1,3]);
       F1 := Vector4(C04, C04, C06, C07); */
    vdup.32     d2, d12[1]
    vdup.32     d3, d10[1]     // q1   d3=M11 M11   d2=M21 M21
    vdup.32     q2, d14[1]     // q2   d5=M31 M31   d4=M31 M31
    vmov        s11, s25       // q2   d5=M21 M31   d4=M31 M31
    vmul.f32    q9, q0, q1     // (M11 * M23) (M11 * M33) (M21 * M33) (M21 * M33)
    vmls.f32    q9, q2, q3     // q9=F1: C07=(M11*M23)-(M21*M13), C06=(M11*M33)-(M31*M13), C04=(M21*M33)-(M31*M23), C04=(M21*M33)-(M31*M23)

    /* C08 := (A.M[2,1] * A.M[3,2]) - (A.M[3,1] * A.M[2,2]);
       C10 := (A.M[1,1] * A.M[3,2]) - (A.M[3,1] * A.M[1,2]);
       C11 := (A.M[1,1] * A.M[2,2]) - (A.M[2,1] * A.M[1,2]);
       F2 := Vector4(C08, C08, C10, C11); */
    vmov        q0, q14        // q0   d1=M22 M32   d0=M32 M32
    vmov        q3, q13        // q3   d7=M12 M12   d6=M22 M22
    vmul.f32    q10, q0, q1    // (M11 * M22) (M11 * M32) (M21 * M32) (M21 * M32)
    vmls.f32    q10, q2, q3    // q10=F2: C11=(M11*M22)-(M21*M12), C10=(M11*M32)-(M31*M12), C08=(M21*M32)-(M31*M22), C08=(M21*M32)-(M31*M22)

    /* C12 := (A.M[2,0] * A.M[3,3]) - (A.M[3,0] * A.M[2,3]);
       C14 := (A.M[1,0] * A.M[3,3]) - (A.M[3,0] * A.M[1,3]);
       C15 := (A.M[1,0] * A.M[2,3]) - (A.M[2,0] * A.M[1,3]);
       F3 := Vector4(C12, C12, C14, C15); */
    vmov        q0, q12        // q0   d1=M23 M33   d0=M33 M33
    vdup.32     d2, d12[0]
    vdup.32     d3, d10[0]     // q1   d3=M10 M10   d2=M20 M20
    vdup.32     q2, d14[0]     // q2   d5=M30 M30   d4=M30 M30
    vmov        s11, s24       // q2   d5=M20 M30   d4=M30 M30
    vmov        q3, q15        // q3   d7=M13 M13   d6=M23 M23
    vmul.f32    q11, q0, q1    // (M10 * M23) (M10 * M33) (M20 * M33) (M20 * M33)
    vmls.f32    q11, q2, q3    // q11=F3: C15=(M10*M23)-(M20*M13), C14=(M10*M33)-(M30*M13), C12=(M20*M33)-(M30*M23), C12=(M20*M33)-(M30*M23)

    /* C16 := (A.M[2,0] * A.M[3,2]) - (A.M[3,0] * A.M[2,2]);
       C18 := (A.M[1,0] * A.M[3,2]) - (A.M[3,0] * A.M[1,2]);
       C19 := (A.M[1,0] * A.M[2,2]) - (A.M[2,0] * A.M[1,2]);
       F4 := Vector4(C16, C16, C18, C19); */
    vmov        q0, q14        // q0   d1=M22 M32   d0=M32 M32
    vmov        q3, q13        // q3   d7=M12 M12   d6=M22 M22
    vmul.f32    q12, q0, q1    // (M10 * M22) (M10 * M32) (M20 * M32) (M20 * M32)
    vmls.f32    q12, q2, q3    // q12=F4: C19=(M10*M22)-(M20*M12), C18=(M10*M32)-(M30*M12), C16=(M20*M32)-(M30*M22), C16=(M20*M32)-(M30*M22)

    /* C20 := (A.M[2,0] * A.M[3,1]) - (A.M[3,0] * A.M[2,1]);
       C22 := (A.M[1,0] * A.M[3,1]) - (A.M[3,0] * A.M[1,1]);
       C23 := (A.M[1,0] * A.M[2,1]) - (A.M[2,0] * A.M[1,1]);
       F5 := Vector4(C20, C20, C22, C23); */
    vdup.32     q0, d14[1]     // q0   d1=M31 M31   d0=M31 M31
    vmov        s3, s25        // q0   d1=M21 M31   d0=M31 M31
    vdup.32     d6, d12[1]
    vdup.32     d7, d10[1]     // q3   d7=M11 M11   d6=M21 231
    vmul.f32    q13, q0, q1    // (M10 * M21) (M10 * M31) (M20 * M31) (M20 * M31)
    vmls.f32    q13, q2, q3    // q13=F5: C23=(M10*M21)-(M20*M11), C22=(M10*M31)-(M30*M11), C20=(M20*M31)-(M30*M21), C20=(M20*M31)-(M30*M21)

    /* V0 := Vector4(A.M[1,0], A.M[0,0], A.M[0,0], A.M[0,0]);
       V1 := Vector4(A.M[1,1], A.M[0,1], A.M[0,1], A.M[0,1]);
       V2 := Vector4(A.M[1,2], A.M[0,2], A.M[0,2], A.M[0,2]);
       V3 := Vector4(A.M[1,3], A.M[0,3], A.M[0,3], A.M[0,3]); */
    vdup.32     q0, d8[0]      // q0   d1=M00 M00   d0=M00 M00
    vdup.32     q1, d8[1]      // q1   d3=M01 M01   d2=M01 M01
    vdup.32     q2, d9[0]      // q2   d5=M02 M02   d4=M02 M02
    vdup.32     q3, d9[1]      // q3   d7=M03 M03   d6=M03 M03
    vmov        s0, s20        // q0=V0: d1=M00 M00   d0=M00 M10
    vmov        s4, s21        // q1=V1: d3=M01 M01   d2=M01 M11
    vmov        s8, s22        // q2=V2: d5=M02 M02   d4=M02 M12
    vmov        s12, s23       // q3=V3: d7=M03 M03   d6=M03 M13

    /* I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
       I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
       I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
       I3 := (V0 * F2) - (V1 * F4) + (V2 * F5); */
    vmul.f32    q4, q1, q8     // V1 * F0
    vmul.f32    q5, q0, q8     // V0 * F0
    vmul.f32    q6, q0, q9     // V0 * F1
    vmul.f32    q7, q0, q10    // V0 * F2
    vmls.f32    q4, q2, q9     // (V1 * F0) - (V2 * F1)
    vmls.f32    q5, q2, q11    // (V0 * F0) - (V2 * F3)
    vmls.f32    q6, q1, q11    // (V0 * F1) - (V1 * F3)
    vmls.f32    q7, q1, q12    // (V0 * F2) - (V1 * F4)
    vmla.f32    q4, q3, q10    // q4=I0 := (V1 * F0) - (V2 * F1) + (V3 * F2)
    vmla.f32    q5, q3, q12    // q5=I1 := (V0 * F0) - (V2 * F3) + (V3 * F4)
    vmla.f32    q6, q3, q13    // q6=I2 := (V0 * F1) - (V1 * F3) + (V3 * F5)
    vmla.f32    q7, q2, q13    // q7=I3 := (V0 * F2) - (V1 * F4) + (V2 * F5)

    /* SA := Vector4(+1, -1, +1, -1);
       SB := Vector4(-1, +1, -1, +1);
       Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB); */
    vneg.f32    s17, s17
    vneg.f32    s19, s19
    vneg.f32    s20, s20
    vneg.f32    s22, s22
    vneg.f32    s25, s25
    vneg.f32    s27, s27
    vneg.f32    s28, s28
    vneg.f32    s30, s30       // Inv=q4-q7

    /* Col := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
       Dot := A.R[0] * Col; */
    vld1.32     {q0}, [r2]     // s0-s3=A.R[0]
    vmul.f32    s0, s0, s16
    vmul.f32    s1, s1, s20
    vmul.f32    s2, s2, s24
    vmul.f32    s3, s3, s28    // q0=Dot := A.R[0] * Col

    /* OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W)); */
    vpadd.f32   d0, d0, d1     // Dot.W+Dot.Z Dot.Y+Dot.X
    vpadd.f32   d0, d0, d0     // Dot.W+Dot.Z+Dot.Y+Dot.X (2x)
    RECIPD_MED  d0, d0         // 1/(Dot.W+Dot.Z+Dot.Y+Dot.X) (2x)

    /* Result := Inv * OneOverDeterminant; */
    vmov        d1, d0         // q0=1/(Dot.W+Dot.Z+Dot.Y+Dot.X) (4x)
    vmul.f32    q4, q4, q0
    vmul.f32    q5, q5, q0
    vmul.f32    q6, q6, q0
    vmul.f32    q7, q7, q0

    vst1.32     {q4-q5}, [r1]!
    vst1.32     {q6-q7}, [r1]

    vpop        {q4-q7}
    bx          lr

#endif // __LP64__