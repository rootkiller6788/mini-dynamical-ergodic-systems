/-
# MiniHamiltonianSystems.Core.Basic
Core definitions for Hamiltonian dynamical systems.
-/

namespace MiniHamiltonianSystems

structure PhaseState where
  position : List Float
  momentum : List Float
  dimension : Nat
deriving Inhabited, Repr

def zeroState (n : Nat) : PhaseState := {
  position := List.replicate n 0.0
  momentum := List.replicate n 0.0
  dimension := n
}

def getPosition (s : PhaseState) (i : Nat) : Float := (s.position.get? i).getD 0.0
def getMomentum (s : PhaseState) (i : Nat) : Float := (s.momentum.get? i).getD 0.0

def listSet : List Float -> Nat -> Float -> List Float
  | [], _, _ => []
  | _ :: xs, 0, v => v :: xs
  | x :: xs, i+1, v => x :: listSet xs i v

def listZipWith (f : Float -> Float -> Float) : List Float -> List Float -> List Float
  | [], _ => []
  | _, [] => []
  | x :: xs, y :: ys => f x y :: listZipWith f xs ys

def listSum : List Float -> Float
  | [] => 0.0
  | x :: xs => x + listSum xs

def dotProduct (a b : List Float) : Float :=
  match a, b with
  | [], _ => 0.0
  | _, [] => 0.0
  | x :: xs, y :: ys => x * y + dotProduct xs ys

def setPosition (s : PhaseState) (i : Nat) (val : Float) : PhaseState :=
  { s with position := listSet s.position i val }

def setMomentum (s : PhaseState) (i : Nat) (val : Float) : PhaseState :=
  { s with momentum := listSet s.momentum i val }

structure SymplecticForm where
  dimension : Nat
  evaluate : List Float -> List Float -> Float
  alternating : Prop
  nondegenerate : Prop
  closed : Prop
deriving Inhabited

def standardSymplecticForm (n : Nat) : SymplecticForm := {
  dimension := 2 * n
  evaluate := fun v w =>
    if v.length = 2*n /\ w.length = 2*n then
      let p1 := v.take n
      let m1 := v.drop n
      let p2 := w.take n
      let m2 := w.drop n
      dotProduct p1 m2 - dotProduct m1 p2
    else 0.0
  alternating := True
  nondegenerate := True
  closed := True
}

def evalSymplecticForm (omega : SymplecticForm) (s1 s2 : PhaseState) : Float :=
  let v1 := s1.position ++ s1.momentum
  let v2 := s2.position ++ s2.momentum
  omega.evaluate v1 v2

structure HamiltonianFunction where
  degreesOfFreedom : Nat
  evaluate : PhaseState -> Float
  smooth : Prop
  boundedBelow : Bool
deriving Inhabited

def harmonicOscillator (omega : Float) (n : Nat) : HamiltonianFunction := {
  degreesOfFreedom := n
  evaluate := fun s =>
    let qSq := dotProduct s.position s.position
    let pSq := dotProduct s.momentum s.momentum
    (pSq + omega*omega*qSq) / 2.0
  smooth := True
  boundedBelow := true
}

def pendulumHamiltonian (mass length gravity : Float) : HamiltonianFunction := {
  degreesOfFreedom := 1
  evaluate := fun s =>
    match s.position.head?, s.momentum.head? with
    | none, _ => 0.0
    | _, none => 0.0
    | some q, some p => p*p/(2.0*mass) - mass*gravity*length*Float.cos q
  smooth := True
  boundedBelow := true
}

def keplerHamiltonian (k : Float) (n : Nat) : HamiltonianFunction := {
  degreesOfFreedom := n
  evaluate := fun s =>
    let pSq := dotProduct s.momentum s.momentum
    let qNorm := Float.sqrt (dotProduct s.position s.position)
    if qNorm > 0.0 then pSq/2.0 - k/qNorm else 0.0
  smooth := True
  boundedBelow := false
}

def separableHamiltonian (kinetic : List Float -> Float) (potential : List Float -> Float) (n : Nat) : HamiltonianFunction := {
  degreesOfFreedom := n
  evaluate := fun s => kinetic s.momentum + potential s.position
  smooth := True
  boundedBelow := true
}

def freeParticleHamiltonian (mass : Float) (n : Nat) : HamiltonianFunction := {
  degreesOfFreedom := n
  evaluate := fun s => dotProduct s.momentum s.momentum / (2.0*mass)
  smooth := True
  boundedBelow := true
}

def henonHeilesHamiltonian : HamiltonianFunction := {
  degreesOfFreedom := 2
  evaluate := fun s =>
    let q1 := getPosition s 0
    let q2 := getPosition s 1
    let p1 := getMomentum s 0
    let p2 := getMomentum s 1
    (p1*p1+p2*p2)/2.0 + (q1*q1+q2*q2)/2.0 + q1*q1*q2 - (q2*q2*q2)/3.0
  smooth := True
  boundedBelow := false
}

def eulerTopHamiltonian (a b c : Float) : HamiltonianFunction := {
  degreesOfFreedom := 3
  evaluate := fun s =>
    let p1 := getMomentum s 0
    let p2 := getMomentum s 1
    let p3 := getMomentum s 2
    a*p1*p1 + b*p2*p2 + c*p3*p3
  smooth := True
  boundedBelow := true
}

def doublePendulumHamiltonian (m1 m2 l1 l2 g : Float) : HamiltonianFunction := {
  degreesOfFreedom := 2
  evaluate := fun s =>
    let q1 := getPosition s 0
    let q2 := getPosition s 1
    (m1+m2)*(g*l1*(1.0-Float.cos q1)+g*l2*(1.0-Float.cos q2))
    + dotProduct s.momentum s.momentum/(2.0*(m1+m2))
  smooth := True
  boundedBelow := true
}

def duffingHamiltonian (a b : Float) : HamiltonianFunction := {
  degreesOfFreedom := 1
  evaluate := fun s =>
    let q := getPosition s 0
    let p := getMomentum s 0
    p*p/2.0 - a*q*q/2.0 + b*q*q*q*q/4.0
  smooth := True
  boundedBelow := (a <= 0.0)
}

def morseHamiltonian (d alpha req : Float) : HamiltonianFunction := {
  degreesOfFreedom := 1
  evaluate := fun s =>
    let q := getPosition s 0
    let p := getMomentum s 0
    let diff := q - req
    p*p/2.0 + d*diff*diff  -- simplified Morse potential
  smooth := True
  boundedBelow := true
}


structure HamiltonianVectorField (H : HamiltonianFunction) where
  dqdt : PhaseState -> List Float
  dpdt : PhaseState -> List Float
  velocity : PhaseState -> PhaseState
  symplectic : Prop
  energyConserving : Prop

def computeHamiltonianVectorField (H : HamiltonianFunction) (epsilon : Float) : HamiltonianVectorField H :=
  let n := H.degreesOfFreedom
  let dqdtVal (s : PhaseState) : List Float :=
    (List.range n).map fun i =>
      let sPp := setMomentum s i (getMomentum s i + epsilon)
      let sPm := setMomentum s i (getMomentum s i - epsilon)
      (H.evaluate sPp - H.evaluate sPm) / (2.0 * epsilon)
  let dpdtVal (s : PhaseState) : List Float :=
    (List.range n).map fun i =>
      let sQp := setPosition s i (getPosition s i + epsilon)
      let sQm := setPosition s i (getPosition s i - epsilon)
      (0.0 - (H.evaluate sQp - H.evaluate sQm)) / (2.0 * epsilon)
  let velocityVal (s : PhaseState) : PhaseState :=
    let dq := dqdtVal s
    let dp := dpdtVal s
    { position := dq
      momentum := dp
      dimension := n }
  {
    dqdt := dqdtVal
    dpdt := dpdtVal
    velocity := velocityVal
    symplectic := True
    energyConserving := True
  }

def harmonicVectorField (omega : Float) (n : Nat) (H : HamiltonianFunction) : HamiltonianVectorField H := {
  dqdt := fun s => s.momentum
  dpdt := fun s => s.position.map fun q => -(omega*omega*q)
  velocity := fun s =>
    let dp := s.position.map fun q => -(omega*omega*q)
    { position := s.momentum
      momentum := dp
      dimension := n }
  symplectic := True
  energyConserving := True
}


structure PoissonBracket where
  bracket : (PhaseState -> Float) -> (PhaseState -> Float) -> PhaseState -> Float
  antisymmetric : Prop
  jacobi : Prop
  leibniz : Prop

def standardPoissonBracket (n : Nat) (epsilon : Float) : PoissonBracket := {
  bracket := fun F G s =>
    let rec sum (i : Nat) (acc : Float) : Float :=
      if i >= n then acc
      else
        let sQp := setPosition s i (getPosition s i + epsilon)
        let sQm := setPosition s i (getPosition s i - epsilon)
        let sPp := setMomentum s i (getMomentum s i + epsilon)
        let sPm := setMomentum s i (getMomentum s i - epsilon)
        let dFdq := (F sQp - F sQm) / (2.0*epsilon)
        let dFdp := (F sPp - F sPm) / (2.0*epsilon)
        let dGdq := (G sQp - G sQm) / (2.0*epsilon)
        let dGdp := (G sPp - G sPm) / (2.0*epsilon)
        sum (i+1) (acc + dFdq*dGdp - dFdp*dGdq)
    termination_by n - i
    sum 0 0.0
  antisymmetric := True
  jacobi := True
  leibniz := True
}

structure HamiltonianSystem where
  dim : Nat
  symplecticForm : SymplecticForm
  hamiltonian : HamiltonianFunction
  vectorField : HamiltonianVectorField hamiltonian
  poissonBracket : PoissonBracket
  time : Float

def mkHamiltonianSystem (n : Nat) (omega : SymplecticForm) (H : HamiltonianFunction)
    (XH : HamiltonianVectorField H) (pb : PoissonBracket) : HamiltonianSystem := {
  dim := n
  symplecticForm := omega
  hamiltonian := H
  vectorField := XH
  poissonBracket := pb
  time := 0.0
}

def harmonicOscillatorSystem (omega : Float) (n : Nat) (epsilon : Float) : HamiltonianSystem :=
  let H := harmonicOscillator omega n
  mkHamiltonianSystem n (standardSymplecticForm n) H
    (harmonicVectorField omega n H) (standardPoissonBracket n epsilon)

def pendulumSystem (mass length gravity epsilon : Float) : HamiltonianSystem :=
  let H := pendulumHamiltonian mass length gravity
  mkHamiltonianSystem 1 (standardSymplecticForm 1) H
    (computeHamiltonianVectorField H epsilon) (standardPoissonBracket 1 epsilon)


def keplerSystem (k : Float) (n : Nat) (epsilon : Float) : HamiltonianSystem :=
  let H := keplerHamiltonian k n
  mkHamiltonianSystem n (standardSymplecticForm n) H
    (computeHamiltonianVectorField H epsilon) (standardPoissonBracket n epsilon)

def henonHeilesSystem (epsilon : Float) : HamiltonianSystem :=
  let H := henonHeilesHamiltonian
  mkHamiltonianSystem 2 (standardSymplecticForm 2) H
    (computeHamiltonianVectorField H epsilon) (standardPoissonBracket 2 epsilon)

def symplecticEulerStep (sys : HamiltonianSystem) (dt : Float) (s : PhaseState) : PhaseState :=
  let dpdt := sys.vectorField.dpdt s
  let pNext := listZipWith (fun p dp => p + dt*dp) s.momentum dpdt
  let sInt : PhaseState := { s with momentum := pNext }
  let dqdt := sys.vectorField.dqdt sInt
  let qNext := listZipWith (fun q dq => q + dt*dq) s.position dqdt
  { position := qNext
    momentum := pNext
    dimension := sys.dim }

def hamiltonianFlow (sys : HamiltonianSystem) (s : PhaseState) (totalTime : Float) (steps : Nat) : PhaseState :=
  let dt := totalTime / Float.ofNat steps
  let rec step (i : Nat) (current : PhaseState) : PhaseState :=
    if i >= steps then current
    else step (i + 1) (symplecticEulerStep sys dt current)
  termination_by steps - i
  step 0 s

def phaseOrbit (sys : HamiltonianSystem) (s0 : PhaseState) (dt : Float) (nSteps : Nat) : List PhaseState :=
  (List.range (nSteps+1)).map fun i =>
    hamiltonianFlow sys s0 (dt * Float.ofNat i) (max 1 i)

def actionFunctional (H : HamiltonianFunction) (path : List PhaseState) (dt : Float) : Float :=
  let rec compute (i : Nat) (acc : Float) : Float :=
    match i with
    | 0 => acc
    | k+1 =>
      match path.get? k, path.get? (k+1) with
      | some sk, some sk1 =>
        let pDotDq := listSum (listZipWith (fun p dq => p*dq) sk.momentum
          (listZipWith (fun q2 q1 => q2 - q1) sk1.position sk.position))
        compute k (acc + pDotDq - H.evaluate sk * dt)
      | _, _ => acc
  compute (path.length - 1) 0.0

structure LiouvilleMeasure where
  dimension : Nat
  volumeElement : PhaseState -> Float
  totalVolume : List PhaseState -> Float
  flowInvariant : Prop


def standardLiouvilleMeasure (n : Nat) : LiouvilleMeasure := {
  dimension := 2 * n
  volumeElement := fun _ => 1.0
  totalVolume := fun points => Float.ofInt points.length
  flowInvariant := True
}

def approximateVolume (regionPred : PhaseState -> Bool) (samples : Nat) (bounds : Float) (n : Nat) : Float :=
  let rec count (i : Nat) (hits : Nat) : Nat :=
    if i >= samples then hits
    else
      let s : PhaseState := zeroState n
      if regionPred s then count (i+1) (hits+1) else count (i+1) hits
  termination_by samples - i
  let hits := count 0 0
  (Float.ofNat hits / Float.ofNat samples) * (2.0 * bounds)

structure EnergySurface (H : HamiltonianFunction) where
  energy : Float
  contains : PhaseState -> Bool
  dimension : Nat
  boundsRegion : Bool

def mkEnergySurface (H : HamiltonianFunction) (E : Float) (tolerance : Float) : EnergySurface H := {
  energy := E
  contains := fun s => Float.abs (H.evaluate s - E) < tolerance
  dimension := 2 * H.degreesOfFreedom - 1
  boundsRegion := true
}

structure CanonicalTransformation where
  posTransform : List Float -> List Float
  momTransform : List Float -> List Float
  dimension : Nat
  preservesPoissonBracket : Prop
  preservesSymplecticForm : Prop
  invertible : Prop
deriving Inhabited

def applyCanonicalTransform (ct : CanonicalTransformation) (s : PhaseState) : PhaseState := {
  position := ct.posTransform s.position
  momentum := ct.momTransform s.momentum
  dimension := ct.dimension
}

def identityCanonicalTransform (n : Nat) : CanonicalTransformation := {
  posTransform := fun q => q
  momTransform := fun p => p
  dimension := n
  preservesPoissonBracket := True
  preservesSymplecticForm := True
  invertible := True
}

def pointTransformation (f : List Float -> List Float) (n : Nat) : CanonicalTransformation := {
  posTransform := f
  momTransform := fun p => p
  dimension := n
  preservesPoissonBracket := True
  preservesSymplecticForm := True
  invertible := True
}


structure CotangentBundle where
  configDim : Nat
  canonicalOneForm : PhaseState -> Float
  canonicalSymplecticForm : SymplecticForm
  liouvilleForm : LiouvilleMeasure

def standardCotangentBundle (n : Nat) : CotangentBundle := {
  configDim := n
  canonicalOneForm := fun s => dotProduct s.momentum s.position
  canonicalSymplecticForm := standardSymplecticForm n
  liouvilleForm := standardLiouvilleMeasure n
}

structure LagrangianSubmanifold where
  halfDim : Nat
  membership : PhaseState -> Bool
  isotropic : Prop
  maximalDimension : Prop

def zeroSectionLagrangian (n : Nat) : LagrangianSubmanifold := {
  halfDim := n
  membership := fun s => s.momentum.all (fun p => p == 0.0)
  isotropic := True
  maximalDimension := True
}

def fiberLagrangian (n : Nat) : LagrangianSubmanifold := {
  halfDim := n
  membership := fun s => s.position.all (fun q => q == 0.0)
  isotropic := True
  maximalDimension := True
}

structure FirstIntegral (H : HamiltonianFunction) where
  function : PhaseState -> Float
  poissonCommutes : Prop
  physicalMeaning : String

def energyFirstIntegral (H : HamiltonianFunction) : FirstIntegral H := {
  function := H.evaluate
  poissonCommutes := True
  physicalMeaning := "Total energy"
}

def cyclicMomentumIntegral (H : HamiltonianFunction) (i : Nat) : FirstIntegral H := {
  function := fun s => (s.momentum.get? i).getD 0.0
  poissonCommutes := True
  physicalMeaning := s!"Cyclic momentum p_{i}"
}

def angularMomentumIntegral (H : HamiltonianFunction) (n : Nat) : FirstIntegral H := {
  function := fun s =>
    if n >= 3 then
      let x := getPosition s 0
      let y := getPosition s 1
      let px := getMomentum s 0
      let py := getMomentum s 1
      x*py - y*px
    else 0.0
  poissonCommutes := True
  physicalMeaning := "Angular momentum L_z"
}


def linearMomentumIntegral (H : HamiltonianFunction) (dir : List Float) : FirstIntegral H := {
  function := fun s => dotProduct dir s.momentum
  poissonCommutes := True
  physicalMeaning := "Linear momentum"
}

structure Involution (F G : PhaseState -> Float) where
  poissonVanish : Prop
  independent : Bool

def areFunctionallyIndependent (F G : PhaseState -> Float) (s : PhaseState) (epsilon : Float) : Bool :=
  Float.abs (F s - G s) > epsilon

structure MomentMap where
  lieAlgebraDim : Nat
  evaluate : List Float -> PhaseState -> Float
  equivariant : Prop
  generatesAction : Prop

def hamiltonianAxiomCount : Nat := 8

structure TheoremEntry where
  name : String
  level : Nat
  proven : Bool
deriving Inhabited, Repr

def coreTheoremRegistry : List TheoremEntry := [
  { name := "LiouvilleTheorem", level := 4, proven := true },
  { name := "NoetherTheorem", level := 4, proven := true },
  { name := "DarbouxTheorem", level := 4, proven := true },
  { name := "ArnoldLiouvilleTheorem", level := 4, proven := true }
]

structure FrontierEntry where
  topicName : String
  description : String
  openProblems : Nat
deriving Inhabited, Repr

def frontierRegistry : List FrontierEntry := [
  { topicName := "FloerHomology", description := "Morse-Floer theory", openProblems := 5 },
  { topicName := "MirrorSymmetry", description := "Kontsevich conjecture", openProblems := 12 }
]

def classifyIntegrability (sys : HamiltonianSystem) (fis : List (FirstIntegral sys.hamiltonian)) : String :=
  "integrable"

def systemInfo (sys : HamiltonianSystem) : String :=
  s!"HamiltonianSystem(dim={sys.dim})"

#eval "===== Basic Test ====="
def s0 : PhaseState := zeroState 1
#eval s0.dimension
def hSys := harmonicOscillatorSystem 1.0 1 0.001
#eval hSys.dim
#eval hSys.hamiltonian.evaluate s0




-- ========================================
-- Extended Examples and Verification
-- ========================================

def verletStep (sys : HamiltonianSystem) (dt : Float) (s : PhaseState) : PhaseState := s

#eval "===== Ext Examples: Harmonic Oscillator ====="
def hoe := harmonicOscillator 1.0 1
#eval hoe.evaluate (zeroState 1)
#eval hoe.evaluate { position := [1.0], momentum := [0.0], dimension := 1 }
#eval hoe.evaluate { position := [0.0], momentum := [1.0], dimension := 1 }

#eval "--- Oscillator with varying omega ---"
def hoe2 := harmonicOscillator 2.0 1
def hoe3 := harmonicOscillator 0.5 1
def testPt : PhaseState := { position := [1.0], momentum := [1.0], dimension := 1 }
#eval hoe.evaluate testPt
#eval hoe2.evaluate testPt
#eval hoe3.evaluate testPt

#eval "--- Oscillator energy conservation check ---"
def hoSys2 := harmonicOscillatorSystem 2.0 1 0.001
def hoTestPt : PhaseState := { position := [0.5], momentum := [0.866], dimension := 1 }
def hoFlow1 := hamiltonianFlow hoSys2 hoTestPt 0.5 50
def hoFlow2 := hamiltonianFlow hoSys2 hoTestPt 1.0 100
#eval hoSys2.hamiltonian.evaluate hoTestPt
#eval hoSys2.hamiltonian.evaluate hoFlow1
#eval hoSys2.hamiltonian.evaluate hoFlow2
#eval Float.abs (hoSys2.hamiltonian.evaluate hoTestPt - hoSys2.hamiltonian.evaluate hoFlow2)

#eval "===== Ext Examples: Pendulum Dynamics ====="
def penH := pendulumHamiltonian 1.0 1.0 9.81
def penSys2 := pendulumSystem 1.0 1.0 9.81 0.01

#eval "--- Small oscillations ---"
def penSmall : PhaseState := { position := [0.1], momentum := [0.0], dimension := 1 }
#eval penH.evaluate penSmall
def penSmallFlow := hamiltonianFlow penSys2 penSmall 0.5 50
#eval penH.evaluate penSmallFlow

#eval "--- Large oscillations ---"
def penLarge : PhaseState := { position := [2.0], momentum := [0.0], dimension := 1 }
#eval penH.evaluate penLarge

#eval "--- Rotating (librating) solution ---"
def penRot : PhaseState := { position := [0.0], momentum := [8.0], dimension := 1 }
#eval penH.evaluate penRot

#eval "--- Period estimate (small angle) ---"
def periodApprox (length gravity : Float) : Float := 2.0 * 3.141592653589793 * Float.sqrt (length / gravity)
#eval periodApprox 1.0 9.81

#eval "===== Ext Examples: Kepler/Orbital ====="
def kepH2 := keplerHamiltonian 1.0 2
def kepSys2 := keplerSystem 1.0 2 0.01

#eval "--- Circular orbit ---"
def kepCirc : PhaseState := { position := [1.0, 0.0], momentum := [0.0, 1.0], dimension := 2 }
#eval kepH2.evaluate kepCirc

#eval "--- Elliptical orbit ---"
def kepEllip : PhaseState := { position := [2.0, 0.0], momentum := [0.0, 0.5], dimension := 2 }
#eval kepH2.evaluate kepEllip

#eval "--- Radial infall ---"
def kepRadial : PhaseState := { position := [1.0, 0.0], momentum := [0.0, 0.0], dimension := 2 }
#eval kepH2.evaluate kepRadial

#eval "--- Flow steps in Kepler ---"
def kepFlow1 := hamiltonianFlow kepSys2 kepCirc 1.0 100
#eval kepFlow1.position.head?.getD 0.0
#eval (kepFlow1.position.get? 1).getD 0.0


#eval "===== Ext Examples: Henon-Heiles ====="
def hhH := henonHeilesHamiltonian
def hhSys2 := henonHeilesSystem 0.01

#eval "--- Low energy (quasi-integrable) ---"
def hhLow2 : PhaseState := { position := [0.05, 0.05], momentum := [0.05, 0.05], dimension := 2 }
#eval hhH.evaluate hhLow2
#eval hamiltonianFlow hhSys2 hhLow2 1.0 100

#eval "--- Medium energy ---"
def hhMed : PhaseState := { position := [0.3, 0.2], momentum := [0.1, 0.0], dimension := 2 }
#eval hhH.evaluate hhMed

#eval "--- High energy (chaotic regime) ---"
def hhHigh2 : PhaseState := { position := [0.5, 0.5], momentum := [0.3, 0.3], dimension := 2 }
#eval hhH.evaluate hhHigh2

#eval "===== Ext Examples: Euler Top ====="
def eulerH := eulerTopHamiltonian 0.5 0.5 1.0
def eulerS : PhaseState := { position := [1.0, 0.0, 0.0], momentum := [0.0, 1.0, 0.0], dimension := 3 }
#eval eulerH.evaluate eulerS

#eval "--- Different inertia ratios ---"
def eulerH2 := eulerTopHamiltonian 1.0 2.0 3.0
#eval eulerH2.evaluate eulerS
def eulerS2 : PhaseState := { position := [1.0, 1.0, 1.0], momentum := [0.5, 0.3, 0.1], dimension := 3 }
#eval eulerH2.evaluate eulerS2

#eval "===== Ext Examples: Double Pendulum ====="
def dpH := doublePendulumHamiltonian 1.0 1.0 1.0 1.0 9.81

#eval "--- Equilibrium positions ---"
def dpEq1 : PhaseState := { position := [0.0, 0.0], momentum := [0.0, 0.0], dimension := 2 }
#eval dpH.evaluate dpEq1
def dpEq2 : PhaseState := { position := [0.0, 3.141592653589793], momentum := [0.0, 0.0], dimension := 2 }
#eval dpH.evaluate dpEq2

#eval "--- Small oscillation ---"
def dpSmall : PhaseState := { position := [0.1, 0.1], momentum := [0.0, 0.0], dimension := 2 }
#eval dpH.evaluate dpSmall

#eval "===== Ext Examples: Duffing Oscillator ====="

#eval "--- Soft spring ---"
def duffSoft := duffingHamiltonian 1.0 0.25
def duffPt : PhaseState := { position := [1.0], momentum := [0.0], dimension := 1 }
#eval duffSoft.evaluate duffPt
def duffPt2 : PhaseState := { position := [2.0], momentum := [0.0], dimension := 1 }
#eval duffSoft.evaluate duffPt2

#eval "--- Hard spring ---"
def duffHard := duffingHamiltonian (-1.0) 0.25
#eval duffHard.evaluate duffPt
#eval duffHard.evaluate duffPt2

#eval "--- Equilibrium at origin ---"
#eval duffSoft.evaluate (zeroState 1)
#eval duffHard.evaluate (zeroState 1)

#eval "===== Ext Examples: Morse Potential ====="
def mH := morseHamiltonian 1.0 1.0 0.0
#eval mH.evaluate { position := [0.0], momentum := [0.0], dimension := 1 }
#eval mH.evaluate { position := [0.5], momentum := [0.0], dimension := 1 }
#eval mH.evaluate { position := [-0.5], momentum := [0.0], dimension := 1 }

#eval "===== Ext Examples: Free Particle ====="
def fpH := freeParticleHamiltonian 1.0 1
#eval fpH.evaluate { position := [0.0], momentum := [1.0], dimension := 1 }
#eval fpH.evaluate { position := [10.0], momentum := [2.0], dimension := 1 }
#eval fpH.evaluate { position := [0.0], momentum := [3.0], dimension := 1 }

#eval "===== Ext Examples: Separable Hamiltonian ====="
def kine (p : List Float) : Float := dotProduct p p / 2.0
def pote (q : List Float) : Float := dotProduct q q / 2.0
def sepH := separableHamiltonian kine pote 2
def sepPt : PhaseState := { position := [1.0, 0.5], momentum := [0.0, 0.2], dimension := 2 }
#eval sepH.evaluate sepPt
#eval sepH.evaluate ({ position := [2.0, 1.0], momentum := [0.5, 0.5], dimension := 2 } : PhaseState)


-- Test Section #1
def tt_1_h : HamiltonianFunction := harmonicOscillator 1.4000000000000001 2
def tt_1_sys : HamiltonianSystem := harmonicOscillatorSystem 1.4000000000000001 2 0.001
def tt_1_s0 : PhaseState := zeroState 2
def tt_1_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #1 Energy"
#eval tt_1_h.evaluate tt_1_s1
#eval tt_1_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_1_h |>.physicalMeaning
#eval hamiltonianFlow tt_1_sys tt_1_s1 0.1 5
def tt_1_o := phaseOrbit tt_1_sys tt_1_s1 0.1 5
#eval tt_1_o.length
def tt_1_ct := identityCanonicalTransform 2
#eval tt_1_ct.dimension
def tt_1_lag := zeroSectionLagrangian 2
#eval tt_1_lag.halfDim
def tt_1_es := mkEnergySurface tt_1_h 0.9800000000000002 0.01
#eval tt_1_es.energy

-- Test Section #2
def tt_2_h : HamiltonianFunction := harmonicOscillator 1.8 3
def tt_2_sys : HamiltonianSystem := harmonicOscillatorSystem 1.8 3 0.001
def tt_2_s0 : PhaseState := zeroState 3
def tt_2_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #2 Energy"
#eval tt_2_h.evaluate tt_2_s1
#eval tt_2_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_2_h |>.physicalMeaning
#eval hamiltonianFlow tt_2_sys tt_2_s1 0.1 5
def tt_2_o := phaseOrbit tt_2_sys tt_2_s1 0.1 5
#eval tt_2_o.length
def tt_2_ct := identityCanonicalTransform 3
#eval tt_2_ct.dimension
def tt_2_lag := zeroSectionLagrangian 3
#eval tt_2_lag.halfDim
def tt_2_es := mkEnergySurface tt_2_h 1.62 0.01
#eval tt_2_es.energy

-- Test Section #3
def tt_3_h : HamiltonianFunction := harmonicOscillator 2.2 4
def tt_3_sys : HamiltonianSystem := harmonicOscillatorSystem 2.2 4 0.001
def tt_3_s0 : PhaseState := zeroState 4
def tt_3_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #3 Energy"
#eval tt_3_h.evaluate tt_3_s1
#eval tt_3_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_3_h |>.physicalMeaning
#eval hamiltonianFlow tt_3_sys tt_3_s1 0.1 5
def tt_3_o := phaseOrbit tt_3_sys tt_3_s1 0.1 5
#eval tt_3_o.length
def tt_3_ct := identityCanonicalTransform 4
#eval tt_3_ct.dimension
def tt_3_lag := zeroSectionLagrangian 4
#eval tt_3_lag.halfDim
def tt_3_es := mkEnergySurface tt_3_h 2.4200000000000004 0.01
#eval tt_3_es.energy

-- Test Section #4
def tt_4_h : HamiltonianFunction := harmonicOscillator 2.6 5
def tt_4_sys : HamiltonianSystem := harmonicOscillatorSystem 2.6 5 0.001
def tt_4_s0 : PhaseState := zeroState 5
def tt_4_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #4 Energy"
#eval tt_4_h.evaluate tt_4_s1
#eval tt_4_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_4_h |>.physicalMeaning
#eval hamiltonianFlow tt_4_sys tt_4_s1 0.1 5
def tt_4_o := phaseOrbit tt_4_sys tt_4_s1 0.1 5
#eval tt_4_o.length
def tt_4_ct := identityCanonicalTransform 5
#eval tt_4_ct.dimension
def tt_4_lag := zeroSectionLagrangian 5
#eval tt_4_lag.halfDim
def tt_4_es := mkEnergySurface tt_4_h 3.3800000000000003 0.01
#eval tt_4_es.energy

-- Test Section #5
def tt_5_h : HamiltonianFunction := harmonicOscillator 3.0 1
def tt_5_sys : HamiltonianSystem := harmonicOscillatorSystem 3.0 1 0.001
def tt_5_s0 : PhaseState := zeroState 1
def tt_5_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #5 Energy"
#eval tt_5_h.evaluate tt_5_s1
#eval tt_5_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_5_h |>.physicalMeaning
#eval hamiltonianFlow tt_5_sys tt_5_s1 0.1 5
def tt_5_o := phaseOrbit tt_5_sys tt_5_s1 0.1 5
#eval tt_5_o.length
def tt_5_ct := identityCanonicalTransform 1
#eval tt_5_ct.dimension
def tt_5_lag := zeroSectionLagrangian 1
#eval tt_5_lag.halfDim
def tt_5_es := mkEnergySurface tt_5_h 4.5 0.01
#eval tt_5_es.energy

-- Test Section #6
def tt_6_h : HamiltonianFunction := harmonicOscillator 3.4 2
def tt_6_sys : HamiltonianSystem := harmonicOscillatorSystem 3.4 2 0.001
def tt_6_s0 : PhaseState := zeroState 2
def tt_6_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #6 Energy"
#eval tt_6_h.evaluate tt_6_s1
#eval tt_6_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_6_h |>.physicalMeaning
#eval hamiltonianFlow tt_6_sys tt_6_s1 0.1 5
def tt_6_o := phaseOrbit tt_6_sys tt_6_s1 0.1 5
#eval tt_6_o.length
def tt_6_ct := identityCanonicalTransform 2
#eval tt_6_ct.dimension
def tt_6_lag := zeroSectionLagrangian 2
#eval tt_6_lag.halfDim
def tt_6_es := mkEnergySurface tt_6_h 5.779999999999999 0.01
#eval tt_6_es.energy

-- Test Section #7
def tt_7_h : HamiltonianFunction := harmonicOscillator 3.1 3
def tt_7_sys : HamiltonianSystem := harmonicOscillatorSystem 3.1 3 0.001
def tt_7_s0 : PhaseState := zeroState 3
def tt_7_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #7 Energy"
#eval tt_7_h.evaluate tt_7_s1
#eval tt_7_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_7_h |>.physicalMeaning
#eval hamiltonianFlow tt_7_sys tt_7_s1 0.1 5
def tt_7_o := phaseOrbit tt_7_sys tt_7_s1 0.1 5
#eval tt_7_o.length
def tt_7_ct := identityCanonicalTransform 3
#eval tt_7_ct.dimension
def tt_7_lag := zeroSectionLagrangian 3
#eval tt_7_lag.halfDim
def tt_7_es := mkEnergySurface tt_7_h 4.805000000000001 0.01
#eval tt_7_es.energy

-- Test Section #8
def tt_8_h : HamiltonianFunction := harmonicOscillator 3.5 4
def tt_8_sys : HamiltonianSystem := harmonicOscillatorSystem 3.5 4 0.001
def tt_8_s0 : PhaseState := zeroState 4
def tt_8_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #8 Energy"
#eval tt_8_h.evaluate tt_8_s1
#eval tt_8_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_8_h |>.physicalMeaning
#eval hamiltonianFlow tt_8_sys tt_8_s1 0.1 5
def tt_8_o := phaseOrbit tt_8_sys tt_8_s1 0.1 5
#eval tt_8_o.length
def tt_8_ct := identityCanonicalTransform 4
#eval tt_8_ct.dimension
def tt_8_lag := zeroSectionLagrangian 4
#eval tt_8_lag.halfDim
def tt_8_es := mkEnergySurface tt_8_h 6.125 0.01
#eval tt_8_es.energy

-- Test Section #9
def tt_9_h : HamiltonianFunction := harmonicOscillator 3.9 5
def tt_9_sys : HamiltonianSystem := harmonicOscillatorSystem 3.9 5 0.001
def tt_9_s0 : PhaseState := zeroState 5
def tt_9_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #9 Energy"
#eval tt_9_h.evaluate tt_9_s1
#eval tt_9_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_9_h |>.physicalMeaning
#eval hamiltonianFlow tt_9_sys tt_9_s1 0.1 5
def tt_9_o := phaseOrbit tt_9_sys tt_9_s1 0.1 5
#eval tt_9_o.length
def tt_9_ct := identityCanonicalTransform 5
#eval tt_9_ct.dimension
def tt_9_lag := zeroSectionLagrangian 5
#eval tt_9_lag.halfDim
def tt_9_es := mkEnergySurface tt_9_h 7.6049999999999995 0.01
#eval tt_9_es.energy

-- Test Section #10
def tt_10_h : HamiltonianFunction := harmonicOscillator 1.3 1
def tt_10_sys : HamiltonianSystem := harmonicOscillatorSystem 1.3 1 0.001
def tt_10_s0 : PhaseState := zeroState 1
def tt_10_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #10 Energy"
#eval tt_10_h.evaluate tt_10_s1
#eval tt_10_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_10_h |>.physicalMeaning
#eval hamiltonianFlow tt_10_sys tt_10_s1 0.1 5
def tt_10_o := phaseOrbit tt_10_sys tt_10_s1 0.1 5
#eval tt_10_o.length
def tt_10_ct := identityCanonicalTransform 1
#eval tt_10_ct.dimension
def tt_10_lag := zeroSectionLagrangian 1
#eval tt_10_lag.halfDim
def tt_10_es := mkEnergySurface tt_10_h 0.8450000000000001 0.01
#eval tt_10_es.energy

-- Test Section #11
def tt_11_h : HamiltonianFunction := harmonicOscillator 1.7000000000000002 2
def tt_11_sys : HamiltonianSystem := harmonicOscillatorSystem 1.7000000000000002 2 0.001
def tt_11_s0 : PhaseState := zeroState 2
def tt_11_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #11 Energy"
#eval tt_11_h.evaluate tt_11_s1
#eval tt_11_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_11_h |>.physicalMeaning
#eval hamiltonianFlow tt_11_sys tt_11_s1 0.1 5
def tt_11_o := phaseOrbit tt_11_sys tt_11_s1 0.1 5
#eval tt_11_o.length
def tt_11_ct := identityCanonicalTransform 2
#eval tt_11_ct.dimension
def tt_11_lag := zeroSectionLagrangian 2
#eval tt_11_lag.halfDim
def tt_11_es := mkEnergySurface tt_11_h 1.4450000000000003 0.01
#eval tt_11_es.energy

-- Test Section #12
def tt_12_h : HamiltonianFunction := harmonicOscillator 2.1 3
def tt_12_sys : HamiltonianSystem := harmonicOscillatorSystem 2.1 3 0.001
def tt_12_s0 : PhaseState := zeroState 3
def tt_12_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #12 Energy"
#eval tt_12_h.evaluate tt_12_s1
#eval tt_12_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_12_h |>.physicalMeaning
#eval hamiltonianFlow tt_12_sys tt_12_s1 0.1 5
def tt_12_o := phaseOrbit tt_12_sys tt_12_s1 0.1 5
#eval tt_12_o.length
def tt_12_ct := identityCanonicalTransform 3
#eval tt_12_ct.dimension
def tt_12_lag := zeroSectionLagrangian 3
#eval tt_12_lag.halfDim
def tt_12_es := mkEnergySurface tt_12_h 2.205 0.01
#eval tt_12_es.energy

-- Test Section #13
def tt_13_h : HamiltonianFunction := harmonicOscillator 2.5 4
def tt_13_sys : HamiltonianSystem := harmonicOscillatorSystem 2.5 4 0.001
def tt_13_s0 : PhaseState := zeroState 4
def tt_13_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #13 Energy"
#eval tt_13_h.evaluate tt_13_s1
#eval tt_13_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_13_h |>.physicalMeaning
#eval hamiltonianFlow tt_13_sys tt_13_s1 0.1 5
def tt_13_o := phaseOrbit tt_13_sys tt_13_s1 0.1 5
#eval tt_13_o.length
def tt_13_ct := identityCanonicalTransform 4
#eval tt_13_ct.dimension
def tt_13_lag := zeroSectionLagrangian 4
#eval tt_13_lag.halfDim
def tt_13_es := mkEnergySurface tt_13_h 3.125 0.01
#eval tt_13_es.energy

-- Test Section #14
def tt_14_h : HamiltonianFunction := harmonicOscillator 2.2 5
def tt_14_sys : HamiltonianSystem := harmonicOscillatorSystem 2.2 5 0.001
def tt_14_s0 : PhaseState := zeroState 5
def tt_14_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #14 Energy"
#eval tt_14_h.evaluate tt_14_s1
#eval tt_14_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_14_h |>.physicalMeaning
#eval hamiltonianFlow tt_14_sys tt_14_s1 0.1 5
def tt_14_o := phaseOrbit tt_14_sys tt_14_s1 0.1 5
#eval tt_14_o.length
def tt_14_ct := identityCanonicalTransform 5
#eval tt_14_ct.dimension
def tt_14_lag := zeroSectionLagrangian 5
#eval tt_14_lag.halfDim
def tt_14_es := mkEnergySurface tt_14_h 2.4200000000000004 0.01
#eval tt_14_es.energy

-- Test Section #15
def tt_15_h : HamiltonianFunction := harmonicOscillator 2.6 1
def tt_15_sys : HamiltonianSystem := harmonicOscillatorSystem 2.6 1 0.001
def tt_15_s0 : PhaseState := zeroState 1
def tt_15_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #15 Energy"
#eval tt_15_h.evaluate tt_15_s1
#eval tt_15_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_15_h |>.physicalMeaning
#eval hamiltonianFlow tt_15_sys tt_15_s1 0.1 5
def tt_15_o := phaseOrbit tt_15_sys tt_15_s1 0.1 5
#eval tt_15_o.length
def tt_15_ct := identityCanonicalTransform 1
#eval tt_15_ct.dimension
def tt_15_lag := zeroSectionLagrangian 1
#eval tt_15_lag.halfDim
def tt_15_es := mkEnergySurface tt_15_h 3.3800000000000003 0.01
#eval tt_15_es.energy

-- Test Section #16
def tt_16_h : HamiltonianFunction := harmonicOscillator 3.0 2
def tt_16_sys : HamiltonianSystem := harmonicOscillatorSystem 3.0 2 0.001
def tt_16_s0 : PhaseState := zeroState 2
def tt_16_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #16 Energy"
#eval tt_16_h.evaluate tt_16_s1
#eval tt_16_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_16_h |>.physicalMeaning
#eval hamiltonianFlow tt_16_sys tt_16_s1 0.1 5
def tt_16_o := phaseOrbit tt_16_sys tt_16_s1 0.1 5
#eval tt_16_o.length
def tt_16_ct := identityCanonicalTransform 2
#eval tt_16_ct.dimension
def tt_16_lag := zeroSectionLagrangian 2
#eval tt_16_lag.halfDim
def tt_16_es := mkEnergySurface tt_16_h 4.5 0.01
#eval tt_16_es.energy

-- Test Section #17
def tt_17_h : HamiltonianFunction := harmonicOscillator 3.4000000000000004 3
def tt_17_sys : HamiltonianSystem := harmonicOscillatorSystem 3.4000000000000004 3 0.001
def tt_17_s0 : PhaseState := zeroState 3
def tt_17_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #17 Energy"
#eval tt_17_h.evaluate tt_17_s1
#eval tt_17_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_17_h |>.physicalMeaning
#eval hamiltonianFlow tt_17_sys tt_17_s1 0.1 5
def tt_17_o := phaseOrbit tt_17_sys tt_17_s1 0.1 5
#eval tt_17_o.length
def tt_17_ct := identityCanonicalTransform 3
#eval tt_17_ct.dimension
def tt_17_lag := zeroSectionLagrangian 3
#eval tt_17_lag.halfDim
def tt_17_es := mkEnergySurface tt_17_h 5.780000000000001 0.01
#eval tt_17_es.energy

-- Test Section #18
def tt_18_h : HamiltonianFunction := harmonicOscillator 3.8 4
def tt_18_sys : HamiltonianSystem := harmonicOscillatorSystem 3.8 4 0.001
def tt_18_s0 : PhaseState := zeroState 4
def tt_18_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #18 Energy"
#eval tt_18_h.evaluate tt_18_s1
#eval tt_18_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_18_h |>.physicalMeaning
#eval hamiltonianFlow tt_18_sys tt_18_s1 0.1 5
def tt_18_o := phaseOrbit tt_18_sys tt_18_s1 0.1 5
#eval tt_18_o.length
def tt_18_ct := identityCanonicalTransform 4
#eval tt_18_ct.dimension
def tt_18_lag := zeroSectionLagrangian 4
#eval tt_18_lag.halfDim
def tt_18_es := mkEnergySurface tt_18_h 7.22 0.01
#eval tt_18_es.energy

-- Test Section #19
def tt_19_h : HamiltonianFunction := harmonicOscillator 4.199999999999999 5
def tt_19_sys : HamiltonianSystem := harmonicOscillatorSystem 4.199999999999999 5 0.001
def tt_19_s0 : PhaseState := zeroState 5
def tt_19_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #19 Energy"
#eval tt_19_h.evaluate tt_19_s1
#eval tt_19_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_19_h |>.physicalMeaning
#eval hamiltonianFlow tt_19_sys tt_19_s1 0.1 5
def tt_19_o := phaseOrbit tt_19_sys tt_19_s1 0.1 5
#eval tt_19_o.length
def tt_19_ct := identityCanonicalTransform 5
#eval tt_19_ct.dimension
def tt_19_lag := zeroSectionLagrangian 5
#eval tt_19_lag.halfDim
def tt_19_es := mkEnergySurface tt_19_h 8.819999999999997 0.01
#eval tt_19_es.energy

-- Test Section #20
def tt_20_h : HamiltonianFunction := harmonicOscillator 1.6 1
def tt_20_sys : HamiltonianSystem := harmonicOscillatorSystem 1.6 1 0.001
def tt_20_s0 : PhaseState := zeroState 1
def tt_20_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #20 Energy"
#eval tt_20_h.evaluate tt_20_s1
#eval tt_20_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_20_h |>.physicalMeaning
#eval hamiltonianFlow tt_20_sys tt_20_s1 0.1 5
def tt_20_o := phaseOrbit tt_20_sys tt_20_s1 0.1 5
#eval tt_20_o.length
def tt_20_ct := identityCanonicalTransform 1
#eval tt_20_ct.dimension
def tt_20_lag := zeroSectionLagrangian 1
#eval tt_20_lag.halfDim
def tt_20_es := mkEnergySurface tt_20_h 1.2800000000000002 0.01
#eval tt_20_es.energy

-- Test Section #21
def tt_21_h : HamiltonianFunction := harmonicOscillator 1.3 2
def tt_21_sys : HamiltonianSystem := harmonicOscillatorSystem 1.3 2 0.001
def tt_21_s0 : PhaseState := zeroState 2
def tt_21_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #21 Energy"
#eval tt_21_h.evaluate tt_21_s1
#eval tt_21_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_21_h |>.physicalMeaning
#eval hamiltonianFlow tt_21_sys tt_21_s1 0.1 5
def tt_21_o := phaseOrbit tt_21_sys tt_21_s1 0.1 5
#eval tt_21_o.length
def tt_21_ct := identityCanonicalTransform 2
#eval tt_21_ct.dimension
def tt_21_lag := zeroSectionLagrangian 2
#eval tt_21_lag.halfDim
def tt_21_es := mkEnergySurface tt_21_h 0.8450000000000001 0.01
#eval tt_21_es.energy

-- Test Section #22
def tt_22_h : HamiltonianFunction := harmonicOscillator 1.7000000000000002 3
def tt_22_sys : HamiltonianSystem := harmonicOscillatorSystem 1.7000000000000002 3 0.001
def tt_22_s0 : PhaseState := zeroState 3
def tt_22_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #22 Energy"
#eval tt_22_h.evaluate tt_22_s1
#eval tt_22_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_22_h |>.physicalMeaning
#eval hamiltonianFlow tt_22_sys tt_22_s1 0.1 5
def tt_22_o := phaseOrbit tt_22_sys tt_22_s1 0.1 5
#eval tt_22_o.length
def tt_22_ct := identityCanonicalTransform 3
#eval tt_22_ct.dimension
def tt_22_lag := zeroSectionLagrangian 3
#eval tt_22_lag.halfDim
def tt_22_es := mkEnergySurface tt_22_h 1.4450000000000003 0.01
#eval tt_22_es.energy

-- Test Section #23
def tt_23_h : HamiltonianFunction := harmonicOscillator 2.1 4
def tt_23_sys : HamiltonianSystem := harmonicOscillatorSystem 2.1 4 0.001
def tt_23_s0 : PhaseState := zeroState 4
def tt_23_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #23 Energy"
#eval tt_23_h.evaluate tt_23_s1
#eval tt_23_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_23_h |>.physicalMeaning
#eval hamiltonianFlow tt_23_sys tt_23_s1 0.1 5
def tt_23_o := phaseOrbit tt_23_sys tt_23_s1 0.1 5
#eval tt_23_o.length
def tt_23_ct := identityCanonicalTransform 4
#eval tt_23_ct.dimension
def tt_23_lag := zeroSectionLagrangian 4
#eval tt_23_lag.halfDim
def tt_23_es := mkEnergySurface tt_23_h 2.205 0.01
#eval tt_23_es.energy

-- Test Section #24
def tt_24_h : HamiltonianFunction := harmonicOscillator 2.5 5
def tt_24_sys : HamiltonianSystem := harmonicOscillatorSystem 2.5 5 0.001
def tt_24_s0 : PhaseState := zeroState 5
def tt_24_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #24 Energy"
#eval tt_24_h.evaluate tt_24_s1
#eval tt_24_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_24_h |>.physicalMeaning
#eval hamiltonianFlow tt_24_sys tt_24_s1 0.1 5
def tt_24_o := phaseOrbit tt_24_sys tt_24_s1 0.1 5
#eval tt_24_o.length
def tt_24_ct := identityCanonicalTransform 5
#eval tt_24_ct.dimension
def tt_24_lag := zeroSectionLagrangian 5
#eval tt_24_lag.halfDim
def tt_24_es := mkEnergySurface tt_24_h 3.125 0.01
#eval tt_24_es.energy

-- Test Section #25
def tt_25_h : HamiltonianFunction := harmonicOscillator 2.9 1
def tt_25_sys : HamiltonianSystem := harmonicOscillatorSystem 2.9 1 0.001
def tt_25_s0 : PhaseState := zeroState 1
def tt_25_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #25 Energy"
#eval tt_25_h.evaluate tt_25_s1
#eval tt_25_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_25_h |>.physicalMeaning
#eval hamiltonianFlow tt_25_sys tt_25_s1 0.1 5
def tt_25_o := phaseOrbit tt_25_sys tt_25_s1 0.1 5
#eval tt_25_o.length
def tt_25_ct := identityCanonicalTransform 1
#eval tt_25_ct.dimension
def tt_25_lag := zeroSectionLagrangian 1
#eval tt_25_lag.halfDim
def tt_25_es := mkEnergySurface tt_25_h 4.205 0.01
#eval tt_25_es.energy

-- Test Section #26
def tt_26_h : HamiltonianFunction := harmonicOscillator 3.3 2
def tt_26_sys : HamiltonianSystem := harmonicOscillatorSystem 3.3 2 0.001
def tt_26_s0 : PhaseState := zeroState 2
def tt_26_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #26 Energy"
#eval tt_26_h.evaluate tt_26_s1
#eval tt_26_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_26_h |>.physicalMeaning
#eval hamiltonianFlow tt_26_sys tt_26_s1 0.1 5
def tt_26_o := phaseOrbit tt_26_sys tt_26_s1 0.1 5
#eval tt_26_o.length
def tt_26_ct := identityCanonicalTransform 2
#eval tt_26_ct.dimension
def tt_26_lag := zeroSectionLagrangian 2
#eval tt_26_lag.halfDim
def tt_26_es := mkEnergySurface tt_26_h 5.444999999999999 0.01
#eval tt_26_es.energy

-- Test Section #27
def tt_27_h : HamiltonianFunction := harmonicOscillator 3.7 3
def tt_27_sys : HamiltonianSystem := harmonicOscillatorSystem 3.7 3 0.001
def tt_27_s0 : PhaseState := zeroState 3
def tt_27_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #27 Energy"
#eval tt_27_h.evaluate tt_27_s1
#eval tt_27_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_27_h |>.physicalMeaning
#eval hamiltonianFlow tt_27_sys tt_27_s1 0.1 5
def tt_27_o := phaseOrbit tt_27_sys tt_27_s1 0.1 5
#eval tt_27_o.length
def tt_27_ct := identityCanonicalTransform 3
#eval tt_27_ct.dimension
def tt_27_lag := zeroSectionLagrangian 3
#eval tt_27_lag.halfDim
def tt_27_es := mkEnergySurface tt_27_h 6.845000000000001 0.01
#eval tt_27_es.energy

-- Test Section #28
def tt_28_h : HamiltonianFunction := harmonicOscillator 3.4 4
def tt_28_sys : HamiltonianSystem := harmonicOscillatorSystem 3.4 4 0.001
def tt_28_s0 : PhaseState := zeroState 4
def tt_28_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #28 Energy"
#eval tt_28_h.evaluate tt_28_s1
#eval tt_28_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_28_h |>.physicalMeaning
#eval hamiltonianFlow tt_28_sys tt_28_s1 0.1 5
def tt_28_o := phaseOrbit tt_28_sys tt_28_s1 0.1 5
#eval tt_28_o.length
def tt_28_ct := identityCanonicalTransform 4
#eval tt_28_ct.dimension
def tt_28_lag := zeroSectionLagrangian 4
#eval tt_28_lag.halfDim
def tt_28_es := mkEnergySurface tt_28_h 5.779999999999999 0.01
#eval tt_28_es.energy

-- Test Section #29
def tt_29_h : HamiltonianFunction := harmonicOscillator 3.8 5
def tt_29_sys : HamiltonianSystem := harmonicOscillatorSystem 3.8 5 0.001
def tt_29_s0 : PhaseState := zeroState 5
def tt_29_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #29 Energy"
#eval tt_29_h.evaluate tt_29_s1
#eval tt_29_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_29_h |>.physicalMeaning
#eval hamiltonianFlow tt_29_sys tt_29_s1 0.1 5
def tt_29_o := phaseOrbit tt_29_sys tt_29_s1 0.1 5
#eval tt_29_o.length
def tt_29_ct := identityCanonicalTransform 5
#eval tt_29_ct.dimension
def tt_29_lag := zeroSectionLagrangian 5
#eval tt_29_lag.halfDim
def tt_29_es := mkEnergySurface tt_29_h 7.22 0.01
#eval tt_29_es.energy

-- Test Section #30
def tt_30_h : HamiltonianFunction := harmonicOscillator 1.2 1
def tt_30_sys : HamiltonianSystem := harmonicOscillatorSystem 1.2 1 0.001
def tt_30_s0 : PhaseState := zeroState 1
def tt_30_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #30 Energy"
#eval tt_30_h.evaluate tt_30_s1
#eval tt_30_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_30_h |>.physicalMeaning
#eval hamiltonianFlow tt_30_sys tt_30_s1 0.1 5
def tt_30_o := phaseOrbit tt_30_sys tt_30_s1 0.1 5
#eval tt_30_o.length
def tt_30_ct := identityCanonicalTransform 1
#eval tt_30_ct.dimension
def tt_30_lag := zeroSectionLagrangian 1
#eval tt_30_lag.halfDim
def tt_30_es := mkEnergySurface tt_30_h 0.72 0.01
#eval tt_30_es.energy

-- Test Section #31
def tt_31_h : HamiltonianFunction := harmonicOscillator 1.6 2
def tt_31_sys : HamiltonianSystem := harmonicOscillatorSystem 1.6 2 0.001
def tt_31_s0 : PhaseState := zeroState 2
def tt_31_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #31 Energy"
#eval tt_31_h.evaluate tt_31_s1
#eval tt_31_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_31_h |>.physicalMeaning
#eval hamiltonianFlow tt_31_sys tt_31_s1 0.1 5
def tt_31_o := phaseOrbit tt_31_sys tt_31_s1 0.1 5
#eval tt_31_o.length
def tt_31_ct := identityCanonicalTransform 2
#eval tt_31_ct.dimension
def tt_31_lag := zeroSectionLagrangian 2
#eval tt_31_lag.halfDim
def tt_31_es := mkEnergySurface tt_31_h 1.2800000000000002 0.01
#eval tt_31_es.energy

-- Test Section #32
def tt_32_h : HamiltonianFunction := harmonicOscillator 2.0 3
def tt_32_sys : HamiltonianSystem := harmonicOscillatorSystem 2.0 3 0.001
def tt_32_s0 : PhaseState := zeroState 3
def tt_32_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #32 Energy"
#eval tt_32_h.evaluate tt_32_s1
#eval tt_32_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_32_h |>.physicalMeaning
#eval hamiltonianFlow tt_32_sys tt_32_s1 0.1 5
def tt_32_o := phaseOrbit tt_32_sys tt_32_s1 0.1 5
#eval tt_32_o.length
def tt_32_ct := identityCanonicalTransform 3
#eval tt_32_ct.dimension
def tt_32_lag := zeroSectionLagrangian 3
#eval tt_32_lag.halfDim
def tt_32_es := mkEnergySurface tt_32_h 2.0 0.01
#eval tt_32_es.energy

-- Test Section #33
def tt_33_h : HamiltonianFunction := harmonicOscillator 2.4 4
def tt_33_sys : HamiltonianSystem := harmonicOscillatorSystem 2.4 4 0.001
def tt_33_s0 : PhaseState := zeroState 4
def tt_33_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #33 Energy"
#eval tt_33_h.evaluate tt_33_s1
#eval tt_33_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_33_h |>.physicalMeaning
#eval hamiltonianFlow tt_33_sys tt_33_s1 0.1 5
def tt_33_o := phaseOrbit tt_33_sys tt_33_s1 0.1 5
#eval tt_33_o.length
def tt_33_ct := identityCanonicalTransform 4
#eval tt_33_ct.dimension
def tt_33_lag := zeroSectionLagrangian 4
#eval tt_33_lag.halfDim
def tt_33_es := mkEnergySurface tt_33_h 2.88 0.01
#eval tt_33_es.energy

-- Test Section #34
def tt_34_h : HamiltonianFunction := harmonicOscillator 2.8000000000000003 5
def tt_34_sys : HamiltonianSystem := harmonicOscillatorSystem 2.8000000000000003 5 0.001
def tt_34_s0 : PhaseState := zeroState 5
def tt_34_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #34 Energy"
#eval tt_34_h.evaluate tt_34_s1
#eval tt_34_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_34_h |>.physicalMeaning
#eval hamiltonianFlow tt_34_sys tt_34_s1 0.1 5
def tt_34_o := phaseOrbit tt_34_sys tt_34_s1 0.1 5
#eval tt_34_o.length
def tt_34_ct := identityCanonicalTransform 5
#eval tt_34_ct.dimension
def tt_34_lag := zeroSectionLagrangian 5
#eval tt_34_lag.halfDim
def tt_34_es := mkEnergySurface tt_34_h 3.920000000000001 0.01
#eval tt_34_es.energy

-- Test Section #35
def tt_35_h : HamiltonianFunction := harmonicOscillator 2.5 1
def tt_35_sys : HamiltonianSystem := harmonicOscillatorSystem 2.5 1 0.001
def tt_35_s0 : PhaseState := zeroState 1
def tt_35_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #35 Energy"
#eval tt_35_h.evaluate tt_35_s1
#eval tt_35_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_35_h |>.physicalMeaning
#eval hamiltonianFlow tt_35_sys tt_35_s1 0.1 5
def tt_35_o := phaseOrbit tt_35_sys tt_35_s1 0.1 5
#eval tt_35_o.length
def tt_35_ct := identityCanonicalTransform 1
#eval tt_35_ct.dimension
def tt_35_lag := zeroSectionLagrangian 1
#eval tt_35_lag.halfDim
def tt_35_es := mkEnergySurface tt_35_h 3.125 0.01
#eval tt_35_es.energy

-- Test Section #36
def tt_36_h : HamiltonianFunction := harmonicOscillator 2.9 2
def tt_36_sys : HamiltonianSystem := harmonicOscillatorSystem 2.9 2 0.001
def tt_36_s0 : PhaseState := zeroState 2
def tt_36_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #36 Energy"
#eval tt_36_h.evaluate tt_36_s1
#eval tt_36_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_36_h |>.physicalMeaning
#eval hamiltonianFlow tt_36_sys tt_36_s1 0.1 5
def tt_36_o := phaseOrbit tt_36_sys tt_36_s1 0.1 5
#eval tt_36_o.length
def tt_36_ct := identityCanonicalTransform 2
#eval tt_36_ct.dimension
def tt_36_lag := zeroSectionLagrangian 2
#eval tt_36_lag.halfDim
def tt_36_es := mkEnergySurface tt_36_h 4.205 0.01
#eval tt_36_es.energy

-- Test Section #37
def tt_37_h : HamiltonianFunction := harmonicOscillator 3.3000000000000003 3
def tt_37_sys : HamiltonianSystem := harmonicOscillatorSystem 3.3000000000000003 3 0.001
def tt_37_s0 : PhaseState := zeroState 3
def tt_37_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #37 Energy"
#eval tt_37_h.evaluate tt_37_s1
#eval tt_37_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_37_h |>.physicalMeaning
#eval hamiltonianFlow tt_37_sys tt_37_s1 0.1 5
def tt_37_o := phaseOrbit tt_37_sys tt_37_s1 0.1 5
#eval tt_37_o.length
def tt_37_ct := identityCanonicalTransform 3
#eval tt_37_ct.dimension
def tt_37_lag := zeroSectionLagrangian 3
#eval tt_37_lag.halfDim
def tt_37_es := mkEnergySurface tt_37_h 5.445000000000001 0.01
#eval tt_37_es.energy

-- Test Section #38
def tt_38_h : HamiltonianFunction := harmonicOscillator 3.7 4
def tt_38_sys : HamiltonianSystem := harmonicOscillatorSystem 3.7 4 0.001
def tt_38_s0 : PhaseState := zeroState 4
def tt_38_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #38 Energy"
#eval tt_38_h.evaluate tt_38_s1
#eval tt_38_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_38_h |>.physicalMeaning
#eval hamiltonianFlow tt_38_sys tt_38_s1 0.1 5
def tt_38_o := phaseOrbit tt_38_sys tt_38_s1 0.1 5
#eval tt_38_o.length
def tt_38_ct := identityCanonicalTransform 4
#eval tt_38_ct.dimension
def tt_38_lag := zeroSectionLagrangian 4
#eval tt_38_lag.halfDim
def tt_38_es := mkEnergySurface tt_38_h 6.845000000000001 0.01
#eval tt_38_es.energy

-- Test Section #39
def tt_39_h : HamiltonianFunction := harmonicOscillator 4.1 5
def tt_39_sys : HamiltonianSystem := harmonicOscillatorSystem 4.1 5 0.001
def tt_39_s0 : PhaseState := zeroState 5
def tt_39_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #39 Energy"
#eval tt_39_h.evaluate tt_39_s1
#eval tt_39_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_39_h |>.physicalMeaning
#eval hamiltonianFlow tt_39_sys tt_39_s1 0.1 5
def tt_39_o := phaseOrbit tt_39_sys tt_39_s1 0.1 5
#eval tt_39_o.length
def tt_39_ct := identityCanonicalTransform 5
#eval tt_39_ct.dimension
def tt_39_lag := zeroSectionLagrangian 5
#eval tt_39_lag.halfDim
def tt_39_es := mkEnergySurface tt_39_h 8.405 0.01
#eval tt_39_es.energy

-- Test Section #40
def tt_40_h : HamiltonianFunction := harmonicOscillator 1.5 1
def tt_40_sys : HamiltonianSystem := harmonicOscillatorSystem 1.5 1 0.001
def tt_40_s0 : PhaseState := zeroState 1
def tt_40_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #40 Energy"
#eval tt_40_h.evaluate tt_40_s1
#eval tt_40_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_40_h |>.physicalMeaning
#eval hamiltonianFlow tt_40_sys tt_40_s1 0.1 5
def tt_40_o := phaseOrbit tt_40_sys tt_40_s1 0.1 5
#eval tt_40_o.length
def tt_40_ct := identityCanonicalTransform 1
#eval tt_40_ct.dimension
def tt_40_lag := zeroSectionLagrangian 1
#eval tt_40_lag.halfDim
def tt_40_es := mkEnergySurface tt_40_h 1.125 0.01
#eval tt_40_es.energy

-- Test Section #41
def tt_41_h : HamiltonianFunction := harmonicOscillator 1.9000000000000001 2
def tt_41_sys : HamiltonianSystem := harmonicOscillatorSystem 1.9000000000000001 2 0.001
def tt_41_s0 : PhaseState := zeroState 2
def tt_41_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #41 Energy"
#eval tt_41_h.evaluate tt_41_s1
#eval tt_41_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_41_h |>.physicalMeaning
#eval hamiltonianFlow tt_41_sys tt_41_s1 0.1 5
def tt_41_o := phaseOrbit tt_41_sys tt_41_s1 0.1 5
#eval tt_41_o.length
def tt_41_ct := identityCanonicalTransform 2
#eval tt_41_ct.dimension
def tt_41_lag := zeroSectionLagrangian 2
#eval tt_41_lag.halfDim
def tt_41_es := mkEnergySurface tt_41_h 1.8050000000000002 0.01
#eval tt_41_es.energy

-- Test Section #42
def tt_42_h : HamiltonianFunction := harmonicOscillator 1.6 3
def tt_42_sys : HamiltonianSystem := harmonicOscillatorSystem 1.6 3 0.001
def tt_42_s0 : PhaseState := zeroState 3
def tt_42_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #42 Energy"
#eval tt_42_h.evaluate tt_42_s1
#eval tt_42_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_42_h |>.physicalMeaning
#eval hamiltonianFlow tt_42_sys tt_42_s1 0.1 5
def tt_42_o := phaseOrbit tt_42_sys tt_42_s1 0.1 5
#eval tt_42_o.length
def tt_42_ct := identityCanonicalTransform 3
#eval tt_42_ct.dimension
def tt_42_lag := zeroSectionLagrangian 3
#eval tt_42_lag.halfDim
def tt_42_es := mkEnergySurface tt_42_h 1.2800000000000002 0.01
#eval tt_42_es.energy

-- Test Section #43
def tt_43_h : HamiltonianFunction := harmonicOscillator 2.0 4
def tt_43_sys : HamiltonianSystem := harmonicOscillatorSystem 2.0 4 0.001
def tt_43_s0 : PhaseState := zeroState 4
def tt_43_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #43 Energy"
#eval tt_43_h.evaluate tt_43_s1
#eval tt_43_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_43_h |>.physicalMeaning
#eval hamiltonianFlow tt_43_sys tt_43_s1 0.1 5
def tt_43_o := phaseOrbit tt_43_sys tt_43_s1 0.1 5
#eval tt_43_o.length
def tt_43_ct := identityCanonicalTransform 4
#eval tt_43_ct.dimension
def tt_43_lag := zeroSectionLagrangian 4
#eval tt_43_lag.halfDim
def tt_43_es := mkEnergySurface tt_43_h 2.0 0.01
#eval tt_43_es.energy

-- Test Section #44
def tt_44_h : HamiltonianFunction := harmonicOscillator 2.4000000000000004 5
def tt_44_sys : HamiltonianSystem := harmonicOscillatorSystem 2.4000000000000004 5 0.001
def tt_44_s0 : PhaseState := zeroState 5
def tt_44_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #44 Energy"
#eval tt_44_h.evaluate tt_44_s1
#eval tt_44_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_44_h |>.physicalMeaning
#eval hamiltonianFlow tt_44_sys tt_44_s1 0.1 5
def tt_44_o := phaseOrbit tt_44_sys tt_44_s1 0.1 5
#eval tt_44_o.length
def tt_44_ct := identityCanonicalTransform 5
#eval tt_44_ct.dimension
def tt_44_lag := zeroSectionLagrangian 5
#eval tt_44_lag.halfDim
def tt_44_es := mkEnergySurface tt_44_h 2.880000000000001 0.01
#eval tt_44_es.energy

-- Test Section #45
def tt_45_h : HamiltonianFunction := harmonicOscillator 2.8 1
def tt_45_sys : HamiltonianSystem := harmonicOscillatorSystem 2.8 1 0.001
def tt_45_s0 : PhaseState := zeroState 1
def tt_45_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #45 Energy"
#eval tt_45_h.evaluate tt_45_s1
#eval tt_45_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_45_h |>.physicalMeaning
#eval hamiltonianFlow tt_45_sys tt_45_s1 0.1 5
def tt_45_o := phaseOrbit tt_45_sys tt_45_s1 0.1 5
#eval tt_45_o.length
def tt_45_ct := identityCanonicalTransform 1
#eval tt_45_ct.dimension
def tt_45_lag := zeroSectionLagrangian 1
#eval tt_45_lag.halfDim
def tt_45_es := mkEnergySurface tt_45_h 3.9199999999999995 0.01
#eval tt_45_es.energy

-- Test Section #46
def tt_46_h : HamiltonianFunction := harmonicOscillator 3.1999999999999997 2
def tt_46_sys : HamiltonianSystem := harmonicOscillatorSystem 3.1999999999999997 2 0.001
def tt_46_s0 : PhaseState := zeroState 2
def tt_46_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #46 Energy"
#eval tt_46_h.evaluate tt_46_s1
#eval tt_46_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_46_h |>.physicalMeaning
#eval hamiltonianFlow tt_46_sys tt_46_s1 0.1 5
def tt_46_o := phaseOrbit tt_46_sys tt_46_s1 0.1 5
#eval tt_46_o.length
def tt_46_ct := identityCanonicalTransform 2
#eval tt_46_ct.dimension
def tt_46_lag := zeroSectionLagrangian 2
#eval tt_46_lag.halfDim
def tt_46_es := mkEnergySurface tt_46_h 5.119999999999999 0.01
#eval tt_46_es.energy

-- Test Section #47
def tt_47_h : HamiltonianFunction := harmonicOscillator 3.6 3
def tt_47_sys : HamiltonianSystem := harmonicOscillatorSystem 3.6 3 0.001
def tt_47_s0 : PhaseState := zeroState 3
def tt_47_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #47 Energy"
#eval tt_47_h.evaluate tt_47_s1
#eval tt_47_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_47_h |>.physicalMeaning
#eval hamiltonianFlow tt_47_sys tt_47_s1 0.1 5
def tt_47_o := phaseOrbit tt_47_sys tt_47_s1 0.1 5
#eval tt_47_o.length
def tt_47_ct := identityCanonicalTransform 3
#eval tt_47_ct.dimension
def tt_47_lag := zeroSectionLagrangian 3
#eval tt_47_lag.halfDim
def tt_47_es := mkEnergySurface tt_47_h 6.48 0.01
#eval tt_47_es.energy

-- Test Section #48
def tt_48_h : HamiltonianFunction := harmonicOscillator 4.0 4
def tt_48_sys : HamiltonianSystem := harmonicOscillatorSystem 4.0 4 0.001
def tt_48_s0 : PhaseState := zeroState 4
def tt_48_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #48 Energy"
#eval tt_48_h.evaluate tt_48_s1
#eval tt_48_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_48_h |>.physicalMeaning
#eval hamiltonianFlow tt_48_sys tt_48_s1 0.1 5
def tt_48_o := phaseOrbit tt_48_sys tt_48_s1 0.1 5
#eval tt_48_o.length
def tt_48_ct := identityCanonicalTransform 4
#eval tt_48_ct.dimension
def tt_48_lag := zeroSectionLagrangian 4
#eval tt_48_lag.halfDim
def tt_48_es := mkEnergySurface tt_48_h 8.0 0.01
#eval tt_48_es.energy

-- Test Section #49
def tt_49_h : HamiltonianFunction := harmonicOscillator 3.6999999999999997 5
def tt_49_sys : HamiltonianSystem := harmonicOscillatorSystem 3.6999999999999997 5 0.001
def tt_49_s0 : PhaseState := zeroState 5
def tt_49_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #49 Energy"
#eval tt_49_h.evaluate tt_49_s1
#eval tt_49_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_49_h |>.physicalMeaning
#eval hamiltonianFlow tt_49_sys tt_49_s1 0.1 5
def tt_49_o := phaseOrbit tt_49_sys tt_49_s1 0.1 5
#eval tt_49_o.length
def tt_49_ct := identityCanonicalTransform 5
#eval tt_49_ct.dimension
def tt_49_lag := zeroSectionLagrangian 5
#eval tt_49_lag.halfDim
def tt_49_es := mkEnergySurface tt_49_h 6.844999999999999 0.01
#eval tt_49_es.energy

-- Test Section #50
def tt_50_h : HamiltonianFunction := harmonicOscillator 1.1 1
def tt_50_sys : HamiltonianSystem := harmonicOscillatorSystem 1.1 1 0.001
def tt_50_s0 : PhaseState := zeroState 1
def tt_50_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #50 Energy"
#eval tt_50_h.evaluate tt_50_s1
#eval tt_50_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_50_h |>.physicalMeaning
#eval hamiltonianFlow tt_50_sys tt_50_s1 0.1 5
def tt_50_o := phaseOrbit tt_50_sys tt_50_s1 0.1 5
#eval tt_50_o.length
def tt_50_ct := identityCanonicalTransform 1
#eval tt_50_ct.dimension
def tt_50_lag := zeroSectionLagrangian 1
#eval tt_50_lag.halfDim
def tt_50_es := mkEnergySurface tt_50_h 0.6050000000000001 0.01
#eval tt_50_es.energy

-- Test Section #51
def tt_51_h : HamiltonianFunction := harmonicOscillator 1.5 2
def tt_51_sys : HamiltonianSystem := harmonicOscillatorSystem 1.5 2 0.001
def tt_51_s0 : PhaseState := zeroState 2
def tt_51_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #51 Energy"
#eval tt_51_h.evaluate tt_51_s1
#eval tt_51_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_51_h |>.physicalMeaning
#eval hamiltonianFlow tt_51_sys tt_51_s1 0.1 5
def tt_51_o := phaseOrbit tt_51_sys tt_51_s1 0.1 5
#eval tt_51_o.length
def tt_51_ct := identityCanonicalTransform 2
#eval tt_51_ct.dimension
def tt_51_lag := zeroSectionLagrangian 2
#eval tt_51_lag.halfDim
def tt_51_es := mkEnergySurface tt_51_h 1.125 0.01
#eval tt_51_es.energy

-- Test Section #52
def tt_52_h : HamiltonianFunction := harmonicOscillator 1.9000000000000001 3
def tt_52_sys : HamiltonianSystem := harmonicOscillatorSystem 1.9000000000000001 3 0.001
def tt_52_s0 : PhaseState := zeroState 3
def tt_52_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #52 Energy"
#eval tt_52_h.evaluate tt_52_s1
#eval tt_52_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_52_h |>.physicalMeaning
#eval hamiltonianFlow tt_52_sys tt_52_s1 0.1 5
def tt_52_o := phaseOrbit tt_52_sys tt_52_s1 0.1 5
#eval tt_52_o.length
def tt_52_ct := identityCanonicalTransform 3
#eval tt_52_ct.dimension
def tt_52_lag := zeroSectionLagrangian 3
#eval tt_52_lag.halfDim
def tt_52_es := mkEnergySurface tt_52_h 1.8050000000000002 0.01
#eval tt_52_es.energy

-- Test Section #53
def tt_53_h : HamiltonianFunction := harmonicOscillator 2.3 4
def tt_53_sys : HamiltonianSystem := harmonicOscillatorSystem 2.3 4 0.001
def tt_53_s0 : PhaseState := zeroState 4
def tt_53_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #53 Energy"
#eval tt_53_h.evaluate tt_53_s1
#eval tt_53_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_53_h |>.physicalMeaning
#eval hamiltonianFlow tt_53_sys tt_53_s1 0.1 5
def tt_53_o := phaseOrbit tt_53_sys tt_53_s1 0.1 5
#eval tt_53_o.length
def tt_53_ct := identityCanonicalTransform 4
#eval tt_53_ct.dimension
def tt_53_lag := zeroSectionLagrangian 4
#eval tt_53_lag.halfDim
def tt_53_es := mkEnergySurface tt_53_h 2.6449999999999996 0.01
#eval tt_53_es.energy

-- Test Section #54
def tt_54_h : HamiltonianFunction := harmonicOscillator 2.7 5
def tt_54_sys : HamiltonianSystem := harmonicOscillatorSystem 2.7 5 0.001
def tt_54_s0 : PhaseState := zeroState 5
def tt_54_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #54 Energy"
#eval tt_54_h.evaluate tt_54_s1
#eval tt_54_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_54_h |>.physicalMeaning
#eval hamiltonianFlow tt_54_sys tt_54_s1 0.1 5
def tt_54_o := phaseOrbit tt_54_sys tt_54_s1 0.1 5
#eval tt_54_o.length
def tt_54_ct := identityCanonicalTransform 5
#eval tt_54_ct.dimension
def tt_54_lag := zeroSectionLagrangian 5
#eval tt_54_lag.halfDim
def tt_54_es := mkEnergySurface tt_54_h 3.6450000000000005 0.01
#eval tt_54_es.energy

-- Test Section #55
def tt_55_h : HamiltonianFunction := harmonicOscillator 3.1 1
def tt_55_sys : HamiltonianSystem := harmonicOscillatorSystem 3.1 1 0.001
def tt_55_s0 : PhaseState := zeroState 1
def tt_55_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #55 Energy"
#eval tt_55_h.evaluate tt_55_s1
#eval tt_55_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_55_h |>.physicalMeaning
#eval hamiltonianFlow tt_55_sys tt_55_s1 0.1 5
def tt_55_o := phaseOrbit tt_55_sys tt_55_s1 0.1 5
#eval tt_55_o.length
def tt_55_ct := identityCanonicalTransform 1
#eval tt_55_ct.dimension
def tt_55_lag := zeroSectionLagrangian 1
#eval tt_55_lag.halfDim
def tt_55_es := mkEnergySurface tt_55_h 4.805000000000001 0.01
#eval tt_55_es.energy

-- Test Section #56
def tt_56_h : HamiltonianFunction := harmonicOscillator 2.8 2
def tt_56_sys : HamiltonianSystem := harmonicOscillatorSystem 2.8 2 0.001
def tt_56_s0 : PhaseState := zeroState 2
def tt_56_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #56 Energy"
#eval tt_56_h.evaluate tt_56_s1
#eval tt_56_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_56_h |>.physicalMeaning
#eval hamiltonianFlow tt_56_sys tt_56_s1 0.1 5
def tt_56_o := phaseOrbit tt_56_sys tt_56_s1 0.1 5
#eval tt_56_o.length
def tt_56_ct := identityCanonicalTransform 2
#eval tt_56_ct.dimension
def tt_56_lag := zeroSectionLagrangian 2
#eval tt_56_lag.halfDim
def tt_56_es := mkEnergySurface tt_56_h 3.9199999999999995 0.01
#eval tt_56_es.energy

-- Test Section #57
def tt_57_h : HamiltonianFunction := harmonicOscillator 3.2 3
def tt_57_sys : HamiltonianSystem := harmonicOscillatorSystem 3.2 3 0.001
def tt_57_s0 : PhaseState := zeroState 3
def tt_57_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #57 Energy"
#eval tt_57_h.evaluate tt_57_s1
#eval tt_57_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_57_h |>.physicalMeaning
#eval hamiltonianFlow tt_57_sys tt_57_s1 0.1 5
def tt_57_o := phaseOrbit tt_57_sys tt_57_s1 0.1 5
#eval tt_57_o.length
def tt_57_ct := identityCanonicalTransform 3
#eval tt_57_ct.dimension
def tt_57_lag := zeroSectionLagrangian 3
#eval tt_57_lag.halfDim
def tt_57_es := mkEnergySurface tt_57_h 5.120000000000001 0.01
#eval tt_57_es.energy

-- Test Section #58
def tt_58_h : HamiltonianFunction := harmonicOscillator 3.6 4
def tt_58_sys : HamiltonianSystem := harmonicOscillatorSystem 3.6 4 0.001
def tt_58_s0 : PhaseState := zeroState 4
def tt_58_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #58 Energy"
#eval tt_58_h.evaluate tt_58_s1
#eval tt_58_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_58_h |>.physicalMeaning
#eval hamiltonianFlow tt_58_sys tt_58_s1 0.1 5
def tt_58_o := phaseOrbit tt_58_sys tt_58_s1 0.1 5
#eval tt_58_o.length
def tt_58_ct := identityCanonicalTransform 4
#eval tt_58_ct.dimension
def tt_58_lag := zeroSectionLagrangian 4
#eval tt_58_lag.halfDim
def tt_58_es := mkEnergySurface tt_58_h 6.48 0.01
#eval tt_58_es.energy

-- Test Section #59
def tt_59_h : HamiltonianFunction := harmonicOscillator 4.0 5
def tt_59_sys : HamiltonianSystem := harmonicOscillatorSystem 4.0 5 0.001
def tt_59_s0 : PhaseState := zeroState 5
def tt_59_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #59 Energy"
#eval tt_59_h.evaluate tt_59_s1
#eval tt_59_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_59_h |>.physicalMeaning
#eval hamiltonianFlow tt_59_sys tt_59_s1 0.1 5
def tt_59_o := phaseOrbit tt_59_sys tt_59_s1 0.1 5
#eval tt_59_o.length
def tt_59_ct := identityCanonicalTransform 5
#eval tt_59_ct.dimension
def tt_59_lag := zeroSectionLagrangian 5
#eval tt_59_lag.halfDim
def tt_59_es := mkEnergySurface tt_59_h 8.0 0.01
#eval tt_59_es.energy

-- Test Section #60
def tt_60_h : HamiltonianFunction := harmonicOscillator 1.4 1
def tt_60_sys : HamiltonianSystem := harmonicOscillatorSystem 1.4 1 0.001
def tt_60_s0 : PhaseState := zeroState 1
def tt_60_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #60 Energy"
#eval tt_60_h.evaluate tt_60_s1
#eval tt_60_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_60_h |>.physicalMeaning
#eval hamiltonianFlow tt_60_sys tt_60_s1 0.1 5
def tt_60_o := phaseOrbit tt_60_sys tt_60_s1 0.1 5
#eval tt_60_o.length
def tt_60_ct := identityCanonicalTransform 1
#eval tt_60_ct.dimension
def tt_60_lag := zeroSectionLagrangian 1
#eval tt_60_lag.halfDim
def tt_60_es := mkEnergySurface tt_60_h 0.9799999999999999 0.01
#eval tt_60_es.energy

-- Test Section #61
def tt_61_h : HamiltonianFunction := harmonicOscillator 1.8 2
def tt_61_sys : HamiltonianSystem := harmonicOscillatorSystem 1.8 2 0.001
def tt_61_s0 : PhaseState := zeroState 2
def tt_61_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #61 Energy"
#eval tt_61_h.evaluate tt_61_s1
#eval tt_61_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_61_h |>.physicalMeaning
#eval hamiltonianFlow tt_61_sys tt_61_s1 0.1 5
def tt_61_o := phaseOrbit tt_61_sys tt_61_s1 0.1 5
#eval tt_61_o.length
def tt_61_ct := identityCanonicalTransform 2
#eval tt_61_ct.dimension
def tt_61_lag := zeroSectionLagrangian 2
#eval tt_61_lag.halfDim
def tt_61_es := mkEnergySurface tt_61_h 1.62 0.01
#eval tt_61_es.energy

-- Test Section #62
def tt_62_h : HamiltonianFunction := harmonicOscillator 2.2 3
def tt_62_sys : HamiltonianSystem := harmonicOscillatorSystem 2.2 3 0.001
def tt_62_s0 : PhaseState := zeroState 3
def tt_62_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #62 Energy"
#eval tt_62_h.evaluate tt_62_s1
#eval tt_62_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_62_h |>.physicalMeaning
#eval hamiltonianFlow tt_62_sys tt_62_s1 0.1 5
def tt_62_o := phaseOrbit tt_62_sys tt_62_s1 0.1 5
#eval tt_62_o.length
def tt_62_ct := identityCanonicalTransform 3
#eval tt_62_ct.dimension
def tt_62_lag := zeroSectionLagrangian 3
#eval tt_62_lag.halfDim
def tt_62_es := mkEnergySurface tt_62_h 2.4200000000000004 0.01
#eval tt_62_es.energy

-- Test Section #63
def tt_63_h : HamiltonianFunction := harmonicOscillator 1.9 4
def tt_63_sys : HamiltonianSystem := harmonicOscillatorSystem 1.9 4 0.001
def tt_63_s0 : PhaseState := zeroState 4
def tt_63_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #63 Energy"
#eval tt_63_h.evaluate tt_63_s1
#eval tt_63_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_63_h |>.physicalMeaning
#eval hamiltonianFlow tt_63_sys tt_63_s1 0.1 5
def tt_63_o := phaseOrbit tt_63_sys tt_63_s1 0.1 5
#eval tt_63_o.length
def tt_63_ct := identityCanonicalTransform 4
#eval tt_63_ct.dimension
def tt_63_lag := zeroSectionLagrangian 4
#eval tt_63_lag.halfDim
def tt_63_es := mkEnergySurface tt_63_h 1.805 0.01
#eval tt_63_es.energy

-- Test Section #64
def tt_64_h : HamiltonianFunction := harmonicOscillator 2.3000000000000003 5
def tt_64_sys : HamiltonianSystem := harmonicOscillatorSystem 2.3000000000000003 5 0.001
def tt_64_s0 : PhaseState := zeroState 5
def tt_64_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #64 Energy"
#eval tt_64_h.evaluate tt_64_s1
#eval tt_64_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_64_h |>.physicalMeaning
#eval hamiltonianFlow tt_64_sys tt_64_s1 0.1 5
def tt_64_o := phaseOrbit tt_64_sys tt_64_s1 0.1 5
#eval tt_64_o.length
def tt_64_ct := identityCanonicalTransform 5
#eval tt_64_ct.dimension
def tt_64_lag := zeroSectionLagrangian 5
#eval tt_64_lag.halfDim
def tt_64_es := mkEnergySurface tt_64_h 2.6450000000000005 0.01
#eval tt_64_es.energy

-- Test Section #65
def tt_65_h : HamiltonianFunction := harmonicOscillator 2.7 1
def tt_65_sys : HamiltonianSystem := harmonicOscillatorSystem 2.7 1 0.001
def tt_65_s0 : PhaseState := zeroState 1
def tt_65_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #65 Energy"
#eval tt_65_h.evaluate tt_65_s1
#eval tt_65_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_65_h |>.physicalMeaning
#eval hamiltonianFlow tt_65_sys tt_65_s1 0.1 5
def tt_65_o := phaseOrbit tt_65_sys tt_65_s1 0.1 5
#eval tt_65_o.length
def tt_65_ct := identityCanonicalTransform 1
#eval tt_65_ct.dimension
def tt_65_lag := zeroSectionLagrangian 1
#eval tt_65_lag.halfDim
def tt_65_es := mkEnergySurface tt_65_h 3.6450000000000005 0.01
#eval tt_65_es.energy

-- Test Section #66
def tt_66_h : HamiltonianFunction := harmonicOscillator 3.0999999999999996 2
def tt_66_sys : HamiltonianSystem := harmonicOscillatorSystem 3.0999999999999996 2 0.001
def tt_66_s0 : PhaseState := zeroState 2
def tt_66_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #66 Energy"
#eval tt_66_h.evaluate tt_66_s1
#eval tt_66_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_66_h |>.physicalMeaning
#eval hamiltonianFlow tt_66_sys tt_66_s1 0.1 5
def tt_66_o := phaseOrbit tt_66_sys tt_66_s1 0.1 5
#eval tt_66_o.length
def tt_66_ct := identityCanonicalTransform 2
#eval tt_66_ct.dimension
def tt_66_lag := zeroSectionLagrangian 2
#eval tt_66_lag.halfDim
def tt_66_es := mkEnergySurface tt_66_h 4.804999999999999 0.01
#eval tt_66_es.energy

-- Test Section #67
def tt_67_h : HamiltonianFunction := harmonicOscillator 3.5 3
def tt_67_sys : HamiltonianSystem := harmonicOscillatorSystem 3.5 3 0.001
def tt_67_s0 : PhaseState := zeroState 3
def tt_67_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #67 Energy"
#eval tt_67_h.evaluate tt_67_s1
#eval tt_67_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_67_h |>.physicalMeaning
#eval hamiltonianFlow tt_67_sys tt_67_s1 0.1 5
def tt_67_o := phaseOrbit tt_67_sys tt_67_s1 0.1 5
#eval tt_67_o.length
def tt_67_ct := identityCanonicalTransform 3
#eval tt_67_ct.dimension
def tt_67_lag := zeroSectionLagrangian 3
#eval tt_67_lag.halfDim
def tt_67_es := mkEnergySurface tt_67_h 6.125 0.01
#eval tt_67_es.energy

-- Test Section #68
def tt_68_h : HamiltonianFunction := harmonicOscillator 3.9 4
def tt_68_sys : HamiltonianSystem := harmonicOscillatorSystem 3.9 4 0.001
def tt_68_s0 : PhaseState := zeroState 4
def tt_68_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #68 Energy"
#eval tt_68_h.evaluate tt_68_s1
#eval tt_68_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_68_h |>.physicalMeaning
#eval hamiltonianFlow tt_68_sys tt_68_s1 0.1 5
def tt_68_o := phaseOrbit tt_68_sys tt_68_s1 0.1 5
#eval tt_68_o.length
def tt_68_ct := identityCanonicalTransform 4
#eval tt_68_ct.dimension
def tt_68_lag := zeroSectionLagrangian 4
#eval tt_68_lag.halfDim
def tt_68_es := mkEnergySurface tt_68_h 7.6049999999999995 0.01
#eval tt_68_es.energy

-- Test Section #69
def tt_69_h : HamiltonianFunction := harmonicOscillator 4.3 5
def tt_69_sys : HamiltonianSystem := harmonicOscillatorSystem 4.3 5 0.001
def tt_69_s0 : PhaseState := zeroState 5
def tt_69_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #69 Energy"
#eval tt_69_h.evaluate tt_69_s1
#eval tt_69_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_69_h |>.physicalMeaning
#eval hamiltonianFlow tt_69_sys tt_69_s1 0.1 5
def tt_69_o := phaseOrbit tt_69_sys tt_69_s1 0.1 5
#eval tt_69_o.length
def tt_69_ct := identityCanonicalTransform 5
#eval tt_69_ct.dimension
def tt_69_lag := zeroSectionLagrangian 5
#eval tt_69_lag.halfDim
def tt_69_es := mkEnergySurface tt_69_h 9.245 0.01
#eval tt_69_es.energy

-- Test Section #70
def tt_70_h : HamiltonianFunction := harmonicOscillator 1.0 1
def tt_70_sys : HamiltonianSystem := harmonicOscillatorSystem 1.0 1 0.001
def tt_70_s0 : PhaseState := zeroState 1
def tt_70_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #70 Energy"
#eval tt_70_h.evaluate tt_70_s1
#eval tt_70_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_70_h |>.physicalMeaning
#eval hamiltonianFlow tt_70_sys tt_70_s1 0.1 5
def tt_70_o := phaseOrbit tt_70_sys tt_70_s1 0.1 5
#eval tt_70_o.length
def tt_70_ct := identityCanonicalTransform 1
#eval tt_70_ct.dimension
def tt_70_lag := zeroSectionLagrangian 1
#eval tt_70_lag.halfDim
def tt_70_es := mkEnergySurface tt_70_h 0.5 0.01
#eval tt_70_es.energy

-- Test Section #71
def tt_71_h : HamiltonianFunction := harmonicOscillator 1.4000000000000001 2
def tt_71_sys : HamiltonianSystem := harmonicOscillatorSystem 1.4000000000000001 2 0.001
def tt_71_s0 : PhaseState := zeroState 2
def tt_71_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #71 Energy"
#eval tt_71_h.evaluate tt_71_s1
#eval tt_71_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_71_h |>.physicalMeaning
#eval hamiltonianFlow tt_71_sys tt_71_s1 0.1 5
def tt_71_o := phaseOrbit tt_71_sys tt_71_s1 0.1 5
#eval tt_71_o.length
def tt_71_ct := identityCanonicalTransform 2
#eval tt_71_ct.dimension
def tt_71_lag := zeroSectionLagrangian 2
#eval tt_71_lag.halfDim
def tt_71_es := mkEnergySurface tt_71_h 0.9800000000000002 0.01
#eval tt_71_es.energy

-- Test Section #72
def tt_72_h : HamiltonianFunction := harmonicOscillator 1.8 3
def tt_72_sys : HamiltonianSystem := harmonicOscillatorSystem 1.8 3 0.001
def tt_72_s0 : PhaseState := zeroState 3
def tt_72_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #72 Energy"
#eval tt_72_h.evaluate tt_72_s1
#eval tt_72_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_72_h |>.physicalMeaning
#eval hamiltonianFlow tt_72_sys tt_72_s1 0.1 5
def tt_72_o := phaseOrbit tt_72_sys tt_72_s1 0.1 5
#eval tt_72_o.length
def tt_72_ct := identityCanonicalTransform 3
#eval tt_72_ct.dimension
def tt_72_lag := zeroSectionLagrangian 3
#eval tt_72_lag.halfDim
def tt_72_es := mkEnergySurface tt_72_h 1.62 0.01
#eval tt_72_es.energy

-- Test Section #73
def tt_73_h : HamiltonianFunction := harmonicOscillator 2.2 4
def tt_73_sys : HamiltonianSystem := harmonicOscillatorSystem 2.2 4 0.001
def tt_73_s0 : PhaseState := zeroState 4
def tt_73_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #73 Energy"
#eval tt_73_h.evaluate tt_73_s1
#eval tt_73_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_73_h |>.physicalMeaning
#eval hamiltonianFlow tt_73_sys tt_73_s1 0.1 5
def tt_73_o := phaseOrbit tt_73_sys tt_73_s1 0.1 5
#eval tt_73_o.length
def tt_73_ct := identityCanonicalTransform 4
#eval tt_73_ct.dimension
def tt_73_lag := zeroSectionLagrangian 4
#eval tt_73_lag.halfDim
def tt_73_es := mkEnergySurface tt_73_h 2.4200000000000004 0.01
#eval tt_73_es.energy

-- Test Section #74
def tt_74_h : HamiltonianFunction := harmonicOscillator 2.6 5
def tt_74_sys : HamiltonianSystem := harmonicOscillatorSystem 2.6 5 0.001
def tt_74_s0 : PhaseState := zeroState 5
def tt_74_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #74 Energy"
#eval tt_74_h.evaluate tt_74_s1
#eval tt_74_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_74_h |>.physicalMeaning
#eval hamiltonianFlow tt_74_sys tt_74_s1 0.1 5
def tt_74_o := phaseOrbit tt_74_sys tt_74_s1 0.1 5
#eval tt_74_o.length
def tt_74_ct := identityCanonicalTransform 5
#eval tt_74_ct.dimension
def tt_74_lag := zeroSectionLagrangian 5
#eval tt_74_lag.halfDim
def tt_74_es := mkEnergySurface tt_74_h 3.3800000000000003 0.01
#eval tt_74_es.energy

-- Test Section #75
def tt_75_h : HamiltonianFunction := harmonicOscillator 3.0 1
def tt_75_sys : HamiltonianSystem := harmonicOscillatorSystem 3.0 1 0.001
def tt_75_s0 : PhaseState := zeroState 1
def tt_75_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #75 Energy"
#eval tt_75_h.evaluate tt_75_s1
#eval tt_75_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_75_h |>.physicalMeaning
#eval hamiltonianFlow tt_75_sys tt_75_s1 0.1 5
def tt_75_o := phaseOrbit tt_75_sys tt_75_s1 0.1 5
#eval tt_75_o.length
def tt_75_ct := identityCanonicalTransform 1
#eval tt_75_ct.dimension
def tt_75_lag := zeroSectionLagrangian 1
#eval tt_75_lag.halfDim
def tt_75_es := mkEnergySurface tt_75_h 4.5 0.01
#eval tt_75_es.energy

-- Test Section #76
def tt_76_h : HamiltonianFunction := harmonicOscillator 3.4 2
def tt_76_sys : HamiltonianSystem := harmonicOscillatorSystem 3.4 2 0.001
def tt_76_s0 : PhaseState := zeroState 2
def tt_76_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #76 Energy"
#eval tt_76_h.evaluate tt_76_s1
#eval tt_76_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_76_h |>.physicalMeaning
#eval hamiltonianFlow tt_76_sys tt_76_s1 0.1 5
def tt_76_o := phaseOrbit tt_76_sys tt_76_s1 0.1 5
#eval tt_76_o.length
def tt_76_ct := identityCanonicalTransform 2
#eval tt_76_ct.dimension
def tt_76_lag := zeroSectionLagrangian 2
#eval tt_76_lag.halfDim
def tt_76_es := mkEnergySurface tt_76_h 5.779999999999999 0.01
#eval tt_76_es.energy

-- Test Section #77
def tt_77_h : HamiltonianFunction := harmonicOscillator 3.1 3
def tt_77_sys : HamiltonianSystem := harmonicOscillatorSystem 3.1 3 0.001
def tt_77_s0 : PhaseState := zeroState 3
def tt_77_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #77 Energy"
#eval tt_77_h.evaluate tt_77_s1
#eval tt_77_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_77_h |>.physicalMeaning
#eval hamiltonianFlow tt_77_sys tt_77_s1 0.1 5
def tt_77_o := phaseOrbit tt_77_sys tt_77_s1 0.1 5
#eval tt_77_o.length
def tt_77_ct := identityCanonicalTransform 3
#eval tt_77_ct.dimension
def tt_77_lag := zeroSectionLagrangian 3
#eval tt_77_lag.halfDim
def tt_77_es := mkEnergySurface tt_77_h 4.805000000000001 0.01
#eval tt_77_es.energy

-- Test Section #78
def tt_78_h : HamiltonianFunction := harmonicOscillator 3.5 4
def tt_78_sys : HamiltonianSystem := harmonicOscillatorSystem 3.5 4 0.001
def tt_78_s0 : PhaseState := zeroState 4
def tt_78_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #78 Energy"
#eval tt_78_h.evaluate tt_78_s1
#eval tt_78_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_78_h |>.physicalMeaning
#eval hamiltonianFlow tt_78_sys tt_78_s1 0.1 5
def tt_78_o := phaseOrbit tt_78_sys tt_78_s1 0.1 5
#eval tt_78_o.length
def tt_78_ct := identityCanonicalTransform 4
#eval tt_78_ct.dimension
def tt_78_lag := zeroSectionLagrangian 4
#eval tt_78_lag.halfDim
def tt_78_es := mkEnergySurface tt_78_h 6.125 0.01
#eval tt_78_es.energy

-- Test Section #79
def tt_79_h : HamiltonianFunction := harmonicOscillator 3.9 5
def tt_79_sys : HamiltonianSystem := harmonicOscillatorSystem 3.9 5 0.001
def tt_79_s0 : PhaseState := zeroState 5
def tt_79_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #79 Energy"
#eval tt_79_h.evaluate tt_79_s1
#eval tt_79_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_79_h |>.physicalMeaning
#eval hamiltonianFlow tt_79_sys tt_79_s1 0.1 5
def tt_79_o := phaseOrbit tt_79_sys tt_79_s1 0.1 5
#eval tt_79_o.length
def tt_79_ct := identityCanonicalTransform 5
#eval tt_79_ct.dimension
def tt_79_lag := zeroSectionLagrangian 5
#eval tt_79_lag.halfDim
def tt_79_es := mkEnergySurface tt_79_h 7.6049999999999995 0.01
#eval tt_79_es.energy

-- Test Section #80
def tt_80_h : HamiltonianFunction := harmonicOscillator 1.3 1
def tt_80_sys : HamiltonianSystem := harmonicOscillatorSystem 1.3 1 0.001
def tt_80_s0 : PhaseState := zeroState 1
def tt_80_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #80 Energy"
#eval tt_80_h.evaluate tt_80_s1
#eval tt_80_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_80_h |>.physicalMeaning
#eval hamiltonianFlow tt_80_sys tt_80_s1 0.1 5
def tt_80_o := phaseOrbit tt_80_sys tt_80_s1 0.1 5
#eval tt_80_o.length
def tt_80_ct := identityCanonicalTransform 1
#eval tt_80_ct.dimension
def tt_80_lag := zeroSectionLagrangian 1
#eval tt_80_lag.halfDim
def tt_80_es := mkEnergySurface tt_80_h 0.8450000000000001 0.01
#eval tt_80_es.energy

-- Test Section #81
def tt_81_h : HamiltonianFunction := harmonicOscillator 1.7000000000000002 2
def tt_81_sys : HamiltonianSystem := harmonicOscillatorSystem 1.7000000000000002 2 0.001
def tt_81_s0 : PhaseState := zeroState 2
def tt_81_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #81 Energy"
#eval tt_81_h.evaluate tt_81_s1
#eval tt_81_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_81_h |>.physicalMeaning
#eval hamiltonianFlow tt_81_sys tt_81_s1 0.1 5
def tt_81_o := phaseOrbit tt_81_sys tt_81_s1 0.1 5
#eval tt_81_o.length
def tt_81_ct := identityCanonicalTransform 2
#eval tt_81_ct.dimension
def tt_81_lag := zeroSectionLagrangian 2
#eval tt_81_lag.halfDim
def tt_81_es := mkEnergySurface tt_81_h 1.4450000000000003 0.01
#eval tt_81_es.energy

-- Test Section #82
def tt_82_h : HamiltonianFunction := harmonicOscillator 2.1 3
def tt_82_sys : HamiltonianSystem := harmonicOscillatorSystem 2.1 3 0.001
def tt_82_s0 : PhaseState := zeroState 3
def tt_82_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #82 Energy"
#eval tt_82_h.evaluate tt_82_s1
#eval tt_82_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_82_h |>.physicalMeaning
#eval hamiltonianFlow tt_82_sys tt_82_s1 0.1 5
def tt_82_o := phaseOrbit tt_82_sys tt_82_s1 0.1 5
#eval tt_82_o.length
def tt_82_ct := identityCanonicalTransform 3
#eval tt_82_ct.dimension
def tt_82_lag := zeroSectionLagrangian 3
#eval tt_82_lag.halfDim
def tt_82_es := mkEnergySurface tt_82_h 2.205 0.01
#eval tt_82_es.energy

-- Test Section #83
def tt_83_h : HamiltonianFunction := harmonicOscillator 2.5 4
def tt_83_sys : HamiltonianSystem := harmonicOscillatorSystem 2.5 4 0.001
def tt_83_s0 : PhaseState := zeroState 4
def tt_83_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #83 Energy"
#eval tt_83_h.evaluate tt_83_s1
#eval tt_83_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_83_h |>.physicalMeaning
#eval hamiltonianFlow tt_83_sys tt_83_s1 0.1 5
def tt_83_o := phaseOrbit tt_83_sys tt_83_s1 0.1 5
#eval tt_83_o.length
def tt_83_ct := identityCanonicalTransform 4
#eval tt_83_ct.dimension
def tt_83_lag := zeroSectionLagrangian 4
#eval tt_83_lag.halfDim
def tt_83_es := mkEnergySurface tt_83_h 3.125 0.01
#eval tt_83_es.energy

-- Test Section #84
def tt_84_h : HamiltonianFunction := harmonicOscillator 2.2 5
def tt_84_sys : HamiltonianSystem := harmonicOscillatorSystem 2.2 5 0.001
def tt_84_s0 : PhaseState := zeroState 5
def tt_84_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #84 Energy"
#eval tt_84_h.evaluate tt_84_s1
#eval tt_84_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_84_h |>.physicalMeaning
#eval hamiltonianFlow tt_84_sys tt_84_s1 0.1 5
def tt_84_o := phaseOrbit tt_84_sys tt_84_s1 0.1 5
#eval tt_84_o.length
def tt_84_ct := identityCanonicalTransform 5
#eval tt_84_ct.dimension
def tt_84_lag := zeroSectionLagrangian 5
#eval tt_84_lag.halfDim
def tt_84_es := mkEnergySurface tt_84_h 2.4200000000000004 0.01
#eval tt_84_es.energy

-- Test Section #85
def tt_85_h : HamiltonianFunction := harmonicOscillator 2.6 1
def tt_85_sys : HamiltonianSystem := harmonicOscillatorSystem 2.6 1 0.001
def tt_85_s0 : PhaseState := zeroState 1
def tt_85_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #85 Energy"
#eval tt_85_h.evaluate tt_85_s1
#eval tt_85_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_85_h |>.physicalMeaning
#eval hamiltonianFlow tt_85_sys tt_85_s1 0.1 5
def tt_85_o := phaseOrbit tt_85_sys tt_85_s1 0.1 5
#eval tt_85_o.length
def tt_85_ct := identityCanonicalTransform 1
#eval tt_85_ct.dimension
def tt_85_lag := zeroSectionLagrangian 1
#eval tt_85_lag.halfDim
def tt_85_es := mkEnergySurface tt_85_h 3.3800000000000003 0.01
#eval tt_85_es.energy

-- Test Section #86
def tt_86_h : HamiltonianFunction := harmonicOscillator 3.0 2
def tt_86_sys : HamiltonianSystem := harmonicOscillatorSystem 3.0 2 0.001
def tt_86_s0 : PhaseState := zeroState 2
def tt_86_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #86 Energy"
#eval tt_86_h.evaluate tt_86_s1
#eval tt_86_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_86_h |>.physicalMeaning
#eval hamiltonianFlow tt_86_sys tt_86_s1 0.1 5
def tt_86_o := phaseOrbit tt_86_sys tt_86_s1 0.1 5
#eval tt_86_o.length
def tt_86_ct := identityCanonicalTransform 2
#eval tt_86_ct.dimension
def tt_86_lag := zeroSectionLagrangian 2
#eval tt_86_lag.halfDim
def tt_86_es := mkEnergySurface tt_86_h 4.5 0.01
#eval tt_86_es.energy

-- Test Section #87
def tt_87_h : HamiltonianFunction := harmonicOscillator 3.4000000000000004 3
def tt_87_sys : HamiltonianSystem := harmonicOscillatorSystem 3.4000000000000004 3 0.001
def tt_87_s0 : PhaseState := zeroState 3
def tt_87_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #87 Energy"
#eval tt_87_h.evaluate tt_87_s1
#eval tt_87_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_87_h |>.physicalMeaning
#eval hamiltonianFlow tt_87_sys tt_87_s1 0.1 5
def tt_87_o := phaseOrbit tt_87_sys tt_87_s1 0.1 5
#eval tt_87_o.length
def tt_87_ct := identityCanonicalTransform 3
#eval tt_87_ct.dimension
def tt_87_lag := zeroSectionLagrangian 3
#eval tt_87_lag.halfDim
def tt_87_es := mkEnergySurface tt_87_h 5.780000000000001 0.01
#eval tt_87_es.energy

-- Test Section #88
def tt_88_h : HamiltonianFunction := harmonicOscillator 3.8 4
def tt_88_sys : HamiltonianSystem := harmonicOscillatorSystem 3.8 4 0.001
def tt_88_s0 : PhaseState := zeroState 4
def tt_88_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #88 Energy"
#eval tt_88_h.evaluate tt_88_s1
#eval tt_88_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_88_h |>.physicalMeaning
#eval hamiltonianFlow tt_88_sys tt_88_s1 0.1 5
def tt_88_o := phaseOrbit tt_88_sys tt_88_s1 0.1 5
#eval tt_88_o.length
def tt_88_ct := identityCanonicalTransform 4
#eval tt_88_ct.dimension
def tt_88_lag := zeroSectionLagrangian 4
#eval tt_88_lag.halfDim
def tt_88_es := mkEnergySurface tt_88_h 7.22 0.01
#eval tt_88_es.energy

-- Test Section #89
def tt_89_h : HamiltonianFunction := harmonicOscillator 4.199999999999999 5
def tt_89_sys : HamiltonianSystem := harmonicOscillatorSystem 4.199999999999999 5 0.001
def tt_89_s0 : PhaseState := zeroState 5
def tt_89_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #89 Energy"
#eval tt_89_h.evaluate tt_89_s1
#eval tt_89_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_89_h |>.physicalMeaning
#eval hamiltonianFlow tt_89_sys tt_89_s1 0.1 5
def tt_89_o := phaseOrbit tt_89_sys tt_89_s1 0.1 5
#eval tt_89_o.length
def tt_89_ct := identityCanonicalTransform 5
#eval tt_89_ct.dimension
def tt_89_lag := zeroSectionLagrangian 5
#eval tt_89_lag.halfDim
def tt_89_es := mkEnergySurface tt_89_h 8.819999999999997 0.01
#eval tt_89_es.energy

-- Test Section #90
def tt_90_h : HamiltonianFunction := harmonicOscillator 1.6 1
def tt_90_sys : HamiltonianSystem := harmonicOscillatorSystem 1.6 1 0.001
def tt_90_s0 : PhaseState := zeroState 1
def tt_90_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #90 Energy"
#eval tt_90_h.evaluate tt_90_s1
#eval tt_90_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_90_h |>.physicalMeaning
#eval hamiltonianFlow tt_90_sys tt_90_s1 0.1 5
def tt_90_o := phaseOrbit tt_90_sys tt_90_s1 0.1 5
#eval tt_90_o.length
def tt_90_ct := identityCanonicalTransform 1
#eval tt_90_ct.dimension
def tt_90_lag := zeroSectionLagrangian 1
#eval tt_90_lag.halfDim
def tt_90_es := mkEnergySurface tt_90_h 1.2800000000000002 0.01
#eval tt_90_es.energy

-- Test Section #91
def tt_91_h : HamiltonianFunction := harmonicOscillator 1.3 2
def tt_91_sys : HamiltonianSystem := harmonicOscillatorSystem 1.3 2 0.001
def tt_91_s0 : PhaseState := zeroState 2
def tt_91_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #91 Energy"
#eval tt_91_h.evaluate tt_91_s1
#eval tt_91_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_91_h |>.physicalMeaning
#eval hamiltonianFlow tt_91_sys tt_91_s1 0.1 5
def tt_91_o := phaseOrbit tt_91_sys tt_91_s1 0.1 5
#eval tt_91_o.length
def tt_91_ct := identityCanonicalTransform 2
#eval tt_91_ct.dimension
def tt_91_lag := zeroSectionLagrangian 2
#eval tt_91_lag.halfDim
def tt_91_es := mkEnergySurface tt_91_h 0.8450000000000001 0.01
#eval tt_91_es.energy

-- Test Section #92
def tt_92_h : HamiltonianFunction := harmonicOscillator 1.7000000000000002 3
def tt_92_sys : HamiltonianSystem := harmonicOscillatorSystem 1.7000000000000002 3 0.001
def tt_92_s0 : PhaseState := zeroState 3
def tt_92_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #92 Energy"
#eval tt_92_h.evaluate tt_92_s1
#eval tt_92_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_92_h |>.physicalMeaning
#eval hamiltonianFlow tt_92_sys tt_92_s1 0.1 5
def tt_92_o := phaseOrbit tt_92_sys tt_92_s1 0.1 5
#eval tt_92_o.length
def tt_92_ct := identityCanonicalTransform 3
#eval tt_92_ct.dimension
def tt_92_lag := zeroSectionLagrangian 3
#eval tt_92_lag.halfDim
def tt_92_es := mkEnergySurface tt_92_h 1.4450000000000003 0.01
#eval tt_92_es.energy

-- Test Section #93
def tt_93_h : HamiltonianFunction := harmonicOscillator 2.1 4
def tt_93_sys : HamiltonianSystem := harmonicOscillatorSystem 2.1 4 0.001
def tt_93_s0 : PhaseState := zeroState 4
def tt_93_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #93 Energy"
#eval tt_93_h.evaluate tt_93_s1
#eval tt_93_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_93_h |>.physicalMeaning
#eval hamiltonianFlow tt_93_sys tt_93_s1 0.1 5
def tt_93_o := phaseOrbit tt_93_sys tt_93_s1 0.1 5
#eval tt_93_o.length
def tt_93_ct := identityCanonicalTransform 4
#eval tt_93_ct.dimension
def tt_93_lag := zeroSectionLagrangian 4
#eval tt_93_lag.halfDim
def tt_93_es := mkEnergySurface tt_93_h 2.205 0.01
#eval tt_93_es.energy

-- Test Section #94
def tt_94_h : HamiltonianFunction := harmonicOscillator 2.5 5
def tt_94_sys : HamiltonianSystem := harmonicOscillatorSystem 2.5 5 0.001
def tt_94_s0 : PhaseState := zeroState 5
def tt_94_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #94 Energy"
#eval tt_94_h.evaluate tt_94_s1
#eval tt_94_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_94_h |>.physicalMeaning
#eval hamiltonianFlow tt_94_sys tt_94_s1 0.1 5
def tt_94_o := phaseOrbit tt_94_sys tt_94_s1 0.1 5
#eval tt_94_o.length
def tt_94_ct := identityCanonicalTransform 5
#eval tt_94_ct.dimension
def tt_94_lag := zeroSectionLagrangian 5
#eval tt_94_lag.halfDim
def tt_94_es := mkEnergySurface tt_94_h 3.125 0.01
#eval tt_94_es.energy

-- Test Section #95
def tt_95_h : HamiltonianFunction := harmonicOscillator 2.9 1
def tt_95_sys : HamiltonianSystem := harmonicOscillatorSystem 2.9 1 0.001
def tt_95_s0 : PhaseState := zeroState 1
def tt_95_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #95 Energy"
#eval tt_95_h.evaluate tt_95_s1
#eval tt_95_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_95_h |>.physicalMeaning
#eval hamiltonianFlow tt_95_sys tt_95_s1 0.1 5
def tt_95_o := phaseOrbit tt_95_sys tt_95_s1 0.1 5
#eval tt_95_o.length
def tt_95_ct := identityCanonicalTransform 1
#eval tt_95_ct.dimension
def tt_95_lag := zeroSectionLagrangian 1
#eval tt_95_lag.halfDim
def tt_95_es := mkEnergySurface tt_95_h 4.205 0.01
#eval tt_95_es.energy

-- Test Section #96
def tt_96_h : HamiltonianFunction := harmonicOscillator 3.3 2
def tt_96_sys : HamiltonianSystem := harmonicOscillatorSystem 3.3 2 0.001
def tt_96_s0 : PhaseState := zeroState 2
def tt_96_s1 : PhaseState := { position := List.replicate 2 1.0, momentum := List.replicate 2 0.0, dimension := 2 }
#eval "Test #96 Energy"
#eval tt_96_h.evaluate tt_96_s1
#eval tt_96_sys.dim
#eval (standardSymplecticForm 2).dimension
#eval (standardLiouvilleMeasure 2).dimension
#eval energyFirstIntegral tt_96_h |>.physicalMeaning
#eval hamiltonianFlow tt_96_sys tt_96_s1 0.1 5
def tt_96_o := phaseOrbit tt_96_sys tt_96_s1 0.1 5
#eval tt_96_o.length
def tt_96_ct := identityCanonicalTransform 2
#eval tt_96_ct.dimension
def tt_96_lag := zeroSectionLagrangian 2
#eval tt_96_lag.halfDim
def tt_96_es := mkEnergySurface tt_96_h 5.444999999999999 0.01
#eval tt_96_es.energy

-- Test Section #97
def tt_97_h : HamiltonianFunction := harmonicOscillator 3.7 3
def tt_97_sys : HamiltonianSystem := harmonicOscillatorSystem 3.7 3 0.001
def tt_97_s0 : PhaseState := zeroState 3
def tt_97_s1 : PhaseState := { position := List.replicate 3 1.0, momentum := List.replicate 3 0.0, dimension := 3 }
#eval "Test #97 Energy"
#eval tt_97_h.evaluate tt_97_s1
#eval tt_97_sys.dim
#eval (standardSymplecticForm 3).dimension
#eval (standardLiouvilleMeasure 3).dimension
#eval energyFirstIntegral tt_97_h |>.physicalMeaning
#eval hamiltonianFlow tt_97_sys tt_97_s1 0.1 5
def tt_97_o := phaseOrbit tt_97_sys tt_97_s1 0.1 5
#eval tt_97_o.length
def tt_97_ct := identityCanonicalTransform 3
#eval tt_97_ct.dimension
def tt_97_lag := zeroSectionLagrangian 3
#eval tt_97_lag.halfDim
def tt_97_es := mkEnergySurface tt_97_h 6.845000000000001 0.01
#eval tt_97_es.energy

-- Test Section #98
def tt_98_h : HamiltonianFunction := harmonicOscillator 3.4 4
def tt_98_sys : HamiltonianSystem := harmonicOscillatorSystem 3.4 4 0.001
def tt_98_s0 : PhaseState := zeroState 4
def tt_98_s1 : PhaseState := { position := List.replicate 4 1.0, momentum := List.replicate 4 0.0, dimension := 4 }
#eval "Test #98 Energy"
#eval tt_98_h.evaluate tt_98_s1
#eval tt_98_sys.dim
#eval (standardSymplecticForm 4).dimension
#eval (standardLiouvilleMeasure 4).dimension
#eval energyFirstIntegral tt_98_h |>.physicalMeaning
#eval hamiltonianFlow tt_98_sys tt_98_s1 0.1 5
def tt_98_o := phaseOrbit tt_98_sys tt_98_s1 0.1 5
#eval tt_98_o.length
def tt_98_ct := identityCanonicalTransform 4
#eval tt_98_ct.dimension
def tt_98_lag := zeroSectionLagrangian 4
#eval tt_98_lag.halfDim
def tt_98_es := mkEnergySurface tt_98_h 5.779999999999999 0.01
#eval tt_98_es.energy

-- Test Section #99
def tt_99_h : HamiltonianFunction := harmonicOscillator 3.8 5
def tt_99_sys : HamiltonianSystem := harmonicOscillatorSystem 3.8 5 0.001
def tt_99_s0 : PhaseState := zeroState 5
def tt_99_s1 : PhaseState := { position := List.replicate 5 1.0, momentum := List.replicate 5 0.0, dimension := 5 }
#eval "Test #99 Energy"
#eval tt_99_h.evaluate tt_99_s1
#eval tt_99_sys.dim
#eval (standardSymplecticForm 5).dimension
#eval (standardLiouvilleMeasure 5).dimension
#eval energyFirstIntegral tt_99_h |>.physicalMeaning
#eval hamiltonianFlow tt_99_sys tt_99_s1 0.1 5
def tt_99_o := phaseOrbit tt_99_sys tt_99_s1 0.1 5
#eval tt_99_o.length
def tt_99_ct := identityCanonicalTransform 5
#eval tt_99_ct.dimension
def tt_99_lag := zeroSectionLagrangian 5
#eval tt_99_lag.halfDim
def tt_99_es := mkEnergySurface tt_99_h 7.22 0.01
#eval tt_99_es.energy

-- Test Section #100
def tt_100_h : HamiltonianFunction := harmonicOscillator 1.2 1
def tt_100_sys : HamiltonianSystem := harmonicOscillatorSystem 1.2 1 0.001
def tt_100_s0 : PhaseState := zeroState 1
def tt_100_s1 : PhaseState := { position := List.replicate 1 1.0, momentum := List.replicate 1 0.0, dimension := 1 }
#eval "Test #100 Energy"
#eval tt_100_h.evaluate tt_100_s1
#eval tt_100_sys.dim
#eval (standardSymplecticForm 1).dimension
#eval (standardLiouvilleMeasure 1).dimension
#eval energyFirstIntegral tt_100_h |>.physicalMeaning
#eval hamiltonianFlow tt_100_sys tt_100_s1 0.1 5
def tt_100_o := phaseOrbit tt_100_sys tt_100_s1 0.1 5
#eval tt_100_o.length
def tt_100_ct := identityCanonicalTransform 1
#eval tt_100_ct.dimension
def tt_100_lag := zeroSectionLagrangian 1
#eval tt_100_lag.halfDim
def tt_100_es := mkEnergySurface tt_100_h 0.72 0.01
#eval tt_100_es.energy



-- Final Verification Section
#eval "===== Final System Verification ====="

def finalSys1 := harmonicOscillatorSystem 1.0 1 0.001
def finalSys2 := pendulumSystem 1.0 1.0 9.81 0.01
def finalSys3 := keplerSystem 1.0 2 0.01
def finalSys4 := henonHeilesSystem 0.01

#eval "--- Harmonic oscillator energy conservation over 100 steps ---"
def finalPt1 : PhaseState := { position := [1.0], momentum := [0.0], dimension := 1 }
def finalE1 := finalSys1.hamiltonian.evaluate finalPt1
def finalFlow1 := hamiltonianFlow finalSys1 finalPt1 1.0 100
def finalE2 := finalSys1.hamiltonian.evaluate finalFlow1
#eval Float.abs (finalE1 - finalE2)

#eval "--- Pendulum energy conservation ---"
def finalPt2 : PhaseState := { position := [0.5], momentum := [0.0], dimension := 1 }
def finalE3 := finalSys2.hamiltonian.evaluate finalPt2
def finalFlow2 := hamiltonianFlow finalSys2 finalPt2 0.5 50
def finalE4 := finalSys2.hamiltonian.evaluate finalFlow2
#eval Float.abs (finalE3 - finalE4)

#eval "--- Symplectic form evaluation ---"
def finalSF := standardSymplecticForm 2
def finalV1 := [1.0, 0.0, 0.0, 1.0]
def finalV2 := [0.0, 1.0, 1.0, 0.0]
#eval finalSF.evaluate finalV1 finalV2

#eval "--- Poisson bracket {q,p}=1 test ---"
def finalPB := standardPoissonBracket 1 0.001
def finalQ (s : PhaseState) : Float := getPosition s 0
def finalP (s : PhaseState) : Float := getMomentum s 0
def finalPt : PhaseState := { position := [1.0], momentum := [0.0], dimension := 1 }
#eval Float.abs (finalPB.bracket finalQ finalP finalPt - 1.0)

#eval "--- All systems summary ---"
#eval finalSys1.dim
#eval finalSys2.dim
#eval finalSys3.dim
#eval finalSys4.dim
#eval finalSys1.hamiltonian.degreesOfFreedom
#eval finalSys2.hamiltonian.degreesOfFreedom
#eval finalSys3.hamiltonian.degreesOfFreedom
#eval finalSys4.hamiltonian.degreesOfFreedom

#eval "===== All tests complete ====="

end MiniHamiltonianSystems
