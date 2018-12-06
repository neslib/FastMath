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
    .globl _outer_product_matrix3
    .globl _neg_matrix3
    .globl _matrix3_add_scalar, _scalar_add_matrix3, _matrix3_add_matrix3
    .globl _matrix3_sub_scalar, _scalar_sub_matrix3, _matrix3_sub_matrix3
    .globl _matrix3_mul_scalar, _scalar_mul_matrix3, _matrix3_mul_vector3, _vector3_mul_matrix3, _matrix3_mul_matrix3
    .globl _matrix3_div_scalar, _scalar_div_matrix3
    .globl _matrix3_comp_mult, _matrix3_transpose

_outer_product_matrix3: // (const C, R: TVector3; out Result: TMatrix3);
    fldmias     r1, {s0-s2}        // R.W R.Z R.Y R.X
    fldmias     r0, {s4-s6}        // C.W C.Z C.Y C.X

    vdup.32     q2, d2[0]          // C.X (4x)
    vdup.32     q3, d2[1]          // C.Y (4x)
    vdup.32     q8, d3[0]          // C.Z (4x)

    vmul.f32    q2, q2, q0         // R * C.X
    vmul.f32    q3, q3, q0         // R * C.Y
    vmul.f32    q8, q8, q0         // R * C.Z

    fstmias     r2!, {s8-s10}
    vmov        q0, q8
    fstmias     r2!, {s12-s14}
    fstmias     r2, {s0-s2}
    bx          lr

_neg_matrix3: // (const A: TMatrix3; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vneg.f32    q0, q0
    vneg.f32    q1, q1
    vneg.f32    s8, s8
    vst1.f32    {q0-q1}, [r1]!
    fsts        s8, [r1]
    bx          lr

_matrix3_add_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vdup.f32    q3, r1
    vadd.f32    q0, q0, q3
    vadd.f32    q1, q1, q3
    vadd.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_scalar_add_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    vdup.f32    q3, r0
    vld1.32     {q0-q1}, [r1]!
    flds        s8, [r1]
    vadd.f32    q0, q0, q3
    vadd.f32    q1, q1, q3
    vadd.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_matrix3_add_matrix3: // (const A, B: TMatrix3; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vld1.32     {q8-q9}, [r1]! 
    flds        s9, [r1]
    vadd.f32    q0, q0, q8
    vadd.f32    q1, q1, q9
    vadd.f32    s8, s8, s9
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_matrix3_sub_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vdup.f32    q3, r1
    vsub.f32    q0, q0, q3
    vsub.f32    q1, q1, q3
    vsub.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_scalar_sub_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    vdup.f32    q3, r0
    vld1.32     {q0-q1}, [r1]! 
    flds        s8, [r1]
    vsub.f32    q0, q3, q0
    vsub.f32    q1, q3, q1
    vsub.f32    s8, s12, s8
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_matrix3_sub_matrix3: // (const A, B: TMatrix3; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]!
    flds        s8, [r0]
    vld1.32     {q8-q9}, [r1]!
    flds        s9, [r1]
    vsub.f32    q0, q0, q8
    vsub.f32    q1, q1, q9
    vsub.f32    s8, s8, s9
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_matrix3_mul_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vdup.f32    q3, r1
    vmul.f32    q0, q0, q3
    vmul.f32    q1, q1, q3
    vmul.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_scalar_mul_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    vdup.f32    q3, r0
    vld1.32     {q0-q1}, [r1]! 
    flds        s8, [r1]
    vmul.f32    q0, q0, q3
    vmul.f32    q1, q1, q3
    vmul.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_vector3_mul_matrix3: // (const A: TVector3; const B: TMatrix3; out Result: TVector3);
    vld3.32     {d0, d2, d4}, [r1]!     // q0: ### ### B10 B00 (deinterleaved)
                                        // q1: ### ### B11 B01
                                        // q2: ### ### B12 B02
    flds        s2, [r1]                // q0: ### B20 B10 B00
    flds        s6, [r1, #4]            // q1: ### B21 B11 B01
    flds        s10, [r1, #8]           // q2: ### B22 B12 B02
                                     
    fldmias     r0, {s12-s14}           // q3: ### A.Z A.Y A.X
    vmov.i64    d31, 0x00000000FFFFFFFF
    vand.32     d7, d7, d31             // q3:   0 A.Z A.Y A.X
    vmul.f32    q0, q0, q3     // (0*###) (A.Z*B20) (A.Y*B10) (A.X*A00)
    vmul.f32    q1, q1, q3     // (0*###) (A.Z*B21) (A.Y*B11) (A.X*A01)
    vmul.f32    q2, q2, q3     // (0*###) (A.Z*B22) (A.Y*B12) (A.X*A02)
    vpadd.f32   d0, d0, d1     // (0)+(A.Z*B20) (A.Y*B10)+(A.B*A00)
    vpadd.f32   d2, d2, d3     // (0)+(A.Z*B21) (A.Y*B11)+(A.B*A01)
    vpadd.f32   d4, d4, d5     // (0)+(A.Z*B22) (A.Y*B12)+(A.B*A02)
    vpadd.f32   d0, d0, d2
    vpadd.f32   d1, d4, d4
    fstmias     r2, {s0-s2}
    bx          lr

_matrix3_mul_vector3: // (const A: TMatrix3; const B: TVector3; out Result: TVector3);
    fldmias     r1, {s12-s14}  // q3: ### B.Z B.Y B.X
    vmov.i64    d31, 0x00000000FFFFFFFF
    vand.32     d7, d7, d31    // q3:   0 B.Z B.Y B.X
    fldmias     r0!, {s0-s2}   // q0: ### A02 A01 A00
    fldmias     r0!, {s4-s6}   // q1: ### A12 A11 A10
    fldmias     r0, {s8-s10}   // q2: ### A22 A21 A20
    vmul.f32    q0, q0, q3     // (0*###) (B.Z*A02) (B.Y*A01) (B.X*A00)
    vmul.f32    q1, q1, q3     // (0*###) (B.Z*A12) (B.Y*A11) (B.X*A10)
    vmul.f32    q2, q2, q3     // (0*###) (B.Z*A22) (B.Y*A21) (B.X*A20)
    vpadd.f32   d0, d0, d1     // (0)+(B.Z*A02) (B.Y*A01)+(B.X*A00)
    vpadd.f32   d2, d2, d3     // (0)+(B.Z*A12) (B.Y*A11)+(B.X*A10)
    vpadd.f32   d4, d4, d5     // (0)+(B.Z*A22) (B.Y*A21)+(B.X*A20)
    vpadd.f32   d0, d0, d2
    vpadd.f32   d1, d4, d4
    fstmias     r2, {s0-s2}
    bx          lr

_matrix3_mul_matrix3: // (const A, B: TMatrix3; out Result: TMatrix3);
    // Implemented as 4 Vector*Matrix calculations
    vpush       {q4-q6}
    
    vld3.32     {d0, d2, d4}, [r1]!     // q0: ### ### B10 B00 (deinterleaved)
                                        // q1: ### ### B11 B01
                                        // q2: ### ### B12 B02
    flds        s2, [r1]                // q0: ### B20 B10 B00
    flds        s6, [r1, #4]            // q1: ### B21 B11 B01
    flds        s10, [r1, #8]           // q2: ### B22 B12 B02

    fldmias     r0!, {s12-s14}          // q3: ### A02 A01 A00
    fldmias     r0!, {s16-s18}          // q4: ### A12 A11 A10
    fldmias     r0, {s20-s22}           // q5: ### A22 A21 A20
    
    vmov.i64    d31, 0x00000000FFFFFFFF
    vand.32     d7, d7, d31             // q3:   0 A02 A01 A00
    vand.32     d9, d9, d31             // q4:   0 A12 A11 A10
    vand.32     d11, d11, d31           // q5:   0 A22 A21 A20

    // A.R[0] * B
    vmul.f32    q6, q0, q3
    vmul.f32    q13, q1, q3
    vmul.f32    q14, q2, q3
    vpadd.f32   d12, d12, d13
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d12, d12, d26
    vpadd.f32   d13, d28, d28
    fstmias     r2!, {s24-s26}

    // A.R[1] * B
    vmul.f32    q6, q0, q4
    vmul.f32    q13, q1, q4
    vmul.f32    q14, q2, q4
    vpadd.f32   d12, d12, d13
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d12, d12, d26
    vpadd.f32   d13, d28, d28
    fstmias     r2!, {s24-s26}

    // A.R[2] * B
    vmul.f32    q6, q0, q5
    vmul.f32    q13, q1, q5
    vmul.f32    q14, q2, q5
    vpadd.f32   d12, d12, d13
    vpadd.f32   d26, d26, d27
    vpadd.f32   d28, d28, d29
    vpadd.f32   d12, d12, d26
    vpadd.f32   d13, d28, d28
    fstmias     r2, {s24-s26}

    vpop        {q4-q6}
    bx          lr

_matrix3_div_scalar: // (const A: TMatrix3; const B: Single; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vdup.f32    q3, r1
    RECIPQ_MED  q3, q3         // 1 / B
    vmul.f32    q0, q0, q3
    vmul.f32    q1, q1, q3
    vmul.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_scalar_div_matrix3: // (const A: Single; const B: TMatrix3; out Result: TMatrix3);
    vdup.f32    q3, r0
    vld1.32     {q0-q1}, [r1]! 
    flds        s8, [r1]
    RECIPQ_MED  q0, q0
    RECIPQ_MED  q1, q1
    RECIPD_MED  d4, d4
    vmul.f32    q0, q0, q3
    vmul.f32    q1, q1, q3
    vmul.f32    s8, s8, s12
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_matrix3_comp_mult: // (const A, B: TMatrix3; out Result: TMatrix3);
    vld1.32     {q0-q1}, [r0]! 
    flds        s8, [r0]
    vld1.32     {q8-q9}, [r1]! 
    flds        s9, [r1]
    vmul.f32    q0, q0, q8
    vmul.f32    q1, q1, q9
    vmul.f32    s8, s8, s9
    vst1.f32    {q0-q1}, [r2]!
    fsts        s8, [r2]
    bx          lr

_matrix3_transpose: // (const A: TMatrix3; out Result: TMatrix3);
    /*                           Original:    ### M02 M01 M00
                                              ### M12 M11 M10
                                              ### M22 M21 M20 */
    vld3.32     {d0, d2, d4}, [r0]!    // q0: ### ### M10 M00 (deinterleaved)
                                       // q1: ### ### M11 M01
                                       // q2: ### ### M12 M02
    flds        s2, [r0]               // q0: ### M20 M10 M00
    flds        s6, [r0, #4]           // q1: ### M21 M11 M01
    flds        s10, [r0, #8]          // q2: ### M22 M12 M02
    fstmias     r1!, {s0-s2}
    fstmias     r1!, {s4-s6}
    fstmias     r1, {s8-s10}
    bx          lr

#endif // __LP64__