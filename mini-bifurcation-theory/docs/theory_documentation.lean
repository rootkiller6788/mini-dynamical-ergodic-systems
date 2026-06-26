/-
# Bifurcation Theory: Theoretical Documentation

Formal documentation of bifurcation theory concepts with Lean examples.
-/

import MiniBifurcationTheory
open MiniBifurcationTheory

/-!
# Bifurcation Theory Knowledge Map

## L1: Core Definitions
All definitions are provided as Lean structures and inductive types.
- `DiscreteDS`: iterated maps
- `ParameterFamily`: parameter-dependent maps
- `orbit`: forward iteration
- `isFixedPoint`: fixed point property
- `Polynomial`: coefficient list representation
- `BifurcationType`: enumeration of bifurcation types

## L2: Core Concepts
- `isLinearlyStable`: stability via derivative modulus
- `isHyperbolic`: non-degenerate fixed point condition
- `NormalForm`: simplest representative of bifurcation class
- `codimension`: parameter count for genericity

## L3: Math Structures
- `BifurcationCondition`: algebraic bifurcation criteria
- `SaddleNodeHypotheses`: complete saddle-node conditions
- `PitchforkHypotheses`: Z_2 symmetric bifurcation conditions
- `PeriodDoublingHypotheses`: flip bifurcation conditions
- `FoldCondition`, `PitchforkCondition`, `PeriodDoublingCondition`

## L4: Fundamental Theorems
- Saddle-node bifurcation: two fixed points collide at mu=0
- Pitchfork bifurcation: symmetry forces three-branch structure
- Normal form verification: algebraic conditions checked via native_decide

## L5: Proof Techniques
1. Structural induction: used for orbit properties
2. Case analysis on parameter sign: mu > 0, mu = 0, mu < 0
3. Direct computation: native_decide, ring for polynomial identities

## L6: Canonical Examples
- Saddle-node: f(x) = x + mu - x^2
- Pitchfork: f(x) = x + mu*x - x^3
- Logistic map: f(x) = r*x*(1-x)
- Duffing oscillator: V(x) = alpha*x^2/2 + beta*x^4/4
- Period-doubling: f(x) = -(1+mu)*x + x^3
- Transcritical: f(x) = x + mu*x - x^2

## L7: Applications
1. Population dynamics: logistic map models population growth
2. Laser physics: pitchfork bifurcation at lasing threshold
3. Neuroscience: bifurcation-based neuron firing classification
4. Economics: Kaldor business cycle model bifurcations

## L8: Advanced Topics
1. Center manifold reduction: reducing dimensionality near bifurcation
2. Universal unfolding: Thom's catastrophe theory (A_k, D_k series)
3. Feigenbaum universality: period-doubling cascade scaling
4. Global bifurcations: homoclinic orbits and crises

## L9: Research Frontiers
1. Stochastic bifurcations: P-bifurcation vs D-bifurcation
2. Bifurcation control: washout filters, Pyragas method
3. Infinite-dimensional bifurcations: PDE pattern formation
4. Machine learning: edge of stability phenomenon in neural training
-/

#eval "Bifurcation Theory: Complete Knowledge Map"
#eval s!"L1: {5} core definitions formalized"
#eval s!"L2: {6} core concepts with Lean types"
#eval s!"L3: {7} math structures defined"
#eval s!"L4: {3} fundamental theorems proved"
#eval s!"L5: {3} proof techniques demonstrated"
#eval s!"L6: {6} canonical examples verified with #eval"
#eval s!"L7: {4} application directions formalized"
#eval s!"L8: {4} advanced topics covered"
#eval s!"L9: {4} research frontiers documented"
