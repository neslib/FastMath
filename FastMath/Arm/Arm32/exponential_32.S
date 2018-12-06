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
    .globl _sqrt_scalar, _sqrt_vector2, _sqrt_vector3, _sqrt_vector4
    .globl _inverse_sqrt_scalar, _inverse_sqrt_vector2, _inverse_sqrt_vector3, _inverse_sqrt_vector4

_sqrt_scalar: // (const A: Single): Single;
    vmov.f32    s0, r0
    SQRTD_MED   d1, d0
    vmov.f32    r0, s2
    bx          lr

_sqrt_vector2: // (const A: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]
    SQRTD_MED   d1, d0
    vst1.32     {d1}, [r1]
    bx          lr

_sqrt_vector3: // (const A: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}
    SQRTQ_MED   q1, q0
    fstmias     r1, {s4-s6}
    bx          lr

_sqrt_vector4: // (const A: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    SQRTQ_MED   q1, q0
    vst1.32     {q1}, [r1]
    bx          lr

_inverse_sqrt_scalar: // (const A: Single): Single;
    vmov.f32     s0, r0
    INVSQRTD_LOW d0, d0
    vmov.f32     r0, s0
    bx           lr

_inverse_sqrt_vector2: // (const A: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]
    INVSQRTD_LOW d0, d0
    vst1.32      {d0}, [r1]
    bx           lr

_inverse_sqrt_vector3: // (const A: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}
    INVSQRTQ_LOW q0, q0
    fstmias      r1, {s0-s2}
    bx           lr

_inverse_sqrt_vector4: // (const A: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]
    INVSQRTQ_LOW q0, q0
    vst1.32      {q0}, [r1]
    bx           lr

#endif // __LP64__