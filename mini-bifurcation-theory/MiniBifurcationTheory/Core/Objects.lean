/-
# Bifurcation Theory: Core Objects

Dynamical system objects, invariants, and constructions.
-/

import MiniBifurcationTheory.Core.Basic

namespace MiniBifurcationTheory

structure VectorField (S : Type) where
  v : S -> S

structure ContinuousDS (S : Type) where
  vf : VectorField S

def ContinuousDS.eulerStep (cds : ContinuousDS Rat) (h : Rat) (x : Rat) : Rat :=
  x + h * cds.vf.v x

def ContinuousDS.rk4Step (cds : ContinuousDS Rat) (h : Rat) (x : Rat) : Rat :=
  let v := cds.vf.v
  let k1 := v x
  let k2 := v (x + h/2 * k1)
  let k3 := v (x + h/2 * k2)
  let k4 := v (x + h * k3)
  x + h/6 * (k1 + 2*k2 + 2*k3 + k4)

def ContinuousDS.timeOneMap (cds : ContinuousDS Rat) (steps : Nat) : Rat -> Rat :=
  let h : Rat := 1 / (steps : Rat)
  fun x => Nat.rec x (fun _ y => cds.eulerStep h y) steps

def isForwardInvariant (f : alpha -> alpha) (A : alpha -> Bool) : Prop :=
  forall x, A x = true -> A (f x) = true

def isInvariantProper (f : alpha -> alpha) (A : alpha -> Bool) : Prop :=
  (forall x, A x = true -> A (f x) = true) /\ (forall x, A (f x) = true -> A x = true)

structure Attractor (alpha : Type) where
  set : alpha -> Bool
  isCompact : Bool
  basinOfAttraction : alpha -> Bool

structure PhasePortrait1D where
  fixedPoints : List Rat
  isStable : List Bool
  flowDirection : Rat -> Bool

def buildPhasePortrait1D (f : Rat -> Rat) (derivAt : Rat -> Rat) (candidates : List Rat) : PhasePortrait1D :=
  let fps := List.filter (fun x => f x == x) candidates
  let stabilities := List.map (fun x => decide (absRat (derivAt x) < 1)) fps
  { fixedPoints := fps, isStable := stabilities, flowDirection := fun x => derivAt x > 0 }

def fixedPointCount (f : alpha -> alpha) (domain : List alpha) [BEq alpha] : Nat :=
  (List.filter (fun x => f x == x) domain).length

def periodicPointCount (f : alpha -> alpha) (domain : List alpha) [BEq alpha] (n : Nat) : Nat :=
  (List.filter (fun x => orbit f x n == x) domain).length

def topologicalEntropyApprox (f : alpha -> alpha) (domain : List alpha) [BEq alpha] (n : Nat) : Rat :=
  let Nn := periodicPointCount f domain n
  if Nn = 0 then 0
  else (Nn : Rat) / (n : Rat)

structure BifurcationDiagramEntry where
  paramValue : Rat
  attractors : List Rat
  period : Nat

def generateBifurcationDiagram (pf : ParameterFamily Rat Rat)
    (params : List Rat) (initialX : Rat) (transient : Nat) (record : Nat) : List BifurcationDiagramEntry :=
  List.map (fun mu =>
    let x := ParameterFamily.iterate pf mu transient initialX
    let orbitPts := List.map (fun i => ParameterFamily.iterate pf mu i x) (List.range record)
    { paramValue := mu, attractors := orbitPts, period := record }
  ) params

structure GradientSystem where
  potential : Polynomial
  stateSpace : Rat

def GradientSystem.vectorField (gs : GradientSystem) : Rat -> Rat :=
  fun x => -(gs.potential.derivAt x)

def GradientSystem.findMinima (gs : GradientSystem) (grid : List Rat) : List Rat :=
  List.filter (fun x =>
    let d := gs.potential.derivAt x
    absRat d < (1/1000 : Rat)
  ) grid

def isStructurallyStable (f : Rat -> Rat) (derivAt : Rat -> Rat) (candidates : List Rat) : Bool :=
  List.all candidates (fun x =>
    if f x == x then derivAt x != 1 /\ derivAt x != -1 else true)

structure IFS (alpha : Type) where
  maps : List (alpha -> alpha)

structure ShiftSpace (alphabetSize : Nat) where
  transitions : List (List Nat)

def fullShift (N : Nat) : ShiftSpace N :=
  { transitions := List.map (fun i => List.range N) (List.range N) }

def entropyLowerBound (f : alpha -> alpha) (domain : List alpha) [BEq alpha] (n : Nat) : Rat :=
  let pn := periodicPointCount f domain n
  if pn = 0 then 0
  else (pn : Rat) / (n : Rat)

def polynomialCriticalPoints (p : Polynomial) (grid : List Rat) : List Rat :=
  let d := p.derivative
  List.filter (fun x => absRat (d.eval x) < (1 : Rat)/10000) grid

inductive CriticalPointType : Type where
  | maximum | minimum | inflection
  deriving BEq, Repr

def classifyCriticalPoint (p : Polynomial) (x : Rat) : CriticalPointType :=
  let d2 := p.derivative.derivative.eval x
  if d2 < 0 then .maximum
  else if d2 > 0 then .minimum
  else .inflection

end MiniBifurcationTheory
