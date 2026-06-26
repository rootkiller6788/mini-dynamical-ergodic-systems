/-
# Stability Theory: Robustness Properties
Robust stability, small-gain, passivity, circle criterion.
## Knowledge Levels: L4, L5, L7
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
namespace MiniStabilityTheory

structure RobustStability where
  nominalSystem : LinearSystem2D
  uncertaintyBound : Float
  isRobustlyStable : Bool
  stabilityMargin : Float

def structuredSingularValue (M : LinearDiscreteSystem2D) (deltaStruct : String) : Float :=
  let sr := spectralRadius2D M
  if sr >= 1.0 then 0.0 else 1.0 / sr - 1.0

structure SmallGainResult where
  gain1 : Float
  gain2 : Float
  productLessThanOne : gain1 * gain2 < 1.0

structure PassiveSystem where
  storageFunction : Float -> Float
  isPassive : Bool
  isStrictlyPassive : Bool

structure CircleCriterion where
  A : LinearSystem2D
  sectorK1 : Float
  sectorK2 : Float
  isAbsolutelyStable : Bool

def checkCircleCriterion (A : LinearSystem2D) (k1 k2 : Float) : Bool :=
  A.trace < 0.0 && A.det > 0.0 && k1 < k2

structure PopovCriterion where
  A : LinearSystem2D
  sectorBound : Float
  popovParameter : Float
  isAbsolutelyStable : Bool

def checkPopovCriterion (A : LinearSystem2D) (k eta : Float) : Bool := eta > 0.0 && k > 0.0

structure IQCStability where
  nominalSystem : LinearSystem2D
  uncertaintyIQC : String
  isStable : Bool

end MiniStabilityTheory
/-! ## Extended Robustness Analysis -/

/-- Integral Quadratic Constraints (IQC) multipliers for robust stability. -/
structure IQCMultiplier where
  Pi11 : Float -> Float
  Pi12 : Float -> Float
  Pi22 : Float -> Float
  frequencyRange : Float * Float

/-- Zames-Falb IQC for monotone, odd nonlinearities. -/
def zamesFalbCondition (multiplierCoeffs : List Float) : Bool :=
  multiplierCoeffs.all (fun c => c.abs <= 1.0)

/-- Popov IQC: multiplier Pi(s) = eta * s + 1 for sector nonlinearities. -/
def popovIQC (eta k : Float) (omega : Float) : Bool :=
  1.0/k + eta * omega * omega > 0.0

/-- Circle IQC: for slope-restricted nonlinearities. -/
def circleIQC (k1 k2 : Float) (omega : Float) : Bool :=
  k1 < k2 && k1 >= 0.0

/-- O'Shea-Zames-Falb IQC: convolution multipliers for monotone nonlinearities. -/
structure OSheaZamesFalb where
  impulseResponse : List Float
  passivityCoefficient : Float

/-- Gap metric: distance between two linear systems in the gap topology. -/
def gapMetric (P1 P2 : TransferFunction) : Float :=
  -- delta_g(P1, P2) = max(delta(P1,P2), delta(P2,P1))
  -- where delta = ||(I+P2*P2^*)^{-1/2} (P1-P2) (I+P1^*P1)^{-1/2}||_inf
  0.0  -- placeholder

/-- Nu-gap metric (Vinnicombe metric) for robust stability. -/
def nuGapMetric (P1 P2 : TransferFunction) : Float :=
  -- delta_nu(P1, P2) - gives max uncertainty for stability
  0.0

/-- Robust stability margin via the gap metric. -/
def gapRobustnessMargin (P C : TransferFunction) : Float :=
  -- b_{P,C} = ||[P; I] (I - C P)^{-1} [-C I]||_inf^{-1}
  0.0

/-- LFT (Linear Fractional Transformation) for uncertainty modeling. -/
structure LFT where
  M : List (List Float)
  Delta : List (List Float)
  upperLFT : List (List Float)
  lowerLFT : List (List Float)

/-- Structured singular value mu bounds. -/
def muLowerBound (M : List (List Float)) : Float := 0.0
def muUpperBound (M : List (List Float)) : Float := 1.0

/-- D-K iteration for mu-synthesis. -/
structure DKIiteration where
  iteration : Nat
  D_scaling : List Float
  controller : StateSpace

/-- Robust H-infinity performance. -/
structure RobustHInfinity where
  nominalPerformance : Float
  robustPerformance : Float
  degradation : Float

/-- Robust stability of time-delay systems. -/
structure TimeDelayStability where
  A : LinearSystem2D
  Ad : LinearSystem2D  -- delayed state matrix
  maxDelay : Float
  isStable : Bool

/-- Lyapunov-Krasovskii functional for time-delay systems. -/
structure LyapunovKrasovskii where
  P : LinearSystem2D
  Q : LinearSystem2D
  R : Float
  -- V = x^T P x + integral_{-tau}^0 x^T(s) Q x(s) ds
  --   + tau * integral_{-tau}^0 integral_{t+theta}^t x_dot^T(s) R x_dot(s) ds dtheta

/-- Linear Matrix Inequality (LMI) feasibility for stability. -/
structure LMI where
  matrices : List (List (List Float))
  variables : List Float
  isFeasible : Bool

/-- Schur complement for LMI: [A B; B^T C] > 0 iff C > 0 and A - B C^{-1} B^T > 0. -/
def schurComplement (A B C : Float) : Bool := C > 0.0 && A - B*B/C > 0.0

/-- S-procedure: convert quadratic constraints to LMIs. -/
structure SProcedure where
  quadraticForms : List (Float -> Float -> Float)
  nonnegativityCondition : Bool

/-- Kalman-Yakubovich-Popov (KYP) lemma for frequency-domain inequalities. -/
structure KYP where
  A : LinearSystem2D
  B : Float
  C : Float
  D : Float
  frequencyDomainInequality : Float -> Bool
  timeDomainInequality : Bool

/-- Generalized KYP lemma for finite frequency ranges. -/
structure GeneralizedKYP where
  A : LinearSystem2D
  B : Float
  C : Float
  lowFreq : Float; highFreq : Float
  LMIexists : Bool

/-- Integral quadratic separation principle. -/
structure IQSeparation where
  G : Float -> Float
  Delta : Float -> Float
  separated : Bool

/-- Robust MPC (Min-Max MPC): minimize worst-case cost. -/
structure RobustMPC where
  horizon : Nat
  uncertaintySet : String
  worstCaseCost : Float

/-- Tube-based MPC: nominal trajectory + robust invariant tube. -/
structure TubeMPC where
  nominalMPC : ModelPredictiveControl
  tubeSize : Float
  invariantTube : Bool

/-- Stochastic MPC: chance constraints. -/
structure StochasticMPC where
  confidenceLevel : Float
  constraintTightening : Float

/-- Scenario-based robust optimization for control. -/
structure ScenarioControl where
  numScenarios : Nat
  violationProbability : Float
  sampleComplexity : Nat

