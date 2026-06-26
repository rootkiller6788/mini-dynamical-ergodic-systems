/-
# invariant_measures: Reference Implementation

Implementation and verification of invariant_measures concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== invariant_measures ==="
def finvariant_measures (x : Rat) : Rat := x/2
def dinvariant_measures (x : Rat) : Rat := 1/2
def ginvariant_measures : List Rat := List.map (fun i => (i:Rat)/10) (List.range 21)
#eval (List.filter (fun x => finvariant_measures x == x) ginvariant_measures).length
#eval fixedPointCount finvariant_measures ginvariant_measures
#eval periodicPointCount finvariant_measures ginvariant_measures 1
#eval periodicPointCount finvariant_measures ginvariant_measures 2
#eval periodicPointCount finvariant_measures ginvariant_measures 3
#eval topologicalEntropyApprox finvariant_measures ginvariant_measures 5
#eval topologicalEntropyApprox finvariant_measures ginvariant_measures 10
#eval isStructurallyStable finvariant_measures dinvariant_measures ginvariant_measures
#eval polynomialCriticalPoints ({ coeffs := [0,0,1] } : Polynomial) ginvariant_measures
#eval classifyCriticalPoint ({ coeffs := [0,0,1] } : Polynomial) 0
#eval periodicOrbitMultiplier finvariant_measures dinvariant_measures 0 1
#eval periodicOrbitMultiplier finvariant_measures dinvariant_measures 0 2
#eval isStructurallyStable1D finvariant_measures dinvariant_measures [1,2,3,4] ginvariant_measures
#eval birkhoffAverage finvariant_measures (fun x => x) 0 50
#eval birkhoffAverage finvariant_measures (fun x => x) 0 100
#eval isErgodicApprox finvariant_measures (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, 1+sqrtRat 6, ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## Structures and Types -/
def faminvariant_measures : ParameterFamily Rat Rat := { f := fun mu x => x + mu }
#eval faminvariant_measures.f 0 0
#eval faminvariant_measures.f 1 0
#eval ParameterFamily.iterate faminvariant_measures 1 5 0

def dsinvariant_measures : DiscreteDS Rat := { f := fun x => x+1 }
#eval dsinvariant_measures.iterate 0 0
#eval dsinvariant_measures.iterate 5 0
#eval orbit dsinvariant_measures.f 0 5

def polyinvariant_measures : Polynomial := { coeffs := [1, 0, 1] }
#eval polyinvariant_measures.eval 0
#eval polyinvariant_measures.eval 1
#eval polyinvariant_measures.eval (-1)
#eval polyinvariant_measures.derivAt 0
#eval polyinvariant_measures.derivAt 1
#eval polyinvariant_measures.derivAt (-1)

def poly2_invariant_measures : Polynomial := Polynomial.add polyinvariant_measures ({ coeffs := [0, 1] } : Polynomial)
#eval poly2_invariant_measures.eval 0
#eval poly2_invariant_measures.eval 1

def poly3_invariant_measures : Polynomial := Polynomial.sub ({ coeffs := [0,0,1] } : Polynomial) polyinvariant_measures
#eval poly3_invariant_measures.eval 0
#eval poly3_invariant_measures.eval 1

def poly4_invariant_measures : Polynomial := Polynomial.scalarMul 3 polyinvariant_measures
#eval poly4_invariant_measures.eval 0
#eval poly4_invariant_measures.eval 1

#eval codimension .saddleNode
#eval codimension .transcritical
#eval codimension (.pitchfork true)
#eval codimension (.pitchfork false)
#eval codimension .periodDoubling
#eval codimension .hopf

#eval normalFormSaddleNode.bType
#eval normalFormTranscritical.bType
#eval normalFormPitchforkSuper.bType
#eval normalFormPitchforkSub.bType
#eval normalFormPeriodDoubling.bType

#eval "=== invariant_measures Complete ==="
