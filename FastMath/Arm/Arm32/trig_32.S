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
    .globl _radians_scalar, _radians_vector2, _radians_vector3, _radians_vector4
    .globl _degrees_scalar, _degrees_vector2, _degrees_vector3, _degrees_vector4

_radians_scalar: // (const ADegrees: Single): Single;
    adr         r2, PI_OVER_180
    vmov.f32    s0, r0
    vld1.32     {d1}, [r2]
    vmul.f32    d0, d0, d1
    vmov.f32    r0, s0
    bx          lr 
    
_radians_vector2: // (const ADegrees: TVector2; out Result: TVector2);
    adr         r2, PI_OVER_180
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r2]
    vmul.f32    d0, d0, d1
    vst1.32     {d0}, [r1]
    bx          lr 
    
_radians_vector3: // (const ADegrees: TVector3; out Result: TVector3);
    adr         r2, PI_OVER_180
    fldmias     r0, {s0-s2}
    vld1.32     {q1}, [r2]
    vmul.f32    q0, q0, q1
    fstmias     r1, {s0-s2}
    bx          lr 
    
_radians_vector4: // (const ADegrees: TVector4; out Result: TVector4);
    adr         r2, PI_OVER_180
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r2]
    vmul.f32    q0, q0, q1
    vst1.32     {q0}, [r1]
    bx          lr 
    
_degrees_scalar: // (const ADegrees: Single): Single;
    adr         r2, _180_OVER_PI
    vmov.f32    s0, r0
    vld1.32     {d1}, [r2]
    vmul.f32    d0, d0, d1
    vmov.f32    r0, s0
    bx          lr 
    
_degrees_vector2: // (const ARadians: TVector2; out Result: TVector2);
    adr         r2, _180_OVER_PI
    vld1.32     {d0}, [r0]
    vld1.32     {d1}, [r2]
    vmul.f32    d0, d0, d1
    vst1.32     {d0}, [r1]
    bx          lr 
    
_degrees_vector3: // (const ARadians: TVector3; out Result: TVector3);
    adr         r2, _180_OVER_PI
    fldmias     r0, {s0-s2}
    vld1.32     {q1}, [r2]
    vmul.f32    q0, q0, q1
    fstmias     r1, {s0-s2}
    bx          lr 
    
_degrees_vector4: // (const ARadians: TVector4; out Result: TVector4);
    adr         r2, _180_OVER_PI
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r2]
    vmul.f32    q0, q0, q1
    vst1.32     {q0}, [r1]
    bx          lr 

PI_OVER_180:
    .float 0.01745329251994329576923690768489,  0.01745329251994329576923690768489,  0.01745329251994329576923690768489,  0.01745329251994329576923690768489

_180_OVER_PI:
    .float 57.295779513082320876798154814105, 57.295779513082320876798154814105, 57.295779513082320876798154814105, 57.295779513082320876798154814105
        
#endif // __LP64__