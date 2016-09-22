#if __LP64__
    .text
    .align 4
    .include "../Arm64/macros_64.S"
    .globl _neg_vector3
    .globl _vector3_add_scalar, _scalar_add_vector3, _vector3_add_vector3
    .globl _vector3_sub_scalar, _scalar_sub_vector3, _vector3_sub_vector3
    .globl _vector3_mul_scalar, _scalar_mul_vector3, _vector3_mul_vector3
    .globl _vector3_div_scalar, _scalar_div_vector3, _vector3_div_vector3
    .globl _vector3_length, _vector3_distance, _vector3_distance_squared
    .globl _vector3_dot, _vector3_cross, _vector3_normalize, _vector3_faceforward
    .globl _vector3_reflect, _vector3_refract

/* Calculates 3D dot product.

   Parameters:
     Res: register that will be set to the result. Can be the same as A or B.
     A, B: the two vectors to calculate the dot product for.

   Modifies V31 */
.macro DOT3 Res A B
    eor.16b     v31, v31, v31
    fmul.4s     \Res, \A, \B           // (A.W*B.W) (A.Z*B.Z) (A.Y*B.Y) (A.X*B.X)
    mov.s       \Res[3], v31[0]        // 0 (A.Z*B.Z) (A.Y*B.Y) (A.X*B.X)
    faddp.4s    \Res, \Res, \Res       // (A.Z*B.Z) (A.Y*B.Y)+(A.X*B.X) (2x)
    faddp.4s    \Res, \Res, \Res       // (A.Z*B.Z)+(A.Y*B.Y)+(A.X*B.X) (4x)
.endm

_neg_vector3: // (const A: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    fneg.4s     v0, v0
    STORE3      v0, x1
    ret

_vector3_add_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    dup.4s      v1, v0[0]
    LOAD3       v0, x0
    fadd.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_scalar_add_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    dup.4s      v0, v0[0]
    LOAD3       v1, x0
    fadd.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_vector3_add_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    LOAD3       v1, x1
    fadd.4s     v0, v0, v1
    STORE3      v0, x2
    ret

_vector3_sub_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    dup.4s      v1, v0[0]
    LOAD3       v0, x0
    fsub.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_scalar_sub_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    dup.4s      v0, v0[0]
    LOAD3       v1, x0
    fsub.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_vector3_sub_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    LOAD3       v1, x1
    fsub.4s     v0, v0, v1
    STORE3      v0, x2
    ret

_vector3_mul_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    dup.4s      v1, v0[0]
    LOAD3       v0, x0
    fmul.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_scalar_mul_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    dup.4s      v0, v0[0]
    LOAD3       v1, x0
    fmul.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_vector3_mul_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    LOAD3       v1, x1
    fmul.4s     v0, v0, v1
    STORE3      v0, x2
    ret

_vector3_div_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    dup.4s      v1, v0[0]
    LOAD3       v0, x0
    fdiv.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_scalar_div_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    dup.4s      v0, v0[0]
    LOAD3       v1, x0
    fdiv.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_vector3_div_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    LOAD3       v1, x1
    fdiv.4s     v0, v0, v1
    STORE3      v0, x2
    ret

_vector3_length: // (const A: TVector3): Single;
    LOAD3       v0, x0          // Z Y X
    DOT3        v0, v0, v0      // Dot(A, A)
    fsqrt.4s    v0, v0          // Sqrt(Dot(A, A))
    ret

_vector3_distance: // (const A, B: TVector3): Single;
    LOAD3       v0, x0
    LOAD3       v1, x1
    fsub.4s     v0, v0, v1      // C=A-B
    DOT3        v0, v0, v0      // Dot(C, C)
    fsqrt.4s    v0, v0          // Sqrt(Dot(C, C))
    ret

_vector3_distance_squared: // (const A, B: TVector3): Single;
    LOAD3       v0, x0
    LOAD3       v1, x1
    fsub.4s     v0, v0, v1      // C=A-B
    DOT3        v0, v0, v0      // Dot(C, C)
    ret

_vector3_dot: // (const A, B: TVector3): Single;
    LOAD3       v0, x0
    LOAD3       v1, x1
    DOT3        v0, v0, v1      // Dot(A, B)
    ret

XYZ_TO_YZX:
    .byte 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 12, 13, 14, 15
XYZ_TO_ZXY:
    .byte 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 12, 13, 14, 15

_vector3_cross: // (const A, B: TVector3; out Result: TVector3);
    adr         x3, XYZ_TO_YZX
    LOAD3       v0, x0          // A.W A.Z A.Y A.X
    LOAD3       v1, x1          // B.W B.Z B.Y B.X
    ld1.4s      {v2-v3}, [x3]   // Lookup tables

    tbl.16b     v4, {v0}, v2    // A.W A.X A.Z A.Y
    tbl.16b     v5, {v0}, v3    // A.W A.Y A.X A.Z
    tbl.16b     v6, {v1}, v2    // B.W B.X B.Z B.Y
    tbl.16b     v7, {v1}, v3    // B.W B.Y B.X B.Z

    fmul.4s     v0, v4, v7      // # (A.X*B.Y) (A.Z*B.X) (A.Y*B.Z)
    fmls.4s     v0, v5, v6      // # (A.X*B.Y)-(B.X*A.Y) (A.Z*B.X)-(B.Z*A.X) (A.Y*B.Z)-(B.Y*A.Z)

    STORE3      v0, x2
    ret

_vector3_normalize: // (const A: TVector3; out Result: TVector3);
    LOAD3        v0, x0         // Z Y X
    mov.4s       v1, v0
    DOT3         v0, v0, v0     // Dot(A, A)
    fsqrt.4s     v0, v0         // Sqrt(Dot(A, A))
    fdiv.4s      v0, v1, v0     // A / Sqrt(Dot(A, A))
    STORE3       v0, x1
    ret

_vector3_faceforward: // (const N, I, NRef: TVector3; out Result: TVector3);
    LOAD3       v0, x0         // N
    LOAD3       v1, x1         // I
    LOAD3       v2, x2         // NRef
    DOT3        v2, v2, v1     // Dot(NRef, I)
    fneg.4s     v3, v0         // -N
    fcmlt.4s    v2, v2, #0     // (Dot(NRef, I) < 0)? Yes: $FFFFFFFF, No: $00000000
    bsl.16b     v2, v0, v3     // (Dot(NRef, I) < 0)? Yes: N, No: -N
    STORE3      v2, x3
    ret

_vector3_reflect: // (const I, N: TVector3; out Result: TVector3);
    LOAD3       v0, x0         // I
    LOAD3       v1, x1         // N
    mov.4s      v2, v0         // I
    fmov.4s     v3, #2.0       // 2
    DOT3        v0, v0, v1     // Dot(N, I) (2x)
    fmul.4s     v0, v0, v3     // (2*Dot(N, I)) (2x)
    fmls.4s     v2, v0, v1     // I - ((2 * Dot(N, I)) * N);
    STORE3      v2, x2
    ret

_vector3_refract: // (const I, N: TVector3; const Eta: Single; out Result: TVector3);
    dup.4s      v4, v0[0]          // Eta
    LOAD3       v0, x0             // I
    LOAD3       v1, x1             // N
    DOT3        v5, v1, v0         // D := Dot(N, I)
    fmov.4s     v6, #1.0           // 1
    mov.4s      v7, v6             // 1
    fmls.4s     v6, v5, v5         // 1-D*D
    fmul.4s     v6, v6, v4         // Eta*(1-D*D)
    fmls.4s     v7, v4, v6         // K := 1-Eta*Eta*(1-D*D)
    fcmp        s7, #0.0           // if (K < 0) then Result.Init
    blt         _set_null_vec3
    fmul.4s     v0, v0, v4         // Eta * I
    fsqrt.4s    v2, v7             // Sqrt(K)
    fmla.4s     v2, v4, v5         // Eta*D + Sqrt(K)
    fmls.4s     v0, v2, v1         // (Eta * I) - ((Eta*D + Sqrt(K)) * N)
    STORE3      v0, x2
    ret

_set_null_vec3:
    eor.16b     v0, v0, v0
    STORE3      v0, x2
    ret

#endif // __LP64__
