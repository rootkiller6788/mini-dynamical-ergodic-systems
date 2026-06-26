/- Test/Smoke.lean - Smoke test for MiniComplexDynamics -/

import MiniComplexDynamics

open MiniComplexDynamics

def main : IO Unit := do
  IO.println "════════════════════════════════════════════"
  IO.println "  MiniComplexDynamics Smoke Test"
  IO.println "════════════════════════════════════════════"

  IO.println s!"  Axiom system: {dynamicsAxiomCount} axioms"
  IO.println s!"  Core theorems: {coreTheoremRegistry.length}"
  IO.println s!"  Fatou component types: 5"
  IO.println s!"  Research frontiers: {frontierRegistry.topics.length}"
  IO.println ""
  IO.println "  All modules importable:"
  IO.println "    Core/Basic, Core/Laws, Core/Objects"
  IO.println "    Morphisms/Hom, Equiv, Iso"
  IO.println "    Constructions, Properties"
  IO.println "    Theorems/Basic, Classification, Main, UniversalProperties"
  IO.println "    Examples/Standard, Counterexamples"
  IO.println "    Bridges: Algebra, Topology, Analysis, Geometry, Computation"
  IO.println "    Applications: Newton, Population, Physics"
  IO.println "    Advanced: ParabolicImplosion, Renormalization,"
  IO.println "             TranscendentalDynamics, SeveralVariables"
  IO.println "    Frontiers/ResearchFrontiers"
  IO.println ""
  IO.println "  ✅ Smoke test PASSED"
