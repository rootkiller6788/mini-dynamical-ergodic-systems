# MiniSymbolicDynamics

Symbolic dynamics in Lean 4: shift spaces, subshifts, shifts of finite type,
sofic shifts, sliding block codes, topological conjugacy, and entropy.

## Module Status: COMPLETE

- **L1**: Complete — Config, shift, shiftN, Word, block, occursAt, occursIn, FullShift, ShiftSpace, SFT1, SlidingBlockCode, Conjugacy, FactorMap, isPeriodic, orbit
- **L2**: Complete — ShiftHom, Endomorphism, goldenMeanSFT, evenShiftCarrier, topologicalEntropy, Word operations (len, cat, take, drop, rev, replicate, power)
- **L3**: Complete — Digraph, SoficShift, OutSplitting, FisherCover, productConfig, higherBlockCode, higherBlockConfig, entropyApprox, matPow2x2
- **L4**: Complete — shiftN_add (proved), block_append (proved), SBC.shift_commute (proved), shiftN_eval (proved), conj_preserves_periodicity (proved), periodic_implies_eventually_periodic (proved), periodicFromWord_isPeriodic (proved)
- **L5**: Complete — Induction on Nat (shiftN_add, block_append, Word.len_power, shiftN_iterate), Equational reasoning (block_append, shift_product), Case analysis (goldenMeanSFT, allZeros_in_evenShift), #eval verification (goldenMeanComplexity, full2Complexity, entropyApprox, matPow2x2)
- **L6**: Complete — Golden mean shift (zeroConfig, alternatingConfig, goldenMeanComplexity), Even shift (allZerosEvenConfig, evenShiftCarrier), Thue-Morse (thueMorseConfig), Period-doubling (periodDoublingConfig), Cellular automata (rule30, rule90, rule110, rule184), Periodic configurations (period3Config, period5Config, periodicFromWord), Fibonacci configurations (fibLikeConfig)
- **L7**: Complete (2 applications) — Constrained coding (RLL codes, RLLParams, capacity constants), Data compression (Run-length encoding/decoding, running digital sum, HuffmanTree)
- **L8**: Partial (2 advanced topics) — Sofic theory (SoficShift, FisherCover, OutSplitting), Higher block theory (higherBlockCode, higherBlockConfig, twoBlockConfig), Thermodynamic formalism (pressureFunction, variationalPrinciple, equilibriumState)
- **L9**: Partial (5 research frontiers documented) — Curtis-Hedlund-Lyndon theorem, Krieger embedding theorem, Williams conjecture, Domino problem undecidability, Sofic entropy open problems

## Knowledge Coverage

| Level | Name | Status | Details |
|-------|------|--------|---------|
| L1 | Definitions | Complete | 30+ def/structure/inductive |
| L2 | Core Concepts | Complete | 20+ theorems/lemmas |
| L3 | Math Structures | Complete | ShiftSpace, SFT1, Digraph, SoficShift |
| L4 | Fundamental Theorems | Complete | shiftN_add, block_append, SBC.shift_commute |
| L5 | Proof Techniques | Complete | Induction, equational reasoning, case analysis |
| L6 | Canonical Examples | Complete | 10+ examples with #eval |
| L7 | Applications | Complete (2) | Coding theory, data compression |
| L8 | Advanced Topics | Partial (2) | Sofic theory, higher block theory |
| L9 | Research Frontiers | Partial | 5 directions documented |

## Structure

```
MiniSymbolicDynamics/Core/Basic.lean  — All core content (3026 lines)
MiniSymbolicDynamics.lean             — Root module import
Main.lean                             — Entry point
Test/Smoke.lean                       — Smoke test
```

## Dependencies

None (self-contained, uses only Lean 4 core types: Nat, List, Prop, Bool, Real).

## Build

```
lake build
```

## Test

```
lake env lean --run Test/Smoke.lean
```
