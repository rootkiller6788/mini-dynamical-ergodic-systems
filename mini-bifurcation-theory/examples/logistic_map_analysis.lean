/-
# Logistic Map: Complete Bifurcation Analysis
Comprehensive analysis of the logistic map f(x) = r*x*(1-x)
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

/-! ## Fixed Points -/

def logFp0 (r : Rat) : Rat := 0
def logFp1 (r : Rat) : Rat := 1 - 1/r

def logDeriv (r x : Rat) : Rat := r * (1 - 2*x)

def logFp0Stable (r : Rat) : Bool := absRat (logDeriv r 0) < 1
def logFp1Stable (r : Rat) : Bool := absRat (logDeriv r (1-1/r)) < 1

#eval "=== Logistic Map Fixed Point Stability ==="
#eval logFp0Stable ((1:Rat)/2)
#eval logFp0Stable 1
#eval logFp0Stable 2
#eval logFp1Stable ((3:Rat)/2)
#eval logFp1Stable ((5:Rat)/2)
#eval logFp1Stable 3
#eval logFp1Stable ((31:Rat)/10)

/-! ## Period-2 Orbit -/

def logP2 (r : Rat) : Rat * Rat :=
  let s := sqrtRat ((r-3)*(r+1))
  ((r+1+s)/(2*r), (r+1-s)/(2*r))

def logP2Exists (r : Rat) : Bool := r > 3

def logP2Stable (r : Rat) : Bool :=
  if r <= 3 then false else
  let (x1, x2) := logP2 r
  let m := (logDeriv r x1) * (logDeriv r x2)
  absRat m < 1

#eval "=== Period-2 Orbit Analysis ==="
#eval logP2Exists ((5:Rat)/2)
#eval logP2Exists ((32:Rat)/10)
#eval logP2 ((32:Rat)/10)
#eval logP2 ((34:Rat)/10)

/-! ## Bifurcation Diagram Features -/

def logBifPoints : List Rat := [1, 3, 1+sqrtRat 6, ((3544:Rat)/1000), ((3566:Rat)/1000), ((3569:Rat)/1000)]

def logRegime (r : Rat) : String :=
  if r <= 0 then "extinction"
  else if r <= 1 then "zero stable"
  else if r <= 3 then "positive fixed point stable"
  else if r <= 1+sqrtRat 6 then "period-2 stable"
  else if r <= ((3569:Rat)/1000) then "period-doubling cascade"
  else "chaos"

#eval "=== Logistic Map Regimes ==="
#eval logRegime ((1:Rat)/2)
#eval logRegime 2
#eval logRegime ((5:Rat)/2)
#eval logRegime ((32:Rat)/10)
#eval logRegime ((35:Rat)/10)
#eval logRegime 4

/-! ## Feigenbaum Constants -/

def feigDelta : Rat := 4669201609102990 / 1000000000000000
def feigAlpha : Rat := 2502907875095892 / 1000000000000000

def deltaApprox (r1 r2 r3 : Rat) : Rat := (r2 - r1) / (r3 - r2)

#eval "=== Feigenbaum Constant Approximation ==="
#eval deltaApprox 3 (1+sqrtRat 6) ((3544:Rat)/1000)

/-! ## Lyapunov Exponent -/

def logLyapunov (r x0 : Rat) (n : Nat) : Rat :=
  let rec sum (x : Rat) (k : Nat) (acc : Rat) : Rat :=
    match k with | 0 => acc | m+1 => sum (r*x*(1-x)) m (acc + absRat (r*(1-2*x)))
  sum x0 n 0 / (n : Rat)

#eval "=== Lyapunov Exponent Values ==="
#eval logLyapunov ((5:Rat)/2) ((1:Rat)/2) 100
#eval logLyapunov ((32:Rat)/10) ((1:Rat)/2) 100
#eval logLyapunov ((35:Rat)/10) ((1:Rat)/2) 100
#eval logLyapunov 4 ((1:Rat)/2) 100

/-! ## Orbit Analysis -/

def logOrbit (r x0 : Rat) (n : Nat) : List Rat :=
  List.map (fun i => orbit (fun x => r*x*(1-x)) x0 i) (List.range (n+1))

#eval "=== Orbit Examples ==="
#eval (logOrbit ((5:Rat)/2) ((3:Rat)/10) 5).length
#eval (logOrbit ((32:Rat)/10) ((3:Rat)/10) 10).length

/-! ## Bifurcation Test Function -/

def testLogisticMap : IO Unit := do
  let rVals : List Rat := [(1:Rat)/2, 1, (3:Rat)/2, 2, (5:Rat)/2, 3, (31:Rat)/10, (32:Rat)/10, (34:Rat)/10, (35:Rat)/10, (36:Rat)/10, 4]
  for r in rVals do
    let fp0 := logFp0 r
    let fp1 := if r > 1 then logFp1 r else fp0
    let s0 := logFp0Stable r
    let s1 := logFp1Stable r
    IO.println s!"r={r}: regime={logRegime r}, fp0_stable={s0}, fp1_stable={s1}"

#eval testLogisticMap

#eval "=== Logistic Map Analysis Complete ==="
