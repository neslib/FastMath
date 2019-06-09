{ Don't convert Single to Double on x64 }
{$EXCESSPRECISION OFF}

{ Enums must be scoped }
{$SCOPEDENUMS ON}

{$DEFINE FM_PASCAL}
{$DEFINE FM_INLINE}

{$IF not Defined(FM_NOSIMD)}
  {$IF Defined(CPUARM)}
    { On Arm, use NEON/Arm64 optimizations.
      Keep FM_INLINE for the functions that call the optimized versions. }
    {$UNDEF FM_PASCAL}
    {$DEFINE FM_ARM}
  {$ELSEIF Defined(MACOS64)}
    { On MacOS 64-bit, use SSE2 optimizations using a linked object file. }
    {$UNDEF FM_PASCAL}
    {$DEFINE FM_X64}
  {$ELSEIF Defined(CPUX86)}
    { On x86-32 use SSE2 optimizations.
      Undefine FM_INLINE since assembly functions cannot be inlined. }
    {$UNDEF FM_PASCAL}
    {$UNDEF FM_INLINE}
    {$DEFINE FM_X86}
  {$ELSEIF Defined(CPUX64)}
    { On x86-64, use SSE2 optimizations.
      Undefine FM_INLINE since assembly functions cannot be inlined. }
    {$UNDEF FM_PASCAL}
    {$UNDEF FM_INLINE}
    {$DEFINE FM_X64}
  {$ENDIF}
{$ENDIF}