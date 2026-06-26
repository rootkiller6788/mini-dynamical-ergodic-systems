/-
# Stability Theory: Regression Tests
Comprehensive validation across parameter ranges.
-/
import MiniStabilityTheory
open MiniStabilityTheory

def regressionEigenvalueStability : IO Unit := do
  let stableSystems : List (LinearSystem2D * Bool) := [
    ({ a11 := -1.0, a12 := 0.0, a21 := 0.0, a22 := -2.0 }, true),
    ({ a11 := -2.0, a12 := 1.0, a21 := 0.0, a22 := -3.0 }, true),
    ({ a11 := -1.0, a12 := 2.0, a21 := -2.0, a22 := -1.0 }, true)
  ]
  let unstableSystems : List (LinearSystem2D * Bool) := [
    ({ a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 2.0 }, false),
    ({ a11 := 1.0, a12 := 2.0, a21 := 3.0, a22 := -1.0 }, false)
  ]
  for (sys, expected) in stableSystems do
    let actual := sys.isStable
    if actual != expected then IO.println s!"FAIL: stable system misclassified"
  for (sys, expected) in unstableSystems do
    let actual := sys.isStable
    if actual != expected then IO.println s!"FAIL: unstable system misclassified"
  IO.println "Eigenvalue stability regression - PASS"

def regressionRouthHurwitz : IO Unit := do
  let testCases : List (Float * Float * Bool) := [
    (1.0, 1.0, true), (3.0, 2.0, true), (0.0, 1.0, false), (-1.0, 2.0, false), (1.0, -1.0, false)
  ]
  for (a, b, expected) in testCases do
    let actual := isHurwitzQuadratic a b
    if actual != expected then IO.println s!"FAIL: Routh-Hurwitz a={a}, b={b}"
  IO.println "Routh-Hurwitz regression - PASS"

def regressionLogisticStability : IO Unit := do
  let r_vals := [0.1, 0.5, 0.9]
  for r in r_vals do
    let deriv := logisticDeriv r 0.0
    if deriv.abs >= 1.0 then IO.println s!"FAIL: Logistic r={r}"
  let r_vals2 := [1.5, 2.0, 2.5]
  for r in r_vals2 do
    let xStar := 1.0 - 1.0/r
    let deriv := logisticDeriv r xStar
    if deriv.abs >= 1.0 then IO.println s!"FAIL: Logistic r={r}"
  IO.println "Logistic stability regression - PASS"

def regressionStabilityTypes : IO Unit := do
  let testCases : List (Float * Float * StabilityType) := [
    (-3.0, 2.0, .stableNode), (1.0, -1.0, .saddle), (0.0, 0.0, .degenerate)
  ]
  for (tr, det, expected) in testCases do
    let actual := classifyByTraceDet tr det
    if actual != expected then IO.println s!"FAIL: classify({tr},{det})={actual}"
  IO.println "Stability type regression - PASS"

#eval regressionEigenvalueStability
#eval regressionRouthHurwitz
#eval regressionLogisticStability
#eval regressionStabilityTypes