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
    .globl _vector2_add_scalar, _scalar_add_vector2, _vector2_add_vector2
    .globl _vector2_sub_scalar, _scalar_sub_vector2, _vector2_sub_vector2
    .globl _vector2_mul_scalar, _scalar_mul_vector2, _vector2_mul_vector2
    .globl _vector2_div_scalar, _scalar_div_vector2, _vector2_div_vector2
    .globl _vector2_length, _vector2_distance, _vector2_distance_squared
    .globl _vector2_dot, _vector2_normalize, _vector2_faceforward
    .globl _vector2_reflect, _vector2_refract

/* Calculates 2D dot product.

   Parameters:
     Res: D-register that will be set to the result. Can be the same as A or B.
     A, B: the two vectors to calculate the dot product for (D-registers). */
.macro DOT2 Res A B
    vmul.f32    \Res, \A, \B     // (A.Y*B.Y) (A.X*B.X)
    vpadd.f32   \Res, \Res, \Res // (A.Y*B.Y)+(A.X*B.X) (2x)
.endm
    
//_neg_vector2: // (const A: TVector2; out Result: TVector2);
//    vld1.32     {d0}, [r0]
//    vneg.f32    d0, d0
//    vst1.f32    {d0}, [r1]
//    bx          lr

_vector2_add_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vdup.f32    d1, r1
    vadd.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_scalar_add_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    vdup.f32    d0, r0
    vld1.32     {d1}, [r1]
    vadd.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_add_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r1]
    vadd.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_sub_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vdup.f32    d1, r1
    vsub.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_scalar_sub_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    vdup.f32    d0, r0
    vld1.32     {d1}, [r1]
    vsub.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_sub_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r1]
    vsub.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_mul_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vdup.f32    d1, r1
    vmul.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_scalar_mul_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    vdup.f32    d0, r0
    vld1.32     {d1}, [r1]
    vmul.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_mul_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r1]
    vmul.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_div_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vdup.f32    d1, r1
    RECIPD_MED  d1, d1     // 1 / B
    vmul.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_scalar_div_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    vdup.f32    d0, r0
    vld1.32     {d1}, [r1]
    RECIPD_MED  d1, d1     // 1 / B
    vmul.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_div_vector2: // (const A, B: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r1]
    RECIPD_MED  d1, d1     // 1 / B
    vmul.f32    d0, d0, d1
    vst1.f32    {d0}, [r2]
    bx          lr

_vector2_length: // (const A: TVector2): Single;
    vld1.32     {d0}, [r0]         // Y X
    DOT2        d0, d0, d0         // Dot(A, A)
    SQRTD_MED   d1, d0             // Sqrt(Dot(A, A))
    vmov.f32    r0, s2
    bx          lr

_vector2_distance: // (const A, B: TVector2): Single;
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r1]
    vsub.f32    d0, d0, d1         // C=A-B
    DOT2        d0, d0, d0         // Dot(C, C)
    SQRTD_MED   d1, d0             // Sqrt(Dot(C, C))
    vmov.f32    r0, s2
    bx          lr

_vector2_distance_squared: // (const A, B: TVector2): Single;
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r1]
    vsub.f32    d0, d0, d1         // C=A-B
    DOT2        d0, d0, d0         // Dot(C, C)
    vmov.f32    r0, s0
    bx          lr

_vector2_dot: // (const A, B: TVector2): Single;
    vld1.32     {d0}, [r0]  // A.Y A.X
    vld1.32     {d1}, [r1]  // B.Y B.X
    DOT2        d0, d0, d1  // Dot(A, B)
    vmov.f32    r0, s0
    bx          lr

_vector2_normalize: // (const A: TVector2; out Result: TVector2);
    vld1.32      {d0}, [r0]     // Y X
    vmov         d16, d0
    DOT2         d0, d0, d0     // Dot(A, A)
    INVSQRTD_MED d1, d0         // 1 / Sqrt(Dot(A, A))
    vmul.f32     d0, d16, d1    // A / Sqrt(Dot(A, A))
    vst1.32      {d0}, [r1]
    bx           lr

_vector2_faceforward: // (const N, I, NRef: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]     // N
    vld1.32     {d1}, [r1]     // I
    vld1.32     {d2}, [r2]     // NRef

    DOT2        d2, d2, d1     // Dot(NRef, I)
    vneg.f32    d3, d0         // -N
    vclt.f32    d2, d2, #0     // (Dot(NRef, I) < 0)? Yes: $FFFFFFFF, No: $00000000
    vbsl.f32    d2, d0, d3     // (Dot(NRef, I) < 0)? Yes: N, No: -N
    vst1.32     {d2}, [r3]

    bx          lr

_vector2_reflect: // (const I, N: TVector2; out Result: TVector2);
    vld1.32     {d0}, [r0]  // I
    vld1.32     {d1}, [r1]  // N
    vmov        d2, d0      // I
    vmov.f32    d3, #2.0    // 2
    DOT2        d0, d0, d1  // Dot(N, I) (2x)
    vmul.f32    d0, d0, d3  // (2*Dot(N, I)) (2x)
    vmls.f32    d2, d0, d1  // I - ((2 * Dot(N, I)) * N);
    vst1.32     {d2}, [r2]
    bx          lr

_vector2_refract: // (const I, N: TVector2; const Eta: Single; out Result: TVector2);
    vld1.32     {d0}, [r0]         // I
    vld1.32     {d1}, [r1]         // N
    vdup.32     d4, r2             // Eta
    DOT2        d5, d1, d0         // D := Dot(N, I)
    vmov.f32    d6, #1.0           // 1
    vmov        d7, d6             // 1
    vmls.f32    d6, d5, d5         // 1-D*D
    vmul.f32    d6, d6, d4         // Eta*(1-D*D)
    vmls.f32    d7, d4, d6         // K := 1-Eta*Eta*(1-D*D)
    vcmp.f32    s14, #0            // if (K < 0) then Result.Init
    vmrs        APSR_nzcv, FPSCR
    blt         _set_null_vec2
    vmul.f32    d0, d0, d4         // Eta * I
    SQRTD_LOW   d2, d7             // Sqrt(K)
    vmla.f32    d2, d4, d5         // Eta*D + Sqrt(K)
    vmls.f32    d0, d2, d1         // (Eta * I) - ((Eta*D + Sqrt(K)) * N)
    vst1.32     {d0}, [r3]
    bx          lr

_set_null_vec2:
    veor.f32    d0, d0, d0
    vst1.32     {d0}, [r3]
    bx          lr

#endif // __LP64__