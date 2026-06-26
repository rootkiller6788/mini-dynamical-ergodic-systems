/-
# Pitchfork Bifurcation: Complete Analysis

Comprehensive analysis of the pitchfork bifurcation
f(x,mu) = x + mu*x - x^3 (supercritical) and f(x,mu) = x + mu*x + x^3 (subcritical)
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

/-! ## Supercritical Pitchfork -/
def pfSuper (mu x : Rat) : Rat := x + mu*x - x*x*x

def pfSuperFp (mu : Rat) : List Rat :=
  if mu > 0 then [sqrtRat mu, 0, -sqrtRat mu] else [0]

def pfSuperDeriv (mu x : Rat) : Rat := 1 + mu - 3*x*x

def pfSuperX0Stable (mu : Rat) : Bool := absRat (pfSuperDeriv mu 0) < 1
def pfSuperXpStable (mu : Rat) : Bool := absRat (pfSuperDeriv mu (sqrtRat mu)) < 1

#eval "=== Supercritical Pitchfork Fixed Points ==="
#eval pfSuperFp (-(1:Rat)/2)
#eval pfSuperFp 0
#eval pfSuperFp ((1:Rat)/4)
#eval pfSuperFp ((1:Rat)/2)
#eval pfSuperFp 1
#eval pfSuperFp 2

#eval "=== Supercritical Pitchfork Stability ==="
#eval pfSuperX0Stable (-(1:Rat)/2)
#eval pfSuperX0Stable 0
#eval pfSuperX0Stable ((1:Rat)/4)
#eval pfSuperX0Stable ((1:Rat)/2)
#eval pfSuperXpStable ((1:Rat)/4)
#eval pfSuperXpStable ((1:Rat)/2)
#eval pfSuperXpStable 1

/-! ## Subcritical Pitchfork -/
def pfSub (mu x : Rat) : Rat := x + mu*x + x*x*x

def pfSubFp (mu : Rat) : List Rat :=
  if mu < 0 then [sqrtRat (-mu), 0, -sqrtRat (-mu)] else [0]

def pfSubDeriv (mu x : Rat) : Rat := 1 + mu + 3*x*x

def pfSubX0Stable (mu : Rat) : Bool := absRat (pfSubDeriv mu 0) < 1

#eval "=== Subcritical Pitchfork Fixed Points ==="
#eval pfSubFp (-(1:Rat)/2)
#eval pfSubFp (-(1:Rat)/4)
#eval pfSubFp 0
#eval pfSubFp ((1:Rat)/4)
#eval pfSubFp ((1:Rat)/2)

#eval "=== Subcritical Pitchfork Stability ==="
#eval pfSubX0Stable (-(1:Rat)/2)
#eval pfSubX0Stable (-(1:Rat)/4)
#eval pfSubX0Stable 0
#eval pfSubX0Stable ((1:Rat)/4)
#eval pfSubX0Stable ((1:Rat)/2)

/-! ## Symmetry Analysis -/
def pfSymmetric (f : Rat -> Rat) : Bool :=
  let grid := [-2, -1, 0, 1, 2]
  List.all grid (fun x => f (-x) == -(f x))

def pfTestFn (mu : Rat) (x : Rat) : Rat := x + mu*x - x*x*x

#eval pfSymmetric (fun x => pfTestFn 0 x)
#eval pfSymmetric (fun x => pfTestFn ((1:Rat)/2) x)

/-! ## Bifurcation Regime Detection -/
def pfRegime (mu : Rat) (sc : Bool) : String :=
  if sc then
    if mu < 0 then "trivial-stable"
    else if mu == 0 then "bifurcation-point"
    else if mu < 1 then "three-fp-outer-stable"
    else "three-fp-outer-unstable"
  else
    if mu < -1 then "three-fp-outer-unstable"
    else if mu < 0 then "three-fp"
    else "trivial-unstable"

#eval "=== Pitchfork Regimes ==="
#eval pfRegime (-2) true
#eval pfRegime (-(1:Rat)/2) true
#eval pfRegime 0 true
#eval pfRegime ((1:Rat)/4) true
#eval pfRegime ((1:Rat)/2) true
#eval pfRegime 1 true
#eval pfRegime 2 true

#eval pfRegime (-2) false
#eval pfRegime (-(1:Rat)/2) false
#eval pfRegime 0 false
#eval pfRegime ((1:Rat)/4) false
#eval pfRegime 1 false

/-! ## Orbit Analysis -/
def pfOrbit (mu x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => pfSuper mu x) x0 i) (List.range (n+1))

#eval (pfOrbit ((1:Rat)/4) ((1:Rat)/10) 20).length
#eval (pfOrbit ((1:Rat)/4) ((3:Rat)/5) 20).length
#eval (pfOrbit (-(1:Rat)/4) ((1:Rat)/10) 20).length

/-! ## Derivative Analysis -/
def pfDerivSign (mu x : Rat) (sc : Bool) : Int :=
  let d := if sc then 1 + mu - 3*x*x else 1 + mu + 3*x*x
  if d > 0 then 1 else if d < 0 then -1 else 0

#eval pfDerivSign ((1:Rat)/2) 0 true
#eval pfDerivSign ((1:Rat)/2) (sqrtRat ((1:Rat)/2)) true
#eval pfDerivSign (-(1:Rat)/2) 0 true

/-! ## Systematic Analysis -/
def pfAnalysis (muVals : List Rat) : IO Unit := do
  for mu in muVals do
    let sc_fps := pfSuperFp mu
    let sb_fps := pfSubFp mu
    IO.println s!"mu={mu}: super_fps={sc_fps}, sub_fps={sb_fps}"

#eval pfAnalysis [-(3:Rat)/4, -(1:Rat)/2, -(1:Rat)/4, 0, (1:Rat)/4, (1:Rat)/2, (3:Rat)/4, 1]

/-! ## Normal Form Verification -/
def pfNormalFormCheck (mu : Rat) : Bool :=
  pfSuper mu 0 == 0 /\ pfSuper mu (sqrtRat mu) == sqrtRat mu

#eval pfNormalFormCheck ((1:Rat)/4)
#eval pfNormalFormCheck ((1:Rat)/2)

/-! ## Complete Pitchfork Analysis -/
#eval "=== Pitchfork Bifurcation Analysis Complete ==="
