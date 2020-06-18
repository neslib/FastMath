{ These declarations need to be in the "interface" section of this unit for
  Delphi's inlining to work }

{$IF Defined(FM_ARM)}
const
  {$IF Defined(IOS)}
  { @exclude }
  _LIB_FASTMATH = 'libfastmath-ios.a';
  { @exclude }
  _PREFIX = '';
  {$ELSEIF Defined(ANDROID64)}
  { @exclude }
  _LIB_FASTMATH = 'libfastmath-android-64.a';
  _PREFIX = '_';
  {$ELSEIF Defined(ANDROID)}
  {$IF (RTLVersion = 33)}
  { Delphi 10.3 uses Thumb mode. }
  { @exclude }
  _LIB_FASTMATH = 'libfastmath-android-32.a';
  {$ELSE}
  { Delphi 10.2 and earlier and Delphi 10.4 and later use ARM mode. }
  { @exclude }
  _LIB_FASTMATH = 'libfastmath-android-arm.a';
  {$ENDIF}
  { @exclude }
  _PREFIX = '_';
  {$ELSE}
    {$MESSAGE Error 'Unsupported ARM platform for FaseMath'}
  {$ENDIF}

{ @exclude }
function _radians_scalar(ADegrees: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'radians_scalar';

{ @exclude }
procedure _radians_vector2(ADegrees, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'radians_vector2';

{ @exclude }
procedure _radians_vector3(ADegrees, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'radians_vector3';

{ @exclude }
procedure _radians_vector4(ADegrees, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'radians_vector4';

{ @exclude }
function _degrees_scalar(ADegrees: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'degrees_scalar';

{ @exclude }
procedure _degrees_vector2(ARadians, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'degrees_vector2';

{ @exclude }
procedure _degrees_vector3(ARadians, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'degrees_vector3';

{ @exclude }
procedure _degrees_vector4(ARadians, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'degrees_vector4';

{ @exclude }
function _sqrt_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sqrt_scalar';

{ @exclude }
procedure _sqrt_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sqrt_vector2';

{ @exclude }
procedure _sqrt_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sqrt_vector3';

{ @exclude }
procedure _sqrt_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sqrt_vector4';

{ @exclude }
function _inverse_sqrt_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'inverse_sqrt_scalar';

{ @exclude }
procedure _inverse_sqrt_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'inverse_sqrt_vector2';

{ @exclude }
procedure _inverse_sqrt_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'inverse_sqrt_vector3';

{ @exclude }
procedure _inverse_sqrt_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'inverse_sqrt_vector4';

{ @exclude }
procedure _fast_sincos_scalar(A: Single; ASin, ACos: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_sincos_scalar';

{ @exclude }
procedure _fast_sincos_vector2(A, ASin, ACos: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_sincos_vector2';

{ @exclude }
procedure _fast_sincos_vector3(A, ASin, ACos: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_sincos_vector3';

{ @exclude }
procedure _fast_sincos_vector4(A, ASin, ACos: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_sincos_vector4';

{ @exclude }
function _fast_exp_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp_scalar';

{ @exclude }
procedure _fast_exp_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp_vector2';

{ @exclude }
procedure _fast_exp_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp_vector3';

{ @exclude }
procedure _fast_exp_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp_vector4';

{ @exclude }
function _fast_ln_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_ln_scalar';

{ @exclude }
procedure _fast_ln_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_ln_vector2';

{ @exclude }
procedure _fast_ln_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_ln_vector3';

{ @exclude }
procedure _fast_ln_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_ln_vector4';

{ @exclude }
function _fast_log2_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_log2_scalar';

{ @exclude }
procedure _fast_log2_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_log2_vector2';

{ @exclude }
procedure _fast_log2_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_log2_vector3';

{ @exclude }
procedure _fast_log2_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_log2_vector4';

{ @exclude }
function _fast_exp2_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp2_scalar';

{ @exclude }
procedure _fast_exp2_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp2_vector2';

{ @exclude }
procedure _fast_exp2_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp2_vector3';

{ @exclude }
procedure _fast_exp2_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fast_exp2_vector4';

{ @exclude }
function _abs_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'abs_scalar';

{ @exclude }
procedure _abs_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'abs_vector2';

{ @exclude }
procedure _abs_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'abs_vector3';

{ @exclude }
procedure _abs_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'abs_vector4';

{ @exclude }
function _sign_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sign_scalar';

{ @exclude }
procedure _sign_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sign_vector2';

{ @exclude }
procedure _sign_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sign_vector3';

{ @exclude }
procedure _sign_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'sign_vector4';

{ @exclude }
function _floor_scalar(A: Single): Integer;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'floor_scalar';

{ @exclude }
procedure _floor_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'floor_vector2';

{ @exclude }
procedure _floor_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'floor_vector3';

{ @exclude }
procedure _floor_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'floor_vector4';

{ @exclude }
function _trunc_scalar(A: Single): Integer;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'trunc_scalar';

{ @exclude }
procedure _trunc_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'trunc_vector2';

{ @exclude }
procedure _trunc_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'trunc_vector3';

{ @exclude }
procedure _trunc_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'trunc_vector4';

{ @exclude }
function _round_scalar(A: Single): Integer;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'round_scalar';

{ @exclude }
procedure _round_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'round_vector2';

{ @exclude }
procedure _round_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'round_vector3';

{ @exclude }
procedure _round_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'round_vector4';

{ @exclude }
function _ceil_scalar(A: Single): Integer;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ceil_scalar';

{ @exclude }
procedure _ceil_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ceil_vector2';

{ @exclude }
procedure _ceil_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ceil_vector3';

{ @exclude }
procedure _ceil_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ceil_vector4';

{ @exclude }
function _frac_scalar(A: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'frac_scalar';

{ @exclude }
procedure _frac_vector2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'frac_vector2';

{ @exclude }
procedure _frac_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'frac_vector3';

{ @exclude }
procedure _frac_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'frac_vector4';

{ @exclude }
function _fmod_scalar(A, B: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_scalar';

{ @exclude }
procedure _fmod_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_vector2';

{ @exclude }
procedure _fmod_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_vector3';

{ @exclude }
procedure _fmod_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_vector4';

{ @exclude }
procedure _fmod_vector2_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_vector2_scalar';

{ @exclude }
procedure _fmod_vector3_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_vector3_scalar';

{ @exclude }
procedure _fmod_vector4_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fmod_vector4_scalar';

{ @exclude }
function _modf_scalar(A: Single; B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'modf_scalar';

{ @exclude }
procedure _modf_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'modf_vector2';

{ @exclude }
procedure _modf_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'modf_vector3';

{ @exclude }
procedure _modf_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'modf_vector4';

{ @exclude }
procedure _min_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'min_vector2';

{ @exclude }
procedure _min_vector2_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'min_vector2_scalar';

{ @exclude }
procedure _min_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'min_vector3';

{ @exclude }
procedure _min_vector3_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'min_vector3_scalar';

{ @exclude }
procedure _min_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'min_vector4';

{ @exclude }
procedure _min_vector4_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'min_vector4_scalar';

{ @exclude }
procedure _max_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'max_vector2';

{ @exclude }
procedure _max_vector2_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'max_vector2_scalar';

{ @exclude }
procedure _max_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'max_vector3';

{ @exclude }
procedure _max_vector3_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'max_vector3_scalar';

{ @exclude }
procedure _max_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'max_vector4';

{ @exclude }
procedure _max_vector4_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'max_vector4_scalar';

{ @exclude }
function _ensure_range_scalar(A, AMin, AMax: Single): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_scalar';

{ @exclude }
procedure _ensure_range_vector2(A, AMin, AMax, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_vector2';

{ @exclude }
procedure _ensure_range_vector2_scalar(A: Pointer; AMin, AMax: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_vector2_scalar';

{ @exclude }
procedure _ensure_range_vector3(A, AMin, AMax, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_vector3';

{ @exclude }
procedure _ensure_range_vector3_scalar(A: Pointer; AMin, AMax: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_vector3_scalar';

{ @exclude }
procedure _ensure_range_vector4(A, AMin, AMax, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_vector4';

{ @exclude }
procedure _ensure_range_vector4_scalar(A: Pointer; AMin, AMax: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'ensure_range_vector4_scalar';

{ @exclude }
procedure _mix_vector2(A, B, T, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'mix_vector2';

{ @exclude }
procedure _mix_vector2_scalar(A, B: Pointer; T: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'mix_vector2_scalar';

{ @exclude }
procedure _mix_vector3(A, B, T, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'mix_vector3';

{ @exclude }
procedure _mix_vector3_scalar(A, B: Pointer; T: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'mix_vector3_scalar';

{ @exclude }
procedure _mix_vector4(A, B, T, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'mix_vector4';

{ @exclude }
procedure _mix_vector4_scalar(A, B: Pointer; T: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'mix_vector4_scalar';

{ @exclude }
procedure _step_vector2(AEdge, A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'step_vector2';

{ @exclude }
procedure _step_scalar_vector2(AEdge: Single; A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'step_scalar_vector2';

{ @exclude }
procedure _step_vector3(AEdge, A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'step_vector3';

{ @exclude }
procedure _step_scalar_vector3(AEdge: Single; A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'step_scalar_vector3';

{ @exclude }
procedure _step_vector4(AEdge, A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'step_vector4';

{ @exclude }
procedure _step_scalar_vector4(AEdge: Single; A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'step_scalar_vector4';

{ @exclude }
procedure _smoothstep_vector2(AEdge0, AEdge1, A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'smoothstep_vector2';

{ @exclude }
procedure _smoothstep_scalar_vector2(AEdge0, AEdge1: Single; A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'smoothstep_scalar_vector2';

{ @exclude }
procedure _smoothstep_vector3(AEdge0, AEdge1, A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'smoothstep_vector3';

{ @exclude }
procedure _smoothstep_scalar_vector3(AEdge0, AEdge1: Single; A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'smoothstep_scalar_vector3';

{ @exclude }
procedure _smoothstep_vector4(AEdge0, AEdge1, A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'smoothstep_vector4';

{ @exclude }
procedure _smoothstep_scalar_vector4(AEdge0, AEdge1: Single; A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'smoothstep_scalar_vector4';

{ @exclude }
procedure _fma_vector2(A, B, C, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fma_vector2';

{ @exclude }
procedure _fma_vector3(A, B, C, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fma_vector3';

{ @exclude }
procedure _fma_vector4(A, B, C, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'fma_vector4';

{ @exclude }
function _vector2_length(A: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_length';

{ @exclude }
function _vector3_length(A: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_length';

{ @exclude }
function _vector4_length(A: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_length';

{ @exclude }
function _vector2_distance(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_distance';

{ @exclude }
function _vector3_distance(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_distance';

{ @exclude }
function _vector4_distance(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_distance';

{ @exclude }
function _vector2_distance_squared(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_distance_squared';

{ @exclude }
function _vector3_distance_squared(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_distance_squared';

{ @exclude }
function _vector4_distance_squared(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_distance_squared';

{ @exclude }
function _vector2_dot(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_dot';

{ @exclude }
function _vector3_dot(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_dot';

{ @exclude }
function _vector4_dot(A, B: Pointer): Single;
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_dot';

{ @exclude }
procedure _vector3_cross(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_cross';

{ @exclude }
procedure _vector2_normalize_fast(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_normalize';

{ @exclude }
procedure _vector3_normalize_fast(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_normalize';

{ @exclude }
procedure _vector4_normalize_fast(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_normalize';

{ @exclude }
procedure _vector2_faceforward(N, I, NRef, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_faceforward';

{ @exclude }
procedure _vector3_faceforward(N, I, NRef, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_faceforward';

{ @exclude }
procedure _vector4_faceforward(N, I, NRef, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_faceforward';

{ @exclude }
procedure _vector2_reflect(I, N, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_reflect';

{ @exclude }
procedure _vector3_reflect(I, N, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_reflect';

{ @exclude }
procedure _vector4_reflect(I, N, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_reflect';

{ @exclude }
procedure _vector2_refract(I, N: Pointer; Eta: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_refract';

{ @exclude }
procedure _vector3_refract(I, N: Pointer; Eta: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_refract';

{ @exclude }
procedure _vector4_refract(I, N: Pointer; Eta: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_refract';

{ @exclude }
procedure _matrix2_comp_mult(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_comp_mult';

{ @exclude }
procedure _matrix3_comp_mult(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_comp_mult';

{ @exclude }
procedure _matrix4_comp_mult(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_comp_mult';

{ @exclude }
procedure _outer_product_matrix2(C, R, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'outer_product_matrix2';

{ @exclude }
procedure _outer_product_matrix3(C, R, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'outer_product_matrix3';

{ @exclude }
procedure _outer_product_matrix4(C, R, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'outer_product_matrix4';

{ @exclude }
procedure _matrix2_transpose(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_transpose';

{ @exclude }
procedure _matrix3_transpose(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_transpose';

{ @exclude }
procedure _matrix4_transpose(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_transpose';

{ @exclude }
procedure _matrix4_inverse(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_inverse';

{ @exclude }
procedure _vector2_add_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_add_scalar';

{ @exclude }
procedure _scalar_add_vector2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_add_vector2';

{ @exclude }
procedure _vector2_add_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_add_vector2';

{ @exclude }
procedure _vector2_sub_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_sub_scalar';

{ @exclude }
procedure _scalar_sub_vector2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_sub_vector2';

{ @exclude }
procedure _vector2_sub_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_sub_vector2';

{ @exclude }
procedure _vector2_mul_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_mul_scalar';

{ @exclude }
procedure _scalar_mul_vector2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_mul_vector2';

{ @exclude }
procedure _vector2_mul_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_mul_vector2';

{ @exclude }
procedure _vector2_div_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_div_scalar';

{ @exclude }
procedure _scalar_div_vector2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_div_vector2';

{ @exclude }
procedure _vector2_div_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_div_vector2';

{ @exclude }
procedure _neg_vector3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'neg_vector3';

{ @exclude }
procedure _neg_vector4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'neg_vector4';

{ @exclude }
procedure _vector3_add_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_add_scalar';

{ @exclude }
procedure _vector4_add_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_add_scalar';

{ @exclude }
procedure _scalar_add_vector3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_add_vector3';

{ @exclude }
procedure _scalar_add_vector4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_add_vector4';

{ @exclude }
procedure _vector3_add_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_add_vector3';

{ @exclude }
procedure _vector4_add_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_add_vector4';

{ @exclude }
procedure _vector3_sub_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_sub_scalar';

{ @exclude }
procedure _vector4_sub_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_sub_scalar';

{ @exclude }
procedure _scalar_sub_vector3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_sub_vector3';

{ @exclude }
procedure _scalar_sub_vector4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_sub_vector4';

{ @exclude }
procedure _vector3_sub_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_sub_vector3';

{ @exclude }
procedure _vector4_sub_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_sub_vector4';

{ @exclude }
procedure _vector3_mul_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_mul_scalar';

{ @exclude }
procedure _vector4_mul_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_mul_scalar';

{ @exclude }
procedure _scalar_mul_vector3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_mul_vector3';

{ @exclude }
procedure _scalar_mul_vector4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_mul_vector4';

{ @exclude }
procedure _vector3_mul_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_mul_vector3';

{ @exclude }
procedure _vector4_mul_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_mul_vector4';

{ @exclude }
procedure _vector3_div_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_div_scalar';

{ @exclude }
procedure _vector4_div_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_div_scalar';

{ @exclude }
procedure _scalar_div_vector3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_div_vector3';

{ @exclude }
procedure _scalar_div_vector4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_div_vector4';

{ @exclude }
procedure _vector3_div_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_div_vector3';

{ @exclude }
procedure _vector4_div_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_div_vector4';

{ @exclude }
procedure _neg_matrix2(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'neg_matrix2';

{ @exclude }
procedure _matrix2_add_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_add_scalar';

{ @exclude }
procedure _scalar_add_matrix2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_add_matrix2';

{ @exclude }
procedure _matrix2_add_matrix2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_add_matrix2';

{ @exclude }
procedure _matrix2_sub_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_sub_scalar';

{ @exclude }
procedure _scalar_sub_matrix2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_sub_matrix2';

{ @exclude }
procedure _matrix2_sub_matrix2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_sub_matrix2';

{ @exclude }
procedure _matrix2_mul_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_mul_scalar';

{ @exclude }
procedure _scalar_mul_matrix2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_mul_matrix2';

{ @exclude }
procedure _vector2_mul_matrix2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector2_mul_matrix2';

{ @exclude }
procedure _matrix2_mul_vector2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_mul_vector2';

{ @exclude }
procedure _matrix2_mul_matrix2(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_mul_matrix2';

{ @exclude }
procedure _matrix2_div_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix2_div_scalar';

{ @exclude }
procedure _scalar_div_matrix2(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_div_matrix2';

{ @exclude }
procedure _neg_matrix3(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'neg_matrix3';

{ @exclude }
procedure _matrix3_add_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_add_scalar';

{ @exclude }
procedure _scalar_add_matrix3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_add_matrix3';

{ @exclude }
procedure _matrix3_add_matrix3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_add_matrix3';

{ @exclude }
procedure _matrix3_sub_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_sub_scalar';

{ @exclude }
procedure _scalar_sub_matrix3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_sub_matrix3';

{ @exclude }
procedure _matrix3_sub_matrix3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_sub_matrix3';

{ @exclude }
procedure _matrix3_mul_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_mul_scalar';

{ @exclude }
procedure _scalar_mul_matrix3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_mul_matrix3';

{ @exclude }
procedure _vector3_mul_matrix3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector3_mul_matrix3';

{ @exclude }
procedure _matrix3_mul_vector3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_mul_vector3';

{ @exclude }
procedure _matrix3_mul_matrix3(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_mul_matrix3';

{ @exclude }
procedure _matrix3_div_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix3_div_scalar';

{ @exclude }
procedure _scalar_div_matrix3(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_div_matrix3';

{ @exclude }
procedure _neg_matrix4(A, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'neg_matrix4';

{ @exclude }
procedure _matrix4_add_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_add_scalar';

{ @exclude }
procedure _scalar_add_matrix4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_add_matrix4';

{ @exclude }
procedure _matrix4_add_matrix4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_add_matrix4';

{ @exclude }
procedure _matrix4_sub_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_sub_scalar';

{ @exclude }
procedure _scalar_sub_matrix4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_sub_matrix4';

{ @exclude }
procedure _matrix4_sub_matrix4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_sub_matrix4';

{ @exclude }
procedure _matrix4_mul_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_mul_scalar';

{ @exclude }
procedure _scalar_mul_matrix4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_mul_matrix4';

{ @exclude }
procedure _vector4_mul_matrix4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'vector4_mul_matrix4';

{ @exclude }
procedure _matrix4_mul_vector4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_mul_vector4';

{ @exclude }
procedure _matrix4_mul_matrix4(A, B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_mul_matrix4';

{ @exclude }
procedure _matrix4_div_scalar(A: Pointer; B: Single; AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'matrix4_div_scalar';

{ @exclude }
procedure _scalar_div_matrix4(A: Single; B, AResult: Pointer);
  cdecl; external _LIB_FASTMATH name _PREFIX + 'scalar_div_matrix4';
{$ENDIF FM_ARM}
