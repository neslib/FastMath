/* Calculates a reciprocal (1 / A).

   Given an initial reciprocal estimate of A called X(0) (as returned by
   vrecpe), the following Newton-Raphson iteration can be used to refine the
   estimate:
     X(n+1) = X(n) * (2 - A * X(n))
   each additional iteration improves the accuracy.

   The vrecps instruction can be used in the iteration. It calculates this:
     vrecps = (2 - A * B)
   so the iteration looks like this:
     X(n+1) = X(n) * vrecps(A, X(n))

   The LOW (low-precision) version performs one iteration.
   The MED (medium-precision) version performs two iterations.

   The RECIPD version operates on D-registers and modifies D30/D31 as well.
   The RECIPQ version operates on Q-registers and modifies Q14/Q15 as well.

   Parameters
     Res: register that will be set to the result. Can be the same as A.
     A: the argument register to calculate the reciprocal of.
       Can be the same as Res. */
.macro RECIP_LOW Res A Tmp1 Tmp2
    vrecpe.f32   \Tmp1, \A           /* X(0)=Approximate 1/A       */
    vrecps.f32   \Tmp2, \Tmp1, \A    /* 2 - A * X(0)               */
    vmul.f32     \Res, \Tmp1, \Tmp2  /* X(1)=X(0) * (2 - A * X(0)) */
.endm

.macro RECIP_MED Res A Tmp1 Tmp2
    vrecpe.f32   \Tmp1, \A           /* X(0)=Approximate 1/A       */
    vrecps.f32   \Tmp2, \Tmp1, \A    /* 2 - A * X(0)               */
    vmul.f32     \Tmp1, \Tmp1, \Tmp2 /* X(1)=X(0) * (2 - A * X(0)) */
    vrecps.f32   \Tmp2, \Tmp1, \A    /* 2 - A * X(1)               */
    vmul.f32     \Res, \Tmp1, \Tmp2  /* X(2)=X(1) * (2 - A * X(1)) */
.endm

.macro RECIPD_LOW Res A
  RECIP_LOW \Res, \A, d30, d31
.endm

.macro RECIPD_MED Res A
  RECIP_MED \Res, \A, d30, d31
.endm

.macro RECIPQ_LOW Res A
  RECIP_LOW \Res, \A, q14, q15
.endm

.macro RECIPQ_MED Res A
  RECIP_MED \Res, \A, q14, q15
.endm

/* Calculates an inverse square root (1 / Sqrt(A)).

   Given an initial reciprocal square root estimate of A called X(0) (as
   returned by vrsqrte), the following Newton-Raphson iteration can be used to
   refine the estimate:
     X(n+1) = X(n)*(3 - A*X(n)^2)/2
   each additional iteration improves the accuracy.

   The vrsqrts instruction can be used in the iteration. It calculates this:
     vrsqrts = (3 - A * B) / 2
   so the iteration looks like this:
     X(n+1) = X(n) * vrsqrts(A, X(n)^2)

   The LOW (low-precision) version performs one iteration.
   The MED (medium-precision) version performs two iterations.

   The INVSQRTD version operates on D-registers and modifies D30/D31 as well.
   The INVSQRTQ version operates on Q-registers and modifies Q14/Q15 as well.

   Parameters
     Res: register that will be set to the result. Can be the same as A.
     A: the argument register to calculate the inverse square root of.
       Can be the same as Res. */
.macro INVSQRT_LOW Res A Tmp1 Tmp2
    vrsqrte.f32  \Tmp1, \A           /* X(0)=Approximate 1/Sqrt(A)              */
    vmul.f32     \Tmp2, \Tmp1, \A    /* A * X(0)                                */
    vrsqrts.f32  \Tmp2, \Tmp2, \Tmp1 /* (3 - A * X(0) * X(0)) / 2               */
    vmul.f32     \Res, \Tmp1, \Tmp2  /* X(1) = X(0) * (3 - A * X(0) * X(0)) / 2 */
.endm

.macro INVSQRT_MED Res A Tmp1 Tmp2
    vrsqrte.f32  \Tmp1, \A           /* X(0)=Approximate 1/Sqrt(A)              */
    vmul.f32     \Tmp2, \Tmp1, \A    /* A * X(0)                                */
    vrsqrts.f32  \Tmp2, \Tmp2, \Tmp1 /* (3 - A * X(0) * X(0)) / 2               */
    vmul.f32     \Tmp1, \Tmp1, \Tmp2 /* X(1) = X(0) * (3 - A * X(0) * X(0)) / 2 */
    vmul.f32     \Tmp2, \Tmp1, \A    /* A * X(1)                                */
    vrsqrts.f32  \Tmp2, \Tmp2, \Tmp1 /* (3 - A * X(1) * X(1)) / 2               */
    vmul.f32     \Res, \Tmp1, \Tmp2  /* X(2) = X(1) * (3 - A * X(1) * X(1)) / 2 */
.endm

.macro INVSQRTD_LOW Res A
  INVSQRT_LOW \Res, \A, d30, d31
.endm

.macro INVSQRTD_MED Res A
  INVSQRT_MED \Res, \A, d30, d31
.endm

.macro INVSQRTQ_LOW Res A
  INVSQRT_LOW \Res, \A, q14, q15
.endm

.macro INVSQRTQ_MED Res A
  INVSQRT_MED \Res, \A, q14, q15
.endm

/* Calculates a square root (1 / Sqrt(A)).

   NEON does not have a SQRT instruction, but does have instructions to
   calculate the inverse (reciprocal) square root. So we can calculate the
   square root by calculating A * (1 / Sqrt(A))

   The LOW (low-precision) version performs one iteration.
   The MED (medium-precision) version performs two iterations.

   The SQRTD version operates on D-registers and modifies D29/D30/D31 as well.
   The SQRTQ version operates on Q-registers and modifies Q13/Q14/Q15 as well.

   Parameters
     Res: register that will be set to the result.
       CANNOT be the same as A.
     A: the argument register to calculate the inverse square root of.
       CANNOT be the same as Res. */
.macro SQRT_LOW Res A Tmp1 Tmp2 Tmp3
    /* Special case for A=0. The inverse square root of A would result in
       Infinity, but we should return 0. So we check for 0 and set \Tmp3 to
       $FFFFFFFF if A=0, $00000000 otherwise. At the end, we AND the result
       with the complement of this mask so the result is 0 if A=0.*/
    vceq.f32     \Tmp3, \A, #0
    
    /* 1 / Sqrt(A) */
    INVSQRT_LOW  \Res, \A, \Tmp1, \Tmp2
    
    vmul.f32     \Res, \Res, \A         /* A * (1 / Sqrt(A))      */
    vbic.f32     \Res, \Res, \Tmp3      /* A * (1 / Sqrt(A)) or 0 */
.endm

.macro SQRT_MED Res A Tmp1 Tmp2 Tmp3
    vceq.f32     \Tmp3, \A, #0
    
    /* 1 / Sqrt(A) */
    INVSQRT_MED  \Res, \A, \Tmp1, \Tmp2 
    
    vmul.f32     \Res, \Res, \A         /* A * (1 / Sqrt(A))      */
    vbic.f32     \Res, \Res, \Tmp3      /* A * (1 / Sqrt(A)) or 0 */
.endm

.macro SQRTD_LOW Res A
    SQRT_LOW \Res, \A, d29, d30, d31
.endm

.macro SQRTD_MED Res A
    SQRT_MED \Res, \A, d29, d30, d31
.endm

.macro SQRTQ_LOW Res A
    SQRT_LOW \Res, \A, q13, q14, q15
.endm

.macro SQRTQ_MED Res A
    SQRT_MED \Res, \A, q13, q14, q15
.endm

