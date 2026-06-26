/-
# Bifurcation Theory: Comprehensive Tests

Extensive test suite for bifurcation theory formalization.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== DiscreteDS Tests ==="
def ds1 : DiscreteDS Rat := { f := fun x => 2*x + 1 }
#eval ds1.f 0
#eval ds1.f 1
#eval ds1.f 5
#eval ds1.iterate 0 10
#eval ds1.iterate 1 10
#eval ds1.iterate 3 10

def ds2 : DiscreteDS Rat := { f := fun x => x*x }
#eval ds2.f 0
#eval ds2.f 1
#eval ds2.f 2
#eval ds2.iterate 0 2
#eval ds2.iterate 1 2
#eval ds2.iterate 2 2
#eval ds2.iterate 3 2

#eval "=== ParameterFamily Tests ==="
def pf1 : ParameterFamily Rat Rat := { f := fun mu x => mu + x }
#eval pf1.f 0 5
#eval pf1.f 3 5
#eval pf1.f (-2) 5
#eval ParameterFamily.iterate pf1 1 0 0
#eval ParameterFamily.iterate pf1 1 1 0
#eval ParameterFamily.iterate pf1 1 5 0

def pf2 : ParameterFamily Rat Rat := { f := fun r x => r*x*(1-x) }
#eval pf2.f 2 0.5
#eval pf2.f 3 0.5
#eval ParameterFamily.iterate pf2 2 0 0.5
#eval ParameterFamily.iterate pf2 2 5 0.5
#eval ParameterFamily.iterate pf2 3 0 0.2
#eval ParameterFamily.iterate pf2 3 10 0.2

#eval "=== Orbit Tests ==="
def sqMap (x : Rat) : Rat := x*x
#eval orbit sqMap 0 0
#eval orbit sqMap 0 1
#eval orbit sqMap 0 5
#eval orbit sqMap 2 0
#eval orbit sqMap 2 1
#eval orbit sqMap 2 2
#eval orbit sqMap 2 3

def idMap (x : Rat) : Rat := x
#eval orbit idMap 5 0
#eval orbit idMap 5 1
#eval orbit idMap 5 10
#eval orbit idMap 5 100

#eval "=== Fixed Point Tests ==="
#eval isFixedPointBool sqMap 0
#eval isFixedPointBool sqMap 1
#eval isFixedPointBool sqMap 2
#eval isFixedPointBool idMap 0
#eval isFixedPointBool idMap 5
#eval isFixedPointBool idMap 100

#eval "=== Polynomial Tests ==="
def zero : Polynomial := { coeffs := [] }
def one : Polynomial := { coeffs := [1] }
def xPoly : Polynomial := { coeffs := [0, 1] }
def xSq : Polynomial := { coeffs := [0, 0, 1] }
def cubic : Polynomial := { coeffs := [1, 2, 3, 4] }

#eval zero.eval 0
#eval zero.eval 5
#eval one.eval 0
#eval one.eval 5
#eval xPoly.eval 0
#eval xPoly.eval 1
#eval xPoly.eval 5
#eval xSq.eval 0
#eval xSq.eval 1
#eval xSq.eval 2
#eval xSq.eval 3
#eval cubic.eval 0
#eval cubic.eval 1
#eval cubic.eval (-1)

#eval "=== Derivative Tests ==="
#eval one.derivAt 0
#eval xPoly.derivAt 0
#eval xPoly.derivAt 1
#eval xPoly.derivAt 5
#eval xSq.derivAt 0
#eval xSq.derivAt 1
#eval xSq.derivAt 2

#eval "=== Polynomial Operations ==="
def pA := Polynomial.add xPoly one
def pB := Polynomial.sub xSq xPoly
def pC := Polynomial.scalarMul 3 xSq
#eval pA.eval 1
#eval pA.eval 5
#eval pB.eval 0
#eval pB.eval 2
#eval pC.eval 1
#eval pC.eval 2

#eval "=== Stability Tests ==="
def linFn (x : Rat) : Rat := x/2
def linD (_ : Rat) : Rat := 1/2
#eval isLinearlyStable linFn 0 linD
#eval isLinearlyUnstable (fun x => 2*x) 0 (fun _ => 2)
#eval isHyperbolic (fun x => x/2) 0 (fun _ => 1/2)

#eval "=== Bifurcation Type Tests ==="
#eval codimension .saddleNode
#eval codimension .transcritical
#eval codimension (.pitchfork true)
#eval codimension (.pitchfork false)
#eval codimension .periodDoubling
#eval codimension .hopf

#eval "=== Normal Form Tests ==="
#eval normalFormSaddleNode.bType
#eval normalFormTranscritical.bType
#eval normalFormPitchforkSuper.bType
#eval normalFormPitchforkSub.bType
#eval normalFormPeriodDoubling.bType

#eval "=== Bifurcation Detection ==="
def domain : List Rat := [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
#eval detectFixedPointBifurcation saddleFamily domain (-(1:Rat)/4) ((1:Rat)/4)
#eval detectFixedPointBifurcation saddleFamily domain 0 ((1:Rat)/2)

#eval "=== Continuous System Tests ==="
def cds : ContinuousDS Rat := { vf := { v := fun x => -x } }
#eval cds.eulerStep ((1:Rat)/10) 1
#eval cds.eulerStep ((1:Rat)/10) 0
#eval cds.rk4Step ((1:Rat)/10) 1
#eval cds.timeOneMap 100 1

#eval "=== Phase Portrait Tests ==="
def linSys (x : Rat) : Rat := -x
def linDer (_ : Rat) : Rat := -1
def portrait := buildPhasePortrait1D linSys linDer domain
#eval portrait.fixedPoints
#eval portrait.isStable

#eval "=== Invariant Counting Tests ==="
#eval fixedPointCount linSys domain
#eval fixedPointCount sqMap domain
#eval periodicPointCount (fun x => -x) domain 2
#eval periodicPointCount sqMap domain 1

#eval "=== Entropy Tests ==="
#eval topologicalEntropyApprox (fun x => 2*x) domain 5
#eval topologicalEntropyApprox sqMap domain 3

#eval "=== Gradient System Tests ==="
def gs : GradientSystem := { potential := { coeffs := [0, 0, 1] }, stateSpace := 0 }
#eval gs.vectorField 1
#eval gs.vectorField (-1)
#eval GradientSystem.findMinima gs domain

#eval "=== Structural Stability Tests ==="
#eval isStructurallyStable linSys linDer domain
#eval isStructurallyStable sqMap (fun x => 2*x) domain

#eval "=== IFS Tests ==="
def ifs : IFS Rat := { maps := [fun x => x/2, fun x => (x+1)/2] }
#eval ifs.maps.length

#eval "=== Shift Space Tests ==="
def fs2 := fullShift 2
#eval fs2.transitions.length

#eval "=== Critical Point Tests ==="
#eval polynomialCriticalPoints xSq domain
#eval classifyCriticalPoint xSq 0
#eval classifyCriticalPoint ({ coeffs := [0, 0, -1] } : Polynomial) 0

#eval "=== Periodic Multiplier Tests ==="
#eval periodicOrbitMultiplier (fun x => -x) (fun _ => -1) 1 2
#eval periodicOrbitMultiplier sqMap (fun x => 2*x) 1 1
#eval periodicOrbitMultiplier sqMap (fun x => 2*x) 0 1

#eval "=== Structural Stability 1D Tests ==="
#eval isStructurallyStable1D (fun x => x/2) (fun _ => 1/2) [1,2,3] domain

#eval "=== Birkhoff Average Tests ==="
#eval birkhoffAverage (fun x => x/2) (fun x => x) 1 100

#eval "=== Feigenbaum Tests ==="
#eval feigenbaumScaling ((4669:Rat)/1000) ((2503:Rat)/1000) [(3:Rat), ((349:Rat)/100), ((358:Rat)/100)] [(1:Rat), (1:Rat)]

#eval "=== Renormalization Group Tests ==="
#eval rgEquation (fun x => 1 - ((23:Rat)/10)*x*x) ((25:Rat)/10) 0

#eval "=== ALL TESTS COMPLETE ==="
