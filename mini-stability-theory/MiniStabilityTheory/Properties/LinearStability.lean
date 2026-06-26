/-
# Stability Theory: Linear Stability Analysis
Eigenvalue criteria, modal analysis, Floquet theory.
## Knowledge Levels: L2, L4, L5
-/
import MiniStabilityTheory.Core.Basic
import MiniStabilityTheory.Core.Objects
import MiniStabilityTheory.Core.Laws
namespace MiniStabilityTheory

theorem linearization_stability (A : LinearSystem2D) (h_stable : A.isStable) : A.classify.isStable := by
  unfold LinearSystem2D.isStable at h_stable
  unfold LinearSystem2D.classify StabilityType.isStable
  have hTr : A.trace < 0.0 := h_stable.1
  have hDet : A.det > 0.0 := h_stable.2
  split
  . exfalso; linarith
  . exfalso; linarith
  . exfalso; linarith
  . exfalso; linarith
  . rfl
  . rfl
  . exfalso; linarith

structure ModalDecomposition where
  A : LinearSystem2D
  stableEigenvalues : List Float; unstableEigenvalues : List Float
  centerEigenvalues : List Float

def decompose2D (A : LinearSystem2D) : ModalDecomposition :=
  let evs := A.eigenvalues
  { A, stableEigenvalues := evs.filter (fun l => l < 0.0)
  , unstableEigenvalues := evs.filter (fun l => l > 0.0)
  , centerEigenvalues := evs.filter (fun l => l == 0.0) }

structure FloquetAnalysis where
  period : Float
  monodromyMatrix : LinearSystem2D
  multipliers : List Float
  isStable : Bool

def computeMonodromy (A_periodic : Float -> LinearSystem2D) (T : Float) (steps : Nat) : LinearSystem2D :=
  let dt := T / (steps : Float)
  let rec integrate (t : Float) (Phi : LinearSystem2D) (k : Nat) : LinearSystem2D :=
    match k with
    | 0 => Phi
    | m+1 =>
      let A_t := A_periodic t
      let dPhi11 := A_t.a11 * Phi.a11 + A_t.a12 * Phi.a21
      let dPhi12 := A_t.a11 * Phi.a12 + A_t.a12 * Phi.a22
      let dPhi21 := A_t.a21 * Phi.a11 + A_t.a22 * Phi.a21
      let dPhi22 := A_t.a21 * Phi.a12 + A_t.a22 * Phi.a22
      integrate (t + dt)
        { a11 := Phi.a11 + dt * dPhi11, a12 := Phi.a12 + dt * dPhi12
        , a21 := Phi.a21 + dt * dPhi21, a22 := Phi.a22 + dt * dPhi22 } m
  integrate 0.0 { a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 1.0 } steps

def stabilityIndex (A : LinearSystem2D) : Int :=
  if A.trace < 0.0 then -1 else if A.trace > 0.0 then 1 else 0

def morseIndex2D (A : LinearSystem2D) : Nat :=
  A.eigenvalues.filter (fun l => l > 0.0) |>.length

def eigenvalueConditionNumber (A : LinearSystem2D) : Float :=
  let disc := A.discriminant
  if disc <= 0.0 then 1.0
  else let gap := Float.sqrt disc
       if gap < 0.001 then 1000.0 else (A.a12.abs + A.a21.abs) / gap

def isStabilitySensitive (A : LinearSystem2D) (threshold : Float) : Bool :=
  eigenvalueConditionNumber A > threshold

end MiniStabilityTheory
/-! ## Additional Linear Stability Analysis -/

/-- Compute the time constant for each mode. -/
def timeConstants (A : LinearSystem2D) : List Float :=
  A.eigenvalues.map (fun lambda => if lambda != 0.0 then -1.0 / lambda else 1.0e20)

/-- Dominant time constant (slowest mode). -/
def dominantTimeConstant (A : LinearSystem2D) : Float :=
  match timeConstants A |>.maximum? with | none => 1.0e20 | some tc => tc

/-- Participation factor: relative contribution of state to mode. -/
def participationFactor (A : LinearSystem2D) (modeIdx : Nat) (stateIdx : Nat) : Float :=
  let evs := A.eigenvalues
  if modeIdx < evs.length then 1.0 else 0.0

/-- Residue of transfer function at an eigenvalue. -/
def residue (A : LinearSystem2D) (c b : Float) (lambda : Float) : Float :=
  -- For SISO: residue_i = c * v_i * w_i^T * b
  -- where v_i, w_i are right/left eigenvectors
  c * b / (2.0 * lambda - A.trace)

/-- DC gain from state-space. -/
def dcGain (A : LinearSystem2D) (B : Float * Float) (C : Float * Float) (D : Float) : Float :=
  let detA := A.det
  if detA == 0.0 then 0.0
  else
    let invA11 := A.a22 / detA; let invA12 := -A.a12 / detA
    let invA21 := -A.a21 / detA; let invA22 := A.a11 / detA
    let b1 := B.1; let b2 := B.2; let c1 := C.1; let c2 := C.2
    c1*(invA11*b1 + invA12*b2) + c2*(invA21*b1 + invA22*b2) + D

/-- Bandwidth of the system (frequency where gain drops by 3dB). -/
def bandwidth (A : LinearSystem2D) : Float :=
  let wn := naturalFrequency A; let zeta := dampingRatio A
  if wn > 0.0 && zeta > 0.0 then
    wn * Float.sqrt (1.0 - 2.0*zeta*zeta + Float.sqrt (2.0 - 4.0*zeta*zeta + 4.0*zeta*zeta*zeta*zeta))
  else 0.0

/-- Peak gain (resonance peak). -/
def resonancePeak (A : LinearSystem2D) : Float :=
  let zeta := dampingRatio A
  if zeta > 0.0 && zeta < 0.707 then
    1.0 / (2.0 * zeta * Float.sqrt (1.0 - zeta*zeta))
  else 1.0

/-- Resonance frequency. -/
def resonanceFrequency (A : LinearSystem2D) : Float :=
  let wn := naturalFrequency A; let zeta := dampingRatio A
  if zeta < 0.707 then wn * Float.sqrt (1.0 - 2.0*zeta*zeta) else 0.0

/-- Minimum stability margin via Gershgorin. -/
def gershgorinMargin (A : LinearSystem2D) : Float :=
  let r1 := A.a12.abs; let r2 := A.a21.abs
  min (-A.a11 - r1) (-A.a22 - r2)

/-- Inverse of the condition number of the eigenvector matrix. -/
def eigenvectorCondition (A : LinearSystem2D) : Float :=
  let disc := A.discriminant
  if disc.abs < 0.001 then 0.01  -- nearly defective
  else
    let v1 := A.a12; let v2 := disc > 0.0 then 1.0 else 1.0  -- simplified
    1.0

/-- Modal assurance criterion (MAC) between two eigenvectors. -/
def modalAssuranceCriterion (v1 v2 : Float * Float) : Float :=
  let dot := v1.1 * v2.1 + v1.2 * v2.2
  let n1 := v1.1*v1.1 + v1.2*v1.2; let n2 := v2.1*v2.1 + v2.2*v2.2
  if n1 == 0.0 || n2 == 0.0 then 0.0 else (dot * dot) / (n1 * n2)

/-- Eigenvalue sensitivity to parameter variation. -/
def eigenvalueSensitivity (A : LinearSystem2D) (pertA : LinearSystem2D) : Float :=
  let evs_orig := A.eigenvalues
  let A_pert := { a11 := A.a11 + pertA.a11, a12 := A.a12 + pertA.a12
                , a21 := A.a21 + pertA.a21, a22 := A.a22 + pertA.a22 }
  let evs_pert := A_pert.eigenvalues
  match evs_orig, evs_pert with
  | [l1o, l2o], [l1p, l2p] => max (l1p - l1o).abs (l2p - l2o).abs
  | _, _ => 0.0

/-- Pseudospectrum analysis: epsilon-pseudospectrum boundary estimate. -/
def pseudospectrumBoundary (A : LinearSystem2D) (epsilon : Float) : Float :=
  -- For normal matrices: epsilon-ball around eigenvalues
  -- For non-normal: can be much larger
  let kappa := eigenvalueConditionNumber A
  kappa * epsilon

/-- Distance to instability. -/
def distanceToInstability (A : LinearSystem2D) : Float :=
  let tr := A.trace; let det := A.det
  if tr < 0.0 && det > 0.0 then min (-tr) det else 0.0

/-- Structured distance to instability (real perturbation). -/
def structuredDistanceToInstability (A : LinearSystem2D) : Float :=
  -- Minimize sigma_min(A - j*omega*I) over omega > 0
  let candidate1 := -A.trace / 2.0
  let candidate2 := Float.sqrt A.det
  min candidate1 candidate2

/-- H2 norm of the system (trace of controllability Gramian * C^T C). -/
def h2Norm (A : LinearSystem2D) (B C : Float * Float) : Float :=
  if A.isStable then
    let detA := A.det
    let b1 := B.1; let b2 := B.2; let c1 := C.1; let c2 := C.2
    Float.sqrt ((c1*b1 + c2*b2)^2 / (-2.0 * A.trace * detA))
  else 0.0

/-- H-infinity norm (simplified for SISO second-order). -/
def hInfNorm (A : LinearSystem2D) (B C : Float * Float) (D : Float) : Float :=
  let dc := dcGain A B C D
  let peak := resonancePeak A
  max (dc.abs) peak

/-- Robust stability margin via structured singular value (simplified). -/
def robustStabilityMargin (A : LinearSystem2D) (uncertaintyWeight : Float) : Float :=
  if A.isStable then
    let ms := sensitivityPeak A ({ a11 := 1.0, a12 := 0.0, a21 := 0.0, a22 := 1.0 })
    1.0 / (ms * uncertaintyWeight)
  else 0.0

