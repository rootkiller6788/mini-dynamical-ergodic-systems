/-
# MiniComplexDynamics.Advanced.ParabolicImplosion

Advanced topic: Parabolic implosion and the discontinuity of
Julia sets at parabolic parameters. Lavaurs maps and Ecalle cylinders.
-/

import MiniComplexDynamics.Core.Basic
import MiniComplexDynamics.Theorems.Classification
import MiniObjectKernel.Core.Basic

open MiniObjectKernel
open MiniComplexDynamics

namespace MiniComplexDynamics

/-- Parabolic implosion: as a parameter approaches a parabolic
    parameter, the Julia set can explode discontinuously. -/
structure ParabolicImplosion where
  parabolicParameter : ComplexNumbers
  approximatingSequence : Nat -> ComplexNumbers
  limitJuliaSet : ComplexNumbers -> Bool
  implosionEffect : Prop

/-- The Lavaurs map: the limit of the dynamics after appropriate
    rescaling near a parabolic point. -/
structure LavaursMap where
  parabolicPoint : ComplexNumbers
  cylinder : ComplexNumbers -> Bool
  ecAlleeCylinder : Prop
  hornMap : ComplexNumbers -> ComplexNumbers

/-- Ecalle cylinders: the quotient of the attracting/repelling
    petals by the dynamics gives an elliptic curve. -/
structure EcalleCylinders where
  attractingCylinder : ComplexNumbers -> Bool
  repellingCylinder : ComplexNumbers -> Bool
  ecAlleeTransform : Prop
  fatouCoordinates : Prop

/-- The horn map: a holomorphic map between Ecalle cylinders
    encoding the transition between attracting and repelling dynamics. -/
structure HornMap where
  domain : ComplexNumbers -> Bool
  codomain : ComplexNumbers -> Bool
  map : ComplexNumbers -> ComplexNumbers
  isAnalytic : Prop
  determinesImplosion : Prop

/-- Parabolic renormalization: at a parabolic parameter,
    the dynamics rescaled converges to a Lavaurs map. -/
structure ParabolicRenormalization where
  original : ComplexNumbers -> ComplexNumbers
  limit : ComplexNumbers -> ComplexNumbers
  scalingSequence : Nat -> Float
  convergenceProperty : Prop

/-- The Douady-Ecalle-Voronin theory of parabolic implosion. -/
structure DouadyEcalleVoronin where
  parabolicGerms : List (ComplexNumbers -> ComplexNumbers)
  classification : Prop
  moduliSpace : Nat

/-- The space of parabolic germs modulo analytic conjugacy. -/
structure ParabolicGermModuli where
  dimension : Nat
  parameters : List ComplexNumbers

#eval "── ParabolicImplosion: Ecalle cylinders and Lavaurs maps ──"

end MiniComplexDynamics
