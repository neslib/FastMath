#if __LP64__
    .text
    .align 4
    .include "../Arm64/macros_64.S"
    .globl _abs_scalar, _abs_vector2, _abs_vector3, _abs_vector4
    .globl _sign_scalar, _sign_vector2, _sign_vector3, _sign_vector4
    .globl _floor_scalar, _floor_vector2, _floor_vector3, _floor_vector4
    .globl _trunc_scalar, _trunc_vector2, _trunc_vector3, _trunc_vector4
    .globl _round_scalar, _round_vector2, _round_vector3, _round_vector4
    .globl _ceil_scalar, _ceil_vector2, _ceil_vector3, _ceil_vector4
    .globl _frac_scalar, _frac_vector2, _frac_vector3, _frac_vector4
    .globl _fmod_scalar, _fmod_vector2, _fmod_vector2_scalar, _fmod_vector4, _fmod_vector4_scalar, _fmod_vector3, _fmod_vector3_scalar
    .globl _modf_scalar, _modf_vector2, _modf_vector3, _modf_vector4
    .globl _min_vector2, _min_vector2_scalar, _min_vector3, _min_vector3_scalar, _min_vector4, _min_vector4_scalar
    .globl _max_vector2, _max_vector2_scalar, _max_vector3, _max_vector3_scalar, _max_vector4, _max_vector4_scalar
    .globl _ensure_range_scalar, _ensure_range_vector2, _ensure_range_vector2_scalar, _ensure_range_vector3, _ensure_range_vector3_scalar, _ensure_range_vector4, _ensure_range_vector4_scalar
    .globl _mix_vector2, _mix_vector2_scalar, _mix_vector3, _mix_vector3_scalar, _mix_vector4, _mix_vector4_scalar
    .globl _step_vector2, _step_scalar_vector2, _step_vector3, _step_scalar_vector3, _step_vector4, _step_scalar_vector4
    .globl _smoothstep_vector2, _smoothstep_scalar_vector2, _smoothstep_vector3, _smoothstep_scalar_vector3, _smoothstep_vector4, _smoothstep_scalar_vector4
    .globl _fma_vector2, _fma_vector3, _fma_vector4

_abs_scalar: // (const A: Single): Single;
    fabs        s0, s0
    ret

_abs_vector2: // (const A: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    fabs.2s     v0, v0
    st1.2s      {v0}, [x1]
    ret

_abs_vector3: // (const A: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    fabs.4s     v0, v0
    STORE3      v0, x1
    ret
    
_abs_vector4: // (const A: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    fabs.4s     v0, v0
    st1.4s      {v0}, [x1]
    ret

ONE_D:
    .float 1.0, 1.0
    .int 0x80000000, 0x80000000 // sign bit

ONE_Q:
    .float 1.0, 1.0, 1.0, 1.0
    .int 0x80000000, 0x80000000, 0x80000000, 0x80000000

_sign_scalar: // (const A: Single): Single;
    adr         x2, ONE_D
    ld1.2s      {v1-v2}, [x2]
    and.8b      v3, v0, v2 // (A < 0)? Yes: $80000000, No: $00000000
    orr.8b      v3, v3, v1 // (A < 0)? Yes: -1.0, No: 1.0
    fcmeq.2s    v0, v0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    bic.8b      v0, v3, v0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    ret

_sign_vector2: // (const A: TVector2; out Result: TVector2);
    adr         x2, ONE_D
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1-v2}, [x2]
    and.8b      v3, v0, v2 // (A < 0)? Yes: $80000000, No: $00000000
    orr.8b      v3, v3, v1 // (A < 0)? Yes: -1.0, No: 1.0
    fcmeq.2s    v0, v0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    bic.8b      v0, v3, v0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    st1.2s      {v0}, [x1]
    ret

_sign_vector3: // (const A: TVector3; out Result: TVector3);
    adr         x2, ONE_Q
    LOAD3       v0, x0
    ld1.4s      {v1-v2}, [x2]
    and.16b     v3, v0, v2 // (A < 0)? Yes: $80000000, No: $00000000
    orr.16b     v3, v3, v1 // (A < 0)? Yes: -1.0, No: 1.0
    fcmeq.4s    v0, v0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    bic.16b     v0, v3, v0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    STORE3      v0, x1
    ret

_sign_vector4: // (const A: TVector4; out Result: TVector4);
    adr         x2, ONE_Q
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1-v2}, [x2]
    and.16b     v3, v0, v2 // (A < 0)? Yes: $80000000, No: $00000000
    orr.16b     v3, v3, v1 // (A < 0)? Yes: -1.0, No: 1.0
    fcmeq.4s    v0, v0, #0 // (A = 0)? Yes: $FFFFFFFF, No: $00000000
    bic.16b     v0, v3, v0 // (A = 0)? Yes: 0, No: -1.0 or 1.0
    st1.4s      {v0}, [x1]
    ret

_floor_scalar: // (const A: Single): Integer;
    fcvtms      s0, s0     // Floor(A) (as int)
    fmov        w0, s0
    ret

_floor_vector2: // (const A: TVector2; out Result: TIVector2);
    ld1.2s      {v0}, [x0]
    fcvtms.2s   v0, v0     // Floor(A) (as int)
    st1.2s      {v0}, [x1]
    ret

_floor_vector3: // (const A: TVector3; out Result: TIVector3);
    LOAD3       v0, x0
    fcvtms.4s   v0, v0     // Floor(A) (as int)
    STORE3      v0, x1
    ret

_floor_vector4: // (const A: TVector4; out Result: TIVector4);
    ld1.4s      {v0}, [x0]
    fcvtms.4s   v0, v0     // Floor(A) (as int)
    st1.4s      {v0}, [x1]
    ret

_trunc_scalar: // (const A: Single): Integer;
    fcvtzs      s0, s0     // Trunc(A) (as int)
    fmov        w0, s0
    ret

_trunc_vector2: // (const A: TVector2; out Result: TIVector2);
    ld1.2s      {v0}, [x0]
    fcvtzs.2s   v0, v0     // Trunc(A) (as int)
    st1.2s      {v0}, [x1]
    ret

_trunc_vector3: // (const A: TVector3; out Result: TIVector3);
    LOAD3       v0, x0
    fcvtzs.4s   v0, v0     // Trunc(A) (as int)
    STORE3      v0, x1
    ret

_trunc_vector4: // (const A: TVector4; out Result: TIVector4);
    ld1.4s      {v0}, [x0]
    fcvtzs.4s   v0, v0     // Trunc(A) (as int)
    st1.4s      {v0}, [x1]
    ret

_round_scalar: // (const A: Single): Integer;
    fcvtns      s0, s0     // Round(A) (as int)
    fmov        w0, s0
    ret

_round_vector2: // (const A: TVector2; out Result: TIVector2);
    ld1.2s      {v0}, [x0]
    fcvtns.2s   v0, v0     // Round(A) (as int)
    st1.2s      {v0}, [x1]
    ret

_round_vector3: // (const A: TVector3; out Result: TIVector3);
    LOAD3       v0, x0
    fcvtns.4s   v0, v0     // Round(A) (as int)
    STORE3      v0, x1
    ret

_round_vector4: // (const A: TVector4; out Result: TIVector4);
    ld1.4s      {v0}, [x0]
    fcvtns.4s   v0, v0     // Round(A) (as int)
    st1.4s      {v0}, [x1]
    ret

_ceil_scalar: // (const A: Single): Integer;
    fcvtps      s0, s0     // Ceil(A) (as int)
    fmov        w0, s0
    ret

_ceil_vector2: // (const A: TVector2; out Result: TIVector2);
    ld1.2s      {v0}, [x0]
    fcvtps.2s   v0, v0     // Ceil(A) (as int)
    st1.2s      {v0}, [x1]
    ret

_ceil_vector3: // (const A: TVector3; out Result: TIVector3);
    LOAD3       v0, x0
    fcvtps.4s   v0, v0     // Ceil(A) (as int)
    STORE3      v0, x1
    ret

_ceil_vector4: // (const A: TVector4; out Result: TIVector4);
    ld1.4s      {v0}, [x0]
    fcvtps.4s   v0, v0     // Ceil(A) (as int)
    st1.4s      {v0}, [x1]
    ret

_frac_scalar: // (const A: Single): Single;
    fcvtzs      s1, s0     // Trunc(A) (as int)
    scvtf       s1, s1     // Trunc(A) (as float)
    fsub        s0, s0, s1 // A - Trunc(A)
    ret

_frac_vector2: // (const A: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    fcvtzs.2s   v1, v0     // Trunc(A) (as int)
    scvtf.2s    v1, v1     // Trunc(A) (as float)
    fsub.2s     v0, v0, v1 // A - Trunc(A)
    st1.2s      {v0}, [x1]
    ret

_frac_vector3: // (const A: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    fcvtzs.4s   v1, v0     // Trunc(A) (as int)
    scvtf.4s    v1, v1     // Trunc(A) (as float)
    fsub.4s     v0, v0, v1 // A - Trunc(A)
    STORE3      v0, x1
    ret

_frac_vector4: // (const A: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    fcvtzs.4s   v1, v0     // Trunc(A) (as int)
    scvtf.4s    v1, v1     // Trunc(A) (as float)
    fsub.4s     v0, v0, v1 // A - Trunc(A)
    st1.4s      {v0}, [x1]
    ret

_fmod_scalar: // (const A, B: Single): Single;
    fdiv        s2, s0, s1     // A / B
    fcvtzs      s2, s2         // Trunc(A / B) (as int)
    scvtf       s2, s2         // Trunc(A / B) (as float)
    fmsub       s0, s1, s2, s0 // A - (B * Trunc(A / B))
    ret

_fmod_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s      {v0}, [x0]
    ld1.2s      {v1}, [x1]
    fdiv.2s     v2, v0, v1 // A / B
    fcvtzs.2s   v2, v2     // Trunc(A / B) (as int)
    scvtf.2s    v2, v2     // Trunc(A / B) (as float)
    fmls.2s     v0, v1, v2 // A - (B * Trunc(A / B))
    st1.2s      {v0}, [x2]
    ret

_fmod_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3       v0, x0
    LOAD3       v1, x1
    fdiv.4s     v2, v0, v1 // A / B
    fcvtzs.4s   v2, v2     // Trunc(A / B) (as int)
    scvtf.4s    v2, v2     // Trunc(A / B) (as float)
    fmls.4s     v0, v1, v2 // A - (B * Trunc(A / B))
    STORE3      v0, x2
    ret

_fmod_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s      {v0}, [x0]
    ld1.4s      {v1}, [x1]
    fdiv.4s     v2, v0, v1 // A / B
    fcvtzs.4s   v2, v2     // Trunc(A / B) (as int)
    scvtf.4s    v2, v2     // Trunc(A / B) (as float)
    fmls.4s     v0, v1, v2 // A - (B * Trunc(A / B))
    st1.4s      {v0}, [x2]
    ret

_fmod_vector2_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s      v1, v0[0]
    ld1.2s      {v0}, [x0]
    fdiv.2s     v2, v0, v1 // A / B
    fcvtzs.2s   v2, v2     // Trunc(A / B) (as int)
    scvtf.2s    v2, v2     // Trunc(A / B) (as float)
    fmls.2s     v0, v1, v2 // A - (B * Trunc(A / B))
    st1.2s      {v0}, [x1]
    ret

_fmod_vector3_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);   
    dup.4s      v1, v0[0]
    LOAD3       v0, x0
    fdiv.4s     v2, v0, v1 // A / B
    fcvtzs.4s   v2, v2     // Trunc(A / B) (as int)
    scvtf.4s    v2, v2     // Trunc(A / B) (as float)
    fmls.4s     v0, v1, v2 // A - (B * Trunc(A / B))
    STORE3      v0, x1
    ret

_fmod_vector4_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s      v1, v0[0]
    ld1.4s      {v0}, [x0]
    fdiv.4s     v2, v0, v1 // A / B
    fcvtzs.4s   v2, v2     // Trunc(A / B) (as int)
    scvtf.4s    v2, v2     // Trunc(A / B) (as float)
    fmls.4s     v0, v1, v2 // A - (B * Trunc(A / B))
    st1.4s      {v0}, [x1]
    ret

_modf_scalar: // (const A: Single; out B: Integer): Single;
    fcvtzs       s1, s0        // Trunc(A) (as int)
    scvtf        s2, s1        // Trunc(A) (as float)
    fsub         s0, s0, s2    // Frac=A-Trunc(A)
    str          s1, [x0]      // B := Trunc(A)
    fmov         w0, s0
    ret

_modf_vector2: // (const A: TVector2; out B: TIVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]
    fcvtzs.2s    v1, v0        // Trunc(A) (as int)
    scvtf.2s     v2, v1        // Trunc(A) (as float)
    fsub.2s      v0, v0, v2    // Frac=A-Trunc(A)
    st1.2s       {v1}, [x1]    // B := Trunc(A)
    st1.2s       {v0}, [x2]    // Result := Frac(A)
    ret

_modf_vector3: // (const A: TVector3; out B: TIVector3; out Result: TVector3);
    LOAD3        v0, x0
    fcvtzs.4s    v1, v0        // Trunc(A) (as int)
    scvtf.4s     v2, v1        // Trunc(A) (as float)
    fsub.4s      v0, v0, v2    // Frac=A-Trunc(A)
    STORE3       v1, x1        // B := Trunc(A)
    STORE3       v0, x2        // Result := Frac(A)
    ret

_modf_vector4: // (const A: TVector4; out B: TIVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]
    fcvtzs.4s    v1, v0        // Trunc(A) (as int)
    scvtf.4s     v2, v1        // Trunc(A) (as float)
    fsub.4s      v0, v0, v2    // Frac=A-Trunc(A)
    st1.4s       {v1}, [x1]    // B := Trunc(A)
    st1.4s       {v0}, [x2]    // Result := Frac(A)
    ret

_min_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    fmin.2s      v0, v0, v1
    st1.2s       {v0}, [x2]
    ret

_min_vector2_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s       v1, v0[0]
    ld1.2s       {v0}, [x0]
    fmin.2s      v0, v0, v1
    st1.2s       {v0}, [x1]
    ret

_min_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3        v0, x0
    LOAD3        v1, x1
    fmin.4s      v0, v0, v1
    STORE3       v0, x2
    ret

_min_vector3_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    dup.4s       v1, v0[0]
    LOAD3        v0, x0
    fmin.4s      v0, v0, v1
    STORE3       v0, x1
    ret

_min_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    fmin.4s      v0, v0, v1
    st1.4s       {v0}, [x2]
    ret

_min_vector4_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s       v1, v0[0]
    ld1.4s       {v0}, [x0]
    fmin.4s      v0, v0, v1
    st1.4s       {v0}, [x1]
    ret

_max_vector2: // (const A, B: TVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    fmax.2s      v0, v0, v1
    st1.2s       {v0}, [x2]
    ret

_max_vector2_scalar: // (const A: TVector2; const B: Single; out Result: TVector2);
    dup.2s       v1, v0[0]
    ld1.2s       {v0}, [x0]
    fmax.2s      v0, v0, v1
    st1.2s       {v0}, [x1]
    ret

_max_vector3: // (const A, B: TVector3; out Result: TVector3);
    LOAD3        v0, x0
    LOAD3        v1, x1
    fmax.4s      v0, v0, v1
    STORE3       v0, x2
    ret

_max_vector3_scalar: // (const A: TVector3; const B: Single; out Result: TVector3);
    dup.4s       v1, v0[0]
    LOAD3        v0, x0
    fmax.4s      v0, v0, v1
    STORE3       v0, x1
    ret

_max_vector4: // (const A, B: TVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    fmax.4s      v0, v0, v1
    st1.4s       {v0}, [x2]
    ret

_max_vector4_scalar: // (const A: TVector4; const B: Single; out Result: TVector4);
    dup.4s       v1, v0[0]
    ld1.4s       {v0}, [x0]
    fmax.4s      v0, v0, v1
    st1.4s       {v0}, [x1]
    ret

_ensure_range_scalar: // (const A, AMin, AMax: Single): Single;
    fmax         s0, s0, s1
    fmin         s0, s0, s2
    ret

_ensure_range_vector2: // (const A, AMin, AMax: TVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    ld1.2s       {v2}, [x2]
    fmax.2s      v0, v0, v1
    fmin.2s      v0, v0, v2
    st1.2s       {v0}, [x3]
    ret

_ensure_range_vector2_scalar: // (const A: TVector2; const AMin, AMax: Single; out Result: TVector2);
    dup.2s       v2, v1[0]
    dup.2s       v1, v0[0]
    ld1.2s       {v0}, [x0]
    fmax.2s      v0, v0, v1
    fmin.2s      v0, v0, v2
    st1.2s       {v0}, [x1]
    ret

_ensure_range_vector3: // (const A, AMin, AMax: TVector3; out Result: TVector3);
    LOAD3        v0, x0
    LOAD3        v1, x1
    LOAD3        v2, x2
    fmax.4s      v0, v0, v1
    fmin.4s      v0, v0, v2
    STORE3       v0, x3
    ret

_ensure_range_vector3_scalar: // (const A: TVector3; const AMin, AMax: Single; out Result: TVector3);
    dup.4s       v2, v1[0]
    dup.4s       v1, v0[0]
    LOAD3        v0, x0
    fmax.4s      v0, v0, v1
    fmin.4s      v0, v0, v2
    STORE3       v0, x1
    ret

_ensure_range_vector4: // (const A, AMin, AMax: TVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    ld1.4s       {v2}, [x2]
    fmax.4s      v0, v0, v1
    fmin.4s      v0, v0, v2
    st1.4s       {v0}, [x3]
    ret

_ensure_range_vector4_scalar: // (const A: TVector4; const AMin, AMax: Single; out Result: TVector4);
    dup.4s       v2, v1[0]
    dup.4s       v1, v0[0]
    ld1.4s       {v0}, [x0]
    fmax.4s      v0, v0, v1
    fmin.4s      v0, v0, v2
    st1.4s       {v0}, [x1]
    ret

_mix_vector2: // (const A, B, T: TVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    ld1.2s       {v2}, [x2]
    fsub.2s      v1, v1, v0 // B - A
    fmla.2s      v0, v1, v2 // A + (T * (B - A))
    st1.2s       {v0}, [x3]
    ret

_mix_vector2_scalar: // (const A, B: TVector2; T: Single; out Result: TVector2);
    dup.2s       v2, v0[0]
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    fsub.2s      v1, v1, v0 // B - A
    fmla.2s      v0, v1, v2 // A + (T * (B - A))
    st1.2s       {v0}, [x2]
    ret

_mix_vector3: // (const A, B, T: TVector3; out Result: TVector3);
    LOAD3        v0, x0
    LOAD3        v1, x1
    LOAD3        v2, x2
    fsub.4s      v1, v1, v0 // B - A
    fmla.4s      v0, v1, v2 // A + (T * (B - A))
    STORE3       v0, x3
    ret

_mix_vector3_scalar: // (const A, B: TVector3; T: Single; out Result: TVector3);
    dup.4s       v2, v0[0]
    LOAD3        v0, x0
    LOAD3        v1, x1
    fsub.4s      v1, v1, v0 // B - A
    fmla.4s      v0, v1, v2 // A + (T * (B - A))
    STORE3       v0, x2
    ret

_mix_vector4: // (const A, B, T: TVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    ld1.4s       {v2}, [x2]
    fsub.4s      v1, v1, v0 // B - A
    fmla.4s      v0, v1, v2 // A + (T * (B - A))
    st1.4s       {v0}, [x3]
    ret

_mix_vector4_scalar: // (const A, B: TVector4; T: Single; out Result: TVector4);
    dup.4s       v2, v0[0]
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    fsub.4s      v1, v1, v0 // B - A
    fmla.4s      v0, v1, v2 // A + (T * (B - A))
    st1.4s       {v0}, [x2]
    ret

_step_vector2: // (const AEdge, A: TVector2; out Result: TVector2);
    adr          x3, ONE_D
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    ld1.2s       {v2}, [x3] // 1.0
    fcmge.2s     v0, v1, v0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    and.8b       v0, v0, v2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    st1.2s       {v0}, [x2]
    ret

_step_scalar_vector2: // (const AEdge: Single; const A: TVector2; out Result: TVector2);
    adr          x3, ONE_D
    dup.2s       v0, v0[0]
    ld1.2s       {v1}, [x0]
    ld1.2s       {v2}, [x3] // 1.0
    fcmge.2s     v0, v1, v0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    and.8b       v0, v0, v2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    st1.2s       {v0}, [x1]
    ret

_step_vector3: // (const AEdge, A: TVector3; out Result: TVector3);
    adr          x3, ONE_Q
    LOAD3        v0, x0
    LOAD3        v1, x1
    ld1.4s       {v2}, [x3] // 1.0
    fcmge.4s     v0, v1, v0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    and.16b      v0, v0, v2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    STORE3       v0, x2
    ret

_step_scalar_vector3: // (const AEdge: Single; const A: TVector3; out Result: TVector3);
    adr          x3, ONE_Q
    dup.4s       v0, v0[0]
    LOAD3        v1, x0
    ld1.4s       {v2}, [x3] // 1.0
    fcmge.4s     v0, v1, v0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    and.16b      v0, v0, v2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    STORE3       v0, x1
    ret

_step_vector4: // (const AEdge, A: TVector4; out Result: TVector4);
    adr          x3, ONE_Q
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    ld1.4s       {v2}, [x3] // 1.0
    fcmge.4s     v0, v1, v0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    and.16b      v0, v0, v2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    st1.4s       {v0}, [x2]
    ret

_step_scalar_vector4: // (const AEdge: Single; const A: TVector4; out Result: TVector4);
    adr          x3, ONE_Q
    dup.4s       v0, v0[0]
    ld1.4s       {v1}, [x0]
    ld1.4s       {v2}, [x3] // 1.0
    fcmge.4s     v0, v1, v0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
    and.16b      v0, v0, v2 // (A >= AEdge)? Yes: 1.0, No: 0.0
    st1.4s       {v0}, [x1]
    ret

SMOOTH_STEP_D:
    .float 1.0, 1.0 // v16
    .float 2.0, 2.0 // v17
    .float 3.0, 3.0 // v18

SMOOTH_STEP_Q:
    .float 1.0, 1.0, 1.0, 1.0
    .float 2.0, 2.0, 2.0, 2.0
    .float 3.0, 3.0, 3.0, 3.0

_smoothstep_vector2: // (const AEdge0, AEdge1, A: TVector2; out Result: TVector2);
    adr          x4, SMOOTH_STEP_D
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    ld1.2s       {v2}, [x2]
    ld1.2s       {v16-v18}, [x4]
    fcmge.2s     v19, v2, v0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    fcmle.2s     v20, v2, v1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    bic.8b       v16, v16, v20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    fsub.2s      v1, v1, v0      // AEdge1 - AEdge0
    fsub.2s      v2, v2, v0      // A - AEdge0
    fdiv.2s      v2, v2, v1      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    fmls.2s      v18, v17, v2    // 3 - (2 * Temp)
    fmul.2s      v0, v18, v2     // Temp * (3 - (2 * Temp))
    fmul.2s      v0, v0, v2      // Result := Temp * Temp * (3 - (2 * Temp))

    and.8b       v0, v0, v19     // (A < AEdge0)? Yes: 0.0, No: Result
    and.8b       v0, v0, v20     // (A > AEdge1)? Yes: 0.0, No: Result
    orr.8b       v0, v0, v16     // (A > AEdge1)? Yes: 1.0, No: Result

    st1.2s       {v0}, [x3]
    ret

_smoothstep_scalar_vector2: // (const AEdge0, AEdge1: Single; const A: TVector2; out Result: TVector2);
    adr          x4, SMOOTH_STEP_D
    dup.2s       v0, v0[0]
    dup.2s       v1, v1[0]
    ld1.2s       {v2}, [x0]
    ld1.2s       {v16-v18}, [x4]
    fcmge.2s     v19, v2, v0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    fcmle.2s     v20, v2, v1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    bic.8b       v16, v16, v20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    fsub.2s      v1, v1, v0      // AEdge1 - AEdge0
    fsub.2s      v2, v2, v0      // A - AEdge0
    fdiv.2s      v2, v2, v1      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    fmls.2s      v18, v17, v2    // 3 - (2 * Temp)
    fmul.2s      v0, v18, v2     // Temp * (3 - (2 * Temp))
    fmul.2s      v0, v0, v2      // Result := Temp * Temp * (3 - (2 * Temp))

    and.8b       v0, v0, v19     // (A < AEdge0)? Yes: 0.0, No: Result
    and.8b       v0, v0, v20     // (A > AEdge1)? Yes: 0.0, No: Result
    orr.8b       v0, v0, v16     // (A > AEdge1)? Yes: 1.0, No: Result

    st1.2s       {v0}, [x1]
    ret

_smoothstep_vector3: // (const AEdge0, AEdge1, A: TVector3; out Result: TVector3);
    adr          x4, SMOOTH_STEP_Q
    LOAD3        v0, x0
    LOAD3        v1, x1
    LOAD3        v2, x2
    ld1.4s       {v16-v18}, [x4]
    fcmge.4s     v19, v2, v0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    fcmle.4s     v20, v2, v1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    bic.16b      v16, v16, v20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    fsub.4s      v1, v1, v0      // AEdge1 - AEdge0
    fsub.4s      v2, v2, v0      // A - AEdge0
    fdiv.4s      v2, v2, v1      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    fmls.4s      v18, v17, v2    // 3 - (2 * Temp)
    fmul.4s      v0, v18, v2     // Temp * (3 - (2 * Temp))
    fmul.4s      v0, v0, v2      // Result := Temp * Temp * (3 - (2 * Temp))

    and.16b      v0, v0, v19     // (A < AEdge0)? Yes: 0.0, No: Result
    and.16b      v0, v0, v20     // (A > AEdge1)? Yes: 0.0, No: Result
    orr.16b      v0, v0, v16     // (A > AEdge1)? Yes: 1.0, No: Result

    STORE3       v0, x3
    ret

_smoothstep_scalar_vector3: // (const AEdge0, AEdge1: Single; const A: TVector3; out Result: TVector3);
    adr          x4, SMOOTH_STEP_Q
    dup.4s       v0, v0[0]
    dup.4s       v1, v1[0]
    LOAD3        v2, x0
    ld1.4s       {v16-v18}, [x4]
    fcmge.4s     v19, v2, v0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    fcmle.4s     v20, v2, v1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    bic.16b      v16, v16, v20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    fsub.4s      v1, v1, v0      // AEdge1 - AEdge0
    fsub.4s      v2, v2, v0      // A - AEdge0
    fdiv.4s      v2, v2, v1      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    fmls.4s      v18, v17, v2    // 3 - (2 * Temp)
    fmul.4s      v0, v18, v2     // Temp * (3 - (2 * Temp))
    fmul.4s      v0, v0, v2      // Result := Temp * Temp * (3 - (2 * Temp))

    and.16b      v0, v0, v19     // (A < AEdge0)? Yes: 0.0, No: Result
    and.16b      v0, v0, v20     // (A > AEdge1)? Yes: 0.0, No: Result
    orr.16b      v0, v0, v16     // (A > AEdge1)? Yes: 1.0, No: Result

    STORE3       v0, x1
    ret

_smoothstep_vector4: // (const AEdge0, AEdge1, A: TVector4; out Result: TVector4);
    adr          x4, SMOOTH_STEP_Q
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    ld1.4s       {v2}, [x2]
    ld1.4s       {v16-v18}, [x4]
    fcmge.4s     v19, v2, v0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    fcmle.4s     v20, v2, v1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    bic.16b      v16, v16, v20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    fsub.4s      v1, v1, v0      // AEdge1 - AEdge0
    fsub.4s      v2, v2, v0      // A - AEdge0
    fdiv.4s      v2, v2, v1      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    fmls.4s      v18, v17, v2    // 3 - (2 * Temp)
    fmul.4s      v0, v18, v2     // Temp * (3 - (2 * Temp))
    fmul.4s      v0, v0, v2      // Result := Temp * Temp * (3 - (2 * Temp))

    and.16b      v0, v0, v19     // (A < AEdge0)? Yes: 0.0, No: Result
    and.16b      v0, v0, v20     // (A > AEdge1)? Yes: 0.0, No: Result
    orr.16b      v0, v0, v16     // (A > AEdge1)? Yes: 1.0, No: Result

    st1.4s       {v0}, [x3]
    ret

_smoothstep_scalar_vector4: // (const AEdge0, AEdge1: Single; const A: TVector4; out Result: TVector4);
    adr          x4, SMOOTH_STEP_Q
    dup.4s       v0, v0[0]
    dup.4s       v1, v1[0]
    ld1.4s       {v2}, [x0]
    ld1.4s       {v16-v18}, [x4]
    fcmge.4s     v19, v2, v0     // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
    fcmle.4s     v20, v2, v1     // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
    bic.16b      v16, v16, v20   // (A > AEdge1)? Yes: 1.0, No: 0.0
    fsub.4s      v1, v1, v0      // AEdge1 - AEdge0
    fsub.4s      v2, v2, v0      // A - AEdge0
    fdiv.4s      v2, v2, v1      // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
    fmls.4s      v18, v17, v2    // 3 - (2 * Temp)
    fmul.4s      v0, v18, v2     // Temp * (3 - (2 * Temp))
    fmul.4s      v0, v0, v2      // Result := Temp * Temp * (3 - (2 * Temp))

    and.16b      v0, v0, v19     // (A < AEdge0)? Yes: 0.0, No: Result
    and.16b      v0, v0, v20     // (A > AEdge1)? Yes: 0.0, No: Result
    orr.16b      v0, v0, v16     // (A > AEdge1)? Yes: 1.0, No: Result

    st1.4s       {v0}, [x1]
    ret

_fma_vector2: // (const A, B, C: TVector2; out Result: TVector2);
    ld1.2s       {v0}, [x0]
    ld1.2s       {v1}, [x1]
    ld1.2s       {v2}, [x2]
    fmla.2s      v2, v0, v1      // // (A * B) + C
    st1.2s       {v2}, [x3]
    ret

_fma_vector3: // (const A, B, C: TVector3; out Result: TVector3);
    LOAD3        v0, x0
    LOAD3        v1, x1
    LOAD3        v2, x2
    fmla.4s      v2, v0, v1      // // (A * B) + C
    STORE3       v2, x3
    ret

_fma_vector4: // (const A, B, C: TVector4; out Result: TVector4);
    ld1.4s       {v0}, [x0]
    ld1.4s       {v1}, [x1]
    ld1.4s       {v2}, [x2]
    fmla.4s      v2, v0, v1      // // (A * B) + C
    st1.4s       {v2}, [x3]
    ret

#endif // __LP64__
