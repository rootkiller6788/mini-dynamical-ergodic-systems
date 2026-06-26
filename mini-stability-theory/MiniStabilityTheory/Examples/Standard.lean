/-
# Stability Theory: Standard Examples
Canonical examples with #eval verification.
## Knowledge Levels: L6
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
import MiniStabilityTheory.Theorems.LyapunovMain
import MiniStabilityTheory.Theorems.Main
namespace MiniStabilityTheory

def harmonicOscillator (omega x v : Float) : Float * Float := (v, -omega * omega * x)
#eval harmonicOscillator 2.0 1.0 0.0

def dampedHarmonic (omega zeta x v : Float) : Float * Float :=
  (v, -2.0*zeta*omega*v - omega*omega*x)
#eval dampedHarmonic 2.0 0.1 1.0 0.0

def dampedEnergyDerivative (omega zeta x v : Float) : Float := -2.0 * zeta * omega * v * v

def vanDerPolVectorField (mu x v : Float) : Float * Float :=
  (v, -mu * (x*x - 1.0) * v - x)
#eval vanDerPolVectorField 1.0 2.0 0.0

def pendulumVectorField (g L x v : Float) : Float * Float :=
  (v, -(g/L) * Float.sin x)
#eval pendulumEnergy 9.8 1.0 0.0 0.0

#eval logisticMap 2.5 0.6
#eval logisticZero_stability 0.5 (by norm_num) (by norm_num)
#eval logistic_nonzero_stability 2.0 (by norm_num) (by norm_num)

def lotkaVolterra (a b c d x y : Float) : Float * Float :=
  (a*x - b*x*y, -c*y + d*x*y)

/-- Lorenz 2D projection stability. -/
def lorenzOriginStability (sigma rho beta : Float) : StabilityType :=
  let Aproj : LinearSystem2D := { a11 := -sigma, a12 := sigma, a21 := rho, a22 := -1.0 }
  Aproj.classify
#eval lorenzOriginStability 10.0 0.5 (8.0/3.0)
#eval lorenzOriginStability 10.0 28.0 (8.0/3.0)

def cubicSystem (x : Float) : Float := -x*x*x
def cubicLyapunovV (x : Float) : Float := x*x / 2.0
def cubicLyapunovVDot (x : Float) : Float := -x*x*x*x

#eval cubicSystem 0.0; #eval cubicLyapunovV 1.0; #eval cubicLyapunovVDot 1.0

def exampleStableNode : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
def exampleStableFocus : LinearSystem2D := { a11 := -1.0, a12 := 2.0, a21 := -2.0, a22 := -1.0 }
def exampleSaddle : LinearSystem2D := { a11 := 1.0, a12 := 2.0, a21 := 3.0, a22 := -1.0 }
def exampleUnstableNode : LinearSystem2D := { a11 := 2.0, a12 := 0.0, a21 := 0.0, a22 := 3.0 }
def exampleCenter : LinearSystem2D := { a11 := 0.0, a12 := 2.0, a21 := -2.0, a22 := 0.0 }

#eval exampleStableNode.classify; #eval exampleStableFocus.classify
#eval exampleSaddle.classify; #eval exampleUnstableNode.classify; #eval exampleCenter.classify
#eval exampleStableNode.isStable; #eval exampleSaddle.isStable

/-- Routh-Hurwitz verification. -/
#eval isHurwitzQuadratic 3.0 2.0; #eval isHurwitzQuadratic (-1.0) (-2.0)

/-- Convergence rate: x' = -x^3 gives algebraic decay. -/
def convergenceRate (x0 t : Float) : Float := x0 / Float.sqrt (1.0 + 2.0*x0*x0*t)
#eval convergenceRate 1.0 0.0; #eval convergenceRate 1.0 1.0; #eval convergenceRate 1.0 100.0

end MiniStabilityTheory
/-! ## Additional Examples -/

/-- Example: Damped pendulum with nonlinearity. -/
def dampedPendulum (g L b x v : Float) : Float * Float :=
  (v, -(g/L) * Float.sin x - b * v)

/-- Damped pendulum equilibria: x = 0 (stable), x = pi (saddle). -/
#eval dampedPendulum 9.8 1.0 0.1 0.0 0.0
#eval dampedPendulum 9.8 1.0 0.1 pi 0.0

/-- Linearization at x=0: J = [[0,1],[-g/L,-b]]. -/
def dampedPendulumJacobian (g L b : Float) : LinearSystem2D :=
  { a11 := 0.0, a12 := 1.0, a21 := -(g/L), a22 := -b }
#eval (dampedPendulumJacobian 9.8 1.0 0.1).classify

/-- Example: Predator-prey with logistic prey. -/
def predatorPreyLogistic (r K a b d x y : Float) : Float * Float :=
  (r*x*(1.0 - x/K) - a*x*y, b*x*y - d*y)
#eval predatorPreyLogistic 1.0 100.0 0.1 0.05 0.5 50.0 10.0

/-- Example: SIR epidemic model. -/
def sirModel (beta gamma S I R : Float) : Float * Float * Float :=
  (-beta*S*I, beta*S*I - gamma*I, gamma*I)
#eval sirModel 0.3 0.1 0.99 0.01 0.0

/-- Example: Lorenz system full. -/
def lorenzSystem (sigma rho beta x y z : Float) : Float * Float * Float :=
  (sigma*(y-x), x*(rho-z) - y, x*y - beta*z)
#eval lorenzSystem 10.0 28.0 (8.0/3.0) 1.0 1.0 1.0

/-- Example: Rossler attractor. -/
def rosslerSystem (a b c x y z : Float) : Float * Float * Float :=
  (-y - z, x + a*y, b + z*(x-c))
#eval rosslerSystem 0.2 0.2 5.7 0.0 0.0 0.0

/-- Example: Chua circuit (piecewise linear). -/
def chuaCircuit (alpha beta m0 m1 x y z : Float) : Float * Float * Float :=
  let hx := if x.abs < 1.0 then m0*x else m1*x + (m0-m1)*1.0
  (alpha*(y - x - hx), x - y + z, -beta*y)
#eval chuaCircuit 15.6 28.0 (-1.143) (-0.714) 0.7 0.0 0.0

/-- Example: FitzHugh-Nagumo neuron model. -/
def fitzHughNagumo (a b c I v w : Float) : Float * Float :=
  (v - v*v*v/3.0 - w + I, c*(v + a - b*w))
#eval fitzHughNagumo 0.7 0.8 0.08 0.5 0.0 0.0

/-- Example: Brusselator (chemical oscillations). -/
def brusselator (a b x y : Float) : Float * Float :=
  (a - (b+1.0)*x + x*x*y, b*x - x*x*y)
#eval brusselator 1.0 3.0 1.0 2.0

/-- Example: Duffing oscillator phase portrait. -/
def duffingSystem (alpha beta delta gamma omega x v t : Float) : Float * Float :=
  (v, -delta*v - alpha*x - beta*x*x*x + gamma*Float.cos (omega*t))
#eval duffingSystem 1.0 (-1.0) 0.2 0.3 1.2 0.5 0.5 0.0

/-- Stability margin computation examples. -/
def stableSysA : LinearSystem2D := { a11 := -2.0, a12 := 3.0, a21 := -1.0, a22 := -4.0 }
#eval dampingRatio stableSysA
#eval naturalFrequency stableSysA
#eval settlingTime stableSysA
#eval percentOvershoot stableSysA

def marginallyStableSys : LinearSystem2D := { a11 := 0.0, a12 := 1.0, a21 := -4.0, a22 := 0.0 }
#eval dampingRatio marginallyStableSys
#eval naturalFrequency marginallyStableSys

/-- Eigenvalue sensitivity example. -/
def stiffSystem : LinearSystem2D := { a11 := -1.0, a12 := 0.0, a21 := 0.0, a22 := -100.0 }
#eval eigenvalueConditionNumber stiffSystem

def nearlyDefective : LinearSystem2D := { a11 := -1.0, a12 := 1.0, a21 := 0.0, a22 := -1.0 }
#eval eigenvalueConditionNumber nearlyDefective

/-- Robust stability example. -/
def nominalStable : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
#eval checkCircleCriterion nominalStable 0.0 10.0

/-- Bifurcation parameter sweep for logistic map. -/
def logisticBifurcationSweep (rMin rMax : Float) (steps : Nat) : List (Float * Float) :=
  let dr := (rMax - rMin) / (steps : Float)
  List.range steps |>.map (fun i =>
    let r := rMin + (i : Float) * dr
    let xstar := if r <= 1.0 then 0.0 else 1.0 - 1.0/r
    (r, logisticDeriv r xstar).abs)

#eval logisticBifurcationSweep 0.1 4.0 10

/-- Stability of numerical methods. -/
def explicitEulerStability (lambda dt : Float) : Float := 1.0 - lambda * dt
def implicitEulerStability (lambda dt : Float) : Float := 1.0 / (1.0 + lambda * dt)
def trapezoidalStability (lambda dt : Float) : Float := (1.0 - lambda * dt / 2.0) / (1.0 + lambda * dt / 2.0)
def rk4Stability (z : Float) : Float := 1.0 + z + z*z/2.0 + z*z*z/6.0 + z*z*z*z/24.0

#eval explicitEulerStability 10.0 0.1
#eval implicitEulerStability 10.0 0.1
#eval trapezoidalStability 10.0 0.1
#eval rk4Stability (-10.0 * 0.1)

