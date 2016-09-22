#if __LP64__
    .text
    .align 4
    .include "../Arm64/macros_64.S"
    .globl _sqrt_scalar, _sqrt_vector2, _sqrt_vector3, _sqrt_vector4
    .globl _inverse_sqrt_scalar, _inverse_sqrt_vector2, _inverse_sqrt_vector3, _inverse_sqrt_vector4

_sqrt_scalar: // (const A: Single): Single;
    fsqrt       s0, s0
    ret

_sqrt_vector2: // (const A: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    fsqrt.2s    v0, v0
    st1.2s      {v0}, [x1]
    ret

_sqrt_vector3: // (const A: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    fsqrt.4s    v0, v0
    STORE3      v0, x1
    ret

_sqrt_vector4: // (const A: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    fsqrt.4s    v0, v0
    st1.4s      {v0}, [x1]
    ret

/* See macros_32.S for explaination of the inverse square root calculation */
_inverse_sqrt_scalar: // (const A: Single): Single;
    frsqrte     s1, s0     // X(0)=Approximate 1/Sqrt(A)
    fmul        s2, s1, s0 // A * X(0)
    frsqrts     s2, s2, s1 // (3 - A * X(0) * X(0)) / 2
    fmul        s0, s1, s2 // X(1) = X(0) * (3 - A * X(0) * X(0)) / 2
    ret

_inverse_sqrt_vector2: // (const A: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    frsqrte.2s  v1, v0     // X(0)=Approximate 1/Sqrt(A)
    fmul.2s     v2, v1, v0 // A * X(0)
    frsqrts.2s  v2, v2, v1 // (3 - A * X(0) * X(0)) / 2
    fmul.2s     v0, v1, v2 // X(1) = X(0) * (3 - A * X(0) * X(0)) / 2
    st1.2s      {v0}, [x1]
    ret

_inverse_sqrt_vector3: // (const A: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    frsqrte.4s  v1, v0     // X(0)=Approximate 1/Sqrt(A)
    fmul.4s     v2, v1, v0 // A * X(0)
    frsqrts.4s  v2, v2, v1 // (3 - A * X(0) * X(0)) / 2
    fmul.4s     v0, v1, v2 // X(1) = X(0) * (3 - A * X(0) * X(0)) / 2
    STORE3      v0, x1
    ret

_inverse_sqrt_vector4: // (const A: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    frsqrte.4s  v1, v0     // X(0)=Approximate 1/Sqrt(A)
    fmul.4s     v2, v1, v0 // A * X(0)
    frsqrts.4s  v2, v2, v1 // (3 - A * X(0) * X(0)) / 2
    fmul.4s     v0, v1, v2 // X(1) = X(0) * (3 - A * X(0) * X(0)) / 2
    st1.4s      {v0}, [x1]
    ret

#endif // __LP64__