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
    .globl _outer_product_matrix2
    .globl _neg_matrix2
    .globl _matrix2_add_scalar, _scalar_add_matrix2, _matrix2_add_matrix2
    .globl _matrix2_sub_scalar, _scalar_sub_matrix2, _matrix2_sub_matrix2
    .globl _matrix2_mul_scalar, _scalar_mul_matrix2, _matrix2_mul_vector2, _vector2_mul_matrix2, _matrix2_mul_matrix2
    .globl _matrix2_div_scalar, _scalar_div_matrix2
    .globl _matrix2_comp_mult, _matrix2_transpose

_outer_product_matrix2: // (const C, R: TVector2; out Result: TMatrix2);
    vld1.32     {d0}, [r1]         //            R.Y R.X
    vld1.32     {d2}, [r0]         //            C.Y C.X
    vmov        d1, d0             // q0=R.Y R.X R.Y R.X
    vdup.32     d3, d2[1]          //    C.Y C.Y
    vdup.32     d2, d2[0]          // q1=C.Y C.Y C.X C.X
    vmul.f32    q0, q0, q1         // (R.Y*C.Y) (R.X*C.Y) (R.Y*C.X) (R.X*C.X)
    vst1.f32    {q0}, [r2]
    bx          lr

_neg_matrix2: // (const A: TMatrix2; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vneg.f32    q0, q0
    vst1.f32    {q0}, [r1]
    bx          lr

_matrix2_add_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    vadd.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_add_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    vadd.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_add_matrix2: // (const A, B: TMatrix2; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vadd.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_sub_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    vsub.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_sub_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    vsub.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_sub_matrix2: // (const A, B: TMatrix2; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vld1.32     {q1}, [r1]
    vsub.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_mul_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_mul_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_vector2_mul_matrix2: // (const A: TVector2; const B: TMatrix2; out Result: TVector2);
    vld1.32     {d0}, [r0] // A.Y A.X
    vmov        d1, d0     // A.Y A.X A.Y A.X
    vld1.32     {q1}, [r1] // B11 B10 B01 B00
    vmul.f32    q0, q0, q1 // (A.Y*B11) (A.X*B10) (A.Y*B01) (A.X*B00)
    vpadd.f32   d0, d0, d1 // (A.Y*B11)+(A.X*B10) (A.Y*B01)+(A.X*B00)
    vst1.f32    {d0}, [r2]
    bx          lr

_matrix2_mul_vector2: // (const A: TMatrix2; const B: TVector2; out Result: TVector2);
    vld2.32     {d0-d1}, [r0] // A11 A01 A10 A00 (deinterleaved)
    vld1.32     {d2}, [r1]    // B.Y B.X
    vmov        d3, d2        // B.Y B.X B.Y B.X
    vmul.f32    q0, q0, q1    // (A11*B.Y) (A01*B.X) (A10*B.Y) (A00*B.X)
    vpadd.f32   d0, d0, d1    // (A11*B.Y) (A01*B.X)+(A10*B.Y) (A00*B.X)
    vst1.f32    {d0}, [r2]
    bx          lr

_matrix2_mul_matrix2: // (const A, B: TMatrix2; out Result: TMatrix2);
    // Implemented as 2 Matrix*Vector calculations
    vld2.32     {q0}, [r0]    // d1=A11 A01  d0=A10 A00 (deinterleaved)
    vld1.32     {q1}, [r1]    // d3=B11 B10  d2=B01 B00

    // A * B.C[0]
    vmul.f32    d4, d0, d2    //                     (A10*B01) (A00*B00)
    vmul.f32    d5, d1, d2    // (A11*B01) (A01*B00)

    // A * B.C[1]
    vmul.f32    d6, d0, d3    //                     (A10*B11) (A00*B10)
    vmul.f32    d7, d1, d3    // (A11*B11) (A01*B10)

    vpadd.f32   d0, d4, d5    // (A11*B01)+(A01*B00) (A10*B01)+(A00*B00)
    vpadd.f32   d1, d6, d7    // (A11*B11)+(A01*B10) (A10*B11)+(A00*B10)
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_div_scalar: // (const A: TMatrix2; const B: Single; out Result: TMatrix2);
    vld1.32     {q0}, [r0]
    vdup.f32    q1, r1
    RECIPQ_MED  q1, q1        // 1 / B
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_scalar_div_matrix2: // (const A: Single; const B: TMatrix2; out Result: TMatrix2);
    vdup.f32    q0, r0
    vld1.32     {q1}, [r1]
    RECIPQ_MED  q1, q1        // 1 / B
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_comp_mult: // (const A, B: TMatrix2; out Result: TMatrix2);
    vld1.32     {q0}, [r0] // Contains entire matrix A
    vld1.32     {q1}, [r1] // Contains entire matrix B
    vmul.f32    q0, q0, q1
    vst1.f32    {q0}, [r2]
    bx          lr

_matrix2_transpose: // (const A: TMatrix2; out Result: TMatrix2);
    vld1.32     {q0}, [r0]         // d0=M01 M00
                                   // d1=M11 M10
    vtrn.32     d0, d1             // d0=M10 M00
                                   // d1=M11 M01
    vst1.32     {q0}, [r1]
    bx          lr

#endif // __LP64__