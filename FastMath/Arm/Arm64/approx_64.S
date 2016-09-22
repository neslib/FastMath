#if __LP64__
    .text
    .align 4
    .include "../Arm64/macros_64.S"
    .globl _fast_sincos_scalar, _fast_sincos_vector2, _fast_sincos_vector3, _fast_sincos_vector4
    .globl _fast_exp_scalar, _fast_exp_vector2, _fast_exp_vector3, _fast_exp_vector4
    .globl _fast_ln_scalar, _fast_ln_vector2, _fast_ln_vector3, _fast_ln_vector4
    .globl _fast_log2_scalar, _fast_log2_vector2, _fast_log2_vector3, _fast_log2_vector4
    .globl _fast_exp2_scalar, _fast_exp2_vector2, _fast_exp2_vector3, _fast_exp2_vector4

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

_fast_sincos_scalar: // (const A: Single; out Sin, Cos: Single);
    adr          x3, SINCOS_FACTORS_D
    ld1.2s       {v16-v19}, [x3], #32 // (v16) FOPI
                                      // (v17) 1 (int)
                                      // (v18) not 1 (int)
                                      // (v19) 2 (int)
    ld1.2s       {v20-v23}, [x3], #32 // (v20) Pi / 4
                                      // (v21) 4 (int)
                                      // (v22) COSCOF_P0
                                      // (v23) SINCOF_P0
    ld1.2s       {v24-v27}, [x3], #32 // (v24) COSCOF_P1
                                      // (v25) SINCOF_P1
                                      // (v26) COSCOF_P2
                                      // (v27) SINCOF_P2
    ld1.2s       {v28-v29}, [x3]      // (v28) 0.5
                                      // (v29) 1.0

    fcmlt.2s     v1, v0, #0.0         // (v1) SignMaskSin = Sign(A)
    fabs.2s      v0, v0               // (v0) X := Abs(A)
    fmul.2s      v2, v0, v16          //
    fcvtzs.2s    v2, v2               // J := Trunc(X * FOPI)
    add.2s       v2, v2, v17
    and.8b       v2, v2, v18          // (v2) J := (J + 1) and (not 1)
    scvtf.2s     v3, v2               // (v3) Y := J
    cmtst.2s     v31, v2, v19         // (v31) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmls.2s      v0, v3, v20          // (v0) X := X - Y * Pi / 4
    cmtst.2s     v30, v2, v21         // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    eor.8b       v1, v1, v30          // (v1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    sub.2s       v2, v2, v19          // J - 2
    cmtst.2s     v30, v2, v21         // (v30) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmul.2s      v2, v0, v0           // (v2) Z := X * X
    fmla.2s      v24, v2, v22         // Y1 := Z * COSCOF_P0 + COSCOF_P1
    fmla.2s      v25, v2, v23         // Y2 := Z * SINCOF_P0 + SINCOF_P1
    fmla.2s      v26, v24, v2         // Y1 := (Y1 * Z) + COSCOF_P2
    fmla.2s      v27, v25, v2         // Y2 := (Y2 * Z) + SINCOF_P2
    fmul.2s      v26, v26, v2         // Y1 * Z
    fmul.2s      v27, v27, v2         // Y2 * Z
    fmul.2s      v26, v26, v2         // Y1 := Y1 * (Z * Z)
    fmul.2s      v27, v27, v0         // Y2 * (Z * X)
    fmls.2s      v26, v2, v28         // Y1 := Y1 - 0.5 * Z
    fadd.2s      v27, v27, v0         // (v27) Y2 := Y2 * (Z * X) + X
    fadd.2s      v26, v26, v29        // (v26) Y1 := Y1 - 0.5 * Z + 1
    mov.2s       v7, v31
    bsl.8b       v31, v26, v27        // (v31) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    bsl.8b       v7, v27, v26         // (v7)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    fneg.2s      v0, v31              // (v0) -YS
    fneg.2s      v2, v7               // (v2) -YC
    bsl.8b       v1, v0, v31          // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    bsl.8b       v30, v7, v2          // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    str          s1, [x0]
    str          s30, [x1]
    ret

_fast_sincos_vector2: // (const A: TVector2; out Sin, Cos: TVector2);
    adr          x3, SINCOS_FACTORS_D
    ld1.2s       {v0}, [x0]
    ld1.2s       {v16-v19}, [x3], #32 // (v16) FOPI
                                      // (v17) 1 (int)
                                      // (v18) not 1 (int)
                                      // (v19) 2 (int)
    ld1.2s       {v20-v23}, [x3], #32 // (v20) Pi / 4
                                      // (v21) 4 (int)
                                      // (v22) COSCOF_P0
                                      // (v23) SINCOF_P0
    ld1.2s       {v24-v27}, [x3], #32 // (v24) COSCOF_P1
                                      // (v25) SINCOF_P1
                                      // (v26) COSCOF_P2
                                      // (v27) SINCOF_P2
    ld1.2s       {v28-v29}, [x3]      // (v28) 0.5
                                      // (v29) 1.0

    fcmlt.2s     v1, v0, #0.0         // (v1) SignMaskSin = Sign(A)
    fabs.2s      v0, v0               // (v0) X := Abs(A)
    fmul.2s      v2, v0, v16          //
    fcvtzs.2s    v2, v2               // J := Trunc(X * FOPI)
    add.2s       v2, v2, v17
    and.8b       v2, v2, v18          // (v2) J := (J + 1) and (not 1)
    scvtf.2s     v3, v2               // (v3) Y := J
    cmtst.2s     v31, v2, v19         // (v31) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmls.2s      v0, v3, v20          // (v0) X := X - Y * Pi / 4
    cmtst.2s     v30, v2, v21         // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    eor.8b       v1, v1, v30          // (v1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    sub.2s       v2, v2, v19          // J - 2
    cmtst.2s     v30, v2, v21         // (v30) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmul.2s      v2, v0, v0           // (v2) Z := X * X
    fmla.2s      v24, v2, v22         // Y1 := Z * COSCOF_P0 + COSCOF_P1
    fmla.2s      v25, v2, v23         // Y2 := Z * SINCOF_P0 + SINCOF_P1
    fmla.2s      v26, v24, v2         // Y1 := (Y1 * Z) + COSCOF_P2
    fmla.2s      v27, v25, v2         // Y2 := (Y2 * Z) + SINCOF_P2
    fmul.2s      v26, v26, v2         // Y1 * Z
    fmul.2s      v27, v27, v2         // Y2 * Z
    fmul.2s      v26, v26, v2         // Y1 := Y1 * (Z * Z)
    fmul.2s      v27, v27, v0         // Y2 * (Z * X)
    fmls.2s      v26, v2, v28         // Y1 := Y1 - 0.5 * Z
    fadd.2s      v27, v27, v0         // (v27) Y2 := Y2 * (Z * X) + X
    fadd.2s      v26, v26, v29        // (v26) Y1 := Y1 - 0.5 * Z + 1
    mov.2s       v7, v31
    bsl.8b       v31, v26, v27        // (v31) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    bsl.8b       v7, v27, v26         // (v7)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    fneg.2s      v0, v31              // (v0) -YS
    fneg.2s      v2, v7               // (v2) -YC
    bsl.8b       v1, v0, v31          // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    bsl.8b       v30, v7, v2          // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    st1.2s       {v1}, [x1]
    st1.2s       {v30}, [x2]
    ret

_fast_sincos_vector3: // (const A: TVector3; out Sin, Cos: TVector3);
    adr          x3, SINCOS_FACTORS_Q
    LOAD3        v0, x0
    ld1.4s       {v16-v19}, [x3], #64 // (v16) FOPI
                                      // (v17) 1 (int)
                                      // (v18) not 1 (int)
                                      // (v19) 2 (int)
    ld1.4s       {v20-v23}, [x3], #64 // (v20) Pi / 4
                                      // (v21) 4 (int)
                                      // (v22) COSCOF_P0
                                      // (v23) SINCOF_P0
    ld1.4s       {v24-v27}, [x3], #64 // (v24) COSCOF_P1
                                      // (v25) SINCOF_P1
                                      // (v26) COSCOF_P2
                                      // (v27) SINCOF_P2
    ld1.4s       {v28-v29}, [x3]      // (v28) 0.5
                                      // (v29) 1.0

    fcmlt.4s     v1, v0, #0.0         // (v1) SignMaskSin = Sign(A)
    fabs.4s      v0, v0               // (v0) X := Abs(A)
    fmul.4s      v2, v0, v16          //
    fcvtzs.4s    v2, v2               // J := Trunc(X * FOPI)
    add.4s       v2, v2, v17
    and.16b      v2, v2, v18          // (v2) J := (J + 1) and (not 1)
    scvtf.4s     v3, v2               // (v3) Y := J
    cmtst.4s     v31, v2, v19         // (v31) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmls.4s      v0, v3, v20          // (v0) X := X - Y * Pi / 4
    cmtst.4s     v30, v2, v21         // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    eor.16b      v1, v1, v30          // (v1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    sub.4s       v2, v2, v19          // J - 2
    cmtst.4s     v30, v2, v21         // (v30) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmul.4s      v2, v0, v0           // (v2) Z := X * X
    fmla.4s      v24, v2, v22         // Y1 := Z * COSCOF_P0 + COSCOF_P1
    fmla.4s      v25, v2, v23         // Y2 := Z * SINCOF_P0 + SINCOF_P1
    fmla.4s      v26, v24, v2         // Y1 := (Y1 * Z) + COSCOF_P2
    fmla.4s      v27, v25, v2         // Y2 := (Y2 * Z) + SINCOF_P2
    fmul.4s      v26, v26, v2         // Y1 * Z
    fmul.4s      v27, v27, v2         // Y2 * Z
    fmul.4s      v26, v26, v2         // Y1 := Y1 * (Z * Z)
    fmul.4s      v27, v27, v0         // Y2 * (Z * X)
    fmls.4s      v26, v2, v28         // Y1 := Y1 - 0.5 * Z
    fadd.4s      v27, v27, v0         // (v27) Y2 := Y2 * (Z * X) + X
    fadd.4s      v26, v26, v29        // (v26) Y1 := Y1 - 0.5 * Z + 1
    mov.4s       v7, v31
    bsl.16b      v31, v26, v27        // (v31) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    bsl.16b      v7, v27, v26         // (v7)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    fneg.4s      v0, v31              // (v0) -YS
    fneg.4s      v2, v7               // (v2) -YC
    bsl.16b      v1, v0, v31          // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    bsl.16b      v30, v7, v2          // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    STORE3       v1, x1
    STORE3       v30, x2
    ret

_fast_sincos_vector4: // (const A: TVector4; out Sin, Cos: TVector4);
    adr          x3, SINCOS_FACTORS_Q
    ld1.4s       {v0}, [x0]
    ld1.4s       {v16-v19}, [x3], #64 // (v16) FOPI
                                      // (v17) 1 (int)
                                      // (v18) not 1 (int)
                                      // (v19) 2 (int)
    ld1.4s       {v20-v23}, [x3], #64 // (v20) Pi / 4
                                      // (v21) 4 (int)
                                      // (v22) COSCOF_P0
                                      // (v23) SINCOF_P0
    ld1.4s       {v24-v27}, [x3], #64 // (v24) COSCOF_P1
                                      // (v25) SINCOF_P1
                                      // (v26) COSCOF_P2
                                      // (v27) SINCOF_P2
    ld1.4s       {v28-v29}, [x3]      // (v28) 0.5
                                      // (v29) 1.0

    fcmlt.4s     v1, v0, #0.0         // (v1) SignMaskSin = Sign(A)
    fabs.4s      v0, v0               // (v0) X := Abs(A)
    fmul.4s      v2, v0, v16          //
    fcvtzs.4s    v2, v2               // J := Trunc(X * FOPI)
    add.4s       v2, v2, v17
    and.16b      v2, v2, v18          // (v2) J := (J + 1) and (not 1)
    scvtf.4s     v3, v2               // (v3) Y := J
    cmtst.4s     v31, v2, v19         // (v31) PolyMask := ((J and 2) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmls.4s      v0, v3, v20          // (v0) X := X - Y * Pi / 4
    cmtst.4s     v30, v2, v21         // ((J and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    eor.16b      v1, v1, v30          // (v1) if ((J and 4) <> 0) then SignMaskSin := -SignMaskSin
    sub.4s       v2, v2, v19          // J - 2
    cmtst.4s     v30, v2, v21         // (v30) SignMaskCos := (((J - 2) and 4) <> 0)? Yes: $FFFFFFFF, No: $00000000
    fmul.4s      v2, v0, v0           // (v2) Z := X * X
    fmla.4s      v24, v2, v22         // Y1 := Z * COSCOF_P0 + COSCOF_P1
    fmla.4s      v25, v2, v23         // Y2 := Z * SINCOF_P0 + SINCOF_P1
    fmla.4s      v26, v24, v2         // Y1 := (Y1 * Z) + COSCOF_P2
    fmla.4s      v27, v25, v2         // Y2 := (Y2 * Z) + SINCOF_P2
    fmul.4s      v26, v26, v2         // Y1 * Z
    fmul.4s      v27, v27, v2         // Y2 * Z
    fmul.4s      v26, v26, v2         // Y1 := Y1 * (Z * Z)
    fmul.4s      v27, v27, v0         // Y2 * (Z * X)
    fmls.4s      v26, v2, v28         // Y1 := Y1 - 0.5 * Z
    fadd.4s      v27, v27, v0         // (v27) Y2 := Y2 * (Z * X) + X
    fadd.4s      v26, v26, v29        // (v26) Y1 := Y1 - 0.5 * Z + 1
    mov.4s       v7, v31
    bsl.16b      v31, v26, v27        // (v31) YS := ((J and 2) <> 0)? Yes: Y1, No: Y2
    bsl.16b      v7, v27, v26         // (v7)  YC := ((J and 2) <> 0)? Yes: Y2, No: Y1
    fneg.4s      v0, v31              // (v0) -YS
    fneg.4s      v2, v7               // (v2) -YC
    bsl.16b      v1, v0, v31          // if (SignMaskSin < 0) then Sin := -YS else Sin := YS
    bsl.16b      v30, v7, v2          // if (SignMaskCos < 0) then Cos := -YC else Cos := YC
    st1.4s       {v1}, [x1]
    st1.4s       {v30}, [x2]
    ret

EXP_FACTORS_D:
    .float 0.509964287281036376953125, 0.509964287281036376953125               // v16 / F1
    .float 0.3120158612728118896484375, 0.3120158612728118896484375             // v17 / F2
    .float 0.1666135489940643310546875, 0.1666135489940643310546875             // v18 / F3
    .float -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3   // v19 / F4
    .float 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2 // v20 / F5
    .float 2139095040.0, 2139095040.0                                           // v21
    .float 12102203.1615614, 12102203.1615614                                   // v22
    .float 1065353216.0, 1065353216.0                                           // v23
    .int 0x7F800000, 0x7F800000                                                 // v24
    .int 0x007FFFFF, 0x007FFFFF                                                 // v25
    .int 0x3F800000, 0x3F800000                                                 // v26

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

_fast_exp_scalar: // (const A: Single): Single;
    adr         x2, EXP_FACTORS_D
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v23}, [x2], #32
    ld1.2s      {v24-v26}, [x2]

    fmla.2s     v23, v0, v22 // Val := 12102203.1615614 * A + 1065353216.0;
    fmin.2s     v0, v23, v21 // if (Val >= EXP_CST) then Val := EXP_CST;
    fcmgt.2s    v1, v0, #0.0 // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    fcvtzs.2s   v0, v0       // IVal := Trunc(Val)
    and.8b      v0, v0, v1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    and.8b      v1, v0, v24  // XU.I := IVal and $7F800000;
    and.8b      v2, v0, v25
    orr.8b      v2, v2, v26  // XU2.I := (IVal and $007FFFFF) or $3F800000;

    fmla.2s     v19, v2, v20 // F4+B*F5
    fmla.2s     v18, v2, v19 // F3+B*(F4+B*F5)
    fmla.2s     v17, v2, v18 // F2+B*(F3+B*(F4+B*F5))
    fmla.2s     v16, v2, v17 // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    fmul.2s     v0, v1, v16  // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    ret

_fast_exp_vector2: // (const A: TVector2; out Result: TVector2);
    adr         x2, EXP_FACTORS_D
    ld1.2s      {v0}, [x0]
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v23}, [x2], #32
    ld1.2s      {v24-v26}, [x2]

    fmla.2s     v23, v0, v22 // Val := 12102203.1615614 * A + 1065353216.0;
    fmin.2s     v0, v23, v21 // if (Val >= EXP_CST) then Val := EXP_CST;
    fcmgt.2s    v1, v0, #0.0 // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    fcvtzs.2s   v0, v0       // IVal := Trunc(Val)
    and.8b      v0, v0, v1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    and.8b      v1, v0, v24  // XU.I := IVal and $7F800000;
    and.8b      v2, v0, v25
    orr.8b      v2, v2, v26  // XU2.I := (IVal and $007FFFFF) or $3F800000;

    fmla.2s     v19, v2, v20 // F4+B*F5
    fmla.2s     v18, v2, v19 // F3+B*(F4+B*F5)
    fmla.2s     v17, v2, v18 // F2+B*(F3+B*(F4+B*F5))
    fmla.2s     v16, v2, v17 // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    fmul.2s     v0, v1, v16  // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    st1.2s      {v0}, [x1]
    ret

_fast_exp_vector3: // (const A: TVector3; out Result: TVector3);
    adr         x2, EXP_FACTORS_Q
    LOAD3       v0, x0
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v23}, [x2], #64
    ld1.4s      {v24-v26}, [x2]

    fmla.4s     v23, v0, v22 // Val := 12102203.1615614 * A + 1065353216.0;
    fmin.4s     v0, v23, v21 // if (Val >= EXP_CST) then Val := EXP_CST;
    fcmgt.4s    v1, v0, #0.0 // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    fcvtzs.4s   v0, v0       // IVal := Trunc(Val)
    and.16b     v0, v0, v1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    and.16b     v1, v0, v24  // XU.I := IVal and $7F800000;
    and.16b     v2, v0, v25
    orr.16b     v2, v2, v26  // XU2.I := (IVal and $007FFFFF) or $3F800000;

    fmla.4s     v19, v2, v20 // F4+B*F5
    fmla.4s     v18, v2, v19 // F3+B*(F4+B*F5)
    fmla.4s     v17, v2, v18 // F2+B*(F3+B*(F4+B*F5))
    fmla.4s     v16, v2, v17 // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    fmul.4s     v0, v1, v16  // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    STORE3      v0, x1
    ret

_fast_exp_vector4: // (const A: TVector4; out Result: TVector4);
    adr         x2, EXP_FACTORS_Q
    ld1.4s      {v0}, [x0]
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v23}, [x2], #64
    ld1.4s      {v24-v26}, [x2]

    fmla.4s     v23, v0, v22 // Val := 12102203.1615614 * A + 1065353216.0;
    fmin.4s     v0, v23, v21 // if (Val >= EXP_CST) then Val := EXP_CST;
    fcmgt.4s    v1, v0, #0.0 // (Val > 0)? Yes: $FFFFFFFF, No: $00000000
    fcvtzs.4s   v0, v0       // IVal := Trunc(Val)
    and.16b     v0, v0, v1   // (Val > 0)? Yes: IVal := Trunc(Val), No: IVal := 0
    and.16b     v1, v0, v24  // XU.I := IVal and $7F800000;
    and.16b     v2, v0, v25
    orr.16b     v2, v2, v26  // XU2.I := (IVal and $007FFFFF) or $3F800000;

    fmla.4s     v19, v2, v20 // F4+B*F5
    fmla.4s     v18, v2, v19 // F3+B*(F4+B*F5)
    fmla.4s     v17, v2, v18 // F2+B*(F3+B*(F4+B*F5))
    fmla.4s     v16, v2, v17 // F1+B*(F2+B*(F3+B*(F4+B*F5)))
    fmul.4s     v0, v1, v16  // XU.S*(F1+B*(F2+B*(F3+B*(F4+B*F5))))
    st1.4s      {v0}, [x1]
    ret

LN_FACTORS_D:
    .float 3.3977745, 3.3977745                // v16 / F1
    .float 2.2744832, 2.2744832                // v17 / F2
    .float 0.024982445, 0.024982445            // v18 / F3
    .float -0.24371102, -0.24371102            // v19 / F4
    .float 0.69314718055995, 0.69314718055995  // v20 / F5
    .float -89.93423858, -89.93423858          // v21
    .int 0xFF800000, 0xFF800000 // NegInfinity    v22
    .int 0x007FFFFF, 0x007FFFFF                // v23
    .int 0x3F800000, 0x3F800000                // v24

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

_fast_ln_scalar: // (const A: Single): Single;
    adr         x2, LN_FACTORS_D
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v23}, [x2], #32
    ld1.2s      {v24}, [x2]

    sshr.2s     v1, v0, #23  // Exp (Integer) := Val.I shr 23;
    scvtf.2s    v1, v1       // Exp (Float)
    fcmgt.2s    v2, v0, #0.0 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    and.8b      v3, v2, v21  // (A > 0)? Yes: -89.93423858, No: 0
    bic.8b      v4, v22, v2  // (A > 0)? Yes: 0, No: NegInfinity
    orr.8b      v4, v4, v3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    and.8b      v0, v0, v23
    orr.8b      v0, v0, v24  // Val.I := (Val.I and $007FFFFF) or $3F800000;
    fmul.2s     v2, v0, v0   // X := Val.I, X2 := X * X

    fmla.2s     v19, v18, v0 // F4+F3*X
    fsub.2s     v3, v0, v17  // X-F2
    fmla.2s     v3, v2, v19  // (X-F2)+X2*(F4+F3*X)
    fmla.2s     v4, v0, v16  // F1*X+AddCst
    fmla.2s     v4, v2, v3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    fmla.2s     v4, v20, v1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    fmov        s0, s4
    ret

_fast_ln_vector2: // (const A: TVector2; out Result: TVector2);
    adr         x2, LN_FACTORS_D
    ld1.2s      {v0}, [x0]
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v23}, [x2], #32
    ld1.2s      {v24}, [x2]

    sshr.2s     v1, v0, #23  // Exp (Integer) := Val.I shr 23;
    scvtf.2s    v1, v1       // Exp (Float)
    fcmgt.2s    v2, v0, #0.0 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    and.8b      v3, v2, v21  // (A > 0)? Yes: -89.93423858, No: 0
    bic.8b      v4, v22, v2  // (A > 0)? Yes: 0, No: NegInfinity
    orr.8b      v4, v4, v3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    and.8b      v0, v0, v23
    orr.8b      v0, v0, v24  // Val.I := (Val.I and $007FFFFF) or $3F800000;
    fmul.2s     v2, v0, v0   // X := Val.I, X2 := X * X

    fmla.2s     v19, v18, v0 // F4+F3*X
    fsub.2s     v3, v0, v17  // X-F2
    fmla.2s     v3, v2, v19  // (X-F2)+X2*(F4+F3*X)
    fmla.2s     v4, v0, v16  // F1*X+AddCst
    fmla.2s     v4, v2, v3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    fmla.2s     v4, v20, v1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    st1.2s      {v4}, [x1]
    ret

_fast_ln_vector3: // (const A: TVector3; out Result: TVector3);
    adr         x2, LN_FACTORS_Q
    LOAD3       v0, x0
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v23}, [x2], #64
    ld1.4s      {v24}, [x2]

    sshr.4s     v1, v0, #23  // Exp (Integer) := Val.I shr 23;
    scvtf.4s    v1, v1       // Exp (Float)
    fcmgt.4s    v2, v0, #0.0 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    and.16b     v3, v2, v21  // (A > 0)? Yes: -89.93423858, No: 0
    bic.16b     v4, v22, v2  // (A > 0)? Yes: 0, No: NegInfinity
    orr.16b     v4, v4, v3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    and.16b     v0, v0, v23
    orr.16b     v0, v0, v24  // Val.I := (Val.I and $007FFFFF) or $3F800000;
    fmul.4s     v2, v0, v0   // X := Val.I, X2 := X * X

    fmla.4s     v19, v18, v0 // F4+F3*X
    fsub.4s     v3, v0, v17  // X-F2
    fmla.4s     v3, v2, v19  // (X-F2)+X2*(F4+F3*X)
    fmla.4s     v4, v0, v16  // F1*X+AddCst
    fmla.4s     v4, v2, v3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    fmla.4s     v4, v20, v1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    STORE3      v4, x1
    ret

_fast_ln_vector4: // (const A: TVector4; out Result: TVector4);
    adr         x2, LN_FACTORS_Q
    ld1.4s      {v0}, [x0]
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v23}, [x2], #64
    ld1.4s      {v24}, [x2]

    sshr.4s     v1, v0, #23  // Exp (Integer) := Val.I shr 23;
    scvtf.4s    v1, v1       // Exp (Float)
    fcmgt.4s    v2, v0, #0.0 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
    and.16b     v3, v2, v21  // (A > 0)? Yes: -89.93423858, No: 0
    bic.16b     v4, v22, v2  // (A > 0)? Yes: 0, No: NegInfinity
    orr.16b     v4, v4, v3   // (A > 0)? Yes: AddCst := -89.93423858, No: AddCst := NegInfinity

    and.16b     v0, v0, v23
    orr.16b     v0, v0, v24  // Val.I := (Val.I and $007FFFFF) or $3F800000;
    fmul.4s     v2, v0, v0   // X := Val.I, X2 := X * X

    fmla.4s     v19, v18, v0 // F4+F3*X
    fsub.4s     v3, v0, v17  // X-F2
    fmla.4s     v3, v2, v19  // (X-F2)+X2*(F4+F3*X)
    fmla.4s     v4, v0, v16  // F1*X+AddCst
    fmla.4s     v4, v2, v3   // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))
    fmla.4s     v4, v20, v1  // (F1*X+AddCst)+X2*((X-F2)+X2*(F4+F3*X))+(F5*Exp)

    st1.4s      {v4}, [x1]
    ret

LOG2_FACTORS_D:
    .float -124.22551499, -124.22551499                 // v16 / F1
    .float 1.498030302, 1.498030302                     // v17 / F2
    .float 1.72587999, 1.72587999                       // v18 / F3
    .float 0.3520887068, 0.3520887068                   // v19 / F4
    .float 1.1920928955078125e-7, 1.1920928955078125e-7 // v20 / F5
    .int 0x007FFFFF, 0x007FFFFF                         // v21
    .int 0x3F000000, 0x3F000000                         // v22

LOG2_FACTORS_Q:
    .float -124.22551499, -124.22551499, -124.22551499, -124.22551499
    .float 1.498030302, 1.498030302, 1.498030302, 1.498030302
    .float 1.72587999, 1.72587999, 1.72587999, 1.72587999
    .float 0.3520887068, 0.3520887068, 0.3520887068, 0.3520887068
    .float 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7
    .int 0x007FFFFF, 0x007FFFFF, 0x007FFFFF, 0x007FFFFF
    .int 0x3F000000, 0x3F000000, 0x3F000000, 0x3F000000

_fast_log2_scalar: // (const A: Single): Single;
    adr         x2, LOG2_FACTORS_D
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v22}, [x2]

    and.8b      v1, v0, v21
    orr.8b      v1, v1, v22    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    scvtf.2s    v0, v0         // VX.I as Float
    fmla.2s     v16, v0, v20   // F1+(VX.I*F5)
    fmls.2s     v16, v17, v1   // F1+(VX.I*F5)-(F2*MX.S)

    fadd.2s     v2, v19, v1    // F4+MX.S
    fdiv.2s     v3, v18, v2    // F3/(F4+MX.S)
    fsub.2s     v0, v16, v3    // F1+(VX.I*F5)-(F2*MX.S)-)F3/(F4+MX.S))
    ret

_fast_log2_vector2: // (const A: TVector2; out Result: TVector2);
    adr         x2, LOG2_FACTORS_D
    ld1.2s      {v0}, [x0]
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v22}, [x2]

    and.8b      v1, v0, v21
    orr.8b      v1, v1, v22    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    scvtf.2s    v0, v0         // VX.I as Float
    fmla.2s     v16, v0, v20   // F1+(VX.I*F5)
    fmls.2s     v16, v17, v1   // F1+(VX.I*F5)-(F2*MX.S)

    fadd.2s     v2, v19, v1    // F4+MX.S
    fdiv.2s     v3, v18, v2    // F3/(F4+MX.S)
    fsub.2s     v0, v16, v3    // F1+(VX.I*F5)-(F2*MX.S)-)F3/(F4+MX.S))
    st1.2s      {v0}, [x1]
    ret

_fast_log2_vector3: // (const A: TVector3; out Result: TVector3);
    adr         x2, LOG2_FACTORS_Q
    LOAD3       v0, x0
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v22}, [x2]

    and.16b     v1, v0, v21
    orr.16b     v1, v1, v22    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    scvtf.4s    v0, v0         // VX.I as Float
    fmla.4s     v16, v0, v20   // F1+(VX.I*F5)
    fmls.4s     v16, v17, v1   // F1+(VX.I*F5)-(F2*MX.S)

    fadd.4s     v2, v19, v1    // F4+MX.S
    fdiv.4s     v3, v18, v2    // F3/(F4+MX.S)
    fsub.4s     v0, v16, v3    // F1+(VX.I*F5)-(F2*MX.S)-)F3/(F4+MX.S))
    STORE3      v0, x1
    ret

_fast_log2_vector4: // (const A: TVector4; out Result: TVector4);
    adr         x2, LOG2_FACTORS_Q
    ld1.4s      {v0}, [x0]
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v22}, [x2]

    and.16b     v1, v0, v21
    orr.16b     v1, v1, v22    // MX.I := (VX.I and $007FFFFF) or $3F000000;
    scvtf.4s    v0, v0         // VX.I as Float
    fmla.4s     v16, v0, v20   // F1+(VX.I*F5)
    fmls.4s     v16, v17, v1   // F1+(VX.I*F5)-(F2*MX.S)

    fadd.4s     v2, v19, v1    // F4+MX.S
    fdiv.4s     v3, v18, v2    // F3/(F4+MX.S)
    fsub.4s     v0, v16, v3    // F1+(VX.I*F5)-(F2*MX.S)-)F3/(F4+MX.S))
    st1.4s      {v0}, [x1]
    ret

EXP2_FACTORS_D:
    .float 121.2740575, 121.2740575 // v16 / F1
    .float 27.7280233, 27.7280233   // v17 / F2
    .float 4.84252568, 4.84252568   // v18 / F3
    .float 1.49012907, 1.49012907   // v19 / F4
    .float 1.0, 1.0                 // v20
    .float 8388608.0, 8388608.0     // v21 (1 shl 23)

EXP2_FACTORS_Q:
    .float 121.2740575, 121.2740575, 121.2740575, 121.2740575
    .float 27.7280233, 27.7280233, 27.7280233, 27.7280233
    .float 4.84252568, 4.84252568, 4.84252568, 4.84252568
    .float 1.49012907, 1.49012907, 1.49012907, 1.49012907
    .float 1.0, 1.0, 1.0, 1.0
    .float 8388608.0, 8388608.0, 8388608.0, 8388608.0

_fast_exp2_scalar: // (const A: Single): Single;
    adr         x2, EXP2_FACTORS_D
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v21}, [x2]

    fcvtms.2s   v2, v0         // Floor(A) (as int)
    scvtf.2s    v2, v2         // Floor(A) (as float)
    fsub.2s     v1, v0, v2     // Z := A - Floor(A)

    fadd.2s     v0, v0, v16    // A+F1
    fsub.2s     v3, v18, v1    // F3-Z
    fdiv.2s     v2, v17, v3    // F2/(F3-Z)
    fadd.2s     v0, v0, v2     // A+F1+F2/(F3-Z)
    fmls.2s     v0, v19, v1    // A+F1+F2/(F3-Z)-F4*Z
    fmul.2s     v0, v0, v21    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    fcvtzs.2s   v0, v0         // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))
    ret

_fast_exp2_vector2: // (const A: TVector2; out Result: TVector2);
    adr         x2, EXP2_FACTORS_D
    ld1.2s      {v0}, [x0]
    ld1.2s      {v16-v19}, [x2], #32
    ld1.2s      {v20-v21}, [x2]

    fcvtms.2s   v2, v0         // Floor(A) (as int)
    scvtf.2s    v2, v2         // Floor(A) (as float)
    fsub.2s     v1, v0, v2     // Z := A - Floor(A)

    fadd.2s     v0, v0, v16    // A+F1
    fsub.2s     v3, v18, v1    // F3-Z
    fdiv.2s     v2, v17, v3    // F2/(F3-Z)
    fadd.2s     v0, v0, v2     // A+F1+F2/(F3-Z)
    fmls.2s     v0, v19, v1    // A+F1+F2/(F3-Z)-F4*Z
    fmul.2s     v0, v0, v21    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    fcvtzs.2s   v0, v0         // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    st1.2s      {v0}, [x1]
    ret

_fast_exp2_vector3: // (const A: TVector3; out Result: TVector3);
    adr         x2, EXP2_FACTORS_Q
    LOAD3       v0, x0
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v21}, [x2]

    fcvtms.4s   v2, v0         // Floor(A) (as int)
    scvtf.4s    v2, v2         // Floor(A) (as float)
    fsub.4s     v1, v0, v2     // Z := A - Floor(A)

    fadd.4s     v0, v0, v16    // A+F1
    fsub.4s     v3, v18, v1    // F3-Z
    fdiv.4s     v2, v17, v3    // F2/(F3-Z)
    fadd.4s     v0, v0, v2     // A+F1+F2/(F3-Z)
    fmls.4s     v0, v19, v1    // A+F1+F2/(F3-Z)-F4*Z
    fmul.4s     v0, v0, v21    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    fcvtzs.4s   v0, v0         // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    STORE3      v0, x1
    ret

_fast_exp2_vector4: // (const A: TVector4; out Result: TVector4);
    adr         x2, EXP2_FACTORS_Q
    ld1.4s      {v0}, [x0]
    ld1.4s      {v16-v19}, [x2], #64
    ld1.4s      {v20-v21}, [x2]

    fcvtms.4s   v2, v0         // Floor(A) (as int)
    scvtf.4s    v2, v2         // Floor(A) (as float)
    fsub.4s     v1, v0, v2     // Z := A - Floor(A)

    fadd.4s     v0, v0, v16    // A+F1
    fsub.4s     v3, v18, v1    // F3-Z
    fdiv.4s     v2, v17, v3    // F2/(F3-Z)
    fadd.4s     v0, v0, v2     // A+F1+F2/(F3-Z)
    fmls.4s     v0, v19, v1    // A+F1+F2/(F3-Z)-F4*Z
    fmul.4s     v0, v0, v21    // (1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z)
    fcvtzs.4s   v0, v0         // Trunc((1 shl 23) * (A+F1+F2/(F3-Z)-F4*Z))

    st1.4s      {v0}, [x1]
    ret

#endif // __LP64__
