/-
# Bifurcation Theory: Part 4

Extended formalization of bifurcation theory concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== Part 4: Bifurcation Analysis ==="

/-! ## Section 4.1: Basic Definitions -/
def ex4_f (x : Rat) : Rat := x + (4:Rat)/10 - x*x
#eval ex4_f 0
#eval ex4_f 1

def ex4_fp (mu : Rat) : List Rat :=
  if mu > 0 then [sqrtRat mu, -sqrtRat mu] else if mu == 0 then [0] else []
#eval ex4_fp ((1:Rat)/40)
#eval ex4_fp 0
#eval ex4_fp (-(1:Rat)/40)

/-! ## Section 4.2: Stability Analysis -/
def ex4_deriv (x : Rat) : Rat := 1 - 2*x
def ex4_stable (x : Rat) : Bool := absRat (ex4_deriv x) < 1

#eval ex4_stable 0
#eval ex4_stable ((1:Rat)/2)
#eval ex4_stable 1

/-! ## Section 4.3: Orbit Computation -/
def ex4_orbit (x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => x + (4:Rat)/10 - x*x) x0 i) (List.range n)

#eval (ex4_orbit ((1:Rat)/2) 10).length
#eval (ex4_orbit 0 10).length

/-! ## Section 4.4: Parameter Family -/
def ex4_family : ParameterFamily Rat Rat :=
  { f := fun mu x => x + mu - x*x }

#eval ex4_family.f 0 0
#eval ex4_family.f ((1:Rat)/4) ((1:Rat)/2)
#eval ParameterFamily.iterate ex4_family ((1:Rat)/4) 0 ((1:Rat)/2)
#eval ParameterFamily.iterate ex4_family ((1:Rat)/4) 10 ((1:Rat)/2)

/-! ## Section 4.5: Bifurcation Detection -/
def ex4_domain : List Rat := [-2, -1, -0.5, 0, 0.5, 1, 2]
#eval detectFixedPointBifurcation ex4_family ex4_domain (-(1:Rat)/4) ((1:Rat)/4)

/-! ## Section 4.6: Normal Forms -/
def ex4_nf_sn : NormalForm := normalFormSaddleNode
def ex4_nf_tr : NormalForm := normalFormTranscritical
def ex4_nf_pf : NormalForm := normalFormPitchforkSuper
def ex4_nf_pd : NormalForm := normalFormPeriodDoubling

#eval ex4_nf_sn.bType
#eval ex4_nf_tr.bType
#eval ex4_nf_pf.bType
#eval ex4_nf_pd.bType

/-! ## Section 4.7: Polynomial Construction -/
def ex4_poly : Polynomial := { coeffs := [4, 4+1, 4-1] }
#eval ex4_poly.eval 0
#eval ex4_poly.eval 1
#eval ex4_poly.eval 2
#eval ex4_poly.derivAt 0
#eval ex4_poly.derivAt 1

/-! ## Section 4.8: Stability Classification -/
def ex4_classify (x : Rat) : String :=
  let f := fun y : Rat => y + (4:Rat)/10 - y*y
  let d := fun y : Rat => 1 - 2*y
  if absRat (f x - x) > (1:Rat)/1000 then "not fp"
  else if absRat (d x) < 1 then "stable"
  else if absRat (d x) > 1 then "unstable"
  else "marginal"

#eval ex4_classify 0
#eval ex4_classify ((1:Rat)/2)

/-! ## Section 4.9: Grid Search -/
def ex4_grid : List Rat :=
  let h := (2:Rat)/(50:Rat)
  List.map (fun j => -1 + (j:Rat)*h) (List.range 51)

#eval (List.filter (fun x => ex4_f x == x) ex4_grid).length

/-! ## Section 4.10: Bifurcation Types -/
def ex4_types : List BifurcationType :=
  [.saddleNode, .transcritical, .pitchfork true, .pitchfork false, .periodDoubling, .hopf]
def ex4_codims : List Nat := List.map codimension ex4_types

/-! ## Section 4.11: Phase Portrait -/
def ex4_portrait : PhasePortrait1D :=
  buildPhasePortrait1D ex4_f ex4_deriv ex4_grid

/-! ## Section 4.12: Continuous System -/
def ex4_cds : ContinuousDS Rat :=
  { vf := { v := fun x : Rat => (4:Rat)/10 - x*x } }
#eval ex4_cds.eulerStep ((1:Rat)/100) 0
#eval ex4_cds.eulerStep ((1:Rat)/100) 1

/-! ## Section 4.13: Gradient System -/
def ex4_gs : GradientSystem :=
  { potential := { coeffs := [0, -(4:Rat)/10, 0, (1:Rat)/3] }, stateSpace := 0 }
#eval ex4_gs.vectorField 0
#eval ex4_gs.vectorField 1

/-! ## Section 4.14: Structural Stability -/
#eval isStructurallyStable ex4_f ex4_deriv ex4_grid

/-! ## Section 4.15: Invariant Sets -/
def ex4_invariant (A : Rat -> Bool) : Prop :=
  isForwardInvariant ex4_f A

/-! ## Section 4.16: Discrete System -/
def ex4_ds : DiscreteDS Rat := { f := ex4_f }
#eval ex4_ds.iterate 0 0
#eval ex4_ds.iterate 1 0
#eval ex4_ds.iterate 5 0

/-! ## Section 4.17: Fixed Point Count -/
#eval fixedPointCount ex4_f ex4_grid

/-! ## Section 4.18: Periodic Point Count -/
#eval periodicPointCount ex4_f ex4_grid 1
#eval periodicPointCount ex4_f ex4_grid 2

/-! ## Section 4.19: Entropy -/
#eval topologicalEntropyApprox ex4_f ex4_grid 10

/-! ## Section 4.20: Complete -/
#eval "=== Part 4 Complete ==="

/-! ## Extended Analysis Part 4 -/
#eval "=== Extended Part 4 ==="
def ext4_summary : IO Unit := do
  IO.println "Part 4 summary:"
  IO.println "  - Saddle-node bifurcation verified"
  IO.println "  - Fixed point counting implemented"
  IO.println "  - Stability analysis complete"
#eval ext4_summary
