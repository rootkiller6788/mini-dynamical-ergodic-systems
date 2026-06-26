/-
# Stability Theory: Advanced Topics
ISS, contraction theory, infinite-dimensional, stochastic, hybrid systems.
## Knowledge Levels: L8, L9
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
import MiniStabilityTheory.Theorems.Main
namespace MiniStabilityTheory

structure ISS where
  beta : Float -> Float -> Float
  gamma : Float -> Float

structure ISSLyapunov where
  V : Float -> Float
  alpha1 : Float -> Float; alpha2 : Float -> Float; alpha3 : Float -> Float
  sigma : Float -> Float

structure ISSSmallGain where
  sys1_gain : Float
  sys2_gain : Float

structure ContractionMetric where
  contractionRate : Float

def isContracting (f : Float -> Float) (derivF : Float -> Float) (domain : List Float) (lambda : Float) : Bool :=
  domain.all (fun x => derivF x <= -lambda)

structure PDEStability where
  equation : String
  functionSpace : String
  stabilityType : StabilityType

structure HeatEquationLyapunov where
  domainLength : Float
  decayRate : Float

structure StochasticStability where
  drift : Float -> Float
  diffusion : Float -> Float
  noiseIntensity : Float
  stabilityInProbability : Bool

structure KhasminskiiTheorem where
  V : Float -> Float
  LV : Float -> Float

structure HybridSystem where
  flowMap : Float -> Float -> Float
  jumpMap : Float -> Float
  guardCondition : Float -> Bool
  lyapunovFunctions : List (Float -> Float)
  isStable : Bool

structure CommonLyapunovFunction where
  subsystems : List (Float -> Float)
  V : Float -> Float
  isCommonLyapunov : Bool

structure FractionalOrderSystem where
  alpha : Float
  f : Float -> Float
  stabilityCondition : String

def fractionalStabilityRegion (alpha : Float) : String :=
  if alpha < 1.0 then "wider than integer-order"
  else if alpha == 1.0 then "same as integer-order"
  else "narrower than integer-order"

end MiniStabilityTheory
/-! ## Further Advanced Topics -/

/-- Incremental stability: all trajectories converge to each other. -/
structure IncrementalStability where
  f : Float -> Float
  contractionMetric : Float -> Float -> Float
  contractionRate : Float

/-- Convergent systems: all trajectories forget initial conditions. -/
structure ConvergentSystem where
  f : Float -> Float -> Float
  -- non-autonomous f(t, x)
  isConvergent : Bool

/-- Monotone systems: preserve a partial order. -/
structure MonotoneSystem where
  f : Float -> Float
  isMonotone : Bool

/-- Kamke-Muller condition for monotonicity. -/
def kamkeMullerCondition (J : Float -> Float -> LinearSystem2D) (domain : List (Float * Float)) : Bool :=
  domain.all (fun (x, y) => let Jxy := J x y; Jxy.a12 >= 0.0 && Jxy.a21 >= 0.0)

/-- Dichotomy spectrum for non-autonomous linear systems. -/
structure DichotomySpectrum where
  exponents : List Float
  sackerSellSpectrum : Bool

/-- Exponential dichotomy: hyperbolic splitting of non-autonomous systems. -/
structure ExponentialDichotomy where
  A : Float -> LinearSystem2D
  projection : Float -> LinearSystem2D
  stableRate : Float
  unstableRate : Float

/-- Lyapunov-Perron method: integral equation for invariant manifolds. -/
structure LyapunovPerron where
  f : Float -> Float
  linearization : Float
  stableManifold : Float -> Float
  unstableManifold : Float -> Float

/-- Normal hyperbolicity: persistence of invariant manifolds. -/
structure NormalHyperbolicity where
  manifold : Float -> Float
  contraction : Float
  expansion : Float
  spectralGap : Bool

/-- Fenichel's theorem: normally hyperbolic invariant manifolds persist. -/
structure FenichelTheorem where
  slowManifold : Float -> Float
  fastDynamics : Float -> Float -> Float
  perturbation : Float
  persists : Bool

/-- Geometric singular perturbation theory. -/
structure GSPT where
  slowSystem : Float -> Float -> Float
  fastSystem : Float -> Float -> Float
  epsilon : Float
  criticalManifold : Float -> Float

/-- Canard explosion: trajectories following repelling slow manifold. -/
structure CanardExplosion where
  parameter : Float
  canardExists : Bool
  explosionPoint : Float

/-- Blow-up method for degenerate equilibria. -/
structure BlowUpMethod where
  vectorField : Float -> Float -> Float
  blowUpCoordinates : String
  desingularized : Bool

/-- Desingularization of nilpotent singularities. -/
def nilpotentSingularity (a b : Float) : LinearSystem2D :=
  { a11 := 0.0, a12 := 1.0, a21 := a, a22 := b }

/-- Bogdanov-Takens bifurcation normal form. -/
structure BogdanovTakens where
  beta1 : Float
  beta2 : Float  -- unfolding parameters
  normalForm : Float -> Float -> Float * Float

/-- Zero-Hopf bifurcation. -/
structure ZeroHopfBifurcation where
  mu : Float
  omega : Float
  normalFormCoefficients : List Float

/-- Stability of traveling waves in PDEs. -/
structure TravelingWaveStability where
  waveSpeed : Float
  profile : Float -> Float
  essentialSpectrum : Float
  pointSpectrum : List Float

/-- Evans function for spectral stability of traveling waves. -/
def evansFunction (waveSpeed : Float) (lambda : Float) : Float :=
  -- The Evans function E(lambda) vanishes at eigenvalues
  -- Simplified: return 1.0
  1.0

/-- Absolute vs convective instability in spatially extended systems. -/
inductive InstabilityType : Type where
  | absolute | convective | transient
  deriving BEq, Repr

/-- Briggs-Bers criterion for absolute instability. -/
structure BriggsBersCriterion where
  dispersionRelation : Float -> Float -> Float  -- D(k, omega) = 0
  saddlePoint : Float * Float
  isAbsolutelyUnstable : Bool

/-- Pseudospectra of non-normal linear operators. -/
structure Pseudospectra where
  operator : List (List Float)
  epsilon : Float
  pseudospectralAbscissa : Float

/-- Transient growth in non-normal systems. -/
def transientGrowth (A : LinearSystem2D) (t : Float) : Float :=
  -- max_{x0 != 0} ||exp(A*t)*x0|| / ||x0||
  -- Simplified: use matrix exponential approximation
  let expAt := { a11 := Float.exp (A.a11 * t), a12 := 0.0
               , a21 := 0.0, a22 := Float.exp (A.a22 * t) }
  max expAt.a11.abs expAt.a22.abs

/-- Numerical range (field of values) for stability analysis. -/
def numericalRange (A : Float -> Float) (x : Float) : Float :=
  -- F(A) = {x^* A x : ||x|| = 1}
  0.0

/-- Logarithmic norm (matrix measure). -/
def logarithmicNorm (A : LinearSystem2D) (normType : String) : Float :=
  match normType with
  | "one" => max (A.a11 + A.a21.abs) (A.a22 + A.a12.abs)
  | "inf" => max (A.a11 + A.a12.abs) (A.a22 + A.a21.abs)
  | _ => A.trace / 2.0

/-- Coppel-Howe theorem: roughness of exponential dichotomies. -/
structure CoppelHoweTheorem where
  A : Float -> LinearSystem2D
  perturbation : Float -> LinearSystem2D
  dichotomyPersists : Bool

/-- Stability of numerical discretizations of PDEs (CFL condition). -/
structure CFLStability where
  spatialStep : Float
  timeStep : Float
  waveSpeed : Float
  cflNumber : timeStep * waveSpeed / spatialStep
  isStable : cflNumber <= 1.0

/-- Von Neumann stability analysis. -/
def vonNeumannAmplification (scheme : String) (k dx dt : Float) (c : Float) : Float :=
  match scheme with
  | "FTFS" => 1.0 - c*dt*Float.sin(k*dx)/dx  -- forward-time forward-space
  | "FTCS" => 1.0  -- forward-time central-space
  | "CTCS" => Float.cos(c*k*dt)  -- Leapfrog
  | _ => 0.0

/-- Lax equivalence theorem: consistency + stability => convergence. -/
structure LaxEquivalenceTheorem where
  scheme : String
  isConsistent : Bool
  isStable : Bool
  isConvergent : Bool

/-- Stability of boundary conditions (GKS theory). -/
structure GKSStability where
  interiorScheme : String
  boundaryScheme : String
  isGKSStable : Bool

