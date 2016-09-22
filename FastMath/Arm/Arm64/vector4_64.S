#if __LP64__
    .text
    .align 4
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
     Res: register that will be set to the result. Can be the same as A or B.
     A, B: the two vectors to calculate the dot product for. */
.macro DOT4 Res A B
    fmul.4s     \Res, \A, \B           // (A.W*B.W) (A.Z*B.Z) (A.Y*B.Y) (A.X*B.X)
    faddp.4s    \Res, \Res, \Res       // (A.W*B.W)+(A.Z*B.Z) (A.Y*B.Y)+(A.X*B.X) (2x)
    faddp.4s    \Res, \Res, \Res       // (A.W*B.W)+(A.Z*B.Z)+(A.Y*B.Y)+(A.X*B.X) (4x)
.endm

_neg_vector4: // (const A: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    fneg.4s     v0, v0
    st1.4s      {v0}, [x1]
    ret

_vector4_add_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fadd.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_add_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fadd.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_vector4_add_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fadd.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_vector4_sub_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fsub.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_sub_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fsub.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_vector4_sub_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fsub.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_vector4_mul_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_mul_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_vector4_mul_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_vector4_div_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fdiv.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_scalar_div_vector4: // (const A: Single; const B: TVector4; out Result: TVector4);
    dup.4s      v0, v0[0]
    ld1.4s      {v1}, [x0]
    fdiv.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_vector4_div_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fdiv.4s     v0, v0, v1
    st1.4s      {v0}, [x2]
    ret

_vector4_length: // (const A: TVector4): Single;
    ld1.4s      {v0}, [x0]      // Y X
    DOT4        v0, v0, v0      // Dot(A, A)
    fsqrt.4s    v0, v0          // Sqrt(Dot(A, A))
    ret

_vector4_distance: // (const A, B: TVector4): Single;
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fsub.4s     v0, v0, v1      // C=A-B
    DOT4        v0, v0, v0      // Dot(C, C)
    fsqrt.4s    v0, v0          // Sqrt(Dot(C, C))
    ret

_vector4_distance_squared: // (const A, B: TVector4): Single;
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fsub.4s     v0, v0, v1      // C=A-B
    DOT4        v0, v0, v0      // Dot(C, C)
    ret

_vector4_dot: // (const A, B: TVector4): Single;
    ld1.4s      {v0}, [x0]      // A.Y A.X
    ld1.4s      {v1}, [x1]      // B.Y B.X
    DOT4        v0, v0, v1      // Dot(A, B)
    ret

_vector4_normalize: // (const A: TVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]     // Y X
    mov.4s       v1, v0
    DOT4         v0, v0, v0     // Dot(A, A)
    fsqrt.4s     v0, v0         // Sqrt(Dot(A, A))
    fdiv.4s      v0, v1, v0     // A / Sqrt(Dot(A, A))
    st1.4s       {v0}, [x1]
    ret

_vector4_faceforward: // (const N, I, NRef: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]     // N
    ld1.4s      {v1}, [x1]     // I
    ld1.4s      {v2}, [x2]     // NRef
    DOT4        v2, v2, v1     // Dot(NRef, I)
    fneg.4s     v3, v0         // -N
    fcmlt.4s    v2, v2, #0     // (Dot(NRef, I) < 0)? Yes: $FFFFFFFF, No: $00000000
    bsl.16b     v2, v0, v3     // (Dot(NRef, I) < 0)? Yes: N, No: -N
    st1.4s      {v2}, [x3]
    ret

_vector4_reflect: // (const I, N: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]     // I
    ld1.4s      {v1}, [x1]     // N
    mov.4s      v2, v0         // I
    fmov.4s     v3, #2.0       // 2
    DOT4        v0, v0, v1     // Dot(N, I) (2x)
    fmul.4s     v0, v0, v3     // (2*Dot(N, I)) (2x)
    fmls.4s     v2, v0, v1     // I - ((2 * Dot(N, I)) * N);
    st1.4s      {v2}, [x2]
    ret

_vector4_refract: // (const I, N: TVector4; const Eta: Single; out Result: TVector4);
    dup.4s      v4, v0[0]          // Eta
    ld1.4s      {v0}, [x0]         // I
    ld1.4s      {v1}, [x1]         // N
    DOT4        v5, v1, v0         // D := Dot(N, I)
    fmov.4s     v6, #1.0           // 1
    mov.4s      v7, v6             // 1
    fmls.4s     v6, v5, v5         // 1-D*D
    fmul.4s     v6, v6, v4         // Eta*(1-D*D)
    fmls.4s     v7, v4, v6         // K := 1-Eta*Eta*(1-D*D)
    fcmp        s7, #0.0           // if (K < 0) then Result.Init
    blt         _set_null_vec4
    fmul.4s     v0, v0, v4         // Eta * I
    fsqrt.4s    v2, v7             // Sqrt(K)
    fmla.4s     v2, v4, v5         // Eta*D + Sqrt(K)
    fmls.4s     v0, v2, v1         // (Eta * I) - ((Eta*D + Sqrt(K)) * N)
    st1.4s      {v0}, [x2]
    ret

_set_null_vec4:
    eor.16b     v0, v0, v0
    st1.4s      {v0}, [x2]
    ret

#endif // __LP64__