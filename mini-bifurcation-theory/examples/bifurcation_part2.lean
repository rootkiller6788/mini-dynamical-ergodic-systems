/-
# Bifurcation Theory: Part 2

Extended formalization of bifurcation theory concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== Part 2: Bifurcation Analysis ==="

/-! ## Section 2.1: Basic Definitions -/
def ex2_f (x : Rat) : Rat := x + (2:Rat)/10 - x*x
#eval ex2_f 0
#eval ex2_f 1

def ex2_fp (mu : Rat) : List Rat :=
  if mu > 0 then [sqrtRat mu, -sqrtRat mu] else if mu == 0 then [0] else []
#eval ex2_fp ((1:Rat)/20)
#eval ex2_fp 0
#eval ex2_fp (-(1:Rat)/20)

/-! ## Section 2.2: Stability Analysis -/
def ex2_deriv (x : Rat) : Rat := 1 - 2*x
def ex2_stable (x : Rat) : Bool := absRat (ex2_deriv x) < 1

#eval ex2_stable 0
#eval ex2_stable ((1:Rat)/2)
#eval ex2_stable 1

/-! ## Section 2.3: Orbit Computation -/
def ex2_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (2:Rat)/10 - x*x) x0 i) (List.range n)

#eval (ex2_orbit ((1:Rat)/2) 10).length
#eval (ex2_orbit 0 10).length

/-! ## Section 2.4: Parameter Family -/
def ex2_family : ParameterFamily Rat Rat :=
  { f := fun mu x => x + mu - x*x }

#eval ex2_family.f 0 0
#eval ex2_family.f ((1:Rat)/4) ((1:Rat)/2)
#eval ParameterFamily.iterate ex2_family ((1:Rat)/4) 0 ((1:Rat)/2)
#eval ParameterFamily.iterate ex2_family ((1:Rat)/4) 10 ((1:Rat)/2)

/-! ## Section 2.5: Bifurcation Detection -/
def ex2_domain : List Rat := [-2, -1, -0.5, 0, 0.5, 1, 2]
#eval detectFixedPointBifurcation ex2_family ex2_domain (-(1:Rat)/4) ((1:Rat)/4)

/-! ## Section 2.6: Normal Forms -/
def ex2_nf_sn : NormalForm := normalFormSaddleNode
def ex2_nf_tr : NormalForm := normalFormTranscritical
def ex2_nf_pf : NormalForm := normalFormPitchforkSuper
def ex2_nf_pd : NormalForm := normalFormPeriodDoubling

#eval ex2_nf_sn.bType
#eval ex2_nf_tr.bType
#eval ex2_nf_pf.bType
#eval ex2_nf_pd.bType

/-! ## Section 2.7: Polynomial Construction -/
def ex2_poly : Polynomial := { coeffs := [2, 2+1, 2-1] }
#eval ex2_poly.eval 0
#eval ex2_poly.eval 1
#eval ex2_poly.eval 2
#eval ex2_poly.derivAt 0
#eval ex2_poly.derivAt 1

/-! ## Section 2.8: Stability Classification -/
def ex2_classify (x : Rat) : String :=
  let f := fun y : Rat => y + (2:Rat)/10 - y*y
  let d := fun y : Rat => 1 - 2*y
  if absRat (f x - x) > (1:Rat)/1000 then "not fp"
  else if absRat (d x) < 1 then "stable"
  else if absRat (d x) > 1 then "unstable"
  else "marginal"

#eval ex2_classify 0
#eval ex2_classify ((1:Rat)/2)

/-! ## Section 2.9: Grid Search -/
def ex2_grid : List Rat :=
  let h := (2:Rat)/(50:Rat)
  List.map (fun j => -1 + (j:Rat)*h) (List.range 51)

#eval (List.filter (fun x => ex2_f x == x) ex2_grid).length

/-! ## Section 2.10: Bifurcation Types -/
def ex2_types : List BifurcationType :=
  [.saddleNode, .transcritical, .pitchfork true, .pitchfork false, .periodDoubling, .hopf]
def ex2_codims : List Nat := List.map codimension ex2_types

/-! ## Section 2.11: Phase Portrait -/
def ex2_portrait : PhasePortrait1D :=
  buildPhasePortrait1D ex2_f ex2_deriv ex2_grid

/-! ## Section 2.12: Continuous System -/
def ex2_cds : ContinuousDS Rat :=
  { vf := { v := fun x : Rat => (2:Rat)/10 - x*x } }
#eval ex2_cds.eulerStep ((1:Rat)/100) 0
#eval ex2_cds.eulerStep ((1:Rat)/100) 1

/-! ## Section 2.13: Gradient System -/
def ex2_gs : GradientSystem :=
  { potential := { coeffs := [0, -(2:Rat)/10, 0, (1:Rat)/3] }, stateSpace := 0 }
#eval ex2_gs.vectorField 0
#eval ex2_gs.vectorField 1

/-! ## Section 2.14: Structural Stability -/
#eval isStructurallyStable ex2_f ex2_deriv ex2_grid

/-! ## Section 2.15: Invariant Sets -/
def ex2_invariant (A : Rat -> Bool) : Prop :=
  isForwardInvariant ex2_f A

/-! ## Section 2.16: Discrete System -/
def ex2_ds : DiscreteDS Rat := { f := ex2_f }
#eval ex2_ds.iterate 0 0
#eval ex2_ds.iterate 1 0
#eval ex2_ds.iterate 5 0

/-! ## Section 2.17: Fixed Point Count -/
#eval fixedPointCount ex2_f ex2_grid

/-! ## Section 2.18: Periodic Point Count -/
#eval periodicPointCount ex2_f ex2_grid 1
#eval periodicPointCount ex2_f ex2_grid 2

/-! ## Section 2.19: Entropy -/
#eval topologicalEntropyApprox ex2_f ex2_grid 10

/-! ## Section 2.20: Complete -/
#eval "=== Part 2 Complete ==="

/-! ## Extended Analysis for Part 2 -/
#eval "=== Extended Part 2 ==="
def ext2_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (2:Rat)/10 - x*x) x0 i) (List.range n)
#eval (ext2_orbit ((1:Rat)/2) 20).length
#eval (ext2_orbit 0 20).length
