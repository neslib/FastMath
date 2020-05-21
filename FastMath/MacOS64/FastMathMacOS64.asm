; MacOS64 uses the System V AMD64 ABI:
; * First 6 (up to) 64-bit int/pointer parameters in RDI, RSI, RDX, RCX, R8, R9
; * First 8 float parameters in XMM0-XMM7
; * (Up to) 64-bit int return value: RAX
; * (Up to) 128-bit int return value: RAX, RDX
; * Float return value(s): XMM0, XMM1. This applies to records with float values
;   as well: the first 2 Single values are returned in XMM0 and the next to in
;   XMM1 (so for a TVector4, XMM0 contains X and Y, and XMM1 contains Z and W).
;   Use "movhlps xmm1, xmm0" to copy the upper 2 floats from xmm0 to the lower
;   2 floats of xmm1
; * For return values larger than 128 bits, the first parameter (RDI) will be
;   set by the caller to the address of the return value (and all other 
;   parameters move one up).
; * RBX, RBP and R12-R15 must be saved
; * RAX, RCX, RDX, RSI, RDI, R8-R11 can be modified
; * All XMM registeres can be modified
; * For leaf-node functions (that don't call other functions), the 128 bytes
;   below the stack pointer (the red-zone) can be freely used.
; * The ".data" segment is aligned, so you can use "movaps" and friends
; * Parameter pointers do *not* have to be aligned, so you should use "movups"

BITS 64

section .data

ALIGN 16

; SSE rounding modes (bits in MXCSR register)
%define SSE_ROUND_MASK 0xFFFF9FFF
%define SSE_ROUND_NEAREST 0x00000000
%define SSE_ROUND_DOWN 0x00002000
%define SSE_ROUND_UP 0x00004000
%define SSE_ROUND_TRUNC 0x00006000

; These constants fit in a single XMM register. These values represent
; sign-bits as used by 32-bit floating-point values.
; XOR'ing a floating-point value with 0x80000000 swaps the sign.
; XOR'ing a floating-point value with 0x00000000 leaves the value unchanged.
kSSE_MASK_SIGN:
  dd 0x80000000, 0x80000000, 0x80000000, 0x80000000

kSSE_MASK_NPNP:
  dd 0x80000000, 0x00000000, 0x80000000, 0x00000000

kSSE_MASK_PNPN:
  dd 0x00000000, 0x80000000, 0x00000000, 0x80000000

kSSE_MASK_0FFF:
  dd 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000

; These constants mask off an element of the binary representation of a
; 32-bit floating-point value.
kSSE_MASK_FRACTION:
  dd 0x007FFFFF, 0x007FFFFF, 0x007FFFFF, 0x007FFFFF

kSSE_MASK_EXPONENT:
  dd 0x7F800000, 0x7F800000, 0x7F800000, 0x7F800000

kSSE_MASK_ABS_VAL:
  dd 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF

; Commonly used floating-point values
kSSE_ONE_HALF:
  dd 0.5, 0.5, 0.5, 0.5

kSSE_ONE:
  dd 1.0, 1.0, 1.0, 1.0

kSSE_TWO:
  dd 2.0, 2.0, 2.0, 2.0

kSSE_THREE:
  dd 3.0, 3.0, 3.0, 3.0

kSSE_PI_OVER_180:
  dd 0.01745329251994329576923690768489, 0.01745329251994329576923690768489, 0.01745329251994329576923690768489, 0.01745329251994329576923690768489

kSSE_180_OVER_PI:
  dd 57.295779513082320876798154814105, 57.295779513082320876798154814105, 57.295779513082320876798154814105, 57.295779513082320876798154814105

kSSE_NEG_INFINITY:
  dd -__Infinity__, -__Infinity__, -__Infinity__, -__Infinity__

kSSE_PI_OVER_4:
  dd 0.78539816339744830961566084581988, 0.78539816339744830961566084581988, 0.78539816339744830961566084581988, 0.78539816339744830961566084581988

; Commonly used integer values
kSSE_INT_ONE:
  dd 1, 1, 1, 1

kSSE_INT_NOT_ONE:
  dd 0xFFFFFFFE, 0xFFFFFFFE, 0xFFFFFFFE, 0xFFFFFFFE

kSSE_INT_TWO:
  dd 2, 2, 2, 2

kSSE_INT_FOUR:
  dd 4, 4, 4, 4

; Constants for approximating trigonometric functions
kSSE_FOPI:
  dd 1.27323954473516, 1.27323954473516, 1.27323954473516, 1.27323954473516

kSSE_SINCOF_P0:
  dd -1.9515295891E-4, -1.9515295891E-4, -1.9515295891E-4, -1.9515295891E-4

kSSE_SINCOF_P1:
  dd 8.3321608736E-3, 8.3321608736E-3, 8.3321608736E-3, 8.3321608736E-3

kSSE_SINCOF_P2:
  dd -1.6666654611E-1, -1.6666654611E-1, -1.6666654611E-1, -1.6666654611E-1

kSSE_COSCOF_P0:
  dd 2.443315711809948E-005, 2.443315711809948E-005, 2.443315711809948E-005, 2.443315711809948E-005

kSSE_COSCOF_P1:
  dd -1.388731625493765E-003, -1.388731625493765E-003, -1.388731625493765E-003, -1.388731625493765E-003

kSSE_COSCOF_P2:
  dd 4.166664568298827E-002, 4.166664568298827E-002, 4.166664568298827E-002, 4.166664568298827E-002

kSSE_EXP_A1:
  dd 12102203.1615614, 12102203.1615614, 12102203.1615614, 12102203.1615614

kSSE_EXP_A2:
  dd 1065353216.0, 1065353216.0, 1065353216.0, 1065353216.0

kSSE_EXP_CST:
  dd 2139095040.0, 2139095040.0, 2139095040.0, 2139095040.0

kSSE_EXP_F1:
  dd 0.509964287281036376953125, 0.509964287281036376953125, 0.509964287281036376953125, 0.509964287281036376953125

kSSE_EXP_F2:
  dd 0.3120158612728118896484375, 0.3120158612728118896484375, 0.3120158612728118896484375, 0.3120158612728118896484375

kSSE_EXP_F3:
  dd 0.1666135489940643310546875, 0.1666135489940643310546875, 0.1666135489940643310546875, 0.1666135489940643310546875

kSSE_EXP_F4:
  dd -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3

kSSE_EXP_F5:
  dd 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2

kSSE_EXP_I1:
  dd 0x3F800000, 0x3F800000, 0x3F800000, 0x3F800000

kSSE_LN_CST:
  dd -89.93423858, -89.93423858, -89.93423858, -89.93423858

kSSE_LN_F1:
  dd 3.3977745, 3.3977745, 3.3977745, 3.3977745

kSSE_LN_F2:
  dd 2.2744832, 2.2744832, 2.2744832, 2.2744832

kSSE_LN_F3:
  dd 0.024982445, 0.024982445, 0.024982445, 0.024982445

kSSE_LN_F4:
  dd 0.24371102, 0.24371102, 0.24371102, 0.24371102

kSSE_LN_F5:
  dd 0.69314718055995, 0.69314718055995, 0.69314718055995, 0.69314718055995

kSSE_LOG2_I1:
  dd 0x3F000000, 0x3F000000, 0x3F000000, 0x3F000000

kSSE_LOG2_F1:
  dd 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7

kSSE_LOG2_F2:
  dd 124.22551499, 124.22551499, 124.22551499, 124.22551499

kSSE_LOG2_F3:
  dd 1.498030302, 1.498030302, 1.498030302, 1.498030302

kSSE_LOG2_F4:
  dd 1.72587999, 1.72587999, 1.72587999, 1.72587999

kSSE_LOG2_F5:
  dd 0.3520887068, 0.3520887068, 0.3520887068, 0.3520887068

kSSE_EXP2_F1:
  dd 121.2740575, 121.2740575, 121.2740575, 121.2740575

kSSE_EXP2_F2:
  dd 27.7280233, 27.7280233, 27.7280233, 27.7280233

kSSE_EXP2_F3:
  dd 4.84252568, 4.84252568, 4.84252568, 4.84252568

kSSE_EXP2_F4:
  dd 1.49012907, 1.49012907, 1.49012907, 1.49012907

kSSE_EXP2_F5:
  dd 8388608.0, 8388608.0, 8388608.0, 8388608.00000

section .text

%define Param1 rdi
%define Param2 rsi
%define Param3 rdx
%define Self rdi
%define OldFlags rsp-32
%define NewFlags rsp-48

global _radians_vector2, _radians_vector3, _radians_vector4
global _degrees_vector2, _degrees_vector3, _degrees_vector4
global _sqrt_single, _sqrt_vector2, _sqrt_vector3, _sqrt_vector4
global _inverse_sqrt_single, _inverse_sqrt_vector2, _inverse_sqrt_vector3, _inverse_sqrt_vector4
global _fast_sin_single, _fast_sin_vector2, _fast_sin_vector3, _fast_sin_vector4
global _fast_cos_single, _fast_cos_vector2, _fast_cos_vector3, _fast_cos_vector4
global _fast_sin_cos_single, _fast_sin_cos_vector2, _fast_sin_cos_vector3, _fast_sin_cos_vector4
global _fast_exp_single, _fast_exp_vector2, _fast_exp_vector3, _fast_exp_vector4
global _fast_ln_single, _fast_ln_vector2, _fast_ln_vector3, _fast_ln_vector4
global _fast_log2_single, _fast_log2_vector2, _fast_log2_vector3, _fast_log2_vector4
global _fast_exp2_single, _fast_exp2_vector2, _fast_exp2_vector3, _fast_exp2_vector4
global _abs_vector3, _abs_vector4
global _sign_single, _sign_vector2, _sign_vector3, _sign_vector4
global _floor_single, _floor_vector2, _floor_vector3, _floor_vector4
global _trunc_single, _trunc_vector2, _trunc_vector3, _trunc_vector4
global _round_single,_round_vector2, _round_vector3, _round_vector4
global _ceil_single, _ceil_vector2, _ceil_vector3, _ceil_vector4
global _frac_vector2, _frac_vector3, _frac_vector4
global _fmod_vector2_single, _fmod_vector3_single, _fmod_vector4_single
global _fmod_vector2, _fmod_vector3, _fmod_vector4
global _modf_vector2, _modf_vector3, _modf_vector4
global _min_vector2_single, _min_vector3_single, _min_vector4_single
global _min_vector2, _min_vector3, _min_vector4
global _max_vector2_single, _max_vector3_single, _max_vector4_single
global _max_vector2, _max_vector3, _max_vector4
global _ensure_range_single
global _ensure_range_vector2_single, _ensure_range_vector3_single, _ensure_range_vector4_single
global _ensure_range_vector2, _ensure_range_vector3, _ensure_range_vector4
global _mix_vector3_single, _mix_vector4_single
global _mix_vector3, _mix_vector4
global _step_single_vector2, _step_single_vector3, _step_single_vector4
global _step_vector2, _step_vector3, _step_vector4
global _smooth_step_single_vector3, _smooth_step_single_vector4
global _smooth_step_vector3, _smooth_step_vector4
global _fma_vector2, _fma_vector3, _fma_vector4
global _outer_product_matrix2, _outer_product_matrix3, _outer_product_matrix4
global _vector2_div_single, _single_div_vector2, _vector2_div_vector2
global _vector2_normalize_fast, _vector2_set_normalized_fast
global _vector3_add_single, _single_add_vector3, _vector3_add_vector3
global _vector3_sub_single, _single_sub_vector3, _vector3_sub_vector3
global _vector3_mul_single, _single_mul_vector3, _vector3_mul_vector3
global _vector3_div_single, _single_div_vector3, _vector3_div_vector3
global _vector3_distance, _vector3_distance_squared
global _vector3_get_length, _vector3_get_length_squared
global _vector3_normalize_fast, _vector3_set_normalized_fast
global _vector3_reflect, _vector3_refract
global _vector4_add_single, _single_add_vector4, _vector4_add_vector4
global _vector4_sub_single, _single_sub_vector4, _vector4_sub_vector4
global _vector4_mul_single, _single_mul_vector4, _vector4_mul_vector4
global _vector4_div_single, _single_div_vector4, _vector4_div_vector4
global _vector4_negative
global _vector4_distance, _vector4_distance_squared
global _vector4_face_forward
global _vector4_get_length, _vector4_get_length_squared
global _vector4_normalize_fast, _vector4_set_normalized_fast
global _vector4_reflect, _vector4_refract
global _matrix3_add_single, _single_add_matrix3, _matrix3_add_matrix3
global _matrix3_sub_single, _single_sub_matrix3, _matrix3_sub_matrix3
global _matrix3_mul_single, _single_mul_matrix3, _matrix3_comp_mult
global _matrix3_mul_vector3, _vector3_mul_matrix3, _matrix3_mul_matrix3
global _matrix3_div_single, _single_div_matrix3
global _matrix3_negative, _matrix3_transpose, _matrix3_set_transposed
global _matrix4_add_single, _single_add_matrix4, _matrix4_add_matrix4
global _matrix4_sub_single, _single_sub_matrix4, _matrix4_sub_matrix4
global _matrix4_mul_single, _single_mul_matrix4, _matrix4_comp_mult
global _matrix4_mul_vector4, _vector4_mul_matrix4, _matrix4_mul_matrix4
global _matrix4_div_single, _single_div_matrix4
global _matrix4_negative, _matrix4_inverse, _matrix4_set_inversed
global _matrix4_transpose, _matrix4_set_transposed

;****************************************************************************
; Angle and Trigonometry Functions
;****************************************************************************

_radians_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [rel kSSE_PI_OVER_180]
  mulps     xmm0, xmm1
  ret

_radians_vector3:
  movlps    xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movaps    xmm2, [rel kSSE_PI_OVER_180]
  mulps     xmm0, xmm2
  mulss     xmm1, xmm2
  ret

_radians_vector4:
  movups    xmm0, [Param1]
  movaps    xmm1, [rel kSSE_PI_OVER_180]
  mulps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret

_degrees_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [rel kSSE_180_OVER_PI]
  mulps     xmm0, xmm1
  ret

_degrees_vector3:
  movlps    xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movaps    xmm2, [rel kSSE_180_OVER_PI]
  mulps     xmm0, xmm2
  mulss     xmm1, xmm2
  ret

_degrees_vector4:
  movups    xmm0, [Param1]
  movaps    xmm1, [rel kSSE_180_OVER_PI]
  mulps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret

;****************************************************************************
; Exponential Functions
;****************************************************************************

_sqrt_single:
  sqrtss    xmm0, xmm0
  ret

_sqrt_vector2:
  movlps    xmm0, [Param1]
  sqrtps    xmm0, xmm0
  ret

_sqrt_vector3:
  movlps    xmm0, [Param1]
  movss     xmm1, [Param1+8]
  sqrtps    xmm0, xmm0
  sqrtps    xmm1, xmm1
  ret

_sqrt_vector4:
  movups    xmm0, [Param1]
  sqrtps    xmm0, xmm0
  movhlps   xmm1, xmm0
  ret

_inverse_sqrt_single:
  rsqrtss   xmm0, xmm0
  ret

_inverse_sqrt_vector2:
  movlps    xmm0, [Param1]
  rsqrtps   xmm0, xmm0
  ret

_inverse_sqrt_vector3:
  movlps    xmm0, [Param1]
  movss     xmm1, [Param1+8]
  rsqrtps   xmm0, xmm0
  rsqrtps   xmm1, xmm1
  ret

_inverse_sqrt_vector4:
  movups    xmm0, [Param1]
  rsqrtps   xmm0, xmm0
  movhlps   xmm1, xmm0
  ret

;****************************************************************************
; Fast approximate Functions
;****************************************************************************

_fast_sin_single:
  movss     xmm2, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  movss     xmm3, [rel kSSE_MASK_SIGN]
  andps     xmm0, xmm2               ; (xmm0) X := Abs(ARadians)
  andps     xmm1, xmm3               ; (xmm1) SignBit
  movaps    xmm2, xmm0
  movss     xmm4, [rel kSSE_FOPI]
  movss     xmm5, [rel kSSE_INT_ONE]
  mulss     xmm2, xmm4
  movss     xmm6, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm2, xmm2               ; J := Trunc(X * FOPI)
  movss     xmm7, [rel kSSE_INT_FOUR]
  paddd     xmm2, xmm5
  pand      xmm2, xmm6               ; (xmm2) J := (J + 1) and (not 1)
  movss     xmm6, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm4, xmm2               ; (xmm4) Y := J
  movaps    xmm5, xmm2
  pand      xmm2, xmm6               ; J and 2
  pand      xmm5, xmm7               ; J and 4
  pxor      xmm7, xmm7
  pslld     xmm5, 29                 ; (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd   xmm2, xmm7               ; (xmm2) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movss     xmm6, [rel kSSE_PI_OVER_4]
  pxor      xmm1, xmm5               ; (xmm1) SignBit := SignBit xor SwapSignBit
  mulss     xmm4, xmm6               ; Y * Pi / 4
  movss     xmm3, [rel kSSE_COSCOF_P0]
  subss     xmm0, xmm4               ; (xmm0) X := X - (Y * Pi / 4)
  movss     xmm4, [rel kSSE_COSCOF_P1]
  movaps    xmm7, xmm0
  movss     xmm6, [rel kSSE_COSCOF_P2]
  mulss     xmm7, xmm7               ; (xmm7) Z := X * X
  movss     xmm5, [rel kSSE_SINCOF_P1]
  mulss     xmm3, xmm7               ; COSCOF_P0 * Z
  addss     xmm3, xmm4               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movss     xmm4, [rel kSSE_ONE_HALF]
  mulss     xmm3, xmm7               ; Y * Z
  mulss     xmm4, xmm7               ; Z * 0.5
  addps     xmm3, xmm6               ; Y := (Y * Z) + COSCOF_P2
  movss     xmm6, [rel kSSE_ONE]
  mulss     xmm3, xmm7               ; Y * Z
  mulss     xmm3, xmm7               ; Y := Y * (Z * Z)
  subss     xmm3, xmm4               ; Y - Z * 0.5
  movss     xmm4, [rel kSSE_SINCOF_P0]
  addps     xmm3, xmm6               ; (xmm3) Y := Y - Z * 0.5 + 1
  movss     xmm6, [rel kSSE_SINCOF_P2]
  mulss     xmm4, xmm7               ; SINCOF_P0 * Z
  addss     xmm4, xmm5               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps    xmm5, xmm2
  mulss     xmm4, xmm7               ; Y2 * Z
  addss     xmm4, xmm6               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulss     xmm4, xmm7               ; Y2 * Z
  mulss     xmm4, xmm0               ; Y2 * (Z * X)
  addss     xmm4, xmm0               ; (xmm4) Y2 := Y2 * (Z * X) + X
  andps     xmm4, xmm2               ; Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm3               ; Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addss     xmm4, xmm5
  xorps     xmm4, xmm1               ; (Y + Y2) xor SignBit
  movss     xmm0, xmm4
  ret

_fast_sin_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm2, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  movlps    xmm3, [rel kSSE_MASK_SIGN]
  andps     xmm0, xmm2               ; (xmm0) X := Abs(ARadians)
  andps     xmm1, xmm3               ; (xmm1) SignBit
  movaps    xmm2, xmm0
  movlps    xmm4, [rel kSSE_FOPI]
  movlps    xmm5, [rel kSSE_INT_ONE]
  mulps     xmm2, xmm4
  movlps    xmm6, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm2, xmm2               ; J := Trunc(X * FOPI)
  movlps    xmm7, [rel kSSE_INT_FOUR]
  paddd     xmm2, xmm5
  pand      xmm2, xmm6               ; (xmm2) J := (J + 1) and (not 1)
  movlps    xmm6, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm4, xmm2               ; (xmm4) Y := J
  movaps    xmm5, xmm2
  pand      xmm2, xmm6               ; J and 2
  pand      xmm5, xmm7               ; J and 4
  pxor      xmm7, xmm7
  pslld     xmm5, 29                 ; (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd   xmm2, xmm7               ; (xmm2) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movlps    xmm6, [rel kSSE_PI_OVER_4]
  pxor      xmm1, xmm5               ; (xmm1) SignBit := SignBit xor SwapSignBit
  mulps     xmm4, xmm6               ; Y * Pi / 4
  movlps    xmm3, [rel kSSE_COSCOF_P0]
  subps     xmm0, xmm4               ; (xmm0) X := X - (Y * Pi / 4)
  movlps    xmm4, [rel kSSE_COSCOF_P1]
  movaps    xmm7, xmm0
  movlps    xmm6, [rel kSSE_COSCOF_P2]
  mulps     xmm7, xmm7               ; (xmm7) Z := X * X
  movlps    xmm5, [rel kSSE_SINCOF_P1]
  mulps     xmm3, xmm7               ; COSCOF_P0 * Z
  addps     xmm3, xmm4               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movlps    xmm4, [rel kSSE_ONE_HALF]
  mulps     xmm3, xmm7               ; Y * Z
  mulps     xmm4, xmm7               ; Z * 0.5
  addps     xmm3, xmm6               ; Y := (Y * Z) + COSCOF_P2
  movlps    xmm6, [rel kSSE_ONE]
  mulps     xmm3, xmm7               ; Y * Z
  mulps     xmm3, xmm7               ; Y := Y * (Z * Z)
  subps     xmm3, xmm4               ; Y - Z * 0.5
  movlps    xmm4, [rel kSSE_SINCOF_P0]
  addps     xmm3, xmm6               ; (xmm3) Y := Y - Z * 0.5 + 1
  movlps    xmm6, [rel kSSE_SINCOF_P2]
  mulps     xmm4, xmm7               ; SINCOF_P0 * Z
  addps     xmm4, xmm5               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps    xmm5, xmm2
  mulps     xmm4, xmm7               ; Y2 * Z
  addps     xmm4, xmm6               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulps     xmm4, xmm7               ; Y2 * Z
  mulps     xmm4, xmm0               ; Y2 * (Z * X)
  addps     xmm4, xmm0               ; (xmm4) Y2 := Y2 * (Z * X) + X
  andps     xmm4, xmm2               ; Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm3               ; Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addps     xmm4, xmm5
  xorps     xmm4, xmm1               ; (Y + Y2) xor SignBit
  movaps    xmm0, xmm4
  ret

_fast_sin_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movaps    xmm2, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  movaps    xmm3, [rel kSSE_MASK_SIGN]
  andps     xmm0, xmm2               ; (xmm0) X := Abs(ARadians)
  andps     xmm1, xmm3               ; (xmm1) SignBit
  movaps    xmm2, xmm0
  movaps    xmm4, [rel kSSE_FOPI]
  movaps    xmm5, [rel kSSE_INT_ONE]
  mulps     xmm2, xmm4
  movaps    xmm6, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm2, xmm2               ; J := Trunc(X * FOPI)
  movaps    xmm7, [rel kSSE_INT_FOUR]
  paddd     xmm2, xmm5
  pand      xmm2, xmm6               ; (xmm2) J := (J + 1) and (not 1)
  movaps    xmm6, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm4, xmm2               ; (xmm4) Y := J
  movaps    xmm5, xmm2
  pand      xmm2, xmm6               ; J and 2
  pand      xmm5, xmm7               ; J and 4
  pxor      xmm7, xmm7
  pslld     xmm5, 29                 ; (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd   xmm2, xmm7               ; (xmm2) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movaps    xmm6, [rel kSSE_PI_OVER_4]
  pxor      xmm1, xmm5               ; (xmm1) SignBit := SignBit xor SwapSignBit
  mulps     xmm4, xmm6               ; Y * Pi / 4
  movaps    xmm3, [rel kSSE_COSCOF_P0]
  subps     xmm0, xmm4               ; (xmm0) X := X - (Y * Pi / 4)
  movaps    xmm4, [rel kSSE_COSCOF_P1]
  movaps    xmm7, xmm0
  movaps    xmm6, [rel kSSE_COSCOF_P2]
  mulps     xmm7, xmm7               ; (xmm7) Z := X * X
  movaps    xmm5, [rel kSSE_SINCOF_P1]
  mulps     xmm3, xmm7               ; COSCOF_P0 * Z
  addps     xmm3, xmm4               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movaps    xmm4, [rel kSSE_ONE_HALF]
  mulps     xmm3, xmm7               ; Y * Z
  mulps     xmm4, xmm7               ; Z * 0.5
  addps     xmm3, xmm6               ; Y := (Y * Z) + COSCOF_P2
  movaps    xmm6, [rel kSSE_ONE]
  mulps     xmm3, xmm7               ; Y * Z
  mulps     xmm3, xmm7               ; Y := Y * (Z * Z)
  subps     xmm3, xmm4               ; Y - Z * 0.5
  movaps    xmm4, [rel kSSE_SINCOF_P0]
  addps     xmm3, xmm6               ; (xmm3) Y := Y - Z * 0.5 + 1
  movaps    xmm6, [rel kSSE_SINCOF_P2]
  mulps     xmm4, xmm7               ; SINCOF_P0 * Z
  addps     xmm4, xmm5               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps    xmm5, xmm2
  mulps     xmm4, xmm7               ; Y2 * Z
  addps     xmm4, xmm6               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulps     xmm4, xmm7               ; Y2 * Z
  mulps     xmm4, xmm0               ; Y2 * (Z * X)
  addps     xmm4, xmm0               ; (xmm4) Y2 := Y2 * (Z * X) + X
  andps     xmm4, xmm2               ; Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm3               ; Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addps     xmm4, xmm5
  xorps     xmm4, xmm1               ; (Y + Y2) xor SignBit
  movaps    xmm0, xmm4
  movhlps   xmm1, xmm4
  ret

_fast_sin_vector4:
  movups    xmm0, [Param1]
  movaps    xmm2, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  movaps    xmm3, [rel kSSE_MASK_SIGN]
  andps     xmm0, xmm2               ; (xmm0) X := Abs(ARadians)
  andps     xmm1, xmm3               ; (xmm1) SignBit
  movaps    xmm2, xmm0
  movaps    xmm4, [rel kSSE_FOPI]
  movaps    xmm5, [rel kSSE_INT_ONE]
  mulps     xmm2, xmm4
  movaps    xmm6, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm2, xmm2               ; J := Trunc(X * FOPI)
  movaps    xmm7, [rel kSSE_INT_FOUR]
  paddd     xmm2, xmm5
  pand      xmm2, xmm6               ; (xmm2) J := (J + 1) and (not 1)
  movaps    xmm6, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm4, xmm2               ; (xmm4) Y := J
  movaps    xmm5, xmm2
  pand      xmm2, xmm6               ; J and 2
  pand      xmm5, xmm7               ; J and 4
  pxor      xmm7, xmm7
  pslld     xmm5, 29                 ; (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd   xmm2, xmm7               ; (xmm2) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movaps    xmm6, [rel kSSE_PI_OVER_4]
  pxor      xmm1, xmm5               ; (xmm1) SignBit := SignBit xor SwapSignBit
  mulps     xmm4, xmm6               ; Y * Pi / 4
  movaps    xmm3, [rel kSSE_COSCOF_P0]
  subps     xmm0, xmm4               ; (xmm0) X := X - (Y * Pi / 4)
  movaps    xmm4, [rel kSSE_COSCOF_P1]
  movaps    xmm7, xmm0
  movaps    xmm6, [rel kSSE_COSCOF_P2]
  mulps     xmm7, xmm7               ; (xmm7) Z := X * X
  movaps    xmm5, [rel kSSE_SINCOF_P1]
  mulps     xmm3, xmm7               ; COSCOF_P0 * Z
  addps     xmm3, xmm4               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movaps    xmm4, [rel kSSE_ONE_HALF]
  mulps     xmm3, xmm7               ; Y * Z
  mulps     xmm4, xmm7               ; Z * 0.5
  addps     xmm3, xmm6               ; Y := (Y * Z) + COSCOF_P2
  movaps    xmm6, [rel kSSE_ONE]
  mulps     xmm3, xmm7               ; Y * Z
  mulps     xmm3, xmm7               ; Y := Y * (Z * Z)
  subps     xmm3, xmm4               ; Y - Z * 0.5
  movaps    xmm4, [rel kSSE_SINCOF_P0]
  addps     xmm3, xmm6               ; (xmm3) Y := Y - Z * 0.5 + 1
  movaps    xmm6, [rel kSSE_SINCOF_P2]
  mulps     xmm4, xmm7               ; SINCOF_P0 * Z
  addps     xmm4, xmm5               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps    xmm5, xmm2
  mulps     xmm4, xmm7               ; Y2 * Z
  addps     xmm4, xmm6               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulps     xmm4, xmm7               ; Y2 * Z
  mulps     xmm4, xmm0               ; Y2 * (Z * X)
  addps     xmm4, xmm0               ; (xmm4) Y2 := Y2 * (Z * X) + X
  andps     xmm4, xmm2               ; Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm3               ; Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addps     xmm4, xmm5
  xorps     xmm4, xmm1               ; (Y + Y2) xor SignBit
  movaps    xmm0, xmm4
  movhlps   xmm1, xmm4
  ret

_fast_cos_single:
  movss     xmm1, [rel kSSE_MASK_ABS_VAL]
  movss     xmm2, [rel kSSE_FOPI]
  andps     xmm0, xmm1               ; (xmm0) X := Abs(ARadians)
  movss     xmm3, [rel kSSE_INT_NOT_ONE]
  movaps    xmm1, xmm0
  movss     xmm4, [rel kSSE_INT_FOUR]
  mulss     xmm1, xmm2
  movss     xmm2, [rel kSSE_INT_ONE]
  cvtps2dq  xmm1, xmm1               ; J := Trunc(X * FOPI)
  pxor      xmm6, xmm6
  paddd     xmm1, xmm2
  pand      xmm1, xmm3               ; (xmm1) J := (J + 1) and (not 1)
  movss     xmm3, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm1               ; (xmm2) Y := J
  psubd     xmm1, xmm3               ; J - 2
  movaps    xmm5, xmm1
  pandn     xmm1, xmm4               ; (not (J - 2)) and 4
  pand      xmm5, xmm3               ; (J - 2) and 2
  pslld     xmm1, 29                 ; (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movss     xmm3, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm5, xmm6               ; (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulss     xmm2, xmm3               ; Y * Pi / 4
  movss     xmm3, [rel kSSE_COSCOF_P1]
  subss     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  movss     xmm2, [rel kSSE_COSCOF_P0]
  movss     xmm4, [rel kSSE_COSCOF_P2]
  movaps    xmm6, xmm0
  mulss     xmm6, xmm6               ; (xmm6) Z := X * X
  mulss     xmm2, xmm6               ; COSCOF_P0 * Z
  addps     xmm2, xmm3               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movss     xmm3, [rel kSSE_ONE_HALF]
  mulss     xmm2, xmm6               ; Y * Z
  mulss     xmm3, xmm6               ; Z * 0.5
  addss     xmm2, xmm4               ; Y := (Y * Z) + COSCOF_P2
  movss     xmm7, [rel kSSE_ONE]
  mulss     xmm2, xmm6
  movss     xmm4, [rel kSSE_SINCOF_P1]
  mulss     xmm2, xmm6               ; Y := Y * (Z * Z)
  subss     xmm2, xmm3               ; Y - Z * 0.5
  addss     xmm2, xmm7               ; (xmm2) Y := Y - Z * 0.5 + 1
  movss     xmm3, [rel kSSE_SINCOF_P0]
  movss     xmm7, [rel kSSE_SINCOF_P2]
  mulss     xmm3, xmm6               ; SINCOF_P0 * Z
  addss     xmm3, xmm4               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulss     xmm3, xmm6               ; Y2 * Z
  addss     xmm3, xmm7               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulss     xmm3, xmm6               ; Y2 * Z
  mulss     xmm3, xmm0               ; Y2 * (Z * X)
  addss     xmm3, xmm0               ; Y2 := Y2 * (Z * X) + X
  andps     xmm3, xmm5               ; ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm2               ; ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addss     xmm3, xmm5
  xorps     xmm3, xmm1               ; (Y + Y2) xor SignBit
  movss     xmm0, xmm3
  ret   

_fast_cos_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [rel kSSE_MASK_ABS_VAL]
  movlps    xmm2, [rel kSSE_FOPI]
  andps     xmm0, xmm1               ; (xmm0) X := Abs(ARadians)
  movlps    xmm3, [rel kSSE_INT_NOT_ONE]
  movaps    xmm1, xmm0
  movlps    xmm4, [rel kSSE_INT_FOUR]
  mulps     xmm1, xmm2
  movlps    xmm2, [rel kSSE_INT_ONE]
  cvtps2dq  xmm1, xmm1               ; J := Trunc(X * FOPI)
  pxor      xmm6, xmm6
  paddd     xmm1, xmm2
  pand      xmm1, xmm3               ; (xmm1) J := (J + 1) and (not 1)
  movlps    xmm3, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm1               ; (xmm2) Y := J
  psubd     xmm1, xmm3               ; J - 2
  movaps    xmm5, xmm1
  pandn     xmm1, xmm4               ; (not (J - 2)) and 4
  pand      xmm5, xmm3               ; (J - 2) and 2
  pslld     xmm1, 29                 ; (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movlps    xmm3, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm5, xmm6               ; (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulps     xmm2, xmm3               ; Y * Pi / 4
  movlps    xmm3, [rel kSSE_COSCOF_P1]
  subps     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  movlps    xmm2, [rel kSSE_COSCOF_P0]
  movlps    xmm4, [rel kSSE_COSCOF_P2]
  movaps    xmm6, xmm0
  mulps     xmm6, xmm6               ; (xmm6) Z := X * X
  mulps     xmm2, xmm6               ; COSCOF_P0 * Z
  addps     xmm2, xmm3               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movlps    xmm3, [rel kSSE_ONE_HALF]
  mulps     xmm2, xmm6               ; Y * Z
  mulps     xmm3, xmm6               ; Z * 0.5
  addps     xmm2, xmm4               ; Y := (Y * Z) + COSCOF_P2
  movlps    xmm7, [rel kSSE_ONE]
  mulps     xmm2, xmm6
  movlps    xmm4, [rel kSSE_SINCOF_P1]
  mulps     xmm2, xmm6               ; Y := Y * (Z * Z)
  subps     xmm2, xmm3               ; Y - Z * 0.5
  addps     xmm2, xmm7               ; (xmm2) Y := Y - Z * 0.5 + 1
  movlps    xmm3, [rel kSSE_SINCOF_P0]
  movlps    xmm7, [rel kSSE_SINCOF_P2]
  mulps     xmm3, xmm6               ; SINCOF_P0 * Z
  addps     xmm3, xmm4               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps     xmm3, xmm6               ; Y2 * Z
  addps     xmm3, xmm7               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulps     xmm3, xmm6               ; Y2 * Z
  mulps     xmm3, xmm0               ; Y2 * (Z * X)
  addps     xmm3, xmm0               ; Y2 := Y2 * (Z * X) + X
  andps     xmm3, xmm5               ; ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm2               ; ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addps     xmm3, xmm5
  xorps     xmm3, xmm1               ; (Y + Y2) xor SignBit
  movaps    xmm0, xmm3
  ret
  
_fast_cos_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movaps    xmm1, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm2, [rel kSSE_FOPI]
  andps     xmm0, xmm1               ; (xmm0) X := Abs(ARadians)
  movaps    xmm3, [rel kSSE_INT_NOT_ONE]
  movaps    xmm1, xmm0
  movaps    xmm4, [rel kSSE_INT_FOUR]
  mulps     xmm1, xmm2
  movaps    xmm2, [rel kSSE_INT_ONE]
  cvtps2dq  xmm1, xmm1               ; J := Trunc(X * FOPI)
  pxor      xmm6, xmm6
  paddd     xmm1, xmm2
  pand      xmm1, xmm3               ; (xmm1) J := (J + 1) and (not 1)
  movaps    xmm3, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm1               ; (xmm2) Y := J
  psubd     xmm1, xmm3               ; J - 2
  movaps    xmm5, xmm1
  pandn     xmm1, xmm4               ; (not (J - 2)) and 4
  pand      xmm5, xmm3               ; (J - 2) and 2
  pslld     xmm1, 29                 ; (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movaps    xmm3, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm5, xmm6               ; (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulps     xmm2, xmm3               ; Y * Pi / 4
  movaps    xmm3, [rel kSSE_COSCOF_P1]
  subps     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  movaps    xmm2, [rel kSSE_COSCOF_P0]
  movaps    xmm4, [rel kSSE_COSCOF_P2]
  movaps    xmm6, xmm0
  mulps     xmm6, xmm6               ; (xmm6) Z := X * X
  mulps     xmm2, xmm6               ; COSCOF_P0 * Z
  addps     xmm2, xmm3               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movaps    xmm3, [rel kSSE_ONE_HALF]
  mulps     xmm2, xmm6               ; Y * Z
  mulps     xmm3, xmm6               ; Z * 0.5
  addps     xmm2, xmm4               ; Y := (Y * Z) + COSCOF_P2
  movaps    xmm7, [rel kSSE_ONE]
  mulps     xmm2, xmm6
  movaps    xmm4, [rel kSSE_SINCOF_P1]
  mulps     xmm2, xmm6               ; Y := Y * (Z * Z)
  subps     xmm2, xmm3               ; Y - Z * 0.5
  addps     xmm2, xmm7               ; (xmm2) Y := Y - Z * 0.5 + 1
  movaps    xmm3, [rel kSSE_SINCOF_P0]
  movaps    xmm7, [rel kSSE_SINCOF_P2]
  mulps     xmm3, xmm6               ; SINCOF_P0 * Z
  addps     xmm3, xmm4               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps     xmm3, xmm6               ; Y2 * Z
  addps     xmm3, xmm7               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulps     xmm3, xmm6               ; Y2 * Z
  mulps     xmm3, xmm0               ; Y2 * (Z * X)
  addps     xmm3, xmm0               ; Y2 := Y2 * (Z * X) + X
  andps     xmm3, xmm5               ; ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm2               ; ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addps     xmm3, xmm5
  xorps     xmm3, xmm1               ; (Y + Y2) xor SignBit
  movaps    xmm0, xmm3
  movhlps   xmm1, xmm3
  ret   
    
_fast_cos_vector4:
  movups    xmm0, [Param1]
  movaps    xmm1, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm2, [rel kSSE_FOPI]
  andps     xmm0, xmm1               ; (xmm0) X := Abs(ARadians)
  movaps    xmm3, [rel kSSE_INT_NOT_ONE]
  movaps    xmm1, xmm0
  movaps    xmm4, [rel kSSE_INT_FOUR]
  mulps     xmm1, xmm2
  movaps    xmm2, [rel kSSE_INT_ONE]
  cvtps2dq  xmm1, xmm1               ; J := Trunc(X * FOPI)
  pxor      xmm6, xmm6
  paddd     xmm1, xmm2
  pand      xmm1, xmm3               ; (xmm1) J := (J + 1) and (not 1)
  movaps    xmm3, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm1               ; (xmm2) Y := J
  psubd     xmm1, xmm3               ; J - 2
  movaps    xmm5, xmm1
  pandn     xmm1, xmm4               ; (not (J - 2)) and 4
  pand      xmm5, xmm3               ; (J - 2) and 2
  pslld     xmm1, 29                 ; (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movaps    xmm3, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm5, xmm6               ; (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulps     xmm2, xmm3               ; Y * Pi / 4
  movaps    xmm3, [rel kSSE_COSCOF_P1]
  subps     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  movaps    xmm2, [rel kSSE_COSCOF_P0]
  movaps    xmm4, [rel kSSE_COSCOF_P2]
  movaps    xmm6, xmm0
  mulps     xmm6, xmm6               ; (xmm6) Z := X * X
  mulps     xmm2, xmm6               ; COSCOF_P0 * Z
  addps     xmm2, xmm3               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movaps    xmm3, [rel kSSE_ONE_HALF]
  mulps     xmm2, xmm6               ; Y * Z
  mulps     xmm3, xmm6               ; Z * 0.5
  addps     xmm2, xmm4               ; Y := (Y * Z) + COSCOF_P2
  movaps    xmm7, [rel kSSE_ONE]
  mulps     xmm2, xmm6
  movaps    xmm4, [rel kSSE_SINCOF_P1]
  mulps     xmm2, xmm6               ; Y := Y * (Z * Z)
  subps     xmm2, xmm3               ; Y - Z * 0.5
  addps     xmm2, xmm7               ; (xmm2) Y := Y - Z * 0.5 + 1
  movaps    xmm3, [rel kSSE_SINCOF_P0]
  movaps    xmm7, [rel kSSE_SINCOF_P2]
  mulps     xmm3, xmm6               ; SINCOF_P0 * Z
  addps     xmm3, xmm4               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps     xmm3, xmm6               ; Y2 * Z
  addps     xmm3, xmm7               ; Y2 := (Y2 * Z) + SINCOF_P2
  mulps     xmm3, xmm6               ; Y2 * Z
  mulps     xmm3, xmm0               ; Y2 * (Z * X)
  addps     xmm3, xmm0               ; Y2 := Y2 * (Z * X) + X
  andps     xmm3, xmm5               ; ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm5, xmm2               ; ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addps     xmm3, xmm5
  xorps     xmm3, xmm1               ; (Y + Y2) xor SignBit
  movaps    xmm0, xmm3
  movhlps   xmm1, xmm3
  ret                                               
  
_fast_sin_cos_single:
  movss     xmm2, [rel kSSE_MASK_SIGN]
  movss     xmm3, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  pand      xmm0, xmm3               ; (xmm0) X := Abs(ARadians)
  pand      xmm1, xmm2               ; (xmm1) SignBitSin
  movaps    xmm4, xmm0
  movss     xmm5, [rel kSSE_FOPI]
  movss     xmm6, [rel kSSE_INT_ONE]
  mulss     xmm4, xmm5
  movss     xmm7, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm4, xmm4               ; (xmm4) J := Trunc(X * FOPI)
  movss     xmm5, [rel kSSE_INT_FOUR]
  paddd     xmm4, xmm6
  pand      xmm4, xmm7               ; (xmm4) J := (J + 1) and (not 1)
  movss     xmm7, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm4               ; (xmm2) Y := J
  movaps    xmm3, xmm4
  movaps    xmm6, xmm4               ; (xmm6) J
  pand      xmm3, xmm5               ; J and 4
  pand      xmm4, xmm7               ; J and 2
  pxor      xmm5, xmm5
  pslld     xmm3, 29                 ; (xmm3) SwapSignBitSin := (J and 4) shl 29
  movss     xmm7, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm4, xmm5               ; (xmm4) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulss     xmm2, xmm7               ; Y * Pi / 4
  movss     xmm5, [rel kSSE_INT_TWO]
  subss     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  psubd     xmm6, xmm5               ; J - 2
  movss     xmm7, [rel kSSE_INT_FOUR]
  pxor      xmm1, xmm3               ; (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps    xmm6, xmm7               ; (not (J - 2)) and 4
  movaps    xmm3, xmm0
  pslld     xmm6, 29                 ; (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulss     xmm3, xmm3               ; (xmm3) Z := X * X
  movss     xmm2, [rel kSSE_COSCOF_P0]
  movss     xmm5, [rel kSSE_COSCOF_P1]
  movss     xmm7, [rel kSSE_COSCOF_P2]
  mulss     xmm2, xmm3               ; COSCOF_P0 * Z
  addss     xmm2, xmm5               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movss     xmm5, [rel kSSE_ONE_HALF]
  mulss     xmm2, xmm3               ; Y * Z
  addss     xmm2, xmm7               ; Y := (Y * Z) + COSCOF_P2
  movss     xmm7, [rel kSSE_ONE]
  mulss     xmm2, xmm3               ; Y * Z
  mulss     xmm5, xmm3               ; 0.5 * Z
  mulss     xmm2, xmm3               ; Y * (Z * Z)
  subss     xmm2, xmm5               ; Y - 0.5 * Z
  movss     xmm5, [rel kSSE_SINCOF_P0]
  addss     xmm2, xmm7               ; (xmm2) Y := Y - 0.5 * Z + 1
  movss     xmm7, [rel kSSE_SINCOF_P1]
  mulss     xmm5, xmm3               ; SINCOF_P0 * Z
  addss     xmm5, xmm7               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulss     xmm5, xmm3               ; Y2 * Z
  movss     xmm7, [rel kSSE_SINCOF_P2]
  addss     xmm5, xmm7               ; Y2 := Y2 * Z + SINCOF_P2
  mulss     xmm5, xmm3               ; Y2 * Z
  mulss     xmm5, xmm0               ; Y2 * (Z * X)
  addss     xmm5, xmm0               ; (xmm5) Y2 := Y2 * (Z * X) + X
  movaps    xmm0, xmm2               ; Y
  movaps    xmm3, xmm5               ; Y2
  andps     xmm5, xmm4               ; ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm4, xmm2               ; ((J and 2) = 0)? Yes: 0 , No: Y
  subss     xmm3, xmm5               ; ((J and 2) = 0)? Yes: 0 , No: Y2
  subss     xmm0, xmm4               ; ((J and 2) = 0)? Yes: Y , No: 0
  addps     xmm4, xmm5               ; ((J and 2) = 0)? Yes: Y2, No: Y
  addps     xmm3, xmm0               ; ((J and 2) = 0)? Yes: Y , No: Y2
  xorps     xmm4, xmm1               ; Sin
  xorps     xmm3, xmm6               ; Cos
  movss     [Param1], xmm4
  movss     [Param2], xmm3
  ret                                                
  
_fast_sin_cos_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm2, [rel kSSE_MASK_SIGN]
  movlps    xmm3, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  pand      xmm0, xmm3               ; (xmm0) X := Abs(ARadians)
  pand      xmm1, xmm2               ; (xmm1) SignBitSin
  movaps    xmm4, xmm0
  movlps    xmm5, [rel kSSE_FOPI]
  movlps    xmm6, [rel kSSE_INT_ONE]
  mulps     xmm4, xmm5
  movlps    xmm7, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm4, xmm4               ; (xmm4) J := Trunc(X * FOPI)
  movlps    xmm5, [rel kSSE_INT_FOUR]
  paddd     xmm4, xmm6
  pand      xmm4, xmm7               ; (xmm4) J := (J + 1) and (not 1)
  movlps    xmm7, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm4               ; (xmm2) Y := J
  movaps    xmm3, xmm4
  movaps    xmm6, xmm4               ; (xmm6) J
  pand      xmm3, xmm5               ; J and 4
  pand      xmm4, xmm7               ; J and 2
  pxor      xmm5, xmm5
  pslld     xmm3, 29                 ; (xmm3) SwapSignBitSin := (J and 4) shl 29
  movlps    xmm7, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm4, xmm5               ; (xmm4) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulps     xmm2, xmm7               ; Y * Pi / 4
  movlps    xmm5, [rel kSSE_INT_TWO]
  subps     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  psubd     xmm6, xmm5               ; J - 2
  movlps    xmm7, [rel kSSE_INT_FOUR]
  pxor      xmm1, xmm3               ; (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps    xmm6, xmm7               ; (not (J - 2)) and 4
  movaps    xmm3, xmm0
  pslld     xmm6, 29                 ; (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulps     xmm3, xmm3               ; (xmm3) Z := X * X
  movlps    xmm2, [rel kSSE_COSCOF_P0]
  movlps    xmm5, [rel kSSE_COSCOF_P1]
  movlps    xmm7, [rel kSSE_COSCOF_P2]
  mulps     xmm2, xmm3               ; COSCOF_P0 * Z
  addps     xmm2, xmm5               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movlps    xmm5, [rel kSSE_ONE_HALF]
  mulps     xmm2, xmm3               ; Y * Z
  addps     xmm2, xmm7               ; Y := (Y * Z) + COSCOF_P2
  movlps    xmm7, [rel kSSE_ONE]
  mulps     xmm2, xmm3               ; Y * Z
  mulps     xmm5, xmm3               ; 0.5 * Z
  mulps     xmm2, xmm3               ; Y * (Z * Z)
  subps     xmm2, xmm5               ; Y - 0.5 * Z
  movlps    xmm5, [rel kSSE_SINCOF_P0]
  addps     xmm2, xmm7               ; (xmm2) Y := Y - 0.5 * Z + 1
  movlps    xmm7, [rel kSSE_SINCOF_P1]
  mulps     xmm5, xmm3               ; SINCOF_P0 * Z
  addps     xmm5, xmm7               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps     xmm5, xmm3               ; Y2 * Z
  movlps    xmm7, [rel kSSE_SINCOF_P2]
  addps     xmm5, xmm7               ; Y2 := Y2 * Z + SINCOF_P2
  mulps     xmm5, xmm3               ; Y2 * Z
  mulps     xmm5, xmm0               ; Y2 * (Z * X)
  addps     xmm5, xmm0               ; (xmm5) Y2 := Y2 * (Z * X) + X
  movaps    xmm0, xmm2               ; Y
  movaps    xmm3, xmm5               ; Y2
  andps     xmm5, xmm4               ; ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm4, xmm2               ; ((J and 2) = 0)? Yes: 0 , No: Y
  subps     xmm3, xmm5               ; ((J and 2) = 0)? Yes: 0 , No: Y2
  subps     xmm0, xmm4               ; ((J and 2) = 0)? Yes: Y , No: 0
  addps     xmm4, xmm5               ; ((J and 2) = 0)? Yes: Y2, No: Y
  addps     xmm3, xmm0               ; ((J and 2) = 0)? Yes: Y , No: Y2
  xorps     xmm4, xmm1               ; Sin
  xorps     xmm3, xmm6               ; Cos
  movlps    [Param2], xmm4
  movlps    [Param3], xmm3
  ret   
    
_fast_sin_cos_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movaps    xmm2, [rel kSSE_MASK_SIGN]
  movaps    xmm3, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  pand      xmm0, xmm3               ; (xmm0) X := Abs(ARadians)
  pand      xmm1, xmm2               ; (xmm1) SignBitSin
  movaps    xmm4, xmm0
  movaps    xmm5, [rel kSSE_FOPI]
  movaps    xmm6, [rel kSSE_INT_ONE]
  mulps     xmm4, xmm5
  movaps    xmm7, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm4, xmm4               ; (xmm4) J := Trunc(X * FOPI)
  movaps    xmm5, [rel kSSE_INT_FOUR]
  paddd     xmm4, xmm6
  pand      xmm4, xmm7               ; (xmm4) J := (J + 1) and (not 1)
  movaps    xmm7, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm4               ; (xmm2) Y := J
  movaps    xmm3, xmm4
  movaps    xmm6, xmm4               ; (xmm6) J
  pand      xmm3, xmm5               ; J and 4
  pand      xmm4, xmm7               ; J and 2
  pxor      xmm5, xmm5
  pslld     xmm3, 29                 ; (xmm3) SwapSignBitSin := (J and 4) shl 29
  movaps    xmm7, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm4, xmm5               ; (xmm4) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulps     xmm2, xmm7               ; Y * Pi / 4
  movaps    xmm5, [rel kSSE_INT_TWO]
  subps     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  psubd     xmm6, xmm5               ; J - 2
  movaps    xmm7, [rel kSSE_INT_FOUR]
  pxor      xmm1, xmm3               ; (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps    xmm6, xmm7               ; (not (J - 2)) and 4
  movaps    xmm3, xmm0
  pslld     xmm6, 29                 ; (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulps     xmm3, xmm3               ; (xmm3) Z := X * X
  movaps    xmm2, [rel kSSE_COSCOF_P0]
  movaps    xmm5, [rel kSSE_COSCOF_P1]
  movaps    xmm7, [rel kSSE_COSCOF_P2]
  mulps     xmm2, xmm3               ; COSCOF_P0 * Z
  addps     xmm2, xmm5               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movaps    xmm5, [rel kSSE_ONE_HALF]
  mulps     xmm2, xmm3               ; Y * Z
  addps     xmm2, xmm7               ; Y := (Y * Z) + COSCOF_P2
  movaps    xmm7, [rel kSSE_ONE]
  mulps     xmm2, xmm3               ; Y * Z
  mulps     xmm5, xmm3               ; 0.5 * Z
  mulps     xmm2, xmm3               ; Y * (Z * Z)
  subps     xmm2, xmm5               ; Y - 0.5 * Z
  movaps    xmm5, [rel kSSE_SINCOF_P0]
  addps     xmm2, xmm7               ; (xmm2) Y := Y - 0.5 * Z + 1
  movaps    xmm7, [rel kSSE_SINCOF_P1]
  mulps     xmm5, xmm3               ; SINCOF_P0 * Z
  addps     xmm5, xmm7               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps     xmm5, xmm3               ; Y2 * Z
  movaps    xmm7, [rel kSSE_SINCOF_P2]
  addps     xmm5, xmm7               ; Y2 := Y2 * Z + SINCOF_P2
  mulps     xmm5, xmm3               ; Y2 * Z
  mulps     xmm5, xmm0               ; Y2 * (Z * X)
  addps     xmm5, xmm0               ; (xmm5) Y2 := Y2 * (Z * X) + X
  movaps    xmm0, xmm2               ; Y
  movaps    xmm3, xmm5               ; Y2
  andps     xmm5, xmm4               ; ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm4, xmm2               ; ((J and 2) = 0)? Yes: 0 , No: Y
  subps     xmm3, xmm5               ; ((J and 2) = 0)? Yes: 0 , No: Y2
  subps     xmm0, xmm4               ; ((J and 2) = 0)? Yes: Y , No: 0
  addps     xmm4, xmm5               ; ((J and 2) = 0)? Yes: Y2, No: Y
  addps     xmm3, xmm0               ; ((J and 2) = 0)? Yes: Y , No: Y2
  xorps     xmm4, xmm1               ; Sin
  xorps     xmm3, xmm6               ; Cos
  movhlps   xmm5, xmm4
  movhlps   xmm2, xmm3
  movq      [Param2], xmm4
  movss     [Param2+8], xmm5
  movq      [Param3], xmm3
  movss     [Param3+8], xmm2
  ret   
    
_fast_sin_cos_vector4:
  movups    xmm0, [Param1]
  movaps    xmm2, [rel kSSE_MASK_SIGN]
  movaps    xmm3, [rel kSSE_MASK_ABS_VAL]
  movaps    xmm1, xmm0
  pand      xmm0, xmm3               ; (xmm0) X := Abs(ARadians)
  pand      xmm1, xmm2               ; (xmm1) SignBitSin
  movaps    xmm4, xmm0
  movaps    xmm5, [rel kSSE_FOPI]
  movaps    xmm6, [rel kSSE_INT_ONE]
  mulps     xmm4, xmm5
  movaps    xmm7, [rel kSSE_INT_NOT_ONE]
  cvtps2dq  xmm4, xmm4               ; (xmm4) J := Trunc(X * FOPI)
  movaps    xmm5, [rel kSSE_INT_FOUR]
  paddd     xmm4, xmm6
  pand      xmm4, xmm7               ; (xmm4) J := (J + 1) and (not 1)
  movaps    xmm7, [rel kSSE_INT_TWO]
  cvtdq2ps  xmm2, xmm4               ; (xmm2) Y := J
  movaps    xmm3, xmm4
  movaps    xmm6, xmm4               ; (xmm6) J
  pand      xmm3, xmm5               ; J and 4
  pand      xmm4, xmm7               ; J and 2
  pxor      xmm5, xmm5
  pslld     xmm3, 29                 ; (xmm3) SwapSignBitSin := (J and 4) shl 29
  movaps    xmm7, [rel kSSE_PI_OVER_4]
  pcmpeqd   xmm4, xmm5               ; (xmm4) PolyMask := ((J and 2) = 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  mulps     xmm2, xmm7               ; Y * Pi / 4
  movaps    xmm5, [rel kSSE_INT_TWO]
  subps     xmm0, xmm2               ; (xmm0) X := X - (Y * Pi / 4)
  psubd     xmm6, xmm5               ; J - 2
  movaps    xmm7, [rel kSSE_INT_FOUR]
  pxor      xmm1, xmm3               ; (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps    xmm6, xmm7               ; (not (J - 2)) and 4
  movaps    xmm3, xmm0
  pslld     xmm6, 29                 ; (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulps     xmm3, xmm3               ; (xmm3) Z := X * X
  movaps    xmm2, [rel kSSE_COSCOF_P0]
  movaps    xmm5, [rel kSSE_COSCOF_P1]
  movaps    xmm7, [rel kSSE_COSCOF_P2]
  mulps     xmm2, xmm3               ; COSCOF_P0 * Z
  addps     xmm2, xmm5               ; Y := COSCOF_P0 * Z + COSCOF_P1
  movaps    xmm5, [rel kSSE_ONE_HALF]
  mulps     xmm2, xmm3               ; Y * Z
  addps     xmm2, xmm7               ; Y := (Y * Z) + COSCOF_P2
  movaps    xmm7, [rel kSSE_ONE]
  mulps     xmm2, xmm3               ; Y * Z
  mulps     xmm5, xmm3               ; 0.5 * Z
  mulps     xmm2, xmm3               ; Y * (Z * Z)
  subps     xmm2, xmm5               ; Y - 0.5 * Z
  movaps    xmm5, [rel kSSE_SINCOF_P0]
  addps     xmm2, xmm7               ; (xmm2) Y := Y - 0.5 * Z + 1
  movaps    xmm7, [rel kSSE_SINCOF_P1]
  mulps     xmm5, xmm3               ; SINCOF_P0 * Z
  addps     xmm5, xmm7               ; Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps     xmm5, xmm3               ; Y2 * Z
  movaps    xmm7, [rel kSSE_SINCOF_P2]
  addps     xmm5, xmm7               ; Y2 := Y2 * Z + SINCOF_P2
  mulps     xmm5, xmm3               ; Y2 * Z
  mulps     xmm5, xmm0               ; Y2 * (Z * X)
  addps     xmm5, xmm0               ; (xmm5) Y2 := Y2 * (Z * X) + X
  movaps    xmm0, xmm2               ; Y
  movaps    xmm3, xmm5               ; Y2
  andps     xmm5, xmm4               ; ((J and 2) = 0)? Yes: Y2, No: 0
  andnps    xmm4, xmm2               ; ((J and 2) = 0)? Yes: 0 , No: Y
  subps     xmm3, xmm5               ; ((J and 2) = 0)? Yes: 0 , No: Y2
  subps     xmm0, xmm4               ; ((J and 2) = 0)? Yes: Y , No: 0
  addps     xmm4, xmm5               ; ((J and 2) = 0)? Yes: Y2, No: Y
  addps     xmm3, xmm0               ; ((J and 2) = 0)? Yes: Y , No: Y2
  xorps     xmm4, xmm1               ; Sin
  xorps     xmm3, xmm6               ; Cos
  movups    [Param2], xmm4
  movups    [Param3], xmm3
  ret                                                       
  
_fast_exp_single:    
  movss     xmm1, [rel kSSE_EXP_A1]
  movss     xmm2, [rel kSSE_EXP_A2]

  ; Val := 12102203.1615614 * A + 1065353216.0
  mulss     xmm0, xmm1
  movss     xmm3, [rel kSSE_EXP_CST]
  addss     xmm0, xmm2

  ; if (Val >= EXP_CST) then Val := EXP_CST
  movss     xmm1, xmm0
  cmpltss   xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm0 ; (Val < EXP_CST)? Yes: Val, No: 0
  andnps    xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps      xmm0, xmm1 ; (Val < EXP_CST)? Yes: Val, No: EXP_CST

  ; IVal := Trunc(Val)
  xorps     xmm3, xmm3
  cvtps2dq  xmm1, xmm0

  ; if (IVal < 0) then I := 0
  movss     xmm2, [rel kSSE_MASK_EXPONENT]
  movdqa    xmm0, xmm1 ; IVal
  pcmpgtd   xmm1, xmm3 ; (IVal > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movss     xmm3, [rel kSSE_MASK_FRACTION]
  pand      xmm0, xmm1 ; (IVal > 0)? Yes: IVal, No: 0

  ; XU.I := IVal and 0x7F800000
  movss     xmm4, [rel kSSE_EXP_I1]
  movss     xmm1, xmm0
  pand      xmm0, xmm2 ; XU.I / XU.S

  ; XU2.I := (IVal and 0x007FFFFF) or 0x3F800000;
  pand      xmm1, xmm3
  movss     xmm6, [rel kSSE_EXP_F5]
  por       xmm1, xmm4 ; XU2.I / XU2.S

  ;  Result := XU.S *
  ;    ( 0.509964287281036376953125 + B *
  ;    ( 0.3120158612728118896484375 + B *
  ;    ( 0.1666135489940643310546875 + B *
  ;    (-2.12528370320796966552734375e-3 + B *
  ;      1.3534179888665676116943359375e-2))));
  movss     xmm5, [rel kSSE_EXP_F4]
  movss     xmm7, xmm1

  mulss     xmm1, xmm6
  movss     xmm4, [rel kSSE_EXP_F3]
  addss     xmm1, xmm5
  movss     xmm3, [rel kSSE_EXP_F2]
  mulss     xmm1, xmm7
  movss     xmm2, [rel kSSE_EXP_F1]
  addss     xmm1, xmm4
  mulss     xmm1, xmm7
  addss     xmm1, xmm3
  mulss     xmm1, xmm7
  addss     xmm1, xmm2
  mulss     xmm1, xmm0

  movss     xmm0, xmm1
  ret
  
_fast_exp_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [rel kSSE_EXP_A1]
  movlps    xmm2, [rel kSSE_EXP_A2]

  ; Val := 12102203.1615614 * A + 1065353216.0
  mulps     xmm0, xmm1
  movlps    xmm3, [rel kSSE_EXP_CST]
  addps     xmm0, xmm2

  ; if (Val >= EXP_CST) then Val := EXP_CST
  movaps    xmm1, xmm0
  cmpltps   xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm0 ; (Val < EXP_CST)? Yes: Val, No: 0
  andnps    xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps      xmm0, xmm1 ; (Val < EXP_CST)? Yes: Val, No: EXP_CST

  ; IVal := Trunc(Val)
  xorps     xmm3, xmm3
  cvtps2dq  xmm1, xmm0

  ; if (IVal < 0) then I := 0
  movlps    xmm2, [rel kSSE_MASK_EXPONENT]
  movdqa    xmm0, xmm1 ; IVal
  pcmpgtd   xmm1, xmm3 ; (IVal > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movlps    xmm3, [rel kSSE_MASK_FRACTION]
  pand      xmm0, xmm1 ; (IVal > 0)? Yes: IVal, No: 0

  ; XU.I := IVal and 0x7F800000
  movlps    xmm4, [rel kSSE_EXP_I1]
  movdqa    xmm1, xmm0
  pand      xmm0, xmm2 ; XU.I / XU.S

  ; XU2.I := (IVal and 0x007FFFFF) or 0x3F800000;
  pand      xmm1, xmm3
  movlps    xmm6, [rel kSSE_EXP_F5]
  por       xmm1, xmm4 ; XU2.I / XU2.S

  ;  Result := XU.S *
  ;    ( 0.509964287281036376953125 + B *
  ;    ( 0.3120158612728118896484375 + B *
  ;    ( 0.1666135489940643310546875 + B *
  ;    (-2.12528370320796966552734375e-3 + B *
  ;      1.3534179888665676116943359375e-2))));
  movlps    xmm5, [rel kSSE_EXP_F4]
  movaps    xmm7, xmm1

  mulps     xmm1, xmm6
  movlps    xmm4, [rel kSSE_EXP_F3]
  addps     xmm1, xmm5
  movlps    xmm3, [rel kSSE_EXP_F2]
  mulps     xmm1, xmm7
  movlps    xmm2, [rel kSSE_EXP_F1]
  addps     xmm1, xmm4
  mulps     xmm1, xmm7
  addps     xmm1, xmm3
  mulps     xmm1, xmm7
  addps     xmm1, xmm2
  mulps     xmm1, xmm0
  movaps    xmm0, xmm1
  ret
  
_fast_exp_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movaps    xmm1, [rel kSSE_EXP_A1]
  movaps    xmm2, [rel kSSE_EXP_A2]

  ; Val := 12102203.1615614 * A + 1065353216.0
  mulps     xmm0, xmm1
  movaps    xmm3, [rel kSSE_EXP_CST]
  addps     xmm0, xmm2

  ; if (Val >= EXP_CST) then Val := EXP_CST
  movaps    xmm1, xmm0
  cmpltps   xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm0 ; (Val < EXP_CST)? Yes: Val, No: 0
  andnps    xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps      xmm0, xmm1 ; (Val < EXP_CST)? Yes: Val, No: EXP_CST

  ; IVal := Trunc(Val)
  xorps     xmm3, xmm3
  cvtps2dq  xmm1, xmm0

  ; if (IVal < 0) then I := 0
  movaps    xmm2, [rel kSSE_MASK_EXPONENT]
  movdqa    xmm0, xmm1 ; IVal
  pcmpgtd   xmm1, xmm3 ; (IVal > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movaps    xmm3, [rel kSSE_MASK_FRACTION]
  pand      xmm0, xmm1 ; (IVal > 0)? Yes: IVal, No: 0

  ; XU.I := IVal and 0x7F800000
  movaps    xmm4, [rel kSSE_EXP_I1]
  movdqa    xmm1, xmm0
  pand      xmm0, xmm2 ; XU.I / XU.S

  ; XU2.I := (IVal and 0x007FFFFF) or 0x3F800000;
  pand      xmm1, xmm3
  movaps    xmm6, [rel kSSE_EXP_F5]
  por       xmm1, xmm4 ; XU2.I / XU2.S

  ;  Result := XU.S *
  ;    ( 0.509964287281036376953125 + B *
  ;    ( 0.3120158612728118896484375 + B *
  ;    ( 0.1666135489940643310546875 + B *
  ;    (-2.12528370320796966552734375e-3 + B *
  ;      1.3534179888665676116943359375e-2))));
  movaps    xmm5, [rel kSSE_EXP_F4]
  movaps    xmm7, xmm1

  mulps     xmm1, xmm6
  movaps    xmm4, [rel kSSE_EXP_F3]
  addps     xmm1, xmm5
  movaps    xmm3, [rel kSSE_EXP_F2]
  mulps     xmm1, xmm7
  movaps    xmm2, [rel kSSE_EXP_F1]
  addps     xmm1, xmm4
  mulps     xmm1, xmm7
  addps     xmm1, xmm3
  mulps     xmm1, xmm7
  addps     xmm1, xmm2
  mulps     xmm1, xmm0
  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_fast_exp_vector4:
  movups    xmm0, [Param1]
  movaps    xmm1, [rel kSSE_EXP_A1]
  movaps    xmm2, [rel kSSE_EXP_A2]

  ; Val := 12102203.1615614 * A + 1065353216.0
  mulps     xmm0, xmm1
  movaps    xmm3, [rel kSSE_EXP_CST]
  addps     xmm0, xmm2

  ; if (Val >= EXP_CST) then Val := EXP_CST
  movaps    xmm1, xmm0
  cmpltps   xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm0 ; (Val < EXP_CST)? Yes: Val, No: 0
  andnps    xmm0, xmm3 ; (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps      xmm0, xmm1 ; (Val < EXP_CST)? Yes: Val, No: EXP_CST

  ; IVal := Trunc(Val)
  xorps     xmm3, xmm3
  cvtps2dq  xmm1, xmm0

  ; if (IVal < 0) then I := 0
  movaps    xmm2, [rel kSSE_MASK_EXPONENT]
  movdqa    xmm0, xmm1 ; IVal
  pcmpgtd   xmm1, xmm3 ; (IVal > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movaps    xmm3, [rel kSSE_MASK_FRACTION]
  pand      xmm0, xmm1 ; (IVal > 0)? Yes: IVal, No: 0

  ; XU.I := IVal and 0x7F800000
  movaps    xmm4, [rel kSSE_EXP_I1]
  movdqa    xmm1, xmm0
  pand      xmm0, xmm2 ; XU.I / XU.S

  ; XU2.I := (IVal and 0x007FFFFF) or 0x3F800000;
  pand      xmm1, xmm3
  movaps    xmm6, [rel kSSE_EXP_F5]
  por       xmm1, xmm4 ; XU2.I / XU2.S

  ;  Result := XU.S *
  ;    ( 0.509964287281036376953125 + B *
  ;    ( 0.3120158612728118896484375 + B *
  ;    ( 0.1666135489940643310546875 + B *
  ;    (-2.12528370320796966552734375e-3 + B *
  ;      1.3534179888665676116943359375e-2))));
  movaps    xmm5, [rel kSSE_EXP_F4]
  movaps    xmm7, xmm1

  mulps     xmm1, xmm6
  movaps    xmm4, [rel kSSE_EXP_F3]
  addps     xmm1, xmm5
  movaps    xmm3, [rel kSSE_EXP_F2]
  mulps     xmm1, xmm7
  movaps    xmm2, [rel kSSE_EXP_F1]
  addps     xmm1, xmm4
  mulps     xmm1, xmm7
  addps     xmm1, xmm3
  mulps     xmm1, xmm7
  addps     xmm1, xmm2
  mulps     xmm1, xmm0
  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_fast_ln_single:  
  xorps     xmm2, xmm2
  movss     xmm1, xmm0
  movss     xmm3, [rel kSSE_LN_CST]
  movss     xmm4, [rel kSSE_NEG_INFINITY]

  ; Exp := Val.I shr 23
  psrld     xmm0, 23
  movss     xmm5, xmm1
  cvtdq2ps  xmm0, xmm0 ; xmm0=Exp

  ; if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnless  xmm1, xmm2 ; (A > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movss     xmm2, [rel kSSE_MASK_FRACTION]
  andps     xmm3, xmm1 ; (A > 0)? Yes: -89.93423858, No: 0
  andnps    xmm1, xmm4 ; (A > 0)? Yes: 0, No: NegInfinity
  movss     xmm4, [rel kSSE_EXP_I1]
  orps      xmm1, xmm3 ; (A > 0)? Yes: -89.93423858, No: NegInfinity

  ; Val.I := (Val.I and 0x007FFFFF) or 0x3F800000
  pand      xmm5, xmm2
  movss     xmm2, [rel kSSE_LN_F5]
  por       xmm5, xmm4
  movss     xmm6, [rel kSSE_LN_F3]
  movss     xmm3, xmm5 ; xmm3=X
  mulss     xmm5, xmm5 ; xmm5=X2

  movss     xmm4, xmm3
  movss     xmm7, [rel kSSE_LN_F4]
  mulss     xmm4, xmm6
  mulss     xmm0, xmm2 ; xmm0 = Exp * 0.69314718055995
  subss     xmm4, xmm7
  movss     xmm7, [rel kSSE_LN_F2]
  movss     xmm6, xmm3
  mulss     xmm4, xmm5 ; xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subss     xmm6, xmm7
  movss     xmm2, [rel kSSE_LN_F1]
  addss     xmm4, xmm6 ; xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulss     xmm3, xmm2
  mulss     xmm4, xmm5 ; xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addss     xmm3, xmm1 ; xmm3 = (3.3977745 * X + AddCst)
  addss     xmm4, xmm0
  addss     xmm3, xmm4

  movss     xmm0, xmm3
  ret
  
_fast_ln_vector2:  
  movlps    xmm0, [Param1]
  xorps     xmm2, xmm2
  movaps    xmm1, xmm0
  movlps    xmm3, [rel kSSE_LN_CST]
  movlps    xmm4, [rel kSSE_NEG_INFINITY]

  ; Exp := Val.I shr 23
  psrld     xmm0, 23
  movaps    xmm5, xmm1
  cvtdq2ps  xmm0, xmm0 ; xmm0=Exp

  ; if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnleps  xmm1, xmm2 ; (A > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movlps    xmm2, [rel kSSE_MASK_FRACTION]
  andps     xmm3, xmm1 ; (A > 0)? Yes: -89.93423858, No: 0
  andnps    xmm1, xmm4 ; (A > 0)? Yes: 0, No: NegInfinity
  movlps    xmm4, [rel kSSE_EXP_I1]
  orps      xmm1, xmm3 ; (A > 0)? Yes: -89.93423858, No: NegInfinity

  ; Val.I := (Val.I and 0x007FFFFF) or 0x3F800000
  pand      xmm5, xmm2
  movlps    xmm2, [rel kSSE_LN_F5]
  por       xmm5, xmm4
  movlps    xmm6, [rel kSSE_LN_F3]
  movaps    xmm3, xmm5 ; xmm3=X
  mulps     xmm5, xmm5 ; xmm5=X2

  movaps    xmm4, xmm3
  movlps    xmm7, [rel kSSE_LN_F4]
  mulps     xmm4, xmm6
  mulps     xmm0, xmm2 ; xmm0 = Exp * 0.69314718055995
  subps     xmm4, xmm7
  movlps    xmm7, [rel kSSE_LN_F2]
  movaps    xmm6, xmm3
  mulps     xmm4, xmm5 ; xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subps     xmm6, xmm7
  movlps    xmm2, [rel kSSE_LN_F1]
  addps     xmm4, xmm6 ; xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulps     xmm3, xmm2
  mulps     xmm4, xmm5 ; xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addps     xmm3, xmm1 ; xmm3 = (3.3977745 * X + AddCst)
  addps     xmm4, xmm0
  addps     xmm3, xmm4
  
  movaps    xmm0, xmm3
  ret
  
_fast_ln_vector3:  
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  xorps     xmm2, xmm2
  movaps    xmm1, xmm0
  movaps    xmm3, [rel kSSE_LN_CST]
  movaps    xmm4, [rel kSSE_NEG_INFINITY]

  ; Exp := Val.I shr 23
  psrld     xmm0, 23
  movaps    xmm5, xmm1
  cvtdq2ps  xmm0, xmm0 ; xmm0=Exp

  ; if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnleps  xmm1, xmm2 ; (A > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movaps    xmm2, [rel kSSE_MASK_FRACTION]
  andps     xmm3, xmm1 ; (A > 0)? Yes: -89.93423858, No: 0
  andnps    xmm1, xmm4 ; (A > 0)? Yes: 0, No: NegInfinity
  movaps    xmm4, [rel kSSE_EXP_I1]
  orps      xmm1, xmm3 ; (A > 0)? Yes: -89.93423858, No: NegInfinity

  ; Val.I := (Val.I and 0x007FFFFF) or 0x3F800000
  pand      xmm5, xmm2
  movaps    xmm2, [rel kSSE_LN_F5]
  por       xmm5, xmm4
  movaps    xmm6, [rel kSSE_LN_F3]
  movaps    xmm3, xmm5 ; xmm3=X
  mulps     xmm5, xmm5 ; xmm5=X2

  movaps    xmm4, xmm3
  movaps    xmm7, [rel kSSE_LN_F4]
  mulps     xmm4, xmm6
  mulps     xmm0, xmm2 ; xmm0 = Exp * 0.69314718055995
  subps     xmm4, xmm7
  movaps    xmm7, [rel kSSE_LN_F2]
  movaps    xmm6, xmm3
  mulps     xmm4, xmm5 ; xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subps     xmm6, xmm7
  movaps    xmm2, [rel kSSE_LN_F1]
  addps     xmm4, xmm6 ; xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulps     xmm3, xmm2
  mulps     xmm4, xmm5 ; xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addps     xmm3, xmm1 ; xmm3 = (3.3977745 * X + AddCst)
  addps     xmm4, xmm0
  addps     xmm3, xmm4

  movaps    xmm0, xmm3
  movhlps   xmm1, xmm3
  ret
  
_fast_ln_vector4:  
  movups    xmm0, [Param1]
  xorps     xmm2, xmm2
  movaps    xmm1, xmm0
  movaps    xmm3, [rel kSSE_LN_CST]
  movaps    xmm4, [rel kSSE_NEG_INFINITY]

  ; Exp := Val.I shr 23
  psrld     xmm0, 23
  movaps    xmm5, xmm1
  cvtdq2ps  xmm0, xmm0 ; xmm0=Exp

  ; if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnleps  xmm1, xmm2 ; (A > 0)? Yes: 0xFFFFFFFF, No: 0x00000000
  movaps    xmm2, [rel kSSE_MASK_FRACTION]
  andps     xmm3, xmm1 ; (A > 0)? Yes: -89.93423858, No: 0
  andnps    xmm1, xmm4 ; (A > 0)? Yes: 0, No: NegInfinity
  movaps    xmm4, [rel kSSE_EXP_I1]
  orps      xmm1, xmm3 ; (A > 0)? Yes: -89.93423858, No: NegInfinity

  ; Val.I := (Val.I and 0x007FFFFF) or 0x3F800000
  pand      xmm5, xmm2
  movaps    xmm2, [rel kSSE_LN_F5]
  por       xmm5, xmm4
  movaps    xmm6, [rel kSSE_LN_F3]
  movaps    xmm3, xmm5 ; xmm3=X
  mulps     xmm5, xmm5 ; xmm5=X2

  movaps    xmm4, xmm3
  movaps    xmm7, [rel kSSE_LN_F4]
  mulps     xmm4, xmm6
  mulps     xmm0, xmm2 ; xmm0 = Exp * 0.69314718055995
  subps     xmm4, xmm7
  movaps    xmm7, [rel kSSE_LN_F2]
  movaps    xmm6, xmm3
  mulps     xmm4, xmm5 ; xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subps     xmm6, xmm7
  movaps    xmm2, [rel kSSE_LN_F1]
  addps     xmm4, xmm6 ; xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulps     xmm3, xmm2
  mulps     xmm4, xmm5 ; xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addps     xmm3, xmm1 ; xmm3 = (3.3977745 * X + AddCst)
  addps     xmm4, xmm0
  addps     xmm3, xmm4

  movaps    xmm0, xmm3
  movhlps   xmm1, xmm3
  ret

_fast_log2_single:  
  movss     xmm2, [rel kSSE_MASK_FRACTION]
  movss     xmm1, xmm0

  ; MX.I := (VX.I and 0x007FFFFF) or 0x3F000000
  movss     xmm3, [rel kSSE_LOG2_I1]
  pand      xmm0, xmm2
  cvtdq2ps  xmm1, xmm1
  movss     xmm4, [rel kSSE_LOG2_F1]
  por       xmm0, xmm3

  movss     xmm2, [rel kSSE_LOG2_F2]
  mulss     xmm1, xmm4 ; VX.I * 1.1920928955078125e-7
  movss     xmm3, [rel kSSE_LOG2_F3]
  subss     xmm1, xmm2 ; Result - 124.22551499
  mulss     xmm3, xmm0
  movss     xmm4, [rel kSSE_LOG2_F5]
  subss     xmm1, xmm3 ; Result - 124.22551499 - 1.498030302 * MX.S
  movss     xmm2, [rel kSSE_LOG2_F4]
  addss     xmm0, xmm4
  divss     xmm2, xmm0
  subss     xmm1, xmm2 ; Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movss     xmm0, xmm1
  ret
  
_fast_log2_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm2, [rel kSSE_MASK_FRACTION]
  movaps    xmm1, xmm0

  ; MX.I := (VX.I and 0x007FFFFF) or 0x3F000000
  movlps    xmm3, [rel kSSE_LOG2_I1]
  pand      xmm0, xmm2
  cvtdq2ps  xmm1, xmm1
  movlps    xmm4, [rel kSSE_LOG2_F1]
  por       xmm0, xmm3

  movlps    xmm2, [rel kSSE_LOG2_F2]
  mulps     xmm1, xmm4 ; VX.I * 1.1920928955078125e-7
  movlps    xmm3, [rel kSSE_LOG2_F3]
  subps     xmm1, xmm2 ; Result - 124.22551499
  mulps     xmm3, xmm0
  movlps    xmm4, [rel kSSE_LOG2_F5]
  subps     xmm1, xmm3 ; Result - 124.22551499 - 1.498030302 * MX.S
  movlps    xmm2, [rel kSSE_LOG2_F4]
  addps     xmm0, xmm4
  divps     xmm2, xmm0
  subps     xmm1, xmm2 ; Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movaps    xmm0, xmm1
  ret
  
_fast_log2_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movaps    xmm2, [rel kSSE_MASK_FRACTION]
  movaps    xmm1, xmm0

  ; MX.I := (VX.I and 0x007FFFFF) or 0x3F000000
  movaps    xmm3, [rel kSSE_LOG2_I1]
  pand      xmm0, xmm2
  cvtdq2ps  xmm1, xmm1
  movaps    xmm4, [rel kSSE_LOG2_F1]
  por       xmm0, xmm3

  movaps    xmm2, [rel kSSE_LOG2_F2]
  mulps     xmm1, xmm4 ; VX.I * 1.1920928955078125e-7
  movaps    xmm3, [rel kSSE_LOG2_F3]
  subps     xmm1, xmm2 ; Result - 124.22551499
  mulps     xmm3, xmm0
  movaps    xmm4, [rel kSSE_LOG2_F5]
  subps     xmm1, xmm3 ; Result - 124.22551499 - 1.498030302 * MX.S
  movaps    xmm2, [rel kSSE_LOG2_F4]
  addps     xmm0, xmm4
  divps     xmm2, xmm0
  subps     xmm1, xmm2 ; Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_fast_log2_vector4:
  movups    xmm0, [Param1]
  movaps    xmm2, [rel kSSE_MASK_FRACTION]
  movaps    xmm1, xmm0

  ; MX.I := (VX.I and 0x007FFFFF) or 0x3F000000
  movaps    xmm3, [rel kSSE_LOG2_I1]
  pand      xmm0, xmm2
  cvtdq2ps  xmm1, xmm1
  movaps    xmm4, [rel kSSE_LOG2_F1]
  por       xmm0, xmm3

  movaps    xmm2, [rel kSSE_LOG2_F2]
  mulps     xmm1, xmm4 ; VX.I * 1.1920928955078125e-7
  movaps    xmm3, [rel kSSE_LOG2_F3]
  subps     xmm1, xmm2 ; Result - 124.22551499
  mulps     xmm3, xmm0
  movaps    xmm4, [rel kSSE_LOG2_F5]
  subps     xmm1, xmm3 ; Result - 124.22551499 - 1.498030302 * MX.S
  movaps    xmm2, [rel kSSE_LOG2_F4]
  addps     xmm0, xmm4
  divps     xmm2, xmm0
  subps     xmm1, xmm2 ; Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_fast_exp2_single:
  ; Set rounding mode to Round Positive (=Round Down)
  stmxcsr   [OldFlags]
  mov       ecx, [OldFlags]
  xorps     xmm1, xmm1
  and       ecx, SSE_ROUND_MASK
  movss     xmm3, xmm0
  or        ecx, SSE_ROUND_DOWN
  movss     xmm5, xmm0
  mov       [NewFlags], ecx

  movss     xmm1, [rel kSSE_EXP2_F1]
  ldmxcsr   [NewFlags]

  ; Z := A - RoundDown(A)
  cvtps2dq  xmm3, xmm3
  addss     xmm1, xmm5 ; A + 121.2740575
  cvtdq2ps  xmm3, xmm3
  movss     xmm2, [rel kSSE_EXP2_F2]
  subss     xmm0, xmm3

  movss     xmm3, [rel kSSE_EXP2_F3]
  movss     xmm4, [rel kSSE_EXP2_F4]
  subss     xmm3, xmm0 ; (4.84252568 - Z)
  mulss     xmm0, xmm4 ; 1.49012907 * Z
  divss     xmm2, xmm3
  movss     xmm5, [rel kSSE_EXP2_F5]
  addss     xmm1, xmm2 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subss     xmm1, xmm0 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulss     xmm1, xmm5 ; (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq  xmm1, xmm1

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movss     xmm0, xmm1
  ret
  
_fast_exp2_vector2:
  ; Set rounding mode to Round Positive (=Round Down)
  stmxcsr   [OldFlags]
  movlps    xmm0, [Param1]
  mov       ecx, [OldFlags]
  xorps     xmm1, xmm1
  and       ecx, SSE_ROUND_MASK
  movaps    xmm3, xmm0
  or        ecx, SSE_ROUND_DOWN
  movaps    xmm5, xmm0
  mov       [NewFlags], ecx

  movlps    xmm1, [rel kSSE_EXP2_F1]
  ldmxcsr   [NewFlags]

  ; Z := A - RoundDown(A)
  cvtps2dq  xmm3, xmm3
  addps     xmm1, xmm5 ; A + 121.2740575
  cvtdq2ps  xmm3, xmm3
  movlps    xmm2, [rel kSSE_EXP2_F2]
  subps     xmm0, xmm3

  movlps    xmm3, [rel kSSE_EXP2_F3]
  movlps    xmm4, [rel kSSE_EXP2_F4]
  subps     xmm3, xmm0 ; (4.84252568 - Z)
  mulps     xmm0, xmm4 ; 1.49012907 * Z
  divps     xmm2, xmm3
  movlps    xmm5, [rel kSSE_EXP2_F5]
  addps     xmm1, xmm2 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subps     xmm1, xmm0 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulps     xmm1, xmm5 ; (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq  xmm1, xmm1

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movaps    xmm0, xmm1
  ret
  
_fast_exp2_vector3:
  ; Set rounding mode to Round Positive (=Round Down)
  stmxcsr   [OldFlags]
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  mov       edx, [OldFlags]
  xorps     xmm1, xmm1
  and       edx, SSE_ROUND_MASK
  movaps    xmm3, xmm0
  or        edx, SSE_ROUND_DOWN
  movaps    xmm5, xmm0
  mov       [NewFlags], edx

  movaps    xmm1, [rel kSSE_EXP2_F1]
  ldmxcsr   [NewFlags]

  ; Z := A - RoundDown(A)
  cvtps2dq  xmm3, xmm3
  addps     xmm1, xmm5 ; A + 121.2740575
  cvtdq2ps  xmm3, xmm3
  movaps    xmm2, [rel kSSE_EXP2_F2]
  subps     xmm0, xmm3

  movaps    xmm3, [rel kSSE_EXP2_F3]
  movaps    xmm4, [rel kSSE_EXP2_F4]
  subps     xmm3, xmm0 ; (4.84252568 - Z)
  mulps     xmm0, xmm4 ; 1.49012907 * Z
  divps     xmm2, xmm3
  movaps    xmm5, [rel kSSE_EXP2_F5]
  addps     xmm1, xmm2 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subps     xmm1, xmm0 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulps     xmm1, xmm5 ; (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq  xmm1, xmm1

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_fast_exp2_vector4:
  ; Set rounding mode to Round Positive (=Round Down)
  stmxcsr   [OldFlags]
  movups    xmm0, [Param1]
  mov       edx, [OldFlags]
  xorps     xmm1, xmm1
  and       edx, SSE_ROUND_MASK
  movaps    xmm3, xmm0
  or        edx, SSE_ROUND_DOWN
  movaps    xmm5, xmm0
  mov       [NewFlags], edx

  movaps    xmm1, [rel kSSE_EXP2_F1]
  ldmxcsr   [NewFlags]

  ; Z := A - RoundDown(A)
  cvtps2dq  xmm3, xmm3
  addps     xmm1, xmm5 ; A + 121.2740575
  cvtdq2ps  xmm3, xmm3
  movaps    xmm2, [rel kSSE_EXP2_F2]
  subps     xmm0, xmm3

  movaps    xmm3, [rel kSSE_EXP2_F3]
  movaps    xmm4, [rel kSSE_EXP2_F4]
  subps     xmm3, xmm0 ; (4.84252568 - Z)
  mulps     xmm0, xmm4 ; 1.49012907 * Z
  divps     xmm2, xmm3
  movaps    xmm5, [rel kSSE_EXP2_F5]
  addps     xmm1, xmm2 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subps     xmm1, xmm0 ; A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulps     xmm1, xmm5 ; (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq  xmm1, xmm1

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
;****************************************************************************
; Common Functions
;****************************************************************************
  
_abs_vector3:  
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movaps    xmm2, [rel kSSE_MASK_ABS_VAL]
  andps     xmm0, xmm2
  pand      xmm1, xmm2
  ret
  
_abs_vector4:  
  movups    xmm0, [Param1]
  movaps    xmm1, [rel kSSE_MASK_ABS_VAL]
  andps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret   
  
_sign_single:
  movss     xmm1, [rel kSSE_ONE]
  movss     xmm2, xmm0
  movss     xmm3, [rel kSSE_MASK_SIGN]

  andps     xmm0, xmm3 ; (A < 0)? Yes: 0x80000000, No: 0x00000000
  xorps     xmm4, xmm4
  orps      xmm0, xmm1 ; (A < 0)? Yes: -1, No: 1
  cmpneqss  xmm2, xmm4 ; (A = 0)? Yes: 0x00000000, No: 0xFFFFFFFF
  andps     xmm0, xmm2 ; (A = 0)? Yes: 0, No: -1 or 1
  ret
  
_sign_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [rel kSSE_ONE]
  movaps    xmm2, xmm0
  movlps    xmm3, [rel kSSE_MASK_SIGN]

  andps     xmm0, xmm3 ; (A < 0)? Yes: 0x80000000, No: 0x00000000
  xorps     xmm4, xmm4
  orps      xmm0, xmm1 ; (A < 0)? Yes: -1, No: 1
  cmpneqps  xmm2, xmm4 ; (A = 0)? Yes: 0x00000000, No: 0xFFFFFFFF
  andps     xmm0, xmm2 ; (A = 0)? Yes: 0, No: -1 or 1
  ret
  
_sign_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movaps    xmm1, [rel kSSE_ONE]
  movaps    xmm2, xmm0
  movaps    xmm3, [rel kSSE_MASK_SIGN]

  andps     xmm0, xmm3 ; (A < 0)? Yes: 0x80000000, No: 0x00000000
  xorps     xmm4, xmm4
  orps      xmm0, xmm1 ; (A < 0)? Yes: -1, No: 1
  cmpneqps  xmm2, xmm4 ; (A = 0)? Yes: 0x00000000, No: 0xFFFFFFFF
  andps     xmm0, xmm2 ; (A = 0)? Yes: 0, No: -1 or 1
  movhlps   xmm1, xmm0
  ret
  
_sign_vector4:
  movups    xmm0, [Param1]
  movaps    xmm1, [rel kSSE_ONE]
  movaps    xmm2, xmm0
  movaps    xmm3, [rel kSSE_MASK_SIGN]

  andps     xmm0, xmm3 ; (A < 0)? Yes: 0x80000000, No: 0x00000000
  xorps     xmm4, xmm4
  orps      xmm0, xmm1 ; (A < 0)? Yes: -1, No: 1
  cmpneqps  xmm2, xmm4 ; (A = 0)? Yes: 0x00000000, No: 0xFFFFFFFF
  andps     xmm0, xmm2 ; (A = 0)? Yes: 0, No: -1 or 1
  movhlps   xmm1, xmm0
  ret
  
_floor_single:
  ; Set rounding mode to Round Down
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_DOWN
  mov       [NewFlags], eax
  ldmxcsr   [NewFlags]

  cvtss2si  rax, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  ret

 _floor_vector2:
  ; Set rounding mode to Round Down
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_DOWN
  mov       [NewFlags], eax
  movlps    xmm0, [Param1]
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  
  movq      rax, xmm0
  ret
  
_floor_vector3:
  ; Set rounding mode to Round Down
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_DOWN
  mov       [NewFlags], eax
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret
  
_floor_vector4:
  ; Set rounding mode to Round Down
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_DOWN
  mov       [NewFlags], eax
  movups    xmm0, [Param1]
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret
  
_trunc_single:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  ldmxcsr   [NewFlags]

  cvtss2si  rax, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  ret
  
_trunc_vector2:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  movlps    xmm0, [Param1]
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  
  movq      rax, xmm0
  ret
  
_trunc_vector3:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret
  
_trunc_vector4:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  movups    xmm0, [Param1]
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret  
  
_round_single:
  ; Rounding mode defaults to round-to-nearest
  cvtss2si  rax, xmm0 
  ret
  
_round_vector2:
  ; Rounding mode defaults to round-to-nearest
  movlps    xmm0, [Param1]
  cvtps2dq  xmm0, xmm0 
  movq      rax, xmm0
  ret
  
_round_vector3:
  ; Rounding mode defaults to round-to-nearest
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  cvtps2dq  xmm0, xmm0
  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret
  
_round_vector4:
  ; Rounding mode defaults to round-to-nearest
  movups    xmm0, [Param1]
  cvtps2dq  xmm0, xmm0
  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret    
  
_ceil_single:
  ; Set rounding mode to Round Up
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_UP
  mov       [NewFlags], eax
  ldmxcsr   [NewFlags]

  cvtss2si  rax, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  ret
  
_ceil_vector2:
  ; Set rounding mode to Round Up
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_UP
  mov       [NewFlags], eax
  movlps    xmm0, [Param1]
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  
  movq      rax, xmm0
  ret
  
_ceil_vector3:
  ; Set rounding mode to Round Up
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_UP
  mov       [NewFlags], eax
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret
  
_ceil_vector4:
  ; Set rounding mode to Round Up
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_UP
  mov       [NewFlags], eax
  movups    xmm0, [Param1]
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  movq      rax, xmm0
  movq      rdx, xmm1
  ret
  
_frac_vector2:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       edx, [OldFlags]
  and       edx, SSE_ROUND_MASK
  or        edx, SSE_ROUND_TRUNC
  movlps    xmm0, [Param1]
  mov       [NewFlags], edx
  movaps    xmm1, xmm0
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0
  ldmxcsr   [OldFlags]
  cvtdq2ps  xmm0, xmm0
  subps     xmm1, xmm0 ; A - Trunc(A)

  movaps    xmm0, xmm1
  ret
  
_frac_vector3:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  mov       [NewFlags], eax
  movaps    xmm1, xmm0
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0
  ldmxcsr   [OldFlags]
  cvtdq2ps  xmm0, xmm0
  subps     xmm1, xmm0 ; A - Trunc(A)

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_frac_vector4:
  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  movups    xmm0, [Param1]
  mov       [NewFlags], eax
  movaps    xmm1, xmm0
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm0, xmm0
  ldmxcsr   [OldFlags]
  cvtdq2ps  xmm0, xmm0
  subps     xmm1, xmm0 ; A - Trunc(A)

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_fmod_vector2_single:
  ; Set rounding mode to Truncate
  movss     xmm1, xmm0
  movlps    xmm0, [Param1]
  stmxcsr   [OldFlags]
  mov       ecx, [OldFlags]
  shufps    xmm1, xmm1, 0x00 ; Replicate B
  and       ecx, SSE_ROUND_MASK
  movaps    xmm2, xmm0
  or        ecx, SSE_ROUND_TRUNC
  movaps    xmm3, xmm1
  mov       [NewFlags], ecx
  divps     xmm2, xmm3 ; A / B
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm2, xmm2
  cvtdq2ps  xmm2, xmm2 ; Trunc(A / B)
  mulps     xmm2, xmm1
  subps     xmm0, xmm2 ; A - (B * Trunc(A / B))

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  ret
  
_fmod_vector3_single:
  ; Set rounding mode to Truncate
  movss     xmm1, xmm0
  movq      xmm0, [Param1]
  movss     xmm2, [Param1+8]
  movlhps   xmm0, xmm2
  stmxcsr   [OldFlags]
  mov       edx, [OldFlags]
  shufps    xmm1, xmm1, 0x00 ; Replicate B
  and       edx, SSE_ROUND_MASK
  movaps    xmm2, xmm0
  or        edx, SSE_ROUND_TRUNC
  movaps    xmm3, xmm1
  mov       [NewFlags], edx
  divps     xmm2, xmm3 ; A / B
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm2, xmm2
  cvtdq2ps  xmm2, xmm2 ; Trunc(A / B)
  mulps     xmm2, xmm1
  subps     xmm0, xmm2 ; A - (B * Trunc(A / B))

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  ret
  
_fmod_vector4_single:
  ; Set rounding mode to Truncate
  movss     xmm1, xmm0
  movups    xmm0, [Param1]
  stmxcsr   [OldFlags]
  mov       edx, [OldFlags]
  shufps    xmm1, xmm1, 0x00 ; Replicate B
  and       edx, SSE_ROUND_MASK
  movaps    xmm2, xmm0
  or        edx, SSE_ROUND_TRUNC
  movaps    xmm3, xmm1
  mov       [NewFlags], edx
  divps     xmm2, xmm3 ; A / B
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm2, xmm2
  cvtdq2ps  xmm2, xmm2 ; Trunc(A / B)
  mulps     xmm2, xmm1
  subps     xmm0, xmm2 ; A - (B * Trunc(A / B))

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  ret
  
_fmod_vector2:
  ; Set rounding mode to Truncate
  movlps    xmm0, [Param1]
  stmxcsr   [OldFlags]
  movlps    xmm1, [Param2]
  mov       edx, [OldFlags]
  movaps    xmm2, xmm0
  and       edx, SSE_ROUND_MASK
  movaps    xmm3, xmm1
  or        edx, SSE_ROUND_TRUNC
  divps     xmm2, xmm3 ; A / B
  mov       [NewFlags], edx
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm2, xmm2
  cvtdq2ps  xmm2, xmm2 ; Trunc(A / B)
  mulps     xmm2, xmm1
  subps     xmm0, xmm2 ; A - (B * Trunc(A / B))

  ; Restore rounding mode
  ldmxcsr   [OldFlags]
  ret
  
_fmod_vector3:
  ; Set rounding mode to Truncate
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  stmxcsr   [OldFlags]
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  mov       edx, [OldFlags]
  movaps    xmm2, xmm0
  and       edx, SSE_ROUND_MASK
  movaps    xmm3, xmm1
  or        edx, SSE_ROUND_TRUNC
  divps     xmm2, xmm3 ; A / B
  mov       [NewFlags], edx
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm2, xmm2
  cvtdq2ps  xmm2, xmm2 ; Trunc(A / B)
  mulps     xmm2, xmm1
  subps     xmm0, xmm2 ; A - (B * Trunc(A / B))

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  ret
  
_fmod_vector4:
  ; Set rounding mode to Truncate
  movups    xmm0, [Param1]
  stmxcsr   [OldFlags]
  movups    xmm1, [Param2]
  mov       edx, [OldFlags]
  movaps    xmm2, xmm0
  and       edx, SSE_ROUND_MASK
  movaps    xmm3, xmm1
  or        edx, SSE_ROUND_TRUNC
  divps     xmm2, xmm3 ; A / B
  mov       [NewFlags], edx
  ldmxcsr   [NewFlags]

  cvtps2dq  xmm2, xmm2
  cvtdq2ps  xmm2, xmm2 ; Trunc(A / B)
  mulps     xmm2, xmm1
  subps     xmm0, xmm2 ; A - (B * Trunc(A / B))

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movhlps   xmm1, xmm0
  ret
  
_modf_vector2:
  movlps    xmm0, [Param1]

  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  ldmxcsr   [NewFlags]

  movaps    xmm1, xmm0
  cvtps2dq  xmm0, xmm0
  movlps    [Param2], xmm0  ; B = Trunc(A)
  cvtdq2ps  xmm0, xmm0
  subps     xmm1, xmm0 ; A - Trunc(A)

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movaps    xmm0, xmm1
  ret
  
_modf_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1

  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  ldmxcsr   [NewFlags]

  movaps    xmm1, xmm0
  cvtps2dq  xmm0, xmm0
  movhlps   xmm2, xmm0
  movq      [Param2], xmm0  ; B = Trunc(A)
  movd      [Param2+8], xmm2
  cvtdq2ps  xmm0, xmm0
  subps     xmm1, xmm0 ; A - Trunc(A)

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_modf_vector4:
  movups    xmm0, [Param1]

  ; Set rounding mode to Truncate
  stmxcsr   [OldFlags]
  mov       eax, [OldFlags]
  and       eax, SSE_ROUND_MASK
  or        eax, SSE_ROUND_TRUNC
  mov       [NewFlags], eax
  ldmxcsr   [NewFlags]

  movaps    xmm1, xmm0
  cvtps2dq  xmm0, xmm0
  movups    [Param2], xmm0  ; B = Trunc(A)
  cvtdq2ps  xmm0, xmm0
  subps     xmm1, xmm0 ; A - Trunc(A)

  ; Restore rounding mode
  ldmxcsr   [OldFlags]

  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_min_vector2_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate B
  movlps    xmm1, [Param1]
  minps     xmm0, xmm1
  ret
  
_min_vector3_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate B
  movq      xmm1, [Param1]
  movss     xmm2, [Param1+8]
  movlhps   xmm1, xmm2
  minps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_min_vector4_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate B
  movups    xmm1, [Param1]
  minps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_min_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [Param2]
  minps     xmm0, xmm1
  ret
  
_min_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  minps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_min_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  minps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_max_vector2_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate B
  movlps    xmm1, [Param1]
  maxps     xmm0, xmm1
  ret
  
_max_vector3_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate B
  movq      xmm1, [Param1]
  movss     xmm2, [Param1+8]
  movlhps   xmm1, xmm2
  maxps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_max_vector4_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate B
  movups    xmm1, [Param1]
  maxps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_max_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [Param2]
  maxps     xmm0, xmm1
  ret
  
_max_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  maxps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_max_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  maxps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_ensure_range_single:
  maxss     xmm0, xmm1
  minss     xmm0, xmm2
  ret
  
_ensure_range_vector2_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate AMin
  shufps    xmm1, xmm1, 0x00 ; Replicate AMax
  movlps    xmm2, [Param1]
  minps     xmm2, xmm1
  maxps     xmm0, xmm2
  ret
  
_ensure_range_vector3_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate AMin
  shufps    xmm1, xmm1, 0x00 ; Replicate AMax
  movq      xmm2, [Param1]
  movss     xmm3, [Param1+8]
  movlhps   xmm2, xmm3
  minps     xmm2, xmm1
  maxps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
_ensure_range_vector4_single:
  shufps    xmm0, xmm0, 0x00 ; Replicate AMin
  shufps    xmm1, xmm1, 0x00 ; Replicate AMax
  movups    xmm2, [Param1]
  minps     xmm2, xmm1
  maxps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
_ensure_range_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [Param2]
  movlps    xmm2, [Param3]
  maxps     xmm0, xmm1
  minps     xmm0, xmm2
  ret
  
_ensure_range_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  movq      xmm2, [Param3]
  movss     xmm3, [Param3+8]
  movlhps   xmm2, xmm3
  maxps     xmm0, xmm1
  minps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
_ensure_range_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  movups    xmm2, [Param3]
  maxps     xmm0, xmm1
  minps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
_mix_vector3_single:
  movq      xmm4, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm4, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  shufps    xmm0, xmm0, 0x00 ; Replicate T
  subps     xmm1, xmm4
  mulps     xmm1, xmm0
  addps     xmm4, xmm1 ; A + (T * (B - A))
  movhlps   xmm1, xmm4
  movaps    xmm0, xmm4
  ret
  
_mix_vector4_single:
  movups    xmm4, [Param1]
  movups    xmm1, [Param2]
  shufps    xmm0, xmm0, 0x00 ; Replicate T
  subps     xmm1, xmm4
  mulps     xmm1, xmm0
  addps     xmm4, xmm1 ; A + (T * (B - A))
  movaps    xmm0, xmm4
  movhlps   xmm1, xmm4
  ret
  
_mix_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  movq      xmm2, [Param3]
  movss     xmm3, [Param3+8]
  movlhps   xmm2, xmm3
  subps     xmm1, xmm0
  mulps     xmm1, xmm2
  addps     xmm0, xmm1 ; A + (T * (B - A))
  movhlps   xmm1, xmm0
  ret
  
_mix_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  movups    xmm2, [Param3]
  subps     xmm1, xmm0
  mulps     xmm1, xmm2
  addps     xmm0, xmm1 ; A + (T * (B - A))
  movhlps   xmm1, xmm0
  ret
  
_step_single_vector2:
  movlps    xmm1, [Param1]
  shufps    xmm0, xmm0, 0x00 ; Replicate AEdge
  movlps    xmm2, [rel kSSE_ONE]
  cmpnltps  xmm1, xmm0      ; (A >= AEdge)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm2      ; (A >= AEdge)? Yes: 1, No: 0
  movaps    xmm0, xmm1
  ret
  
_step_single_vector3:
  movq      xmm3, [Param1]
  movss     xmm2, [Param1+8]
  movlhps   xmm3, xmm2
  shufps    xmm0, xmm0, 0x00 ; Replicate AEdge
  movaps    xmm2, [rel kSSE_ONE]
  cmpnltps  xmm3, xmm0      ; (A >= AEdge)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm3, xmm2      ; (A >= AEdge)? Yes: 1, No: 0
  movaps    xmm0, xmm3
  movhlps   xmm1, xmm3
  ret
  
_step_single_vector4:
  movups    xmm3, [Param1]
  shufps    xmm0, xmm0, 0x00 ; Replicate AEdge
  movaps    xmm2, [rel kSSE_ONE]
  cmpnltps  xmm3, xmm0      ; (A >= AEdge)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm3, xmm2      ; (A >= AEdge)? Yes: 1, No: 0
  movaps    xmm0, xmm3
  movhlps   xmm1, xmm3
  ret
  
_step_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [Param2]
  movlps    xmm2, [rel kSSE_ONE]
  cmpnltps  xmm1, xmm0 ; (A >= AEdge)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm2 ; (A >= AEdge)? Yes: 1, No: 0
  movaps    xmm0, xmm1
  ret
  
_step_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  movaps    xmm2, [rel kSSE_ONE]
  cmpnltps  xmm1, xmm0 ; (A >= AEdge)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm2 ; (A >= AEdge)? Yes: 1, No: 0
  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_step_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  movaps    xmm2, [rel kSSE_ONE]
  cmpnltps  xmm1, xmm0 ; (A >= AEdge)? Yes: 0xFFFFFFFF, No: 0x00000000
  andps     xmm1, xmm2 ; (A >= AEdge)? Yes: 1, No: 0
  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret   
  
_smooth_step_single_vector3:
  movq      xmm2, [Param1]
  movss     xmm3, [Param1+8]
  movlhps   xmm2, xmm3
  shufps    xmm0, xmm0, 0x00 ; Replicate AEdge0
  shufps    xmm1, xmm1, 0x00 ; Replicate AEdge1
  movaps    xmm3, xmm2
  movaps    xmm4, xmm2
  movaps    xmm5, xmm2
  movaps    xmm6, [rel kSSE_ONE]

  cmpnltps  xmm3, xmm0 ; (A >= AEdge0)? Yes: 0xFFFFFFFF, No: 0x00000000
  cmpleps   xmm4, xmm1 ; (A <= AEdge1)? Yes: 0xFFFFFFFF, No: 0x00000000
  subps     xmm1, xmm0
  movaps    xmm5, xmm4
  subps     xmm2, xmm0
  andnps    xmm5, xmm6 ; (A >  AEdge1)? Yes: 1.0, No: 0.0

  movaps    xmm6, [rel kSSE_TWO]
  divps     xmm2, xmm1 ; Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movaps    xmm7, [rel kSSE_THREE]
  mulps     xmm6, xmm2 ; 2 * Temp
  subps     xmm7, xmm6 ; 3 - (2 * Temp)
  mulps     xmm7, xmm2
  mulps     xmm7, xmm2 ; Result := Temp * Temp * (3 - (2 * Temp))
  andps     xmm7, xmm3 ; (A < AEdge0)? Yes: 0, No: Result
  andps     xmm7, xmm4 ; (A > AEdge1)? Yes: 0, No: Result
  orps      xmm7, xmm5 ; (A > AEdge1)? Yes: 1, No: Result

  movaps    xmm0, xmm7
  movhlps   xmm1, xmm7
  ret
  
_smooth_step_single_vector4:
  movups    xmm2, [Param1]
  shufps    xmm0, xmm0, 0x00 ; Replicate AEdge0
  shufps    xmm1, xmm1, 0x00 ; Replicate AEdge1
  movaps    xmm3, xmm2
  movaps    xmm4, xmm2
  movaps    xmm5, xmm2
  movaps    xmm6, [rel kSSE_ONE]

  cmpnltps  xmm3, xmm0 ; (A >= AEdge0)? Yes: 0xFFFFFFFF, No: 0x00000000
  cmpleps   xmm4, xmm1 ; (A <= AEdge1)? Yes: 0xFFFFFFFF, No: 0x00000000
  subps     xmm1, xmm0
  movaps    xmm5, xmm4
  subps     xmm2, xmm0
  andnps    xmm5, xmm6 ; (A >  AEdge1)? Yes: 1.0, No: 0.0

  movaps    xmm6, [rel kSSE_TWO]
  divps     xmm2, xmm1 ; Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movaps    xmm7, [rel kSSE_THREE]
  mulps     xmm6, xmm2 ; 2 * Temp
  subps     xmm7, xmm6 ; 3 - (2 * Temp)
  mulps     xmm7, xmm2
  mulps     xmm7, xmm2 ; Result := Temp * Temp * (3 - (2 * Temp))
  andps     xmm7, xmm3 ; (A < AEdge0)? Yes: 0, No: Result
  andps     xmm7, xmm4 ; (A > AEdge1)? Yes: 0, No: Result
  orps      xmm7, xmm5 ; (A > AEdge1)? Yes: 1, No: Result

  movaps    xmm0, xmm7
  movhlps   xmm1, xmm7  
  ret
  
_smooth_step_vector3:
  movq      xmm2, [Param3]
  movss     xmm3, [Param3+8]
  movlhps   xmm2, xmm3
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm3, [Param2+8]
  movlhps   xmm1, xmm3

  movaps    xmm3, xmm2
  movaps    xmm4, xmm2
  movaps    xmm5, xmm2
  movaps    xmm6, [rel kSSE_ONE]

  cmpnltps  xmm3, xmm0 ; (A >= AEdge0)? Yes: 0xFFFFFFFF, No: 0x00000000
  cmpleps   xmm4, xmm1 ; (A <= AEdge1)? Yes: 0xFFFFFFFF, No: 0x00000000
  subps     xmm1, xmm0
  movaps    xmm5, xmm4
  subps     xmm2, xmm0
  andnps    xmm5, xmm6 ; (A >  AEdge1)? Yes: 1.0, No: 0.0

  movaps    xmm6, [rel kSSE_TWO]
  divps     xmm2, xmm1 ; Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movaps    xmm7, [rel kSSE_THREE]
  mulps     xmm6, xmm2 ; 2 * Temp
  subps     xmm7, xmm6 ; 3 - (2 * Temp)
  mulps     xmm7, xmm2
  mulps     xmm7, xmm2 ; Result := Temp * Temp * (3 - (2 * Temp))
  andps     xmm7, xmm3 ; (A < AEdge0)? Yes: 0, No: Result
  andps     xmm7, xmm4 ; (A > AEdge1)? Yes: 0, No: Result
  orps      xmm7, xmm5 ; (A > AEdge1)? Yes: 1, No: Result

  movaps    xmm0, xmm7
  movhlps   xmm1, xmm7
  ret
  
_smooth_step_vector4:
  movups    xmm2, [Param3]
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  movaps    xmm3, xmm2
  movaps    xmm4, xmm2
  movaps    xmm5, xmm2
  movaps    xmm6, [rel kSSE_ONE]

  cmpnltps  xmm3, xmm0 ; (A >= AEdge0)? Yes: 0xFFFFFFFF, No: 0x00000000
  cmpleps   xmm4, xmm1 ; (A <= AEdge1)? Yes: 0xFFFFFFFF, No: 0x00000000
  subps     xmm1, xmm0
  movaps    xmm5, xmm4
  subps     xmm2, xmm0
  andnps    xmm5, xmm6 ; (A >  AEdge1)? Yes: 1.0, No: 0.0

  movaps    xmm6, [rel kSSE_TWO]
  divps     xmm2, xmm1 ; Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movaps    xmm7, [rel kSSE_THREE]
  mulps     xmm6, xmm2 ; 2 * Temp
  subps     xmm7, xmm6 ; 3 - (2 * Temp)
  mulps     xmm7, xmm2
  mulps     xmm7, xmm2 ; Result := Temp * Temp * (3 - (2 * Temp))
  andps     xmm7, xmm3 ; (A < AEdge0)? Yes: 0, No: Result
  andps     xmm7, xmm4 ; (A > AEdge1)? Yes: 0, No: Result
  orps      xmm7, xmm5 ; (A > AEdge1)? Yes: 1, No: Result

  movaps    xmm0, xmm7
  movhlps   xmm1, xmm7
  ret  
  
_fma_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [Param2]
  movlps    xmm2, [Param3]
  mulps     xmm0, xmm1
  addps     xmm0, xmm2
  ret
  
_fma_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
  movlhps   xmm1, xmm2
  movq      xmm2, [Param3]
  movss     xmm3, [Param3+8]
  movlhps   xmm2, xmm3
  mulps     xmm0, xmm1
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
_fma_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  movups    xmm2, [Param3]
  mulps     xmm0, xmm1
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
;****************************************************************************
; Matrix Functions
;****************************************************************************

_outer_product_matrix2:
%ifdef FM_COLUMN_MAJOR
  movlps    xmm0, [Param2]
  movlps    xmm1, [Param1]
%else
  movlps    xmm0, [Param1]   ; # # C.Y C.X
  movlps    xmm1, [Param2]   ; # # R.Y R.X
%endif  

  shufps    xmm0, xmm0, 0x50 ; C.Y C.X C.Y C.X
  shufps    xmm1, xmm1, 0x44 ; R.Y R.Y R.X R.X

  mulps     xmm0, xmm1      ; (C.Y*R.Y) (C.X*R.Y) (C.Y*R.X) (C.X*R.X)

  ; Store as matrix
  movhlps   xmm1, xmm0
  ret
  
_outer_product_matrix3:
%ifdef FM_COLUMN_MAJOR
  movq      xmm0, [Param2]
  movss     xmm1, [Param2+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param3]
  movss     xmm2, [Param3+8]
%else
  movq      xmm0, [Param3]
  movss     xmm1, [Param3+8]
  movlhps   xmm0, xmm1
  movq      xmm1, [Param2]
  movss     xmm2, [Param2+8]
%endif  
  movlhps   xmm1, xmm2
  movaps    xmm2, xmm1
  movaps    xmm3, xmm1

  shufps    xmm1, xmm1, 0x00 ; C.X (4x)
  shufps    xmm2, xmm2, 0x55 ; C.Y (4x)
  shufps    xmm3, xmm3, 0xAA ; C.Z (4x)

  mulps     xmm1, xmm0      ; R * C.X
  mulps     xmm2, xmm0      ; R * C.Y
  mulps     xmm3, xmm0      ; R * C.Z

  ; Store as matrix
  movhlps   xmm0, xmm1
  movhlps   xmm4, xmm2
  movhlps   xmm5, xmm3
  movq      [Param1+0x00], xmm1
  movss     [Param1+0x08], xmm0
  movq      [Param1+0x0C], xmm2
  movss     [Param1+0x14], xmm4
  movq      [Param1+0x18], xmm3
  movss     [Param1+0x20], xmm5
  ret
  
_outer_product_matrix4:
%ifdef FM_COLUMN_MAJOR
  movups    xmm0, [Param2]
  movups    xmm1, [Param3]
%else
  movups    xmm0, [Param3]
  movups    xmm1, [Param2]
%endif  
  movaps    xmm2, xmm1
  movaps    xmm3, xmm1
  movaps    xmm4, xmm1

  shufps    xmm1, xmm1, 0x00 ; C.X (4x)
  shufps    xmm2, xmm2, 0x55 ; C.Y (4x)
  shufps    xmm3, xmm3, 0xAA ; C.Z (4x)
  shufps    xmm4, xmm4, 0xFF ; C.W (4x)

  mulps     xmm1, xmm0      ; R * C.X
  mulps     xmm2, xmm0      ; R * C.Y
  mulps     xmm3, xmm0      ; R * C.Z
  mulps     xmm4, xmm0      ; R * C.W

  ; Store as matrix
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
;****************************************************************************
; TVector2
;****************************************************************************
  
_vector2_div_single:
  shufps    xmm0, xmm0, 0
  movlps    xmm1, [Param1]
  divps     xmm1, xmm0
  movaps    xmm0, xmm1
  ret
  
_single_div_vector2:
  movlps    xmm1, [Param1]
  shufps    xmm0, xmm0, 0
  divps     xmm0, xmm1
  ret
  
_vector2_div_vector2:
  movlps    xmm0, [Param1]
  movlps    xmm1, [Param2]
  divps     xmm0, xmm1
  ret
  
_vector2_normalize_fast:
  movlps    xmm0, [Self]    ; Y X
  movaps    xmm2, xmm0
  mulps     xmm0, xmm0      ; Y*Y X*X
  pshufd    xmm1, xmm0, 0x01; X*X Y*Y
  addps     xmm0, xmm1      ; (X*X+Y*Y) (2x)
  rsqrtps   xmm0, xmm0      ; (1 / Sqrt(X*X + Y*Y)) (4x)
  mulps     xmm0, xmm2      ; A * (1 / Sqrt(Dot(A, A)))
  ret
  
_vector2_set_normalized_fast:
  movlps    xmm0, [Self]    ; Y X
  movaps    xmm2, xmm0
  mulps     xmm0, xmm0      ; Y*Y X*X
  pshufd    xmm1, xmm0, 0x01; X*X Y*Y
  addps     xmm0, xmm1      ; (X*X+Y*Y) (2x)
  rsqrtps   xmm0, xmm0      ; (1 / Sqrt(X*X + Y*Y)) (4x)
  mulps     xmm0, xmm2      ; A * (1 / Sqrt(Dot(A, A)))
  movlps    [Self], xmm0
  ret  
  
;****************************************************************************
; TVector3
;****************************************************************************

_vector3_add_single:
  movq      xmm2, [Param1] ; Load 3 floating-point values
  movss     xmm1, [Param1+8]
  shufps    xmm0, xmm0, 0  ; Replicate B
  addps     xmm2, xmm0     ; A + B
  addss     xmm1, xmm0
  movaps    xmm0, xmm2     ; Store result
  ret
  
_single_add_vector3:
  movq      xmm2, [Param1]
  movss     xmm1, [Param1+8]
  shufps    xmm0, xmm0, 0
  addps     xmm2, xmm0
  addss     xmm1, xmm0
  movaps    xmm0, xmm2
  ret
  
_vector3_add_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movq      xmm2, [Param2]
  movss     xmm3, [Param2+8]
  addps     xmm0, xmm2
  addss     xmm1, xmm3
  ret
  
_vector3_sub_single:
  movq      xmm2, [Param1] ; Load 3 floating-point values
  movss     xmm1, [Param1+8]
  shufps    xmm0, xmm0, 0  ; Replicate B
  subps     xmm2, xmm0     ; A + B
  subss     xmm1, xmm0
  movaps    xmm0, xmm2     ; Store result
  ret
  
_single_sub_vector3:
  movq      xmm4, [Param1]
  movss     xmm2, [Param1+8]
  movss     xmm1, xmm0
  shufps    xmm0, xmm0, 0
  subps     xmm0, xmm4
  subss     xmm1, xmm2
  ret
  
_vector3_sub_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movq      xmm2, [Param2]
  movss     xmm3, [Param2+8]
  subps     xmm0, xmm2
  subss     xmm1, xmm3
  ret

_vector3_mul_single:
  movq      xmm2, [Param1]
  movss     xmm1, [Param1+8]
  shufps    xmm0, xmm0, 0
  mulps     xmm2, xmm0
  mulss     xmm1, xmm0
  movaps    xmm0, xmm2
  ret
  
_single_mul_vector3:
  movq      xmm2, [Param1]
  movss     xmm1, [Param1+8]
  shufps    xmm0, xmm0, 0
  mulps     xmm2, xmm0
  mulss     xmm1, xmm0
  movaps    xmm0, xmm2
  ret
  
_vector3_mul_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movq      xmm2, [Param2]
  movss     xmm3, [Param2+8]
  mulps     xmm0, xmm2
  mulss     xmm1, xmm3
  ret  
  
_vector3_div_single:
  movq      xmm2, [Param1]
  movss     xmm1, [Param1+8]
  shufps    xmm0, xmm0, 0
  divps     xmm2, xmm0
  divss     xmm1, xmm0
  movaps    xmm0, xmm2
  ret
  
_single_div_vector3:
  movq      xmm3, [Param1]
  movss     xmm2, [Param1+8]
  movss     xmm1, xmm0
  shufps    xmm0, xmm0, 0
  divps     xmm0, xmm3
  divss     xmm1, xmm2
  ret
  
_vector3_div_vector3:
  movq      xmm0, [Param1]
  movss     xmm1, [Param1+8]
  movq      xmm2, [Param2]
  movss     xmm3, [Param2+8]
  divps     xmm0, xmm2
  divss     xmm1, xmm3
  ret
  
_vector3_distance:
  movq      xmm0, [Self]
  movss     xmm1, [Self+8]
  movq      xmm2, [Param2]
  movss     xmm3, [Param2+8]
  movlhps   xmm0, xmm1
  movlhps   xmm2, xmm3
  subps     xmm0, xmm2 ; A - B

  ; (A - B).Length
  mulps     xmm0, xmm0
  pshufd    xmm1, xmm0, 0x0E
  addps     xmm0, xmm1
  pshufd    xmm1, xmm0, 0x01
  addss     xmm0, xmm1
  sqrtss    xmm0, xmm0
  ret
  
_vector3_distance_squared:
  movq      xmm0, [Self]
  movss     xmm1, [Self+8]
  movq      xmm2, [Param2]
  movss     xmm3, [Param2+8]
  movlhps   xmm0, xmm1
  movlhps   xmm2, xmm3
  subps     xmm0, xmm2 ; A - B

  ; (A - B).Length
  mulps     xmm0, xmm0
  pshufd    xmm1, xmm0, 0x0E
  addps     xmm0, xmm1
  pshufd    xmm1, xmm0, 0x01
  addss     xmm0, xmm1
  ret
  
_vector3_get_length:
  movq      xmm0, [Self]    ; 0 0 Y X
  movss     xmm1, [Self+8]  ; 0 0 0 Z
  movlhps   xmm0, xmm1      ; 0 Z Y Z
  mulps     xmm0, xmm0      ;  0  Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x0E; Y*Y X*X  0  Z*Z
  addps     xmm0, xmm1      ;     #         #     (Y*Y)     (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x01; (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y)
  addss     xmm0, xmm1      ; (X*X + Y*Y + Z*Z)
  sqrtss    xmm0, xmm0      ; Sqrt(X*X + Y*Y + Z*Z)
  ret
  
_vector3_get_length_squared:
  movq      xmm0, [Self]    ; 0 0 Y X
  movss     xmm1, [Self+8]  ; 0 0 0 Z
  movlhps   xmm0, xmm1      ; 0 Z Y Z
  mulps     xmm0, xmm0      ;  0  Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x0E; Y*Y X*X  0  Z*Z
  addps     xmm0, xmm1      ;     #         #     (Y*Y)     (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x01; (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y)
  addss     xmm0, xmm1      ; (X*X + Y*Y + Z*Z)
  ret

_vector3_normalize_fast:
  movq      xmm0, [Self]    ; 0 0 Y X
  movss     xmm1, [Self+8]  ; 0 0 0 Z
  movlhps   xmm0, xmm1      ; 0 Z Y Z
  movaps    xmm2, xmm0

  ; Dot(A, A)
  mulps     xmm0, xmm0      ;  0  Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x4E; Y*Y X*X  0  Z*Z
  addps     xmm0, xmm1      ;   (Y*Y) (X*X+Z*Z) (Y*Y) (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x11; (X*X+Z*Z) (Y*Y) (X*X+Z*Z) (Y*Y)
  addps     xmm0, xmm1      ; (X*X + Y*Y + Z*Z) (4x)

  rsqrtps   xmm0, xmm0      ; (1 / Sqrt(X*X + Y*Y + Z*Z)) (4x)
  mulps     xmm0, xmm2      ; A * (1 / Sqrt(Dot(A, A)))
  movhlps   xmm1, xmm0
  ret
  
_vector3_set_normalized_fast:
  movq      xmm0, [Self]    ; 0 0 Y X
  movss     xmm1, [Self+8]  ; 0 0 0 Z
  movlhps   xmm0, xmm1      ; 0 Z Y Z
  movaps    xmm2, xmm0

  ; Dot(A, A)
  mulps     xmm0, xmm0      ;  0  Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x4E; Y*Y X*X  0  Z*Z
  addps     xmm0, xmm1      ;   (Y*Y) (X*X+Z*Z) (Y*Y) (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x11; (X*X+Z*Z) (Y*Y) (X*X+Z*Z) (Y*Y)
  addps     xmm0, xmm1      ; (X*X + Y*Y + Z*Z) (4x)

  rsqrtps   xmm0, xmm0      ; (1 / Sqrt(X*X + Y*Y + Z*Z)) (4x)
  mulps     xmm0, xmm2      ; A * (1 / Sqrt(Dot(A, A)))
  movhlps   xmm1, xmm0
  movq      [Self], xmm0
  movss     [Self+8], xmm1
  ret  
  
_vector3_reflect:
  movq      xmm0, [Self]
  movss     xmm2, [Self+8]
  movq      xmm1, [Param2]
  movss     xmm3, [Param2+8]
  movlhps   xmm0, xmm2
  movlhps   xmm1, xmm3
  movaps    xmm2, xmm0
  movups    xmm3, [rel kSSE_TWO]

  ; Dot(N, I)
  mulps     xmm0, xmm1
  mulps     xmm3, xmm1 ; N * 2
  pshufd    xmm1, xmm0, 0x4E
  addps     xmm0, xmm1
  pshufd    xmm1, xmm0, 0x11
  addps     xmm0, xmm1

  ; (2 * Dot(N, I)) * N
  mulps     xmm0, xmm3

  ; I - ((2 * Dot(N, I)) * N)
  subps     xmm2, xmm0
  movaps    xmm0, xmm2
  movhlps   xmm1, xmm2
  ret
  
_vector3_refract:
  movq      xmm3, [Self]
  movss     xmm2, [Self+8]
  movq      xmm1, [Param2]
  movss     xmm4, [Param2+8]
  movlhps   xmm3, xmm2
  movlhps   xmm1, xmm4
  movups    xmm7, xmm3
  movss     xmm2, [rel kSSE_ONE]

  ; D := Dot(N, I)
  mulps     xmm3, xmm1
  movss     xmm4, xmm2 ; 1
  pshufd    xmm1, xmm3, 0x4E
  movss     xmm5, xmm0 ; Eta
  addps     xmm3, xmm1
  mulss     xmm5, xmm5 ; Eta * Eta
  pshufd    xmm1, xmm3, 0x11
  addss     xmm3, xmm1

  ; K := 1 - Eta * Eta * (1 - D * D)
  movss     xmm6, xmm3  ; D
  mulss     xmm3, xmm3  ; D * D
  subss     xmm4, xmm3  ; 1 - D * D
  mulss     xmm4, xmm5  ; Eta * Eta * (1 - D * D)
  xorps     xmm5, xmm5  ; 0
  subss     xmm2, xmm4  ; K := 1 - Eta * Eta * (1 - D * D)

  ; if (K < 0) then
  comiss    xmm2, xmm5

  jb        _set_null_vec3

  ; K >= 0
  mulss     xmm6, xmm0    ; Eta * D
  shufps    xmm0, xmm0, 0 ; Replicate Eta (4x)
  mulps     xmm7, xmm0    ; Eta * I
  sqrtss    xmm2, xmm2    ; Sqrt(K)
  addss     xmm6, xmm2    ; Eta * D + Sqrt(K)
  shufps    xmm6, xmm6, 0 ; Replicate Eta * D + Sqrt(K) (4x)
  movups    xmm1, [Param2]
  mulps     xmm6, xmm1    ; ((Eta * D + Sqrt(K)) * N)
  subps     xmm7, xmm6    ; (Eta * I) - ((Eta * D + Sqrt(K)) * N)
  movaps    xmm0, xmm7
  movhlps   xmm1, xmm7
  ret

_set_null_vec3:
  ; K < 0: Result := Vector4(0, 0, 0, 0)
  movaps    xmm0, xmm5
  movlhps   xmm1, xmm5
  ret
  
;****************************************************************************
; TVector4
;****************************************************************************
  
_vector4_add_single:
  movups    xmm2, [Param1] ; Load 4 floating-point values
  shufps    xmm0, xmm0, 0  ; Replicate B
  addps     xmm2, xmm0     ; A + B
  movaps    xmm0, xmm2     ; Store result
  movhlps   xmm1, xmm2
  ret
  
_single_add_vector4:
  movups    xmm1, [Param1]
  shufps    xmm0, xmm0, 0
  addps     xmm1, xmm0
  movaps    xmm0, xmm1
  movhlps   xmm1, xmm1
  ret
  
_vector4_add_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  addps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_vector4_sub_single:
  movups    xmm2, [Param1]
  shufps    xmm0, xmm0, 0
  subps     xmm2, xmm0
  movaps    xmm0, xmm2  
  movhlps   xmm1, xmm2
  ret
  
_single_sub_vector4:
  movups    xmm1, [Param1]
  shufps    xmm0, xmm0, 0
  subps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_vector4_sub_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  subps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_vector4_mul_single:
  movups    xmm2, [Param1]
  shufps    xmm0, xmm0, 0
  mulps     xmm2, xmm0
  movaps    xmm0, xmm2  
  movhlps   xmm1, xmm2
  ret
  
_single_mul_vector4:
  movups    xmm1, [Param1]
  shufps    xmm0, xmm0, 0
  mulps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_vector4_mul_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  mulps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_vector4_div_single:
  movups    xmm2, [Param1]
  shufps    xmm0, xmm0, 0
  divps     xmm2, xmm0
  movaps    xmm0, xmm2  
  movhlps   xmm1, xmm2
  ret
  
_single_div_vector4:
  movups    xmm1, [Param1]
  shufps    xmm0, xmm0, 0
  divps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret
  
_vector4_div_vector4:
  movups    xmm0, [Param1]
  movups    xmm1, [Param2]
  divps     xmm0, xmm1
  movhlps   xmm1, xmm0
  ret  

_vector4_negative:
  movaps    xmm0, [rel kSSE_MASK_SIGN] ; Load mask with 4 sign (upper) bits
  movups    xmm1, [Param1]
  xorps     xmm0, xmm1                 ; Flip sign bit
  movhlps   xmm1, xmm0
  ret
  
_vector4_distance:
  movups    xmm0, [Self]
  movups    xmm1, [Param2]
  subps     xmm0, xmm1 ; A - B

  ; (A - B).Length
  mulps     xmm0, xmm0
  pshufd    xmm1, xmm0, 0x0E
  addps     xmm0, xmm1
  pshufd    xmm1, xmm0, 0x01
  addss     xmm0, xmm1
  sqrtss    xmm0, xmm0
  ret
  
_vector4_distance_squared:
  movups    xmm0, [Self]
  movups    xmm1, [Param2]
  subps     xmm0, xmm1 ; A - B

  ; (A - B).LengthSquared
  mulps     xmm0, xmm0
  pshufd    xmm1, xmm0, 0x0E
  addps     xmm0, xmm1
  pshufd    xmm1, xmm0, 0x01
  addss     xmm0, xmm1
  ret
  
_vector4_face_forward:
  movups    xmm0, [Self]
  movups    xmm1, [Param2]
  movups    xmm2, [Param3]
  xorps     xmm3, xmm3 ; 0
  movaps    xmm4, [rel kSSE_MASK_SIGN]

  ; Dot(NRef, I)
  mulps     xmm2, xmm1
  pshufd    xmm1, xmm2, 0x4E
  addps     xmm2, xmm1
  pshufd    xmm1, xmm2, 0x11
  addps     xmm2, xmm1

  ; Dot(NRef, I) >= 0?  Yes: 0xFFFFFFFF, No: 0x00000000
  cmpnltps  xmm2, xmm3
  andps     xmm2, xmm4 ; Yes: 0x80000000, No: 0x00000000

  ; Flip sign of N if (Dot(NRef, I) >= 0)
  xorps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
  
_vector4_get_length:
  movups    xmm0, [Self]    ; W Z Y X
  mulps     xmm0, xmm0      ; W*W Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x0E; Y*Y X*X W*W Z*Z
  addps     xmm0, xmm1      ;     #         #     (Y*Y+W*W) (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x01; (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y+W*W)
  addss     xmm0, xmm1      ; (X*X + Y*Y + Z*Z + W*W)
  sqrtss    xmm0, xmm0      ; Sqrt(X*X + Y*Y + Z*Z + W*W)
  ret
  
_vector4_get_length_squared:
  movups    xmm0, [Self]    ; W Z Y X
  mulps     xmm0, xmm0      ; W*W Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x0E; Y*Y X*X W*W Z*Z
  addps     xmm0, xmm1      ;     #         #     (Y*Y+W*W) (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x01; (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y+W*W)
  addss     xmm0, xmm1      ; (X*X + Y*Y + Z*Z + W*W)
  ret
 
_vector4_normalize_fast:
  movups    xmm0, [Self]    ; W Z Y X
  movaps    xmm2, xmm0

  ; Dot(A, A)
  mulps     xmm0, xmm0      ; W*W Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x4E; Y*Y X*X W*W Z*Z
  addps     xmm0, xmm1      ; (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x11; (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W)
  addps     xmm0, xmm1      ; (X*X + Y*Y + Z*Z + W*W) (4x)

  rsqrtps   xmm0, xmm0      ; (1 / Sqrt(X*X + Y*Y + Z*Z + W*W)) (4x)
  mulps     xmm0, xmm2      ; A * (1 / Sqrt(Dot(A, A)))
  movhlps   xmm1, xmm0
  ret
  
_vector4_set_normalized_fast:
  movups    xmm0, [Self]    ; W Z Y X
  movaps    xmm2, xmm0

  ; Dot(A, A)
  mulps     xmm0, xmm0      ; W*W Z*Z Y*Y X*X
  pshufd    xmm1, xmm0, 0x4E; Y*Y X*X W*W Z*Z
  addps     xmm0, xmm1      ; (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z)
  pshufd    xmm1, xmm0, 0x11; (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W)
  addps     xmm0, xmm1      ; (X*X + Y*Y + Z*Z + W*W) (4x)

  rsqrtps   xmm0, xmm0      ; (1 / Sqrt(X*X + Y*Y + Z*Z + W*W)) (4x)
  mulps     xmm0, xmm2      ; A * (1 / Sqrt(Dot(A, A)))
  movups    [Self], xmm0
  ret
  
_vector4_reflect:
  movups    xmm0, [Self]
  movups    xmm1, [Param2]
  movaps    xmm2, xmm0
  movaps    xmm3, [rel kSSE_TWO]

  ; Dot(N, I)
  mulps     xmm0, xmm1
  mulps     xmm3, xmm1 ; N * 2
  pshufd    xmm1, xmm0, 0x4E
  addps     xmm0, xmm1
  pshufd    xmm1, xmm0, 0x11
  addps     xmm0, xmm1

  ; (2 * Dot(N, I)) * N
  mulps     xmm0, xmm3

  ; I - ((2 * Dot(N, I)) * N)
  subps     xmm2, xmm0
  movaps    xmm0, xmm2
  movhlps   xmm1, xmm2
  ret
  
_vector4_refract:
  movups    xmm3, [Self]
  movups    xmm1, [Param2]
  movups    xmm7, xmm3
  movss     xmm2, [rel kSSE_ONE]

  ; D := Dot(N, I)
  mulps     xmm3, xmm1
  movss     xmm4, xmm2 ; 1
  pshufd    xmm1, xmm3, 0x4E
  movss     xmm5, xmm0 ; Eta
  addps     xmm3, xmm1
  mulss     xmm5, xmm5 ; Eta * Eta
  pshufd    xmm1, xmm3, 0x11
  addss     xmm3, xmm1

  ; K := 1 - Eta * Eta * (1 - D * D)
  movss     xmm6, xmm3  ; D
  mulss     xmm3, xmm3  ; D * D
  subss     xmm4, xmm3  ; 1 - D * D
  mulss     xmm4, xmm5  ; Eta * Eta * (1 - D * D)
  xorps     xmm5, xmm5  ; 0
  subss     xmm2, xmm4  ; K := 1 - Eta * Eta * (1 - D * D)

  ; if (K < 0) then
  comiss    xmm2, xmm5

  jb        _set_null_vec4

  ; K >= 0
  mulss     xmm6, xmm0    ; Eta * D
  shufps    xmm0, xmm0, 0 ; Replicate Eta (4x)
  mulps     xmm7, xmm0    ; Eta * I
  sqrtss    xmm2, xmm2    ; Sqrt(K)
  addss     xmm6, xmm2    ; Eta * D + Sqrt(K)
  shufps    xmm6, xmm6, 0 ; Replicate Eta * D + Sqrt(K) (4x)
  movups    xmm1, [Param2]
  mulps     xmm6, xmm1    ; ((Eta * D + Sqrt(K)) * N)
  subps     xmm7, xmm6    ; (Eta * I) - ((Eta * D + Sqrt(K)) * N)
  movaps    xmm0, xmm7
  movhlps   xmm1, xmm7
  ret

_set_null_vec4:
  ; K < 0: Result := Vector4(0, 0, 0, 0)
  movaps    xmm0, xmm5
  movhlps   xmm1, xmm5
  ret
  
;****************************************************************************
; TMatrix3
;****************************************************************************

_matrix3_add_single:
  movups    xmm1, [Param2 + 0x00] ; Load 3 rows
  shufps    xmm0, xmm0, 0         ; Replicate B
  movups    xmm3, [Param2 + 0x10]
  movss     xmm4, [Param2 + 0x20]
  addps     xmm1, xmm0            ; Add B to each row
  addps     xmm3, xmm0
  addss     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm3
  movss     [Param1 + 0x20], xmm4
  ret

_single_add_matrix3:
  movups    xmm1, [Param2 + 0x00] ; Load 3 rows
  shufps    xmm0, xmm0, 0         ; Replicate A
  movups    xmm2, [Param2 + 0x10]
  movss     xmm3, [Param2 + 0x20]
  addps     xmm1, xmm0            ; Add A to each row
  addps     xmm2, xmm0
  addss     xmm3, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movss     [Param1 + 0x20], xmm3
  ret

_matrix3_add_matrix3:
  movups    xmm0, [Param2 + 0x00] ; Load 3 rows of A
  movups    xmm1, [Param2 + 0x10]
  movss     xmm2, [Param2 + 0x20]
  movups    xmm4, [Param3 + 0x00] ; Load 3 rows of B
  movups    xmm5, [Param3 + 0x10]
  movss     xmm3, [Param3 + 0x20]
  addps     xmm0, xmm4            ; Add rows
  addps     xmm1, xmm5
  addss     xmm2, xmm3
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movss     [Param1 + 0x20], xmm2
  ret
  
_matrix3_sub_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 3 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movss     xmm3, [Param2 + 0x20]
  subps     xmm1, xmm0             ; Subtract B from each row
  subps     xmm2, xmm0
  subss     xmm3, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movss     [Param1 + 0x20], xmm3
  ret
  
_single_sub_matrix3:
  movups    xmm4, [Param2 + 0x00]  ; Load 3 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm5, [Param2 + 0x10]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movss     xmm6, [Param2 + 0x20]
  subps     xmm0, xmm4             ; Subtract each row from A
  subps     xmm1, xmm5
  subss     xmm2, xmm6
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movss     [Param1 + 0x20], xmm2
  ret
  
_matrix3_sub_matrix3:
  movups    xmm0, [Param2 + 0x00] ; Load 3 rows of A
  movups    xmm1, [Param2 + 0x10]
  movss     xmm2, [Param2 + 0x20]
  movups    xmm4, [Param3 + 0x00] ; Load 3 rows of B
  movups    xmm5, [Param3 + 0x10]
  movss     xmm6, [Param3 + 0x20]
  subps     xmm0, xmm4             ; Subtract rows
  subps     xmm1, xmm5
  subss     xmm2, xmm6
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movss     [Param1 + 0x20], xmm2
  ret
  
_matrix3_mul_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 3 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movss     xmm3, [Param2 + 0x20]
  mulps     xmm1, xmm0             ; Multiply each row by B
  mulps     xmm2, xmm0
  mulss     xmm3, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movss     [Param1 + 0x20], xmm3
  ret
  
_single_mul_matrix3:
  movups    xmm2, [Param2 + 0x00]  ; Load 3 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm1, [Param2 + 0x10]
  movss     xmm3, [Param2 + 0x20]
  mulps     xmm2, xmm0             ; Multiply each row by A
  mulps     xmm1, xmm0
  mulss     xmm3, xmm0
  movups    [Param1 + 0x00], xmm2
  movups    [Param1 + 0x10], xmm1
  movss     [Param1 + 0x20], xmm3
  ret
  
_matrix3_comp_mult:
  movups    xmm2, [Param2 + 0x00]  ; Self[0]
  movups    xmm0, [Param2 + 0x10]  ; Self[1]
  movss     xmm1, [Param2 + 0x20]  ; Self[2]
  movups    xmm4, [Param3 + 0x00]  ; AOther[0]
  movups    xmm5, [Param3 + 0x10]  ; AOther[1]
  movss     xmm3, [Param3 + 0x20]  ; AOther[2]

  ; Component-wise multiplication
  mulps     xmm2, xmm4
  mulps     xmm0, xmm5
  mulss     xmm1, xmm3

  ; Store result
  movups    [Param1 + 0x00], xmm2
  movups    [Param1 + 0x10], xmm0
  movss     [Param1 + 0x20], xmm1
  ret
  
%macro M3_MUL_V3 2
  movq      xmm0, [%2]         ; Load vector
  movss     xmm1, [%2+8]
  movlhps   xmm0, xmm1

  movq      xmm4, [%1 + 0x00]  ; Load 3 rows
  movss     xmm1, [%1 + 0x08]
  movlhps   xmm4, xmm1

  movaps    xmm1, xmm0
  movaps    xmm2, xmm0

  movq      xmm5, [%1 + 0x0C]
  movss     xmm6, [%1 + 0x14]
  movlhps   xmm5, xmm6

  movq      xmm6, [%1 + 0x18]
  movss     xmm3, [%1 + 0x20]
  movlhps   xmm6, xmm3

  mulps     xmm0, xmm4             ; ###, (Az * B02), (Ay * B01), (Ax * B00)
  mulps     xmm1, xmm5             ; ###, (Az * B12), (Ay * B11), (Ax * B10)
  mulps     xmm2, xmm6             ; ###, (Az * B22), (Ay * B21), (Ax * B20)
  xorps     xmm3, xmm3             ; 000

  ; Transpose xmm0-xmm2 
  movaps    xmm4, xmm2
  unpcklps  xmm2, xmm3             ; 000 B21 000 B20
  unpckhps  xmm4, xmm3             ; 000 ### 000 B22

  movaps    xmm3, xmm0
  unpcklps  xmm0, xmm1             ; B11 B01 B10 B00
  unpckhps  xmm3, xmm1             ; ### ### B12 B02

  movaps    xmm1, xmm0
  unpcklpd  xmm0, xmm2             ; 000 B20 B10 B00
  unpckhpd  xmm1, xmm2             ; 000 B21 B11 B01

  unpcklpd  xmm3, xmm4             ; 000 B22 B12 B02

  addps     xmm0, xmm1             ; Add rows
  addps     xmm0, xmm3
  movhlps   xmm1, xmm0
  ret
%endmacro

%macro V3_MUL_M3 2
  movq      xmm0, [%1]             ; Load vector
  movss     xmm1, [%1+8]
  movlhps   xmm0, xmm1

  movq      xmm4, [%2 + 0x00]      ; Load 3 rows
  movss     xmm1, [%2 + 0x08]
  movlhps   xmm4, xmm1

  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  shufps    xmm0, xmm0, 0x00       ; Bx Bx Bx Bx
  shufps    xmm1, xmm1, 0x55       ; By By By By
  shufps    xmm2, xmm2, 0xAA       ; Bz Bz Bz Bz

  movq      xmm5, [%2 + 0x0C]
  movss     xmm3, [%2 + 0x14]
  movlhps   xmm5, xmm3

  movq      xmm6, [%2 + 0x18]
  movss     xmm3, [%2 + 0x20]
  movlhps   xmm6, xmm3

  mulps     xmm0, xmm4             ; (A00 * Bx), (A01 * Bx), (A02 * Bx), #
  mulps     xmm1, xmm5             ; (A10 * By), (A11 * By), (A12 * By), #
  mulps     xmm2, xmm6             ; (A20 * Bz), (A21 * Bz), (A22 * Bz), #
  addps     xmm0, xmm1             ; Add rows
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
%endmacro

%macro M3_MUL_M3 2
  ; A.R[0] * B 
  movq      xmm0, [%1 + 0x00]
  movss     xmm1, [%1 + 0x08]
  movlhps   xmm0, xmm1

  movq      xmm4, [%2 + 0x00]
  movss     xmm1, [%2 + 0x08]
  movlhps   xmm4, xmm1

  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA

  movq      xmm5, [%2 + 0x0C]
  movss     xmm3, [%2 + 0x14]
  movlhps   xmm5, xmm3

  movq      xmm6, [%2 + 0x18]
  movss     xmm3, [%2 + 0x20]
  movlhps   xmm6, xmm3

  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  addps     xmm0, xmm1
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  movq      [Param1 + 0x00], xmm0
  movss     [Param1 + 0x08], xmm1

  ; A.R[1] * B 
  movq      xmm0, [%1 + 0x0C]
  movss     xmm1, [%1 + 0x14]
  movlhps   xmm0, xmm1

  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  addps     xmm0, xmm1
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  movq      [Param1 + 0x0C], xmm0
  movss     [Param1 + 0x14], xmm1

  ; A.R[2] * B 
  movq      xmm0, [%1 + 0x18]
  movss     xmm1, [%1 + 0x20]
  movlhps   xmm0, xmm1

  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  addps     xmm0, xmm1
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  movq      [Param1 + 0x18], xmm0
  movss     [Param1 + 0x20], xmm1
  ret
%endmacro
  
%ifdef FM_COLUMN_MAJOR
_matrix3_mul_vector3:
  V3_MUL_M3 Param2, Param1
  
_vector3_mul_matrix3:
  M3_MUL_V3 Param2, Param1
  
_matrix3_mul_matrix3:
  M3_MUL_M3 Param3, Param2
%else
_matrix3_mul_vector3:
  M3_MUL_V3 Param1, Param2
  
_vector3_mul_matrix3:
  V3_MUL_M3 Param1, Param2
  
_matrix3_mul_matrix3:
  M3_MUL_M3 Param2, Param3
%endif

_matrix3_div_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 3 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movss     xmm3, [Param2 + 0x20]
  divps     xmm1, xmm0             ; Divide each row by B
  divps     xmm2, xmm0
  divss     xmm3, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movss     [Param1 + 0x20], xmm3
  ret
  
_single_div_matrix3:
  movups    xmm4, [Param2 + 0x00]  ; Load 3 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm5, [Param2 + 0x10]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movss     xmm3, [Param2 + 0x20]
  divps     xmm0, xmm4             ; Divide A by each row
  divps     xmm1, xmm5
  divss     xmm2, xmm3
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movss     [Param1 + 0x20], xmm2
  ret
  
_matrix3_negative:
  movups    xmm0, [rel kSSE_MASK_SIGN]  ; Load mask with 4 sign (upper) bits
  movups    xmm1, [Param2 + 0x00]       ; Load 3 rows
  movups    xmm2, [Param2 + 0x10]
  movss     xmm3, [Param2 + 0x20]
  xorps     xmm1, xmm0                  ; Flip sign bits of each element in each row
  xorps     xmm2, xmm0
  pxor      xmm3, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movss     [Param1 + 0x20], xmm3
  ret
  
_matrix3_transpose:
  movss     xmm0, [Param2 + 0x00]
  movss     xmm1, [Param2 + 0x04]
  movss     xmm2, [Param2 + 0x08]

  movss     [Param1 + 0x00], xmm0
  movss     [Param1 + 0x0C], xmm1
  movss     [Param1 + 0x18], xmm2

  movss     xmm0, [Param2 + 0x0C]
  movss     xmm1, [Param2 + 0x10]
  movss     xmm2, [Param2 + 0x14]

  movss     [Param1 + 0x04], xmm0
  movss     [Param1 + 0x10], xmm1
  movss     [Param1 + 0x1C], xmm2

  movss     xmm0, [Param2 + 0x18]
  movss     xmm1, [Param2 + 0x1C]
  movss     xmm2, [Param2 + 0x20]

  movss     [Param1 + 0x08], xmm0
  movss     [Param1 + 0x14], xmm1
  movss     [Param1 + 0x20], xmm2
  ret
  
_matrix3_set_transposed:
  movss     xmm1, [Param1 + 0x04]
  movss     xmm2, [Param1 + 0x08]

  movss     xmm3, [Param1 + 0x0C]
  movss     xmm5, [Param1 + 0x14]

  movss     xmm6, [Param1 + 0x18]
  movss     xmm7, [Param1 + 0x1C]
  
  movss     [Param1 + 0x0C], xmm1
  movss     [Param1 + 0x18], xmm2

  movss     [Param1 + 0x04], xmm3
  movss     [Param1 + 0x1C], xmm5

  movss     [Param1 + 0x08], xmm6
  movss     [Param1 + 0x14], xmm7 
  ret
  
;****************************************************************************
; TMatrix4
;****************************************************************************
  
_matrix4_add_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  addps     xmm1, xmm0             ; Add B to each row
  addps     xmm2, xmm0
  addps     xmm3, xmm0
  addps     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
_single_add_matrix4:
  movups    xmm1, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  addps     xmm1, xmm0             ; Add A to each row
  addps     xmm2, xmm0
  addps     xmm3, xmm0
  addps     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
_matrix4_add_matrix4:
  movups    xmm0, [Param2 + 0x00] ; Load 4 rows of A
  movups    xmm1, [Param2 + 0x10]
  movups    xmm2, [Param2 + 0x20]
  movups    xmm3, [Param2 + 0x30]
  movups    xmm4, [Param3 + 0x00] ; Load 2 rows of B
  movups    xmm5, [Param3 + 0x10]
  addps     xmm0, xmm4             ; Add rows
  addps     xmm1, xmm5
  movups    xmm4, [Param3 + 0x20] ; Load 2 rows of B
  movups    xmm5, [Param3 + 0x30]
  addps     xmm2, xmm4             ; Add rows
  addps     xmm3, xmm5
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movups    [Param1 + 0x20], xmm2
  movups    [Param1 + 0x30], xmm3
  ret
  
_matrix4_sub_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  subps     xmm1, xmm0             ; Subtract B from each row
  subps     xmm2, xmm0
  subps     xmm3, xmm0
  subps     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
_single_sub_matrix4:
  movups    xmm4, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm5, [Param2 + 0x10]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  subps     xmm0, xmm4             ; Subtract each row from A
  subps     xmm1, xmm5
  movups    xmm4, [Param2 + 0x20]
  movups    xmm5, [Param2 + 0x30]
  subps     xmm2, xmm4
  subps     xmm3, xmm5
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movups    [Param1 + 0x20], xmm2
  movups    [Param1 + 0x30], xmm3
  ret
  
_matrix4_sub_matrix4:
  movups    xmm0, [Param2 + 0x00] ; Load 4 rows of A
  movups    xmm1, [Param2 + 0x10]
  movups    xmm2, [Param2 + 0x20]
  movups    xmm3, [Param2 + 0x30]
  movups    xmm4, [Param3 + 0x00] ; Load 4 rows of B
  movups    xmm5, [Param3 + 0x10]
  subps     xmm0, xmm4             ; Subtract rows
  subps     xmm1, xmm5
  movups    xmm4, [Param3 + 0x20]
  movups    xmm5, [Param3 + 0x30]
  subps     xmm2, xmm4
  subps     xmm3, xmm5
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movups    [Param1 + 0x20], xmm2
  movups    [Param1 + 0x30], xmm3
  ret                                           
  
_matrix4_mul_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  mulps     xmm1, xmm0             ; Multiply each row by B
  mulps     xmm2, xmm0
  mulps     xmm3, xmm0
  mulps     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret   
  
_single_mul_matrix4:
  movups    xmm1, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  mulps     xmm1, xmm0             ; Multiply each row by A
  mulps     xmm2, xmm0
  mulps     xmm3, xmm0
  mulps     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
_matrix4_comp_mult:
  movups    xmm0, [Param2 + 0x00]   ; Self[0]
  movups    xmm1, [Param2 + 0x10]   ; Self[1]
  movups    xmm2, [Param2 + 0x20]   ; Self[2]
  movups    xmm3, [Param2 + 0x30]   ; Self[3]
  movups    xmm4, [Param3 + 0x00] ; AOther[0]
  movups    xmm5, [Param3 + 0x10] ; AOther[1]

  ; Component-wise multiplication
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  movups    xmm4, [Param3 + 0x20] ; AOther[2]
  movups    xmm5, [Param3 + 0x30] ; AOther[3]
  mulps     xmm2, xmm4
  mulps     xmm3, xmm5

  ; Store result
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movups    [Param1 + 0x20], xmm2
  movups    [Param1 + 0x30], xmm3
  ret                                                   
  
%macro M4_MUL_V4 2
  movups    xmm0, [%2]             ; Load vector
  movups    xmm4, [%1 + 0x00]      ; Load 4 rows
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  movups    xmm5, [%1 + 0x10]
  mulps     xmm0, xmm4             ; (Ax * B00), (Ay * B01), (Az * B02), (Aw * B03)
  mulps     xmm1, xmm5             ; (Ax * B10), (Ay * B11), (Az * B12), (Aw * B13)
  movups    xmm4, [%1 + 0x20]
  movups    xmm5, [%1 + 0x30]
  mulps     xmm2, xmm4             ; (Ax * B20), (Ay * B21), (Az * B22), (Aw * B23)
  mulps     xmm3, xmm5             ; (Ax * B30), (Ay * B31), (Az * B32), (Aw * B33)

  ; Transpose xmm0-xmm3 
  movaps    xmm4, xmm2
  unpcklps  xmm2, xmm3             ; B32 B22 B33 B23
  unpckhps  xmm4, xmm3             ; B30 B20 B31 B21

  movaps    xmm3, xmm0
  unpcklps  xmm0, xmm1             ; B12 B02 B13 B03
  unpckhps  xmm3, xmm1             ; B10 B00 B11 B01

  movaps    xmm1, xmm0
  unpcklpd  xmm0, xmm2             ; B33 B23 B13 B03
  unpckhpd  xmm1, xmm2             ; B32 B22 B12 B02

  movaps    xmm2, xmm3
  unpcklpd  xmm2, xmm4             ; B31 B21 B11 B01
  unpckhpd  xmm3, xmm4             ; B30 B20 B10 B00

  addps     xmm0, xmm1             ; Add rows
  addps     xmm2, xmm3
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
%endmacro

%macro V4_MUL_M4 2
  movups    xmm0, [%1]             ; Load vector
  movups    xmm4, [%2 + 0x00]      ; Load 4 rows
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  shufps    xmm0, xmm0, 0x00       ; Bx Bx Bx Bx
  shufps    xmm1, xmm1, 0x55       ; By By By By
  shufps    xmm2, xmm2, 0xAA       ; Bz Bz Bz Bz
  shufps    xmm3, xmm3, 0xFF       ; Bw Bw Bw Bw
  movups    xmm5, [%2 + 0x10]
  mulps     xmm0, xmm4             ; (A00 * Bx), (A01 * Bx), (A02 * Bx), (A03 * Bx)
  mulps     xmm1, xmm5             ; (A10 * By), (A11 * By), (A12 * By), (A13 * By)
  movups    xmm4, [%2 + 0x20]
  movups    xmm5, [%2 + 0x30]
  mulps     xmm2, xmm4             ; (A20 * Bz), (A21 * Bz), (A22 * Bz), (A23 * Bz)
  mulps     xmm3, xmm5             ; (A30 * Bw), (A31 * Bw), (A32 * Bw), (A33 * Bw)
  addps     xmm0, xmm1             ; Add rows
  addps     xmm2, xmm3
  addps     xmm0, xmm2
  movhlps   xmm1, xmm0
  ret
%endmacro
  
%macro M4_MUL_M4 2
  ; A.R[0] * B 
  movups    xmm0, [%1 + 0x00]
  movups    xmm4, [%2 + 0x00]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA
  shufps    xmm3, xmm3, 0xFF
  movups    xmm5, [%2 + 0x10]
  movups    xmm6, [%2 + 0x20]
  movups    xmm7, [%2 + 0x30]
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  mulps     xmm3, xmm7
  addps     xmm0, xmm1
  addps     xmm2, xmm3
  addps     xmm0, xmm2
  movups    [Param1 + 0x00], xmm0

  ; A.R[1] * B 
  movups    xmm0, [%1 + 0x10]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA
  shufps    xmm3, xmm3, 0xFF
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  mulps     xmm3, xmm7
  addps     xmm0, xmm1
  addps     xmm2, xmm3
  addps     xmm0, xmm2
  movups    [Param1 + 0x10], xmm0

  ; A.R[2] * B 
  movups    xmm0, [%1 + 0x20]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA
  shufps    xmm3, xmm3, 0xFF
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  mulps     xmm3, xmm7
  addps     xmm0, xmm1
  addps     xmm2, xmm3
  addps     xmm0, xmm2
  movups    [Param1 + 0x20], xmm0

  ; A.R[3] * B 
  movups    xmm0, [%1 + 0x30]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  shufps    xmm0, xmm0, 0x00
  shufps    xmm1, xmm1, 0x55
  shufps    xmm2, xmm2, 0xAA
  shufps    xmm3, xmm3, 0xFF
  mulps     xmm0, xmm4
  mulps     xmm1, xmm5
  mulps     xmm2, xmm6
  mulps     xmm3, xmm7
  addps     xmm0, xmm1
  addps     xmm2, xmm3
  addps     xmm0, xmm2
  movups    [Param1 + 0x30], xmm0 
  ret
%endmacro

%ifdef FM_COLUMN_MAJOR
_matrix4_mul_vector4:
  V4_MUL_M4 Param2, Param1
  
_vector4_mul_matrix4:
  M4_MUL_V4 Param2, Param1
  
_matrix4_mul_matrix4:
  M4_MUL_M4 Param3, Param2
%else
_matrix4_mul_vector4:
  M4_MUL_V4 Param1, Param2
  
_vector4_mul_matrix4:
  V4_MUL_M4 Param1, Param2
  
_matrix4_mul_matrix4:
  M4_MUL_M4 Param2, Param3
%endif

_matrix4_div_single:
  movups    xmm1, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate B
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  divps     xmm1, xmm0             ; Divide each row by B
  divps     xmm2, xmm0             ; NOTE: We could speed it up by multiplying by
  divps     xmm3, xmm0             ; 1/B instead, using the "rcpps" instruction,
  divps     xmm4, xmm0             ; but that instruction is an approximation,
                                   ; so we lose accuracy.
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
_single_div_matrix4:
  movups    xmm4, [Param2 + 0x00]  ; Load 4 rows
  shufps    xmm0, xmm0, 0          ; Replicate A
  movups    xmm5, [Param2 + 0x10]
  movaps    xmm1, xmm0
  movaps    xmm2, xmm0
  movaps    xmm3, xmm0
  divps     xmm0, xmm4             ; Divide A by each row
  divps     xmm1, xmm5
  movups    xmm4, [Param2 + 0x20]
  movups    xmm5, [Param2 + 0x30]
  divps     xmm2, xmm4
  divps     xmm3, xmm5
  movups    [Param1 + 0x00], xmm0
  movups    [Param1 + 0x10], xmm1
  movups    [Param1 + 0x20], xmm2
  movups    [Param1 + 0x30], xmm3
  ret
  
_matrix4_negative:
  movaps    xmm0, [rel kSSE_MASK_SIGN]  ; Load mask with 4 sign (upper) bits
  movups    xmm1, [Param2 + 0x00]       ; Load 4 rows
  movups    xmm2, [Param2 + 0x10]
  movups    xmm3, [Param2 + 0x20]
  movups    xmm4, [Param2 + 0x30]
  xorps     xmm1, xmm0                  ; Flip sign bits of each element in each row
  xorps     xmm2, xmm0
  xorps     xmm3, xmm0
  xorps     xmm4, xmm0
  movups    [Param1 + 0x00], xmm1
  movups    [Param1 + 0x10], xmm2
  movups    [Param1 + 0x20], xmm3
  movups    [Param1 + 0x30], xmm4
  ret
  
%macro M4_INVERSE 2  
  movups    xmm1, [%2 + 0x10]      ; M[1]
  movups    xmm2, [%2 + 0x20]      ; M[2]
  movups    xmm3, [%2 + 0x30]      ; M[3]

  ;  C00 := (A.M[2,2] * A.M[3,3]) - (A.M[3,2] * A.M[2,3]);
  ;  C02 := (A.M[1,2] * A.M[3,3]) - (A.M[3,2] * A.M[1,3]);
  ;  C03 := (A.M[1,2] * A.M[2,3]) - (A.M[2,2] * A.M[1,3]);
  ;  F0 := Vector4(C00, C00, C02, C03);
  movaps    xmm5, xmm2             ; M[2]
  movaps    xmm7, xmm2             ; M[2]
  movaps    xmm0, xmm3             ; M[3]
  movaps    xmm6, xmm3             ; M[3]
  shufps    xmm6, xmm2, 0xAA       ; M22 M22 M32 M32
  shufps    xmm0, xmm2, 0xFF       ; M23 M23 M33 M33
  shufps    xmm7, xmm1, 0xFF       ; M13 M13 M23 M23
  pshufd    xmm4, xmm0, 0x80       ; M23 M33 M33 M33
  shufps    xmm5, xmm1, 0xAA       ; M12 M12 M22 M22
  pshufd    xmm0, xmm6, 0x80       ; M22 M32 M32 M32
  mulps     xmm5, xmm4             ; (M12 * M23) (M12 * M33) (M22 * M33) (M22 * M33)
  mulps     xmm7, xmm0             ; (M22 * M13) (M32 * M13) (M32 * M23) (M32 * M23)
  subps     xmm5, xmm7             ; C03=(M12*M23)-(M22*M13), C02=(M12*M33)-(M32*M13), C00=(M22*M33)-(M32*M23), C00=(M22*M33)-(M32*M23)
  movups    xmm8, xmm5

  ;  C04 := (A.M[2,1] * A.M[3,3]) - (A.M[3,1] * A.M[2,3]);
  ;  C06 := (A.M[1,1] * A.M[3,3]) - (A.M[3,1] * A.M[1,3]);
  ;  C07 := (A.M[1,1] * A.M[2,3]) - (A.M[2,1] * A.M[1,3]);
  ;  F1 := Vector4(C04, C04, C06, C07);
  movaps    xmm5, xmm2             ; M[2]
  movaps    xmm7, xmm2             ; M[2]
  movaps    xmm0, xmm3             ; M[3]
  movaps    xmm6, xmm3             ; M[3]
  shufps    xmm6, xmm2, 0x55       ; M21 M21 M31 M31
  shufps    xmm0, xmm2, 0xFF       ; M23 M23 M33 M33
  shufps    xmm7, xmm1, 0xFF       ; M13 M13 M23 M23
  pshufd    xmm4, xmm0, 0x80       ; M23 M33 M33 M33
  shufps    xmm5, xmm1, 0x55       ; M11 M11 M21 M21
  pshufd    xmm0, xmm6, 0x80       ; M21 M31 M31 M31
  mulps     xmm5, xmm4             ; (M11 * M23) (M11 * M33) (M21 * M33) (M21 * M33)
  mulps     xmm7, xmm0             ; (M21 * M13) (M31 * M13) (M31 * M23) (M31 * M23)
  subps     xmm5, xmm7             ; C07=(M11*M23)-(M21*M13), C06=(M11*M33)-(M31*M13), C04=(M21*M33)-(M31*M23), C04=(M21*M33)-(M31*M23)
  movups    xmm9, xmm5

  ;  C08 := (A.M[2,1] * A.M[3,2]) - (A.M[3,1] * A.M[2,2]);
  ;  C10 := (A.M[1,1] * A.M[3,2]) - (A.M[3,1] * A.M[1,2]);
  ;  C11 := (A.M[1,1] * A.M[2,2]) - (A.M[2,1] * A.M[1,2]);
  ;  F2 := Vector4(C08, C08, C10, C11);
  movaps    xmm5, xmm2             ; M[2]
  movaps    xmm7, xmm2             ; M[2]
  movaps    xmm0, xmm3             ; M[3]
  movaps    xmm6, xmm3             ; M[3]
  shufps    xmm6, xmm2, 0x55       ; M21 M21 M31 M31
  shufps    xmm0, xmm2, 0xAA       ; M22 M22 M32 M32
  shufps    xmm7, xmm1, 0xAA       ; M12 M12 M22 M22
  pshufd    xmm4, xmm0, 0x80       ; M22 M32 M32 M32
  shufps    xmm5, xmm1, 0x55       ; M11 M11 M21 M21
  pshufd    xmm0, xmm6, 0x80       ; M21 M31 M31 M31
  mulps     xmm5, xmm4             ; (M11 * M22) (M11 * M32) (M21 * M32) (M21 * M32)
  mulps     xmm7, xmm0             ; (M21 * M12) (M31 * M12) (M31 * M22) (M32 * M22)
  subps     xmm5, xmm7             ; C11=(M11*M22)-(M21*M12), C10=(M11*M32)-(M31*M12), C08=(M21*M32)-(M31*M22), C08=(M21*M32)-(M31*M22)
  movups    xmm10, xmm5

  ;  C12 := (A.M[2,0] * A.M[3,3]) - (A.M[3,0] * A.M[2,3]);
  ;  C14 := (A.M[1,0] * A.M[3,3]) - (A.M[3,0] * A.M[1,3]);
  ;  C15 := (A.M[1,0] * A.M[2,3]) - (A.M[2,0] * A.M[1,3]);
  ;  F3 := Vector4(C12, C12, C14, C15);
  movaps    xmm5, xmm2             ; M[2]
  movaps    xmm7, xmm2             ; M[2]
  movaps    xmm0, xmm3             ; M[3]
  movaps    xmm6, xmm3             ; M[3]
  shufps    xmm6, xmm2, 0x00       ; M20 M20 M30 M30
  shufps    xmm0, xmm2, 0xFF       ; M23 M23 M33 M33
  shufps    xmm7, xmm1, 0xFF       ; M13 M13 M23 M23
  pshufd    xmm4, xmm0, 0x80       ; M23 M33 M33 M33
  shufps    xmm5, xmm1, 0x00       ; M10 M10 M20 M20
  pshufd    xmm0, xmm6, 0x80       ; M20 M30 M30 M30
  mulps     xmm5, xmm4             ; (M10 * M23) (M10 * M33) (M20 * M33) (M20 * M33)
  mulps     xmm7, xmm0             ; (M20 * M13) (M30 * M13) (M30 * M23) (M30 * M23)
  subps     xmm5, xmm7             ; C15=(M10*M23)-(M20*M13), C14=(M10*M33)-(M30*M13), C12=(M20*M33)-(M30*M23), C12=(M20*M33)-(M30*M23)
  movups    xmm11, xmm5

  ;  C16 := (A.M[2,0] * A.M[3,2]) - (A.M[3,0] * A.M[2,2]);
  ;  C18 := (A.M[1,0] * A.M[3,2]) - (A.M[3,0] * A.M[1,2]);
  ;  C19 := (A.M[1,0] * A.M[2,2]) - (A.M[2,0] * A.M[1,2]);
  ;  F4 := Vector4(C16, C16, C18, C19);
  movaps    xmm5, xmm2             ; M[2]
  movaps    xmm7, xmm2             ; M[2]
  movaps    xmm0, xmm3             ; M[3]
  movaps    xmm6, xmm3             ; M[3]
  shufps    xmm6, xmm2, 0x00       ; M20 M20 M30 M30
  shufps    xmm0, xmm2, 0xAA       ; M22 M22 M32 M32
  shufps    xmm7, xmm1, 0xAA       ; M12 M12 M22 M22
  pshufd    xmm4, xmm0, 0x80       ; M22 M32 M32 M32
  shufps    xmm5, xmm1, 0x00       ; M10 M10 M20 M20
  pshufd    xmm0, xmm6, 0x80       ; M20 M30 M30 M30
  mulps     xmm5, xmm4             ; (M10 * M22) (M10 * M32) (M20 * M32) (M20 * M32)
  mulps     xmm7, xmm0             ; (M20 * M12) (M30 * M12) (M30 * M22) (M30 * M22)
  subps     xmm5, xmm7             ; C19=(M10*M22)-(M20*M12), C18=(M10*M32)-(M30*M12), C16=(M20*M32)-(M30*M22), C16=(M20*M32)-(M30*M22)
  movups    xmm12, xmm5

  ;  C20 := (A.M[2,0] * A.M[3,1]) - (A.M[3,0] * A.M[2,1]);
  ;  C22 := (A.M[1,0] * A.M[3,1]) - (A.M[3,0] * A.M[1,1]);
  ;  C23 := (A.M[1,0] * A.M[2,1]) - (A.M[2,0] * A.M[1,1]);
  ;  F5 := Vector4(C20, C20, C22, C23);
  movaps    xmm5, xmm2             ; M[2]
  movaps    xmm7, xmm2             ; M[2]
  movaps    xmm0, xmm3             ; M[3]
  movaps    xmm6, xmm3             ; M[3]
  shufps    xmm6, xmm2, 0x00       ; M20 M20 M30 M30
  shufps    xmm0, xmm2, 0x55       ; M21 M21 M31 M31
  shufps    xmm7, xmm1, 0x55       ; M11 M11 M21 M21
  pshufd    xmm4, xmm0, 0x80       ; M21 M31 M31 M31
  shufps    xmm5, xmm1, 0x00       ; M10 M10 M20 M20
  pshufd    xmm0, xmm6, 0x80       ; M20 M30 M30 M30
  mulps     xmm5, xmm4             ; (M10 * M21) (M10 * M31) (M20 * M31) (M20 * M31)
  mulps     xmm7, xmm0             ; (M20 * M11) (M30 * M11) (M30 * M21) (M30 * M21)
  subps     xmm5, xmm7             ; C23=(M10*M21)-(M20*M11), C22=(M10*M31)-(M30*M11), C20=(M20*M31)-(M30*M21), C20=(M20*M31)-(M30*M21)
  movups    xmm13, xmm5

  ;  V0 := Vector4(A.M[1,0], A.M[0,0], A.M[0,0], A.M[0,0]);
  ;  V1 := Vector4(A.M[1,1], A.M[0,1], A.M[0,1], A.M[0,1]);
  ;  V2 := Vector4(A.M[1,2], A.M[0,2], A.M[0,2], A.M[0,2]);
  ;  V3 := Vector4(A.M[1,3], A.M[0,3], A.M[0,3], A.M[0,3]);
  movups    xmm0, [%2 + 0x00]      ; M[0]
  movaps    xmm4, xmm1             ; M[1]
  movaps    xmm5, xmm1             ; M[1]
  movaps    xmm6, xmm1             ; M[1]
  movaps    xmm7, xmm1             ; M[1]

  shufps    xmm4, xmm0, 0x00       ; M00 M00 M10 M10
  shufps    xmm5, xmm0, 0x55       ; M01 M01 M11 M11
  shufps    xmm6, xmm0, 0xAA       ; M02 M02 M12 M12
  shufps    xmm7, xmm0, 0xFF       ; M03 M03 M13 M13

  pshufd    xmm4, xmm4, 0xA8       ; V0=M00 M00 M00 M10
  pshufd    xmm5, xmm5, 0xA8       ; V1=M01 M01 M01 M11
  pshufd    xmm6, xmm6, 0xA8       ; V2=M02 M02 M02 M12
  pshufd    xmm7, xmm7, 0xA8       ; V3=M03 M03 M03 M13

  ;  I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
  ;  I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
  ;  I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
  ;  I3 := (V0 * F2) - (V1 * F4) + (V2 * F5);
  movaps    xmm0, xmm5             ; V1
  movaps    xmm1, xmm6             ; V2
  movaps    xmm2, xmm7             ; V3
  mulps     xmm0, xmm8             ; V1 * F0
  mulps     xmm1, xmm9             ; V2 * F1
  mulps     xmm2, xmm10            ; V3 * F2
  subps     xmm0, xmm1             ; (V1 * F0) - (V2 * F1)
  movaps    xmm1, xmm4             ; V0
  addps     xmm0, xmm2             ; I0=(V1 * F0) - (V2 * F1) + (V3 * F2)

  movaps    xmm2, xmm6             ; V2
  movaps    xmm3, xmm7             ; V3
  mulps     xmm1, xmm8             ; V0 * F0
  mulps     xmm2, xmm11            ; V2 * F3
  mulps     xmm3, xmm12            ; V3 * F4
  subps     xmm1, xmm2             ; (V0 * F0) - (V2 * F3)
  movaps    xmm2, xmm4             ; V0
  addps     xmm1, xmm3             ; I1=(V0 * F0) - (V2 * F3) + (V3 * F4)

  movaps    xmm3, xmm5             ; V1
  mulps     xmm2, xmm9             ; V0 * F1
  mulps     xmm3, xmm11            ; V1 * F3
  mulps     xmm7, xmm13            ; V3 * F5
  subps     xmm2, xmm3             ; (V0 * F1) - (V1 * F3)
  mulps     xmm4, xmm10            ; V0 * F2
  addps     xmm2, xmm7             ; I2=(V0 * F1) - (V1 * F3) + (V3 * F5)

  mulps     xmm5, xmm12            ; V1 * F4
  mulps     xmm6, xmm13            ; V2 * F5
  subps     xmm4, xmm5             ; (V0 * F2) - (V1 * F4)
  addps     xmm4, xmm6             ; I3=(V0 * F2) - (V1 * F4) + (V2 * F5)

  ;  SA := Vector4(+1, -1, +1, -1);
  ;  SB := Vector4(-1, +1, -1, +1);
  ;  Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB);

  movaps    xmm6, [rel kSSE_MASK_PNPN] ; SA
  movaps    xmm7, [rel kSSE_MASK_NPNP] ; SB
  xorps     xmm0, xmm6             ; Inv[0] = I0 * SA
  xorps     xmm1, xmm7             ; Inv[1] = I1 * SB
  xorps     xmm2, xmm6             ; Inv[2] = I2 * SA
  xorps     xmm4, xmm7             ; Inv[3] = I3 * SB

  ;  Row := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
  movaps    xmm3, xmm0
  movaps    xmm5, xmm2
  movaps    xmm6, xmm1

  unpcklps  xmm3, xmm1             ; Inv[1,1] Inv[0,1] Inv[1,0] Inv[0,0]
  unpcklps  xmm5, xmm4             ; Inv[3,1] Inv[2,1] Inv[3,0] Inv[2,0]
  movups    xmm6, [%2 + 0x00]      ; A.C[0]
  movlhps   xmm3, xmm5             ; Inv[3,0] Inv[2,0] Inv[1,0] Inv[0,0]

  ;  Dot := A.C[0] * Row;
  mulps     xmm3, xmm6             ; Dot.W  Dot.Z  Dot.Y  Dot.X

  ;  OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W));
  pshufd    xmm6, xmm3, 0x4E       ; Dot.Y  Dot.X  Dot.W  Dot.Z
  addps     xmm3, xmm6             ; W+Y Z+X Y+W X+Z
  pshufd    xmm6, xmm3, 0x11       ; X+Z Y+X X+Z Y+W
  movaps    xmm5, [rel kSSE_ONE]   ; 1.0 (4x)
  addps     xmm3, xmm6             ; X+Y+Z+W (4x)
  divps     xmm5, xmm3             ; OneOverDeterminant (4x)

  ;  Result := Inv * OneOverDeterminant;
  mulps     xmm0, xmm5
  mulps     xmm1, xmm5
  mulps     xmm2, xmm5
  mulps     xmm4, xmm5

  movups    [%1 + 0x00], xmm0
  movups    [%1 + 0x10], xmm1
  movups    [%1 + 0x20], xmm2
  movups    [%1 + 0x30], xmm4
  ret
%endmacro  

_matrix4_inverse:
  M4_INVERSE Param1, Param2

_matrix4_set_inversed:
  M4_INVERSE Param1, Param1
  
%macro M4_TRANSPOSE 2  
  movups    xmm0, [%2 + 0x00]        ; A03 A02 A01 A00
  movups    xmm1, [%2 + 0x10]        ; A13 A12 A11 A10
  movups    xmm2, [%2 + 0x20]        ; A23 A22 A21 A20
  movups    xmm3, [%2 + 0x30]        ; A33 A32 A31 A30

  movaps    xmm4, xmm2
  unpcklps  xmm2, xmm3               ; A31 A21 A30 A20
  unpckhps  xmm4, xmm3               ; A33 A23 A32 A22

  movaps    xmm3, xmm0
  unpcklps  xmm0, xmm1               ; A11 A01 A10 A00
  unpckhps  xmm3, xmm1               ; A13 A03 A12 A02

  movaps    xmm1, xmm0
  unpcklpd  xmm0, xmm2               ; A30 A20 A10 A00
  unpckhpd  xmm1, xmm2               ; A31 A21 A11 A01

  movaps    xmm2, xmm3
  unpcklpd  xmm2, xmm4               ; A32 A22 A12 A02
  unpckhpd  xmm3, xmm4               ; A33 A23 A13 A03

  movups    [%1 + 0x00], xmm0
  movups    [%1 + 0x10], xmm1
  movups    [%1 + 0x20], xmm2
  movups    [%1 + 0x30], xmm3
  ret
%endmacro  

_matrix4_transpose:
  M4_TRANSPOSE Param1, Param2
  
_matrix4_set_transposed:
  M4_TRANSPOSE Param1, Param1