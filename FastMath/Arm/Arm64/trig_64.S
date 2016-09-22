#if __LP64__
    .text
    .align 4
    .include "../Arm64/macros_64.S"
    .globl _radians_scalar, _radians_vector2, _radians_vector3, _radians_vector4
    .globl _degrees_scalar, _degrees_vector2, _degrees_vector3, _degrees_vector4

PI_OVER_180:
    .float 0.01745329251994329576923690768489,  0.01745329251994329576923690768489,  0.01745329251994329576923690768489,  0.01745329251994329576923690768489

_180_OVER_PI:
    .float 57.295779513082320876798154814105, 57.295779513082320876798154814105, 57.295779513082320876798154814105, 57.295779513082320876798154814105
    
_radians_scalar: // (const ADegrees: Single): Single;
    adr         x8, PI_OVER_180
    ldr         s1, [x8]
    fmul        s0, s0, s1
    ret

_radians_vector2: // (const ADegrees: TVector2; out Result: TVector2);
    adr         x8, PI_OVER_180
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x8]
    fmul.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_radians_vector3: // (const ADegrees: TVector3; out Result: TVector3);
    adr         x8, PI_OVER_180
    LOAD3       v0, x0
    ld1.4s      {v1}, [x8]
    fmul.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_radians_vector4: // (const ADegrees: TVector4; out Result: TVector4);
    adr         x8, PI_OVER_180
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x8]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret

_degrees_scalar: // (const ADegrees: Single): Single;
    adr         x8, _180_OVER_PI
    ldr         s1, [x8]
    fmul        s0, s0, s1
    ret

_degrees_vector2: // (const ARadians: TVector2; out Result: TVector2);
    adr         x8, _180_OVER_PI
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x8]
    fmul.2s     v0, v0, v1
    st1.2s      {v0}, [x1]
    ret

_degrees_vector3: // (const ARadians: TVector3; out Result: TVector3);
    adr         x8, _180_OVER_PI
    LOAD3       v0, x0
    ld1.4s      {v1}, [x8]
    fmul.4s     v0, v0, v1
    STORE3      v0, x1
    ret

_degrees_vector4: // (const ARadians: TVector4; out Result: TVector4);
    adr         x8, _180_OVER_PI
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x8]
    fmul.4s     v0, v0, v1
    st1.4s      {v0}, [x1]
    ret
#endif // __LP64__