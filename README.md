# NP-Completeness of Deterministic Communication Complexity — machine-verified in Lean 4

A complete, machine-checked **Lean 4** formalization of *NP-Completeness of Deterministic
Communication Complexity via Relaxed Interlacing* (Gaspers, He, Mackenzie; arXiv:2508.05597 v4),
with an interactive **paper &harr; Lean explorer**.

## Live explorers

**Term inspector (recommended) — for readers who don't know Lean:**
### https://imlard.github.io/npcc-lean/inspector/
Every identifier in a Lean statement is clickable and hoverable → a definition card in plain
English *and* the source, with the mathematics **typeset**; a **"check these translations by
hand"** panel on the main theorem and the two axioms; draggable multi-windows; and a **UI-size**
control to calibrate the text for your screen.

**Original explorer:**
### https://imlard.github.io/npcc-lean/
The dependency graph + PDF tracer, with every formalized statement highlighted in place.

Both are bidirectional (paper &harr; Lean &harr; graph), inspired by
[formalarXiv](https://beyondthelibrary.github.io/formal_arxiv/).

## What's in here
- `inspector/index.html` — the term-inspector explorer (self-contained single page).
- `index.html`, `pages/`, `paper.pdf` — the original explorer site (served by GitHub Pages).
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
