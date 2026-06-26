/-
# Stability Theory: Core Objects
Linear systems, nonlinear oscillators, stability matrices with Float.
## Knowledge Levels: L1-L2
-/
import MiniStabilityTheory.Core.Basic
namespace MiniStabilityTheory

/-- A 2D linear system: dx/dt = A x. -/
structure LinearSystem2D where
  a11 : Float
  a12 : Float
  a21 : Float
  a22 : Float

def LinearSystem2D.eval (sys : LinearSystem2D) (x y : Float) : Float :=
  sys.a11 * x + sys.a12 * y
  -- Note: returns only first component in this simplified version

def LinearSystem2D.trace (sys : LinearSystem2D) : Float := sys.a11 + sys.a22

def LinearSystem2D.det (sys : LinearSystem2D) : Float := sys.a11 * sys.a22 - sys.a12 * sys.a21

def LinearSystem2D.discriminant (sys : LinearSystem2D) : Float :=
  sys.trace * sys.trace - 4.0 * sys.det

def LinearSystem2D.eigenvalues (sys : LinearSystem2D) : List Float :=
  let tr := sys.trace
  let disc := sys.discriminant
  if disc >= 0.0 then
    let sqrtD := Float.sqrt disc
    [(tr + sqrtD) / 2.0, (tr - sqrtD) / 2.0]
  else [tr / 2.0, tr / 2.0]

def LinearSystem2D.classify (sys : LinearSystem2D) : StabilityType :=
  let tr := sys.trace
  let det := sys.det
  let disc := sys.discriminant
  if det < 0.0 then .saddle
  else if det == 0.0 then .degenerate
  else if disc > 0.0 then
    if tr < 0.0 then .stableNode else if tr > 0.0 then .unstableNode else .center
  else if disc < 0.0 then
    if tr < 0.0 then .stableFocus else if tr > 0.0 then .unstableFocus else .center
  else
    if tr < 0.0 then .stableNode else if tr > 0.0 then .unstableNode else .degenerate

def LinearSystem2D.isStable (sys : LinearSystem2D) : Bool :=
  sys.trace < 0.0 && sys.det > 0.0

def LinearSystem2D.isStableRouthHurwitz (sys : LinearSystem2D) : Bool :=
  sys.trace < 0.0 && sys.det > 0.0

structure LinearDiscreteSystem2D where
  a11 : Float
  a12 : Float
  a21 : Float
  a22 : Float
  

def LinearDiscreteSystem2D.isOriginStable (sys : LinearDiscreteSystem2D) : Bool :=
  let tr := sys.a11 + sys.a22
  let det := sys.a11 * sys.a22 - sys.a12 * sys.a21
  det.abs < 1.0 && tr.abs < 1.0 + det

structure NonlinearOscillator where
  f : Float -> Float -> Float
  mass : Float
  damping : Float

def vanDerPol (mu : Float) : NonlinearOscillator :=
  { f := fun x v => x + mu * (x*x - 1.0) * v, mass := 1.0, damping := 0.0 }

def duffing (alpha beta delta : Float) : NonlinearOscillator :=
  { f := fun x _ => alpha * x + beta * x * x * x, mass := 1.0, damping := delta }

structure StabilityMatrix where
  size : Nat
  entries : List (List Float)
  

structure QuadraticLyapunov where
  P : LinearSystem2D
  A : LinearSystem2D
  Q : LinearSystem2D

def QuadraticLyapunov.eval (ql : QuadraticLyapunov) (x y : Float) : Float :=
  ql.P.a11 * x * x + 2.0 * ql.P.a12 * x * y + ql.P.a22 * y * y

def harmonicEnergy (omega x v : Float) : Float := v*v / 2.0 + omega*omega * x*x / 2.0

def pendulumEnergy (g L x v : Float) : Float := v*v / 2.0 + (g / L) * (1.0 - Float.cos x)

structure StabilityDomain where
  paramNames : List String
  boundaries : List (List Float -> Bool)

def StabilityDomain.contains (sd : StabilityDomain) (params : List Float) : Bool :=
  sd.boundaries.all (fun b => b params)

structure LinearSystem3D where
  a11 : Float
  a12 : Float
  a13 : Float
  a21 : Float
  a22 : Float
  a23 : Float
  a31 : Float
  a32 : Float
  a33 : Float
  

def LinearSystem3D.trace (sys : LinearSystem3D) : Float := sys.a11 + sys.a22 + sys.a33

structure StateSpace where
  A : LinearSystem2D
  B1 : Float
  B2 : Float
  C1 : Float
  C2 : Float
  D : Float
  

def StateSpace.isStable (ss : StateSpace) : Bool := ss.A.isStable

structure TransferFunction where
  num : List Float
  den : List Float
  

def TransferFunction.isStable (tf : TransferFunction) : Bool :=
  match tf.den with
  | [a1, a0] => a1 > 0.0 && a0 > 0.0
  | [a2, a1, a0] => a2 > 0.0 && a1 > 0.0 && a0 > 0.0 && a2 * a1 > a0
  | _ => false

structure BodeData where
  frequencies : List Float
  magnitudes : List Float
  phases : List Float
  

def firstOrderMagnitude (gain tau omega : Float) : Float :=
  gain / Float.sqrt (1.0 + (tau * omega) * (tau * omega))

def firstOrderPhase (tau omega : Float) : Float :=
  -Float.atan (tau * omega) * 180.0 / pi

def firstOrderStepResponse (gain tau t : Float) : Float :=
  gain * (1.0 - Float.exp (-t / tau))

def firstOrderImpulseResponse (gain tau t : Float) : Float :=
  (gain / tau) * Float.exp (-t / tau)

def secondOrderStepResponse (wn zeta t : Float) : Float :=
  if zeta < 1.0 then
    let wd := wn * Float.sqrt (1.0 - zeta*zeta)
    let phi := Float.atan (Float.sqrt (1.0 - zeta*zeta) / zeta)
    1.0 - Float.exp (-zeta * wn * t) * Float.sin (wd * t + phi) / Float.sqrt (1.0 - zeta*zeta)
  else if zeta == 1.0 then
    1.0 - Float.exp (-wn * t) * (1.0 + wn * t)
  else 0.0

def solveLyapunov2D (A Q : LinearSystem2D) : LinearSystem2D :=
  if A.isStable then { a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 1.0 }
  else { a11 := 0.0, a12 := 0.0, a21 := 0.0, a22 := 0.0 }

def solveDiscreteLyapunov2D (A Q : LinearDiscreteSystem2D) : LinearSystem2D :=
  if A.isOriginStable then { a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 1.0 }
  else { a11 := 0.0, a12 := 0.0, a21 := 0.0, a22 := 0.0 }

structure Gramians where
  controllabilityGramian : LinearSystem2D
  observabilityGramian : LinearSystem2D

def isControllableViaGramian (Wc : LinearSystem2D) : Bool :=
  Wc.a11 > 0.0 && Wc.a11 * Wc.a22 - Wc.a12 * Wc.a21 > 0.0

def isBalanced (Wc Wo : LinearSystem2D) : Bool :=
  (Wc.a11 - Wo.a11).abs < 0.001 && (Wc.a22 - Wo.a22).abs < 0.001

def hankelSingularValues (Wc Wo : LinearSystem2D) : List Float :=
  let prod : LinearSystem2D :=
    { a11 := Wc.a11*Wo.a11 + Wc.a12*Wo.a21,
      a12 := Wc.a11*Wo.a12 + Wc.a12*Wo.a22,
      a21 := Wc.a21*Wo.a11 + Wc.a22*Wo.a21,
      a22 := Wc.a21*Wo.a12 + Wc.a22*Wo.a22 }
  prod.eigenvalues.map Float.sqrt

end MiniStabilityTheory