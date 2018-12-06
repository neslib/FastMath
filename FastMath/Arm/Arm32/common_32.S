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
    .globl _abs_scalar, _abs_vector2, _abs_vector3, _abs_vector4
    .globl _sign_scalar, _sign_vector2, _sign_vector3, _sign_vector4
    .globl _floor_scalar, _floor_vector2, _floor_vector3, _floor_vector4
    .globl _trunc_scalar, _trunc_vector2, _trunc_vector3, _trunc_vector4
    .globl _round_scalar, _round_vector2, _round_vector3, _round_vector4
    .globl _ceil_scalar, _ceil_vector2, _ceil_vector3, _ceil_vector4
    .globl _frac_scalar, _frac_vector2, _frac_vector3, _frac_vector4
    .globl _fmod_scalar, _fmod_vector2, _fmod_vector2_scalar, _fmod_vector3, _fmod_vector3_scalar, _fmod_vector4, _fmod_vector4_scalar
    .globl _modf_scalar, _modf_vector2, _modf_vector3, _modf_vector4
    .globl _min_vector2, _min_vector2_scalar, _min_vector3, _min_vector3_scalar, _min_vector4, _min_vector4_scalar
    .globl _max_vector2, _max_vector2_scalar, _max_vector3, _max_vector3_scalar, _max_vector4, _max_vector4_scalar
    .globl _ensure_range_scalar, _ensure_range_vector2, _ensure_range_vector2_scalar, _ensure_range_vector3, _ensure_range_vector3_scalar, _ensure_range_vector4, _ensure_range_vector4_scalar
    .globl _mix_vector2, _mix_vector2_scalar, _mix_vector3, _mix_vector3_scalar, _mix_vector4, _mix_vector4_scalar
    .globl _step_vector2, _step_scalar_vector2, _step_vector3, _step_scalar_vector3, _step_vector4, _step_scalar_vector4
    .globl _smoothstep_vector2, _smoothstep_scalar_vector2, _smoothstep_vector3, _smoothstep_scalar_vector3, _smoothstep_vector4, _smoothstep_scalar_vector4
    .globl _fma_vector2, _fma_vector3, _fma_vector4

_abs_scalar: // (const A: Single): Single;
    vmov.f32    s0, r0
    vabs.f32    d0, d0
    vmov.f32    r0, s0
    bx          lr

_abs_vector2: // (const A: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vabs.f32    d0, d0
    vst1.32     {d0}, [r1]
    bx          lr

_abs_vector3: // (const A: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}   
    vabs.f32    q0, q0
    fstmias     r1, {s0-s2}
    bx          lr

_abs_vector4: // (const A: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vabs.f32    q0, q0
    vst1.32     {q0}, [r1]
    bx          lr

_sign_scalar: // (const A: Single): Single;
    adr         r2, ONE_D
    vmov.f32    s0, r0
    vld1.32     {d1-d2}, [r2]
    vand.32     d3, d0, d2 // (A < 0)? Yes: $80000000, No: $00000000
    vorr.32     d3, d3, d1 // (A < 0)? Yes: -1.0, No: 1.0
    vceq.f32    d0, d0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    vbic.32     d0, d3, d0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    vmov.f32    r0, s0
    bx          lr

_sign_vector2: // (const A: TVector2; out Result: TVector2);
    adr         r2, ONE_D
    vld1.32     {d0}, [r0]
    vld1.32     {d1-d2}, [r2]
    vand.32     d3, d0, d2 // (A < 0)? Yes: $80000000, No: $00000000
    vorr.32     d3, d3, d1 // (A < 0)? Yes: -1.0, No: 1.0
    vceq.f32    d0, d0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    vbic.32     d0, d3, d0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    vst1.32     {d0}, [r1]
    bx          lr

_sign_vector3: // (const A: TVector3; out Result: TVector3);
    adr         r2, ONE_Q
    fldmias     r0, {s0-s2}
    vld1.32     {q1-q2}, [r2]
    vand.32     q3, q0, q2 // (A < 0)? Yes: $80000000, No: $00000000
    vorr.32     q3, q3, q1 // (A < 0)? Yes: -1.0, No: 1.0
    vceq.f32    q0, q0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    vbic.32     q0, q3, q0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    fstmias     r1, {s0-s2}
    bx          lr

_sign_vector4: // (const A: TVector4; out Result: TVector4);
    adr         r2, ONE_Q
    vld1.32     {q0}, [r0]
    vld1.32     {q1-q2}, [r2]
    vand.32     q3, q0, q2 // (A < 0)? Yes: $80000000, No: $00000000
    vorr.32     q3, q3, q1 // (A < 0)? Yes: -1.0, No: 1.0
    vceq.f32    q0, q0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    vbic.32     q0, q3, q0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    vst1.32     {q0}, [r1]
    bx          lr

_floor_scalar: // (const A: Single): Integer;
    vmov.f32     s0, r0
    vmov.s32     d1, #1

    vcvt.s32.f32 d2, d0     // Result := Trunc(A) (as int)
    vcvt.f32.s32 d3, d2     // Trunc(A) (as float)
    vsub.f32     d3, d0, d3 // Frac=A-Trunc(A)
    vclt.f32     d3, d3, #0 // (Frac<0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d1, d1, d3 // (Frac<0)? Yes: 1, No: 0
    vsub.s32     d2, d2, d1 // if (Frac < 0) then Result := Result - 1

    vmov.s32     r0, s4
    bx           lr

_floor_vector2: // (const A: TVector2; out Result: TIVector2);
    vld1.32      {d0}, [r0]
    vmov.s32     d1, #1

    vcvt.s32.f32 d2, d0     // Result := Trunc(A) (as int)
    vcvt.f32.s32 d3, d2     // Trunc(A) (as float)
    vsub.f32     d3, d0, d3 // Frac=A-Trunc(A)
    vclt.f32     d3, d3, #0 // (Frac<0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d1, d1, d3 // (Frac<0)? Yes: 1.0, No: 0.0
    vsub.s32     d2, d2, d1 // if (Frac < 0) then Result := Result - 1

    vst1.32      {d2}, [r1]
    bx           lr

_floor_vector3: // (const A: TVector3; out Result: TIVector3);
    fldmias      r0, {s0-s2}
    vmov.s32     q1, #1

    vcvt.s32.f32 q2, q0     // Result := Trunc(A) (as int)
    vcvt.f32.s32 q3, q2     // Trunc(A) (as float)
    vsub.f32     q3, q0, q3 // Frac=A-Trunc(A)
    vclt.f32     q3, q3, #0 // (Frac<0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q1, q1, q3 // (Frac<0)? Yes: 1.0, No: 0.0
    vsub.s32     q2, q2, q1 // if (Frac < 0) then Result := Result - 1

    fstmias      r1, {s8-s10}
    bx           lr

_floor_vector4: // (const A: TVector4; out Result: TIVector4);
    vld1.32      {q0}, [r0]
    vmov.s32     q1, #1

    vcvt.s32.f32 q2, q0     // Result := Trunc(A) (as int)
    vcvt.f32.s32 q3, q2     // Trunc(A) (as float)
    vsub.f32     q3, q0, q3 // Frac=A-Trunc(A)
    vclt.f32     q3, q3, #0 // (Frac<0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q1, q1, q3 // (Frac<0)? Yes: 1.0, No: 0.0
    vsub.s32     q2, q2, q1 // if (Frac < 0) then Result := Result - 1

    vst1.32      {q2}, [r1]
    bx           lr

_ceil_scalar: // (const A: Single): Integer;
    vmov.f32     s0, r0
    vmov.s32     d1, #1

    vcvt.s32.f32 d2, d0     // Result := Trunc(A) (as int)
    vcvt.f32.s32 d3, d2     // Trunc(A) (as float)
    vsub.f32     d3, d0, d3 // Frac=A-Trunc(A)
    vcgt.f32     d3, d3, #0 // (Frac>0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d1, d1, d3 // (Frac>0)? Yes: 1.0, No: 0.0
    vadd.s32     d2, d2, d1 // if (Frac > 0) then Result := Result + 1

    vmov.s32     r0, s4
    bx           lr

_ceil_vector2: // (const A: TVector2; out Result: TIVector2);
    vld1.32      {d0}, [r0]
    vmov.s32     d1, #1

    vcvt.s32.f32 d2, d0     // Result := Trunc(A) (as int)
    vcvt.f32.s32 d3, d2     // Trunc(A) (as float)
    vsub.f32     d3, d0, d3 // Frac=A-Trunc(A)
    vcgt.f32     d3, d3, #0 // (Frac>0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d1, d1, d3 // (Frac>0)? Yes: 1.0, No: 0.0
    vadd.s32     d2, d2, d1 // if (Frac > 0) then Result := Result + 1

    vst1.32      {d2}, [r1]
    bx           lr

_ceil_vector3: // (const A: TVector3; out Result: TIVector3);
    fldmias      r0, {s0-s2}
    vmov.s32     q1, #1

    vcvt.s32.f32 q2, q0     // Trunc(A) (as int)
    vcvt.f32.s32 q3, q2     // Result := Trunc(A) (as float)
    vsub.f32     q3, q0, q3 // Frac=A-Trunc(A)
    vcgt.f32     q3, q3, #0 // (Frac>0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q1, q1, q3 // (Frac>0)? Yes: 1.0, No: 0.0
    vadd.s32     q2, q2, q1 // if (Frac > 0) then Result := Result + 1

    fstmias      r1, {s8-s10}
    bx           lr

_ceil_vector4: // (const A: TVector4; out Result: TIVector4);
    vld1.32      {q0}, [r0]
    vmov.s32     q1, #1

    vcvt.s32.f32 q2, q0     // Trunc(A) (as int)
    vcvt.f32.s32 q3, q2     // Result := Trunc(A) (as float)
    vsub.f32     q3, q0, q3 // Frac=A-Trunc(A)
    vcgt.f32     q3, q3, #0 // (Frac>0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q1, q1, q3 // (Frac>0)? Yes: 1.0, No: 0.0
    vadd.s32     q2, q2, q1 // if (Frac > 0) then Result := Result + 1

    vst1.32      {q2}, [r1]
    bx           lr

_step_vector2: // (const AEdge, A: TVector2; out Result: TVector2);
    adr          r3, ONE_D
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vld1.32      {d2}, [r3] // 1.0
    vcge.f32     d0, d1, d0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d0, d0, d2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    vst1.32      {d0}, [r2]
    bx           lr

_step_scalar_vector2: // (const AEdge: Single; const A: TVector2; out Result: TVector2);
    adr          r3, ONE_D
    vdup.32      d0, r0
    vld1.32      {d1}, [r1]
    vld1.32      {d2}, [r3] // 1.0
    vcge.f32     d0, d1, d0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d0, d0, d2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    vst1.32      {d0}, [r2]
    bx           lr

_step_vector3: // (const AEdge, A: TVector3; out Result: TVector3);
    adr          r3, ONE_Q
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    vld1.32      {q2}, [r3] // 1.0
    vcge.f32     q0, q1, q0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q0, q0, q2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    fstmias      r2, {s0-s2}
    bx           lr

_step_scalar_vector3: // (const AEdge: Single; const A: TVector3; out Result: TVector3);
    adr          r3, ONE_Q
    vdup.32      q0, r0
    fldmias      r1, {s4-s6}
    vld1.32      {q2}, [r3] // 1.0
    vcge.f32     q0, q1, q0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q0, q0, q2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    fstmias      r2, {s0-s2}
    bx           lr

_step_vector4: // (const AEdge, A: TVector4; out Result: TVector4);
    adr          r3, ONE_Q
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vld1.32      {q2}, [r3] // 1.0
    vcge.f32     q0, q1, q0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q0, q0, q2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    vst1.32      {q0}, [r2]
    bx           lr

_step_scalar_vector4: // (const AEdge: Single; const A: TVector4; out Result: TVector4);
    adr          r3, ONE_Q
    vdup.32      q0, r0
    vld1.32      {q1}, [r1]
    vld1.32      {q2}, [r3] // 1.0
    vcge.f32     q0, q1, q0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q0, q0, q2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    vst1.32      {q0}, [r2]
    bx           lr

ONE_D:
    .float 1.0, 1.0
    .int 0x80000000, 0x80000000 // sign bit

ONE_Q:
    .float 1.0, 1.0, 1.0, 1.0
    .int 0x80000000, 0x80000000, 0x80000000, 0x80000000
    
_trunc_scalar: // (const A: Single): Integer;
    vmov.f32     s0, r0
    vcvt.s32.f32 d0, d0     // Trunc(A) (as int)
    vmov.s32     r0, s0
    bx           lr

_trunc_vector2: // (const A: TVector2; out Result: TIVector2);
    vld1.32      {d0}, [r0]
    vcvt.s32.f32 d0, d0     // Trunc(A) (as int)
    vst1.32      {d0}, [r1]
    bx           lr

_trunc_vector3: // (const A: TVector3; out Result: TIVector3);
    fldmias      r0, {s0-s2}
    vcvt.s32.f32 q0, q0     // Trunc(A) (as int)
    fstmias      r1, {s0-s2}
    bx           lr

_trunc_vector4: // (const A: TVector4; out Result: TIVector4);
    vld1.32      {q0}, [r0]
    vcvt.s32.f32 q0, q0     // Trunc(A) (as int)
    vst1.32      {q0}, [r1]
    bx           lr

_round_scalar: // (const A: Single): Integer;
    adr          r2, ROUND_D
    vmov.f32     s0, r0
    vld1.32      {d1-d2}, [r2]
    vclt.f32     d3, d0, #0 // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d1, d1, d3 // (A < 0)? Yes: -0.5, No: 0.0
    vbic.32      d2, d2, d3 // (A < 0)? Yes: 0.0, No: 0.499999
    vorr.32      d1, d1, d2 // (A < 0)? Yes: -0.5, No: 0.499999
    vadd.f32     d0, d0, d1 // A := A + Rounding
    vcvt.s32.f32 d0, d0     // Trunc(A) (as int)
    vmov.s32     r0, s0
    bx           lr

_round_vector2: // (const A: TVector2; out Result: TIVector2);
    adr          r2, ROUND_D
    vld1.32      {d0}, [r0]
    vld1.32      {d1-d2}, [r2]
    vclt.f32     d3, d0, #0 // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      d1, d1, d3 // (A < 0)? Yes: -0.5, No: 0.0
    vbic.32      d2, d2, d3 // (A < 0)? Yes: 0.0, No: 0.499999
    vorr.32      d1, d1, d2 // (A < 0)? Yes: -0.5, No: 0.499999
    vadd.f32     d0, d0, d1 // A := A + Rounding
    vcvt.s32.f32 d0, d0     // Trunc(A) (as int)
    vst1.32      {d0}, [r1]
    bx           lr

_round_vector3: // (const A: TVector3; out Result: TIVector3);
    adr          r2, ROUND_Q
    fldmias      r0, {s0-s2}
    vld1.32      {q1-q2}, [r2]
    vclt.f32     q3, q0, #0 // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q1, q1, q3 // (A < 0)? Yes: -0.5, No: 0.0
    vbic.32      q2, q2, q3 // (A < 0)? Yes: 0.0, No: 0.499999
    vorr.32      q1, q1, q2 // (A < 0)? Yes: -0.5, No: 0.499999
    vadd.f32     q0, q0, q1 // A := A + Rounding
    vcvt.s32.f32 q0, q0     // Trunc(A) (as int)
    fstmias      r1, {s0-s2}
    bx           lr

_round_vector4: // (const A: TVector4; out Result: TIVector4);
    adr          r2, ROUND_Q
    vld1.32      {q0}, [r0]
    vld1.32      {q1-q2}, [r2]
    vclt.f32     q3, q0, #0 // (A < 0)? Yes: $FFFFFFFF, No: $00000000
    vand.32      q1, q1, q3 // (A < 0)? Yes: -0.5, No: 0.0
    vbic.32      q2, q2, q3 // (A < 0)? Yes: 0.0, No: 0.499999
    vorr.32      q1, q1, q2 // (A < 0)? Yes: -0.5, No: 0.499999
    vadd.f32     q0, q0, q1 // A := A + Rounding
    vcvt.s32.f32 q0, q0     // Trunc(A) (as int)
    vst1.32      {q0}, [r1]
    bx           lr

ROUND_D:
    .float -0.5, -0.5
    .float 0.499999, 0.499999

ROUND_Q:
    .float -0.5, -0.5, -0.5, -0.5
    .float 0.499999, 0.499999, 0.499999, 0.499999
    
_frac_scalar: // (const A: Single): Single;
    vmov.f32     s0, r0
    vcvt.s32.f32 d1, d0     // Trunc(A) (as int)
    vcvt.f32.s32 d1, d1     // Trunc(A) (as float)
    vsub.f32     d0, d0, d1 // Frac=A-Trunc(A)
    vmov.f32     r0, s0
    bx           lr

_frac_vector2: // (const A: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vcvt.s32.f32 d1, d0     // Trunc(A) (as int)
    vcvt.f32.s32 d1, d1     // Trunc(A) (as float)
    vsub.f32     d0, d0, d1 // Frac=A-Trunc(A)
    vst1.32      {d0}, [r1]
    bx           lr

_frac_vector3: // (const A: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    vcvt.s32.f32 q1, q0     // Trunc(A) (as int)
    vcvt.f32.s32 q1, q1     // Trunc(A) (as float)
    vsub.f32     q0, q0, q1 // Frac=A-Trunc(A)
    fstmias      r1, {s0-s2}
    bx           lr

_frac_vector4: // (const A: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vcvt.s32.f32 q1, q0     // Trunc(A) (as int)
    vcvt.f32.s32 q1, q1     // Trunc(A) (as float)
    vsub.f32     q0, q0, q1 // Frac=A-Trunc(A)
    vst1.32      {q0}, [r1]
    bx           lr

_fmod_scalar: // (const A, B: Single): Single;
    vmov.f32     s0, r0     // d0=A
    vmov.f32     s2, r1     // d1=B

    RECIPD_MED   d2, d1     // 1 / B

    vmul.f32     d3, d0, d2 // A/B
    vcvt.s32.f32 d3, d3     // Trunc(A/B) (as int)
    vcvt.f32.s32 d3, d3     // Trunc(A/B) (as float)
    vmls.f32     d0, d1, d3 // A - (B * Trunc(A / B))
    vmov.f32     r0, s0
    bx           lr

_fmod_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]

    RECIPD_MED   d2, d1     // 1 / B

    vmul.f32     d3, d0, d2 // A/B
    vcvt.s32.f32 d3, d3     // Trunc(A/B) (as int)
    vcvt.f32.s32 d3, d3     // Trunc(A/B) (as float)
    vmls.f32     d0, d1, d3 // A - (B * Trunc(A / B))
    vst1.32      {d0}, [r2]
    bx           lr

_fmod_vector3: // (const A, B: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}

    RECIPQ_MED   q2, q1     // 1 / B

    vmul.f32     q3, q0, q2 // A/B
    vcvt.s32.f32 q3, q3     // Trunc(A/B) (as int)
    vcvt.f32.s32 q3, q3     // Trunc(A/B) (as float)
    vmls.f32     q0, q1, q3 // A - (B * Trunc(A / B))
    fstmias      r2, {s0-s2}
    bx           lr

_fmod_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]

    RECIPQ_MED   q2, q1     // 1 / B

    vmul.f32     q3, q0, q2 // A/B
    vcvt.s32.f32 q3, q3     // Trunc(A/B) (as int)
    vcvt.f32.s32 q3, q3     // Trunc(A/B) (as float)
    vmls.f32     q0, q1, q3 // A - (B * Trunc(A / B))
    vst1.32      {q0}, [r2]
    bx           lr

_fmod_vector2_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vdup.32      d1, r1     // Duplicate B

    RECIPD_MED   d2, d1     // 1 / B

    vmul.f32     d3, d0, d2 // A/B
    vcvt.s32.f32 d3, d3     // Trunc(A/B) (as int)
    vcvt.f32.s32 d3, d3     // Trunc(A/B) (as float)
    vmls.f32     d0, d1, d3 // A - (B * Trunc(A / B))
    vst1.32      {d0}, [r2]
    bx           lr

_fmod_vector3_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias      r0, {s0-s2}
    vdup.32      q1, r1     // Duplicate B

    RECIPQ_MED   q2, q1     // 1 / B

    vmul.f32     q3, q0, q2 // A/B
    vcvt.s32.f32 q3, q3     // Trunc(A/B) (as int)
    vcvt.f32.s32 q3, q3     // Trunc(A/B) (as float)
    vmls.f32     q0, q1, q3 // A - (B * Trunc(A / B))
    fstmias      r2, {s0-s2}
    bx           lr

_fmod_vector4_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vdup.32      q1, r1     // Duplicate B

    RECIPQ_MED   q2, q1     // 1 / B

    vmul.f32     q3, q0, q2 // A/B
    vcvt.s32.f32 q3, q3     // Trunc(A/B) (as int)
    vcvt.f32.s32 q3, q3     // Trunc(A/B) (as float)
    vmls.f32     q0, q1, q3 // A - (B * Trunc(A / B))
    vst1.32      {q0}, [r2]
    bx           lr

_modf_scalar: // (const A: Single; out B: Integer): Single;
    vmov.f32     s0, r0
    vcvt.s32.f32 d1, d0        // Trunc(A) (as int)
    vcvt.f32.s32 d2, d1        // Trunc(A) (as float)
    vsub.f32     d0, d0, d2    // Frac=A-Trunc(A)
    vst1.32      {d1[0]}, [r1] // B := Trunc(A)
    vmov.f32     r0, s0        // Result := Frac(A)
    bx           lr

_modf_vector2: // (const A: TVector2; out B: TIVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vcvt.s32.f32 d1, d0        // Trunc(A) (as int)
    vcvt.f32.s32 d2, d1        // Trunc(A) (as float)
    vsub.f32     d0, d0, d2    // Frac=A-Trunc(A)
    vst1.32      {d1}, [r1]    // B := Trunc(A)
    vst1.32      {d0}, [r2]    // Result := Frac(A)
    bx           lr

_modf_vector3: // (const A: TVector3; out B: TIVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    vcvt.s32.f32 q1, q0        // Trunc(A) (as int)
    vcvt.f32.s32 q2, q1        // Trunc(A) (as float)
    vsub.f32     q0, q0, q2    // Frac=A-Trunc(A)
    fstmias      r1, {s4-s6}   // B := Trunc(A)
    fstmias      r2, {s0-s2}   // Result := Frac(A)
    bx           lr

_modf_vector4: // (const A: TVector4; out B: TIVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vcvt.s32.f32 q1, q0        // Trunc(A) (as int)
    vcvt.f32.s32 q2, q1        // Trunc(A) (as float)
    vsub.f32     q0, q0, q2    // Frac=A-Trunc(A)
    vst1.32      {q1}, [r1]    // B := Trunc(A)
    vst1.32      {q0}, [r2]    // Result := Frac(A)
    bx           lr

_min_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vmin.f32     d0, d0, d1
    vst1.32      {d0}, [r2]
    bx           lr

_min_vector2_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vdup.32      d1, r1
    vmin.f32     d0, d0, d1
    vst1.32      {d0}, [r2]
    bx           lr

_min_vector3: // (const A, B: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    vmin.f32     q0, q0, q1
    fstmias      r2, {s0-s2}
    bx           lr

_min_vector3_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias      r0, {s0-s2}
    vdup.32      q1, r1
    vmin.f32     q0, q0, q1
    fstmias      r2, {s0-s2}
    bx           lr

_min_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vmin.f32     q0, q0, q1
    vst1.32      {q0}, [r2]
    bx           lr

_min_vector4_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vdup.32      q1, r1
    vmin.f32     q0, q0, q1
    vst1.32      {q0}, [r2]
    bx           lr

_max_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vmax.f32     d0, d0, d1
    vst1.32      {d0}, [r2]
    bx           lr

_max_vector2_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vdup.32      d1, r1
    vmax.f32     d0, d0, d1
    vst1.32      {d0}, [r2]
    bx           lr

_max_vector3: // (const A, B: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    vmax.f32     q0, q0, q1
    fstmias      r2, {s0-s2}
    bx           lr

_max_vector3_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias      r0, {s0-s2}
    vdup.32      q1, r1
    vmax.f32     q0, q0, q1
    fstmias      r2, {s0-s2}
    bx           lr

_max_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vmax.f32     q0, q0, q1
    vst1.32      {q0}, [r2]
    bx           lr

_max_vector4_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vdup.32      q1, r1
    vmax.f32     q0, q0, q1
    vst1.32      {q0}, [r2]
    bx           lr

_ensure_range_scalar: // (const A, AMin, AMax: Single): Single;
    vmov.f32     s0, r0     // d0=A
    vmov.f32     s2, r1     // d1=AMin
    vmov.f32     s4, r2     // d2=AMax
    vmax.f32     d0, d0, d1 // Max(A, AMin)
    vmin.f32     d0, d0, d2 // Min(Max(A, AMin), AMax)
    vmov.f32     r0, s0
    bx           lr

_ensure_range_vector2: // (const A, AMin, AMax: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vld1.32      {d2}, [r2]
    vmax.f32     d0, d0, d1
    vmin.f32     d0, d0, d2
    vst1.32      {d0}, [r3]
    bx           lr

_ensure_range_vector2_scalar: // (const A: TVector2; const AMin, AMax: Single; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vdup.32      d1, r1
    vdup.32      d2, r2
    vmax.f32     d0, d0, d1
    vmin.f32     d0, d0, d2
    vst1.32      {d0}, [r3]
    bx           lr

_ensure_range_vector3: // (const A, AMin, AMax: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    fldmias      r2, {s8-s10}
    vmax.f32     q0, q0, q1
    vmin.f32     q0, q0, q2
    fstmias      r3, {s0-s2}
    bx           lr

_ensure_range_vector3_scalar: // (const A: TVector3; const AMin, AMax: Single; out Result: TVector3);
    fldmias      r0, {s0-s2}
    vdup.32      q1, r1
    vdup.32      q2, r2
    vmax.f32     q0, q0, q1
    vmin.f32     q0, q0, q2
    fstmias      r3, {s0-s2}
    bx           lr

_ensure_range_vector4: // (const A, AMin, AMax: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vld1.32      {q2}, [r2]
    vmax.f32     q0, q0, q1
    vmin.f32     q0, q0, q2
    vst1.32      {q0}, [r3]
    bx           lr

_ensure_range_vector4_scalar: // (const A: TVector4; const AMin, AMax: Single; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vdup.32      q1, r1
    vdup.32      q2, r2
    vmax.f32     q0, q0, q1
    vmin.f32     q0, q0, q2
    vst1.32      {q0}, [r3]
    bx           lr

_mix_vector2: // (const A, B, T: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vld1.32      {d2}, [r2]
    vsub.f32     d1, d1, d0 // B - A
    vmla.f32     d0, d1, d2 // A + (T * (B - A))
    vst1.32      {d0}, [r3]
    bx           lr

_mix_vector2_scalar: // (const A, B: TVector2; T: Single; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vdup.32      d2, r2
    vsub.f32     d1, d1, d0 // B - A
    vmla.f32     d0, d1, d2 // A + (T * (B - A))
    vst1.32      {d0}, [r3]
    bx           lr

_mix_vector3: // (const A, B, T: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    fldmias      r2, {s8-s10}
    vsub.f32     q1, q1, q0 // B - A
    vmla.f32     q0, q1, q2 // A + (T * (B - A))
    fstmias      r3, {s0-s2}
    bx           lr

_mix_vector3_scalar: // (const A, B: TVector3; T: Single; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    vdup.32      q2, r2
    vsub.f32     q1, q1, q0 // B - A
    vmla.f32     q0, q1, q2 // A + (T * (B - A))
    fstmias      r3, {s0-s2}
    bx           lr

_mix_vector4: // (const A, B, T: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vld1.32      {q2}, [r2]
    vsub.f32     q1, q1, q0 // B - A
    vmla.f32     q0, q1, q2 // A + (T * (B - A))
    vst1.32      {q0}, [r3]
    bx           lr

_mix_vector4_scalar: // (const A, B: TVector4; T: Single; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vdup.32      q2, r2
    vsub.f32     q1, q1, q0 // B - A
    vmla.f32     q0, q1, q2 // A + (T * (B - A))
    vst1.32      {q0}, [r3]
    bx           lr

#if FORCE_THUMB
#define rx r4
#else
#define rx r12
#endif
    
_smoothstep_vector2: // (const AEdge0, AEdge1, A: TVector2; out Result: TVector2);
#if FORCE_THUMB
    push         {rx}
#endif
    adr          rx, SMOOTH_STEP_D
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vld1.32      {d2}, [r2]
    vld1.32      {d16-d18}, [rx]
    vcge.f32     d19, d2, d0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    vcle.f32     d20, d2, d1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    vbic.32      d16, d16, d20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    vsub.f32     d1, d1, d0      // AEdge1-AEdge0

    RECIPD_MED   d3, d1          // 1/(AEdge1-AEdge0)

    vsub.f32     d2, d2, d0      // (A - AEdge0)
    vmul.f32     d2, d2, d3      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    vmls.f32     d18, d17, d2    // 3 - (2 * Temp)
    vmul.f32     d0, d18, d2     // Temp * (3 - (2 * Temp))
    vmul.f32     d0, d0, d2      // Result := Temp * Temp * (3 - (2 * Temp))

    vand.32      d0, d0, d19     // (A < AEdge0)? Yes: 0.0, No: Result
    vand.32      d0, d0, d20     // (A > AEdge1)? Yes: 0.0, No: Result
    vorr.32      d0, d0, d16     // (A > AEdge1)? Yes: 1.0, No: Result

    vst1.32      {d0}, [r3]
#if FORCE_THUMB
    pop          {rx}
#endif
    bx           lr

_smoothstep_scalar_vector2: // (const AEdge0, AEdge1: Single; const A: TVector2; out Result: TVector2);
#if FORCE_THUMB
    push         {rx}
#endif
    adr          rx, SMOOTH_STEP_D
    vdup.32      d0, r0
    vdup.32      d1, r1
    vld1.32      {d2}, [r2]
    vld1.32      {d16-d18}, [rx]
    vcge.f32     d19, d2, d0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    vcle.f32     d20, d2, d1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    vbic.32      d16, d16, d20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    vsub.f32     d1, d1, d0      // AEdge1-AEdge0

    RECIPD_MED   d3, d1          // 1/(AEdge1-AEdge0)

    vsub.f32     d2, d2, d0      // (A - AEdge0)
    vmul.f32     d2, d2, d3      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    vmls.f32     d18, d17, d2    // 3 - (2 * Temp)
    vmul.f32     d0, d18, d2     // Temp * (3 - (2 * Temp))
    vmul.f32     d0, d0, d2      // Result := Temp * Temp * (3 - (2 * Temp))

    vand.32      d0, d0, d19     // (A < AEdge0)? Yes: 0.0, No: Result
    vand.32      d0, d0, d20     // (A > AEdge1)? Yes: 0.0, No: Result
    vorr.32      d0, d0, d16     // (A > AEdge1)? Yes: 1.0, No: Result

    vst1.32      {d0}, [r3]
#if FORCE_THUMB
    pop          {rx}
#endif
    bx           lr

_smoothstep_vector3: // (const AEdge0, AEdge1, A: TVector3; out Result: TVector3);
#if FORCE_THUMB
    push         {rx}
#endif
    adr          rx, SMOOTH_STEP_Q
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    fldmias      r2, {s8-s10}
    vld1.32      {q8-q9}, [rx]!
    vld1.32      {q10}, [rx]
    vcge.f32     q11, q2, q0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    vcle.f32     q12, q2, q1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    vbic.32      q8, q8, q12     // (A > AEdge1)? Yes: 1.0, No: 0.0
    vsub.f32     q1, q1, q0      // AEdge1-AEdge0

    RECIPQ_MED   q3, q1          // 1/(AEdge1-AEdge0)

    vsub.f32     q2, q2, q0      // (A - AEdge0)
    vmul.f32     q2, q2, q3      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    vmls.f32     q10, q9, q2     // 3 - (2 * Temp)
    vmul.f32     q0, q10, q2     // Temp * (3 - (2 * Temp))
    vmul.f32     q0, q0, q2      // Result := Temp * Temp * (3 - (2 * Temp))

    vand.32      q0, q0, q11     // (A < AEdge0)? Yes: 0.0, No: Result
    vand.32      q0, q0, q12     // (A > AEdge1)? Yes: 0.0, No: Result
    vorr.32      q0, q0, q8      // (A > AEdge1)? Yes: 1.0, No: Result

    fstmias      r3, {s0-s2}
#if FORCE_THUMB
    pop          {rx}
#endif
    bx           lr

_smoothstep_scalar_vector3: // (const AEdge0, AEdge1: Single; const A: TVector3; out Result: TVector3);
#if FORCE_THUMB
    push         {rx}
#endif
    adr          rx, SMOOTH_STEP_Q
    vdup.32      q0, r0
    vdup.32      q1, r1
    fldmias      r2, {s8-s10}
    vld1.32      {q8-q9}, [rx]!
    vld1.32      {q10}, [rx]
    vcge.f32     q11, q2, q0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    vcle.f32     q12, q2, q1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    vbic.32      q8, q8, q12     // (A > AEdge1)? Yes: 1.0, No: 0.0
    vsub.f32     q1, q1, q0      // AEdge1-AEdge0

    RECIPQ_MED   q3, q1          // 1/(AEdge1-AEdge0)

    vsub.f32     q2, q2, q0      // (A - AEdge0)
    vmul.f32     q2, q2, q3      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    vmls.f32     q10, q9, q2     // 3 - (2 * Temp)
    vmul.f32     q0, q10, q2     // Temp * (3 - (2 * Temp))
    vmul.f32     q0, q0, q2      // Result := Temp * Temp * (3 - (2 * Temp))

    vand.32      q0, q0, q11     // (A < AEdge0)? Yes: 0.0, No: Result
    vand.32      q0, q0, q12     // (A > AEdge1)? Yes: 0.0, No: Result
    vorr.32      q0, q0, q8      // (A > AEdge1)? Yes: 1.0, No: Result

    fstmias      r3, {s0-s2}
#if FORCE_THUMB
    pop          {rx}
#endif
    bx           lr

_smoothstep_vector4: // (const AEdge0, AEdge1, A: TVector4; out Result: TVector4);
#if FORCE_THUMB
    push         {rx}
#endif
    adr          rx, SMOOTH_STEP_Q
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vld1.32      {q2}, [r2]
    vld1.32      {q8-q9}, [rx]!
    vld1.32      {q10}, [rx]
    vcge.f32     q11, q2, q0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    vcle.f32     q12, q2, q1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    vbic.32      q8, q8, q12     // (A > AEdge1)? Yes: 1.0, No: 0.0
    vsub.f32     q1, q1, q0      // AEdge1-AEdge0

    RECIPQ_MED   q3, q1          // 1/(AEdge1-AEdge0)

    vsub.f32     q2, q2, q0      // (A - AEdge0)
    vmul.f32     q2, q2, q3      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    vmls.f32     q10, q9, q2     // 3 - (2 * Temp)
    vmul.f32     q0, q10, q2     // Temp * (3 - (2 * Temp))
    vmul.f32     q0, q0, q2      // Result := Temp * Temp * (3 - (2 * Temp))

    vand.32      q0, q0, q11     // (A < AEdge0)? Yes: 0.0, No: Result
    vand.32      q0, q0, q12     // (A > AEdge1)? Yes: 0.0, No: Result
    vorr.32      q0, q0, q8      // (A > AEdge1)? Yes: 1.0, No: Result

    vst1.32      {q0}, [r3]
#if FORCE_THUMB
    pop          {rx}
#endif
    bx           lr

_smoothstep_scalar_vector4: // (const AEdge0, AEdge1: Single; const A: TVector4; out Result: TVector4);
#if FORCE_THUMB
    push         {rx}
#endif
    adr          rx, SMOOTH_STEP_Q
    vdup.32      q0, r0
    vdup.32      q1, r1
    vld1.32      {q2}, [r2]
    vld1.32      {q8-q9}, [rx]!
    vld1.32      {q10}, [rx]
    vcge.f32     q11, q2, q0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    vcle.f32     q12, q2, q1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    vbic.32      q8, q8, q12     // (A > AEdge1)? Yes: 1.0, No: 0.0
    vsub.f32     q1, q1, q0      // AEdge1-AEdge0

    RECIPQ_MED   q3, q1          // 1/(AEdge1-AEdge0)

    vsub.f32     q2, q2, q0      // (A - AEdge0)
    vmul.f32     q2, q2, q3      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    vmls.f32     q10, q9, q2     // 3 - (2 * Temp)
    vmul.f32     q0, q10, q2     // Temp * (3 - (2 * Temp))
    vmul.f32     q0, q0, q2      // Result := Temp * Temp * (3 - (2 * Temp))

    vand.32      q0, q0, q11     // (A < AEdge0)? Yes: 0.0, No: Result
    vand.32      q0, q0, q12     // (A > AEdge1)? Yes: 0.0, No: Result
    vorr.32      q0, q0, q8      // (A > AEdge1)? Yes: 1.0, No: Result

    vst1.32      {q0}, [r3]
#if FORCE_THUMB
    pop          {rx}
#endif
    bx           lr

SMOOTH_STEP_D:
    .float 1.0, 1.0 // d16
    .float 2.0, 2.0 // d17
    .float 3.0, 3.0 // d18

SMOOTH_STEP_Q:
    .float 1.0, 1.0, 1.0, 1.0
    .float 2.0, 2.0, 2.0, 2.0
    .float 3.0, 3.0, 3.0, 3.0
    
_fma_vector2: // (const A, B, C: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    vld1.32      {d1}, [r1]
    vld1.32      {d2}, [r2]
    vmla.f32     d2, d0, d1 // (A * B) + C
    vst1.32      {d2}, [r3]
    bx           lr

_fma_vector3: // (const A, B, C: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    fldmias      r1, {s4-s6}
    fldmias      r2, {s8-s10}
    vmla.f32     q2, q0, q1 // (A * B) + C
    fstmias      r3, {s8-s10}
    bx           lr

_fma_vector4: // (const A, B, C: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    vld1.32      {q1}, [r1]
    vld1.32      {q2}, [r2]
    vmla.f32     q2, q0, q1 // (A * B) + C
    vst1.32      {q2}, [r3]
    bx           lr

#endif // __LP64__
