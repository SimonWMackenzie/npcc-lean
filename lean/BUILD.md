# NP-Completeness of Deterministic Communication Complexity — Lean 4 formalization

Machine-verified formalization of *NP-Completeness of Deterministic Communication
Complexity via Relaxed Interlacing* (Gaspers-He-Mackenzie, arXiv:2508.05597 v4).

## Layout
- `Npcc/`        - this work: the reduction, the ladder engine, the stage lemmas,
                   the gap theorem, and the `main_np_hardness` wrapper.
- `Workspace/`   - the REUSED, sorry-free Mackenzie-Saffidine formalization
                   (interlace/bracket types, structural lemmas, Chung product,
                   log-rank, the appendix ladder steps). Compiles as part of this build.
- `claims/`      - the per-obligation statement ledger (paper label -> Lean claim).
- `obligations.json` - the full obligation ledger with dependencies + status.
- `AxiomReport.lean`, `wrapper_check.lean` - axiom-footprint checks.
- `docs/`        - the formalization plan, pipeline spec, reuse inventory, recaps,
                   and the manuscript-edit notes the formal proof surfaced.

## Build
Requires Lean 4.30.0 (see `lean-toolchain`) and `lake`. Mathlib is a dependency.

```
lake exe cache get      # fetch the prebuilt Mathlib cache (recommended)
lake build NPCC         # builds the whole development
```

`lake build` completes with **0 sorries**.

## Axiom footprint
`main_np_hardness` rests on Lean's `propext`, `Classical.choice`, `Quot.sound`
plus exactly two cited axioms:
- `aghp_balanced_family_exists` - existence of the balanced column family (AGHP).
- `vbp_np_hard`                  - NP-hardness of the Vector Bin Packing promise problem.

Verify with `#print axioms NPCC.main_np_hardness` (see `AxiomReport.lean`).
