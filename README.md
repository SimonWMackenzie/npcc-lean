# NP-Completeness of Deterministic Communication Complexity — machine-verified in Lean 4

A complete, machine-checked **Lean 4** formalization of *NP-Completeness of Deterministic
Communication Complexity via Relaxed Interlacing* (Gaspers, He, Mackenzie; arXiv:2508.05597 v4),
with an interactive **paper &harr; Lean explorer**.

## Live explorer
### https://imlard.github.io/npcc-lean/

Read the whole paper with every formalized statement highlighted in place; click any statement
for its plain-English summary and the exact kernel-checked Lean theorem; and navigate the full
dependency graph — bidirectionally (paper &harr; Lean &harr; graph). Inspired by
[formalarXiv](https://beyondthelibrary.github.io/formal_arxiv/).

## What's in here
- `index.html`, `pages/`, `paper.pdf` — the explorer site (served by GitHub Pages).
- `lean/` — the complete Lean 4 project, browsable source.
- `npcc-lean-formalization.zip` — the same project as a one-click download.

## The result
`lean/` builds with **0 sorries**. `NPCC.main_np_hardness` rests on Lean's `propext`,
`Classical.choice`, `Quot.sound` plus exactly two cited axioms:
- `aghp_balanced_family_exists` — existence of the balanced column family (AGHP).
- `vbp_np_hard` — NP-hardness of the Vector Bin Packing promise problem.

62 of the paper's 65 numbered statements are formalized: 129 proved in `lean/Npcc/` (this work)
and 8 reused from the sorry-free Mackenzie–Saffidine `lean/Workspace/` layer. The remaining 3 are
two-copy exposition variants the proof deliberately routes around.

## Build
Requires Lean 4.30.0 (`lean/lean-toolchain`) and `lake`:

```sh
cd lean
lake exe cache get      # prebuilt Mathlib cache
lake build NPCC         # 0 sorries
```

## Paper
arXiv:2508.05597 — https://arxiv.org/abs/2508.05597
