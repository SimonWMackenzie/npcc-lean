# NP-Completeness of Deterministic Communication Complexity — machine-verified in Lean 4

A machine-checked **Lean 4** formalization of the core reduction in *NP-Completeness of
Deterministic Communication Complexity via Relaxed Interlacing* (Gaspers, He, Mackenzie;
arXiv:2508.05597 v4), with an interactive **paper &harr; Lean explorer**.

> **Scope of the machine check.** The Lean kernel verifies the **size-bounded gap reduction**: a
> 4-Colouring instance is mapped to a communication-complexity gap instance with `YES ⟺ small
> protocol` and polynomial size bounds. The remaining ingredients of the full NP-completeness
> statement — polynomial-time constructibility, membership in NP, and 4-Colouring's own NP-hardness
> — are the paper's prose / standard external results, **not** formalized here.

## Live explorers

**Term inspector (recommended) — for readers who don't know Lean:**
### https://imlard.github.io/npcc-lean/inspector/
Every identifier in a Lean statement is clickable and hoverable → a definition card in plain
English *and* the source, with the mathematics **typeset**; a **"check these translations by
hand"** panel on the main theorem and the cited axiom; draggable multi-windows; and a **UI-size**
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
`Classical.choice`, and `Quot.sound` plus exactly **one** cited axiom:
- `aghp_balanced_family_exists` — existence of the balanced column family (Alon–Goldreich–Håstad–Peralta 1992).

The 4-Colouring → Vector-Bin-Packing reduction (paper Proposition 42) was **formerly a second
axiom (`vbp_np_hard`); it is now discharged** — a proved Lean `def` whose correctness (`YES ⟺ YES`)
and size bounds are machine-checked, so `#print axioms NPCC.main_np_hardness` no longer lists it.

62 of the paper's 65 numbered statements are formalized: **128 proved** in `lean/Npcc/` (this work,
including the discharged reduction) and **8 reused** from the sorry-free Mackenzie–Saffidine
`lean/Workspace/` layer. The remaining 3 are two-copy exposition variants the proof deliberately
routes around.

## Build
Requires Lean 4.30.0 (`lean/lean-toolchain`) and `lake`:

```sh
cd lean
lake exe cache get      # prebuilt Mathlib cache
lake build NPCC         # 0 sorries
```

GitHub Actions also runs `lake build NPCC` and the axiom-footprint reports in
`.github/workflows/lean.yml`.

## Paper
arXiv:2508.05597 — https://arxiv.org/abs/2508.05597
