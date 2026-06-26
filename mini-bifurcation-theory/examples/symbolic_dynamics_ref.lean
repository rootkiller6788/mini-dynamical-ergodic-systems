/-
# symbolic_dynamics_ref: Reference Implementation

Implementation and verification of symbolic_dynamics_ref concepts.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== symbolic_dynamics_ref ==="
def fsymbolic_dynamics_ref (x : Rat) : Rat := x/2
def dsymbolic_dynamics_ref (x : Rat) : Rat := 1/2
def gsymbolic_dynamics_ref : List Rat := List.map (fun i => (i:Rat)/10) (List.range 21)
#eval (List.filter (fun x => fsymbolic_dynamics_ref x == x) gsymbolic_dynamics_ref).length
#eval fixedPointCount fsymbolic_dynamics_ref gsymbolic_dynamics_ref
#eval periodicPointCount fsymbolic_dynamics_ref gsymbolic_dynamics_ref 1
#eval periodicPointCount fsymbolic_dynamics_ref gsymbolic_dynamics_ref 2
#eval periodicPointCount fsymbolic_dynamics_ref gsymbolic_dynamics_ref 3
#eval topologicalEntropyApprox fsymbolic_dynamics_ref gsymbolic_dynamics_ref 5
#eval topologicalEntropyApprox fsymbolic_dynamics_ref gsymbolic_dynamics_ref 10
#eval isStructurallyStable fsymbolic_dynamics_ref dsymbolic_dynamics_ref gsymbolic_dynamics_ref
#eval polynomialCriticalPoints ({ coeffs := [0,0,1] } : Polynomial) gsymbolic_dynamics_ref
#eval classifyCriticalPoint ({ coeffs := [0,0,1] } : Polynomial) 0
#eval periodicOrbitMultiplier fsymbolic_dynamics_ref dsymbolic_dynamics_ref 0 1
#eval periodicOrbitMultiplier fsymbolic_dynamics_ref dsymbolic_dynamics_ref 0 2
#eval isStructurallyStable1D fsymbolic_dynamics_ref dsymbolic_dynamics_ref [1,2,3,4] gsymbolic_dynamics_ref
#eval birkhoffAverage fsymbolic_dynamics_ref (fun x => x) 0 50
#eval birkhoffAverage fsymbolic_dynamics_ref (fun x => x) 0 100
#eval isErgodicApprox fsymbolic_dynamics_ref (fun x => x) 0 100 0 (1:Rat)/10
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [3, 1+sqrtRat 6, ((3544:Rat)/1000)] [1,1]
#eval rgEquation (fun x => 1-((23:Rat)/10)*x*x) ((25:Rat)/10) 0

/-! ## Structures and Types -/
def famsymbolic_dynamics_ref : ParameterFamily Rat Rat := { f := fun mu x => x + mu }
#eval famsymbolic_dynamics_ref.f 0 0
#eval famsymbolic_dynamics_ref.f 1 0
#eval ParameterFamily.iterate famsymbolic_dynamics_ref 1 5 0

def dssymbolic_dynamics_ref : DiscreteDS Rat := { f := fun x => x+1 }
#eval dssymbolic_dynamics_ref.iterate 0 0
#eval dssymbolic_dynamics_ref.iterate 5 0
#eval orbit dssymbolic_dynamics_ref.f 0 5

def polysymbolic_dynamics_ref : Polynomial := { coeffs := [1, 0, 1] }
#eval polysymbolic_dynamics_ref.eval 0
#eval polysymbolic_dynamics_ref.eval 1
#eval polysymbolic_dynamics_ref.eval (-1)
#eval polysymbolic_dynamics_ref.derivAt 0
#eval polysymbolic_dynamics_ref.derivAt 1
#eval polysymbolic_dynamics_ref.derivAt (-1)

def poly2_symbolic_dynamics_ref : Polynomial := Polynomial.add polysymbolic_dynamics_ref ({ coeffs := [0, 1] } : Polynomial)
#eval poly2_symbolic_dynamics_ref.eval 0
#eval poly2_symbolic_dynamics_ref.eval 1

def poly3_symbolic_dynamics_ref : Polynomial := Polynomial.sub ({ coeffs := [0,0,1] } : Polynomial) polysymbolic_dynamics_ref
#eval poly3_symbolic_dynamics_ref.eval 0
#eval poly3_symbolic_dynamics_ref.eval 1

def poly4_symbolic_dynamics_ref : Polynomial := Polynomial.scalarMul 3 polysymbolic_dynamics_ref
#eval poly4_symbolic_dynamics_ref.eval 0
#eval poly4_symbolic_dynamics_ref.eval 1

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

#eval "=== symbolic_dynamics_ref Complete ==="
