/-
# Bifurcation Theory: Core Definitions
-/

namespace MiniBifurcationTheory

def absRat (x : Rat) : Rat := if x < 0 then -x else x

def intSqrt (n : Nat) : Nat :=
  let rec go (low high : Nat) : Nat :=
    if low >= high then low
    else
      let mid := (low + high + 1) / 2
      if mid * mid <= n then go mid high
      else go low (mid - 1)
  go 0 n

def sqrtRat (x : Rat) : Rat :=
  if x <= 0 then 0 else
  let n := x.num.natAbs
  let d := x.den
  let sn := intSqrt n
  let sd := intSqrt d
  if sd = 0 then 0
  else (sn : Rat) / (sd : Rat)

structure DiscreteDS (alpha : Type) where
  f : alpha -> alpha

def DiscreteDS.iterate (ds : DiscreteDS alpha) : Nat -> alpha -> alpha
  | 0, x => x
  | n+1, x => ds.f (iterate ds n x)

structure ParameterFamily (alpha beta : Type) where
  f : beta -> alpha -> alpha

def ParameterFamily.iterate (pf : ParameterFamily alpha beta) (mu : beta) : Nat -> alpha -> alpha
  | 0, x => x
  | n+1, x => pf.f mu (iterate pf mu n x)

def orbit (f : alpha -> alpha) (x : alpha) : Nat -> alpha
  | 0 => x
  | n+1 => f (orbit f x n)

def isFixedPoint (f : alpha -> alpha) (x : alpha) : Prop := f x = x

def isFixedPointBool (f : alpha -> alpha) (x : alpha) [BEq alpha] : Bool := f x == x

def isPeriodicPoint (f : alpha -> alpha) (x : alpha) (n : Nat) : Prop :=
  orbit f x n = x /\ forall k, 0 < k -> k < n -> orbit f x k = x -> False

def isEventuallyPeriodic (f : alpha -> alpha) (x : alpha) : Prop :=
  exists m n : Nat, 0 < n /\ orbit f x (m + n) = orbit f x m

structure Polynomial where
  coeffs : List Rat

def Polynomial.eval (p : Polynomial) (x : Rat) : Rat :=
  match p.coeffs.reverse with
  | [] => 0
  | c :: cs => cs.foldl (fun acc coeff => acc * x + coeff) c

def Polynomial.derivative (p : Polynomial) : Polynomial :=
  match p.coeffs with
  | [] => { coeffs := [0] }
  | _ :: cs =>
    let indexed := cs.zip (List.range cs.length)
    let derivCoeffs := List.map (fun (c, i) => c * ((i+1 : Nat) : Rat)) indexed
    { coeffs := derivCoeffs }

def Polynomial.derivAt (p : Polynomial) (x : Rat) : Rat :=
  p.derivative.eval x

def Polynomial.id : Polynomial := { coeffs := [0, 1] }

def Polynomial.add (p q : Polynomial) : Polynomial :=
  let n := max p.coeffs.length q.coeffs.length
  let coeffs := List.map (fun i =>
    let a := p.coeffs.getD i 0
    let b := q.coeffs.getD i 0
    a + b) (List.range n)
  { coeffs }

def Polynomial.const (c : Rat) : Polynomial := { coeffs := [c] }

def Polynomial.neg (p : Polynomial) : Polynomial :=
  { coeffs := p.coeffs.map (fun a => -a) }

def Polynomial.sub (p q : Polynomial) : Polynomial :=
  p.add q.neg

def Polynomial.scalarMul (c : Rat) (p : Polynomial) : Polynomial :=
  { coeffs := p.coeffs.map (fun a => c * a) }

def isLinearlyStable (f : Rat -> Rat) (x : Rat) (derivAt : Rat -> Rat) : Bool :=
  f x == x /\ absRat (derivAt x) < 1

def isLinearlyUnstable (f : Rat -> Rat) (x : Rat) (derivAt : Rat -> Rat) : Bool :=
  f x == x /\ absRat (derivAt x) > 1

def isHyperbolic (f : Rat -> Rat) (x : Rat) (derivAt : Rat -> Rat) : Bool :=
  f x == x /\ derivAt x != 1 /\ derivAt x != -1

inductive BifurcationType : Type where
  | saddleNode
  | transcritical
  | pitchfork (supercritical : Bool)
  | periodDoubling
  | hopf
  deriving BEq, Repr, Inhabited

structure BifurcationPoint (beta alpha : Type) where
  param : beta
  f : beta -> alpha -> alpha
  bifType : BifurcationType

def codimension (bt : BifurcationType) : Nat :=
  match bt with
  | .saddleNode => 1
  | .transcritical => 1
  | .pitchfork _ => 1
  | .periodDoubling => 1
  | .hopf => 2

structure NormalForm where
  bType : BifurcationType
  polynomial : Polynomial
  paramMin : Rat
  paramMax : Rat
  fixedPointFormula : Rat -> Rat

def normalFormSaddleNode : NormalForm :=
  { bType := .saddleNode
  , polynomial := { coeffs := [0, 1, -1] }
  , paramMin := (-1 : Rat)
  , paramMax := (1 : Rat)
  , fixedPointFormula := fun mu => sqrtRat mu
  }

def normalFormTranscritical : NormalForm :=
  { bType := .transcritical
  , polynomial := { coeffs := [0, 0, -1] }
  , paramMin := (-1 : Rat)
  , paramMax := (1 : Rat)
  , fixedPointFormula := fun mu => mu
  }

def normalFormPitchforkSuper : NormalForm :=
  { bType := .pitchfork true
  , polynomial := { coeffs := [0, 0, 0, -1] }
  , paramMin := (-1 : Rat)
  , paramMax := (1 : Rat)
  , fixedPointFormula := fun mu => if mu > 0 then sqrtRat mu else 0
  }

def normalFormPitchforkSub : NormalForm :=
  { bType := .pitchfork false
  , polynomial := { coeffs := [0, 0, 0, 1] }
  , paramMin := (-1 : Rat)
  , paramMax := (1 : Rat)
  , fixedPointFormula := fun mu => if mu < 0 then sqrtRat (-mu) else 0
  }

def normalFormPeriodDoubling : NormalForm :=
  { bType := .periodDoubling
  , polynomial := { coeffs := [0, -1, 0, 1] }
  , paramMin := (-1/2 : Rat)
  , paramMax := (1 : Rat)
  , fixedPointFormula := fun _ => 0
  }

def detectFixedPointBifurcation (pf : ParameterFamily Rat Rat)
    (domain : List Rat) (mu1 mu2 : Rat) : Bool :=
  let roots1 := domain.filter (fun x => pf.f mu1 x == x)
  let roots2 := domain.filter (fun x => pf.f mu2 x == x)
  roots1.length != roots2.length

structure BifurcationCondition (mu0 x0 : Rat) where
  fixedPt : Rat -> Rat -> Rat
  derivX : Rat -> Rat -> Rat
  pfFixed : fixedPt mu0 x0 = x0
  pfDeriv : derivX mu0 x0 = 1 \/ derivX mu0 x0 = -1

end MiniBifurcationTheory
