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
    .globl _fast_sincos_scalar, _fast_sincos_vector2, _fast_sincos_vector3, _fast_sincos_vector4
    .globl _fast_exp_scalar, _fast_exp_vector2, _fast_exp_vector3, _fast_exp_vector4
    .globl _fast_ln_scalar, _fast_ln_vector2, _fast_ln_vector3, _fast_ln_vector4
    .globl _fast_log2_scalar, _fast_log2_vector2, _fast_log2_vector3, _fast_log2_vector4
    .globl _fast_exp2_scalar, _fast_exp2_vector2, _fast_exp2_vector3, _fast_exp2_vector4

_fast_sincos_scalar: // (const A: Single; out Sin, Cos: Single);
    adr          r3, SINCOS_FACTORS_D
    vmov.f32     s0, r0
    vld1.32      {d16-d19}, [r3]! // (d16) FOPI
                                  // (d17) 1 (int)
                                  // (d18) not 1 (int)
                                  // (d19) 2 (int)
    vld1.32      {d20-d23}, [r3]! // (d20) Pi / 4
                                  // (d21) 4 (int)
                                  // (d22) COSCOF_P0
                                  // (d23) SINCOF_P0
    vld1.32      {d24-d27}, [r3]! // (d24) COSCOF_P1
                                  // (d25) SINCOF_P1
                                  // (d26) COSCOF_P2
                                  // (d27) SINCOF_P2
    vld1.32      {d28-d29}, [r3]  // (d28) 0.5
                                  // (d29) 1.0
    vclt.f32     d1, d0, #0       // (d1) SignMaskSin = Sign(A)
    vabs.f32     d0, d0           // (d0) X := Abs(A)
    vmul.f32     d2, d0, d16      //
    vcvt.u32.f32 d2, d2           // J := Trunc(X * FOPI)
    vadd.u32     d2, d2, d17
    vand.u32     d2, d2, d18      // (d2) J := (J + 1) and (not 1)
    vcvt.f32.u32 d3, d2           // (d3) Y := J
    vtst.u32     d31, d2, d19     // (d31) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vmls.f32     d0, d3, d20      // (d0) X := X - Y * Pi / 4
    vtst.u32     d30, d2, d21     // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    veor.32      d1, d1, d30      // (d1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    vsub.u32     d2, d2, d19      // J - 2
    vtst.u32     d30, d2, d21     // (d30) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vmul.f32     d2, d0, d0       // (d2) Z := X * X
    vmla.f32     d24, d2, d22     // Y1 := Z * COSCOF_P0 + COSCOF_P1
    vmla.f32     d25, d2, d23     // Y2 := Z * SINCOF_P0 + SINCOF_P1
    vmla.f32     d26, d24, d2     // Y1 := (Y1 * Z) + COSCOF_P2
    vmla.f32     d27, d25, d2     // Y2 := (Y2 * Z) + SINCOF_P2
    vmul.f32     d26, d26, d2     // Y1 * Z
    vmul.f32     d27, d27, d2     // Y2 * Z
    vmul.f32     d26, d26, d2     // Y1 := Y1 * (Z * Z)
    vmul.f32     d27, d27, d0     // Y2 * (Z * X)
    vmls.f32     d26, d2, d28     // Y1 := Y1 - 0.5 * Z
    vadd.f32     d27, d27, d0     // (d27) Y2 := Y2 * (Z * X) + X
    vadd.f32     d26, d26, d29    // (d26) Y1 := Y1 - 0.5 * Z + 1
    vmov         d7, d31
    vbsl.f32     d31, d26, d27    // (d31) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    vbsl.f32     d7, d27, d26     // (d7)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    vneg.f32     d0, d31          // (d0) -YS
    vneg.f32     d2, d7           // (d2) -YC
    vbsl.f32     d1, d0, d31      // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    vbsl.f32     d30, d7, d2      // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    vst1.32      {d1[0]}, [r1]
    vst1.32      {d30[0]}, [r2]
    bx           lr
    
_fast_sincos_vector2: // (const A: TVector2; out Sin, Cos: TVector2);
    adr          r3, SINCOS_FACTORS_D
    vld1.32      {d0}, [r0]
    vld1.32      {d16-d19}, [r3]! // (d16) FOPI
                                  // (d17) 1 (int)
                                  // (d18) not 1 (int)
                                  // (d19) 2 (int)
    vld1.32      {d20-d23}, [r3]! // (d20) Pi / 4
                                  // (d21) 4 (int)
                                  // (d22) COSCOF_P0
                                  // (d23) SINCOF_P0
    vld1.32      {d24-d27}, [r3]! // (d24) COSCOF_P1
                                  // (d25) SINCOF_P1
                                  // (d26) COSCOF_P2
                                  // (d27) SINCOF_P2
    vld1.32      {d28-d29}, [r3]  // (d28) 0.5
                                  // (d29) 1.0
    vclt.f32     d1, d0, #0       // (d1) SignMaskSin = Sign(A)
    vabs.f32     d0, d0           // (d0) X := Abs(A)
    vmul.f32     d2, d0, d16      //
    vcvt.u32.f32 d2, d2           // J := Trunc(X * FOPI)
    vadd.u32     d2, d2, d17
    vand.u32     d2, d2, d18      // (d2) J := (J + 1) and (not 1)
    vcvt.f32.u32 d3, d2           // (d3) Y := J
    vtst.u32     d31, d2, d19     // (d31) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vmls.f32     d0, d3, d20      // (d0) X := X - Y * Pi / 4
    vtst.u32     d30, d2, d21     // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    veor.32      d1, d1, d30      // (d1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    vsub.u32     d2, d2, d19      // J - 2
    vtst.u32     d30, d2, d21     // (d30) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vmul.f32     d2, d0, d0       // (d2) Z := X * X
    vmla.f32     d24, d2, d22     // Y1 := Z * COSCOF_P0 + COSCOF_P1
    vmla.f32     d25, d2, d23     // Y2 := Z * SINCOF_P0 + SINCOF_P1
    vmla.f32     d26, d24, d2     // Y1 := (Y1 * Z) + COSCOF_P2
    vmla.f32     d27, d25, d2     // Y2 := (Y2 * Z) + SINCOF_P2
    vmul.f32     d26, d26, d2     // Y1 * Z
    vmul.f32     d27, d27, d2     // Y2 * Z
    vmul.f32     d26, d26, d2     // Y1 := Y1 * (Z * Z)
    vmul.f32     d27, d27, d0     // Y2 * (Z * X)
    vmls.f32     d26, d2, d28     // Y1 := Y1 - 0.5 * Z
    vadd.f32     d27, d27, d0     // (d27) Y2 := Y2 * (Z * X) + X
    vadd.f32     d26, d26, d29    // (d26) Y1 := Y1 - 0.5 * Z + 1
    vmov         d7, d31
    vbsl.f32     d31, d26, d27    // (d31) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    vbsl.f32     d7, d27, d26     // (d7)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    vneg.f32     d0, d31          // (d0) -YS
    vneg.f32     d2, d7           // (d2) -YC
    vbsl.f32     d1, d0, d31      // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    vbsl.f32     d30, d7, d2      // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    vst1.32      {d1}, [r1]
    vst1.32      {d30}, [r2]
    bx           lr

_fast_sincos_vector3: // (const A: TVector3; out Sin, Cos: TVector3);
    adr          r3, SINCOS_FACTORS_Q
    fldmias      r0, {s0-s2}
    vld1.32      {q8-q9}, [r3]!   // (q8) FOPI
                                  // (q9) 1 (int)
    vld1.32      {q10-q11}, [r3]! // (q10) not 1 (int)
                                  // (q11) 2 (int)
    vclt.f32     q1, q0, #0       // (q1) SignMaskSin = Sign(A)
    vabs.f32     q0, q0           // (q0) X := Abs(A)
    vmul.f32     q2, q0, q8       //
    vcvt.u32.f32 q2, q2           // J := Trunc(X * FOPI)
    vadd.u32     q2, q2, q9
    vand.u32     q2, q2, q10      // (q2) J := (J + 1) and (not 1)
    vcvt.f32.u32 q3, q2           // (q3) Y := J
    vtst.u32     q15, q2, q11     // (q15) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vld1.32      {q8-q9}, [r3]!   // (q8) Pi/4
                                  // (q9) 4 (int)
    vmls.f32     q0, q3, q8       // (q0) X := X - Y * Pi / 4
    vtst.u32     q14, q2, q9      // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    veor.32      q1, q1, q14      // (q1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    vsub.u32     q2, q2, q11      // J - 2
    vtst.u32     q14, q2, q9      // (q14) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vld1.32      {q8-q9}, [r3]!   // (q8) COSCOF_P0
                                  // (q9) SINCOF_P0
    vld1.32      {q10-q11}, [r3]! // (q10) COSCOF_P1
                                  // (q11) SINCOF_P1
    vld1.32      {q12-q13}, [r3]! // (q12) COSCOF_P2
                                  // (q13) SINCOF_P2
    vmul.f32     q2, q0, q0       // (q2) Z := X * X
    vmla.f32     q10, q2, q8      // Y1 := Z * COSCOF_P0 + COSCOF_P1
    vmla.f32     q11, q2, q9      // Y2 := Z * SINCOF_P0 + SINCOF_P1
    vmla.f32     q12, q10, q2     // Y1 := (Y1 * Z) + COSCOF_P2
    vmla.f32     q13, q11, q2     // Y2 := (Y2 * Z) + SINCOF_P2
    vmul.f32     q12, q12, q2     // Y1 * Z
    vmul.f32     q13, q13, q2     // Y2 * Z
    vmul.f32     q12, q12, q2     // Y1 := Y1 * (Z * Z)
    vmul.f32     q13, q13, q0     // Y2 * (Z * X)
    vld1.32      {q8-q9}, [r3]    // (q8) 0.5
                                  // (q9) 1.0
    vmls.f32     q12, q2, q8      // Y1 := Y1 - 0.5 * Z
    vadd.f32     q13, q13, q0     // (q13) Y2 := Y2 * (Z * X) + X
    vadd.f32     q12, q12, q9     // (q12) Y1 := Y1 - 0.5 * Z + 1
    vmov         q8, q15
    vbsl.f32     q15, q12, q13    // (q15) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    vbsl.f32     q8, q13, q12     // (q8)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    vneg.f32     q0, q15          // (q0) -YS
    vneg.f32     q2, q8           // (q2) -YC
    vbsl.f32     q1, q0, q15      // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    vbsl.f32     q14, q8, q2      // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    fstmias      r1, {s4-s6}      // q1
    vmov         q0, q14
    fstmias      r2, {s0-s2}
    bx           lr

_fast_sincos_vector4: // (const A: TVector4; out Sin, Cos: TVector4);
    adr          r3, SINCOS_FACTORS_Q
    vld1.32      {q0}, [r0]
    vld1.32      {q8-q9}, [r3]!   // (q8) FOPI
                                  // (q9) 1 (int)
    vld1.32      {q10-q11}, [r3]! // (q10) not 1 (int)
                                  // (q11) 2 (int)
    vclt.f32     q1, q0, #0       // (q1) SignMaskSin = Sign(A)
    vabs.f32     q0, q0           // (q0) X := Abs(A)
    vmul.f32     q2, q0, q8       //
    vcvt.u32.f32 q2, q2           // J := Trunc(X * FOPI)
    vadd.u32     q2, q2, q9
    vand.u32     q2, q2, q10      // (q2) J := (J + 1) and (not 1)
    vcvt.f32.u32 q3, q2           // (q3) Y := J
    vtst.u32     q15, q2, q11     // (q15) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vld1.32      {q8-q9}, [r3]!   // (q8) Pi/4
                                  // (q9) 4 (int)
    vmls.f32     q0, q3, q8       // (q0) X := X - Y * Pi / 4
    vtst.u32     q14, q2, q9      // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    veor.32      q1, q1, q14      // (q1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    vsub.u32     q2, q2, q11      // J - 2
    vtst.u32     q14, q2, q9      // (q14) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    vld1.32      {q8-q9}, [r3]!   // (q8) COSCOF_P0
                                  // (q9) SINCOF_P0
    vld1.32      {q10-q11}, [r3]! // (q10) COSCOF_P1
                                  // (q11) SINCOF_P1
    vld1.32      {q12-q13}, [r3]! // (q12) COSCOF_P2
                                  // (q13) SINCOF_P2
    vmul.f32     q2, q0, q0       // (q2) Z := X * X
    vmla.f32     q10, q2, q8      // Y1 := Z * COSCOF_P0 + COSCOF_P1
    vmla.f32     q11, q2, q9      // Y2 := Z * SINCOF_P0 + SINCOF_P1
    vmla.f32     q12, q10, q2     // Y1 := (Y1 * Z) + COSCOF_P2
    vmla.f32     q13, q11, q2     // Y2 := (Y2 * Z) + SINCOF_P2
    vmul.f32     q12, q12, q2     // Y1 * Z
    vmul.f32     q13, q13, q2     // Y2 * Z
    vmul.f32     q12, q12, q2     // Y1 := Y1 * (Z * Z)
    vmul.f32     q13, q13, q0     // Y2 * (Z * X)
    vld1.32      {q8-q9}, [r3]    // (q8) 0.5
                                  // (q9) 1.0
    vmls.f32     q12, q2, q8      // Y1 := Y1 - 0.5 * Z
    vadd.f32     q13, q13, q0     // (q13) Y2 := Y2 * (Z * X) + X
    vadd.f32     q12, q12, q9     // (q12) Y1 := Y1 - 0.5 * Z + 1
    vmov         q8, q15
    vbsl.f32     q15, q12, q13    // (q15) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    vbsl.f32     q8, q13, q12     // (q8)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    vneg.f32     q0, q15          // (q0) -YS
    vneg.f32     q2, q8           // (q2) -YC
    vbsl.f32     q1, q0, q15      // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    vbsl.f32     q14, q8, q2      // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    vst1.32      {q1}, [r1]
    vst1.32      {q14}, [r2]
    bx           lr

SINCOS_FACTORS_D:
    .float 1.27323954473516, 1.27323954473516
    .int 1, 1
    .int 0xFFFFFFFE, 0xFFFFFFFE
    .int 2, 2
    .float 0.78539816339744830961566084581988, 0.78539816339744830961566084581988
    .int 4, 4
    .float 2.443315711809948E-005, 2.443315711809948E-005
    .float -1.9515295891E-4, -1.9515295891E-4
    .float -1.388731625493765E-003, -1.388731625493765E-003
    .float 8.3321608736E-3, 8.3321608736E-3
    .float 4.166664568298827E-002, 4.166664568298827E-002
    .float -1.6666654611E-1, -1.6666654611E-1
    .float 0.5, 0.5
    .float 1.0, 1.0

SINCOS_FACTORS_Q:
    .float 1.27323954473516, 1.27323954473516, 1.27323954473516, 1.27323954473516
    .int 1, 1, 1, 1
    .int 0xFFFFFFFE, 0xFFFFFFFE, 0xFFFFFFFE, 0xFFFFFFFE
    .int 2, 2, 2, 2
    .float 0.78539816339744830961566084581988, 0.78539816339744830961566084581988, 0.78539816339744830961566084581988, 0.78539816339744830961566084581988
    .int 4, 4, 4, 4
    .float 2.443315711809948E-005, 2.443315711809948E-005, 2.443315711809948E-005, 2.443315711809948E-005
    .float -1.9515295891E-4, -1.9515295891E-4, -1.9515295891E-4, -1.9515295891E-4
    .float -1.388731625493765E-003, -1.388731625493765E-003, -1.388731625493765E-003, -1.388731625493765E-003
    .float 8.3321608736E-3, 8.3321608736E-3, 8.3321608736E-3, 8.3321608736E-3
    .float 4.166664568298827E-002, 4.166664568298827E-002, 4.166664568298827E-002, 4.166664568298827E-002
    .float -1.6666654611E-1, -1.6666654611E-1, -1.6666654611E-1, -1.6666654611E-1
    .float 0.5, 0.5, 0.5, 0.5
    .float 1.0, 1.0, 1.0, 1.0
    
_fast_exp_scalar: // (const A: Single): Single;
    adr         r2, EXP_FACTORS_D
    vmov.f32    s0, r0
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d23}, [r2]!
    vld1.32     {d24-d26}, [r2]

    vmla.f32    d23, d0, d22 // Val := 12102203.1615614 * A + 1065353216.0;
    vmin.f32    d0, d23, d21 // if (Val >= EXP_CST) then Val := EXP_CST;
    vcgt.f32    d1, d0, #0   // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    vcvt.s32.f32 d0, d0      // IVal := Trunc(Val)
    vand.32     d0, d0, d1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    vand.32     d1, d0, d24  // XU.I := IVal and $7F800000;
    vand.32     d2, d0, d25
    vorr.32     d2, d2, d26  // XU2.I := (IVal and $007FFFFF) or $3F800000;

    vmla.f32    d19, d2, d20 // F4+B*F5
    vmla.f32    d18, d2, d19 // F3+B*(F4+B*F5)
    vmla.f32    d17, d2, d18 // F2+B*(F3+B*(F4+B*F5))
    vmla.f32    d16, d2, d17 // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    vmul.f32    d0, d1, d16  // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    vmov.f32    r0, s0
    bx          lr

_fast_exp_vector2: // (const A: TVector2; out Result: TVector2);
    adr         r2, EXP_FACTORS_D
    vld1.32     {d0}, [r0]
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d23}, [r2]!
    vld1.32     {d24-d26}, [r2]

    vmla.f32    d23, d0, d22 // Val := 12102203.1615614 * A + 1065353216.0;
    vmin.f32    d0, d23, d21 // if (Val >= EXP_CST) then Val := EXP_CST;
    vcgt.f32    d1, d0, #0   // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    vcvt.s32.f32 d0, d0      // IVal := Trunc(Val)
    vand.32     d0, d0, d1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    vand.32     d1, d0, d24  // XU.I := IVal and $7F800000;
    vand.32     d2, d0, d25  
    vorr.32     d2, d2, d26  // XU2.I := (IVal and $007FFFFF) or $3F800000;

    vmla.f32    d19, d2, d20 // F4+B*F5
    vmla.f32    d18, d2, d19 // F3+B*(F4+B*F5)
    vmla.f32    d17, d2, d18 // F2+B*(F3+B*(F4+B*F5))
    vmla.f32    d16, d2, d17 // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    vmul.f32    d0, d1, d16  // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    vst1.32     {d0}, [r1]
    bx          lr

_fast_exp_vector3: // (const A: TVector3; out Result: TVector3);
    vpush       {q4-q6}
    adr         r2, EXP_FACTORS_Q
    fldmias     r0, {s0-s2}
    vld1.32     {q8-q9}, [r2]!
    vld1.32     {q10-q11}, [r2]!
    vld1.32     {q12-q13}, [r2]!
    vld1.32     {q14-q15}, [r2]!
    vld1.32     {q4-q5}, [r2]!
    vld1.32     {q6}, [r2]

    vmla.f32    q15, q0, q14 // Val := 12102203.1615614 * A + 1065353216.0;
    vmin.f32    q0, q15, q13 // if (Val >= EXP_CST) then Val := EXP_CST;
    vcgt.f32    q1, q0, #0   // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    vcvt.s32.f32 q0, q0      // IVal := Trunc(Val)
    vand.32     q0, q0, q1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    vand.32     q1, q0, q4   // XU.I := IVal and $7F800000;
    vand.32     q2, q0, q5  
    vorr.32     q2, q2, q6   // XU2.I := (IVal and $007FFFFF) or $3F800000;

    vmla.f32    q11, q2, q12 // F4+B*F5
    vmla.f32    q10, q2, q11 // F3+B*(F4+B*F5)
    vmla.f32    q9, q2, q10  // F2+B*(F3+B*(F4+B*F5))
    vmla.f32    q8, q2, q9   // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    vmul.f32    q0, q1, q8   // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    fstmias     r1, {s0-s2}
    vpop        {q4-q6}
    bx          lr

_fast_exp_vector4: // (const A: TVector4; out Result: TVector4);
    vpush       {q4-q6}
    adr         r2, EXP_FACTORS_Q
    vld1.32     {q0}, [r0]
    vld1.32     {q8-q9}, [r2]!
    vld1.32     {q10-q11}, [r2]!
    vld1.32     {q12-q13}, [r2]!
    vld1.32     {q14-q15}, [r2]!
    vld1.32     {q4-q5}, [r2]!
    vld1.32     {q6}, [r2]

    vmla.f32    q15, q0, q14 // Val := 12102203.1615614 * A + 1065353216.0;
    vmin.f32    q0, q15, q13 // if (Val >= EXP_CST) then Val := EXP_CST;
    vcgt.f32    q1, q0, #0   // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    vcvt.s32.f32 q0, q0      // IVal := Trunc(Val)
    vand.32     q0, q0, q1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    vand.32     q1, q0, q4   // XU.I := IVal and $7F800000;
    vand.32     q2, q0, q5  
    vorr.32     q2, q2, q6   // XU2.I := (IVal and $007FFFFF) or $3F800000;

    vmla.f32    q11, q2, q12 // F4+B*F5
    vmla.f32    q10, q2, q11 // F3+B*(F4+B*F5)
    vmla.f32    q9, q2, q10  // F2+B*(F3+B*(F4+B*F5))
    vmla.f32    q8, q2, q9   // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    vmul.f32    q0, q1, q8   // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    vst1.32     {q0}, [r1]
    vpop        {q4-q6}
    bx          lr

EXP_FACTORS_D:
    .float 0.509964287281036376953125, 0.509964287281036376953125               // d16 / F1
    .float 0.3120158612728118896484375, 0.3120158612728118896484375             // d17 / F2
    .float 0.1666135489940643310546875, 0.1666135489940643310546875             // d18 / F3
    .float -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3   // d19 / F4
    .float 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2 // d20 / F5
    .float 2139095040.0, 2139095040.0                                           // d21
    .float 12102203.1615614, 12102203.1615614                                   // d22
    .float 1065353216.0, 1065353216.0                                           // d23
    .int 0x7F800000, 0x7F800000                                                 // d24
    .int 0x007FFFFF, 0x007FFFFF                                                 // d25
    .int 0x3F800000, 0x3F800000                                                 // d26

EXP_FACTORS_Q:
    .float 0.509964287281036376953125, 0.509964287281036376953125, 0.509964287281036376953125, 0.509964287281036376953125
    .float 0.3120158612728118896484375, 0.3120158612728118896484375, 0.3120158612728118896484375, 0.3120158612728118896484375
    .float 0.1666135489940643310546875, 0.1666135489940643310546875, 0.1666135489940643310546875, 0.1666135489940643310546875
    .float -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3
    .float 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2
    .float 2139095040.0, 2139095040.0, 2139095040.0, 2139095040.0
    .float 12102203.1615614, 12102203.1615614, 12102203.1615614, 12102203.1615614
    .float 1065353216.0, 1065353216.0, 1065353216.0, 1065353216.0
    .int 0x7F800000, 0x7F800000, 0x7F800000, 0x7F800000
    .int 0x007FFFFF, 0x007FFFFF, 0x007FFFFF, 0x007FFFFF
    .int 0x3F800000, 0x3F800000, 0x3F800000, 0x3F800000
        
_fast_ln_scalar: // (const A: Single): Single;
    adr         r2, LN_FACTORS_D
    vmov.f32    s0, r0
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d23}, [r2]!
    vld1.32     {d24}, [r2]

    vshr.s32    d1, d0, #23  // Exp (Integer) := Val.I shr 23;
    vcvt.f32.s32 d1, d1      // Exp (Float)
    vcgt.f32    d2, d0, #0   // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     d3, d2, d21  // (A > 0)? Yes: -89.93423858, No: 0
    vbic.32     d4, d22, d2  // (A > 0)? Yes: 0, No: NegInfinity
    vorr.32     d4, d4, d3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    vand.32     d0, d0, d23
    vorr.32     d0, d0, d24  // Val.I := (Val.I and $007FFFFF) or $3F800000;
    vmul.f32    d2, d0, d0   // X := Val.I, X2 := X * X

    vmla.f32    d19, d18, d0 // F4+F3*X
    vsub.f32    d3, d0, d17  // X-F2
    vmla.f32    d3, d2, d19  // (X-F2)+X2*(F4+F3*X)
    vmla.f32    d4, d0, d16  // F1*X+AddCst
    vmla.f32    d4, d2, d3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    vmla.f32    d4, d20, d1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    vmov.f32    r0, s8
    bx          lr

_fast_ln_vector2: // (const A: TVector2; out Result: TVector2);
    adr         r2, LN_FACTORS_D
    vld1.32     {d0}, [r0]
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d23}, [r2]!
    vld1.32     {d24}, [r2]

    vshr.s32    d1, d0, #23  // Exp (Integer) := Val.I shr 23;
    vcvt.f32.s32 d1, d1      // Exp (Float)
    vcgt.f32    d2, d0, #0   // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     d3, d2, d21  // (A > 0)? Yes: -89.93423858, No: 0
    vbic.32     d4, d22, d2  // (A > 0)? Yes: 0, No: NegInfinity
    vorr.32     d4, d4, d3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    vand.32     d0, d0, d23
    vorr.32     d0, d0, d24  // Val.I := (Val.I and $007FFFFF) or $3F800000;
    vmul.f32    d2, d0, d0   // X := Val.I, X2 := X * X

    vmla.f32    d19, d18, d0 // F4+F3*X
    vsub.f32    d3, d0, d17  // X-F2
    vmla.f32    d3, d2, d19  // (X-F2)+X2*(F4+F3*X)
    vmla.f32    d4, d0, d16  // F1*X+AddCst
    vmla.f32    d4, d2, d3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    vmla.f32    d4, d20, d1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    vst1.32     {d4}, [r1]
    bx          lr

_fast_ln_vector3: // (const A: TVector3; out Result: TVector3);
    vpush       {q4-q5}
    adr         r2, LN_FACTORS_Q
    fldmias     r0, {s0-s2}
    vld1.32     {q8, q9}, [r2]!
    vld1.32     {q10, q11}, [r2]!
    vld1.32     {q12, q13}, [r2]!
    vld1.32     {q14, q15}, [r2]!
    vld1.32     {q5}, [r2]

    vshr.s32    q1, q0, #23  // Exp (Integer) := Val.I shr 23;
    vcvt.f32.s32 q1, q1      // Exp (Float)
    vcgt.f32    q2, q0, #0   // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     q3, q2, q13  // (A > 0)? Yes: -89.93423858, No: 0
    vbic.32     q4, q14, q2  // (A > 0)? Yes: 0, No: NegInfinity
    vorr.32     q4, q4, q3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    vand.32     q0, q0, q15
    vorr.32     q0, q0, q5   // Val.I := (Val.I and $007FFFFF) or $3F800000;
    vmul.f32    q2, q0, q0   // X := Val.I, X2 := X * X

    vmla.f32    q11, q10, q0 // F4+F3*X
    vsub.f32    q3, q0, q9   // X-F2
    vmla.f32    q3, q2, q11  // (X-F2)+X2*(F4+F3*X)
    vmla.f32    q4, q0, q8   // F1*X+AddCst
    vmla.f32    q4, q2, q3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    vmla.f32    q4, q12, q1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    fstmias     r1, {s16-s18}
    vpop        {q4-q5}
    bx          lr

_fast_ln_vector4: // (const A: TVector4; out Result: TVector4);
    vpush       {q4-q5}
    adr         r2, LN_FACTORS_Q
    vld1.32     {q0}, [r0]
    vld1.32     {q8, q9}, [r2]!
    vld1.32     {q10, q11}, [r2]!
    vld1.32     {q12, q13}, [r2]!
    vld1.32     {q14, q15}, [r2]!
    vld1.32     {q5}, [r2]

    vshr.s32    q1, q0, #23  // Exp (Integer) := Val.I shr 23;
    vcvt.f32.s32 q1, q1      // Exp (Float)
    vcgt.f32    q2, q0, #0   // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     q3, q2, q13  // (A > 0)? Yes: -89.93423858, No: 0
    vbic.32     q4, q14, q2  // (A > 0)? Yes: 0, No: NegInfinity
    vorr.32     q4, q4, q3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    vand.32     q0, q0, q15
    vorr.32     q0, q0, q5   // Val.I := (Val.I and $007FFFFF) or $3F800000;
    vmul.f32    q2, q0, q0   // X := Val.I, X2 := X * X

    vmla.f32    q11, q10, q0 // F4+F3*X
    vsub.f32    q3, q0, q9   // X-F2
    vmla.f32    q3, q2, q11  // (X-F2)+X2*(F4+F3*X)
    vmla.f32    q4, q0, q8   // F1*X+AddCst
    vmla.f32    q4, q2, q3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    vmla.f32    q4, q12, q1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    vst1.32     {q4}, [r1]
    vpop        {q4-q5}
    bx          lr

LN_FACTORS_D:
    .float 3.3977745, 3.3977745                // d16 / F1
    .float 2.2744832, 2.2744832                // d17 / F2
    .float 0.024982445, 0.024982445            // d18 / F3
    .float -0.24371102, -0.24371102            // d19 / F4
    .float 0.69314718055995, 0.69314718055995  // d20 / F5
    .float -89.93423858, -89.93423858          // d21
    .int 0xFF800000, 0xFF800000 // NegInfinity    d22
    .int 0x007FFFFF, 0x007FFFFF                // d23
    .int 0x3F800000, 0x3F800000                // d24

LN_FACTORS_Q:
    .float 3.3977745, 3.3977745, 3.3977745, 3.3977745
    .float 2.2744832, 2.2744832, 2.2744832, 2.2744832
    .float 0.024982445, 0.024982445, 0.024982445, 0.024982445
    .float -0.24371102, -0.24371102, -0.24371102, -0.24371102
    .float 0.69314718055995, 0.69314718055995, 0.69314718055995, 0.69314718055995
    .float -89.93423858, -89.93423858, -89.93423858, -89.93423858
    .int 0xFF800000, 0xFF800000, 0xFF800000, 0xFF800000
    .int 0x007FFFFF, 0x007FFFFF, 0x007FFFFF, 0x007FFFFF
    .int 0x3F800000, 0x3F800000, 0x3F800000, 0x3F800000

_fast_log2_scalar: // (const A: Single): Single;
    adr         r2, LOG2_FACTORS_D
    vmov.f32    s0, r0
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d22}, [r2]

    vand.32     d1, d0, d21
    vorr.32     d1, d1, d22    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    vcvt.f32.s32 d0, d0        // VX.I as Float
    vmla.f32    d16, d0, d20   // F1+(VX.I*F5)
    vmls.f32    d16, d17, d1   // F1+(VX.I*F5)-(F2*MX.S)

    vadd.f32    d2, d19, d1    // F4+MX.S
    RECIPD_LOW  d3, d2         // 1/(F4+MX.S)
    vmls.f32    d16, d18, d3   // F1+(VX.I*F5)-(F2*MX.S)-(F3/(F4+MX.S))
    vmov        d0, d16
    vmov.f32    r0, s0
    bx          lr

_fast_log2_vector2: // (const A: TVector2; out Result: TVector2);
    adr         r2, LOG2_FACTORS_D
    vld1.32     {d0}, [r0]
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d22}, [r2]

    vand.32     d1, d0, d21
    vorr.32     d1, d1, d22    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    vcvt.f32.s32 d0, d0        // VX.I as Float
    vmla.f32    d16, d0, d20   // F1+(VX.I*F5)
    vmls.f32    d16, d17, d1   // F1+(VX.I*F5)-(F2*MX.S)

    vadd.f32    d2, d19, d1    // F4+MX.S
    RECIPD_LOW  d3, d2         // 1/(F4+MX.S)
    vmls.f32    d16, d18, d3   // F1+(VX.I*F5)-(F2*MX.S)-(F3/(F4+MX.S))
    vst1.32     {d16}, [r1]
    bx          lr

_fast_log2_vector3: // (const A: TVector3; out Result: TVector3);
    adr         r2, LOG2_FACTORS_Q
    fldmias     r0, {s0-s2}
    vld1.32     {q8-q9}, [r2]!
    vld1.32     {q10-q11}, [r2]!
    vld1.32     {q12-q13}, [r2]!
    vld1.32     {q14}, [r2]

    vand.32     q1, q0, q13
    vorr.32     q1, q1, q14    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    vcvt.f32.s32 q0, q0        // VX.I as Float
    vmla.f32    q8, q0, q12    // F1+(VX.I*F5)
    vmls.f32    q8, q9, q1     // F1+(VX.I*F5)-(F2*MX.S)

    vadd.f32    q2, q11, q1    // F4+MX.S
    RECIPQ_LOW  q3, q2         // 1/(F4+MX.S)
    vmls.f32    q8, q10, q3    // F1+(VX.I*F5)-(F2*MX.S)-(F3/(F4+MX.S))
    vmov        q0, q8
    fstmias     r1, {s0-s2}
    bx          lr

_fast_log2_vector4: // (const A: TVector4; out Result: TVector4);
    adr         r2, LOG2_FACTORS_Q
    vld1.32     {q0}, [r0]
    vld1.32     {q8-q9}, [r2]!
    vld1.32     {q10-q11}, [r2]!
    vld1.32     {q12-q13}, [r2]!
    vld1.32     {q14}, [r2]

    vand.32     q1, q0, q13
    vorr.32     q1, q1, q14    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    vcvt.f32.s32 q0, q0        // VX.I as Float
    vmla.f32    q8, q0, q12    // F1+(VX.I*F5)
    vmls.f32    q8, q9, q1     // F1+(VX.I*F5)-(F2*MX.S)

    vadd.f32    q2, q11, q1    // F4+MX.S
    RECIPQ_LOW  q3, q2         // 1/(F4+MX.S)
    vmls.f32    q8, q10, q3    // F1+(VX.I*F5)-(F2*MX.S)-(F3/(F4+MX.S))
    vst1.32     {q8}, [r1]
    bx          lr

LOG2_FACTORS_D:
    .float -124.22551499, -124.22551499                 // d16 / F1
    .float 1.498030302, 1.498030302                     // d17 / F2
    .float 1.72587999, 1.72587999                       // d18 / F3
    .float 0.3520887068, 0.3520887068                   // d19 / F4
    .float 1.1920928955078125e-7, 1.1920928955078125e-7 // d20 / F5
    .int 0x007FFFFF, 0x007FFFFF                         // d21
    .int 0x3F000000, 0x3F000000                         // d22

LOG2_FACTORS_Q:
    .float -124.22551499, -124.22551499, -124.22551499, -124.22551499
    .float 1.498030302, 1.498030302, 1.498030302, 1.498030302
    .float 1.72587999, 1.72587999, 1.72587999, 1.72587999
    .float 0.3520887068, 0.3520887068, 0.3520887068, 0.3520887068
    .float 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7
    .int 0x007FFFFF, 0x007FFFFF, 0x007FFFFF, 0x007FFFFF
    .int 0x3F000000, 0x3F000000, 0x3F000000, 0x3F000000
    
_fast_exp2_scalar: // (const A: Single): Single;
    adr         r2, EXP2_FACTORS_D
    vmov.f32    s0, r0
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d21}, [r2]

    vclt.f32    d1, d0, #0     // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     d1, d1, d20    // if (A < 0) then Offset := 1 else Offset := 0

    vcvt.s32.f32 d2, d0        // Trunc(A) (as int)
    vcvt.f32.s32 d2, d2        // Trunc(A) (as float)
    vsub.f32    d2, d0, d2     // A - Trunc(A)
    vadd.f32    d1, d1, d2     // Z := A - Trunc(A) + Offset;

    vadd.f32    d0, d0, d16    // A+F1
    vsub.f32    d3, d18, d1    // F3-Z
    RECIPD_LOW  d2, d3         // 1/(F3-Z)
    vmla.f32    d0, d17, d2    // A+F1+F2/(F3-Z)
    vmls.f32    d0, d19, d1    // A+F1+F2/(F3-Z)-F4*Z
    vmul.f32    d0, d0, d21    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    vcvt.s32.f32 d0, d0        // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    vmov.f32    r0, s0
    bx          lr

_fast_exp2_vector2: // (const A: TVector2; out Result: TVector2);
    adr         r2, EXP2_FACTORS_D
    vld1.32     {d0}, [r0]
    vld1.32     {d16-d19}, [r2]!
    vld1.32     {d20-d21}, [r2]

    vclt.f32    d1, d0, #0     // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     d1, d1, d20    // if (A < 0) then Offset := 1 else Offset := 0

    vcvt.s32.f32 d2, d0        // Trunc(A) (as int)
    vcvt.f32.s32 d2, d2        // Trunc(A) (as float)
    vsub.f32    d2, d0, d2     // A - Trunc(A)
    vadd.f32    d1, d1, d2     // Z := A - Trunc(A) + Offset;

    vadd.f32    d0, d0, d16    // A+F1
    vsub.f32    d3, d18, d1    // F3-Z
    RECIPD_LOW  d2, d3         // 1/(F3-Z)
    vmla.f32    d0, d17, d2    // A+F1+F2/(F3-Z)
    vmls.f32    d0, d19, d1    // A+F1+F2/(F3-Z)-F4*Z
    vmul.f32    d0, d0, d21    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    vcvt.s32.f32 d0, d0        // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    vst1.32     {d0}, [r1]
    bx          lr

_fast_exp2_vector3: // (const A: TVector3; out Result: TVector3);
    adr         r2, EXP2_FACTORS_Q
    fldmias     r0, {s0-s2}
    vld1.32     {q8-q9}, [r2]!
    vld1.32     {q10-q11}, [r2]!
    vld1.32     {q12-q13}, [r2]

    vclt.f32    q1, q0, #0     // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     q1, q1, q12    // if (A < 0) then Offset := 1 else Offset := 0

    vcvt.s32.f32 q2, q0        // Trunc(A) (as int)
    vcvt.f32.s32 q2, q2        // Trunc(A) (as float)
    vsub.f32    q2, q0, q2     // A - Trunc(A)
    vadd.f32    q1, q1, q2     // Z := A - Trunc(A) + Offset;

    vadd.f32    q0, q0, q8     // A+F1
    vsub.f32    q3, q10, q1    // F3-Z
    RECIPQ_LOW  q2, q3         // 1/(F3-Z)
    vmla.f32    q0, q9, q2     // A+F1+F2/(F3-Z)
    vmls.f32    q0, q11, q1    // A+F1+F2/(F3-Z)-F4*Z
    vmul.f32    q0, q0, q13    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    vcvt.s32.f32 q0, q0        // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    fstmias     r1, {s0-s2}
    bx          lr

_fast_exp2_vector4: // (const A: TVector4; out Result: TVector4);
    adr         r2, EXP2_FACTORS_Q
    vld1.32     {q0}, [r0]
    vld1.32     {q8-q9}, [r2]!
    vld1.32     {q10-q11}, [r2]!
    vld1.32     {q12-q13}, [r2]

    vclt.f32    q1, q0, #0     // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32     q1, q1, q12    // if (A < 0) then Offset := 1 else Offset := 0

    vcvt.s32.f32 q2, q0        // Trunc(A) (as int)
    vcvt.f32.s32 q2, q2        // Trunc(A) (as float)
    vsub.f32    q2, q0, q2     // A - Trunc(A)
    vadd.f32    q1, q1, q2     // Z := A - Trunc(A) + Offset;

    vadd.f32    q0, q0, q8     // A+F1
    vsub.f32    q3, q10, q1    // F3-Z
    RECIPQ_LOW  q2, q3         // 1/(F3-Z)
    vmla.f32    q0, q9, q2     // A+F1+F2/(F3-Z)
    vmls.f32    q0, q11, q1    // A+F1+F2/(F3-Z)-F4*Z
    vmul.f32    q0, q0, q13    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    vcvt.s32.f32 q0, q0        // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    vst1.32     {q0}, [r1]
    bx          lr

EXP2_FACTORS_D:
    .float 121.2740575, 121.2740575 // d16 / F1
    .float 27.7280233, 27.7280233   // d17 / F2
    .float 4.84252568, 4.84252568   // d18 / F3
    .float 1.49012907, 1.49012907   // d19 / F4
    .float 1.0, 1.0                 // d20
    .float 8388608.0, 8388608.0     // d21 (1 shl 23)

EXP2_FACTORS_Q:
    .float 121.2740575, 121.2740575, 121.2740575, 121.2740575
    .float 27.7280233, 27.7280233, 27.7280233, 27.7280233
    .float 4.84252568, 4.84252568, 4.84252568, 4.84252568
    .float 1.49012907, 1.49012907, 1.49012907, 1.49012907
    .float 1.0, 1.0, 1.0, 1.0
    .float 8388608.0, 8388608.0, 8388608.0, 8388608.0

#endif // __LP64__
