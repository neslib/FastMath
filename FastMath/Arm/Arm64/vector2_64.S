#if __LP64__
    .text
    .align 4
    .globl _vector2_add_scalar, _scalar_add_vector2, _vector2_add_vector2
    .globl _vector2_sub_scalar, _scalar_sub_vector2, _vector2_sub_vector2
    .globl _vector2_mul_scalar, _scalar_mul_vector2, _vector2_mul_vector2
    .globl _vector2_div_scalar, _scalar_div_vector2, _vector2_div_vector2
    .globl _vector2_length, _vector2_distance, _vector2_distance_squared
    .globl _vector2_dot, _vector2_normalize, _vector2_faceforward
    .globl _vector2_reflect, _vector2_refract

/* Calculates 2D dot product.

   Parameters:
     Res: Register that will be set to the result. Can be the same as A or B.
     A, B: the two vectors to calculate the dot product for. */
.macro DOT2 Res A B
    fmul.2s     \Res, \A, \B     // (A.Y*B.Y) (A.X*B.X)
    faddp.2s    \Res, \Res, \Res // (A.Y*B.Y)+(A.X*B.X) (2x)
.endm

_vector2_add_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s      v1, v0[0]
    ld1.2s      {v0}, [x0]
    fadd.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_scalar_add_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    dup.2s      v0, v0[0]
    ld1.2s      {v1}, [x0]
    fadd.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_vector2_add_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fadd.2s     v0, v0, v1
    st1.2s      {v0}, [x2]
    ret

_vector2_sub_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s      v1, v0[0]
    ld1.2s      {v0}, [x0]
    fsub.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_scalar_sub_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    dup.2s      v0, v0[0]
    ld1.2s      {v1}, [x0]
    fsub.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_vector2_sub_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fsub.2s     v0, v0, v1
    st1.2s      {v0}, [x2]
    ret

_vector2_mul_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s      v1, v0[0]
    ld1.2s      {v0}, [x0]
    fmul.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_scalar_mul_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    dup.2s      v0, v0[0]
    ld1.2s      {v1}, [x0]
    fmul.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_vector2_mul_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fmul.2s     v0, v0, v1
    st1.2s      {v0}, [x2]
    ret

_vector2_div_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s      v1, v0[0]
    ld1.2s      {v0}, [x0]
    fdiv.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_scalar_div_vector2: // (const A: Single; const B: TVector2; out Result: TVector2);
    dup.2s      v0, v0[0]
    ld1.2s      {v1}, [x0]
    fdiv.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_vector2_div_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fdiv.2s     v0, v0, v1
    st1.2s      {v0}, [x2]
    ret

_vector2_length: // (const A: TVector2): Single;
    ld1.2s      {v0}, [x0]      // Y X
    DOT2        v0, v0, v0      // Dot(A, A)
    fsqrt.2s    v0, v0          // Sqrt(Dot(A, A))
    ret

_vector2_distance: // (const A, B: TVector2): Single;
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fsub.2s     v0, v0, v1      // C=A-B
    DOT2        v0, v0, v0      // Dot(C, C)
    fsqrt.2s    v0, v0          // Sqrt(Dot(C, C))
    ret

_vector2_distance_squared: // (const A, B: TVector2): Single;
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fsub.2s     v0, v0, v1      // C=A-B
    DOT2        v0, v0, v0      // Dot(C, C)
    ret

_vector2_dot: // (const A, B: TVector2): Single;
    ld1.2s      {v0}, [x0]      // A.Y A.X
    ld1.2s      {v1}, [x1]      // B.Y B.X
    DOT2        v0, v0, v1      // Dot(A, B)
    ret

_vector2_normalize: // (const A: TVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]     // Y X
    mov.2s       v1, v0
    DOT2         v0, v0, v0     // Dot(A, A)
    fsqrt.2s     v0, v0         // Sqrt(Dot(A, A))
    fdiv.2s      v0, v1, v0     // A / Sqrt(Dot(A, A))
    st1.2s       {v0}, [x1]
    ret

_vector2_faceforward: // (const N, I, NRef: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]     // N
    ld1.2s      {v1}, [x1]     // I
    ld1.2s      {v2}, [x2]     // NRef
    DOT2        v2, v2, v1     // Dot(NRef, I)
    fneg.2s     v3, v0         // -N
    fcmlt.2s    v2, v2, #0     // (Dot(NRef, I) < 0)? Yes: $FFFFFFFF, No: $00000000
    bsl.8b      v2, v0, v3     // (Dot(NRef, I) < 0)? Yes: N, No: -N
    st1.2s      {v2}, [x3]
    ret

_vector2_reflect: // (const I, N: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]     // I
    ld1.2s      {v1}, [x1]     // N
    mov.2s      v2, v0         // I
    fmov.2s     v3, #2.0       // 2
    DOT2        v0, v0, v1     // Dot(N, I) (2x)
    fmul.2s     v0, v0, v3     // (2*Dot(N, I)) (2x)
    fmls.2s     v2, v0, v1     // I - ((2 * Dot(N, I)) * N);
    st1.2s      {v2}, [x2]
    ret

_vector2_refract: // (const I, N: TVector2; const Eta: Single; out Result: TVector2);
    dup.2s      v4, v0[0]          // Eta
    ld1.2s      {v0}, [x0]         // I
    ld1.2s      {v1}, [x1]         // N
    DOT2        v5, v1, v0         // D := Dot(N, I)
    fmov.2s     v6, #1.0           // 1
    mov.2s      v7, v6             // 1
    fmls.2s     v6, v5, v5         // 1-D*D
    fmul.2s     v6, v6, v4         // Eta*(1-D*D)
    fmls.2s     v7, v4, v6         // K := 1-Eta*Eta*(1-D*D)
    fcmp        s7, #0.0           // if (K < 0) then Result.Init
    blt         _set_null_vec2
    fmul.2s     v0, v0, v4         // Eta * I
    fsqrt.2s    v2, v7             // Sqrt(K)
    fmla.2s     v2, v4, v5         // Eta*D + Sqrt(K)
    fmls.2s     v0, v2, v1         // (Eta * I) - ((Eta*D + Sqrt(K)) * N)
    st1.2s      {v0}, [x2]
    ret

_set_null_vec2:
    eor.8b      v0, v0, v0
    st1.2s      {v0}, [x2]
    ret

#endif // __LP64__