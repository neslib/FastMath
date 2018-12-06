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
    .globl _neg_vector4
    .globl _vector4_add_scalar, _scalar_add_vector4, _vector4_add_vector4
    .globl _vector4_sub_scalar, _scalar_sub_vector4, _vector4_sub_vector4
    .globl _vector4_mul_scalar, _scalar_mul_vector4, _vector4_mul_vector4
    .globl _vector4_div_scalar, _scalar_div_vector4, _vector4_div_vector4
    .globl _vector4_length, _vector4_distance, _vector4_distance_squared
    .globl _vector4_dot, _vector4_normalize, _vector4_faceforward
    .globl _vector4_reflect, _vector4_refract

/* Calculates 4D dot product.

   Parameters:
     Res: q-register that will be set to the result. Can be the same as A or B.
     ResLo, ResHi: d-register that matches the lower and upper register of Res
       (for example, if Res is set to q3, then ResLo must be d6 and ResHi must
       be d7). The ResLo register will contain the eventual dot product (twice).
     A, B: the two vectors to calculate the dot product for (q-registers). */
.macro DOT4 Res ResLo ResHi A B
    vmul.f32    \Res, \A, \B           // (A.W*B.W) (A.Z*B.Z) (A.Y*B.Y) (A.X*B.X)
    vpadd.f32   \ResLo, \ResLo, \ResHi // (A.W*B.W)+(A.Z*B.Z) (A.Y*B.Y)+(A.X*B.X)
    vpadd.f32   \ResLo, \ResLo, \ResLo // (A.W*B.W)+(A.Z*B.Z)+(A.Y*B.Y)+(A.X*B.X) (x2)
.endm

_neg_vector4: // (const A: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vneg.f32    q0, q0
    vst1.f32    {q0}, [r1]
    bx          lr

_vector4_add_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    vadd.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_add_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    vadd.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_add_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vadd.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_sub_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    vsub.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_sub_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    vsub.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_sub_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vsub.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_mul_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_mul_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_mul_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_div_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    RECIPQ_MED  q1, q1     // 1 / B
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_div_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    RECIPQ_MED  q1, q1     // 1 / B
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_div_vector4: // (const A, B: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    RECIPQ_MED  q1, q1     // 1 / B
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector4_length: // (const A: TVector4): Single;
    vld1.32     {q0}, [r0]         // W Z Y X
    DOT4        q0, d0, d1, q0, q0 // Dot(A, A)
    SQRTD_MED   d1, d0             // Sqrt(Dot(A, A))
    vmov.f32    r0, s2
    bx          lr

_vector4_distance: // (const A, B: TVector4): Single;
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vsub.f32    q0, q0, q1         // C=A-B
    DOT4        q0, d0, d1, q0, q0 // Dot(C, C)
    SQRTD_MED   d1, d0             // Sqrt(Dot(C, C))
    vmov.f32    r0, s2
    bx          lr

_vector4_distance_squared: // (const A, B: TVector4): Single;
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vsub.f32    q0, q0, q1         // C=A-B
    DOT4        q0, d0, d1, q0, q0 // Dot(C, C)
    vmov.f32    r0, s0
    bx          lr

_vector4_dot: // (const A, B: TVector4): Single;
    vld1.32     {q0}, [r0]  // A.W A.Z A.Y A.X
    vld1.32     {q1}, [r1]  // B.W B.Z B.Y B.X
    DOT4        q0, d0, d1, q0, q1
    vmov.f32    r0, s0
    bx          lr

_vector4_normalize: // (const A: TVector4; out Result: TVector4);
    vld1.32      {q0}, [r0]         // W Z Y X
    vmov         q8, q0
    DOT4         q0, d0, d1, q0, q0 // Dot(A, A)
    INVSQRTD_MED d1, d0             // 1 / Sqrt(Dot(A, A))
    vmul.f32     d0, d16, d1        // A / Sqrt(Dot(A, A))
    vmul.f32     d1, d17, d1
    vst1.32      {q0}, [r1]
    bx           lr

_vector4_faceforward: // (const N, I, NRef: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]         // N
    vld1.32     {q1}, [r1]         // I
    vld1.32     {q2}, [r2]         // NRef

    DOT4        q2, d4, d5, q2, q1 // Dot(NRef, I)
    vneg.f32    q3, q0             // -N
    vclt.f32    q2, q2, #0         // (Dot(NRef, I) < 0)? Yes: $FFFFFFFF, No: $00000000
    vbsl.f32    q2, q0, q3         // (Dot(NRef, I) < 0)? Yes: N, No: -N
    vst1.32     {q2}, [r3]

    bx          lr

_vector4_reflect: // (const I, N: TVector4; out Result: TVector4);
    vld1.32     {q0}, [r0]         // I
    vld1.32     {q1}, [r1]         // N
    vmov        q2, q0             // I
    vmov.f32    d6, #2.0           // 2
    DOT4        q0, d0, d1, q0, q1 // Dot(N, I) (2x)
    vmul.f32    d0, d0, d6         // (2*Dot(N, I)) (2x)
    vmls.f32    d4, d0, d2
    vmls.f32    d5, d0, d3         // I - ((2 * Dot(N, I)) * N);
    vst1.32     {q2}, [r2]
    bx          lr

_vector4_refract: // (const I, N: TVector4; const Eta: Single; out Result: TVector4);
    vld1.32     {q0}, [r0]             // I
    vld1.32     {q1}, [r1]             // N
    vdup.32     q8, r2                 // Eta
    DOT4        q2, d4, d5, q1, q0     // D := Dot(N, I)
    vmov.f32    d6, #1.0               // 1
    vmov        d7, d6                 // 1
    vmls.f32    d6, d4, d4             // 1-D*D
    vmul.f32    d6, d6, d16            // Eta*(1-D*D)
    vmls.f32    d7, d16, d6            // K := 1-Eta*Eta*(1-D*D)
    vcmp.f32    s14, #0                // if (K < 0) then Result.Init
    vmrs        APSR_nzcv, FPSCR
    blt         _set_null_vec4
    vmul.f32    q0, q0, q8             // Eta * I
    SQRTD_LOW   d6, d7                 // Sqrt(K)
    vdup.32     q9, d6[0]
    vdup.32     q2, d4[0]
    vmla.f32    q9, q8, q2             // Eta*D + Sqrt(K)
    vmls.f32    q0, q9, q1             // (Eta * I) - ((Eta*D + Sqrt(K)) * N)
    vst1.32     {q0}, [r3]
    bx          lr

_set_null_vec4:
    veor.f32    q0, q0, q0
    vst1.32     {q0}, [r3]
    bx          lr
    
#endif // __LP64__