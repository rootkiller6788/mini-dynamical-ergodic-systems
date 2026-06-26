/-
# Bifurcation Theory: Additional Examples

Extended example set covering edge cases and verification.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

#eval "=== Saddle-Node Fixed Point Counting ==="
def countSN (mu : Rat) : Nat :=
  let fps : List Rat := if mu > 0 then [sqrtRat mu, -sqrtRat mu] else if mu == 0 then [0] else []
  fps.length

#eval countSN ((1:Rat)/4)
#eval countSN ((1:Rat)/16)
#eval countSN 0
#eval countSN (-(1:Rat)/4)
#eval countSN (-1)

#eval "=== Pitchfork Fixed Point Counting ==="
def countPF (mu : Rat) (sc : Bool) : Nat :=
  let sign : Rat := if sc then 1 else -1
  let fps := if sign * mu > 0 then [sqrtRat (sign*mu), 0, -sqrtRat (sign*mu)] else [0]
  fps.length

#eval countPF ((1:Rat)/2) true
#eval countPF (-(1:Rat)/2) true
#eval countPF ((-1:Rat)/2) false
#eval countPF ((1:Rat)/2) false

#eval "=== Logistic Map Bifurcation Points ==="
def logBifPoints : List Rat :=
  [1, 3, 1+sqrtRat 6, ((3544:Rat)/1000), ((3566:Rat)/1000), ((3569:Rat)/1000)]

def logFpCount (r : Rat) : Nat :=
  let fps : List Rat := if r <= 1 then [0] else [0, 1-1/r]
  fps.length

#eval List.map logFpCount [(1:Rat)/2, (3:Rat)/2, (5:Rat)/2, (31:Rat)/10, (35:Rat)/10]

#eval "=== Stability Changes at Bifurcations ==="
def stabAt (r : Rat) (x : Rat) : Bool :=
  absRat (r*(1-2*x)) < 1

#eval stabAt ((5:Rat)/2) 0
#eval stabAt ((5:Rat)/2) (1-1/((5:Rat)/2))
#eval stabAt ((31:Rat)/10) (1-1/((31:Rat)/10))

#eval "=== Derivative at Fixed Points ==="
def derivSN (x : Rat) : Rat := 1 - 2*x
#eval derivSN (sqrtRat ((1:Rat)/4))
#eval derivSN (-sqrtRat ((1:Rat)/4))

def derivPF (mu x : Rat) : Rat := 1 + mu - 3*x*x
#eval derivPF ((1:Rat)/2) 0
#eval derivPF ((1:Rat)/2) (sqrtRat ((1:Rat)/2))

#eval "=== Normal Form Cross-Validation ==="
def checkNormalForm (f : Rat -> Rat -> Rat) (mu0 x0 : Rat) (expectedFp : Rat) : Bool :=
  f mu0 x0 == x0 /\ f mu0 expectedFp == expectedFp

#eval checkNormalForm (fun mu x => x + mu - x*x) 0 0 0
#eval checkNormalForm (fun mu x => x + mu*x - x*x*x) 0 0 0
#eval checkNormalForm (fun mu x => -(1+mu)*x + x*x*x) 0 0 0

#eval "=== Newton Method for Fixed Points ==="
def findFpNewton (f : Rat -> Rat -> Rat) (d : Rat -> Rat -> Rat) (mu x0 : Rat) (iters : Nat) : Rat :=
  Nat.rec x0 (fun _ x =>
    let g := f mu x - x
    let gp := d mu x - 1
    if gp == 0 then x else x - g/gp
  ) iters

#eval findFpNewton (fun mu x => x + mu - x*x) (fun _ x => 1-2*x) ((1:Rat)/4) 1 10
#eval findFpNewton (fun mu x => x + mu - x*x) (fun _ x => 1-2*x) ((1:Rat)/4) (-1) 10

#eval "=== Parameter Sweep for Bifurcation Detection ==="
def sweepParams (f : Rat -> Rat -> Rat) (params : List Rat) (x0 : Rat) (n : Nat) : List (Rat * Rat) :=
  List.map (fun mu =>
    let x := ParameterFamily.iterate {f := fun mu x => f mu x} mu n x0
    (mu, x)
  ) params

#eval sweepParams (fun mu x => x + mu - x*x) [-(1:Rat)/2, -(1:Rat)/4, 0, (1:Rat)/4, (1:Rat)/2] 0 100

#eval "=== Additional Verification Complete ==="
