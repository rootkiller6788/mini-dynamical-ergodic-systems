/-
# Bifurcation Theory: Reference Manual

Complete reference for all bifurcation theory definitions and theorems.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

/-! ## Core Types -/
#eval "=== Core Types ==="
#eval "DiscreteDS: iterated map dynamical system"
#eval "ParameterFamily: mu-parameterized dynamical system"
#eval "Polynomial: coefficient list over Rat"

/-! ## Bifurcation Types -/
#eval "=== Bifurcation Types ==="
#eval s!"saddleNode -> codim={codimension .saddleNode}"
#eval s!"transcritical -> codim={codimension .transcritical}"
#eval s!"pitchfork super -> codim={codimension (.pitchfork true)}"
#eval s!"pitchfork sub -> codim={codimension (.pitchfork false)}"
#eval s!"periodDoubling -> codim={codimension .periodDoubling}"
#eval s!"hopf -> codim={codimension .hopf}"

/-! ## Normal Forms -/
#eval "=== Normal Forms ==="
#eval normalFormSaddleNode
#eval normalFormTranscritical
#eval normalFormPitchforkSuper
#eval normalFormPitchforkSub
#eval normalFormPeriodDoubling

/-! ## Stability Functions -/
#eval "=== Stability Functions ==="
#eval "isLinearlyStable: |f'(x*)| < 1"
#eval "isLinearlyUnstable: |f'(x*)| > 1"
#eval "isHyperbolic: |f'(x*)| != 1"

/-! ## Polynomial Operations -/
#eval "=== Polynomial Operations ==="
def pp : Polynomial := { coeffs := [0, 1, 2] }
#eval pp.eval 0
#eval pp.eval 1
#eval pp.eval 2
#eval pp.derivAt 0
#eval pp.derivAt 1
#eval pp.derivAt 2

/-! ## Phase Portrait Construction -/
#eval "=== Phase Portraits ==="
def ref_f (x : Rat) : Rat := x*x
def ref_d (x : Rat) : Rat := 2*x
def ref_grid : List Rat := [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
def ref_portrait : PhasePortrait1D := buildPhasePortrait1D ref_f ref_d ref_grid
#eval ref_portrait.fixedPoints
#eval ref_portrait.isStable

/-! ## Bifurcation Detection -/
#eval "=== Bifurcation Detection ==="
def ref_pf : ParameterFamily Rat Rat := { f := fun mu x => x + mu - x*x }
#eval detectFixedPointBifurcation ref_pf ref_grid (-(1:Rat)/4) ((1:Rat)/4)

/-! ## Counting Invariants -/
#eval "=== Combinatorial Invariants ==="
#eval fixedPointCount ref_f ref_grid
#eval periodicPointCount ref_f ref_grid 1
#eval periodicPointCount ref_f ref_grid 2
#eval topologicalEntropyApprox ref_f ref_grid 10

/-! ## Structural Stability -/
#eval "=== Structural Stability ==="
#eval isStructurallyStable ref_f ref_d ref_grid
#eval isStructurallyStable1D ref_f ref_d [1,2,3] ref_grid

/-! ## Continuous Systems -/
#eval "=== Continuous Systems ==="
def ref_cds : ContinuousDS Rat := { vf := { v := fun x => -x*x } }
#eval ref_cds.eulerStep ((1:Rat)/100) 1
#eval ref_cds.rk4Step ((1:Rat)/100) 1
#eval ref_cds.timeOneMap 100 1

/-! ## Gradient Systems -/
#eval "=== Gradient Systems ==="
def ref_gs : GradientSystem := { potential := { coeffs := [0, 0, 0, (1:Rat)/3] }, stateSpace := 0 }
#eval ref_gs.vectorField 0
#eval ref_gs.vectorField 1
#eval GradientSystem.findMinima ref_gs ref_grid

/-! ## Bifurcation Diagram -/
#eval "=== Bifurcation Diagrams ==="
def ref_params : List Rat := [-(1:Rat)/2, -(1:Rat)/4, 0, (1:Rat)/4, (1:Rat)/2]
def ref_diagram : List BifurcationDiagramEntry := generateBifurcationDiagram ref_pf ref_params 0 50 10
#eval ref_diagram.length

/-! ## Critical Points -/
#eval "=== Critical Points ==="
def ref_cp : List Rat := polynomialCriticalPoints ref_gs.potential ref_grid
#eval ref_cp.length
def ref_gs_poly : Polynomial := { coeffs := [0, 0, 0, (1:Rat)/3] }
#eval classifyCriticalPoint ref_gs_poly 0

/-! ## Periodic Orbit Multiplier -/
#eval "=== Periodic Orbits ==="
#eval periodicOrbitMultiplier ref_f ref_d 1 1
#eval periodicOrbitMultiplier ref_f ref_d 0 1

/-! ## Birkhoff Averages -/
#eval "=== Ergodic Theory ==="
#eval birkhoffAverage ref_f (fun x => x*x) 0 100
#eval isErgodicApprox ref_f (fun x => x) 0 100 0 (1:Rat)/10

/-! ## Feigenbaum Constants -/
#eval "=== Universality ==="
def ref_feig_delta : Rat := 4669201609102990 / 1000000000000000
def ref_feig_alpha : Rat := 2502907875095892 / 1000000000000000
#eval feigenbaumScaling ref_feig_delta ref_feig_alpha [3, 1+sqrtRat 6, ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ref_feig_alpha 0

#eval "=== Reference Manual Complete ==="
