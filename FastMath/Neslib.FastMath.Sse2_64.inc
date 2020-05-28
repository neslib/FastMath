{ Note about x64 calling convention
  ---------------------------------

  Delphi uses the Microsoft x64 calling convention:
  * Arguments that fit into 1, 2, 4 or 8 bytes are passed in registers RCX, RDX,
    R8 and R9. This includes TVector2 records (which are 8 bytes). So those need
    to be moved using MOVQ instead of MOVLPS.
    NOTE: Delphi 10.3 Rio changed this behavior for 8-byte records (TVector2):
    the register contains the address of the parameter instead (as is the case
    in 32-bit, so we should use MOVLPS).
  * The same goes for function results. Those go into RAX. Floating-point values
    are returned in XMM0.
  * The first 4 floating-point arguments go into XMM0, XMM1, XMM2 and XMM3.
  * These registers must be preserved:
    R12, R13, R14, R15, RDI, RSI, RBX, RBP, RSP, XMM6-XMM15.
  * At the start of a function, RBP is always aligned to a 16-byte boundary (its
    address always ends in 0).
  * RSP is also always a multiple of 16, but its address always ends in 8 (since
    the return address is pushed to the stack }

const
  { SSE rounding modes (bits in MXCSR register) }
  SSE_ROUND_MASK    = $FFFF9FFF;
  SSE_ROUND_NEAREST = $00000000;
  SSE_ROUND_DOWN    = $00002000;
  SSE_ROUND_UP      = $00004000;
  SSE_ROUND_TRUNC   = $00006000;

  { These constants fit in a single XMM register. These values represent
    sign-bits as used by 32-bit floating-point values.
    XOR'ing a floating-point value with $80000000 swaps the sign.
    XOR'ing a floating-point value with $00000000 leaves the value unchanged. }
  SSE_MASK_SIGN: array [0..3] of UInt32 = ($80000000, $80000000, $80000000, $80000000);
  SSE_MASK_NPNP: array [0..3] of UInt32 = ($80000000, $00000000, $80000000, $00000000);
  SSE_MASK_PNPN: array [0..3] of UInt32 = ($00000000, $80000000, $00000000, $80000000);
  SSE_MASK_0FFF: array [0..3] of UInt32 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $00000000);

  { These constants mask off an element of the binary representation of a
    32-bit floating-point value. }
  SSE_MASK_FRACTION: array [0..3] of UInt32 = ($007FFFFF, $007FFFFF, $007FFFFF, $007FFFFF);
  SSE_MASK_EXPONENT: array [0..3] of UInt32 = ($7F800000, $7F800000, $7F800000, $7F800000);
  SSE_MASK_ABS_VAL : array [0..3] of UInt32 = ($7FFFFFFF, $7FFFFFFF, $7FFFFFFF, $7FFFFFFF);

  { Commonly used floating-point values }
  SSE_ONE_HALF    : array [0..3] of Single = (0.5, 0.5, 0.5, 0.5);
  SSE_ONE         : array [0..3] of Single = (1, 1, 1, 1);
  SSE_TWO         : array [0..3] of Single = (2, 2, 2, 2);
  SSE_THREE       : array [0..3] of Single = (3, 3, 3, 3);
  SSE_PI_OVER_180 : array [0..3] of Single = (Pi / 180, Pi / 180, Pi / 180, Pi / 180);
  SSE_180_OVER_PI : array [0..3] of Single = (180 / Pi, 180 / Pi, 180 / Pi, 180 / Pi);
  SSE_NEG_INFINITY: array [0..3] of Single = (NegInfinity, NegInfinity, NegInfinity, NegInfinity);
  SSE_PI_OVER_4   : array [0..3] of Single = (Pi / 4, Pi / 4, Pi / 4, Pi / 4);

  { Commonly used integer values }
  SSE_INT_ONE     : array [0..3] of Integer = (1, 1, 1, 1);
  SSE_INT_NOT_ONE : array [0..3] of Cardinal = ($FFFFFFFE, $FFFFFFFE, $FFFFFFFE, $FFFFFFFE);
  SSE_INT_TWO     : array [0..3] of Integer = (2, 2, 2, 2);
  SSE_INT_FOUR    : array [0..3] of Integer = (4, 4, 4, 4);

  { Constants for approximating trigonometric functions }
  SSE_FOPI: array [0..3] of Single = (1.27323954473516, 1.27323954473516, 1.27323954473516, 1.27323954473516);
  SSE_SINCOF_P0: array [0..3] of Single = (-1.9515295891E-4, -1.9515295891E-4, -1.9515295891E-4, -1.9515295891E-4);
  SSE_SINCOF_P1: array [0..3] of Single = (8.3321608736E-3, 8.3321608736E-3, 8.3321608736E-3, 8.3321608736E-3);
  SSE_SINCOF_P2: array [0..3] of Single = (-1.6666654611E-1, -1.6666654611E-1, -1.6666654611E-1, -1.6666654611E-1);
  SSE_COSCOF_P0: array [0..3] of Single = (2.443315711809948E-005, 2.443315711809948E-005, 2.443315711809948E-005, 2.443315711809948E-005);
  SSE_COSCOF_P1: array [0..3] of Single = (-1.388731625493765E-003, -1.388731625493765E-003, -1.388731625493765E-003, -1.388731625493765E-003);
  SSE_COSCOF_P2: array [0..3] of Single = (4.166664568298827E-002, 4.166664568298827E-002, 4.166664568298827E-002, 4.166664568298827E-002);

  SSE_EXP_A1 : array [0..3] of Single = (12102203.1615614, 12102203.1615614, 12102203.1615614, 12102203.1615614);
  SSE_EXP_A2 : array [0..3] of Single = (1065353216, 1065353216, 1065353216, 1065353216);
  SSE_EXP_CST: array [0..3] of Single = (2139095040, 2139095040, 2139095040, 2139095040);
  SSE_EXP_F1 : array [0..3] of Single = (0.509964287281036376953125, 0.509964287281036376953125, 0.509964287281036376953125, 0.509964287281036376953125);
  SSE_EXP_F2 : array [0..3] of Single = (0.3120158612728118896484375, 0.3120158612728118896484375, 0.3120158612728118896484375, 0.3120158612728118896484375);
  SSE_EXP_F3 : array [0..3] of Single = (0.1666135489940643310546875, 0.1666135489940643310546875, 0.1666135489940643310546875, 0.1666135489940643310546875);
  SSE_EXP_F4 : array [0..3] of Single = (-2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3, -2.12528370320796966552734375e-3);
  SSE_EXP_F5 : array [0..3] of Single = (1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2, 1.3534179888665676116943359375e-2);
  SSE_EXP_I1 : array [0..3] of UInt32 = ($3F800000, $3F800000, $3F800000, $3F800000);

  SSE_LN_CST: array [0..3] of Single = (-89.93423858, -89.93423858, -89.93423858, -89.93423858);
  SSE_LN_F1 : array [0..3] of Single = (3.3977745, 3.3977745, 3.3977745, 3.3977745);
  SSE_LN_F2 : array [0..3] of Single = (2.2744832, 2.2744832, 2.2744832, 2.2744832);
  SSE_LN_F3 : array [0..3] of Single = (0.024982445, 0.024982445, 0.024982445, 0.024982445);
  SSE_LN_F4 : array [0..3] of Single = (0.24371102, 0.24371102, 0.24371102, 0.24371102);
  SSE_LN_F5 : array [0..3] of Single = (0.69314718055995, 0.69314718055995, 0.69314718055995, 0.69314718055995);

  SSE_LOG2_I1: array [0..3] of UInt32 = ($3F000000, $3F000000, $3F000000, $3F000000);
  SSE_LOG2_F1: array [0..3] of Single = (1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7, 1.1920928955078125e-7);
  SSE_LOG2_F2: array [0..3] of Single = (124.22551499, 124.22551499, 124.22551499, 124.22551499);
  SSE_LOG2_F3: array [0..3] of Single = (1.498030302, 1.498030302, 1.498030302, 1.498030302);
  SSE_LOG2_F4: array [0..3] of Single = (1.72587999, 1.72587999, 1.72587999, 1.72587999);
  SSE_LOG2_F5: array [0..3] of Single = (0.3520887068, 0.3520887068, 0.3520887068, 0.3520887068);

  SSE_EXP2_F1: array [0..3] of Single = (121.2740575, 121.2740575, 121.2740575, 121.2740575);
  SSE_EXP2_F2: array [0..3] of Single = (27.7280233, 27.7280233, 27.7280233, 27.7280233);
  SSE_EXP2_F3: array [0..3] of Single = (4.84252568, 4.84252568, 4.84252568, 4.84252568);
  SSE_EXP2_F4: array [0..3] of Single = (1.49012907, 1.49012907, 1.49012907, 1.49012907);
  SSE_EXP2_F5: array [0..3] of Single = ($00800000, $00800000, $00800000, $00800000);

{ Angle and Trigonometry Functions }

function Radians(const ADegrees: Single): Single;
begin
  Result := ADegrees * (Pi / 180);
end;

function Radians(const ADegrees: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [ADegrees]
  {$ELSE}
  movq   xmm0, ADegrees
  {$ENDIF}
  movlps xmm1, QWORD [SSE_PI_OVER_180]
  mulps  xmm0, xmm1
  movq   rax, xmm0
end;

function Radians(const ADegrees: TVector3): TVector3; assembler;
asm
  movq     xmm0, [ADegrees]
  movss    xmm1, DWORD [ADegrees+8]
  movups   xmm2, [SSE_PI_OVER_180]
  mulps    xmm0, xmm2
  mulss    xmm1, xmm2
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Radians(const ADegrees: TVector4): TVector4; assembler;
asm
  movups xmm0, [ADegrees]
  movups xmm1, [SSE_PI_OVER_180]
  mulps  xmm0, xmm1
  movups [Result], xmm0
end;

function Degrees(const ARadians: Single): Single;
begin
  Result := ARadians * (180 / Pi);
end;

function Degrees(const ARadians: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [ARadians]
  {$ELSE}
  movq   xmm0, ARadians
  {$ENDIF}
  movlps xmm1, QWORD [SSE_180_OVER_PI]
  mulps  xmm0, xmm1
  movq   rax, xmm0
end;

function Degrees(const ARadians: TVector3): TVector3; assembler;
asm
  movq     xmm0, [ARadians]
  movss    xmm1, DWORD [ARadians+8]
  movups   xmm2, [SSE_180_OVER_PI]
  mulps    xmm0, xmm2
  mulss    xmm1, xmm2
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Degrees(const ARadians: TVector4): TVector4; assembler;
asm
  movups xmm0, [ARadians]
  movups xmm1, [SSE_180_OVER_PI]
  mulps  xmm0, xmm1
  movups [Result], xmm0
end;

{ Exponential Functions }

function Sqrt(const A: Single): Single; assembler;
asm
  sqrtss xmm0, xmm0
end;

function Sqrt(const A: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  {$ELSE}
  movq   xmm0, A
  {$ENDIF}
  sqrtps xmm0, xmm0
  movq   rax, xmm0
end;

function Sqrt(const A: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  sqrtps   xmm0, xmm0
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Sqrt(const A: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  sqrtps xmm0, xmm0
  movups [Result], xmm0
end;

function InverseSqrt(const A: Single): Single; assembler;
asm
  rsqrtss xmm0, xmm0
end;

function InverseSqrt(const A: TVector2): TVector2;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  {$ELSE}
  movq   xmm0, A
  {$ENDIF}
  rsqrtps xmm0, xmm0
  movq    rax, xmm0
end;

function InverseSqrt(const A: TVector3): TVector3;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  rsqrtps  xmm0, xmm0
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function InverseSqrt(const A: TVector4): TVector4; assembler;
asm
  movups  xmm0, [A]
  rsqrtps xmm0, xmm0
  movups  [Result], xmm0
end;

{ Fast approximate Functions }

function FastSin(const ARadians: Single): Single; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movss    xmm2, DWORD [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  movss    xmm3, DWORD [SSE_MASK_SIGN]
  andps    xmm0, xmm2               // (xmm0) X := Abs(ARadians)
  andps    xmm1, xmm3               // (xmm1) SignBit
  movaps   xmm2, xmm0
  movss    xmm4, DWORD [SSE_FOPI]
  movss    xmm5, DWORD [SSE_INT_ONE]
  mulss    xmm2, xmm4
  movss    xmm6, DWORD [SSE_INT_NOT_ONE]
  cvtps2dq xmm2, xmm2               // J := Trunc(X * FOPI)
  movss    xmm7, DWORD [SSE_INT_FOUR]
  paddd    xmm2, xmm5
  pand     xmm2, xmm6               // (xmm2) J := (J + 1) and (not 1)
  movss    xmm6, DWORD [SSE_INT_TWO]
  cvtdq2ps xmm4, xmm2               // (xmm4) Y := J
  movaps   xmm5, xmm2
  pand     xmm2, xmm6               // J and 2
  pand     xmm5, xmm7               // J and 4
  pxor     xmm7, xmm7
  pslld    xmm5, 29                 // (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd  xmm2, xmm7               // (xmm2) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  movss    xmm6, DWORD [SSE_PI_OVER_4]
  pxor     xmm1, xmm5               // (xmm1) SignBit := SignBit xor SwapSignBit
  mulss    xmm4, xmm6               // Y * Pi / 4
  movss    xmm3, DWORD [SSE_COSCOF_P0]
  subss    xmm0, xmm4               // (xmm0) X := X - (Y * Pi / 4)
  movss    xmm4, DWORD [SSE_COSCOF_P1]
  movaps   xmm7, xmm0
  movss    xmm6, DWORD [SSE_COSCOF_P2]
  mulss    xmm7, xmm7               // (xmm7) Z := X * X
  movss    xmm5, DWORD [SSE_SINCOF_P1]
  mulss    xmm3, xmm7               // COSCOF_P0 * Z
  addss    xmm3, xmm4               // Y := COSCOF_P0 * Z + COSCOF_P1
  movss    xmm4, DWORD [SSE_ONE_HALF]
  mulss    xmm3, xmm7               // Y * Z
  mulss    xmm4, xmm7               // Z * 0.5
  addps    xmm3, xmm6               // Y := (Y * Z) + COSCOF_P2
  movss    xmm6, DWORD [SSE_ONE]
  mulss    xmm3, xmm7               // Y * Z
  mulss    xmm3, xmm7               // Y := Y * (Z * Z)
  subss    xmm3, xmm4               // Y - Z * 0.5
  movss    xmm4, DWORD [SSE_SINCOF_P0]
  addps    xmm3, xmm6               // (xmm3) Y := Y - Z * 0.5 + 1
  movss    xmm6, DWORD [SSE_SINCOF_P2]
  mulss    xmm4, xmm7               // SINCOF_P0 * Z
  addss    xmm4, xmm5               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps   xmm5, xmm2
  mulss    xmm4, xmm7               // Y2 * Z
  addss    xmm4, xmm6               // Y2 := (Y2 * Z) + SINCOF_P2
  mulss    xmm4, xmm7               // Y2 * Z
  mulss    xmm4, xmm0               // Y2 * (Z * X)
  addss    xmm4, xmm0               // (xmm4) Y2 := Y2 * (Z * X) + X
  andps    xmm4, xmm2               // Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm3               // Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addss    xmm4, xmm5
  xorps    xmm4, xmm1               // (Y + Y2) xor SignBit
  movss    xmm0, xmm4

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastSin(const ARadians: TVector2): TVector2; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  {$IF RTLVersion >= 33}
  movlps   xmm0, [ARadians]
  {$ELSE}
  movq     xmm0, ARadians
  {$ENDIF}
  movlps   xmm2, QWORD [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  movlps   xmm3, QWORD [SSE_MASK_SIGN]
  andps    xmm0, xmm2               // (xmm0) X := Abs(ARadians)
  andps    xmm1, xmm3               // (xmm1) SignBit
  movaps   xmm2, xmm0
  movlps   xmm4, QWORD [SSE_FOPI]
  movlps   xmm5, QWORD [SSE_INT_ONE]
  mulps    xmm2, xmm4
  movlps   xmm6, QWORD [SSE_INT_NOT_ONE]
  cvtps2dq xmm2, xmm2               // J := Trunc(X * FOPI)
  movlps   xmm7, QWORD [SSE_INT_FOUR]
  paddd    xmm2, xmm5
  pand     xmm2, xmm6               // (xmm2) J := (J + 1) and (not 1)
  movlps   xmm6, QWORD [SSE_INT_TWO]
  cvtdq2ps xmm4, xmm2               // (xmm4) Y := J
  movaps   xmm5, xmm2
  pand     xmm2, xmm6               // J and 2
  pand     xmm5, xmm7               // J and 4
  pxor     xmm7, xmm7
  pslld    xmm5, 29                 // (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd  xmm2, xmm7               // (xmm2) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  movlps   xmm6, QWORD [SSE_PI_OVER_4]
  pxor     xmm1, xmm5               // (xmm1) SignBit := SignBit xor SwapSignBit
  mulps    xmm4, xmm6               // Y * Pi / 4
  movlps   xmm3, QWORD [SSE_COSCOF_P0]
  subps    xmm0, xmm4               // (xmm0) X := X - (Y * Pi / 4)
  movlps   xmm4, QWORD [SSE_COSCOF_P1]
  movaps   xmm7, xmm0
  movlps   xmm6, QWORD [SSE_COSCOF_P2]
  mulps    xmm7, xmm7               // (xmm7) Z := X * X
  movlps   xmm5, QWORD [SSE_SINCOF_P1]
  mulps    xmm3, xmm7               // COSCOF_P0 * Z
  addps    xmm3, xmm4               // Y := COSCOF_P0 * Z + COSCOF_P1
  movlps   xmm4, QWORD [SSE_ONE_HALF]
  mulps    xmm3, xmm7               // Y * Z
  mulps    xmm4, xmm7               // Z * 0.5
  addps    xmm3, xmm6               // Y := (Y * Z) + COSCOF_P2
  movlps   xmm6, QWORD [SSE_ONE]
  mulps    xmm3, xmm7               // Y * Z
  mulps    xmm3, xmm7               // Y := Y * (Z * Z)
  subps    xmm3, xmm4               // Y - Z * 0.5
  movlps   xmm4, QWORD [SSE_SINCOF_P0]
  addps    xmm3, xmm6               // (xmm3) Y := Y - Z * 0.5 + 1
  movlps   xmm6, QWORD [SSE_SINCOF_P2]
  mulps    xmm4, xmm7               // SINCOF_P0 * Z
  addps    xmm4, xmm5               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps   xmm5, xmm2
  mulps    xmm4, xmm7               // Y2 * Z
  addps    xmm4, xmm6               // Y2 := (Y2 * Z) + SINCOF_P2
  mulps    xmm4, xmm7               // Y2 * Z
  mulps    xmm4, xmm0               // Y2 * (Z * X)
  addps    xmm4, xmm0               // (xmm4) Y2 := Y2 * (Z * X) + X
  andps    xmm4, xmm2               // Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm3               // Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addps    xmm4, xmm5
  xorps    xmm4, xmm1               // (Y + Y2) xor SignBit
  movq     rax, xmm4

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastSin(const ARadians: TVector3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [ARadians]
  movss    xmm1, DWORD [ARadians+8]
  movlhps  xmm0, xmm1
  movups   xmm2, [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  movups   xmm3, [SSE_MASK_SIGN]
  andps    xmm0, xmm2               // (xmm0) X := Abs(ARadians)
  andps    xmm1, xmm3               // (xmm1) SignBit
  movaps   xmm2, xmm0
  movups   xmm4, [SSE_FOPI]
  movups   xmm5, [SSE_INT_ONE]
  mulps    xmm2, xmm4
  movups   xmm6, [SSE_INT_NOT_ONE]
  cvtps2dq xmm2, xmm2               // J := Trunc(X * FOPI)
  movups   xmm7, [SSE_INT_FOUR]
  paddd    xmm2, xmm5
  pand     xmm2, xmm6               // (xmm2) J := (J + 1) and (not 1)
  movups   xmm6, [SSE_INT_TWO]
  cvtdq2ps xmm4, xmm2               // (xmm4) Y := J
  movaps   xmm5, xmm2
  pand     xmm2, xmm6               // J and 2
  pand     xmm5, xmm7               // J and 4
  pxor     xmm7, xmm7
  pslld    xmm5, 29                 // (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd  xmm2, xmm7               // (xmm2) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  movups   xmm6, [SSE_PI_OVER_4]
  pxor     xmm1, xmm5               // (xmm1) SignBit := SignBit xor SwapSignBit
  mulps    xmm4, xmm6               // Y * Pi / 4
  movups   xmm3, [SSE_COSCOF_P0]
  subps    xmm0, xmm4               // (xmm0) X := X - (Y * Pi / 4)
  movups   xmm4, [SSE_COSCOF_P1]
  movaps   xmm7, xmm0
  movups   xmm6, [SSE_COSCOF_P2]
  mulps    xmm7, xmm7               // (xmm7) Z := X * X
  movups   xmm5, [SSE_SINCOF_P1]
  mulps    xmm3, xmm7               // COSCOF_P0 * Z
  addps    xmm3, xmm4               // Y := COSCOF_P0 * Z + COSCOF_P1
  movups   xmm4, [SSE_ONE_HALF]
  mulps    xmm3, xmm7               // Y * Z
  mulps    xmm4, xmm7               // Z * 0.5
  addps    xmm3, xmm6               // Y := (Y * Z) + COSCOF_P2
  movups   xmm6, [SSE_ONE]
  mulps    xmm3, xmm7               // Y * Z
  mulps    xmm3, xmm7               // Y := Y * (Z * Z)
  subps    xmm3, xmm4               // Y - Z * 0.5
  movups   xmm4, [SSE_SINCOF_P0]
  addps    xmm3, xmm6               // (xmm3) Y := Y - Z * 0.5 + 1
  movups   xmm6, [SSE_SINCOF_P2]
  mulps    xmm4, xmm7               // SINCOF_P0 * Z
  addps    xmm4, xmm5               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps   xmm5, xmm2
  mulps    xmm4, xmm7               // Y2 * Z
  addps    xmm4, xmm6               // Y2 := (Y2 * Z) + SINCOF_P2
  mulps    xmm4, xmm7               // Y2 * Z
  mulps    xmm4, xmm0               // Y2 * (Z * X)
  addps    xmm4, xmm0               // (xmm4) Y2 := Y2 * (Z * X) + X
  andps    xmm4, xmm2               // Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm3               // Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addps    xmm4, xmm5
  xorps    xmm4, xmm1               // (Y + Y2) xor SignBit
  movhlps  xmm5, xmm4
  movq     [Result], xmm4
  movss    DWORD [Result+8], xmm5

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastSin(const ARadians: TVector4): TVector4; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [ARadians]
  movups   xmm2, [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  movups   xmm3, [SSE_MASK_SIGN]
  andps    xmm0, xmm2               // (xmm0) X := Abs(ARadians)
  andps    xmm1, xmm3               // (xmm1) SignBit
  movaps   xmm2, xmm0
  movups   xmm4, [SSE_FOPI]
  movups   xmm5, [SSE_INT_ONE]
  mulps    xmm2, xmm4
  movups   xmm6, [SSE_INT_NOT_ONE]
  cvtps2dq xmm2, xmm2               // J := Trunc(X * FOPI)
  movups   xmm7, [SSE_INT_FOUR]
  paddd    xmm2, xmm5
  pand     xmm2, xmm6               // (xmm2) J := (J + 1) and (not 1)
  movups   xmm6, [SSE_INT_TWO]
  cvtdq2ps xmm4, xmm2               // (xmm4) Y := J
  movaps   xmm5, xmm2
  pand     xmm2, xmm6               // J and 2
  pand     xmm5, xmm7               // J and 4
  pxor     xmm7, xmm7
  pslld    xmm5, 29                 // (xmm5) SwapSignBit := (J and 4) shl 29
  pcmpeqd  xmm2, xmm7               // (xmm2) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  movups   xmm6, [SSE_PI_OVER_4]
  pxor     xmm1, xmm5               // (xmm1) SignBit := SignBit xor SwapSignBit
  mulps    xmm4, xmm6               // Y * Pi / 4
  movups   xmm3, [SSE_COSCOF_P0]
  subps    xmm0, xmm4               // (xmm0) X := X - (Y * Pi / 4)
  movups   xmm4, [SSE_COSCOF_P1]
  movaps   xmm7, xmm0
  movups   xmm6, [SSE_COSCOF_P2]
  mulps    xmm7, xmm7               // (xmm7) Z := X * X
  movups   xmm5, [SSE_SINCOF_P1]
  mulps    xmm3, xmm7               // COSCOF_P0 * Z
  addps    xmm3, xmm4               // Y := COSCOF_P0 * Z + COSCOF_P1
  movups   xmm4, [SSE_ONE_HALF]
  mulps    xmm3, xmm7               // Y * Z
  mulps    xmm4, xmm7               // Z * 0.5
  addps    xmm3, xmm6               // Y := (Y * Z) + COSCOF_P2
  movups   xmm6, [SSE_ONE]
  mulps    xmm3, xmm7               // Y * Z
  mulps    xmm3, xmm7               // Y := Y * (Z * Z)
  subps    xmm3, xmm4               // Y - Z * 0.5
  movups   xmm4, [SSE_SINCOF_P0]
  addps    xmm3, xmm6               // (xmm3) Y := Y - Z * 0.5 + 1
  movups   xmm6, [SSE_SINCOF_P2]
  mulps    xmm4, xmm7               // SINCOF_P0 * Z
  addps    xmm4, xmm5               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  movaps   xmm5, xmm2
  mulps    xmm4, xmm7               // Y2 * Z
  addps    xmm4, xmm6               // Y2 := (Y2 * Z) + SINCOF_P2
  mulps    xmm4, xmm7               // Y2 * Z
  mulps    xmm4, xmm0               // Y2 * (Z * X)
  addps    xmm4, xmm0               // (xmm4) Y2 := Y2 * (Z * X) + X
  andps    xmm4, xmm2               // Y2 := ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm3               // Y  := ((J and 2) = 0)? Yes: 0 , No: Y
  addps    xmm4, xmm5
  xorps    xmm4, xmm1               // (Y + Y2) xor SignBit
  movups   [Result], xmm4

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastCos(const ARadians: Single): Single; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movss    xmm1, DWORD [SSE_MASK_ABS_VAL]
  movss    xmm2, DWORD [SSE_FOPI]
  andps    xmm0, xmm1               // (xmm0) X := Abs(ARadians)
  movss    xmm3, DWORD [SSE_INT_NOT_ONE]
  movaps   xmm1, xmm0
  movss    xmm4, DWORD [SSE_INT_FOUR]
  mulss    xmm1, xmm2
  movss    xmm2, DWORD [SSE_INT_ONE]
  cvtps2dq xmm1, xmm1               // J := Trunc(X * FOPI)
  pxor     xmm6, xmm6
  paddd    xmm1, xmm2
  pand     xmm1, xmm3               // (xmm1) J := (J + 1) and (not 1)
  movss    xmm3, DWORD [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm1               // (xmm2) Y := J
  psubd    xmm1, xmm3               // J - 2
  movaps   xmm5, xmm1
  pandn    xmm1, xmm4               // (not (J - 2)) and 4
  pand     xmm5, xmm3               // (J - 2) and 2
  pslld    xmm1, 29                 // (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movss    xmm3, DWORD [SSE_PI_OVER_4]
  pcmpeqd  xmm5, xmm6               // (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: $FFFFFFFF, No: $00000000
  mulss    xmm2, xmm3               // Y * Pi / 4
  movss    xmm3, DWORD [SSE_COSCOF_P1]
  subss    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  movss    xmm2, DWORD [SSE_COSCOF_P0]
  movss    xmm4, DWORD [SSE_COSCOF_P2]
  movaps   xmm6, xmm0
  mulss    xmm6, xmm6               // (xmm6) Z := X * X
  mulss    xmm2, xmm6               // COSCOF_P0 * Z
  addps    xmm2, xmm3               // Y := COSCOF_P0 * Z + COSCOF_P1
  movss    xmm3, DWORD [SSE_ONE_HALF]
  mulss    xmm2, xmm6               // Y * Z
  mulss    xmm3, xmm6               // Z * 0.5
  addss    xmm2, xmm4               // Y := (Y * Z) + COSCOF_P2
  movss    xmm7, DWORD [SSE_ONE]
  mulss    xmm2, xmm6
  movss    xmm4, DWORD [SSE_SINCOF_P1]
  mulss    xmm2, xmm6               // Y := Y * (Z * Z)
  subss    xmm2, xmm3               // Y - Z * 0.5
  addss    xmm2, xmm7               // (xmm2) Y := Y - Z * 0.5 + 1
  movss    xmm3, DWORD [SSE_SINCOF_P0]
  movss    xmm7, DWORD [SSE_SINCOF_P2]
  mulss    xmm3, xmm6               // SINCOF_P0 * Z
  addss    xmm3, xmm4               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulss    xmm3, xmm6               // Y2 * Z
  addss    xmm3, xmm7               // Y2 := (Y2 * Z) + SINCOF_P2
  mulss    xmm3, xmm6               // Y2 * Z
  mulss    xmm3, xmm0               // Y2 * (Z * X)
  addss    xmm3, xmm0               // Y2 := Y2 * (Z * X) + X
  andps    xmm3, xmm5               // ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm2               // ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addss    xmm3, xmm5
  xorps    xmm3, xmm1               // (Y + Y2) xor SignBit
  movss    xmm0, xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastCos(const ARadians: TVector2): TVector2; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  {$IF RTLVersion >= 33}
  movlps   xmm0, [ARadians]
  {$ELSE}
  movq     xmm0, ARadians
  {$ENDIF}
  movlps   xmm1, QWORD [SSE_MASK_ABS_VAL]
  movlps   xmm2, QWORD [SSE_FOPI]
  andps    xmm0, xmm1               // (xmm0) X := Abs(ARadians)
  movlps   xmm3, QWORD [SSE_INT_NOT_ONE]
  movaps   xmm1, xmm0
  movlps   xmm4, QWORD [SSE_INT_FOUR]
  mulps    xmm1, xmm2
  movlps   xmm2, QWORD [SSE_INT_ONE]
  cvtps2dq xmm1, xmm1               // J := Trunc(X * FOPI)
  pxor     xmm6, xmm6
  paddd    xmm1, xmm2
  pand     xmm1, xmm3               // (xmm1) J := (J + 1) and (not 1)
  movlps   xmm3, QWORD [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm1               // (xmm2) Y := J
  psubd    xmm1, xmm3               // J - 2
  movaps   xmm5, xmm1
  pandn    xmm1, xmm4               // (not (J - 2)) and 4
  pand     xmm5, xmm3               // (J - 2) and 2
  pslld    xmm1, 29                 // (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movlps   xmm3, QWORD [SSE_PI_OVER_4]
  pcmpeqd  xmm5, xmm6               // (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: $FFFFFFFF, No: $00000000
  mulps    xmm2, xmm3               // Y * Pi / 4
  movlps   xmm3, QWORD [SSE_COSCOF_P1]
  subps    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  movlps   xmm2, QWORD [SSE_COSCOF_P0]
  movlps   xmm4, QWORD [SSE_COSCOF_P2]
  movaps   xmm6, xmm0
  mulps    xmm6, xmm6               // (xmm6) Z := X * X
  mulps    xmm2, xmm6               // COSCOF_P0 * Z
  addps    xmm2, xmm3               // Y := COSCOF_P0 * Z + COSCOF_P1
  movlps   xmm3, QWORD [SSE_ONE_HALF]
  mulps    xmm2, xmm6               // Y * Z
  mulps    xmm3, xmm6               // Z * 0.5
  addps    xmm2, xmm4               // Y := (Y * Z) + COSCOF_P2
  movlps   xmm7, QWORD [SSE_ONE]
  mulps    xmm2, xmm6
  movlps   xmm4, QWORD [SSE_SINCOF_P1]
  mulps    xmm2, xmm6               // Y := Y * (Z * Z)
  subps    xmm2, xmm3               // Y - Z * 0.5
  addps    xmm2, xmm7               // (xmm2) Y := Y - Z * 0.5 + 1
  movlps   xmm3, QWORD [SSE_SINCOF_P0]
  movlps   xmm7, QWORD [SSE_SINCOF_P2]
  mulps    xmm3, xmm6               // SINCOF_P0 * Z
  addps    xmm3, xmm4               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps    xmm3, xmm6               // Y2 * Z
  addps    xmm3, xmm7               // Y2 := (Y2 * Z) + SINCOF_P2
  mulps    xmm3, xmm6               // Y2 * Z
  mulps    xmm3, xmm0               // Y2 * (Z * X)
  addps    xmm3, xmm0               // Y2 := Y2 * (Z * X) + X
  andps    xmm3, xmm5               // ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm2               // ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addps    xmm3, xmm5
  xorps    xmm3, xmm1               // (Y + Y2) xor SignBit
  movq     rax, xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastCos(const ARadians: TVector3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [ARadians]
  movss    xmm1, DWORD [ARadians+8]
  movlhps  xmm0, xmm1
  movups   xmm1, [SSE_MASK_ABS_VAL]
  movups   xmm2, [SSE_FOPI]
  andps    xmm0, xmm1               // (xmm0) X := Abs(ARadians)
  movups   xmm3, [SSE_INT_NOT_ONE]
  movaps   xmm1, xmm0
  movups   xmm4, [SSE_INT_FOUR]
  mulps    xmm1, xmm2
  movups   xmm2, [SSE_INT_ONE]
  cvtps2dq xmm1, xmm1               // J := Trunc(X * FOPI)
  pxor     xmm6, xmm6
  paddd    xmm1, xmm2
  pand     xmm1, xmm3               // (xmm1) J := (J + 1) and (not 1)
  movups   xmm3, [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm1               // (xmm2) Y := J
  psubd    xmm1, xmm3               // J - 2
  movaps   xmm5, xmm1
  pandn    xmm1, xmm4               // (not (J - 2)) and 4
  pand     xmm5, xmm3               // (J - 2) and 2
  pslld    xmm1, 29                 // (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movups   xmm3, [SSE_PI_OVER_4]
  pcmpeqd  xmm5, xmm6               // (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: $FFFFFFFF, No: $00000000
  mulps    xmm2, xmm3               // Y * Pi / 4
  movups   xmm3, [SSE_COSCOF_P1]
  subps    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  movups   xmm2, [SSE_COSCOF_P0]
  movups   xmm4, [SSE_COSCOF_P2]
  movaps   xmm6, xmm0
  mulps    xmm6, xmm6               // (xmm6) Z := X * X
  mulps    xmm2, xmm6               // COSCOF_P0 * Z
  addps    xmm2, xmm3               // Y := COSCOF_P0 * Z + COSCOF_P1
  movups   xmm3, [SSE_ONE_HALF]
  mulps    xmm2, xmm6               // Y * Z
  mulps    xmm3, xmm6               // Z * 0.5
  addps    xmm2, xmm4               // Y := (Y * Z) + COSCOF_P2
  movups   xmm7, [SSE_ONE]
  mulps    xmm2, xmm6
  movups   xmm4, [SSE_SINCOF_P1]
  mulps    xmm2, xmm6               // Y := Y * (Z * Z)
  subps    xmm2, xmm3               // Y - Z * 0.5
  addps    xmm2, xmm7               // (xmm2) Y := Y - Z * 0.5 + 1
  movups   xmm3, [SSE_SINCOF_P0]
  movups   xmm7, [SSE_SINCOF_P2]
  mulps    xmm3, xmm6               // SINCOF_P0 * Z
  addps    xmm3, xmm4               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps    xmm3, xmm6               // Y2 * Z
  addps    xmm3, xmm7               // Y2 := (Y2 * Z) + SINCOF_P2
  mulps    xmm3, xmm6               // Y2 * Z
  mulps    xmm3, xmm0               // Y2 * (Z * X)
  addps    xmm3, xmm0               // Y2 := Y2 * (Z * X) + X
  andps    xmm3, xmm5               // ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm2               // ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addps    xmm3, xmm5
  xorps    xmm3, xmm1               // (Y + Y2) xor SignBit
  movhlps  xmm4, xmm3
  movq     [Result], xmm3
  movss    DWORD [Result+8], xmm4

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastCos(const ARadians: TVector4): TVector4; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [ARadians]
  movups   xmm1, [SSE_MASK_ABS_VAL]
  movups   xmm2, [SSE_FOPI]
  andps    xmm0, xmm1               // (xmm0) X := Abs(ARadians)
  movups   xmm3, [SSE_INT_NOT_ONE]
  movaps   xmm1, xmm0
  movups   xmm4, [SSE_INT_FOUR]
  mulps    xmm1, xmm2
  movups   xmm2, [SSE_INT_ONE]
  cvtps2dq xmm1, xmm1               // J := Trunc(X * FOPI)
  pxor     xmm6, xmm6
  paddd    xmm1, xmm2
  pand     xmm1, xmm3               // (xmm1) J := (J + 1) and (not 1)
  movups   xmm3, [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm1               // (xmm2) Y := J
  psubd    xmm1, xmm3               // J - 2
  movaps   xmm5, xmm1
  pandn    xmm1, xmm4               // (not (J - 2)) and 4
  pand     xmm5, xmm3               // (J - 2) and 2
  pslld    xmm1, 29                 // (xmm1) SignBit := ((not (J - 2)) and 4) shl 29
  movups   xmm3, [SSE_PI_OVER_4]
  pcmpeqd  xmm5, xmm6               // (xmm5) PolyMask := ((J-2) and 2)=0)? Yes: $FFFFFFFF, No: $00000000
  mulps    xmm2, xmm3               // Y * Pi / 4
  movups   xmm3, [SSE_COSCOF_P1]
  subps    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  movups   xmm2, [SSE_COSCOF_P0]
  movups   xmm4, [SSE_COSCOF_P2]
  movaps   xmm6, xmm0
  mulps    xmm6, xmm6               // (xmm6) Z := X * X
  mulps    xmm2, xmm6               // COSCOF_P0 * Z
  addps    xmm2, xmm3               // Y := COSCOF_P0 * Z + COSCOF_P1
  movups   xmm3, [SSE_ONE_HALF]
  mulps    xmm2, xmm6               // Y * Z
  mulps    xmm3, xmm6               // Z * 0.5
  addps    xmm2, xmm4               // Y := (Y * Z) + COSCOF_P2
  movups   xmm7, [SSE_ONE]
  mulps    xmm2, xmm6
  movups   xmm4, [SSE_SINCOF_P1]
  mulps    xmm2, xmm6               // Y := Y * (Z * Z)
  subps    xmm2, xmm3               // Y - Z * 0.5
  addps    xmm2, xmm7               // (xmm2) Y := Y - Z * 0.5 + 1
  movups   xmm3, [SSE_SINCOF_P0]
  movups   xmm7, [SSE_SINCOF_P2]
  mulps    xmm3, xmm6               // SINCOF_P0 * Z
  addps    xmm3, xmm4               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps    xmm3, xmm6               // Y2 * Z
  addps    xmm3, xmm7               // Y2 := (Y2 * Z) + SINCOF_P2
  mulps    xmm3, xmm6               // Y2 * Z
  mulps    xmm3, xmm0               // Y2 * (Z * X)
  addps    xmm3, xmm0               // Y2 := Y2 * (Z * X) + X
  andps    xmm3, xmm5               // ((J-2) and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm5, xmm2               // ((J-2) and 2) = 0)? Yes: 0 , No: Y
  addps    xmm3, xmm5
  xorps    xmm3, xmm1               // (Y + Y2) xor SignBit
  movups   [Result], xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

procedure FastSinCos(const ARadians: Single; out ASin, ACos: Single); assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movss    xmm2, DWORD [SSE_MASK_SIGN]
  movss    xmm3, DWORD [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  pand     xmm0, xmm3               // (xmm0) X := Abs(ARadians)
  pand     xmm1, xmm2               // (xmm1) SignBitSin
  movaps   xmm4, xmm0
  movss    xmm5, DWORD [SSE_FOPI]
  movss    xmm6, DWORD [SSE_INT_ONE]
  mulss    xmm4, xmm5
  movss    xmm7, DWORD [SSE_INT_NOT_ONE]
  cvtps2dq xmm4, xmm4               // (xmm4) J := Trunc(X * FOPI)
  movss    xmm5, DWORD [SSE_INT_FOUR]
  paddd    xmm4, xmm6
  pand     xmm4, xmm7               // (xmm4) J := (J + 1) and (not 1)
  movss    xmm7, DWORD [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm4               // (xmm2) Y := J
  movaps   xmm3, xmm4
  movaps   xmm6, xmm4               // (xmm6) J
  pand     xmm3, xmm5               // J and 4
  pand     xmm4, xmm7               // J and 2
  pxor     xmm5, xmm5
  pslld    xmm3, 29                 // (xmm3) SwapSignBitSin := (J and 4) shl 29
  movss    xmm7, DWORD [SSE_PI_OVER_4]
  pcmpeqd  xmm4, xmm5               // (xmm4) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  mulss    xmm2, xmm7               // Y * Pi / 4
  movss    xmm5, DWORD [SSE_INT_TWO]
  subss    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  psubd    xmm6, xmm5               // J - 2
  movss    xmm7, DWORD [SSE_INT_FOUR]
  pxor     xmm1, xmm3               // (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps   xmm6, xmm7               // (not (J - 2)) and 4
  movaps   xmm3, xmm0
  pslld    xmm6, 29                 // (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulss    xmm3, xmm3               // (xmm3) Z := X * X
  movss    xmm2, DWORD [SSE_COSCOF_P0]
  movss    xmm5, DWORD [SSE_COSCOF_P1]
  movss    xmm7, DWORD [SSE_COSCOF_P2]
  mulss    xmm2, xmm3               // COSCOF_P0 * Z
  addss    xmm2, xmm5               // Y := COSCOF_P0 * Z + COSCOF_P1
  movss    xmm5, DWORD [SSE_ONE_HALF]
  mulss    xmm2, xmm3               // Y * Z
  addss    xmm2, xmm7               // Y := (Y * Z) + COSCOF_P2
  movss    xmm7, DWORD [SSE_ONE]
  mulss    xmm2, xmm3               // Y * Z
  mulss    xmm5, xmm3               // 0.5 * Z
  mulss    xmm2, xmm3               // Y * (Z * Z)
  subss    xmm2, xmm5               // Y - 0.5 * Z
  movss    xmm5, DWORD [SSE_SINCOF_P0]
  addss    xmm2, xmm7               // (xmm2) Y := Y - 0.5 * Z + 1
  movss    xmm7, DWORD [SSE_SINCOF_P1]
  mulss    xmm5, xmm3               // SINCOF_P0 * Z
  addss    xmm5, xmm7               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulss    xmm5, xmm3               // Y2 * Z
  movss    xmm7, DWORD [SSE_SINCOF_P2]
  addss    xmm5, xmm7               // Y2 := Y2 * Z + SINCOF_P2
  mulss    xmm5, xmm3               // Y2 * Z
  mulss    xmm5, xmm0               // Y2 * (Z * X)
  addss    xmm5, xmm0               // (xmm5) Y2 := Y2 * (Z * X) + X
  movaps   xmm0, xmm2               // Y
  movaps   xmm3, xmm5               // Y2
  andps    xmm5, xmm4               // ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm4, xmm2               // ((J and 2) = 0)? Yes: 0 , No: Y
  subss    xmm3, xmm5               // ((J and 2) = 0)? Yes: 0 , No: Y2
  subss    xmm0, xmm4               // ((J and 2) = 0)? Yes: Y , No: 0
  addps    xmm4, xmm5               // ((J and 2) = 0)? Yes: Y2, No: Y
  addps    xmm3, xmm0               // ((J and 2) = 0)? Yes: Y , No: Y2
  xorps    xmm4, xmm1               // Sin
  xorps    xmm3, xmm6               // Cos
  movss    [ASin], xmm4
  movss    [ACos], xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

procedure FastSinCos(const ARadians: TVector2; out ASin, ACos: TVector2); assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  {$IF RTLVersion >= 33}
  movlps   xmm0, [ARadians]
  {$ELSE}
  movq     xmm0, ARadians
  {$ENDIF}
  movlps   xmm2, QWORD [SSE_MASK_SIGN]
  movlps   xmm3, QWORD [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  pand     xmm0, xmm3               // (xmm0) X := Abs(ARadians)
  pand     xmm1, xmm2               // (xmm1) SignBitSin
  movaps   xmm4, xmm0
  movlps   xmm5, QWORD [SSE_FOPI]
  movlps   xmm6, QWORD [SSE_INT_ONE]
  mulps    xmm4, xmm5
  movlps   xmm7, QWORD [SSE_INT_NOT_ONE]
  cvtps2dq xmm4, xmm4               // (xmm4) J := Trunc(X * FOPI)
  movlps   xmm5, QWORD [SSE_INT_FOUR]
  paddd    xmm4, xmm6
  pand     xmm4, xmm7               // (xmm4) J := (J + 1) and (not 1)
  movlps   xmm7, QWORD [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm4               // (xmm2) Y := J
  movaps   xmm3, xmm4
  movaps   xmm6, xmm4               // (xmm6) J
  pand     xmm3, xmm5               // J and 4
  pand     xmm4, xmm7               // J and 2
  pxor     xmm5, xmm5
  pslld    xmm3, 29                 // (xmm3) SwapSignBitSin := (J and 4) shl 29
  movlps   xmm7, QWORD [SSE_PI_OVER_4]
  pcmpeqd  xmm4, xmm5               // (xmm4) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  mulps    xmm2, xmm7               // Y * Pi / 4
  movlps   xmm5, QWORD [SSE_INT_TWO]
  subps    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  psubd    xmm6, xmm5               // J - 2
  movlps   xmm7, QWORD [SSE_INT_FOUR]
  pxor     xmm1, xmm3               // (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps   xmm6, xmm7               // (not (J - 2)) and 4
  movaps   xmm3, xmm0
  pslld    xmm6, 29                 // (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulps    xmm3, xmm3               // (xmm3) Z := X * X
  movlps   xmm2, QWORD [SSE_COSCOF_P0]
  movlps   xmm5, QWORD [SSE_COSCOF_P1]
  movlps   xmm7, QWORD [SSE_COSCOF_P2]
  mulps    xmm2, xmm3               // COSCOF_P0 * Z
  addps    xmm2, xmm5               // Y := COSCOF_P0 * Z + COSCOF_P1
  movlps   xmm5, QWORD [SSE_ONE_HALF]
  mulps    xmm2, xmm3               // Y * Z
  addps    xmm2, xmm7               // Y := (Y * Z) + COSCOF_P2
  movlps   xmm7, QWORD [SSE_ONE]
  mulps    xmm2, xmm3               // Y * Z
  mulps    xmm5, xmm3               // 0.5 * Z
  mulps    xmm2, xmm3               // Y * (Z * Z)
  subps    xmm2, xmm5               // Y - 0.5 * Z
  movlps   xmm5, QWORD [SSE_SINCOF_P0]
  addps    xmm2, xmm7               // (xmm2) Y := Y - 0.5 * Z + 1
  movlps   xmm7, QWORD [SSE_SINCOF_P1]
  mulps    xmm5, xmm3               // SINCOF_P0 * Z
  addps    xmm5, xmm7               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps    xmm5, xmm3               // Y2 * Z
  movlps   xmm7, QWORD [SSE_SINCOF_P2]
  addps    xmm5, xmm7               // Y2 := Y2 * Z + SINCOF_P2
  mulps    xmm5, xmm3               // Y2 * Z
  mulps    xmm5, xmm0               // Y2 * (Z * X)
  addps    xmm5, xmm0               // (xmm5) Y2 := Y2 * (Z * X) + X
  movaps   xmm0, xmm2               // Y
  movaps   xmm3, xmm5               // Y2
  andps    xmm5, xmm4               // ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm4, xmm2               // ((J and 2) = 0)? Yes: 0 , No: Y
  subps    xmm3, xmm5               // ((J and 2) = 0)? Yes: 0 , No: Y2
  subps    xmm0, xmm4               // ((J and 2) = 0)? Yes: Y , No: 0
  addps    xmm4, xmm5               // ((J and 2) = 0)? Yes: Y2, No: Y
  addps    xmm3, xmm0               // ((J and 2) = 0)? Yes: Y , No: Y2
  xorps    xmm4, xmm1               // Sin
  xorps    xmm3, xmm6               // Cos
  movlps   [ASin], xmm4
  movlps   [ACos], xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

procedure FastSinCos(const ARadians: TVector3; out ASin, ACos: TVector3); assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [ARadians]
  movss    xmm1, DWORD [ARadians+8]
  movlhps  xmm0, xmm1
  movups   xmm2, [SSE_MASK_SIGN]
  movups   xmm3, [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  pand     xmm0, xmm3               // (xmm0) X := Abs(ARadians)
  pand     xmm1, xmm2               // (xmm1) SignBitSin
  movaps   xmm4, xmm0
  movups   xmm5, [SSE_FOPI]
  movups   xmm6, [SSE_INT_ONE]
  mulps    xmm4, xmm5
  movups   xmm7, [SSE_INT_NOT_ONE]
  cvtps2dq xmm4, xmm4               // (xmm4) J := Trunc(X * FOPI)
  movups   xmm5, [SSE_INT_FOUR]
  paddd    xmm4, xmm6
  pand     xmm4, xmm7               // (xmm4) J := (J + 1) and (not 1)
  movups   xmm7, [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm4               // (xmm2) Y := J
  movaps   xmm3, xmm4
  movaps   xmm6, xmm4               // (xmm6) J
  pand     xmm3, xmm5               // J and 4
  pand     xmm4, xmm7               // J and 2
  pxor     xmm5, xmm5
  pslld    xmm3, 29                 // (xmm3) SwapSignBitSin := (J and 4) shl 29
  movups   xmm7, [SSE_PI_OVER_4]
  pcmpeqd  xmm4, xmm5               // (xmm4) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  mulps    xmm2, xmm7               // Y * Pi / 4
  movups   xmm5, [SSE_INT_TWO]
  subps    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  psubd    xmm6, xmm5               // J - 2
  movups   xmm7, [SSE_INT_FOUR]
  pxor     xmm1, xmm3               // (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps   xmm6, xmm7               // (not (J - 2)) and 4
  movaps   xmm3, xmm0
  pslld    xmm6, 29                 // (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulps    xmm3, xmm3               // (xmm3) Z := X * X
  movups   xmm2, [SSE_COSCOF_P0]
  movups   xmm5, [SSE_COSCOF_P1]
  movups   xmm7, [SSE_COSCOF_P2]
  mulps    xmm2, xmm3               // COSCOF_P0 * Z
  addps    xmm2, xmm5               // Y := COSCOF_P0 * Z + COSCOF_P1
  movups   xmm5, [SSE_ONE_HALF]
  mulps    xmm2, xmm3               // Y * Z
  addps    xmm2, xmm7               // Y := (Y * Z) + COSCOF_P2
  movups   xmm7, [SSE_ONE]
  mulps    xmm2, xmm3               // Y * Z
  mulps    xmm5, xmm3               // 0.5 * Z
  mulps    xmm2, xmm3               // Y * (Z * Z)
  subps    xmm2, xmm5               // Y - 0.5 * Z
  movups   xmm5, [SSE_SINCOF_P0]
  addps    xmm2, xmm7               // (xmm2) Y := Y - 0.5 * Z + 1
  movups   xmm7, [SSE_SINCOF_P1]
  mulps    xmm5, xmm3               // SINCOF_P0 * Z
  addps    xmm5, xmm7               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps    xmm5, xmm3               // Y2 * Z
  movups   xmm7, [SSE_SINCOF_P2]
  addps    xmm5, xmm7               // Y2 := Y2 * Z + SINCOF_P2
  mulps    xmm5, xmm3               // Y2 * Z
  mulps    xmm5, xmm0               // Y2 * (Z * X)
  addps    xmm5, xmm0               // (xmm5) Y2 := Y2 * (Z * X) + X
  movaps   xmm0, xmm2               // Y
  movaps   xmm3, xmm5               // Y2
  andps    xmm5, xmm4               // ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm4, xmm2               // ((J and 2) = 0)? Yes: 0 , No: Y
  subps    xmm3, xmm5               // ((J and 2) = 0)? Yes: 0 , No: Y2
  subps    xmm0, xmm4               // ((J and 2) = 0)? Yes: Y , No: 0
  addps    xmm4, xmm5               // ((J and 2) = 0)? Yes: Y2, No: Y
  addps    xmm3, xmm0               // ((J and 2) = 0)? Yes: Y , No: Y2
  xorps    xmm4, xmm1               // Sin
  xorps    xmm3, xmm6               // Cos
  movhlps  xmm5, xmm4
  movhlps  xmm2, xmm3
  movq     [ASin], xmm4
  movss    DWORD [ASin+8], xmm5
  movq     [ACos], xmm3
  movss    DWORD [ACos+8], xmm2

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

procedure FastSinCos(const ARadians: TVector4; out ASin, ACos: TVector4); assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [ARadians]
  movups   xmm2, [SSE_MASK_SIGN]
  movups   xmm3, [SSE_MASK_ABS_VAL]
  movaps   xmm1, xmm0
  pand     xmm0, xmm3               // (xmm0) X := Abs(ARadians)
  pand     xmm1, xmm2               // (xmm1) SignBitSin
  movaps   xmm4, xmm0
  movups   xmm5, [SSE_FOPI]
  movups   xmm6, [SSE_INT_ONE]
  mulps    xmm4, xmm5
  movups   xmm7, [SSE_INT_NOT_ONE]
  cvtps2dq xmm4, xmm4               // (xmm4) J := Trunc(X * FOPI)
  movups   xmm5, [SSE_INT_FOUR]
  paddd    xmm4, xmm6
  pand     xmm4, xmm7               // (xmm4) J := (J + 1) and (not 1)
  movups   xmm7, [SSE_INT_TWO]
  cvtdq2ps xmm2, xmm4               // (xmm2) Y := J
  movaps   xmm3, xmm4
  movaps   xmm6, xmm4               // (xmm6) J
  pand     xmm3, xmm5               // J and 4
  pand     xmm4, xmm7               // J and 2
  pxor     xmm5, xmm5
  pslld    xmm3, 29                 // (xmm3) SwapSignBitSin := (J and 4) shl 29
  movups   xmm7, [SSE_PI_OVER_4]
  pcmpeqd  xmm4, xmm5               // (xmm4) PolyMask := ((J and 2) = 0)? Yes: $FFFFFFFF, No: $00000000
  mulps    xmm2, xmm7               // Y * Pi / 4
  movups   xmm5, [SSE_INT_TWO]
  subps    xmm0, xmm2               // (xmm0) X := X - (Y * Pi / 4)
  psubd    xmm6, xmm5               // J - 2
  movups   xmm7, [SSE_INT_FOUR]
  pxor     xmm1, xmm3               // (xmm1) SignBitSin := SignBitSin xor SwapSignBitSin
  andnps   xmm6, xmm7               // (not (J - 2)) and 4
  movaps   xmm3, xmm0
  pslld    xmm6, 29                 // (xmm6) SignBitCos := ((not (J - 2)) and 4) shl 29
  mulps    xmm3, xmm3               // (xmm3) Z := X * X
  movups   xmm2, [SSE_COSCOF_P0]
  movups   xmm5, [SSE_COSCOF_P1]
  movups   xmm7, [SSE_COSCOF_P2]
  mulps    xmm2, xmm3               // COSCOF_P0 * Z
  addps    xmm2, xmm5               // Y := COSCOF_P0 * Z + COSCOF_P1
  movups   xmm5, [SSE_ONE_HALF]
  mulps    xmm2, xmm3               // Y * Z
  addps    xmm2, xmm7               // Y := (Y * Z) + COSCOF_P2
  movups   xmm7, [SSE_ONE]
  mulps    xmm2, xmm3               // Y * Z
  mulps    xmm5, xmm3               // 0.5 * Z
  mulps    xmm2, xmm3               // Y * (Z * Z)
  subps    xmm2, xmm5               // Y - 0.5 * Z
  movups   xmm5, [SSE_SINCOF_P0]
  addps    xmm2, xmm7               // (xmm2) Y := Y - 0.5 * Z + 1
  movups   xmm7, [SSE_SINCOF_P1]
  mulps    xmm5, xmm3               // SINCOF_P0 * Z
  addps    xmm5, xmm7               // Y2 := SINCOF_P0 * Z + SINCOF_P1
  mulps    xmm5, xmm3               // Y2 * Z
  movups   xmm7, [SSE_SINCOF_P2]
  addps    xmm5, xmm7               // Y2 := Y2 * Z + SINCOF_P2
  mulps    xmm5, xmm3               // Y2 * Z
  mulps    xmm5, xmm0               // Y2 * (Z * X)
  addps    xmm5, xmm0               // (xmm5) Y2 := Y2 * (Z * X) + X
  movaps   xmm0, xmm2               // Y
  movaps   xmm3, xmm5               // Y2
  andps    xmm5, xmm4               // ((J and 2) = 0)? Yes: Y2, No: 0
  andnps   xmm4, xmm2               // ((J and 2) = 0)? Yes: 0 , No: Y
  subps    xmm3, xmm5               // ((J and 2) = 0)? Yes: 0 , No: Y2
  subps    xmm0, xmm4               // ((J and 2) = 0)? Yes: Y , No: 0
  addps    xmm4, xmm5               // ((J and 2) = 0)? Yes: Y2, No: Y
  addps    xmm3, xmm0               // ((J and 2) = 0)? Yes: Y , No: Y2
  xorps    xmm4, xmm1               // Sin
  xorps    xmm3, xmm6               // Cos
  movups   [ASin], xmm4
  movups   [ACos], xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastExp(const A: Single): Single; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movss    xmm1, DWORD [SSE_EXP_A1]
  movss    xmm2, DWORD [SSE_EXP_A2]

  // Val := 12102203.1615614 * A + 1065353216.0
  mulss    xmm0, xmm1
  movss    xmm3, DWORD [SSE_EXP_CST]
  addss    xmm0, xmm2

  // if (Val >= EXP_CST) then Val := EXP_CST
  movss    xmm1, xmm0
  cmpltss  xmm0, xmm3 // (Val < EXP_CST)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm0 // (Val < EXP_CST)? Yes: Val, No: 0
  andnps   xmm0, xmm3 // (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps     xmm0, xmm1 // (Val < EXP_CST)? Yes: Val, No: EXP_CST

  // IVal := Trunc(Val)
  xorps    xmm3, xmm3
  cvtps2dq xmm1, xmm0

  // if (IVal < 0) then I := 0
  movss    xmm2, DWORD [SSE_MASK_EXPONENT]
  movdqa   xmm0, xmm1 // IVal
  pcmpgtd  xmm1, xmm3 // (IVal > 0)? Yes: $FFFFFFFF, No: $00000000
  movss    xmm3, DWORD [SSE_MASK_FRACTION]
  pand     xmm0, xmm1 // (IVal > 0)? Yes: IVal, No: 0

  // XU.I := IVal and $7F800000
  movss    xmm4, DWORD [SSE_EXP_I1]
  movss    xmm1, xmm0
  pand     xmm0, xmm2 // XU.I / XU.S

  // XU2.I := (IVal and $007FFFFF) or $3F800000;
  pand     xmm1, xmm3
  movss    xmm6, DWORD [SSE_EXP_F5]
  por      xmm1, xmm4 // XU2.I / XU2.S

  //  Result := XU.S *
  //    ( 0.509964287281036376953125 + B *
  //    ( 0.3120158612728118896484375 + B *
  //    ( 0.1666135489940643310546875 + B *
  //    (-2.12528370320796966552734375e-3 + B *
  //      1.3534179888665676116943359375e-2))));
  movss    xmm5, DWORD [SSE_EXP_F4]
  movss    xmm7, xmm1

  mulss    xmm1, xmm6
  movss    xmm4, DWORD [SSE_EXP_F3]
  addss    xmm1, xmm5
  movss    xmm3, DWORD [SSE_EXP_F2]
  mulss    xmm1, xmm7
  movss    xmm2, DWORD [SSE_EXP_F1]
  addss    xmm1, xmm4
  mulss    xmm1, xmm7
  addss    xmm1, xmm3
  mulss    xmm1, xmm7
  addss    xmm1, xmm2
  mulss    xmm1, xmm0

  movss    xmm0, xmm1

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastExp(const A: TVector2): TVector2;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  movlps   xmm1, QWORD [SSE_EXP_A1]
  movlps   xmm2, QWORD [SSE_EXP_A2]

  // Val := 12102203.1615614 * A + 1065353216.0
  mulps    xmm0, xmm1
  movlps   xmm3, QWORD [SSE_EXP_CST]
  addps    xmm0, xmm2

  // if (Val >= EXP_CST) then Val := EXP_CST
  movaps   xmm1, xmm0
  cmpltps  xmm0, xmm3 // (Val < EXP_CST)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm0 // (Val < EXP_CST)? Yes: Val, No: 0
  andnps   xmm0, xmm3 // (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps     xmm0, xmm1 // (Val < EXP_CST)? Yes: Val, No: EXP_CST

  // IVal := Trunc(Val)
  xorps    xmm3, xmm3
  cvtps2dq xmm1, xmm0

  // if (IVal < 0) then I := 0
  movlps   xmm2, QWORD [SSE_MASK_EXPONENT]
  movdqa   xmm0, xmm1 // IVal
  pcmpgtd  xmm1, xmm3 // (IVal > 0)? Yes: $FFFFFFFF, No: $00000000
  movlps   xmm3, QWORD [SSE_MASK_FRACTION]
  pand     xmm0, xmm1 // (IVal > 0)? Yes: IVal, No: 0

  // XU.I := IVal and $7F800000
  movlps   xmm4, QWORD [SSE_EXP_I1]
  movdqa   xmm1, xmm0
  pand     xmm0, xmm2 // XU.I / XU.S

  // XU2.I := (IVal and $007FFFFF) or $3F800000;
  pand     xmm1, xmm3
  movlps   xmm6, QWORD [SSE_EXP_F5]
  por      xmm1, xmm4 // XU2.I / XU2.S

  //  Result := XU.S *
  //    ( 0.509964287281036376953125 + B *
  //    ( 0.3120158612728118896484375 + B *
  //    ( 0.1666135489940643310546875 + B *
  //    (-2.12528370320796966552734375e-3 + B *
  //      1.3534179888665676116943359375e-2))));
  movlps   xmm5, QWORD [SSE_EXP_F4]
  movaps   xmm7, xmm1

  mulps    xmm1, xmm6
  movlps   xmm4, QWORD [SSE_EXP_F3]
  addps    xmm1, xmm5
  movlps   xmm3, QWORD [SSE_EXP_F2]
  mulps    xmm1, xmm7
  movlps   xmm2, QWORD [SSE_EXP_F1]
  addps    xmm1, xmm4
  mulps    xmm1, xmm7
  addps    xmm1, xmm3
  mulps    xmm1, xmm7
  addps    xmm1, xmm2
  mulps    xmm1, xmm0

  movq     rax, xmm1

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastExp(const A: TVector3): TVector3;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movups   xmm1, [SSE_EXP_A1]
  movups   xmm2, [SSE_EXP_A2]

  // Val := 12102203.1615614 * A + 1065353216.0
  mulps    xmm0, xmm1
  movups   xmm3, [SSE_EXP_CST]
  addps    xmm0, xmm2

  // if (Val >= EXP_CST) then Val := EXP_CST
  movaps   xmm1, xmm0
  cmpltps  xmm0, xmm3 // (Val < EXP_CST)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm0 // (Val < EXP_CST)? Yes: Val, No: 0
  andnps   xmm0, xmm3 // (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps     xmm0, xmm1 // (Val < EXP_CST)? Yes: Val, No: EXP_CST

  // IVal := Trunc(Val)
  xorps    xmm3, xmm3
  cvtps2dq xmm1, xmm0

  // if (IVal < 0) then I := 0
  movups   xmm2, [SSE_MASK_EXPONENT]
  movdqa   xmm0, xmm1 // IVal
  pcmpgtd  xmm1, xmm3 // (IVal > 0)? Yes: $FFFFFFFF, No: $00000000
  movups   xmm3, [SSE_MASK_FRACTION]
  pand     xmm0, xmm1 // (IVal > 0)? Yes: IVal, No: 0

  // XU.I := IVal and $7F800000
  movups   xmm4, [SSE_EXP_I1]
  movdqa   xmm1, xmm0
  pand     xmm0, xmm2 // XU.I / XU.S

  // XU2.I := (IVal and $007FFFFF) or $3F800000;
  pand     xmm1, xmm3
  movups   xmm6, [SSE_EXP_F5]
  por      xmm1, xmm4 // XU2.I / XU2.S

  //  Result := XU.S *
  //    ( 0.509964287281036376953125 + B *
  //    ( 0.3120158612728118896484375 + B *
  //    ( 0.1666135489940643310546875 + B *
  //    (-2.12528370320796966552734375e-3 + B *
  //      1.3534179888665676116943359375e-2))));
  movups   xmm5, [SSE_EXP_F4]
  movaps   xmm7, xmm1

  mulps    xmm1, xmm6
  movups   xmm4, [SSE_EXP_F3]
  addps    xmm1, xmm5
  movups   xmm3, [SSE_EXP_F2]
  mulps    xmm1, xmm7
  movups   xmm2, [SSE_EXP_F1]
  addps    xmm1, xmm4
  mulps    xmm1, xmm7
  addps    xmm1, xmm3
  mulps    xmm1, xmm7
  addps    xmm1, xmm2
  mulps    xmm1, xmm0

  movhlps  xmm0, xmm1
  movq     [Result], xmm1
  movss    DWORD [Result+8], xmm0

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastExp(const A: TVector4): TVector4;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [A]
  movups   xmm1, [SSE_EXP_A1]
  movups   xmm2, [SSE_EXP_A2]

  // Val := 12102203.1615614 * A + 1065353216.0
  mulps    xmm0, xmm1
  movups   xmm3, [SSE_EXP_CST]
  addps    xmm0, xmm2

  // if (Val >= EXP_CST) then Val := EXP_CST
  movaps   xmm1, xmm0
  cmpltps  xmm0, xmm3 // (Val < EXP_CST)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm0 // (Val < EXP_CST)? Yes: Val, No: 0
  andnps   xmm0, xmm3 // (Val < EXP_CST)? Yes: 0, No: EXP_CST
  orps     xmm0, xmm1 // (Val < EXP_CST)? Yes: Val, No: EXP_CST

  // IVal := Trunc(Val)
  xorps    xmm3, xmm3
  cvtps2dq xmm1, xmm0

  // if (IVal < 0) then I := 0
  movups   xmm2, [SSE_MASK_EXPONENT]
  movdqa   xmm0, xmm1 // IVal
  pcmpgtd  xmm1, xmm3 // (IVal > 0)? Yes: $FFFFFFFF, No: $00000000
  movups   xmm3, [SSE_MASK_FRACTION]
  pand     xmm0, xmm1 // (IVal > 0)? Yes: IVal, No: 0

  // XU.I := IVal and $7F800000
  movups   xmm4, [SSE_EXP_I1]
  movdqa   xmm1, xmm0
  pand     xmm0, xmm2 // XU.I / XU.S

  // XU2.I := (IVal and $007FFFFF) or $3F800000;
  pand     xmm1, xmm3
  movups   xmm6, [SSE_EXP_F5]
  por      xmm1, xmm4 // XU2.I / XU2.S

  //  Result := XU.S *
  //    ( 0.509964287281036376953125 + B *
  //    ( 0.3120158612728118896484375 + B *
  //    ( 0.1666135489940643310546875 + B *
  //    (-2.12528370320796966552734375e-3 + B *
  //      1.3534179888665676116943359375e-2))));
  movups   xmm5, [SSE_EXP_F4]
  movaps   xmm7, xmm1

  mulps    xmm1, xmm6
  movups   xmm4, [SSE_EXP_F3]
  addps    xmm1, xmm5
  movups   xmm3, [SSE_EXP_F2]
  mulps    xmm1, xmm7
  movups   xmm2, [SSE_EXP_F1]
  addps    xmm1, xmm4
  mulps    xmm1, xmm7
  addps    xmm1, xmm3
  mulps    xmm1, xmm7
  addps    xmm1, xmm2
  mulps    xmm1, xmm0

  movups   [Result], xmm1

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastLn(const A: Single): Single; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  xorps    xmm2, xmm2
  movss    xmm1, xmm0
  movss    xmm3, DWORD [SSE_LN_CST]
  movss    xmm4, DWORD [SSE_NEG_INFINITY]

  // Exp := Val.I shr 23
  psrld    xmm0, 23
  movss    xmm5, xmm1
  cvtdq2ps xmm0, xmm0 // xmm0=Exp

  // if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnless xmm1, xmm2 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
  movss    xmm2, DWORD [SSE_MASK_FRACTION]
  andps    xmm3, xmm1 // (A > 0)? Yes: -89.93423858, No: 0
  andnps   xmm1, xmm4 // (A > 0)? Yes: 0, No: NegInfinity
  movss    xmm4, DWORD [SSE_EXP_I1]
  orps     xmm1, xmm3 // (A > 0)? Yes: -89.93423858, No: NegInfinity

  // Val.I := (Val.I and $007FFFFF) or $3F800000
  pand     xmm5, xmm2
  movss    xmm2, DWORD [SSE_LN_F5]
  por      xmm5, xmm4
  movss    xmm6, DWORD [SSE_LN_F3]
  movss    xmm3, xmm5 // xmm3=X
  mulss    xmm5, xmm5 // xmm5=X2

  movss    xmm4, xmm3
  movss    xmm7, DWORD [SSE_LN_F4]
  mulss    xmm4, xmm6
  mulss    xmm0, xmm2 // xmm0 = Exp * 0.69314718055995
  subss    xmm4, xmm7
  movss    xmm7, DWORD [SSE_LN_F2]
  movss    xmm6, xmm3
  mulss    xmm4, xmm5 // xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subss    xmm6, xmm7
  movss    xmm2, DWORD [SSE_LN_F1]
  addss    xmm4, xmm6 // xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulss    xmm3, xmm2
  mulss    xmm4, xmm5 // xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addss    xmm3, xmm1 // xmm3 = (3.3977745 * X + AddCst)
  addss    xmm4, xmm0
  addss    xmm3, xmm4

  movss    xmm0, xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastLn(const A: TVector2): TVector2; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  xorps    xmm2, xmm2
  movaps   xmm1, xmm0
  movlps   xmm3, QWORD [SSE_LN_CST]
  movlps   xmm4, QWORD [SSE_NEG_INFINITY]

  // Exp := Val.I shr 23
  psrld    xmm0, 23
  movaps   xmm5, xmm1
  cvtdq2ps xmm0, xmm0 // xmm0=Exp

  // if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnleps xmm1, xmm2 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
  movlps   xmm2, QWORD [SSE_MASK_FRACTION]
  andps    xmm3, xmm1 // (A > 0)? Yes: -89.93423858, No: 0
  andnps   xmm1, xmm4 // (A > 0)? Yes: 0, No: NegInfinity
  movlps   xmm4, QWORD [SSE_EXP_I1]
  orps     xmm1, xmm3 // (A > 0)? Yes: -89.93423858, No: NegInfinity

  // Val.I := (Val.I and $007FFFFF) or $3F800000
  pand     xmm5, xmm2
  movlps   xmm2, QWORD [SSE_LN_F5]
  por      xmm5, xmm4
  movlps   xmm6, QWORD [SSE_LN_F3]
  movaps   xmm3, xmm5 // xmm3=X
  mulps    xmm5, xmm5 // xmm5=X2

  movaps   xmm4, xmm3
  movlps   xmm7, QWORD [SSE_LN_F4]
  mulps    xmm4, xmm6
  mulps    xmm0, xmm2 // xmm0 = Exp * 0.69314718055995
  subps    xmm4, xmm7
  movlps   xmm7, QWORD [SSE_LN_F2]
  movaps   xmm6, xmm3
  mulps    xmm4, xmm5 // xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subps    xmm6, xmm7
  movlps   xmm2, QWORD [SSE_LN_F1]
  addps    xmm4, xmm6 // xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulps    xmm3, xmm2
  mulps    xmm4, xmm5 // xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addps    xmm3, xmm1 // xmm3 = (3.3977745 * X + AddCst)
  addps    xmm4, xmm0
  addps    xmm3, xmm4

  movq     rax, xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastLn(const A: TVector3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  xorps    xmm2, xmm2
  movaps   xmm1, xmm0
  movups   xmm3, [SSE_LN_CST]
  movups   xmm4, [SSE_NEG_INFINITY]

  // Exp := Val.I shr 23
  psrld    xmm0, 23
  movaps   xmm5, xmm1
  cvtdq2ps xmm0, xmm0 // xmm0=Exp

  // if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnleps xmm1, xmm2 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
  movups   xmm2, [SSE_MASK_FRACTION]
  andps    xmm3, xmm1 // (A > 0)? Yes: -89.93423858, No: 0
  andnps   xmm1, xmm4 // (A > 0)? Yes: 0, No: NegInfinity
  movups   xmm4, [SSE_EXP_I1]
  orps     xmm1, xmm3 // (A > 0)? Yes: -89.93423858, No: NegInfinity

  // Val.I := (Val.I and $007FFFFF) or $3F800000
  pand     xmm5, xmm2
  movups   xmm2, [SSE_LN_F5]
  por      xmm5, xmm4
  movups   xmm6, [SSE_LN_F3]
  movaps   xmm3, xmm5 // xmm3=X
  mulps    xmm5, xmm5 // xmm5=X2

  movaps   xmm4, xmm3
  movups   xmm7, [SSE_LN_F4]
  mulps    xmm4, xmm6
  mulps    xmm0, xmm2 // xmm0 = Exp * 0.69314718055995
  subps    xmm4, xmm7
  movups   xmm7, [SSE_LN_F2]
  movaps   xmm6, xmm3
  mulps    xmm4, xmm5 // xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subps    xmm6, xmm7
  movups   xmm2, [SSE_LN_F1]
  addps    xmm4, xmm6 // xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulps    xmm3, xmm2
  mulps    xmm4, xmm5 // xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addps    xmm3, xmm1 // xmm3 = (3.3977745 * X + AddCst)
  addps    xmm4, xmm0
  addps    xmm3, xmm4

  movhlps  xmm2, xmm3
  movq     [Result], xmm3
  movss    DWORD [Result+8], xmm2

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastLn(const A: TVector4): TVector4; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [A]
  xorps    xmm2, xmm2
  movaps   xmm1, xmm0
  movups   xmm3, [SSE_LN_CST]
  movups   xmm4, [SSE_NEG_INFINITY]

  // Exp := Val.I shr 23
  psrld    xmm0, 23
  movaps   xmm5, xmm1
  cvtdq2ps xmm0, xmm0 // xmm0=Exp

  // if (A > 0) then AddCst := -89.93423858 else AddCst := NegInfinity
  cmpnleps xmm1, xmm2 // (A > 0)? Yes: $FFFFFFFF, No: $00000000
  movups   xmm2, [SSE_MASK_FRACTION]
  andps    xmm3, xmm1 // (A > 0)? Yes: -89.93423858, No: 0
  andnps   xmm1, xmm4 // (A > 0)? Yes: 0, No: NegInfinity
  movups   xmm4, [SSE_EXP_I1]
  orps     xmm1, xmm3 // (A > 0)? Yes: -89.93423858, No: NegInfinity

  // Val.I := (Val.I and $007FFFFF) or $3F800000
  pand     xmm5, xmm2
  movups   xmm2, [SSE_LN_F5]
  por      xmm5, xmm4
  movups   xmm6, [SSE_LN_F3]
  movaps   xmm3, xmm5 // xmm3=X
  mulps    xmm5, xmm5 // xmm5=X2

  movaps   xmm4, xmm3
  movups   xmm7, [SSE_LN_F4]
  mulps    xmm4, xmm6
  mulps    xmm0, xmm2 // xmm0 = Exp * 0.69314718055995
  subps    xmm4, xmm7
  movups   xmm7, [SSE_LN_F2]
  movaps   xmm6, xmm3
  mulps    xmm4, xmm5 // xmm4 = X2 * (0.024982445 * X - 0.24371102)
  subps    xmm6, xmm7
  movups   xmm2, [SSE_LN_F1]
  addps    xmm4, xmm6 // xmm4 = (X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102)
  mulps    xmm3, xmm2
  mulps    xmm4, xmm5 // xmm4 = X2 * ((X - 2.2744832) + X2 * (0.024982445 * X - 0.24371102))
  addps    xmm3, xmm1 // xmm3 = (3.3977745 * X + AddCst)
  addps    xmm4, xmm0
  addps    xmm3, xmm4

  movups   [Result], xmm3

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FastLog2(const A: Single): Single; assembler;
asm
  movss    xmm2, DWORD [SSE_MASK_FRACTION]
  movss    xmm1, xmm0

  // MX.I := (VX.I and $007FFFFF) or $3F000000
  movss    xmm3, DWORD [SSE_LOG2_I1]
  pand     xmm0, xmm2
  cvtdq2ps xmm1, xmm1
  movss    xmm4, DWORD [SSE_LOG2_F1]
  por      xmm0, xmm3

  movss    xmm2, DWORD [SSE_LOG2_F2]
  mulss    xmm1, xmm4 // VX.I * 1.1920928955078125e-7
  movss    xmm3, DWORD [SSE_LOG2_F3]
  subss    xmm1, xmm2 // Result - 124.22551499
  mulss    xmm3, xmm0
  movss    xmm4, DWORD [SSE_LOG2_F5]
  subss    xmm1, xmm3 // Result - 124.22551499 - 1.498030302 * MX.S
  movss    xmm2, DWORD [SSE_LOG2_F4]
  addss    xmm0, xmm4
  divss    xmm2, xmm0
  subss    xmm1, xmm2 // Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movss    xmm0, xmm1
end;

function FastLog2(const A: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  movlps   xmm2, QWORD [SSE_MASK_FRACTION]
  movaps   xmm1, xmm0

  // MX.I := (VX.I and $007FFFFF) or $3F000000
  movlps   xmm3, QWORD [SSE_LOG2_I1]
  pand     xmm0, xmm2
  cvtdq2ps xmm1, xmm1
  movlps   xmm4, QWORD [SSE_LOG2_F1]
  por      xmm0, xmm3

  movlps   xmm2, QWORD [SSE_LOG2_F2]
  mulps    xmm1, xmm4 // VX.I * 1.1920928955078125e-7
  movlps   xmm3, QWORD [SSE_LOG2_F3]
  subps    xmm1, xmm2 // Result - 124.22551499
  mulps    xmm3, xmm0
  movlps   xmm4, QWORD [SSE_LOG2_F5]
  subps    xmm1, xmm3 // Result - 124.22551499 - 1.498030302 * MX.S
  movlps   xmm2, QWORD [SSE_LOG2_F4]
  addps    xmm0, xmm4
  divps    xmm2, xmm0
  subps    xmm1, xmm2 // Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movq     rax, xmm1
end;

function FastLog2(const A: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movups   xmm2, [SSE_MASK_FRACTION]
  movaps   xmm1, xmm0

  // MX.I := (VX.I and $007FFFFF) or $3F000000
  movups   xmm3, [SSE_LOG2_I1]
  pand     xmm0, xmm2
  cvtdq2ps xmm1, xmm1
  movups   xmm4, [SSE_LOG2_F1]
  por      xmm0, xmm3

  movups   xmm2, [SSE_LOG2_F2]
  mulps    xmm1, xmm4 // VX.I * 1.1920928955078125e-7
  movups   xmm3, [SSE_LOG2_F3]
  subps    xmm1, xmm2 // Result - 124.22551499
  mulps    xmm3, xmm0
  movups   xmm4, [SSE_LOG2_F5]
  subps    xmm1, xmm3 // Result - 124.22551499 - 1.498030302 * MX.S
  movups   xmm2, [SSE_LOG2_F4]
  addps    xmm0, xmm4
  divps    xmm2, xmm0
  subps    xmm1, xmm2 // Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movhlps  xmm0, xmm1
  movq     [Result], xmm1
  movss    DWORD [Result+8], xmm0
end;

function FastLog2(const A: TVector4): TVector4; assembler;
asm
  movups   xmm0, [A]
  movups   xmm2, [SSE_MASK_FRACTION]
  movaps   xmm1, xmm0

  // MX.I := (VX.I and $007FFFFF) or $3F000000
  movups   xmm3, [SSE_LOG2_I1]
  pand     xmm0, xmm2
  cvtdq2ps xmm1, xmm1
  movups   xmm4, [SSE_LOG2_F1]
  por      xmm0, xmm3

  movups   xmm2, [SSE_LOG2_F2]
  mulps    xmm1, xmm4 // VX.I * 1.1920928955078125e-7
  movups   xmm3, [SSE_LOG2_F3]
  subps    xmm1, xmm2 // Result - 124.22551499
  mulps    xmm3, xmm0
  movups   xmm4, [SSE_LOG2_F5]
  subps    xmm1, xmm3 // Result - 124.22551499 - 1.498030302 * MX.S
  movups   xmm2, [SSE_LOG2_F4]
  addps    xmm0, xmm4
  divps    xmm2, xmm0
  subps    xmm1, xmm2 // Result - 124.22551499 - 1.498030302 * MX.S - 1.72587999 / (0.3520887068 + MX.S)

  movups   [Result], xmm1
end;

function FastExp2(const A: Single): Single; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Positive (=Round Down)
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  xorps    xmm1, xmm1
  and      ecx, SSE_ROUND_MASK
  movss    xmm3, xmm0
  or       ecx, SSE_ROUND_DOWN
  movss    xmm5, xmm0
  mov      [NewFlags], ecx

  movss    xmm1, DWORD [SSE_EXP2_F1]
  ldmxcsr  [NewFlags]

  // Z := A - RoundDown(A)
  cvtps2dq xmm3, xmm3
  addss    xmm1, xmm5 // A + 121.2740575
  cvtdq2ps xmm3, xmm3
  movss    xmm2, DWORD [SSE_EXP2_F2]
  subss    xmm0, xmm3

  movss    xmm3, DWORD [SSE_EXP2_F3]
  movss    xmm4, DWORD [SSE_EXP2_F4]
  subss    xmm3, xmm0 // (4.84252568 - Z)
  mulss    xmm0, xmm4 // 1.49012907 * Z
  divss    xmm2, xmm3
  movss    xmm5, DWORD [SSE_EXP2_F5]
  addss    xmm1, xmm2 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subss    xmm1, xmm0 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulss    xmm1, xmm5 // (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq xmm1, xmm1

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movss    xmm0, xmm1
end;

function FastExp2(const A: TVector2): TVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Positive (=Round Down)
  stmxcsr  [OldFlags]
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  mov      ecx, [OldFlags]
  xorps    xmm1, xmm1
  and      ecx, SSE_ROUND_MASK
  movaps   xmm3, xmm0
  or       ecx, SSE_ROUND_DOWN
  movaps   xmm5, xmm0
  mov      [NewFlags], ecx

  movlps   xmm1, QWORD [SSE_EXP2_F1]
  ldmxcsr  [NewFlags]

  // Z := A - RoundDown(A)
  cvtps2dq xmm3, xmm3
  addps    xmm1, xmm5 // A + 121.2740575
  cvtdq2ps xmm3, xmm3
  movlps   xmm2, QWORD [SSE_EXP2_F2]
  subps    xmm0, xmm3

  movlps   xmm3, QWORD [SSE_EXP2_F3]
  movlps   xmm4, QWORD [SSE_EXP2_F4]
  subps    xmm3, xmm0 // (4.84252568 - Z)
  mulps    xmm0, xmm4 // 1.49012907 * Z
  divps    xmm2, xmm3
  movlps   xmm5, QWORD [SSE_EXP2_F5]
  addps    xmm1, xmm2 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subps    xmm1, xmm0 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulps    xmm1, xmm5 // (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq xmm1, xmm1

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm1
end;

function FastExp2(const A: TVector3): TVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Positive (=Round Down)
  stmxcsr  [OldFlags]
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  mov      edx, [OldFlags]
  xorps    xmm1, xmm1
  and      edx, SSE_ROUND_MASK
  movaps   xmm3, xmm0
  or       edx, SSE_ROUND_DOWN
  movaps   xmm5, xmm0
  mov      [NewFlags], edx

  movups   xmm1, [SSE_EXP2_F1]
  ldmxcsr  [NewFlags]

  // Z := A - RoundDown(A)
  cvtps2dq xmm3, xmm3
  addps    xmm1, xmm5 // A + 121.2740575
  cvtdq2ps xmm3, xmm3
  movups   xmm2, [SSE_EXP2_F2]
  subps    xmm0, xmm3

  movups   xmm3, [SSE_EXP2_F3]
  movups   xmm4, [SSE_EXP2_F4]
  subps    xmm3, xmm0 // (4.84252568 - Z)
  mulps    xmm0, xmm4 // 1.49012907 * Z
  divps    xmm2, xmm3
  movups   xmm5, [SSE_EXP2_F5]
  addps    xmm1, xmm2 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subps    xmm1, xmm0 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulps    xmm1, xmm5 // (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq xmm1, xmm1

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm0, xmm1
  movq     [Result], xmm1
  movss    DWORD [Result+8], xmm0
end;

function FastExp2(const A: TVector4): TVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Positive (=Round Down)
  stmxcsr  [OldFlags]
  movups   xmm0, [A]
  mov      edx, [OldFlags]
  xorps    xmm1, xmm1
  and      edx, SSE_ROUND_MASK
  movaps   xmm3, xmm0
  or       edx, SSE_ROUND_DOWN
  movaps   xmm5, xmm0
  mov      [NewFlags], edx

  movups   xmm1, [SSE_EXP2_F1]
  ldmxcsr  [NewFlags]

  // Z := A - RoundDown(A)
  cvtps2dq xmm3, xmm3
  addps    xmm1, xmm5 // A + 121.2740575
  cvtdq2ps xmm3, xmm3
  movups   xmm2, [SSE_EXP2_F2]
  subps    xmm0, xmm3

  movups   xmm3, [SSE_EXP2_F3]
  movups   xmm4, [SSE_EXP2_F4]
  subps    xmm3, xmm0 // (4.84252568 - Z)
  mulps    xmm0, xmm4 // 1.49012907 * Z
  divps    xmm2, xmm3
  movups   xmm5, [SSE_EXP2_F5]
  addps    xmm1, xmm2 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z)
  subps    xmm1, xmm0 // A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z
  mulps    xmm1, xmm5 // (1 shl 23) * (A + 121.2740575 + 27.7280233 / (4.84252568 - Z) - 1.49012907 * Z)
  cvtps2dq xmm1, xmm1

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm1
end;

{ Common Functions }

function Abs(const A: Single): Single;
begin
  Result := System.Abs(A);
end;

function Abs(const A: TVector2): TVector2;
begin
  Result.Init(System.Abs(A.X), System.Abs(A.Y));
end;

function Abs(const A: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movups   xmm2, [SSE_MASK_ABS_VAL]
  andps    xmm0, xmm2
  pand     xmm1, xmm2
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Abs(const A: TVector4): TVector4; assembler;
asm
  movups   xmm0, [A]
  movups   xmm1, [SSE_MASK_ABS_VAL]
  andps    xmm0, xmm1
  movups   [Result], xmm0
end;

function Sign(const A: Single): Single; assembler;
asm
  movss    xmm1, DWORD [SSE_ONE]
  movss    xmm2, xmm0
  movss    xmm3, DWORD [SSE_MASK_SIGN]

  andps    xmm0, xmm3 // (A < 0)? Yes: $80000000, No: $00000000
  xorps    xmm4, xmm4
  orps     xmm0, xmm1 // (A < 0)? Yes: -1, No: 1
  cmpneqss xmm2, xmm4 // (A = 0)? Yes: $00000000, No: $FFFFFFFF
  andps    xmm0, xmm2 // (A = 0)? Yes: 0, No: -1 or 1
end;

function Sign(const A: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  movlps   xmm1, QWORD [SSE_ONE]
  movaps   xmm2, xmm0
  movlps   xmm3, QWORD [SSE_MASK_SIGN]

  andps    xmm0, xmm3 // (A < 0)? Yes: $80000000, No: $00000000
  xorps    xmm4, xmm4
  orps     xmm0, xmm1 // (A < 0)? Yes: -1, No: 1
  cmpneqps xmm2, xmm4 // (A = 0)? Yes: $00000000, No: $FFFFFFFF
  andps    xmm0, xmm2 // (A = 0)? Yes: 0, No: -1 or 1
  movq     rax, xmm0
end;

function Sign(const A: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movups   xmm1, [SSE_ONE]
  movaps   xmm2, xmm0
  movups   xmm3, [SSE_MASK_SIGN]

  andps    xmm0, xmm3 // (A < 0)? Yes: $80000000, No: $00000000
  xorps    xmm4, xmm4
  orps     xmm0, xmm1 // (A < 0)? Yes: -1, No: 1
  cmpneqps xmm2, xmm4 // (A = 0)? Yes: $00000000, No: $FFFFFFFF
  andps    xmm0, xmm2 // (A = 0)? Yes: 0, No: -1 or 1
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Sign(const A: TVector4): TVector4; assembler;
asm
  movups   xmm0, [A]
  movups   xmm1, [SSE_ONE]
  movaps   xmm2, xmm0
  movups   xmm3, [SSE_MASK_SIGN]

  andps    xmm0, xmm3 // (A < 0)? Yes: $80000000, No: $00000000
  xorps    xmm4, xmm4
  orps     xmm0, xmm1 // (A < 0)? Yes: -1, No: 1
  cmpneqps xmm2, xmm4 // (A = 0)? Yes: $00000000, No: $FFFFFFFF
  andps    xmm0, xmm2 // (A = 0)? Yes: 0, No: -1 or 1
  movups   [Result], xmm0
end;

function Floor(const A: Single): Integer;
begin
  Result := System.Math.Floor(A);
end;
{function Floor(const A: Single): Integer; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Down
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  and      ecx, SSE_ROUND_MASK
  or       ecx, SSE_ROUND_DOWN
  mov      [NewFlags], ecx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movd     eax, xmm0
end;}

function Floor(const A: TVector2): TIVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Down
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_DOWN
  mov      [NewFlags], eax
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm0
end;

function Floor(const A: TVector3): TIVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Down
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_DOWN
  mov      [NewFlags], eax
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Floor(const A: TVector4): TIVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Round Down
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_DOWN
  mov      [NewFlags], eax
  movups   xmm0, [A]
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm0
end;

function Trunc(const A: Single): Integer;
begin
  Result := System.Trunc(A);
end;

{function Trunc(const A: Single): Integer; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  and      ecx, SSE_ROUND_MASK
  or       ecx, SSE_ROUND_TRUNC
  mov      [NewFlags], ecx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movd     eax, xmm0
end;}

function Trunc(const A: TVector2): TIVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  mov      [NewFlags], eax
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm0
end;

function Trunc(const A: TVector3): TIVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  mov      [NewFlags], eax
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Trunc(const A: TVector4): TIVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  mov      [NewFlags], eax
  movups   xmm0, [A]
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm0
end;

function Round(const A: Single): Integer;
begin
  Result := System.Round(A);
end;

function Round(const A: TVector2): TIVector2; assembler;
asm
  // Rounding mode defaults to round-to-nearest
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  cvtps2dq xmm0, xmm0
  movq     rax, xmm0
end;

function Round(const A: TVector3): TIVector3; assembler;
asm
  // Rounding mode defaults to round-to-nearest
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  cvtps2dq xmm0, xmm0
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Round(const A: TVector4): TIVector4; assembler;
asm
  // Rounding mode defaults to round-to-nearest
  movups   xmm0, [A]
  cvtps2dq xmm0, xmm0
  movups   [Result], xmm0
end;

function Ceil(const A: Single): Integer;
begin
  Result := System.Math.Ceil(A);
end;
{function Ceil(const A: Single): Integer; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Ceil Down
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  and      ecx, SSE_ROUND_MASK
  or       ecx, SSE_ROUND_UP
  mov      [NewFlags], ecx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movd     eax, xmm0
end;}

function Ceil(const A: TVector2): TIVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Ceil Down
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_UP
  mov      [NewFlags], eax
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm0
end;

function Ceil(const A: TVector3): TIVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Ceil Down
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_UP
  mov      [NewFlags], eax
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Ceil(const A: TVector4): TIVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Ceil Down
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_UP
  mov      [NewFlags], eax
  movups   xmm0, [A]
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm0
end;

function Frac(const A: Single): Single;
begin
  Result := System.Frac(A);
end;
{function Frac(const A: Single): Single; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  and      ecx, SSE_ROUND_MASK
  or       ecx, SSE_ROUND_TRUNC
  mov      [NewFlags], ecx
  movss    xmm1, xmm0
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0
  ldmxcsr  [OldFlags]
  cvtdq2ps xmm0, xmm0
  subss    xmm1, xmm0 // A - Trunc(A)

  movss    xmm0, xmm1
end;}

function Frac(const A: TVector2): TVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      edx, [OldFlags]
  and      edx, SSE_ROUND_MASK
  or       edx, SSE_ROUND_TRUNC
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  mov      [NewFlags], edx
  movaps   xmm1, xmm0
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0
  ldmxcsr  [OldFlags]
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)

  movq     rax, xmm1
end;

function Frac(const A: TVector3): TVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  mov      [NewFlags], eax
  movaps   xmm1, xmm0
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0
  ldmxcsr  [OldFlags]
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)

  movhlps  xmm0, xmm1
  movq     [Result], xmm1
  movss    DWORD [Result+8], xmm0
end;

function Frac(const A: TVector4): TVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  movups   xmm0, [A]
  mov      [NewFlags], eax
  movaps   xmm1, xmm0
  ldmxcsr  [NewFlags]

  cvtps2dq xmm0, xmm0
  ldmxcsr  [OldFlags]
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)

  movups   [Result], xmm1
end;

function FMod(const A, B: Single): Single;
begin
  Result := A - (B * Trunc(A / B));
end;
{function FMod(const A, B: Single): Single; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      edx, [OldFlags]
  movss    xmm2, xmm0
  and      edx, SSE_ROUND_MASK
  movss    xmm3, xmm1
  or       edx, SSE_ROUND_TRUNC
  divss    xmm2, xmm3 // A / B
  mov      [NewFlags], edx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulss    xmm2, xmm1
  subss    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]
end;}

function FMod(const A: TVector2; const B: Single): TVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  shufps   xmm1, xmm1, $00 // Replicate B
  and      ecx, SSE_ROUND_MASK
  movaps   xmm2, xmm0
  or       ecx, SSE_ROUND_TRUNC
  movaps   xmm3, xmm1
  mov      [NewFlags], ecx
  divps    xmm2, xmm3 // A / B
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulps    xmm2, xmm1
  subps    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm0
end;

function FMod(const A, B: TVector2): TVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}
  stmxcsr  [OldFlags]
  {$IF RTLVersion >= 33}
  movlps   xmm1, [B]
  {$ELSE}
  movq     xmm1, B
  {$ENDIF}
  mov      edx, [OldFlags]
  movaps   xmm2, xmm0
  and      edx, SSE_ROUND_MASK
  movaps   xmm3, xmm1
  or       edx, SSE_ROUND_TRUNC
  divps    xmm2, xmm3 // A / B
  mov      [NewFlags], edx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulps    xmm2, xmm1
  subps    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm0
end;

function FMod(const A: TVector3; const B: Single): TVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movss    xmm1, B
  stmxcsr  [OldFlags]
  mov      edx, [OldFlags]
  shufps   xmm1, xmm1, $00 // Replicate B
  and      edx, SSE_ROUND_MASK
  movaps   xmm2, xmm0
  or       edx, SSE_ROUND_TRUNC
  movaps   xmm3, xmm1
  mov      [NewFlags], edx
  divps    xmm2, xmm3 // A / B
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulps    xmm2, xmm1
  subps    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function FMod(const A, B: TVector3): TVector3;
begin
  Result.Init(Neslib.FastMath.FMod(A.X, B.X), Neslib.FastMath.FMod(A.Y, B.Y), Neslib.FastMath.FMod(A.Z, B.Z));
end;
{function FMod(const A, B: TVector3): TVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  stmxcsr  [OldFlags]
  movq     xmm1, [B]
  movss    xmm2, DWORD [B+8]
  movlhps  xmm1, xmm2
  mov      edx, [OldFlags]
  movaps   xmm2, xmm0
  and      edx, SSE_ROUND_MASK
  movaps   xmm3, xmm1
  or       edx, SSE_ROUND_TRUNC
  divps    xmm2, xmm3 // A / B
  mov      [NewFlags], edx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulps    xmm2, xmm1
  subps    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;}

function FMod(const A: TVector4; const B: Single): TVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  movups   xmm0, [A]
  movss    xmm1, B
  stmxcsr  [OldFlags]
  mov      edx, [OldFlags]
  shufps   xmm1, xmm1, $00 // Replicate B
  and      edx, SSE_ROUND_MASK
  movaps   xmm2, xmm0
  or       edx, SSE_ROUND_TRUNC
  movaps   xmm3, xmm1
  mov      [NewFlags], edx
  divps    xmm2, xmm3 // A / B
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulps    xmm2, xmm1
  subps    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm0
end;

function FMod(const A, B: TVector4): TVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  movups   xmm0, [A]
  stmxcsr  [OldFlags]
  movups   xmm1, [B]
  mov      edx, [OldFlags]
  movaps   xmm2, xmm0
  and      edx, SSE_ROUND_MASK
  movaps   xmm3, xmm1
  or       edx, SSE_ROUND_TRUNC
  divps    xmm2, xmm3 // A / B
  mov      [NewFlags], edx
  ldmxcsr  [NewFlags]

  cvtps2dq xmm2, xmm2
  cvtdq2ps xmm2, xmm2 // Trunc(A / B)
  mulps    xmm2, xmm1
  subps    xmm0, xmm2 // A - (B * Trunc(A / B))

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm0
end;

function ModF(const A: Single; out B: Integer): Single;
begin
  B := Trunc(A);
  Result := Frac(A);
end;
{function ModF(const A: Single; out B: Integer): Single; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      ecx, [OldFlags]
  and      ecx, SSE_ROUND_MASK
  or       ecx, SSE_ROUND_TRUNC
  mov      [NewFlags], ecx
  ldmxcsr  [NewFlags]

  movss    xmm1, xmm0
  cvtps2dq xmm0, xmm0
  movss    [B], xmm0  // B = Trunc(A)
  cvtdq2ps xmm0, xmm0
  subss    xmm1, xmm0 // A - Trunc(A)

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movss    xmm0, xmm1
end;}

function ModF(const A: TVector2; out B: TIVector2): TVector2; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  {$IF RTLVersion >= 33}
  movlps   xmm0, [A]
  {$ELSE}
  movq     xmm0, A
  {$ENDIF}

  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  mov      [NewFlags], eax
  ldmxcsr  [NewFlags]

  movaps   xmm1, xmm0
  cvtps2dq xmm0, xmm0
  movlps   [B], xmm0  // B = Trunc(A)
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movq     rax, xmm1
end;

function ModF(const A: TVector3; out B: TIVector3): TVector3; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1

  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  mov      [NewFlags], eax
  ldmxcsr  [NewFlags]

  movaps   xmm1, xmm0
  cvtps2dq xmm0, xmm0
  movhlps  xmm2, xmm0
  movq     [B], xmm0  // B = Trunc(A)
  movd     DWORD [B+8], xmm2
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movhlps  xmm0, xmm1
  movq     [Result], xmm1
  movss    DWORD [Result+8], xmm0
end;

function ModF(const A: TVector4; out B: TIVector4): TVector4; assembler;
var
  OldFlags, NewFlags: UInt32;
asm
  movups   xmm0, [A]

  // Set rounding mode to Truncate
  stmxcsr  [OldFlags]
  mov      eax, [OldFlags]
  and      eax, SSE_ROUND_MASK
  or       eax, SSE_ROUND_TRUNC
  mov      [NewFlags], eax
  ldmxcsr  [NewFlags]

  movaps   xmm1, xmm0
  cvtps2dq xmm0, xmm0
  movups   [B], xmm0  // B = Trunc(A)
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)

  // Restore rounding mode
  ldmxcsr  [OldFlags]

  movups   [Result], xmm1
end;

function Min(const A: TVector2; const B: Single): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  {$ELSE}
  movq   xmm0, A
  {$ENDIF}
  shufps xmm1, xmm1, $00 // Replicate B
  minps  xmm0, xmm1
  movq   rax, xmm0
end;

function Min(const A, B: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  movlps xmm1, [B]
  {$ELSE}
  movq   xmm0, A
  movq   xmm1, B
  {$ENDIF}
  minps  xmm0, xmm1
  movq   rax, xmm0
end;

function Min(const A: TVector3; const B: Single): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  shufps   xmm2, xmm2, $00 // Replicate B
  minps    xmm0, xmm2
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Min(const A, B: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [B]
  movss    xmm2, DWORD [B+8]
  movlhps  xmm1, xmm2
  minps    xmm0, xmm1
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Min(const A: TVector4; const B: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, $00 // Replicate B
  minps  xmm0, xmm2
  movups [Result], xmm0
end;

function Min(const A, B: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  minps  xmm0, xmm1
  movups [Result], xmm0
end;

function Max(const A: TVector2; const B: Single): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  {$ELSE}
  movq   xmm0, A
  {$ENDIF}
  shufps xmm1, xmm1, $00 // Replicate B
  maxps  xmm0, xmm1
  movq   rax, xmm0
end;

function Max(const A, B: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  movlps xmm1, [B]
  {$ELSE}
  movq   xmm0, A
  movq   xmm1, B
  {$ENDIF}
  maxps  xmm0, xmm1
  movq   rax, xmm0
end;

function Max(const A: TVector3; const B: Single): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  shufps   xmm2, xmm2, $00 // Replicate B
  maxps    xmm0, xmm2
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Max(const A, B: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [B]
  movss    xmm2, DWORD [B+8]
  movlhps  xmm1, xmm2
  maxps    xmm0, xmm1
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Max(const A: TVector4; const B: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, $00 // Replicate B
  maxps  xmm0, xmm2
  movups [Result], xmm0
end;

function Max(const A, B: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  maxps  xmm0, xmm1
  movups [Result], xmm0
end;

function EnsureRange(const A, AMin, AMax: Single): Single; assembler;
asm
  maxss  xmm0, xmm1
  minss  xmm0, xmm2
end;

function EnsureRange(const A: TVector2; const AMin, AMax: Single): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  {$ELSE}
  movq   xmm0, A
  {$ENDIF}
  shufps xmm1, xmm1, $00 // Replicate AMin
  shufps xmm2, xmm2, $00 // Replicate AMax
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movq   rax, xmm0
end;

function EnsureRange(const A, AMin, AMax: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  movlps xmm1, [AMin]
  movlps xmm2, [AMax]
  {$ELSE}
  movq   xmm0, A
  movq   xmm1, AMin
  movq   xmm2, AMax
  {$ENDIF}
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movq   rax, xmm0
end;

function EnsureRange(const A: TVector3; const AMin, AMax: Single): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  shufps   xmm2, xmm2, $00 // Replicate AMin
  shufps   xmm3, xmm3, $00 // Replicate AMax
  maxps    xmm0, xmm2
  minps    xmm0, xmm3
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function EnsureRange(const A, AMin, AMax: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [AMin]
  movss    xmm2, DWORD [AMin+8]
  movlhps  xmm1, xmm2
  movq     xmm2, [AMax]
  movss    xmm3, DWORD [AMax+8]
  movlhps  xmm2, xmm3
  maxps    xmm0, xmm1
  minps    xmm0, xmm2
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function EnsureRange(const A: TVector4; const AMin, AMax: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, $00 // Replicate AMin
  shufps xmm3, xmm3, $00 // Replicate AMax
  maxps  xmm0, xmm2
  minps  xmm0, xmm3
  movups [Result], xmm0
end;

function EnsureRange(const A, AMin, AMax: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [AMin]
  movups xmm2, [AMax]
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movups [Result], xmm0
end;

function Mix(const A, B: TVector2; const T: Single): TVector2;
begin
  Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T));
end;

function Mix(const A, B, T: TVector2): TVector2;
begin
  Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y));
end;

function Mix(const A, B: TVector3; const T: Single): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [B]
  movss    xmm2, DWORD [B+8]
  movlhps  xmm1, xmm2
  shufps   xmm3, xmm3, $00 // Replicate T
  subps    xmm1, xmm0
  mulps    xmm1, xmm3
  addps    xmm0, xmm1 // A + (T * (B - A))
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Mix(const A, B, T: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [B]
  movss    xmm2, DWORD [B+8]
  movlhps  xmm1, xmm2
  movq     xmm2, [T]
  movss    xmm3, DWORD [T+8]
  movlhps  xmm2, xmm3
  subps    xmm1, xmm0
  mulps    xmm1, xmm2
  addps    xmm0, xmm1 // A + (T * (B - A))
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Mix(const A, B: TVector4; const T: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  shufps xmm3, xmm3, $00 // Replicate T
  subps  xmm1, xmm0
  mulps  xmm1, xmm3
  addps  xmm0, xmm1 // A + (T * (B - A))
  movups [Result], xmm0
end;

function Mix(const A, B, T: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  movups xmm2, [T]
  subps  xmm1, xmm0
  mulps  xmm1, xmm2
  addps  xmm0, xmm1 // A + (T * (B - A))
  movups [Result], xmm0
end;

function Step(const AEdge: Single; const A: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps   xmm1, [A]
  {$ELSE}
  movq     xmm1, A
  {$ENDIF}
  shufps   xmm0, xmm0, $00 // Replicate AEdge
  movlps   xmm2, QWORD [SSE_ONE]
  cmpnltps xmm1, xmm0      // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm2      // (A >= AEdge)? Yes: 1, No: 0
  movq     rax, xmm1
end;

function Step(const AEdge, A: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps   xmm0, [AEdge]
  movlps   xmm1, [A]
  {$ELSE}
  movq     xmm0, AEdge
  movq     xmm1, A
  {$ENDIF}
  movlps   xmm2, QWORD [SSE_ONE]
  cmpnltps xmm1, xmm0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm2 // (A >= AEdge)? Yes: 1, No: 0
  movq     rax, xmm1
end;

function Step(const AEdge: Single; const A: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm2, DWORD [A+8]
  movlhps  xmm0, xmm2
  shufps   xmm1, xmm1, $00 // Replicate AEdge
  movups   xmm2, [SSE_ONE]
  cmpnltps xmm0, xmm1      // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm0, xmm2      // (A >= AEdge)? Yes: 1, No: 0
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function Step(const AEdge, A: TVector3): TVector3; assembler;
asm
  movq     xmm0, [AEdge]
  movss    xmm1, DWORD [AEdge+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [A]
  movss    xmm2, DWORD [A+8]
  movlhps  xmm1, xmm2
  movups   xmm2, [SSE_ONE]
  cmpnltps xmm1, xmm0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm2 // (A >= AEdge)? Yes: 1, No: 0
  movhlps  xmm0, xmm1
  movq     [Result], xmm1
  movss    DWORD [Result+8], xmm0
end;

function Step(const AEdge: Single; const A: TVector4): TVector4; assembler;
asm
  movups   xmm0, [A]
  shufps   xmm1, xmm1, $00 // Replicate AEdge
  movups   xmm2, [SSE_ONE]
  cmpnltps xmm0, xmm1      // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm0, xmm2      // (A >= AEdge)? Yes: 1, No: 0
  movups   [Result], xmm0
end;

function Step(const AEdge, A: TVector4): TVector4;
asm
  movups   xmm0, [AEdge]
  movups   xmm1, [A]
  movups   xmm2, [SSE_ONE]
  cmpnltps xmm1, xmm0 // (A >= AEdge)? Yes: $FFFFFFFF, No: $00000000
  andps    xmm1, xmm2 // (A >= AEdge)? Yes: 1, No: 0
  movups   [Result], xmm1
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector2): TVector2;
begin
  Result.Init(SmoothStep(AEdge0, AEdge1, A.X), SmoothStep(AEdge0, AEdge1, A.Y));
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector2): TVector2;
begin
  Result.Init(SmoothStep(AEdge0.X, AEdge1.X, A.X), SmoothStep(AEdge0.Y, AEdge1.Y, A.Y));
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector3): TVector3;
begin
  Result.Init(SmoothStep(AEdge0, AEdge1, A.X), SmoothStep(AEdge0, AEdge1, A.Y), SmoothStep(AEdge0, AEdge1, A.Z));
end;
{function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [A]
  movss    xmm3, DWORD [A+8]
  movlhps  xmm0, xmm3
  shufps   xmm1, xmm1, $00 // Replicate AEdge0
  shufps   xmm2, xmm2, $00 // Replicate AEdge1
  movaps   xmm3, xmm0
  movaps   xmm4, xmm0
  movaps   xmm5, xmm0
  movups   xmm6, [SSE_ONE]

  cmpnltps xmm3, xmm1 // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
  cmpleps  xmm4, xmm2 // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
  subps    xmm2, xmm1
  movaps   xmm5, xmm4
  subps    xmm0, xmm1
  andnps   xmm5, xmm6 // (A >  AEdge1)? Yes: 1.0, No: 0.0

  movups   xmm6, [SSE_TWO]
  divps    xmm0, xmm2 // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movups   xmm7, [SSE_THREE]
  mulps    xmm6, xmm0 // 2 * Temp
  subps    xmm7, xmm6 // 3 - (2 * Temp)
  mulps    xmm7, xmm0
  mulps    xmm7, xmm0 // Result := Temp * Temp * (3 - (2 * Temp))
  andps    xmm7, xmm3 // (A < AEdge0)? Yes: 0, No: Result
  andps    xmm7, xmm4 // (A > AEdge1)? Yes: 0, No: Result
  orps     xmm7, xmm5 // (A > AEdge1)? Yes: 1, No: Result

  movhlps  xmm6, xmm7
  movq     [Result], xmm7
  movss    DWORD [Result+8], xmm6

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;}

function SmoothStep(const AEdge0, AEdge1, A: TVector3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm2, [A]
  movss    xmm3, DWORD [A+8]
  movlhps  xmm2, xmm3
  movq     xmm0, [AEdge0]
  movss    xmm1, DWORD [AEdge0+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [AEdge1]
  movss    xmm3, DWORD [AEdge1+8]
  movlhps  xmm1, xmm3

  movaps   xmm3, xmm2
  movaps   xmm4, xmm2
  movaps   xmm5, xmm2
  movups   xmm6, [SSE_ONE]

  cmpnltps xmm3, xmm0 // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
  cmpleps  xmm4, xmm1 // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
  subps    xmm1, xmm0
  movaps   xmm5, xmm4
  subps    xmm2, xmm0
  andnps   xmm5, xmm6 // (A >  AEdge1)? Yes: 1.0, No: 0.0

  movups   xmm6, [SSE_TWO]
  divps    xmm2, xmm1 // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movups   xmm7, [SSE_THREE]
  mulps    xmm6, xmm2 // 2 * Temp
  subps    xmm7, xmm6 // 3 - (2 * Temp)
  mulps    xmm7, xmm2
  mulps    xmm7, xmm2 // Result := Temp * Temp * (3 - (2 * Temp))
  andps    xmm7, xmm3 // (A < AEdge0)? Yes: 0, No: Result
  andps    xmm7, xmm4 // (A > AEdge1)? Yes: 0, No: Result
  orps     xmm7, xmm5 // (A > AEdge1)? Yes: 1, No: Result

  movhlps  xmm6, xmm7
  movq     [Result], xmm7
  movss    DWORD [Result+8], xmm6

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function SmoothStep(const AEdge0, AEdge1: Single; const A: TVector4): TVector4;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [A]
  shufps   xmm1, xmm1, $00 // Replicate AEdge0
  shufps   xmm2, xmm2, $00 // Replicate AEdge1
  movaps   xmm3, xmm0
  movaps   xmm4, xmm0
  movaps   xmm5, xmm0
  movups   xmm6, [SSE_ONE]

  cmpnltps xmm3, xmm1 // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
  cmpleps  xmm4, xmm2 // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
  subps    xmm2, xmm1
  movaps   xmm5, xmm4
  subps    xmm0, xmm1
  andnps   xmm5, xmm6 // (A >  AEdge1)? Yes: 1.0, No: 0.0

  movups   xmm6, [SSE_TWO]
  divps    xmm0, xmm2 // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movups   xmm7, [SSE_THREE]
  mulps    xmm6, xmm0 // 2 * Temp
  subps    xmm7, xmm6 // 3 - (2 * Temp)
  mulps    xmm7, xmm0
  mulps    xmm7, xmm0 // Result := Temp * Temp * (3 - (2 * Temp))
  andps    xmm7, xmm3 // (A < AEdge0)? Yes: 0, No: Result
  andps    xmm7, xmm4 // (A > AEdge1)? Yes: 0, No: Result
  orps     xmm7, xmm5 // (A > AEdge1)? Yes: 1, No: Result

  movups   [Result], xmm7

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function SmoothStep(const AEdge0, AEdge1, A: TVector4): TVector4; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm2, [A]
  movups   xmm0, [AEdge0]
  movups   xmm1, [AEdge1]
  movaps   xmm3, xmm2
  movaps   xmm4, xmm2
  movaps   xmm5, xmm2
  movups   xmm6, [SSE_ONE]

  cmpnltps xmm3, xmm0 // (A >= AEdge0)? Yes: $FFFFFFFF, No: $00000000
  cmpleps  xmm4, xmm1 // (A <= AEdge1)? Yes: $FFFFFFFF, No: $00000000
  subps    xmm1, xmm0
  movaps   xmm5, xmm4
  subps    xmm2, xmm0
  andnps   xmm5, xmm6 // (A >  AEdge1)? Yes: 1.0, No: 0.0

  movups   xmm6, [SSE_TWO]
  divps    xmm2, xmm1 // Temp := (A - AEdge0) / (AEdge1 - AEdge0)
  movups   xmm7, [SSE_THREE]
  mulps    xmm6, xmm2 // 2 * Temp
  subps    xmm7, xmm6 // 3 - (2 * Temp)
  mulps    xmm7, xmm2
  mulps    xmm7, xmm2 // Result := Temp * Temp * (3 - (2 * Temp))
  andps    xmm7, xmm3 // (A < AEdge0)? Yes: 0, No: Result
  andps    xmm7, xmm4 // (A > AEdge1)? Yes: 0, No: Result
  orps     xmm7, xmm5 // (A > AEdge1)? Yes: 1, No: Result

  movups   [Result], xmm7

  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

function FMA(const A, B, C: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  movlps xmm1, [B]
  movlps xmm2, [C]
  {$ELSE}
  movq   xmm0, A
  movq   xmm1, B
  movq   xmm2, C
  {$ENDIF}
  mulps  xmm0, xmm1
  addps  xmm0, xmm2
  movq   rax, xmm0
end;

function FMA(const A, B, C: TVector3): TVector3; assembler;
asm
  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [B]
  movss    xmm2, DWORD [B+8]
  movlhps  xmm1, xmm2
  movq     xmm2, [C]
  movss    xmm3, DWORD [C+8]
  movlhps  xmm2, xmm3
  mulps    xmm0, xmm1
  addps    xmm0, xmm2
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1
end;

function FMA(const A, B, C: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  movups xmm2, [C]
  mulps  xmm0, xmm1
  addps  xmm0, xmm2
  movups [Result], xmm0
end;

{ Matrix functions }

{$IFDEF FM_COLUMN_MAJOR}
function OuterProduct(const C, R: TVector2): TMatrix2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [R]     // # # C.Y C.X
  movlps xmm1, [C]     // # # R.Y R.X
  {$ELSE}
  movq   xmm0, R       // # # C.Y C.X
  movq   xmm1, C       // # # R.Y R.X
  {$ENDIF}

  shufps xmm0, xmm0, $50 // C.Y C.X C.Y C.X
  shufps xmm1, xmm1, $44 // R.Y R.Y R.X R.X

  mulps  xmm1, xmm0      // (C.Y*R.Y) (C.X*R.Y) (C.Y*R.X) (C.X*R.X)

  // Store as matrix
  movups [Result], xmm1
end;

function OuterProduct(const C, R: TVector3): TMatrix3; assembler;
asm
  movq     xmm0, [C]
  movss    xmm1, DWORD [C+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [R]
  movss    xmm2, DWORD [R+8]
  movlhps  xmm1, xmm2
  movaps   xmm2, xmm1
  movaps   xmm3, xmm1

  shufps   xmm1, xmm1, $00 // C.X (4x)
  shufps   xmm2, xmm2, $55 // C.Y (4x)
  shufps   xmm3, xmm3, $AA // C.Z (4x)

  mulps    xmm1, xmm0      // R * C.X
  mulps    xmm2, xmm0      // R * C.Y
  mulps    xmm3, xmm0      // R * C.Z

  // Store as matrix
  movhlps  xmm0, xmm1
  movhlps  xmm4, xmm2
  movhlps  xmm5, xmm3
  movq     [Result+$00], xmm1
  movss    DWORD [Result+$08], xmm0
  movq     [Result+$0C], xmm2
  movss    DWORD [Result+$14], xmm4
  movq     [Result+$18], xmm3
  movss    DWORD [Result+$20], xmm5
end;

function OuterProduct(const C, R: TVector4): TMatrix4; assembler;
asm
  movups xmm0, [C]
  movups xmm1, [R]
  movaps xmm2, xmm1
  movaps xmm3, xmm1
  movaps xmm4, xmm1

  shufps xmm1, xmm1, $00 // C.X (4x)
  shufps xmm2, xmm2, $55 // C.Y (4x)
  shufps xmm3, xmm3, $AA // C.Z (4x)
  shufps xmm4, xmm4, $FF // C.W (4x)

  mulps  xmm1, xmm0      // R * C.X
  mulps  xmm2, xmm0      // R * C.Y
  mulps  xmm3, xmm0      // R * C.Z
  mulps  xmm4, xmm0      // R * C.W

  // Store as matrix
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm2
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;
{$ELSE}
function OuterProduct(const C, R: TVector2): TMatrix2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [C]     // # # C.Y C.X
  movlps xmm1, [R]     // # # R.Y R.X
  {$ELSE}
  movq   xmm0, C       // # # C.Y C.X
  movq   xmm1, R       // # # R.Y R.X
  {$ENDIF}

  shufps xmm0, xmm0, $50 // C.Y C.X C.Y C.X
  shufps xmm1, xmm1, $44 // R.Y R.Y R.X R.X

  mulps  xmm1, xmm0      // (C.Y*R.Y) (C.X*R.Y) (C.Y*R.X) (C.X*R.X)

  // Store as matrix
  movups [Result], xmm1
end;

function OuterProduct(const C, R: TVector3): TMatrix3; assembler;
asm
  movq     xmm0, [R]
  movss    xmm1, DWORD [R+8]
  movlhps  xmm0, xmm1
  movq     xmm1, [C]
  movss    xmm2, DWORD [C+8]
  movlhps  xmm1, xmm2
  movaps   xmm2, xmm1
  movaps   xmm3, xmm1

  shufps   xmm1, xmm1, $00 // C.X (4x)
  shufps   xmm2, xmm2, $55 // C.Y (4x)
  shufps   xmm3, xmm3, $AA // C.Z (4x)

  mulps    xmm1, xmm0      // R * C.X
  mulps    xmm2, xmm0      // R * C.Y
  mulps    xmm3, xmm0      // R * C.Z

  // Store as matrix
  movhlps  xmm0, xmm1
  movhlps  xmm4, xmm2
  movhlps  xmm5, xmm3
  movq     [Result+$00], xmm1
  movss    DWORD [Result+$08], xmm0
  movq     [Result+$0C], xmm2
  movss    DWORD [Result+$14], xmm4
  movq     [Result+$18], xmm3
  movss    DWORD [Result+$20], xmm5
end;

function OuterProduct(const C, R: TVector4): TMatrix4; assembler;
asm
  movups xmm0, [R]
  movups xmm1, [C]
  movaps xmm2, xmm1
  movaps xmm3, xmm1
  movaps xmm4, xmm1

  shufps xmm1, xmm1, $00 // C.X (4x)
  shufps xmm2, xmm2, $55 // C.Y (4x)
  shufps xmm3, xmm3, $AA // C.Z (4x)
  shufps xmm4, xmm4, $FF // C.W (4x)

  mulps  xmm1, xmm0      // R * C.X
  mulps  xmm2, xmm0      // R * C.Y
  mulps  xmm3, xmm0      // R * C.Z
  mulps  xmm4, xmm0      // R * C.W

  // Store as matrix
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm2
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;
{$ENDIF}

{ TVector2 }

class operator TVector2.Add(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TVector2.Add(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
end;

class operator TVector2.Add(const A, B: TVector2): TVector2;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

function TVector2.Distance(const AOther: TVector2): Single;
begin
  Result := (Self - AOther).Length;
end;

function TVector2.DistanceSquared(const AOther: TVector2): Single;
begin
  Result := (Self - AOther).LengthSquared;
end;

class operator TVector2.Divide(const A: TVector2; const B: Single): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  {$ELSE}
  movq   xmm0, A
  {$ENDIF}
  shufps xmm1, xmm1, 0
  divps  xmm0, xmm1
  movq   rax, xmm0
end;

class operator TVector2.Divide(const A: Single; const B: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm1, [B]
  {$ELSE}
  movq   xmm1, B
  {$ENDIF}
  shufps xmm0, xmm0, 0
  divps  xmm0, xmm1
  movq   rax, xmm0
end;

class operator TVector2.Divide(const A, B: TVector2): TVector2; assembler;
asm
  {$IF RTLVersion >= 33}
  movlps xmm0, [A]
  movlps xmm1, [B]
  {$ELSE}
  movq   xmm0, A
  movq   xmm1, B
  {$ENDIF}
  divps  xmm0, xmm1
  movq   rax, xmm0
end;

function TVector2.Dot(const AOther: TVector2): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y);
end;

function TVector2.FaceForward(const I, NRef: TVector2): TVector2;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

function TVector2.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function TVector2.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

class operator TVector2.Multiply(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TVector2.Multiply(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
end;

class operator TVector2.Multiply(const A, B: TVector2): TVector2;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

function TVector2.NormalizeFast: TVector2; assembler;
asm
  movlps  xmm0, [Self]    // Y X
  movaps  xmm2, xmm0
  mulps   xmm0, xmm0      // Y*Y X*X
  pshufd  xmm1, xmm0, $01 // X*X Y*Y
  addps   xmm0, xmm1      // (X*X+Y*Y) (2x)
  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movq    rax, xmm0
end;

function TVector2.Reflect(const N: TVector2): TVector2;
begin
  Result := Self - ((2 * N.Dot(Self)) * N);
end;

function TVector2.Refract(const N: TVector2; const Eta: Single): TVector2;
var
  D, K: Single;
begin
  D := N.Dot(Self);
  K := 1 - Eta * Eta * (1 - D * D);
  if (K < 0) then
    Result.Init
  else
    Result := (Eta * Self) - ((Eta * D + Sqrt(K)) * N);
end;

procedure TVector2.SetNormalizedFast; assembler;
asm
  movlps  xmm0, [Self]    // Y X
  movaps  xmm2, xmm0
  mulps   xmm0, xmm0      // Y*Y X*X
  pshufd  xmm1, xmm0, $01 // X*X Y*Y
  addps   xmm0, xmm1      // (X*X+Y*Y) (2x)
  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movlps  [Self], xmm0
end;

class operator TVector2.Subtract(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TVector2.Subtract(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
end;

class operator TVector2.Subtract(const A, B: TVector2): TVector2;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

{ TVector3 }

class operator TVector3.Add(const A: TVector3; const B: Single): TVector3; assembler;
asm
  movq   xmm0, [A]      // Load 3 floating-point values
  movss  xmm1, DWORD [A+8]
  shufps xmm2, xmm2, 0  // Replicate B
  addps  xmm0, xmm2     // A + B
  addss  xmm1, xmm2
  movq   [Result], xmm0 // Store result
  movss  DWORD [Result+8], xmm1
end;

class operator TVector3.Add(const A: Single; const B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [B]
  movss  xmm2, DWORD [B+8]
  shufps xmm1, xmm1, 0
  addps  xmm0, xmm1
  addss  xmm2, xmm1
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm2
end;

class operator TVector3.Add(const A, B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  movq   xmm2, [B]
  movss  xmm3, DWORD [B+8]
  addps  xmm0, xmm2
  addss  xmm1, xmm3
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;

function TVector3.Distance(const AOther: TVector3): Single; assembler;
asm
  movq    xmm0, [Self]
  movss   xmm1, DWORD [Self+8]
  movq    xmm2, [AOther]
  movss   xmm3, DWORD [AOther+8]
  movlhps xmm0, xmm1
  movlhps xmm2, xmm3
  subps   xmm0, xmm2 // A - B

  // (A - B).Length
  mulps   xmm0, xmm0
  pshufd  xmm1, xmm0, $0E
  addps   xmm0, xmm1
  pshufd  xmm1, xmm0, $01
  addss   xmm0, xmm1
  sqrtss  xmm0, xmm0
end;

function TVector3.DistanceSquared(const AOther: TVector3): Single; assembler;
asm
  movq    xmm0, [Self]
  movss   xmm1, DWORD [Self+8]
  movq    xmm2, [AOther]
  movss   xmm3, DWORD [AOther+8]
  movlhps xmm0, xmm1
  movlhps xmm2, xmm3
  subps   xmm0, xmm2 // A - B

  // (A - B).Length
  mulps   xmm0, xmm0
  pshufd  xmm1, xmm0, $0E
  addps   xmm0, xmm1
  pshufd  xmm1, xmm0, $01
  addss   xmm0, xmm1
end;

class operator TVector3.Divide(const A: TVector3; const B: Single): TVector3;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.X := A.X * InvB;
  Result.Y := A.Y * InvB;
  Result.Z := A.Z * InvB;
end;
{class operator TVector3.Divide(const A: TVector3; const B: Single): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  shufps xmm2, xmm2, 0
  divps  xmm0, xmm2
  divss  xmm1, xmm2
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;}

class operator TVector3.Divide(const A: Single; const B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [B]
  movss  xmm2, DWORD [B+8]
  movss  xmm3, xmm1
  shufps xmm1, xmm1, 0
  divps  xmm1, xmm0
  divss  xmm3, xmm2
  movq   [Result], xmm1
  movss  DWORD [Result+8], xmm3
end;

class operator TVector3.Divide(const A, B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  movq   xmm2, [B]
  movss  xmm3, DWORD [B+8]
  divps  xmm0, xmm2
  divss  xmm1, xmm3
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;

function TVector3.Cross(const AOther: TVector3): TVector3;
begin
  Result.X := (Y * AOther.Z) - (AOther.Y * Z);
  Result.Y := (Z * AOther.X) - (AOther.Z * X);
  Result.Z := (X * AOther.Y) - (AOther.X * Y);
end;

function TVector3.Dot(const AOther: TVector3): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z);
end;

function TVector3.FaceForward(const I, NRef: TVector3): TVector3; assembler;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

function TVector3.GetLength: Single; assembler;
asm
  movq    xmm0, [Self]    // 0 0 Y X
  movss   xmm1, DWORD [Self+8]  // 0 0 0 Z
  movlhps xmm0, xmm1      // 0 Z Y Z
  mulps   xmm0, xmm0      //  0  Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $0E // Y*Y X*X  0  Z*Z
  addps   xmm0, xmm1      //     #         #     (Y*Y)     (X*X+Z*Z)
  pshufd  xmm1, xmm0, $01 // (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y)
  addss   xmm0, xmm1      // (X*X + Y*Y + Z*Z)
  sqrtss  xmm0, xmm0      // Sqrt(X*X + Y*Y + Z*Z)
end;

function TVector3.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z);
end;
{function TVector3.GetLengthSquared: Single; assembler;
asm
  movq    xmm0, [Self]    // 0 0 Y X
  movss   xmm1, DWORD [Self+8]  // 0 0 0 Z
  movlhps xmm0, xmm1      // 0 Z Y Z
  mulps   xmm0, xmm0      //  0  Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $0E // Y*Y X*X  0  Z*Z
  addps   xmm0, xmm1      //     #         #     (Y*Y)     (X*X+Z*Z)
  pshufd  xmm1, xmm0, $01 // (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y)
  addss   xmm0, xmm1      // (X*X + Y*Y + Z*Z)
end;}

class operator TVector3.Multiply(const A: TVector3; const B: Single): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  shufps xmm2, xmm2, 0
  mulps  xmm0, xmm2
  mulss  xmm1, xmm2
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;

class operator TVector3.Multiply(const A: Single; const B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [B]
  movss  xmm2, DWORD [B+8]
  shufps xmm1, xmm1, 0
  mulps  xmm0, xmm1
  mulss  xmm2, xmm1
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm2
end;

class operator TVector3.Multiply(const A, B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  movq   xmm2, [B]
  movss  xmm3, DWORD [B+8]
  mulps  xmm0, xmm2
  mulss  xmm1, xmm3
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;

class operator TVector3.Negative(const A: TVector3): TVector3;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
end;
{class operator TVector3.Negative(const A: TVector3): TVector3; assembler;
asm
  movups xmm0, [SSE_MASK_SIGN] // Load mask with 4 sign (upper) bits
  movq   xmm1, [A]
  movss  xmm2, DWORD [A+8]
  xorps  xmm1, xmm0            // Flip sign bit
  xorps  xmm2, xmm0
  movq   [Result], xmm1
  movss  DWORD [Result+8], xmm2
end;}

function TVector3.NormalizeFast: TVector3; assembler;
asm
  movq    xmm0, [Self]    // 0 0 Y X
  movss   xmm1, DWORD [Self+8]  // 0 0 0 Z
  movlhps xmm0, xmm1      // 0 Z Y Z
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0      //  0  Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $4E // Y*Y X*X  0  Z*Z
  addps   xmm0, xmm1      //   (Y*Y) (X*X+Z*Z) (Y*Y) (X*X+Z*Z)
  pshufd  xmm1, xmm0, $11 // (X*X+Z*Z) (Y*Y) (X*X+Z*Z) (Y*Y)
  addps   xmm0, xmm1      // (X*X + Y*Y + Z*Z) (4x)

  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y + Z*Z)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movhlps xmm1, xmm0
  movq    [Result], xmm0
  movss   DWORD [Result+8], xmm1
end;

function TVector3.Reflect(const N: TVector3): TVector3; assembler;
asm
  movq     xmm0, [Self]
  movss    xmm2, DWORD [Self+8]
  movq     xmm1, [N]
  movss    xmm3, DWORD [N+8]
  movlhps  xmm0, xmm2
  movlhps  xmm1, xmm3
  movaps   xmm2, xmm0
  movups   xmm3, [SSE_TWO]

  // Dot(N, I)
  mulps    xmm0, xmm1
  mulps    xmm3, xmm1 // N * 2
  pshufd   xmm1, xmm0, $4E
  addps    xmm0, xmm1
  pshufd   xmm1, xmm0, $11
  addps    xmm0, xmm1

  // (2 * Dot(N, I)) * N
  mulps    xmm0, xmm3

  // I - ((2 * Dot(N, I)) * N)
  subps    xmm2, xmm0
  movhlps  xmm3, xmm2
  movq     [Result], xmm2
  movss    DWORD [Result+8], xmm3
end;

function TVector3.Refract(const N: TVector3; const Eta: Single): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movq     xmm0, [Self]
  movss    xmm2, DWORD [Self+8]
  movq     xmm1, [N]
  movss    xmm4, DWORD [N+8]
  movlhps  xmm0, xmm2
  movlhps  xmm1, xmm4
  movups   xmm7, xmm0
  movss    xmm2, DWORD [SSE_ONE]

  // D := Dot(N, I)
  mulps    xmm0, xmm1
  movss    xmm4, xmm2 // 1
  pshufd   xmm1, xmm0, $4E
  movss    xmm5, xmm3 // Eta
  addps    xmm0, xmm1
  mulss    xmm5, xmm5 // Eta * Eta
  pshufd   xmm1, xmm0, $11
  addss    xmm0, xmm1

  // K := 1 - Eta * Eta * (1 - D * D)
  movss    xmm6, xmm0  // D
  mulss    xmm0, xmm0  // D * D
  subss    xmm4, xmm0  // 1 - D * D
  mulss    xmm4, xmm5  // Eta * Eta * (1 - D * D)
  xorps    xmm5, xmm5  // 0
  subss    xmm2, xmm4  // K := 1 - Eta * Eta * (1 - D * D)

  // if (K < 0) then
  comiss   xmm2, xmm5

  jb       @KLessThanZero

  // K >= 0
  mulss    xmm6, xmm3    // Eta * D
  shufps   xmm3, xmm3, 0 // Replicate Eta (4x)
  mulps    xmm7, xmm3    // Eta * I
  sqrtss   xmm2, xmm2    // Sqrt(K)
  addss    xmm6, xmm2    // Eta * D + Sqrt(K)
  shufps   xmm6, xmm6, 0 // Replicate Eta * D + Sqrt(K) (4x)
  movups   xmm1, [N]
  mulps    xmm6, xmm1    // ((Eta * D + Sqrt(K)) * N)
  subps    xmm7, xmm6    // (Eta * I) - ((Eta * D + Sqrt(K)) * N)
  movhlps  xmm0, xmm7
  movq     [Result], xmm7
  movss    DWORD [Result+8], xmm0
  jmp      @Finish

@KLessThanZero:
  // K < 0: Result := Vector4(0, 0, 0, 0)
  movlhps  xmm6, xmm5
  movq     [Result], xmm5
  movss    DWORD [Result+8], xmm6

@Finish:
  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

procedure TVector3.SetNormalizedFast; assembler;
asm
  movq    xmm0, [Self]    // 0 0 Y X
  movss   xmm1, DWORD [Self+8]  // 0 0 0 Z
  movlhps xmm0, xmm1      // 0 Z Y Z
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0      //  0  Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $4E // Y*Y X*X  0  Z*Z
  addps   xmm0, xmm1      //   (Y*Y) (X*X+Z*Z) (Y*Y) (X*X+Z*Z)
  pshufd  xmm1, xmm0, $11 // (X*X+Z*Z) (Y*Y) (X*X+Z*Z) (Y*Y)
  addps   xmm0, xmm1      // (X*X + Y*Y + Z*Z) (4x)

  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y + Z*Z)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movhlps xmm1, xmm0
  movq    [Self], xmm0
  movss   DWORD [Self+8], xmm1
end;

class operator TVector3.Subtract(const A: TVector3; const B: Single): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  shufps xmm2, xmm2, 0
  subps  xmm0, xmm2
  subss  xmm1, xmm2
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;

class operator TVector3.Subtract(const A: Single; const B: TVector3): TVector3; assembler;
asm
  movq   xmm4, [B]
  movss  xmm2, DWORD [B+8]
  movss  xmm3, xmm1
  shufps xmm1, xmm1, 0
  subps  xmm1, xmm4
  subss  xmm3, xmm2
  movq   [Result], xmm1
  movss  DWORD [Result+8], xmm3
end;

class operator TVector3.Subtract(const A, B: TVector3): TVector3; assembler;
asm
  movq   xmm0, [A]
  movss  xmm1, DWORD [A+8]
  movq   xmm2, [B]
  movss  xmm3, DWORD [B+8]
  subps  xmm0, xmm2
  subss  xmm1, xmm3
  movq   [Result], xmm0
  movss  DWORD [Result+8], xmm1
end;

{ TVector4 }

class operator TVector4.Add(const A: TVector4; const B: Single): TVector4; assembler;
asm
  movups xmm0, [A]      // Load 4 floating-point values
  shufps xmm2, xmm2, 0  // Replicate B
  addps  xmm0, xmm2     // A + B
  movups [Result], xmm0 // Store result
end;

class operator TVector4.Add(const A: Single; const B: TVector4): TVector4; assembler;
asm
  movups xmm0, [B]
  shufps xmm1, xmm1, 0
  addps  xmm0, xmm1
  movups [Result], xmm0
end;

class operator TVector4.Add(const A, B: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  addps  xmm0, xmm1
  movups [Result], xmm0
end;

function TVector4.Distance(const AOther: TVector4): Single; assembler;
asm
  movups xmm0, [Self]
  movups xmm1, [AOther]
  subps  xmm0, xmm1 // A - B

  // (A - B).Length
  mulps  xmm0, xmm0
  pshufd xmm1, xmm0, $0E
  addps  xmm0, xmm1
  pshufd xmm1, xmm0, $01
  addss  xmm0, xmm1
  sqrtss xmm0, xmm0
end;

function TVector4.DistanceSquared(const AOther: TVector4): Single; assembler;
asm
  movups xmm0, [Self]
  movups xmm1, [AOther]
  subps  xmm0, xmm1 // A - B

  // (A - B).LengthSquared
  mulps  xmm0, xmm0
  pshufd xmm1, xmm0, $0E
  addps  xmm0, xmm1
  pshufd xmm1, xmm0, $01
  addss  xmm0, xmm1
end;

class operator TVector4.Divide(const A: TVector4; const B: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, 0
  divps  xmm0, xmm2
  movups [Result], xmm0
end;

class operator TVector4.Divide(const A: Single; const B: TVector4): TVector4; assembler;
asm
  movups xmm0, [B]
  shufps xmm1, xmm1, 0
  divps  xmm1, xmm0
  movups [Result], xmm1
end;

class operator TVector4.Divide(const A, B: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  divps  xmm0, xmm1
  movups [Result], xmm0
end;

function TVector4.Dot(const AOther: TVector4): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z) + (W * AOther.W);
end;

function TVector4.FaceForward(const I, NRef: TVector4): TVector4; assembler;
asm
  movups   xmm0, [Self]
  movups   xmm1, [I]
  movups   xmm2, [NRef]
  xorps    xmm3, xmm3 // 0
  movups   xmm4, [SSE_MASK_SIGN]

  // Dot(NRef, I)
  mulps    xmm2, xmm1
  pshufd   xmm1, xmm2, $4E
  addps    xmm2, xmm1
  pshufd   xmm1, xmm2, $11
  addps    xmm2, xmm1

  // Dot(NRef, I) >= 0?  Yes: $FFFFFFFF, No: $00000000
  cmpnltps xmm2, xmm3
  andps    xmm2, xmm4 // Yes: $80000000, No: $00000000

  // Flip sign of N if (Dot(NRef, I) >= 0)
  xorps    xmm0, xmm2
  movups   [Result], xmm0
end;

function TVector4.GetLength: Single; assembler;
asm
  movups xmm0, [Self]    // W Z Y X
  mulps  xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd xmm1, xmm0, $0E // Y*Y X*X W*W Z*Z
  addps  xmm0, xmm1      //     #         #     (Y*Y+W*W) (X*X+Z*Z)
  pshufd xmm1, xmm0, $01 // (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y+W*W)
  addss  xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W)
  sqrtss xmm0, xmm0      // Sqrt(X*X + Y*Y + Z*Z + W*W)
end;

function TVector4.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z) + (W * W);
end;
{function TVector4.GetLengthSquared: Single; assembler;
asm
  movups xmm0, [Self]    // W Z Y X
  mulps  xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd xmm1, xmm0, $0E // Y*Y X*X W*W Z*Z
  addps  xmm0, xmm1      //     #         #     (Y*Y+W*W) (X*X+Z*Z)
  pshufd xmm1, xmm0, $01 // (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y+W*W)
  addss  xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W)
end;}

class operator TVector4.Multiply(const A: TVector4; const B: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, 0
  mulps  xmm0, xmm2
  movups [Result], xmm0
end;

class operator TVector4.Multiply(const A: Single; const B: TVector4): TVector4; assembler;
asm
  movups xmm0, [B]
  shufps xmm1, xmm1, 0
  mulps  xmm1, xmm0
  movups [Result], xmm1
end;

class operator TVector4.Multiply(const A, B: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  mulps  xmm0, xmm1
  movups [Result], xmm0
end;

class operator TVector4.Negative(const A: TVector4): TVector4; assembler;
asm
  movups xmm0, [SSE_MASK_SIGN] // Load mask with 4 sign (upper) bits
  movups xmm1, [A]
  xorps  xmm0, xmm1            // Flip sign bit
  movups [Result], xmm0
end;

function TVector4.NormalizeFast: TVector4;
asm
  movups  xmm0, [Self]    // W Z Y X
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $4E // Y*Y X*X W*W Z*Z
  addps   xmm0, xmm1      // (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z)
  pshufd  xmm1, xmm0, $11 // (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W)
  addps   xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W) (4x)

  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y + Z*Z + W*W)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movups  [Result], xmm0
end;

function TVector4.Reflect(const N: TVector4): TVector4; assembler;
asm
  movups   xmm0, [Self]
  movups   xmm1, [N]
  movaps   xmm2, xmm0
  movups   xmm3, [SSE_TWO]

  // Dot(N, I)
  mulps    xmm0, xmm1
  mulps    xmm3, xmm1 // N * 2
  pshufd   xmm1, xmm0, $4E
  addps    xmm0, xmm1
  pshufd   xmm1, xmm0, $11
  addps    xmm0, xmm1

  // (2 * Dot(N, I)) * N
  mulps    xmm0, xmm3

  // I - ((2 * Dot(N, I)) * N)
  subps    xmm2, xmm0
  movups   [Result], xmm2
end;

function TVector4.Refract(const N: TVector4; const Eta: Single): TVector4; assembler;
asm
  movdqa   [rsp-24], xmm6
  movdqa   [rsp-40], xmm7

  movups   xmm0, [Self]
  movups   xmm1, [N]
  movups   xmm7, xmm0
  movss    xmm2, DWORD [SSE_ONE]

  // D := Dot(N, I)
  mulps    xmm0, xmm1
  movss    xmm4, xmm2 // 1
  pshufd   xmm1, xmm0, $4E
  movss    xmm5, xmm3 // Eta
  addps    xmm0, xmm1
  mulss    xmm5, xmm5 // Eta * Eta
  pshufd   xmm1, xmm0, $11
  addss    xmm0, xmm1

  // K := 1 - Eta * Eta * (1 - D * D)
  movss    xmm6, xmm0  // D
  mulss    xmm0, xmm0  // D * D
  subss    xmm4, xmm0  // 1 - D * D
  mulss    xmm4, xmm5  // Eta * Eta * (1 - D * D)
  xorps    xmm5, xmm5  // 0
  subss    xmm2, xmm4  // K := 1 - Eta * Eta * (1 - D * D)

  // if (K < 0) then
  comiss   xmm2, xmm5

  jb       @KLessThanZero

  // K >= 0
  mulss    xmm6, xmm3    // Eta * D
  shufps   xmm3, xmm3, 0 // Replicate Eta (4x)
  mulps    xmm7, xmm3    // Eta * I
  sqrtss   xmm2, xmm2    // Sqrt(K)
  addss    xmm6, xmm2    // Eta * D + Sqrt(K)
  shufps   xmm6, xmm6, 0 // Replicate Eta * D + Sqrt(K) (4x)
  movups   xmm1, [N]
  mulps    xmm6, xmm1    // ((Eta * D + Sqrt(K)) * N)
  subps    xmm7, xmm6    // (Eta * I) - ((Eta * D + Sqrt(K)) * N)
  movups   [Result], xmm7
  jmp      @Finish

@KLessThanZero:
  // K < 0: Result := Vector4(0, 0, 0, 0)
  movups   [Result], xmm5

@Finish:
  movdqa   xmm6, [rsp-24]
  movdqa   xmm7, [rsp-40]
end;

procedure TVector4.SetNormalizedFast; assembler;
asm
  movups  xmm0, [Self]    // W Z Y X
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $4E // Y*Y X*X W*W Z*Z
  addps   xmm0, xmm1      // (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z)
  pshufd  xmm1, xmm0, $11 // (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W)
  addps   xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W) (4x)

  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y + Z*Z + W*W)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movups  [Self], xmm0
end;

class operator TVector4.Subtract(const A: TVector4; const B: Single): TVector4; assembler;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, 0
  subps  xmm0, xmm2
  movups [Result], xmm0
end;

class operator TVector4.Subtract(const A: Single; const B: TVector4): TVector4; assembler;
asm
  movups xmm0, [B]
  shufps xmm1, xmm1, 0
  subps  xmm1, xmm0
  movups [Result], xmm1
end;

class operator TVector4.Subtract(const A, B: TVector4): TVector4; assembler;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  subps  xmm0, xmm1
  movups [Result], xmm0
end;

{ TQuaternion }

class operator TQuaternion.Add(const A, B: TQuaternion): TQuaternion;
asm
  movups xmm0, [A]
  movups xmm1, [B]
  addps  xmm0, xmm1
  movups [Result], xmm0
end;

function TQuaternion.GetLength: Single;
asm
  movups xmm0, [Self]    // W Z Y X
  mulps  xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd xmm1, xmm0, $0E // Y*Y X*X W*W Z*Z
  addps  xmm0, xmm1      //     #         #     (Y*Y+W*W) (X*X+Z*Z)
  pshufd xmm1, xmm0, $01 // (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y+W*W)
  addss  xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W)
  sqrtss xmm0, xmm0      // Sqrt(X*X + Y*Y + Z*Z + W*W)
end;

function TQuaternion.GetLengthSquared: Single;
asm
  movups xmm0, [Self]    // W Z Y X
  mulps  xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd xmm1, xmm0, $0E // Y*Y X*X W*W Z*Z
  addps  xmm0, xmm1      //     #         #     (Y*Y+W*W) (X*X+Z*Z)
  pshufd xmm1, xmm0, $01 // (X*X+Z*Z) (X*X+Z*Z) (X*X+Z*Z) (Y*Y+W*W)
  addss  xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W)
end;

class operator TQuaternion.Multiply(const A: TQuaternion; const B: Single): TQuaternion;
asm
  movups xmm0, [A]
  shufps xmm2, xmm2, 0
  mulps  xmm0, xmm2
  movups [Result], xmm0
end;

class operator TQuaternion.Multiply(const A: Single; const B: TQuaternion): TQuaternion;
asm
  movups xmm0, [B]
  shufps xmm1, xmm1, 0
  mulps  xmm1, xmm0
  movups [Result], xmm1
end;

class operator TQuaternion.Multiply(const A, B: TQuaternion): TQuaternion;
begin
  Result.X := (A.W * B.X) + (A.X * B.W) + (A.Y * B.Z) - (A.Z * B.Y);
  Result.Y := (A.W * B.Y) + (A.Y * B.W) + (A.Z * B.X) - (A.X * B.Z);
  Result.Z := (A.W * B.Z) + (A.Z * B.W) + (A.X * B.Y) - (A.Y * B.X);
  Result.W := (A.W * B.W) - (A.X * B.X) - (A.Y * B.Y) - (A.Z * B.Z);
end;

function TQuaternion.NormalizeFast: TQuaternion;
asm
  movups  xmm0, [Self]    // W Z Y X
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $4E // Y*Y X*X W*W Z*Z
  addps   xmm0, xmm1      // (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z)
  pshufd  xmm1, xmm0, $11 // (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W)
  addps   xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W) (4x)

  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y + Z*Z + W*W)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movups  [Result], xmm0
end;

procedure TQuaternion.SetNormalizedFast;
asm
  movups  xmm0, [Self]    // W Z Y X
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0      // W*W Z*Z Y*Y X*X
  pshufd  xmm1, xmm0, $4E // Y*Y X*X W*W Z*Z
  addps   xmm0, xmm1      // (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z)
  pshufd  xmm1, xmm0, $11 // (X*X+Z*Z) (Y*Y+W*W) (X*X+Z*Z) (Y*Y+W*W)
  addps   xmm0, xmm1      // (X*X + Y*Y + Z*Z + W*W) (4x)

  rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y + Z*Z + W*W)) (4x)
  mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movups  [Self], xmm0
end;

{ TMatrix 2 }

class operator TMatrix2.Add(const A: TMatrix2; const B: Single): TMatrix2; assembler;
asm
  movups xmm1, [A]              // Load matrix
  shufps xmm2, xmm2, 0          // Replicate B
  addps  xmm1, xmm2             // Add B
  movups [Result], xmm1
end;

class operator TMatrix2.Add(const A: Single; const B: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [B]              // Load matrix
  shufps xmm1, xmm1, 0          // Replicate A
  addps  xmm0, xmm1             // Add A
  movups [Result], xmm0
end;

class operator TMatrix2.Add(const A, B: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [A]   // Load A
  movups xmm1, [B]   // Load B
  addps  xmm0, xmm1  // Add
  movups [Result], xmm0
end;

function TMatrix2.CompMult(const AOther: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [Self]
  movups xmm1, [AOther]

  // Component-wise multiplication
  mulps  xmm0, xmm1

  // Store result
  movups [Result], xmm0
end;

class operator TMatrix2.Divide(const A: TMatrix2; const B: Single): TMatrix2; assembler;
asm
  movups xmm1, [A]              // Load matrix
  shufps xmm2, xmm2, 0          // Replicate B
  divps  xmm1, xmm2             // Divide B
  movups [Result], xmm1
end;

class operator TMatrix2.Divide(const A: Single; const B: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [B]              // Load matrix
  shufps xmm1, xmm1, 0          // Replicate A
  divps  xmm1, xmm0             // Divide B
  movups [Result], xmm1
end;

class operator TMatrix2.Multiply(const A: TMatrix2; const B: Single): TMatrix2; assembler;
asm
  movups xmm1, [A]              // Load matrix
  shufps xmm2, xmm2, 0          // Replicate B
  mulps  xmm1, xmm2             // Multiply
  movups [Result], xmm1
end;

class operator TMatrix2.Multiply(const A: Single; const B: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [B]              // Load matrix
  shufps xmm1, xmm1, 0          // Replicate A
  mulps  xmm0, xmm1             // Multiply
  movups [Result], xmm0
end;

class operator TMatrix2.Multiply(const A: TVector2; const B: TMatrix2): TVector2;
begin
  Result.X := (A.X * B.M[0,0]) + (A.Y * B.M[0,1]);
  Result.Y := (A.X * B.M[1,0]) + (A.Y * B.M[1,1]);
end;

class operator TMatrix2.Multiply(const A: TMatrix2; const B: TVector2): TVector2;
begin
  Result.X := (A.M[0,0] * B.X) + (A.M[1,0] * B.Y);
  Result.Y := (A.M[0,1] * B.X) + (A.M[1,1] * B.Y);
end;

class operator TMatrix2.Multiply(const A, B: TMatrix2): TMatrix2;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[1,0] * B.M[0,1]);
  Result.M[0,1] := (A.M[0,1] * B.M[0,0]) + (A.M[1,1] * B.M[0,1]);
  Result.M[1,0] := (A.M[0,0] * B.M[1,0]) + (A.M[1,0] * B.M[1,1]);
  Result.M[1,1] := (A.M[0,1] * B.M[1,0]) + (A.M[1,1] * B.M[1,1]);
end;

class operator TMatrix2.Negative(const A: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [SSE_MASK_SIGN]  // Load mask with 4 sign (upper) bits
  movups xmm1, [A]              // Load matrix
  xorps  xmm1, xmm0             // Flip sign bits
  movups [Result], xmm1
end;

procedure TMatrix2.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix2.Subtract(const A: TMatrix2; const B: Single): TMatrix2; assembler;
asm
  movups xmm1, [A]              // Load matrix
  shufps xmm2, xmm2, 0          // Replicate B
  subps  xmm1, xmm2             // Subtract B
  movups [Result], xmm1
end;

class operator TMatrix2.Subtract(const A: Single; const B: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [B]              // Load matrix
  shufps xmm1, xmm1, 0          // Replicate A
  subps  xmm1, xmm0             // Subtract B
  movups [Result], xmm1
end;

class operator TMatrix2.Subtract(const A, B: TMatrix2): TMatrix2; assembler;
asm
  movups xmm0, [A]   // Load A
  movups xmm1, [B]   // Load B
  subps  xmm0, xmm1  // Subtract
  movups [Result], xmm0
end;

function TMatrix2.Transpose: TMatrix2;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
end;

{ TMatrix3 }

class operator TMatrix3.Add(const A: TMatrix3; const B: Single): TMatrix3; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 3 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm3, DQWORD [A + $10]
  movss  xmm4, DWORD [A + $20]
  addps  xmm1, xmm2             // Add B to each row
  addps  xmm3, xmm2
  addss  xmm4, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm3
  movss  DWORD [Result + $20], xmm4
end;

class operator TMatrix3.Add(const A: Single; const B: TMatrix3): TMatrix3; assembler;
asm
  movups xmm0, DQWORD [B + $00] // Load 3 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm2, DQWORD [B + $10]
  movss  xmm3, DWORD [B + $20]
  addps  xmm0, xmm1             // Add A to each row
  addps  xmm2, xmm1
  addss  xmm3, xmm1
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm2
  movss  DWORD [Result + $20], xmm3
end;

class operator TMatrix3.Add(const A, B: TMatrix3): TMatrix3; assembler;
asm
  movups xmm0, DQWORD [A + $00] // Load 3 rows of A
  movups xmm1, DQWORD [A + $10]
  movss  xmm2, DWORD [A + $20]
  movups xmm4, DQWORD [B + $00] // Load 3 rows of B
  movups xmm5, DQWORD [B + $10]
  movss  xmm3, DWORD [B + $20]
  addps  xmm0, xmm4             // Add rows
  addps  xmm1, xmm5
  addss  xmm2, xmm3
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm1
  movss  DWORD [Result + $20], xmm2
end;

function TMatrix3.CompMult(const AOther: TMatrix3): TMatrix3; assembler;
asm
  movups xmm0, DQWORD[Self + $00]   // Self[0]
  movups xmm1, DQWORD[Self + $10]   // Self[1]
  movss  xmm2, DWORD[Self + $20]   // Self[2]
  movups xmm4, DQWORD[AOther + $00] // AOther[0]
  movups xmm5, DQWORD[AOther + $10] // AOther[1]
  movss  xmm3, DWORD[AOther + $20] // AOther[2]

  // Component-wise multiplication
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulss  xmm2, xmm3

  // Store result
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm1
  movss  DWORD [Result + $20], xmm2
end;

class operator TMatrix3.Divide(const A: Single; const B: TMatrix3): TMatrix3; assembler;
asm
  movups xmm4, DQWORD [B + $00] // Load 3 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm5, DQWORD [B + $10]
  movaps xmm0, xmm1
  movaps xmm2, xmm1
  movss  xmm3, DWORD [B + $20]
  divps  xmm1, xmm4             // Divide A by each row
  divps  xmm0, xmm5
  divss  xmm2, xmm3
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movss  DWORD [Result + $20], xmm2
end;

class operator TMatrix3.Divide(const A: TMatrix3; const B: Single): TMatrix3; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 3 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movss  xmm3, DWORD [A + $20]
  divps  xmm1, xmm2             // Divide each row by B
  divps  xmm0, xmm2
  divss  xmm3, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movss  DWORD [Result + $20], xmm3
end;

class operator TMatrix3.Multiply(const A: Single; const B: TMatrix3): TMatrix3; assembler;
asm
  movups xmm0, DQWORD [B + $00] // Load 3 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm2, DQWORD [B + $10]
  movss  xmm3, DWORD [B + $20]
  mulps  xmm0, xmm1             // Multiply each row by A
  mulps  xmm2, xmm1
  mulss  xmm3, xmm1
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm2
  movss  DWORD [Result + $20], xmm3
end;

class operator TMatrix3.Multiply(const A: TMatrix3; const B: Single): TMatrix3; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 3 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movss  xmm3, DWORD [A + $20]
  mulps  xmm1, xmm2             // Multiply each row by B
  mulps  xmm0, xmm2
  mulss  xmm3, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movss  DWORD [Result + $20], xmm3
end;

{$IFDEF FM_COLUMN_MAJOR}
class operator TMatrix3.Multiply(const A: TMatrix3; const B: TVector3): TVector3; assembler;
asm
  movdqa  [rsp-24], xmm6

  movq    xmm0, [B]
  movss   xmm1, DWORD [B+8]
  movlhps xmm0, xmm1

  movq    xmm4, QWORD [A + $00]
  movss   xmm1, DWORD [A + $08]
  movlhps xmm4, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA

  movq    xmm5, QWORD [A + $0C]
  movss   xmm3, DWORD [A + $14]
  movlhps xmm5, xmm3

  movq    xmm6, QWORD [A + $18]
  movss   xmm3, DWORD [A + $20]
  movlhps xmm6, xmm3

  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    [Result], xmm0
  movss   DWORD [Result+8], xmm1

  movdqa  xmm6, [rsp-24]
end;

class operator TMatrix3.Multiply(const A: TVector3; const B: TMatrix3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6

  movq     xmm0, [A]
  movss    xmm1, DWORD [A+8]
  movlhps  xmm0, xmm1

  movq     xmm4, QWORD [B + $00]
  movss    xmm1, DWORD [B + $08]
  movlhps  xmm4, xmm1

  movaps   xmm1, xmm0
  movaps   xmm2, xmm0

  movq     xmm5, QWORD [B + $0C]
  movss    xmm6, DWORD [B + $14]
  movlhps  xmm5, xmm6

  movq     xmm6, QWORD [B + $18]
  movss    xmm3, DWORD [B + $20]
  movlhps  xmm6, xmm3

  mulps    xmm0, xmm4
  mulps    xmm1, xmm5
  mulps    xmm2, xmm6
  xorps    xmm3, xmm3

  { Transpose xmm0-xmm2 }
  movaps   xmm4, xmm2
  unpcklps xmm2, xmm3
  unpckhps xmm4, xmm3

  movaps   xmm3, xmm0
  unpcklps xmm0, xmm1
  unpckhps xmm3, xmm1

  movaps   xmm1, xmm0
  unpcklpd xmm0, xmm2
  unpckhpd xmm1, xmm2

  unpcklpd xmm3, xmm4

  addps    xmm0, xmm1
  addps    xmm0, xmm3
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1

  movdqa   xmm6, [rsp-24]
end;

class operator TMatrix3.Multiply(const A, B: TMatrix3): TMatrix3; assembler;
{ Code below consists of 3 Vector*Matrix calculations }
asm
  movdqa  [rsp-24], xmm6

  movq    xmm0, QWORD [B + $00]
  movss   xmm1, DWORD [B + $08]
  movlhps xmm0, xmm1

  movq    xmm4, QWORD [A + $00]
  movss   xmm1, DWORD [A + $08]
  movlhps xmm4, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA

  movq    xmm5, QWORD [A + $0C]
  movss   xmm3, DWORD [A + $14]
  movlhps xmm5, xmm3

  movq    xmm6, QWORD [A + $18]
  movss   xmm3, DWORD [A + $20]
  movlhps xmm6, xmm3

  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    QWORD [Result + $00], xmm0
  movss   DWORD [Result + $08], xmm1

  movq    xmm0, QWORD [B + $0C]
  movss   xmm1, DWORD [B + $14]
  movlhps xmm0, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA
  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    QWORD [Result + $0C], xmm0
  movss   DWORD [Result + $14], xmm1

  movq    xmm0, QWORD [B + $18]
  movss   xmm1, DWORD [B + $20]
  movlhps xmm0, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA
  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    QWORD [Result + $18], xmm0
  movss   DWORD [Result + $20], xmm1

  movdqa  xmm6, [rsp-24]
end;
{$ELSE}
class operator TMatrix3.Multiply(const A: TMatrix3; const B: TVector3): TVector3; assembler;
asm
  movdqa   [rsp-24], xmm6

  movq     xmm0, [B]              // Load vector
  movss    xmm1, DWORD [B+8]
  movlhps  xmm0, xmm1

  movq     xmm4, QWORD [A + $00]  // Load 3 rows
  movss    xmm1, DWORD [A + $08]
  movlhps  xmm4, xmm1

  movaps   xmm1, xmm0
  movaps   xmm2, xmm0

  movq     xmm5, QWORD [A + $0C]
  movss    xmm6, DWORD [A + $14]
  movlhps  xmm5, xmm6

  movq     xmm6, QWORD [A + $18]
  movss    xmm3, DWORD [A + $20]
  movlhps  xmm6, xmm3

  mulps    xmm0, xmm4             // ###, (Az * B02), (Ay * B01), (Ax * B00)
  mulps    xmm1, xmm5             // ###, (Az * B12), (Ay * B11), (Ax * B10)
  mulps    xmm2, xmm6             // ###, (Az * B22), (Ay * B21), (Ax * B20)
  xorps    xmm3, xmm3             // 000

  { Transpose xmm0-xmm2 }
  movaps   xmm4, xmm2
  unpcklps xmm2, xmm3             // 000 B21 000 B20
  unpckhps xmm4, xmm3             // 000 ### 000 B22

  movaps   xmm3, xmm0
  unpcklps xmm0, xmm1             // B11 B01 B10 B00
  unpckhps xmm3, xmm1             // ### ### B12 B02

  movaps   xmm1, xmm0
  unpcklpd xmm0, xmm2             // 000 B20 B10 B00
  unpckhpd xmm1, xmm2             // 000 B21 B11 B01

  unpcklpd xmm3, xmm4             // 000 B22 B12 B02

  addps    xmm0, xmm1             // Add rows
  addps    xmm0, xmm3
  movhlps  xmm1, xmm0
  movq     [Result], xmm0
  movss    DWORD [Result+8], xmm1

  movdqa   xmm6, [rsp-24]
end;

class operator TMatrix3.Multiply(const A: TVector3; const B: TMatrix3): TVector3; assembler;
asm
  movdqa  [rsp-24], xmm6

  movq    xmm0, [A]              // Load vector
  movss   xmm1, DWORD [A+8]
  movlhps xmm0, xmm1

  movq    xmm4, QWORD [B + $00]  // Load 3 rows
  movss   xmm1, DWORD [B + $08]
  movlhps xmm4, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00        // Bx Bx Bx Bx
  shufps  xmm1, xmm1, $55        // By By By By
  shufps  xmm2, xmm2, $AA        // Bz Bz Bz Bz

  movq    xmm5, QWORD [B + $0C]
  movss   xmm3, DWORD [B + $14]
  movlhps xmm5, xmm3

  movq    xmm6, QWORD [B + $18]
  movss   xmm3, DWORD [B + $20]
  movlhps xmm6, xmm3

  mulps   xmm0, xmm4             // (A00 * Bx), (A01 * Bx), (A02 * Bx), #
  mulps   xmm1, xmm5             // (A10 * By), (A11 * By), (A12 * By), #
  mulps   xmm2, xmm6             // (A20 * Bz), (A21 * Bz), (A22 * Bz), #
  addps   xmm0, xmm1             // Add rows
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    [Result], xmm0
  movss   DWORD [Result+8], xmm1

  movdqa  xmm6, [rsp-24]
end;

class operator TMatrix3.Multiply(const A, B: TMatrix3): TMatrix3; assembler;
{ Code below consists of 3 Vector*Matrix calculations }
asm
  movdqa  [rsp-24], xmm6

  { A.R[0] * B }
  movq    xmm0, QWORD [A + $00]
  movss   xmm1, DWORD [A + $08]
  movlhps xmm0, xmm1

  movq    xmm4, QWORD [B + $00]
  movss   xmm1, DWORD [B + $08]
  movlhps xmm4, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA

  movq    xmm5, QWORD [B + $0C]
  movss   xmm3, DWORD [B + $14]
  movlhps xmm5, xmm3

  movq    xmm6, QWORD [B + $18]
  movss   xmm3, DWORD [B + $20]
  movlhps xmm6, xmm3

  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    QWORD [Result + $00], xmm0
  movss   DWORD [Result + $08], xmm1

  { A.R[1] * B }
  movq    xmm0, QWORD [A + $0C]
  movss   xmm1, DWORD [A + $14]
  movlhps xmm0, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA
  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    QWORD [Result + $0C], xmm0
  movss   DWORD [Result + $14], xmm1

  { A.R[2] * B }
  movq    xmm0, QWORD [A + $18]
  movss   xmm1, DWORD [A + $20]
  movlhps xmm0, xmm1

  movaps  xmm1, xmm0
  movaps  xmm2, xmm0
  shufps  xmm0, xmm0, $00
  shufps  xmm1, xmm1, $55
  shufps  xmm2, xmm2, $AA
  mulps   xmm0, xmm4
  mulps   xmm1, xmm5
  mulps   xmm2, xmm6
  addps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
  movq    QWORD [Result + $18], xmm0
  movss   DWORD [Result + $20], xmm1

  movdqa  xmm6, [rsp-24]
end;
{$ENDIF}

class operator TMatrix3.Negative(const A: TMatrix3): TMatrix3; assembler;
asm
  movups xmm0, [SSE_MASK_SIGN]  // Load mask with 4 sign (upper) bits
  movups xmm1, DQWORD [A + $00] // Load 3 rows
  movups xmm2, DQWORD [A + $10]
  movss  xmm3, DWORD [A + $20]
  xorps  xmm1, xmm0             // Flip sign bits of each element in each row
  xorps  xmm2, xmm0
  pxor   xmm3, xmm0
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm2
  movss  DWORD [Result + $20], xmm3
end;

procedure TMatrix3.SetTransposed; assembler;
asm
  movss  xmm0, DWORD [Self + $04]
  movss  xmm1, DWORD [Self + $08]

  movss  xmm2, DWORD [Self + $0C]
  movss  xmm3, DWORD [Self + $14]

  movss  xmm4, DWORD [Self + $18]
  movss  xmm5, DWORD [Self + $1C]

  movss  DWORD [Self + $0C], xmm0
  movss  DWORD [Self + $18], xmm1

  movss  DWORD [Self + $04], xmm2
  movss  DWORD [Self + $1C], xmm3

  movss  DWORD [Self + $08], xmm4
  movss  DWORD [Self + $14], xmm5
end;

class operator TMatrix3.Subtract(const A: TMatrix3; const B: Single): TMatrix3; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 3 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movss  xmm3, DWORD [A + $20]
  subps  xmm1, xmm2             // Subtract B from each row
  subps  xmm0, xmm2
  subss  xmm3, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movss  DWORD [Result + $20], xmm3
end;

class operator TMatrix3.Subtract(const A: Single; const B: TMatrix3): TMatrix3; assembler;
asm
  movups xmm4, DQWORD [B + $00] // Load 3 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm5, DQWORD [B + $10]
  movaps xmm0, xmm1
  movaps xmm2, xmm1
  movss  xmm6, DWORD [B + $20]
  subps  xmm1, xmm4             // Subtract each row from A
  subps  xmm0, xmm5
  subss  xmm2, xmm6
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movss  DWORD [Result + $20], xmm2
end;

class operator TMatrix3.Subtract(const A, B: TMatrix3): TMatrix3; assembler;
asm
  movups xmm0, DQWORD [A + $00] // Load 3 rows of A
  movups xmm1, DQWORD [A + $10]
  movss  xmm2, DWORD [A + $20]
  movups xmm4, DQWORD [B + $00] // Load 3 rows of B
  movups xmm5, DQWORD [B + $10]
  movss  xmm6, DWORD [B + $20]
  subps  xmm0, xmm4             // Subtract rows
  subps  xmm1, xmm5
  subss  xmm2, xmm6
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm1
  movss  DWORD [Result + $20], xmm2
end;

function TMatrix3.Transpose: TMatrix3; assembler;
asm
  movss xmm0, DWORD [Self + $00]
  movss xmm1, DWORD [Self + $04]
  movss xmm2, DWORD [Self + $08]

  movss DWORD [Result + $00], xmm0
  movss DWORD [Result + $0C], xmm1
  movss DWORD [Result + $18], xmm2

  movss xmm0, DWORD [Self + $0C]
  movss xmm1, DWORD [Self + $10]
  movss xmm2, DWORD [Self + $14]

  movss DWORD [Result + $04], xmm0
  movss DWORD [Result + $10], xmm1
  movss DWORD [Result + $1C], xmm2

  movss xmm0, DWORD [Self + $18]
  movss xmm1, DWORD [Self + $1C]
  movss xmm2, DWORD [Self + $20]

  movss DWORD [Result + $08], xmm0
  movss DWORD [Result + $14], xmm1
  movss DWORD [Result + $20], xmm2
end;

{ TMatrix 4 }

class operator TMatrix4.Add(const A: TMatrix4; const B: Single): TMatrix4; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 4 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movups xmm3, DQWORD [A + $20]
  movups xmm4, DQWORD [A + $30]
  addps  xmm1, xmm2             // Add B to each row
  addps  xmm0, xmm2
  addps  xmm3, xmm2
  addps  xmm4, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

class operator TMatrix4.Add(const A: Single; const B: TMatrix4): TMatrix4; assembler;
asm
  movups xmm0, DQWORD [B + $00] // Load 4 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm2, DQWORD [B + $10]
  movups xmm3, DQWORD [B + $20]
  movups xmm4, DQWORD [B + $30]
  addps  xmm0, xmm1             // Add A to each row
  addps  xmm2, xmm1
  addps  xmm3, xmm1
  addps  xmm4, xmm1
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm2
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

class operator TMatrix4.Add(const A, B: TMatrix4): TMatrix4; assembler;
asm
  movups xmm0, DQWORD [A + $00] // Load 4 rows of A
  movups xmm1, DQWORD [A + $10]
  movups xmm2, DQWORD [A + $20]
  movups xmm3, DQWORD [A + $30]
  movups xmm4, DQWORD [B + $00] // Load 2 rows of B
  movups xmm5, DQWORD [B + $10]
  addps  xmm0, xmm4             // Add rows
  addps  xmm1, xmm5
  movups xmm4, DQWORD [B + $20] // Load 2 rows of B
  movups xmm5, DQWORD [B + $30]
  addps  xmm2, xmm4             // Add rows
  addps  xmm3, xmm5
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm1
  movups DQWORD [Result + $20], xmm2
  movups DQWORD [Result + $30], xmm3
end;

function TMatrix4.CompMult(const AOther: TMatrix4): TMatrix4; assembler;
asm
  movups xmm0, DQWORD[Self + $00]   // Self[0]
  movups xmm1, DQWORD[Self + $10]   // Self[1]
  movups xmm2, DQWORD[Self + $20]   // Self[2]
  movups xmm3, DQWORD[Self + $30]   // Self[3]
  movups xmm4, DQWORD[AOther + $00] // AOther[0]
  movups xmm5, DQWORD[AOther + $10] // AOther[1]

  // Component-wise multiplication
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  movups xmm4, DQWORD[AOther + $20] // AOther[2]
  movups xmm5, DQWORD[AOther + $30] // AOther[3]
  mulps  xmm2, xmm4
  mulps  xmm3, xmm5

  // Store result
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm1
  movups DQWORD [Result + $20], xmm2
  movups DQWORD [Result + $30], xmm3
end;

class operator TMatrix4.Divide(const A: Single; const B: TMatrix4): TMatrix4; assembler;
asm
  movups xmm4, DQWORD [B + $00] // Load 4 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm5, DQWORD [B + $10]
  movaps xmm0, xmm1
  movaps xmm2, xmm1
  movaps xmm3, xmm1
  divps  xmm1, xmm4             // Divide A by each row
  divps  xmm0, xmm5
  movups xmm4, DQWORD [B + $20]
  movups xmm5, DQWORD [B + $30]
  divps  xmm2, xmm4
  divps  xmm3, xmm5
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movups DQWORD [Result + $20], xmm2
  movups DQWORD [Result + $30], xmm3
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: Single): TMatrix4; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 4 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movups xmm3, DQWORD [A + $20]
  movups xmm4, DQWORD [A + $30]
  divps  xmm1, xmm2             // Divide each row by B
  divps  xmm0, xmm2             // NOTE: We could speed it up by multiplying by
  divps  xmm3, xmm2             // 1/B instead, using the "rcpps" instruction,
  divps  xmm4, xmm2             // but that instruction is an approximation,
                                // so we lose accuracy.
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

function TMatrix4.Inverse: TMatrix4; assembler;
type
  TStack = record
    case Byte of
      0: (WorkSpace: array [0..7] of TVector4);
      1: (F0, F1, F2, F3, F4, F5, X6, X7: TVector4);
  end;
var
  Stack: TStack;
asm
  movdqa [Stack.X6], xmm6
  movdqa [Stack.X7], xmm6

  movups xmm1, DQWORD[Self + $10] // M[1]
  movups xmm2, DQWORD[Self + $20] // M[2]
  movups xmm3, DQWORD[Self + $30] // M[3]

  //  C00 := (A.M[2,2] * A.M[3,3]) - (A.M[3,2] * A.M[2,3]);
  //  C02 := (A.M[1,2] * A.M[3,3]) - (A.M[3,2] * A.M[1,3]);
  //  C03 := (A.M[1,2] * A.M[2,3]) - (A.M[2,2] * A.M[1,3]);
  //  F0 := Vector4(C00, C00, C02, C03);
  movaps xmm5, xmm2            // M[2]
  movaps xmm7, xmm2            // M[2]
  movaps xmm0, xmm3            // M[3]
  movaps xmm6, xmm3            // M[3]
  shufps xmm6, xmm2, $AA       // M22 M22 M32 M32
  shufps xmm0, xmm2, $FF       // M23 M23 M33 M33
  shufps xmm7, xmm1, $FF       // M13 M13 M23 M23
  pshufd xmm4, xmm0, $80       // M23 M33 M33 M33
  shufps xmm5, xmm1, $AA       // M12 M12 M22 M22
  pshufd xmm0, xmm6, $80       // M22 M32 M32 M32
  mulps  xmm5, xmm4            // (M12 * M23) (M12 * M33) (M22 * M33) (M22 * M33)
  mulps  xmm7, xmm0            // (M22 * M13) (M32 * M13) (M32 * M23) (M32 * M23)
  subps  xmm5, xmm7            // C03=(M12*M23)-(M22*M13), C02=(M12*M33)-(M32*M13), C00=(M22*M33)-(M32*M23), C00=(M22*M33)-(M32*M23)
  movups [Stack.F0], xmm5

  //  C04 := (A.M[2,1] * A.M[3,3]) - (A.M[3,1] * A.M[2,3]);
  //  C06 := (A.M[1,1] * A.M[3,3]) - (A.M[3,1] * A.M[1,3]);
  //  C07 := (A.M[1,1] * A.M[2,3]) - (A.M[2,1] * A.M[1,3]);
  //  F1 := Vector4(C04, C04, C06, C07);
  movaps xmm5, xmm2            // M[2]
  movaps xmm7, xmm2            // M[2]
  movaps xmm0, xmm3            // M[3]
  movaps xmm6, xmm3            // M[3]
  shufps xmm6, xmm2, $55       // M21 M21 M31 M31
  shufps xmm0, xmm2, $FF       // M23 M23 M33 M33
  shufps xmm7, xmm1, $FF       // M13 M13 M23 M23
  pshufd xmm4, xmm0, $80       // M23 M33 M33 M33
  shufps xmm5, xmm1, $55       // M11 M11 M21 M21
  pshufd xmm0, xmm6, $80       // M21 M31 M31 M31
  mulps  xmm5, xmm4            // (M11 * M23) (M11 * M33) (M21 * M33) (M21 * M33)
  mulps  xmm7, xmm0            // (M21 * M13) (M31 * M13) (M31 * M23) (M31 * M23)
  subps  xmm5, xmm7            // C07=(M11*M23)-(M21*M13), C06=(M11*M33)-(M31*M13), C04=(M21*M33)-(M31*M23), C04=(M21*M33)-(M31*M23)
  movups [Stack.F1], xmm5

  //  C08 := (A.M[2,1] * A.M[3,2]) - (A.M[3,1] * A.M[2,2]);
  //  C10 := (A.M[1,1] * A.M[3,2]) - (A.M[3,1] * A.M[1,2]);
  //  C11 := (A.M[1,1] * A.M[2,2]) - (A.M[2,1] * A.M[1,2]);
  //  F2 := Vector4(C08, C08, C10, C11);
  movaps xmm5, xmm2            // M[2]
  movaps xmm7, xmm2            // M[2]
  movaps xmm0, xmm3            // M[3]
  movaps xmm6, xmm3            // M[3]
  shufps xmm6, xmm2, $55       // M21 M21 M31 M31
  shufps xmm0, xmm2, $AA       // M22 M22 M32 M32
  shufps xmm7, xmm1, $AA       // M12 M12 M22 M22
  pshufd xmm4, xmm0, $80       // M22 M32 M32 M32
  shufps xmm5, xmm1, $55       // M11 M11 M21 M21
  pshufd xmm0, xmm6, $80       // M21 M31 M31 M31
  mulps  xmm5, xmm4            // (M11 * M22) (M11 * M32) (M21 * M32) (M21 * M32)
  mulps  xmm7, xmm0            // (M21 * M12) (M31 * M12) (M31 * M22) (M32 * M22)
  subps  xmm5, xmm7            // C11=(M11*M22)-(M21*M12), C10=(M11*M32)-(M31*M12), C08=(M21*M32)-(M31*M22), C08=(M21*M32)-(M31*M22)
  movups [Stack.F2], xmm5

  //  C12 := (A.M[2,0] * A.M[3,3]) - (A.M[3,0] * A.M[2,3]);
  //  C14 := (A.M[1,0] * A.M[3,3]) - (A.M[3,0] * A.M[1,3]);
  //  C15 := (A.M[1,0] * A.M[2,3]) - (A.M[2,0] * A.M[1,3]);
  //  F3 := Vector4(C12, C12, C14, C15);
  movaps xmm5, xmm2            // M[2]
  movaps xmm7, xmm2            // M[2]
  movaps xmm0, xmm3            // M[3]
  movaps xmm6, xmm3            // M[3]
  shufps xmm6, xmm2, $00       // M20 M20 M30 M30
  shufps xmm0, xmm2, $FF       // M23 M23 M33 M33
  shufps xmm7, xmm1, $FF       // M13 M13 M23 M23
  pshufd xmm4, xmm0, $80       // M23 M33 M33 M33
  shufps xmm5, xmm1, $00       // M10 M10 M20 M20
  pshufd xmm0, xmm6, $80       // M20 M30 M30 M30
  mulps  xmm5, xmm4            // (M10 * M23) (M10 * M33) (M20 * M33) (M20 * M33)
  mulps  xmm7, xmm0            // (M20 * M13) (M30 * M13) (M30 * M23) (M30 * M23)
  subps  xmm5, xmm7            // C15=(M10*M23)-(M20*M13), C14=(M10*M33)-(M30*M13), C12=(M20*M33)-(M30*M23), C12=(M20*M33)-(M30*M23)
  movups [Stack.F3], xmm5

  //  C16 := (A.M[2,0] * A.M[3,2]) - (A.M[3,0] * A.M[2,2]);
  //  C18 := (A.M[1,0] * A.M[3,2]) - (A.M[3,0] * A.M[1,2]);
  //  C19 := (A.M[1,0] * A.M[2,2]) - (A.M[2,0] * A.M[1,2]);
  //  F4 := Vector4(C16, C16, C18, C19);
  movaps xmm5, xmm2            // M[2]
  movaps xmm7, xmm2            // M[2]
  movaps xmm0, xmm3            // M[3]
  movaps xmm6, xmm3            // M[3]
  shufps xmm6, xmm2, $00       // M20 M20 M30 M30
  shufps xmm0, xmm2, $AA       // M22 M22 M32 M32
  shufps xmm7, xmm1, $AA       // M12 M12 M22 M22
  pshufd xmm4, xmm0, $80       // M22 M32 M32 M32
  shufps xmm5, xmm1, $00       // M10 M10 M20 M20
  pshufd xmm0, xmm6, $80       // M20 M30 M30 M30
  mulps  xmm5, xmm4            // (M10 * M22) (M10 * M32) (M20 * M32) (M20 * M32)
  mulps  xmm7, xmm0            // (M20 * M12) (M30 * M12) (M30 * M22) (M30 * M22)
  subps  xmm5, xmm7            // C19=(M10*M22)-(M20*M12), C18=(M10*M32)-(M30*M12), C16=(M20*M32)-(M30*M22), C16=(M20*M32)-(M30*M22)
  movups [Stack.F4], xmm5

  //  C20 := (A.M[2,0] * A.M[3,1]) - (A.M[3,0] * A.M[2,1]);
  //  C22 := (A.M[1,0] * A.M[3,1]) - (A.M[3,0] * A.M[1,1]);
  //  C23 := (A.M[1,0] * A.M[2,1]) - (A.M[2,0] * A.M[1,1]);
  //  F5 := Vector4(C20, C20, C22, C23);
  movaps xmm5, xmm2            // M[2]
  movaps xmm7, xmm2            // M[2]
  movaps xmm0, xmm3            // M[3]
  movaps xmm6, xmm3            // M[3]
  shufps xmm6, xmm2, $00       // M20 M20 M30 M30
  shufps xmm0, xmm2, $55       // M21 M21 M31 M31
  shufps xmm7, xmm1, $55       // M11 M11 M21 M21
  pshufd xmm4, xmm0, $80       // M21 M31 M31 M31
  shufps xmm5, xmm1, $00       // M10 M10 M20 M20
  pshufd xmm0, xmm6, $80       // M20 M30 M30 M30
  mulps  xmm5, xmm4            // (M10 * M21) (M10 * M31) (M20 * M31) (M20 * M31)
  mulps  xmm7, xmm0            // (M20 * M11) (M30 * M11) (M30 * M21) (M30 * M21)
  subps  xmm5, xmm7            // C23=(M10*M21)-(M20*M11), C22=(M10*M31)-(M30*M11), C20=(M20*M31)-(M30*M21), C20=(M20*M31)-(M30*M21)
  movups [Stack.F5], xmm5

  //  V0 := Vector4(A.M[1,0], A.M[0,0], A.M[0,0], A.M[0,0]);
  //  V1 := Vector4(A.M[1,1], A.M[0,1], A.M[0,1], A.M[0,1]);
  //  V2 := Vector4(A.M[1,2], A.M[0,2], A.M[0,2], A.M[0,2]);
  //  V3 := Vector4(A.M[1,3], A.M[0,3], A.M[0,3], A.M[0,3]);
  movups xmm0, DQWORD[Self + $00] // M[0]
  movaps xmm4, xmm1            // M[1]
  movaps xmm5, xmm1            // M[1]
  movaps xmm6, xmm1            // M[1]
  movaps xmm7, xmm1            // M[1]

  shufps xmm4, xmm0, $00       // M00 M00 M10 M10
  shufps xmm5, xmm0, $55       // M01 M01 M11 M11
  shufps xmm6, xmm0, $AA       // M02 M02 M12 M12
  shufps xmm7, xmm0, $FF       // M03 M03 M13 M13

  pshufd xmm4, xmm4, $A8       // V0=M00 M00 M00 M10
  pshufd xmm5, xmm5, $A8       // V1=M01 M01 M01 M11
  pshufd xmm6, xmm6, $A8       // V2=M02 M02 M02 M12
  pshufd xmm7, xmm7, $A8       // V3=M03 M03 M03 M13

  //  I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
  //  I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
  //  I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
  //  I3 := (V0 * F2) - (V1 * F4) + (V2 * F5);
  movaps xmm0, xmm5            // V1
  movaps xmm1, xmm6            // V2
  movaps xmm2, xmm7            // V3
  mulps  xmm0, [Stack.F0]      // V1 * F0
  mulps  xmm1, [Stack.F1]      // V2 * F1
  mulps  xmm2, [Stack.F2]      // V3 * F2
  subps  xmm0, xmm1            // (V1 * F0) - (V2 * F1)
  movaps xmm1, xmm4            // V0
  addps  xmm0, xmm2            // I0=(V1 * F0) - (V2 * F1) + (V3 * F2)

  movaps xmm2, xmm6            // V2
  movaps xmm3, xmm7            // V3
  mulps  xmm1, [Stack.F0]      // V0 * F0
  mulps  xmm2, [Stack.F3]      // V2 * F3
  mulps  xmm3, [Stack.F4]      // V3 * F4
  subps  xmm1, xmm2            // (V0 * F0) - (V2 * F3)
  movaps xmm2, xmm4            // V0
  addps  xmm1, xmm3            // I1=(V0 * F0) - (V2 * F3) + (V3 * F4)

  movaps xmm3, xmm5            // V1
  mulps  xmm2, [Stack.F1]      // V0 * F1
  mulps  xmm3, [Stack.F3]      // V1 * F3
  mulps  xmm7, [Stack.F5]      // V3 * F5
  subps  xmm2, xmm3            // (V0 * F1) - (V1 * F3)
  mulps  xmm4, [Stack.F2]      // V0 * F2
  addps  xmm2, xmm7            // I2=(V0 * F1) - (V1 * F3) + (V3 * F5)

  mulps  xmm5, [Stack.F4]      // V1 * F4
  mulps  xmm6, [Stack.F5]      // V2 * F5
  subps  xmm4, xmm5            // (V0 * F2) - (V1 * F4)
  addps  xmm4, xmm6            // I3=(V0 * F2) - (V1 * F4) + (V2 * F5)

  //  SA := Vector4(+1, -1, +1, -1);
  //  SB := Vector4(-1, +1, -1, +1);
  //  Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB);

  movups xmm6, [SSE_MASK_PNPN] // SA
  movups xmm7, [SSE_MASK_NPNP] // SB
  xorps  xmm0, xmm6            // Inv[0] = I0 * SA
  xorps  xmm1, xmm7            // Inv[1] = I1 * SB
  xorps  xmm2, xmm6            // Inv[2] = I2 * SA
  xorps  xmm4, xmm7            // Inv[3] = I3 * SB

  //  Row := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
  movaps   xmm3, xmm0
  movaps   xmm5, xmm2
  movaps   xmm6, xmm1

  unpcklps xmm3, xmm1          // Inv[1,1] Inv[0,1] Inv[1,0] Inv[0,0]
  unpcklps xmm5, xmm4          // Inv[3,1] Inv[2,1] Inv[3,0] Inv[2,0]
  movups   xmm6, DQWORD[Self + $00] // A.C[0]
  movlhps  xmm3, xmm5          // Inv[3,0] Inv[2,0] Inv[1,0] Inv[0,0]

  //  Dot := A.C[0] * Row;
  mulps    xmm3, xmm6          // Dot.W  Dot.Z  Dot.Y  Dot.X

  //  OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W));
  pshufd   xmm6, xmm3, $4E     // Dot.Y  Dot.X  Dot.W  Dot.Z
  addps    xmm3, xmm6          // W+Y Z+X Y+W X+Z
  pshufd   xmm6, xmm3, $11     // X+Z Y+X X+Z Y+W
  movups   xmm5, [SSE_ONE]     // 1.0 (4x)
  addps    xmm3, xmm6          // X+Y+Z+W (4x)
  divps    xmm5, xmm3          // OneOverDeterminant (4x)

  //  Result := Inv * OneOverDeterminant;
  mulps    xmm0, xmm5
  mulps    xmm1, xmm5
  mulps    xmm2, xmm5
  mulps    xmm4, xmm5

  movups   DQWORD[Result + $00], xmm0
  movups   DQWORD[Result + $10], xmm1
  movups   DQWORD[Result + $20], xmm2
  movups   DQWORD[Result + $30], xmm4

  movdqa   xmm6, [Stack.X6]
  movdqa   xmm7, [Stack.X7]
end;

class operator TMatrix4.Multiply(const A: Single; const B: TMatrix4): TMatrix4; assembler;
asm
  movups xmm0, DQWORD [B + $00] // Load 4 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm2, DQWORD [B + $10]
  movups xmm3, DQWORD [B + $20]
  movups xmm4, DQWORD [B + $30]
  mulps  xmm0, xmm1             // Multiply each row by A
  mulps  xmm2, xmm1
  mulps  xmm3, xmm1
  mulps  xmm4, xmm1
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm2
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: Single): TMatrix4; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 4 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movups xmm3, DQWORD [A + $20]
  movups xmm4, DQWORD [A + $30]
  mulps  xmm1, xmm2             // Multiply each row by B
  mulps  xmm0, xmm2
  mulps  xmm3, xmm2
  mulps  xmm4, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

{$IFDEF FM_COLUMN_MAJOR}
class operator TMatrix4.Multiply(const A: TMatrix4; const B: TVector4): TVector4; assembler;
asm
  movups xmm0, [B]
  movups xmm4, DQWORD [A + $00]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  movups xmm5, DQWORD [A + $10]
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  movups xmm4, DQWORD [A + $20]
  movups xmm5, DQWORD [A + $30]
  mulps  xmm2, xmm4
  mulps  xmm3, xmm5
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups [Result], xmm0
end;

class operator TMatrix4.Multiply(const A: TVector4; const B: TMatrix4): TVector4; assembler;
asm
  movups   xmm0, [A]
  movups   xmm4, DQWORD [B + $00]
  movaps   xmm1, xmm0
  movaps   xmm2, xmm0
  movaps   xmm3, xmm0
  movups   xmm5, DQWORD [B + $10]
  mulps    xmm0, xmm4
  mulps    xmm1, xmm5
  movups   xmm4, DQWORD [B + $20]
  movups   xmm5, DQWORD [B + $30]
  mulps    xmm2, xmm4
  mulps    xmm3, xmm5

  { Transpose xmm0-xmm3 }
  movaps   xmm4, xmm2
  unpcklps xmm2, xmm3
  unpckhps xmm4, xmm3

  movaps   xmm3, xmm0
  unpcklps xmm0, xmm1
  unpckhps xmm3, xmm1

  movaps   xmm1, xmm0
  unpcklpd xmm0, xmm2
  unpckhpd xmm1, xmm2

  movaps   xmm2, xmm3
  unpcklpd xmm2, xmm4
  unpckhpd xmm3, xmm4

  addps    xmm0, xmm1
  addps    xmm2, xmm3
  addps    xmm0, xmm2
  movups   [Result], xmm0
end;

class operator TMatrix4.Multiply(const A, B: TMatrix4): TMatrix4; assembler;
{ Code below consists of 4 Vector*Matrix calculations }
asm
  movdqa [rsp-24], xmm6
  movdqa [rsp-40], xmm7

  movups xmm0, DQWORD [B + $00]
  movups xmm4, DQWORD [A + $00]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  movups xmm5, DQWORD [A + $10]
  movups xmm6, DQWORD [A + $20]
  movups xmm7, DQWORD [A + $30]
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $00], xmm0

  movups xmm0, DQWORD [B + $10]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $10], xmm0

  movups xmm0, DQWORD [B + $20]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $20], xmm0

  movups xmm0, DQWORD [B + $30]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $30], xmm0

  movdqa xmm6, [rsp-24]
  movdqa xmm7, [rsp-40]
end;
{$ELSE}
class operator TMatrix4.Multiply(const A: TMatrix4; const B: TVector4): TVector4; assembler;
asm
  movups   xmm0, [B]              // Load vector
  movups   xmm4, DQWORD [A + $00] // Load 4 rows
  movaps   xmm1, xmm0
  movaps   xmm2, xmm0
  movaps   xmm3, xmm0
  movups   xmm5, DQWORD [A + $10]
  mulps    xmm0, xmm4             // (Ax * B00), (Ay * B01), (Az * B02), (Aw * B03)
  mulps    xmm1, xmm5             // (Ax * B10), (Ay * B11), (Az * B12), (Aw * B13)
  movups   xmm4, DQWORD [A + $20]
  movups   xmm5, DQWORD [A + $30]
  mulps    xmm2, xmm4             // (Ax * B20), (Ay * B21), (Az * B22), (Aw * B23)
  mulps    xmm3, xmm5             // (Ax * B30), (Ay * B31), (Az * B32), (Aw * B33)

  { Transpose xmm0-xmm3 }
  movaps   xmm4, xmm2
  unpcklps xmm2, xmm3             // B32 B22 B33 B23
  unpckhps xmm4, xmm3             // B30 B20 B31 B21

  movaps   xmm3, xmm0
  unpcklps xmm0, xmm1             // B12 B02 B13 B03
  unpckhps xmm3, xmm1             // B10 B00 B11 B01

  movaps   xmm1, xmm0
  unpcklpd xmm0, xmm2             // B33 B23 B13 B03
  unpckhpd xmm1, xmm2             // B32 B22 B12 B02

  movaps   xmm2, xmm3
  unpcklpd xmm2, xmm4             // B31 B21 B11 B01
  unpckhpd xmm3, xmm4             // B30 B20 B10 B00

  addps    xmm0, xmm1             // Add rows
  addps    xmm2, xmm3
  addps    xmm0, xmm2
  movups   [Result], xmm0
end;

class operator TMatrix4.Multiply(const A: TVector4; const B: TMatrix4): TVector4; assembler;
asm
  movups xmm0, [A]              // Load vector
  movups xmm4, DQWORD [B + $00] // Load 4 rows
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00        // Bx Bx Bx Bx
  shufps xmm1, xmm1, $55        // By By By By
  shufps xmm2, xmm2, $AA        // Bz Bz Bz Bz
  shufps xmm3, xmm3, $FF        // Bw Bw Bw Bw
  movups xmm5, DQWORD [B + $10]
  mulps  xmm0, xmm4             // (A00 * Bx), (A01 * Bx), (A02 * Bx), (A03 * Bx)
  mulps  xmm1, xmm5             // (A10 * By), (A11 * By), (A12 * By), (A13 * By)
  movups xmm4, DQWORD [B + $20]
  movups xmm5, DQWORD [B + $30]
  mulps  xmm2, xmm4             // (A20 * Bz), (A21 * Bz), (A22 * Bz), (A23 * Bz)
  mulps  xmm3, xmm5             // (A30 * Bw), (A31 * Bw), (A32 * Bw), (A33 * Bw)
  addps  xmm0, xmm1             // Add rows
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups [Result], xmm0
end;

class operator TMatrix4.Multiply(const A, B: TMatrix4): TMatrix4; assembler;
{ Code below consists of 4 Vector*Matrix calculations }
asm
  movdqa [rsp-24], xmm6
  movdqa [rsp-40], xmm7

  { A.R[0] * B }
  movups xmm0, DQWORD [A + $00]
  movups xmm4, DQWORD [B + $00]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  movups xmm5, DQWORD [B + $10]
  movups xmm6, DQWORD [B + $20]
  movups xmm7, DQWORD [B + $30]
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $00], xmm0

  { A.R[1] * B }
  movups xmm0, DQWORD [A + $10]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $10], xmm0

  { A.R[2] * B }
  movups xmm0, DQWORD [A + $20]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $20], xmm0

  { A.R[3] * B }
  movups xmm0, DQWORD [A + $30]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups DQWORD [Result + $30], xmm0

  movdqa xmm6, [rsp-24]
  movdqa xmm7, [rsp-40]
end;
{$ENDIF}

class operator TMatrix4.Negative(const A: TMatrix4): TMatrix4; assembler;
asm
  movups xmm0, [SSE_MASK_SIGN]  // Load mask with 4 sign (upper) bits
  movups xmm1, DQWORD [A + $00] // Load 4 rows
  movups xmm2, DQWORD [A + $10]
  movups xmm3, DQWORD [A + $20]
  movups xmm4, DQWORD [A + $30]
  xorps  xmm1, xmm0             // Flip sign bits of each element in each row
  xorps  xmm2, xmm0
  xorps  xmm3, xmm0
  xorps  xmm4, xmm0
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm2
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

procedure TMatrix4.SetInversed;
begin
  Self := Inverse;
end;

procedure TMatrix4.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix4.Subtract(const A: TMatrix4; const B: Single): TMatrix4; assembler;
asm
  movups xmm1, DQWORD [A + $00] // Load 4 rows
  shufps xmm2, xmm2, 0          // Replicate B
  movups xmm0, DQWORD [A + $10]
  movups xmm3, DQWORD [A + $20]
  movups xmm4, DQWORD [A + $30]
  subps  xmm1, xmm2             // Subtract B from each row
  subps  xmm0, xmm2
  subps  xmm3, xmm2
  subps  xmm4, xmm2
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movups DQWORD [Result + $20], xmm3
  movups DQWORD [Result + $30], xmm4
end;

class operator TMatrix4.Subtract(const A: Single; const B: TMatrix4): TMatrix4; assembler;
asm
  movups xmm4, DQWORD [B + $00] // Load 4 rows
  shufps xmm1, xmm1, 0          // Replicate A
  movups xmm5, DQWORD [B + $10]
  movaps xmm0, xmm1
  movaps xmm2, xmm1
  movaps xmm3, xmm1
  subps  xmm1, xmm4             // Subtract each row from A
  subps  xmm0, xmm5
  movups xmm4, DQWORD [B + $20]
  movups xmm5, DQWORD [B + $30]
  subps  xmm2, xmm4
  subps  xmm3, xmm5
  movups DQWORD [Result + $00], xmm1
  movups DQWORD [Result + $10], xmm0
  movups DQWORD [Result + $20], xmm2
  movups DQWORD [Result + $30], xmm3
end;

class operator TMatrix4.Subtract(const A, B: TMatrix4): TMatrix4; assembler;
asm
  movups xmm0, DQWORD [A + $00] // Load 4 rows of A
  movups xmm1, DQWORD [A + $10]
  movups xmm2, DQWORD [A + $20]
  movups xmm3, DQWORD [A + $30]
  movups xmm4, DQWORD [B + $00] // Load 4 rows of B
  movups xmm5, DQWORD [B + $10]
  subps  xmm0, xmm4             // Subtract rows
  subps  xmm1, xmm5
  movups xmm4, DQWORD [B + $20]
  movups xmm5, DQWORD [B + $30]
  subps  xmm2, xmm4
  subps  xmm3, xmm5
  movups DQWORD [Result + $00], xmm0
  movups DQWORD [Result + $10], xmm1
  movups DQWORD [Result + $20], xmm2
  movups DQWORD [Result + $30], xmm3
end;

function TMatrix4.Transpose: TMatrix4; assembler;
asm
  movups   xmm0, DQWORD[Self + $00] // A03 A02 A01 A00
  movups   xmm1, DQWORD[Self + $10] // A13 A12 A11 A10
  movups   xmm2, DQWORD[Self + $20] // A23 A22 A21 A20
  movups   xmm3, DQWORD[Self + $30] // A33 A32 A31 A30

  movaps   xmm4, xmm2
  unpcklps xmm2, xmm3               // A31 A21 A30 A20
  unpckhps xmm4, xmm3               // A33 A23 A32 A22

  movaps   xmm3, xmm0
  unpcklps xmm0, xmm1               // A11 A01 A10 A00
  unpckhps xmm3, xmm1               // A13 A03 A12 A02

  movaps   xmm1, xmm0
  unpcklpd xmm0, xmm2               // A30 A20 A10 A00
  unpckhpd xmm1, xmm2               // A31 A21 A11 A01

  movaps   xmm2, xmm3
  unpcklpd xmm2, xmm4               // A32 A22 A12 A02
  unpckhpd xmm3, xmm4               // A33 A23 A13 A03

  movups   DQWORD[Result + $00], xmm0
  movups   DQWORD[Result + $10], xmm1
  movups   DQWORD[Result + $20], xmm2
  movups   DQWORD[Result + $30], xmm3
end;
