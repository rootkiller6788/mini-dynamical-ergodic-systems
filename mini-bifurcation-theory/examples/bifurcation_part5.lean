/-
# Bifurcation Theory: Part 5

Extended formalization of bifurcation theory concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== Part 5: Bifurcation Analysis ==="

/-! ## Section 5.1: Basic Definitions -/
def ex5_f (x : Rat) : Rat := x + (5:Rat)/10 - x*x
#eval ex5_f 0
#eval ex5_f 1

def ex5_fp (mu : Rat) : List Rat :=
  if mu > 0 then [sqrtRat mu, -sqrtRat mu] else if mu == 0 then [0] else []
#eval ex5_fp ((1:Rat)/50)
#eval ex5_fp 0
#eval ex5_fp (-(1:Rat)/50)

/-! ## Section 5.2: Stability Analysis -/
def ex5_deriv (x : Rat) : Rat := 1 - 2*x
def ex5_stable (x : Rat) : Bool := absRat (ex5_deriv x) < 1

#eval ex5_stable 0
#eval ex5_stable ((1:Rat)/2)
#eval ex5_stable 1

/-! ## Section 5.3: Orbit Computation -/
def ex5_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (5:Rat)/10 - x*x) x0 i) (List.range n)

#eval (ex5_orbit ((1:Rat)/2) 10).length
#eval (ex5_orbit 0 10).length

/-! ## Section 5.4: Parameter Family -/
def ex5_family : ParameterFamily Rat Rat :=
  { f := fun mu x => x + mu - x*x }

#eval ex5_family.f 0 0
#eval ex5_family.f ((1:Rat)/4) ((1:Rat)/2)
#eval ParameterFamily.iterate ex5_family ((1:Rat)/4) 0 ((1:Rat)/2)
#eval ParameterFamily.iterate ex5_family ((1:Rat)/4) 10 ((1:Rat)/2)

/-! ## Section 5.5: Bifurcation Detection -/
def ex5_domain : List Rat := [-2, -1, -0.5, 0, 0.5, 1, 2]
#eval detectFixedPointBifurcation ex5_family ex5_domain (-(1:Rat)/4) ((1:Rat)/4)

/-! ## Section 5.6: Normal Forms -/
def ex5_nf_sn : NormalForm := normalFormSaddleNode
def ex5_nf_tr : NormalForm := normalFormTranscritical
def ex5_nf_pf : NormalForm := normalFormPitchforkSuper
def ex5_nf_pd : NormalForm := normalFormPeriodDoubling

#eval ex5_nf_sn.bType
#eval ex5_nf_tr.bType
#eval ex5_nf_pf.bType
#eval ex5_nf_pd.bType

/-! ## Section 5.7: Polynomial Construction -/
def ex5_poly : Polynomial := { coeffs := [5, 5+1, 5-1] }
#eval ex5_poly.eval 0
#eval ex5_poly.eval 1
#eval ex5_poly.eval 2
#eval ex5_poly.derivAt 0
#eval ex5_poly.derivAt 1

/-! ## Section 5.8: Stability Classification -/
def ex5_classify (x : Rat) : String :=
  let f := fun y : Rat => y + (5:Rat)/10 - y*y
  let d := fun y : Rat => 1 - 2*y
  if absRat (f x - x) > (1:Rat)/1000 then "not fp"
  else if absRat (d x) < 1 then "stable"
  else if absRat (d x) > 1 then "unstable"
  else "marginal"

#eval ex5_classify 0
#eval ex5_classify ((1:Rat)/2)

/-! ## Section 5.9: Grid Search -/
def ex5_grid : List Rat :=
  let h := (2:Rat)/(50:Rat)
  List.map (fun j => -1 + (j:Rat)*h) (List.range 51)

#eval (List.filter (fun x => ex5_f x == x) ex5_grid).length

/-! ## Section 5.10: Bifurcation Types -/
def ex5_types : List BifurcationType :=
  [.saddleNode, .transcritical, .pitchfork true, .pitchfork false, .periodDoubling, .hopf]
def ex5_codims : List Nat := List.map codimension ex5_types

/-! ## Section 5.11: Phase Portrait -/
def ex5_portrait : PhasePortrait1D :=
  buildPhasePortrait1D ex5_f ex5_deriv ex5_grid

/-! ## Section 5.12: Continuous System -/
def ex5_cds : ContinuousDS Rat :=
  { vf := { v := fun x : Rat => (5:Rat)/10 - x*x } }
#eval ex5_cds.eulerStep ((1:Rat)/100) 0
#eval ex5_cds.eulerStep ((1:Rat)/100) 1

/-! ## Section 5.13: Gradient System -/
def ex5_gs : GradientSystem :=
  { potential := { coeffs := [0, -(5:Rat)/10, 0, (1:Rat)/3] }, stateSpace := 0 }
#eval ex5_gs.vectorField 0
#eval ex5_gs.vectorField 1

/-! ## Section 5.14: Structural Stability -/
#eval isStructurallyStable ex5_f ex5_deriv ex5_grid

/-! ## Section 5.15: Invariant Sets -/
def ex5_invariant (A : Rat -> Bool) : Prop :=
  isForwardInvariant ex5_f A

/-! ## Section 5.16: Discrete System -/
def ex5_ds : DiscreteDS Rat := { f := ex5_f }
#eval ex5_ds.iterate 0 0
#eval ex5_ds.iterate 1 0
#eval ex5_ds.iterate 5 0

/-! ## Section 5.17: Fixed Point Count -/
#eval fixedPointCount ex5_f ex5_grid

/-! ## Section 5.18: Periodic Point Count -/
#eval periodicPointCount ex5_f ex5_grid 1
#eval periodicPointCount ex5_f ex5_grid 2

/-! ## Section 5.19: Entropy -/
#eval topologicalEntropyApprox ex5_f ex5_grid 10

/-! ## Section 5.20: Complete -/
#eval "=== Part 5 Complete ==="

/-! ## Extended Analysis Part 5 -/
#eval "=== Extended Part 5 ==="
def ext5_summary : IO Unit := do
  IO.println "Part 5 summary:"
  IO.println "  - Normal forms cataloged"
  IO.println "  - Bifurcation detection tested"
  IO.println "  - All types classified"
#eval ext5_summary
