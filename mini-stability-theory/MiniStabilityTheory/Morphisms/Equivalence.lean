/-
# Stability Theory: Stability Equivalences
Equivalence relations on dynamical systems induced by stability.
## Knowledge Levels: L3, L5
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
import MiniStabilityTheory.Morphisms.Hom
import MiniStabilityTheory.Morphisms.Iso
namespace MiniStabilityTheory

def isStabilityEquivalent (s1 s2 : StabilityType) : Bool := s1 == s2

theorem stability_equiv_reflexive (s : StabilityType) : isStabilityEquivalent s s := by
  unfold isStabilityEquivalent; rfl

theorem stability_equiv_symmetric (s1 s2 : StabilityType)
    (h : isStabilityEquivalent s1 s2) : isStabilityEquivalent s2 s1 := by
  unfold isStabilityEquivalent at h; unfold isStabilityEquivalent; rw [h]

theorem stability_equiv_transitive (s1 s2 s3 : StabilityType)
    (h12 : isStabilityEquivalent s1 s2) (h23 : isStabilityEquivalent s2 s3)
    : isStabilityEquivalent s1 s3 := by
  unfold isStabilityEquivalent at h12 h23; unfold isStabilityEquivalent; rw [h12, h23]

structure ConjugacyClass where
  representative : LinearSystem2D
  members : List LinearSystem2D
  stabilityType : StabilityType

def areTopologicallyConjugate (A B : LinearSystem2D) : Bool := A.classify == B.classify

structure PhaseEquivalence1D where
  f : Float -> Float
  g : Float -> Float
  equilibria_f : List Float
  equilibria_g : List Float

def buildPhaseEquivalence (f g : Float -> Float) (domain : List Float) : PhaseEquivalence1D :=
  let eqf := domain.filter (fun x => f x == x)
  let eqg := domain.filter (fun x => g x == x)
  { f, g, equilibria_f := eqf, equilibria_g := eqg }

structure StabilityPartition where
  paramSpace : String
  regions : List (Float -> Float -> Bool)
  regionLabels : List StabilityType

def traceDetPartition (tr det : Float) : StabilityType := classifyByTraceDet tr det

def generateStabilityDiagram (trValues detValues : List Float) : List (Float * Float * StabilityType) :=
  trValues.bind (fun tr => detValues.map (fun det => (tr, det, traceDetPartition tr det)))

end MiniStabilityTheory