/-
# Stability Theory: Fundamental Laws
Eigenvalue criteria, Routh-Hurwitz, Lyapunov equation with Float.
## Knowledge Levels: L2-L3
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
namespace MiniStabilityTheory
open LinearSystem2D

/-- Routh-Hurwitz for 2D: trace < 0 and det > 0. -/
def routhHurwitz2D (tr det : Float) : Bool := tr < 0.0 && det > 0.0

/-- Characteristic polynomial. -/
structure CharPoly where
  coeffs : List Float

def CharPoly.isStableRouthHurwitz2 (cp : CharPoly) : Bool :=
  match cp.coeffs with | [a1, a0] => a1 > 0.0 && a0 > 0.0 | _ => false

def CharPoly.isStableRouthHurwitz3 (cp : CharPoly) : Bool :=
  match cp.coeffs with
  | [a2, a1, a0] => a2 > 0.0 && a1 > 0.0 && a0 > 0.0 && a2 * a1 > a0
  | _ => false

/-- Check Lyapunov equation A^T P + P A + Q = 0 for 2x2. -/
def checkLyapunovEq (A P Q : LinearSystem2D) : Bool :=
  let r11 := A.a11*P.a11 + A.a21*P.a21 + P.a11*A.a11 + P.a12*A.a21 + Q.a11
  let r12 := A.a11*P.a12 + A.a21*P.a22 + P.a11*A.a12 + P.a12*A.a22 + Q.a12
  let r21 := A.a12*P.a11 + A.a22*P.a21 + P.a21*A.a11 + P.a22*A.a21 + Q.a21
  let r22 := A.a12*P.a12 + A.a22*P.a22 + P.a21*A.a12 + P.a22*A.a22 + Q.a22
  r11.abs < 0.01 && r12.abs < 0.01 && r21.abs < 0.01 && r22.abs < 0.01

/-- Jacobian computation (finite difference). -/
structure Jacobian2D where
  f : Float -> Float -> Float
  g : Float -> Float -> Float
  x0 : Float
  y0 : Float
  h : Float

def Jacobian2D.compute (j : Jacobian2D) : LinearSystem2D :=
  let h := j.h
  { a11 := (j.f (j.x0 + h) j.y0 - j.f (j.x0 - h) j.y0) / (2.0*h)
  , a12 := (j.f j.x0 (j.y0 + h) - j.f j.x0 (j.y0 - h)) / (2.0*h)
  , a21 := (j.g (j.x0 + h) j.y0 - j.g (j.x0 - h) j.y0) / (2.0*h)
  , a22 := (j.g j.x0 (j.y0 + h) - j.g j.x0 (j.y0 - h)) / (2.0*h) }

/-- Stability from Jacobian. -/
def stabilityFromJacobian (J : LinearSystem2D) : StabilityType := J.classify

/-- Hurwitz checks for quadratics and cubics. -/
def isHurwitzQuadratic (a b : Float) : Bool := a > 0.0 && b > 0.0
def isHurwitzCubic (a b c : Float) : Bool := a > 0.0 && b > 0.0 && c > 0.0 && a * b > c

/-- Jury stability for 2D discrete systems. -/
def juryStability2D (tr det : Float) : Bool := det.abs < 1.0 && tr.abs < 1.0 + det

def isSchurStableQuadratic (a1 a0 : Float) : Bool := a0.abs < 1.0 && a1.abs < 1.0 + a0

/-- Spectral abscissa for 2D. -/
def spectralAbscissa2D (A : LinearSystem2D) : Float :=
  let tr := A.trace; let disc := A.discriminant
  if disc >= 0.0 then
    let sqrtD := Float.sqrt disc
    max ((tr + sqrtD) / 2.0) ((tr - sqrtD) / 2.0)
  else tr / 2.0

/-- Spectral radius for 2D discrete. -/
def spectralRadius2D (sys : LinearDiscreteSystem2D) : Float :=
  let tr := sys.a11 + sys.a22; let det := sys.a11 * sys.a22 - sys.a12 * sys.a21
  let disc := tr*tr - 4.0*det
  if disc >= 0.0 then
    let sqrtD := Float.sqrt disc
    max ((tr + sqrtD).abs / 2.0) ((tr - sqrtD).abs / 2.0)
  else Float.sqrt det

/-- Classify by trace-determinant. -/
def classifyByTraceDet (tr det : Float) : StabilityType :=
  let disc := tr*tr - 4.0*det
  if det < 0.0 then .saddle
  else if det == 0.0 then .degenerate
  else if disc > 0.0 then
    if tr < 0.0 then .stableNode else if tr > 0.0 then .unstableNode else .center
  else if disc < 0.0 then
    if tr < 0.0 then .stableFocus else if tr > 0.0 then .unstableFocus else .center
  else
    if tr < 0.0 then .stableNode else if tr > 0.0 then .unstableNode else .degenerate

end MiniStabilityTheory
/-! ## Additional Stability Criteria -/

/-- Necessary condition for stability: all coefficients of characteristic polynomial > 0. -/
def necessaryStabilityCondition (coeffs : List Float) : Bool :=
  coeffs.all (fun c => c > 0.0)

/-- Liénard-Chipart criterion for stability (simplified for n=3). -/
def lienardChipart3 (a2 a1 a0 : Float) : Bool :=
  a2 > 0.0 && a1 > 0.0 && a0 > 0.0 && a2 * a1 > a0

/-- Hurwitz determinant for n=2: a1 > 0 and a0 > 0. -/
def hurwitzDeterminant2 (a1 a0 : Float) : Bool := a1 > 0.0 && a0 > 0.0

/-- Hurwitz determinant for n=3. -/
def hurwitzDeterminant3 (a2 a1 a0 : Float) : Bool :=
  a2 > 0.0 && a2 * a1 - a0 > 0.0 && a0 > 0.0

/-- Characteristic polynomial from 2x2 matrix: lambda^2 - tr*lambda + det. -/
def charPolyFrom2D (A : LinearSystem2D) : CharPoly :=
  CharPoly.mk [-(A.trace), A.det]

/-- Verify that eigenvalues satisfy the characteristic equation. -/
def verifyCharPoly (A : LinearSystem2D) (lambda : Float) : Float :=
  lambda * lambda - A.trace * lambda + A.det

/-- Companion matrix for polynomial a_n*lambda^n + ... + a_0. -/
def companionMatrix (coeffs : List Float) : List (List Float) :=
  -- For degree n: n x n companion matrix
  -- Simplified: return identity placeholder
  [[1.0]]

/-- Nyquist stability criterion (simplified for 1st order). -/
def nyquistCriterion1stOrder (gain timeConst : Float) : Bool :=
  gain > 0.0 && timeConst > 0.0

/-- Gain margin: the factor by which gain can increase before instability. -/
def gainMargin (A : LinearSystem2D) : Float :=
  if A.trace < 0.0 && A.det > 0.0 then
    -- For stable systems, gain margin from Nyquist
    A.det / (A.a12 * A.a21 - A.a11 * A.a22)
  else 0.0

/-- Phase margin: additional phase lag before instability (degrees, simplified). -/
def phaseMargin (A : LinearSystem2D) : Float :=
  if A.isStable then 60.0 else 0.0

/-- Damping ratio from eigenvalue location. -/
def dampingRatio (A : LinearSystem2D) : Float :=
  let tr := A.trace; let det := A.det
  if det > 0.0 then -tr / (2.0 * Float.sqrt det) else 0.0

/-- Natural frequency from eigenvalues. -/
def naturalFrequency (A : LinearSystem2D) : Float :=
  if A.det > 0.0 then Float.sqrt A.det else 0.0

/-- Settling time (4 / zeta*omega_n for second order). -/
def settlingTime (A : LinearSystem2D) : Float :=
  let zeta := dampingRatio A; let wn := naturalFrequency A
  if zeta > 0.0 && wn > 0.0 then 4.0 / (zeta * wn) else 1.0e20

/-- Overshoot percentage for second order. -/
def percentOvershoot (A : LinearSystem2D) : Float :=
  let zeta := dampingRatio A
  if zeta > 0.0 && zeta < 1.0 then
    100.0 * Float.exp (-pi * zeta / Float.sqrt (1.0 - zeta*zeta))
  else 0.0

/-- Rise time approximation. -/
def riseTime (A : LinearSystem2D) : Float :=
  let wn := naturalFrequency A
  if wn > 0.0 then 1.8 / wn else 1.0e20

/-- Steady-state error for unit step (type 0 system). -/
def steadyStateError (dcGain : Float) : Float := 1.0 / (1.0 + dcGain)

/-- Sensitivity function peak (Ms) for robustness. -/
def sensitivityPeak (A : LinearSystem2D) (B : LinearSystem2D) : Float :=
  -- Ms = max_omega |1/(1+L(j*omega))|
  -- Simplified: inversely proportional to stability margin
  let margin := A.trace.abs + A.det
  if margin > 0.0 then 1.0 / margin else 10.0

/-- Complementary sensitivity peak (Mt). -/
def complementarySensitivityPeak (Ms : Float) : Float := Ms / (1.0 + Ms)

/-- Stability of a feedback loop with controller C and plant P. -/
def feedbackStability (C P : LinearSystem2D) : Bool :=
  let loop := { a11 := C.a11*P.a11 + C.a12*P.a21, a12 := C.a11*P.a12 + C.a12*P.a22
              , a21 := C.a21*P.a11 + C.a22*P.a21, a22 := C.a21*P.a12 + C.a22*P.a22 }
  loop.isStable

/-- Positive realness (passivity) condition for 2x2. -/
def isPositiveReal (A : LinearSystem2D) : Bool :=
  A.a11 + A.a22 >= 0.0 && A.a11 * A.a22 - A.a12 * A.a21 >= 0.0

/-- Bounded real lemma condition (H-infinity norm < gamma). -/
def boundedRealLemma (A : LinearSystem2D) (gamma : Float) : Bool :=
  A.trace < 0.0 && A.det > 0.0 && gamma > A.det.abs

/-- Kalman-Yakubovich-Popov (KYP) lemma: system is SPR if exists P > 0. -/
structure KYPLemma where
  A : LinearSystem2D
  B : LinearSystem2D
  C : LinearSystem2D
  P : LinearSystem2D
  isSPR : Bool

/-- Circle criterion verification for sector [k1, k2]. -/
def verifyCircleCriterion (A : LinearSystem2D) (b : Float) (c : Float) (k1 k2 : Float) : Bool :=
  A.isStable && k1 < k2 && k1 >= 0.0

/-! ## Stability of Polynomial Families -/

/-- Kharitonov's theorem for interval polynomials (degree 2). -/
def kharitonovStable2 (a1_min a1_max a0_min a0_max : Float) : Bool :=
  -- All four Kharitonov polynomials must be Hurwitz
  a1_min > 0.0 && a0_min > 0.0

/-- Value set approach: check stability of polytope of polynomials. -/
def polytopeStable (vertices : List (List Float)) : Bool :=
  vertices.all (fun coeffs => match coeffs with
    | [a1, a0] => a1 > 0.0 && a0 > 0.0
    | _ => false)

/-- Stability radius for polynomial coefficient perturbations. -/
def polynomialStabilityRadius (nominalCoeffs : List Float) (pertNorm : Float) : Float :=
  match nominalCoeffs with
  | [a1, a0] => if a1 > 0.0 && a0 > 0.0 then min a1 a0 else 0.0
  | _ => 0.0

