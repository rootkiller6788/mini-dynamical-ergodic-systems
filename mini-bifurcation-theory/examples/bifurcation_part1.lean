/-
# Bifurcation Theory: Part 1

Extended formalization of bifurcation theory concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== Part 1: Bifurcation Analysis ==="

/-! ## Section 1.1: Basic Definitions -/
def ex1_f (x : Rat) : Rat := x + (1:Rat)/10 - x*x
#eval ex1_f 0
#eval ex1_f 1

def ex1_fp (mu : Rat) : List Rat :=
  if mu > 0 then [sqrtRat mu, -sqrtRat mu] else if mu == 0 then [0] else []
#eval ex1_fp ((1:Rat)/10)
#eval ex1_fp 0
#eval ex1_fp (-(1:Rat)/10)

/-! ## Section 1.2: Stability Analysis -/
def ex1_deriv (x : Rat) : Rat := 1 - 2*x
def ex1_stable (x : Rat) : Bool := absRat (ex1_deriv x) < 1

#eval ex1_stable 0
#eval ex1_stable ((1:Rat)/2)
#eval ex1_stable 1

/-! ## Section 1.3: Orbit Computation -/
def ex1_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (1:Rat)/10 - x*x) x0 i) (List.range n)

#eval (ex1_orbit ((1:Rat)/2) 10).length
#eval (ex1_orbit 0 10).length

/-! ## Section 1.4: Parameter Family -/
def ex1_family : ParameterFamily Rat Rat :=
  { f := fun mu x => x + mu - x*x }

#eval ex1_family.f 0 0
#eval ex1_family.f ((1:Rat)/4) ((1:Rat)/2)
#eval ParameterFamily.iterate ex1_family ((1:Rat)/4) 0 ((1:Rat)/2)
#eval ParameterFamily.iterate ex1_family ((1:Rat)/4) 10 ((1:Rat)/2)

/-! ## Section 1.5: Bifurcation Detection -/
def ex1_domain : List Rat := [-2, -1, -0.5, 0, 0.5, 1, 2]
#eval detectFixedPointBifurcation ex1_family ex1_domain (-(1:Rat)/4) ((1:Rat)/4)

/-! ## Section 1.6: Normal Forms -/
def ex1_nf_sn : NormalForm := normalFormSaddleNode
def ex1_nf_tr : NormalForm := normalFormTranscritical
def ex1_nf_pf : NormalForm := normalFormPitchforkSuper
def ex1_nf_pd : NormalForm := normalFormPeriodDoubling

#eval ex1_nf_sn.bType
#eval ex1_nf_tr.bType
#eval ex1_nf_pf.bType
#eval ex1_nf_pd.bType

/-! ## Section 1.7: Polynomial Construction -/
def ex1_poly : Polynomial := { coeffs := [1, 1+1, 1-1] }
#eval ex1_poly.eval 0
#eval ex1_poly.eval 1
#eval ex1_poly.eval 2
#eval ex1_poly.derivAt 0
#eval ex1_poly.derivAt 1

/-! ## Section 1.8: Stability Classification -/
def ex1_classify (x : Rat) : String :=
  let f := fun y : Rat => y + (1:Rat)/10 - y*y
  let d := fun y : Rat => 1 - 2*y
  if absRat (f x - x) > (1:Rat)/1000 then "not fp"
  else if absRat (d x) < 1 then "stable"
  else if absRat (d x) > 1 then "unstable"
  else "marginal"

#eval ex1_classify 0
#eval ex1_classify ((1:Rat)/2)

/-! ## Section 1.9: Grid Search -/
def ex1_grid : List Rat :=
  let h := (2:Rat)/(50:Rat)
  List.map (fun j => -1 + (j:Rat)*h) (List.range 51)

#eval (List.filter (fun x => ex1_f x == x) ex1_grid).length

/-! ## Section 1.10: Bifurcation Types -/
def ex1_types : List BifurcationType :=
  [.saddleNode, .transcritical, .pitchfork true, .pitchfork false, .periodDoubling, .hopf]
def ex1_codims : List Nat := List.map codimension ex1_types

/-! ## Section 1.11: Phase Portrait -/
def ex1_portrait : PhasePortrait1D :=
  buildPhasePortrait1D ex1_f ex1_deriv ex1_grid

/-! ## Section 1.12: Continuous System -/
def ex1_cds : ContinuousDS Rat :=
  { vf := { v := fun x : Rat => (1:Rat)/10 - x*x } }
#eval ex1_cds.eulerStep ((1:Rat)/100) 0
#eval ex1_cds.eulerStep ((1:Rat)/100) 1

/-! ## Section 1.13: Gradient System -/
def ex1_gs : GradientSystem :=
  { potential := { coeffs := [0, -(1:Rat)/10, 0, (1:Rat)/3] }, stateSpace := 0 }
#eval ex1_gs.vectorField 0
#eval ex1_gs.vectorField 1

/-! ## Section 1.14: Structural Stability -/
#eval isStructurallyStable ex1_f ex1_deriv ex1_grid

/-! ## Section 1.15: Invariant Sets -/
def ex1_invariant (A : Rat -> Bool) : Prop :=
  isForwardInvariant ex1_f A

/-! ## Section 1.16: Discrete System -/
def ex1_ds : DiscreteDS Rat := { f := ex1_f }
#eval ex1_ds.iterate 0 0
#eval ex1_ds.iterate 1 0
#eval ex1_ds.iterate 5 0

/-! ## Section 1.17: Fixed Point Count -/
#eval fixedPointCount ex1_f ex1_grid

/-! ## Section 1.18: Periodic Point Count -/
#eval periodicPointCount ex1_f ex1_grid 1
#eval periodicPointCount ex1_f ex1_grid 2

/-! ## Section 1.19: Entropy -/
#eval topologicalEntropyApprox ex1_f ex1_grid 10

/-! ## Section 1.20: Complete -/
#eval "=== Part 1 Complete ==="

/-! ## Extended Analysis for Part 1 -/
#eval "=== Extended Part 1 ==="
def ext1_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (1:Rat)/5 - x*x) x0 i) (List.range n)
#eval (ext1_orbit ((1:Rat)/2) 20).length
#eval (ext1_orbit 0 20).length
#eval (ext1_orbit (-(1:Rat)/2) 20).length
