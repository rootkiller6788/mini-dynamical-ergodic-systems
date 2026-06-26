/-
# Stability Theory: Stability Isomorphisms
## Knowledge Levels: L3
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Morphisms.Hom
namespace MiniStabilityTheory

/-- Flow equivalence with time reparametrization. -/
structure FlowEquivalence (alpha : Type) where
  flow1 : Float -> alpha -> alpha
  flow2 : Float -> alpha -> alpha
  h : alpha -> alpha
  tau : Float -> Float
  orbitMapping : forall x t, h (flow1 t x) = flow2 (tau t) (h x)

/-- Diffeomorphic equivalence. -/
structure DiffeomorphicEquivalence where
  f : Float -> Float
  g : Float -> Float
  phi : Float -> Float

/-- Normal form representative. -/
structure NormalForm where
  systemType : String
  standardForm : LinearSystem2D

/-- Trace-determinant classification. -/
structure TraceDetClassification where
  trace : Float
  determinant : Float
  discriminant : Float
  stabilityType : StabilityType

/-- Check iso-stable family. -/
def isIsoStableFamily (systems : List LinearSystem2D) : Bool :=
  match systems with
  | [] => true
  | s :: ss => ss.all (fun t => t.classify == s.classify)

/-- Detect stability change. -/
def detectStabilityChange (tr1 det1 tr2 det2 : Float) : Bool :=
  -- classifyByTraceDet would be used here if available from Laws.lean
  -- For now, use direct trace-det analysis
  let stable1 := tr1 < 0.0 && det1 > 0.0
  let stable2 := tr2 < 0.0 && det2 > 0.0
  stable1 != stable2

end MiniStabilityTheory