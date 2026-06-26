/-
# Bifurcation Theory: Laws

Fundamental laws and bifurcation conditions.
-/

import MiniBifurcationTheory.Core.Basic
import MiniBifurcationTheory.Core.Objects

namespace MiniBifurcationTheory

def canContinueFixedPoint (f : Rat -> Rat -> Rat) (derivX : Rat -> Rat -> Rat) (mu0 x0 : Rat) : Bool :=
  f mu0 x0 == x0 /\ derivX mu0 x0 != 1

def newtonFixedPointStep (f : Rat -> Rat -> Rat) (derivX : Rat -> Rat -> Rat) (mu x : Rat) : Rat :=
  let g := f mu x - x
  let gprime := derivX mu x - 1
  if gprime == 0 then x
  else x - g / gprime

def newtonFixedPoint (f : Rat -> Rat -> Rat) (derivX : Rat -> Rat -> Rat) (mu x0 : Rat) (iters : Nat) : Rat :=
  Nat.rec x0 (fun _ x => newtonFixedPointStep f derivX mu x) iters

def isBifurcationPoint1D (f : Rat -> Rat -> Rat) (derivX : Rat -> Rat -> Rat) (mu0 x0 : Rat) : Bool :=
  f mu0 x0 == x0 /\ (derivX mu0 x0 == 1 || derivX mu0 x0 == -1)

def classifyBifurcation1D (derivX : Rat -> Rat -> Rat) (mu0 x0 : Rat) : BifurcationType :=
  if derivX mu0 x0 == 1 then .saddleNode
  else if derivX mu0 x0 == -1 then .periodDoubling
  else .hopf

def isNondegenerateSaddleNode (f : Rat -> Rat -> Rat) (derivX derivXX derivMu : Rat -> Rat -> Rat) (mu0 x0 : Rat) : Bool :=
  f mu0 x0 == x0 /\ derivX mu0 x0 == 1 /\ derivXX mu0 x0 != 0 /\ derivMu mu0 x0 != 0

def isNondegeneratePitchfork (f : Rat -> Rat -> Rat) (derivX derivXXX derivMuX : Rat -> Rat -> Rat) (mu0 x0 : Rat) : Bool :=
  f mu0 x0 == x0 /\ derivX mu0 x0 == 1 /\ derivXXX mu0 x0 != 0 /\ derivMuX mu0 x0 != 0

def isNondegeneratePeriodDoubling (derivX derivXX derivXXX : Rat -> Rat -> Rat) (mu0 x0 : Rat) : Bool :=
  let fx := derivX mu0 x0
  let fxx := derivXX mu0 x0
  let fxxx := derivXXX mu0 x0
  fx == -1 /\ fxx == 0 /\ fxxx != 0

def isTransverseToIdentity (derivMu : Rat -> Rat -> Rat) (mu0 x0 : Rat) : Bool :=
  derivMu mu0 x0 != 0

def saddleNodeBranchingEquation (fMu fXX : Rat) (mu x : Rat) : Rat :=
  fMu * mu + (fXX / 2) * x * x

def pitchforkBranchingEquation (fMuX fXXX : Rat) (mu x : Rat) : Rat :=
  fMuX * mu * x + (fXXX / 6) * x * x * x

structure SaddleNodeHypotheses (mu0 x0 : Rat) where
  f : Rat -> Rat -> Rat
  fx : Rat -> Rat -> Rat
  fxx : Rat -> Rat -> Rat
  fmu : Rat -> Rat -> Rat
  fixedPoint : f mu0 x0 = x0
  eigenvalueOne : fx mu0 x0 = 1
  nondegenerate : fxx mu0 x0 != 0
  transverse : fmu mu0 x0 != 0

structure PitchforkHypotheses (mu0 x0 : Rat) where
  f : Rat -> Rat -> Rat
  fx : Rat -> Rat -> Rat
  fxxx : Rat -> Rat -> Rat
  fmux : Rat -> Rat -> Rat
  fixedPoint : f mu0 x0 = x0
  eigenvalueOne : fx mu0 x0 = 1
  symmetry : forall x, f mu0 (-x) = -(f mu0 x)
  nondegenerate : fxxx mu0 x0 != 0
  transverse : fmux mu0 x0 != 0

structure PeriodDoublingHypotheses (mu0 x0 : Rat) where
  f : Rat -> Rat -> Rat
  fx : Rat -> Rat -> Rat
  fxx : Rat -> Rat -> Rat
  fxxx : Rat -> Rat -> Rat
  fixedPoint : f mu0 x0 = x0
  eigenvalueNegOne : fx mu0 x0 = -1
  nondegenerate : fxxx mu0 x0 != 0
  noQuadratic : fxx mu0 x0 = 0

structure FoldCondition (mu0 x0 : Rat) where
  f : Rat -> Rat -> Rat
  fx : Rat -> Rat -> Rat
  fxx : Rat -> Rat -> Rat
  fmu : Rat -> Rat -> Rat
  fixedPoint : f mu0 x0 = x0
  eigenvalueOne : fx mu0 x0 = 1
  nondegenerate : fxx mu0 x0 != 0
  transverse : fmu mu0 x0 != 0

structure PitchforkCondition (mu0 : Rat) where
  f : Rat -> Rat -> Rat
  fx : Rat -> Rat -> Rat
  fxxx : Rat -> Rat -> Rat
  fmux : Rat -> Rat -> Rat
  fixedPointOrigin : forall mu, f mu 0 = 0
  eigenvalueOne : fx mu0 0 = 1
  nondegenerate : fxxx mu0 0 != 0
  transverse : fmux mu0 0 != 0
  isSymmetric : forall mu x, f mu (-x) = -(f mu x)

structure PeriodDoublingCondition (mu0 x0 : Rat) where
  f : Rat -> Rat -> Rat
  fx : Rat -> Rat -> Rat
  fxx : Rat -> Rat -> Rat
  fxxx : Rat -> Rat -> Rat
  fixedPoint : f mu0 x0 = x0
  eigenvalueNegOne : fx mu0 x0 = -1
  noQuadratic : fxx mu0 x0 = 0
  cubicNonzero : fxxx mu0 x0 != 0

def periodicOrbitMultiplier (f : Rat -> Rat) (derivAt : Rat -> Rat) (x : Rat) (n : Nat) : Rat :=
  let rec mult (y : Rat) (k : Nat) : Rat :=
    match k with
    | 0 => 1
    | m+1 => derivAt (orbit f y m) * mult y m
  mult x n

def feigenbaumScaling (delta alpha : Rat) (bifPoints : List Rat) (forkWidths : List Rat) : Bool :=
  match bifPoints, forkWidths with
  | [r1, r2, r3], [d1, d2] =>
    let deltaEst := (r2 - r1) / (r3 - r2)
    let alphaEst := d1 / d2
    absRat (deltaEst - delta) < (1 : Rat)/100 /\ absRat (alphaEst - alpha) < (1 : Rat)/100
  | _, _ => false

def rgEquation (g : Rat -> Rat) (alpha : Rat) (x : Rat) : Bool :=
  absRat (g x + alpha * g (g (-x / alpha))) < (1 : Rat)/10000

def isStructurallyStable1D (f : Rat -> Rat) (derivAt : Rat -> Rat) (periods : List Nat) (grid : List Rat) : Bool :=
  List.all periods (fun p =>
    List.all grid (fun x =>
      if orbit f x p == x then
        let m := periodicOrbitMultiplier f derivAt x p
        absRat m != 1
      else true
    )
  )

def birkhoffAverage (f : Rat -> Rat) (obs : Rat -> Rat) (x0 : Rat) (n : Nat) : Rat :=
  let sum := List.foldl (fun (acc, y) _ => (acc + obs y, f y)) (0, x0) (List.range n) |>.1
  sum / (n : Rat)

def isErgodicApprox (f : Rat -> Rat) (obs : Rat -> Rat) (x0 : Rat) (n : Nat) (spaceAvg : Rat) (tolerance : Rat) : Bool :=
  let timeAvg := birkhoffAverage f obs x0 n
  absRat (timeAvg - spaceAvg) < tolerance

end MiniBifurcationTheory
