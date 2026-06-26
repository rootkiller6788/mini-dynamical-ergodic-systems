/-
# Bifurcation Theory: Part 3

Extended formalization of bifurcation theory concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== Part 3: Bifurcation Analysis ==="

/-! ## Section 3.1: Basic Definitions -/
def ex3_f (x : Rat) : Rat := x + (3:Rat)/10 - x*x
#eval ex3_f 0
#eval ex3_f 1

def ex3_fp (mu : Rat) : List Rat :=
  if mu > 0 then [sqrtRat mu, -sqrtRat mu] else if mu == 0 then [0] else []
#eval ex3_fp ((1:Rat)/30)
#eval ex3_fp 0
#eval ex3_fp (-(1:Rat)/30)

/-! ## Section 3.2: Stability Analysis -/
def ex3_deriv (x : Rat) : Rat := 1 - 2*x
def ex3_stable (x : Rat) : Bool := absRat (ex3_deriv x) < 1

#eval ex3_stable 0
#eval ex3_stable ((1:Rat)/2)
#eval ex3_stable 1

/-! ## Section 3.3: Orbit Computation -/
def ex3_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (3:Rat)/10 - x*x) x0 i) (List.range n)

#eval (ex3_orbit ((1:Rat)/2) 10).length
#eval (ex3_orbit 0 10).length

/-! ## Section 3.4: Parameter Family -/
def ex3_family : ParameterFamily Rat Rat :=
  { f := fun mu x => x + mu - x*x }

#eval ex3_family.f 0 0
#eval ex3_family.f ((1:Rat)/4) ((1:Rat)/2)
#eval ParameterFamily.iterate ex3_family ((1:Rat)/4) 0 ((1:Rat)/2)
#eval ParameterFamily.iterate ex3_family ((1:Rat)/4) 10 ((1:Rat)/2)

/-! ## Section 3.5: Bifurcation Detection -/
def ex3_domain : List Rat := [-2, -1, -0.5, 0, 0.5, 1, 2]
#eval detectFixedPointBifurcation ex3_family ex3_domain (-(1:Rat)/4) ((1:Rat)/4)

/-! ## Section 3.6: Normal Forms -/
def ex3_nf_sn : NormalForm := normalFormSaddleNode
def ex3_nf_tr : NormalForm := normalFormTranscritical
def ex3_nf_pf : NormalForm := normalFormPitchforkSuper
def ex3_nf_pd : NormalForm := normalFormPeriodDoubling

#eval ex3_nf_sn.bType
#eval ex3_nf_tr.bType
#eval ex3_nf_pf.bType
#eval ex3_nf_pd.bType

/-! ## Section 3.7: Polynomial Construction -/
def ex3_poly : Polynomial := { coeffs := [3, 3+1, 3-1] }
#eval ex3_poly.eval 0
#eval ex3_poly.eval 1
#eval ex3_poly.eval 2
#eval ex3_poly.derivAt 0
#eval ex3_poly.derivAt 1

/-! ## Section 3.8: Stability Classification -/
def ex3_classify (x : Rat) : String :=
  let f := fun y : Rat => y + (3:Rat)/10 - y*y
  let d := fun y : Rat => 1 - 2*y
  if absRat (f x - x) > (1:Rat)/1000 then "not fp"
  else if absRat (d x) < 1 then "stable"
  else if absRat (d x) > 1 then "unstable"
  else "marginal"

#eval ex3_classify 0
#eval ex3_classify ((1:Rat)/2)

/-! ## Section 3.9: Grid Search -/
def ex3_grid : List Rat :=
  let h := (2:Rat)/(50:Rat)
  List.map (fun j => -1 + (j:Rat)*h) (List.range 51)

#eval (List.filter (fun x => ex3_f x == x) ex3_grid).length

/-! ## Section 3.10: Bifurcation Types -/
def ex3_types : List BifurcationType :=
  [.saddleNode, .transcritical, .pitchfork true, .pitchfork false, .periodDoubling, .hopf]
def ex3_codims : List Nat := List.map codimension ex3_types

/-! ## Section 3.11: Phase Portrait -/
def ex3_portrait : PhasePortrait1D :=
  buildPhasePortrait1D ex3_f ex3_deriv ex3_grid

/-! ## Section 3.12: Continuous System -/
def ex3_cds : ContinuousDS Rat :=
  { vf := { v := fun x : Rat => (3:Rat)/10 - x*x } }
#eval ex3_cds.eulerStep ((1:Rat)/100) 0
#eval ex3_cds.eulerStep ((1:Rat)/100) 1

/-! ## Section 3.13: Gradient System -/
def ex3_gs : GradientSystem :=
  { potential := { coeffs := [0, -(3:Rat)/10, 0, (1:Rat)/3] }, stateSpace := 0 }
#eval ex3_gs.vectorField 0
#eval ex3_gs.vectorField 1

/-! ## Section 3.14: Structural Stability -/
#eval isStructurallyStable ex3_f ex3_deriv ex3_grid

/-! ## Section 3.15: Invariant Sets -/
def ex3_invariant (A : Rat -> Bool) : Prop :=
  isForwardInvariant ex3_f A

/-! ## Section 3.16: Discrete System -/
def ex3_ds : DiscreteDS Rat := { f := ex3_f }
#eval ex3_ds.iterate 0 0
#eval ex3_ds.iterate 1 0
#eval ex3_ds.iterate 5 0

/-! ## Section 3.17: Fixed Point Count -/
#eval fixedPointCount ex3_f ex3_grid

/-! ## Section 3.18: Periodic Point Count -/
#eval periodicPointCount ex3_f ex3_grid 1
#eval periodicPointCount ex3_f ex3_grid 2

/-! ## Section 3.19: Entropy -/
#eval topologicalEntropyApprox ex3_f ex3_grid 10

/-! ## Section 3.20: Complete -/
#eval "=== Part 3 Complete ==="

/-! ## Extended Analysis for Part 3 -/
#eval "=== Extended Part 3 ==="
def ext3_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (3:Rat)/10 - x*x) x0 i) (List.range n)
#eval (ext3_orbit ((1:Rat)/2) 20).length
#eval (ext3_orbit 0 20).length
