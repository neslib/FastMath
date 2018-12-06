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
     Res: Q-register that will be set to the result. Can be the same as A or B.
     ResLo, ResHi: d-register that matches the lower and upper register of Res
       (for example, if Res is set to Q3, then ResLo must be D6 and ResHi must
       be D7). The ResLo register will contain the eventual dot product (twice).
     A, B: the two vectors to calculate the dot product for (Q-registers).

   Modifies D31 */
.macro DOT3 Res ResLo ResHi A B
    vmul.f32    \Res, \A, \B           // (A.W*B.W) (A.Z*B.Z) (A.Y*B.Y) (A.X*B.X)
    vmov.i64    d31, 0x00000000FFFFFFFF
    vand.32     \ResHi, \ResHi, d31    // 0 (A.Z*B.Z) (A.Y*B.Y) (A.X*B.X)
    vpadd.f32   \ResLo, \ResLo, \ResHi // (A.Z*B.Z) (A.Y*B.Y)+(A.X*B.X)
    vpadd.f32   \ResLo, \ResLo, \ResLo // (A.Z*B.Z)+(A.Y*B.Y)+(A.X*B.X) (x2)
.endm

_neg_vector3: // (const A: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}
    vneg.f32    q0, q0
    fstmias     r1, {s0-s2}
    bx          lr

_vector3_add_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias     r0, {s0-s2}
    vdup.f32    q1, r1
    vadd.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_scalar_add_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    vdup.f32    q0, r0
    fldmias     r1, {s4-s6}
    vadd.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_add_vector3: // (const A, B: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}
    fldmias     r1, {s4-s6}
    vadd.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_sub_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias     r0, {s0-s2}
    vdup.f32    q1, r1
    vsub.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_scalar_sub_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    vdup.f32    q0, r0
    fldmias     r1, {s4-s6}
    vsub.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_sub_vector3: // (const A, B: TVector4; out Result: TVector4);
    fldmias     r0, {s0-s2}
    fldmias     r1, {s4-s6}
    vsub.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_mul_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias     r0, {s0-s2}
    vdup.f32    q1, r1
    vmul.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_scalar_mul_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    vdup.f32    q0, r0
    fldmias     r1, {s4-s6}
    vmul.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_mul_vector3: // (const A, B: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}
    fldmias     r1, {s4-s6}
    vmul.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_div_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    fldmias     r0, {s0-s2}
    vdup.f32    q1, r1
    RECIPQ_MED  q1, q1     // 1 / B
    vmul.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_scalar_div_vector3: // (const A: Single; const B: TVector3; out Result: TVector3);
    vdup.f32    q0, r0
    fldmias     r1, {s4-s6}
    RECIPQ_MED  q1, q1     // 1 / B
    vmul.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_div_vector3: // (const A, B: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}
    fldmias     r1, {s4-s6}
    RECIPQ_MED  q1, q1     // 1 / B
    vmul.f32    q0, q0, q1
    fstmias     r2, {s0-s2}
    bx          lr

_vector3_length: // (const A: TVector3): Single;
    fldmias     r0, {s0-s2}            // Z Y X
    DOT3        q0, d0, d1, q0, q0     // Dot(A, A)
    SQRTD_MED   d1, d0                 // Sqrt(Dot(A, A))
    vmov.f32    r0, s2
    bx          lr

_vector3_distance: // (const A, B: TVector3): Single;
    fldmias     r0, {s0-s2}   
    fldmias     r1, {s4-s6}   
    vsub.f32    q0, q0, q1             // C=A-B
    DOT3        q0, d0, d1, q0, q0     // Dot(C, C)
    SQRTD_MED   d1, d0                 // Sqrt(Dot(C, C))
    vmov.f32    r0, s2
    bx          lr

_vector3_distance_squared: // (const A, B: TVector3): Single;
    fldmias     r0, {s0-s2}   
    fldmias     r1, {s4-s6}   
    vsub.f32    q0, q0, q1             // C=A-B
    DOT3        q0, d0, d1, q0, q0     // Dot(C, C)
    vmov.f32    r0, s0
    bx          lr

_vector3_dot: // (const A, B: TVector3): Single;
    fldmias     r0, {s0-s2} // A.Z A.Y A.X  
    fldmias     r1, {s4-s6} // B.Z B.Y B.X  
    DOT3        q0, d0, d1, q0, q1
    vmov.f32    r0, s0
    bx          lr

_vector3_cross: // (const A, B: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}    // d1=A.W A.Z  d0=A.Y A.X
    fldmias     r1, {s4-s6}    // d3=B.W B.Z  d2=B.Y B.X
    vtrn.32     d2, d3         // d3=B.W B.Y  d2=B.Z B.X
    vrev64.32   d0, d0         //             d0=A.X A.Y
    vrev64.32   d2, d2         //             d2=B.X B.Z
    vtrn.32     d0, d1         // d1=A.W A.X  d0=A.Z A.Y
    vmul.f32    q2, q0, q1     // (A.W*B.W) (A.X*B.Y) (A.Z*B.X) (A.Y*B.Z)
    vtrn.32     d2, d3         // d3=B.W B.X  d2=B.Y B.Z
    vrev64.32   d0, d0         //             d0=A.Y A.Z
    vrev64.32   d2, d2         //             d2=B.Z B.Y
    vtrn.32     d0, d1         // d1=A.W A.Y  d0=A.X A.Z
    vmls.f32    q2, q0, q1     // # (A.X*B.Y)-(B.X*A.Y) (A.Z*B.X)-(B.Z*A.X) (A.Y*B.Z)-(B.Y*A.Z)
    fstmias     r2, {s8-s10}
    bx          lr

_vector3_normalize: // (const A: TVector3; out Result: TVector3);
    fldmias      r0, {s0-s2}            // Z Y X
    vmov         q8, q0
    DOT3         q0, d0, d1, q0, q0     // Dot(A, A)
    INVSQRTD_MED d1, d0                 // 1 / Sqrt(Dot(A, A))
    vmul.f32     d0, d16, d1            // A / Sqrt(Dot(A, A))
    vmul.f32     d1, d17, d1
    fstmias      r1, {s0-s2}
    bx           lr

_vector3_faceforward: // (const N, I, NRef: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}        // N
    fldmias     r1, {s4-s6}        // I
    fldmias     r2, {s8-s10}       // NRef

    DOT3        q2, d4, d5, q2, q1 // Dot(NRef, I)
    vneg.f32    q3, q0             // -N
    vclt.f32    q2, q2, #0         // (Dot(NRef, I) < 0)? Yes: $FFFFFFFF, No: $00000000
    vbsl.f32    q2, q0, q3         // (Dot(NRef, I) < 0)? Yes: N, No: -N
    fstmias     r3, {s8-s10}
    bx          lr

_vector3_reflect: // (const I, N: TVector3; out Result: TVector3);
    fldmias     r0, {s0-s2}            // I
    fldmias     r1, {s4-s6}            // N
    vmov        q2, q0                 // I
    vmov.f32    d6, #2.0               // 2
    DOT3        q0, d0, d1, q0, q1     // Dot(N, I) (2x)
    vmul.f32    d0, d0, d6             // (2*Dot(N, I)) (2x)
    vmls.f32    d4, d0, d2
    vmls.f32    d5, d0, d3             // I - ((2 * Dot(N, I)) * N);
    fstmias     r2, {s8-s10}
    bx          lr

_vector3_refract: // (const I, N: TVector3; const Eta: Single; out Result: TVector3);
    fldmias     r0, {s0-s2}            // I
    fldmias     r1, {s4-s6}            // N
    vdup.32     q8, r2                 // Eta
    DOT3        q2, d4, d5, q1, q0     // D := Dot(N, I)
    vmov.f32    d6, #1.0               // 1
    vmov        d7, d6                 // 1
    vmls.f32    d6, d4, d4             // 1-D*D
    vmul.f32    d6, d6, d16            // Eta*(1-D*D)
    vmls.f32    d7, d16, d6            // K := 1-Eta*Eta*(1-D*D)
    vcmp.f32    s14, #0                // if (K < 0) then Result.Init
    vmrs        APSR_nzcv, FPSCR
    blt         _set_null_vec3
    vmul.f32    q0, q0, q8             // Eta * I
    SQRTD_LOW   d6, d7                 // Sqrt(K)
    vdup.32     q9, d6[0]
    vdup.32     q2, d4[0]
    vmla.f32    q9, q8, q2             // Eta*D + Sqrt(K)
    vmls.f32    q0, q9, q1             // (Eta * I) - ((Eta*D + Sqrt(K)) * N)
    fstmias     r3, {s0-s2}
    bx          lr

_set_null_vec3:
    veor.f32    q0, q0, q0
    fstmias     r3, {s0-s2}
    bx          lr
    
#endif // __LP64__
