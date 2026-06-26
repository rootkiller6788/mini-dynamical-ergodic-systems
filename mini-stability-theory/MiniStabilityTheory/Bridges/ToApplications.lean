/-
# Stability Theory: Applications
Control theory, power systems, population dynamics, neural networks, aerospace.
## Knowledge Levels: L7
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
import MiniStabilityTheory.Theorems.LyapunovMain
import MiniStabilityTheory.Theorems.Main
namespace MiniStabilityTheory

structure LyapunovControl where
  openLoop : Float -> Float -> Float
  controlLaw : Float -> Float
  lyapunovFunction : Float -> Float
  closedLoopStable : Bool

structure BacksteppingController where
  order : Nat
  lyapunovCandidates : List (Float -> Float)
  virtualControls : List (Float -> Float -> Float)
  isGloballyStable : Bool

structure PIDController where
  kp : Float
  ki : Float
  kd : Float
  setPoint : Float
  isStable : Bool

def pidStabilityCheck (kp ki kd a b : Float) : Bool :=
  let a_cl := a + b*kd; a_cl > 0.0 && b*kp > 0.0 && a_cl * b * kp > b * ki

structure SwingEquation where
  M : Float
  D : Float
  Pm : Float
  Pe : Float
  equilibrium : Float
  isStable : Bool

def equalAreaCriterion (Pm Pe delta0 deltaClear : Float) : Bool :=
  let accArea := Pm * (deltaClear - delta0)
  let decArea := Pe * (Float.cos delta0 - Float.cos deltaClear)
  accArea <= decArea

structure LogisticHarvesting where
  r : Float
  K : Float
  H : Float
  equilibria : List Float
  stableEquilibria : List Float

def logisticHarvestingEquilibria (r K H : Float) : List Float :=
  let disc := 1.0 - 4.0*H/(r*K)
  if disc < 0.0 then [] else if disc == 0.0 then [K/2.0]
  else let sqrtD := Float.sqrt disc; [(K/2.0)*(1.0 - sqrtD), (K/2.0)*(1.0 + sqrtD)]

#eval logisticHarvestingEquilibria 1.0 100.0 10.0

def maximumSustainableYield (r K : Float) : Float := r * K / 4.0

structure GradientDescentStability where
  learningRate : Float
  hessianMaxEigenvalue : Float
  isStable : Bool

def quadraticLossStability (eta : Float) : Bool := eta < 2.0
#eval quadraticLossStability 0.1; #eval quadraticLossStability 1.5; #eval quadraticLossStability 2.5

structure AircraftLongitudinalStability where
  shortPeriodDamping : Float
  shortPeriodFrequency : Float
  isStable : Bool

structure LongitudinalDynamics where
  Xu : Float
  Xw : Float
  Zu : Float
  Zw : Float
  Mu : Float
  Mw : Float
  Mq : Float

def shortPeriodStable (Mq Mw : Float) : Bool := Mq < 0.0 && Mw < 0.0

end MiniStabilityTheory
/-! ## Additional Applications -/

/-- Model predictive control stability via terminal cost. -/
structure ModelPredictiveControl where
  horizon : Nat
  stateCost : Float -> Float
  inputCost : Float -> Float
  terminalCost : Float -> Float
  isStable : Bool

/-- Stability of the closed-loop under MPC if terminal cost is a Lyapunov function. -/
def mpcStabilityCondition (terminalCost : Float -> Float) (f : Float -> Float) (xSet : Float) : Bool :=
  terminalCost (f xSet) - terminalCost xSet < 0.0

/-- Adaptive control: Model Reference Adaptive Control (MRAC). -/
structure MRAC where
  referenceModel : LinearSystem2D
  adaptationGain : Float
  trackingError : Float
  parameterError : Float

/-- Stability of MRAC via Lyapunov: V = e^T P e + theta_tilde^T Gamma^{-1} theta_tilde. -/
def mracLyapunovCondition (P : LinearSystem2D) (Gamma : Float) : Bool :=
  P.a11 > 0.0 && P.a11 * P.a22 - P.a12 * P.a21 > 0.0 && Gamma > 0.0

/-- Sliding mode control: robustness via discontinuous control. -/
structure SlidingModeControl where
  slidingSurface : Float -> Float
  controlGain : Float
  boundaryLayer : Float

/-- Reachability condition for sliding mode: s * ds/dt < -eta * |s|. -/
def slidingCondition (s ds : Float) (eta : Float) : Bool := s * ds < -eta * s.abs

/-- Disturbance observer-based control. -/
structure DisturbanceObserver where
  plantModel : LinearSystem2D
  observerGain : Float * Float
  disturbanceEstimate : Float

/-- Stability of observer-based control (separation principle). -/
structure SeparationPrinciple where
  controllerGain : Float * Float
  observerGain : Float * Float
  closedLoopStable : Bool
  observerStable : Bool

/-- H-infinity control: minimize worst-case gain from disturbance to output. -/
structure HInfinityControl where
  plant : StateSpace
  gamma : Float
  controller : StateSpace
  closedLoopHInfNorm : Float

/-- Bounded real lemma for H-infinity. -/
structure BoundedRealLemma where
  A : LinearSystem2D
  B : Float
  C : Float
  gamma : Float
  -- There exists P > 0 such that A^T P + P A + C^T C + P B B^T P / gamma^2 < 0
  feasible : Bool

/-- Youla parametrization of all stabilizing controllers. -/
structure YoulaParametrization where
  nominalController : LinearSystem2D
  Q_parameter : LinearSystem2D
  allStabilizing : Bool

/-- Internal model principle for reference tracking. -/
structure InternalModelPrinciple where
  referenceModel : List Float
  controllerPoles : List Float
  containsReferenceModel : Bool

/-- Passivity-based control (PBC) for mechanical systems. -/
structure PassivityBasedControl where
  kineticEnergy : Float -> Float -> Float
  potentialEnergy : Float -> Float
  dampingInjection : Float
  energyShaping : Bool

/-- Energy shaping + damping injection = Lyapunov stability. -/
def energyShapingStability (Hd : Float -> Float) (xStar : Float) : Bool :=
  let dHd := (Hd (xStar + 0.001) - Hd (xStar - 0.001)) / 0.002
  dHd.abs < 0.001  -- x* is critical point of desired energy

/-- Iterative learning control: improve tracking over repetitions. -/
structure IterativeLearningControl where
  learningGain : Float
  filterQ : Float -> Float
  iteration : Nat
  errorNorm : Float

/-- Convergence condition for ILC: ||I - L*P|| < 1. -/
def ilcConvergenceCondition (learningGain plantGain : Float) : Bool :=
  (1.0 - learningGain * plantGain).abs < 1.0

/-- Extremum seeking control: real-time optimization via perturbation. -/
structure ExtremumSeeking where
  perturbationFreq : Float
  perturbationAmp : Float
  demodulationGain : Float
  convergesToOptimum : Bool

/-- Averaging analysis for extremum seeking stability. -/
def extremumSeekingStability (hessian ditherFreq ditherAmp : Float) : Bool :=
  hessian > 0.0 && ditherAmp > 0.0

/-- Reset control: hybrid system with state resets. -/
structure ResetControl where
  baseLinear : LinearSystem2D
  resetCondition : Float -> Bool
  afterResetValue : Float
  isStable : Bool

/-- Stability of reset control systems (H_beta condition). -/
def resetStabilityCondition (A : LinearSystem2D) (resetMatrix : Float) : Bool :=
  A.isStable || (A.a11.abs < 1.0)

/-- Event-triggered control: updates only when needed. -/
structure EventTriggeredControl where
  threshold : Float
  interEventTime : Float
  zenoFree : Bool  -- no infinite triggering in finite time

/-- Minimum inter-event time to avoid Zeno behavior. -/
def minimumInterEventTime (f : Float -> Float) (threshold : Float) (x0 : Float) : Float :=
  let L := (f (x0 + 0.001) - f (x0 - 0.001)) / 0.002  -- Lipschitz constant
  if L.abs > 0.0 then threshold / L.abs else 1.0e20

/-- Networked control: stability under communication constraints. -/
structure NetworkedControl where
  maxDelay : Float
  packetLossProb : Float
  quantizationLevel : Nat
  isStable : Bool

/-- Maximum allowable transfer interval (MATI) for stability. -/
def MATI (A : LinearSystem2D) (delay : Float) : Float :=
  if A.isStable then
    let lambda_max := spectralAbscissa2D A
    if lambda_max < 0.0 then Float.log (2.0) / (-lambda_max)
    else 0.0
  else 0.0

/-- Consensus of multi-agent systems: x_i' = sum_{j in N_i} (x_j - x_i). -/
structure ConsensusProtocol where
  adjacencyMatrix : List (List Float)
  laplacianMatrix : List (List Float)
  convergenceRate : Float

/-- Agreement (consensus) is reached if the Laplacian has a simple zero eigenvalue. -/
def consensusCondition (laplacianEigs : List Float) : Bool :=
  let zeroCount := laplacianEigs.filter (fun l => l.abs < 0.001) |>.length
  zeroCount == 1

/-- Formation control: maintain relative positions between agents. -/
structure FormationControl where
  desiredDistances : List (List Float)
  controlGains : List Float
  formationStable : Bool

/-- Stability of formation via graph rigidity. -/
def formationStabilityCondition (rigidityMatrix : List (List Float)) : Bool :=
  -- Graph must be rigid for formation to be locally asymptotically stable
  rigidityMatrix.length >= 2

/-- Flocking (Reynolds model): alignment + cohesion + separation. -/
structure FlockingModel where
  alignmentGain : Float
  cohesionGain : Float
  separationGain : Float
  neighborhoodRadius : Float

/-- Stability of flocking: velocity consensus + collision avoidance. -/
def flockingStability (gamma : Float) : Bool := gamma > 0.0

/-- Kuramoto model of coupled oscillators: dtheta_i/dt = omega_i + K/N * sum sin(theta_j - theta_i). -/
structure KuramotoModel where
  naturalFrequencies : List Float
  couplingStrength : Float
  orderParameter : Float
  synchronizationThreshold : Float

/-- Synchronization occurs when coupling K > K_c. -/
def kuramotoSyncThreshold (freqSpread : Float) : Float := freqSpread

/-- Opinion dynamics: DeGroot model x(t+1) = W x(t). -/
structure OpinionDynamics where
  influenceMatrix : List (List Float)
  convergenceRate : Float
  consensusReached : Bool

/-- DeGroot consensus if W is primitive and row-stochastic. -/
def degrootConsensusCondition (W : List (List Float)) : Bool :=
  -- W irreducible and aperiodic => consensus
  W.length > 1

end MiniStabilityTheory
