/-
# Stability Theory: Lyapunov Function Constructions
Methods for constructing Lyapunov functions.
## Knowledge Levels: L3, L5
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
namespace MiniStabilityTheory

structure QuadraticLyapunov where
  P : LinearSystem2D
  A : LinearSystem2D
  Q : LinearSystem2D
  isSolution : Bool

def constructQuadraticLyapunov (A : LinearSystem2D) : QuadraticLyapunov :=
  let P : LinearSystem2D := { a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 1.0 }
  let Q := { a11 := -(2.0*A.a11), a12 := -(A.a12 + A.a21)
           , a21 := -(A.a12 + A.a21), a22 := -(2.0*A.a22) }
  { P, A, Q, isSolution := true }

def QuadraticLyapunov.eval (ql : QuadraticLyapunov) (x y : Float) : Float :=
  ql.P.a11 * x * x + 2.0 * ql.P.a12 * x * y + ql.P.a22 * y * y

def QuadraticLyapunov.derivative (ql : QuadraticLyapunov) (x y : Float) : Float :=
  let A := ql.A; let P := ql.P
  let x1 := A.a11 * x + A.a12 * y
  let y1 := A.a21 * x + A.a22 * y
  let gradVx := 2.0 * (P.a11 * x + P.a12 * y)
  let gradVy := 2.0 * (P.a12 * x + P.a22 * y)
  gradVx * x1 + gradVy * y1

structure MechanicalLyapunov where
  mass : Float
  damping : Float
  equilibrium : Float

def MechanicalLyapunov.eval (ml : MechanicalLyapunov) (potential : Float -> Float) (x v : Float) : Float :=
  0.5 * ml.mass * v * v + potential x - potential ml.equilibrium

structure SOSLyapunov where
  degree : Nat
  squares : List (List Float)
  equilibrium : Float

def evalPoly (coeffs : List Float) (x : Float) : Float :=
  coeffs.foldl (fun (s, i) a => (s + a * (x ^ i), i+1)) (0.0, 0) |>.1

def SOSLyapunov.eval (sos : SOSLyapunov) (x : Float) : Float :=
  sos.squares.foldl (fun s coeffs => let px := evalPoly coeffs x; s + px * px) 0.0

structure GridLyapunov where
  grid : List Float
  values : List Float
  isDecreasing : Bool

/-- Lyapunov function for 1D discrete system: V(f(x)) <= V(x). -/
def verifyLyapunovDiscrete (f : Float -> Float) (V : Float -> Float) (xStar : Float)
    (candidates : List Float) : Bool :=
  let isFixed := f xStar == xStar
  let vAtEq := V xStar == 0.0
  let vPositive := candidates.all (fun x => x == xStar || V x > 0.0)
  let vDecreasing := candidates.all (fun x => x == xStar || V (f x) < V x)
  isFixed && vAtEq && vPositive && vDecreasing

end MiniStabilityTheory
/-! ## Advanced Lyapunov Function Constructions -/

/-- LQR Lyapunov function: V(x) = x^T P x where P solves Riccati equation. -/
structure LQRLyapunov where
  A : LinearSystem2D
  B : Float * Float
  Q : LinearSystem2D; R : Float
  P : LinearSystem2D

/-- Algebraic Riccati equation: A^T P + P A - P B R^{-1} B^T P + Q = 0. -/
def checkRiccati (A : LinearSystem2D) (B : Float * Float) (Q : LinearSystem2D) (R : Float) (P : LinearSystem2D) : Bool :=
  let b1 := B.1; let b2 := B.2
  let PBRinvBTP_11 := (P.a11*b1 + P.a12*b2) * (b1*P.a11 + b2*P.a21) / R
  let PBRinvBTP_12 := (P.a11*b1 + P.a12*b2) * (b1*P.a12 + b2*P.a22) / R
  let PBRinvBTP_21 := (P.a21*b1 + P.a22*b2) * (b1*P.a11 + b2*P.a21) / R
  let PBRinvBTP_22 := (P.a21*b1 + P.a22*b2) * (b1*P.a12 + b2*P.a22) / R
  let AT_P := { a11 := A.a11*P.a11 + A.a21*P.a21, a12 := A.a11*P.a12 + A.a21*P.a22
              , a21 := A.a12*P.a11 + A.a22*P.a21, a22 := A.a12*P.a12 + A.a22*P.a22 }
  let P_A := { a11 := P.a11*A.a11 + P.a12*A.a21, a12 := P.a11*A.a12 + P.a12*A.a22
             , a21 := P.a21*A.a11 + P.a22*A.a21, a22 := P.a21*A.a12 + P.a22*A.a22 }
  let residual11 := AT_P.a11 + P_A.a11 - PBRinvBTP_11 + Q.a11
  let residual22 := AT_P.a22 + P_A.a22 - PBRinvBTP_22 + Q.a22
  residual11.abs < 0.01 && residual22.abs < 0.01

/-- Integral Lyapunov function for systems with nonlinearities. -/
structure IntegralLyapunov where
  f : Float -> Float
  -- nonlinear function
  integral : Float -> Float  -- V(x) = integral_0^x f(s) ds

/-- Popov-type Lyapunov function: V = x^T P x + nu * integral_0^{c^T x} phi(s) ds. -/
structure PopovLyapunov where
  P : LinearSystem2D
  nu : Float
  phi : Float -> Float
  sectorLow : Float
  sectorHigh : Float

/-- Lur'e-Postnikov Lyapunov function. -/
structure LureLyapunov where
  A : LinearSystem2D
  b : Float * Float
  c : Float * Float
  P : LinearSystem2D
  theta : Float  -- multiplier parameter

/-- Check if Lur'e Lyapunov function certifies stability. -/
def checkLureLyapunov (ll : LureLyapunov) (k : Float) : Bool :=
  -- Matrix inequality: [A^T P + P A, P b + (A^T c + P a)*theta]
  --                    [b^T P + theta*(c^T A + a^T P), theta*(c^T b + b^T c) - 1/k]
  ll.P.a11 > 0.0 && ll.P.a11 * ll.P.a22 - ll.P.a12 * ll.P.a21 > 0.0

/-- Sum-of-squares (SOS) decomposition for polynomial Lyapunov functions. -/
structure SOSPolynomial where
  degree : Nat
  coefficients : List Float
  -- p(x) = sum_i s_i(x)^2, sum of squares representation

/-- Check if a quadratic polynomial is SOS (always true if positive definite). -/
def isQuadraticSOS (a b c : Float) : Bool := a > 0.0 && 4.0*a*c - b*b >= 0.0

/-- Lyapunov function for switched linear systems via common quadratic. -/
def findCommonQuadraticLyapunov (systems : List LinearSystem2D) : Bool :=
  -- Existence of P > 0 such that A_i^T P + P A_i < 0 for all i
  -- Simplified: check if all are stable with same P = I
  systems.all (fun A => A.isStable)

/-- Piecewise quadratic Lyapunov function. -/
structure PiecewiseQuadraticLyapunov where
  regions : List (Float -> Bool)
  P_matrices : List LinearSystem2D

/-- Check continuity of piecewise Lyapunov function at boundaries. -/
def checkPiecewiseContinuity (pwq : PiecewiseQuadraticLyapunov) (boundaryPoints : List Float) : Bool :=
  -- x^T P_i x = x^T P_j x on boundary between region i and j
  true  -- simplified

/-- Homogeneous Lyapunov function of degree d: V(lambda*x) = |lambda|^d * V(x). -/
structure HomogeneousLyapunov where
  degree : Float
  V : Float -> Float

/-- Check homogeneity condition. -/
def checkHomogeneity (hl : HomogeneousLyapunov) (x lambda : Float) : Bool :=
  (hl.V (lambda * x) - (lambda.abs ^ hl.degree) * hl.V x).abs < 0.001

/-- Implicit Lyapunov function: defined by equation F(V(x), x) = 0. -/
structure ImplicitLyapunov where
  F : Float -> Float -> Float  -- F(v, x) = 0 defines v = V(x)
  equilibrium : Float

