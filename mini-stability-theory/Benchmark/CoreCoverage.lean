/-
# Benchmark: Core Coverage Verification
Verifying L1-L6 knowledge coverage.
-/
import MiniStabilityTheory
open MiniStabilityTheory

def test_L1_definitions : IO Unit := do
  let f : Float -> Float := fun x => x
  have h_fixed : isFixedPoint f 0.0 := by unfold isFixedPoint; rfl
  let st : StabilityType := .stableNode
  have h_type : st.isStable := by unfold StabilityType.isStable; rfl
  IO.println "L1: Core definitions OK"

def test_L2_concepts : IO Unit := do
  let V : Float -> Float := fun x => x*x
  have h_V_pos : V 1.0 > 0.0 := by norm_num
  IO.println "L2: Core concepts OK"

def test_L3_structures : IO Unit := do
  let A : LinearSystem2D := { a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }
  let sysType := A.classify
  IO.println s!"L3: Structures OK, type: {sysType}"

def test_L4_theorems : IO Unit := do
  have h_rh : isHurwitzQuadratic 3.0 2.0 := by unfold isHurwitzQuadratic; constructor <;> norm_num
  IO.println "L4: Theorems OK"

def test_L5_proofs : IO Unit := do
  let A : LinearSystem2D := { a11 := -1.0, a12 := 0.0, a21 := 0.0, a22 := -2.0 }
  have h_stable : A.isStable := by
    unfold LinearSystem2D.isStable
    constructor <;> (unfold LinearSystem2D.trace LinearSystem2D.det; norm_num)
  IO.println "L5: Proof techniques OK"

def test_L6_examples : IO Unit := do
  let (v, a) := harmonicOscillator 2.0 1.0 0.0
  let x_next := logisticMap 2.5 0.6
  IO.println s!"L6: Examples OK, harmonic={v},{a}, logistic next={x_next}"

#eval test_L1_definitions; #eval test_L2_concepts; #eval test_L3_structures
#eval test_L4_theorems; #eval test_L5_proofs; #eval test_L6_examples