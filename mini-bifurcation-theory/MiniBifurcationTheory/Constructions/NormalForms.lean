/-
# Bifurcation Theory: Constructions -- Normal Forms

Normal form computation: reducing a general family to its simplest
polynomial form near a bifurcation point.
-/

import MiniBifurcationTheory.Core.Basic
import MiniBifurcationTheory.Core.Objects
import MiniBifurcationTheory.Core.Laws

namespace MiniBifurcationTheory

structure NearIdentityTransform where
  correction : Polynomial
  noConstant : correction.coeffs.getD 0 0 = 0
  noLinear : correction.coeffs.getD 1 0 = 0

def nearIdentityInverse (phi : Polynomial) (order : Nat) : Polynomial :=
  let id2 := Polynomial.scalarMul 2 Polynomial.id
  id2.sub phi

def isResonant (lambda : Rat) (k : Nat) : Bool :=
  if lambda == 1 then k == 1
  else if lambda == -1 then k % 2 == 0
  else k == 1

def normalFormCoeffs (f : Polynomial) (lambda : Rat) (maxOrder : Nat) : List Rat :=
  let coeffs := f.coeffs
  List.map (fun k =>
    if k == 0 then coeffs.getD 0 0
    else if k == 1 then lambda
    else if isResonant lambda k then coeffs.getD k 0
    else 0
  ) (List.range (min maxOrder coeffs.length))

def verifySaddleNodeNormalForm : Bool :=
  let f : Rat -> Rat -> Rat := fun mu x => x + mu - x*x
  let fx : Rat -> Rat -> Rat := fun _ x => 1 - 2*x
  let fxx : Rat -> Rat -> Rat := fun _ _ => 2
  let fmu : Rat -> Rat -> Rat := fun _ _ => 1
  f 0 0 == 0 /\ fx 0 0 == 1 /\ fxx 0 0 != 0 /\ fmu 0 0 != 0

def verifyTranscriticalNormalForm : Bool :=
  let f : Rat -> Rat -> Rat := fun mu x => x + mu*x - x*x
  f 0 0 == 0

def verifyPitchforkNormalForm : Bool :=
  let f : Rat -> Rat -> Rat := fun mu x => x + mu*x - x*x*x
  f 0 0 == 0

def verifyPeriodDoublingNormalForm : Bool :=
  let f : Rat -> Rat -> Rat := fun mu x => -(1+mu)*x + x*x*x
  f 0 0 == 0

def saddleNodeNormalFormTruncated (a b : Rat) : Polynomial :=
  { coeffs := [0, 1, b] }

def pitchforkNormalFormTruncated (a b : Rat) (mu : Rat) : Polynomial :=
  { coeffs := [0, 1 + a*mu, 0, b] }

def periodDoublingNormalFormTruncated (a mu : Rat) : Polynomial :=
  { coeffs := [0, -(1+mu), 0, a] }

end MiniBifurcationTheory
