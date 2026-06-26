/-
# Stability Theory: Counterexamples
Illustrating boundaries of stability theorems.
## Knowledge Levels: L6
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
import MiniStabilityTheory.Theorems.Main
namespace MiniStabilityTheory

def harmonicCenter : LinearSystem2D := { a11 := 0.0, a12 := 1.0, a21 := -1.0, a22 := 0.0 }
#eval harmonicCenter.classify; #eval harmonicCenter.isStable

def slowConvergence (x : Float) : Float := -x*x*x

def unstableDespiteLinearStable : LinearSystem2D := { a11 := -1.0, a12 := 0.0, a21 := 0.0, a22 := -2.0 }
#eval unstableDespiteLinearStable.classify; #eval unstableDespiteLinearStable.isStable

def structurallyUnstableCenter (eps : Float) : LinearSystem2D :=
  { a11 := eps, a12 := 1.0, a21 := -1.0, a22 := eps }
#eval structurallyUnstableCenter 0.0 |>.classify
#eval structurallyUnstableCenter 0.01 |>.classify
#eval structurallyUnstableCenter (-0.01) |>.classify

def nonSmooth (x : Float) : Float := -x.abs
def degenerateSystem (x y : Float) : Float * Float := (x*x - y, -y)

def doubleWell (x : Float) : Float := x - x*x*x
#eval doubleWell 0.0; #eval doubleWell 0.5; #eval doubleWell (-0.5); #eval doubleWell 2.0

def feigenbaumAccumulation : Float := 3.569945672

end MiniStabilityTheory