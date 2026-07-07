# Manuscript edits surfaced by the Lean formalization — TODO for a future agent

**Purpose.** The Lean 4 formalization of this paper (complete: 125 obligations
proved, 0 open, on 2 cited axioms — see `RECAP-COMPLETE-2026-07-07.md`) surfaced
a small number of issues in the manuscript. This file is the actionable edit list.

**How to apply.** Edit the LIVE manuscript at `manuscript/main.tex`. Line numbers
below are from the frozen v4 snapshot
`formalization/paper-snapshots/arxiv-2508.05597-src/main.tex`; locate each item by
its **label** (labels are stable, line numbers may have drifted). Every claim
below is machine-checked in Lean (`C:\lean\npc-cc`); the fixes are not
conjectural — the repaired statements are verified theorems.

Severity legend: **[MUST-FIX]** the statement is false / unprovable as written ·
**[CLARIFY]** sound under the intended reading, but the text should be tightened ·
**[OPTIONAL]** a simplification/observation, no correctness impact.

---

## Edit 1 — [MUST-FIX] `lem:two-copy-ladder` is false without a level guard
**Where:** `\begin{lemma}\label{lem:two-copy-ladder}` (snapshot line 554), the
hypothesis line "let \(H\in \mathbb R\)" (line 556).

**Issue.** As literally stated (`H ∈ ℝ`, no lower bound) the lemma is FALSE.
Machine-verified counterexample (exact counting, no floating point):
`M = M₀ = [1 0]`, `x = 1/2`, `y = 3/5`, `H = 1`. All three hypotheses hold, but
the conclusion fails: the middle rung `comp⟦M⟧₂,2x,y²/2 ≥ H = 1` is violated
(`⌈4·9/50⌉ = 1` column leaves a monochromatic `2×1` block, comp `0 < 1`), and the
top rung `≥ H+1 = 2` fails too (columns `(0,0),(1,1)` give `[[0,1],[0,1]]`,
comp `1 < 2`).

**Fix.** Add the guard **`H > 1`** to the hypotheses (integer form `H ≥ 2`):
change "let \(H\in \mathbb R\)" → "let \(H\in \mathbb R\) with \(H>1\)".

**Verification.** The guarded lemma is proved in Lean, kernel-axioms-only. The
guard is load-bearing exactly at (a) the degenerate-domain kill and (b) bottom-rung
non-monochromaticity — the two places the unguarded statement fails. Every
downstream use in the paper already runs at `comp M ≥ 2`, so the guard is free
downstream — **except** the corollary in Edit 2.

## Edit 2 — [MUST-FIX] `cor:robust-two-copy-ladder` instantiates `H = comp M` with only `comp M ≥ 1`
**Where:** `\begin{corollary}\label{cor:robust-two-copy-ladder}` (snapshot line 703).

**Issue.** This corollary instantiates `lem:two-copy-ladder` at `H = comp M`, but
its own robustness hypothesis (via R1) only guarantees `comp M ≥ 1`, which does not
meet the `H > 1` guard from Edit 1.

**Fix.** Add **`comp M ≥ 2`** to the corollary's hypotheses (or otherwise ensure
`H = comp M > 1` at the instantiation). This is the only downstream site that
needs a change once Edit 1 lands.

## Edit 3 — [CLARIFY] `lem:hard-seed` threshold must be allowed to depend on the robustness margin
**Where:** `\begin{lemma}\label{lem:hard-seed}` (snapshot line 1874).

**Issue.** The lemma reads "for sufficiently large … , for every robust `M` …",
placing the robustness datum `(f, δ, b)` *inside* the asymptotic threshold. Under
that literal quantifier order the statement is **unprovable**: landing the target
column density `2^(−2^(0.49√m))` from rungs at `y₀ = (1/2+δ)²` needs grid depth
`≳ 0.49√m + log₂(1/η)` with `η = −2 log₂(1/2+δ)`, while the copy-count cap bounds
the usable depth by `O(√m)` with a `j`-fixed constant — so `δ → 1/2⁻` defeats any
single threshold `m₀` (at `δ = 1/2` exactly the route is impossible). The paper's
*intended* reading — `δ` a fixed construction constant chosen before the limit — is
sound; only the written quantifier order is loose.

**Fix.** Make explicit that the "sufficiently large" threshold may depend on the
robustness parameters, e.g. quantify `δ` (and `j`) **before** the threshold:
`m₀ = m₀(j, δ)`, `0 < δ < 1/2` fixed; the game and `b` stay quantified after (they
grow with the downstream instance). One sentence suffices.

**Verification.** With `δ` (open, `<1/2`) hoisted before the threshold, `lem:hard-seed`
is proved in Lean. The Opus prover lane correctly *refused* to prove the loose form;
two independent GPT-5.5 re-derivations confirmed the two-sided squeeze.

---

## Optional notes (no correctness impact — record if revising)
- **[OPTIONAL] `def:column-loss-resilient` clause (ii) is unconsumed downstream.**
  (`\label{def:column-loss-resilient}` snapshot line 1912; used at
  `lem:M2-column-loss-resilient` line 3759.) In the formalization, clause (ii) of
  column-loss resilience enters only through `localized_extension`; both `Extension`
  and `Separation` are proved from clause (i) alone. This matches the paper but
  suggests clause (ii) could be dropped or presented as a derived remark.
- **[OPTIONAL] balanced-family lower bound needs `t ≤ q`.** The family-cardinality
  lower bound is vacuous unless `t ≤ q` (empty-family witness); the paper uses it
  only in that regime, but stating `t ≤ q` explicitly removes a silent side
  condition.
- **[OPTIONAL] Stage-1 threshold is priced by direct counting, not robustness.**
  `lem:stage1-threshold` is proved by direct heavy-rectangle counting; the
  robustness "engine" is not needed there. A one-line remark could save a reader
  from looking for a robustness argument.
- **[OPTIONAL] construction regime.** The reduction operates at
  `d = ceilpowtwo(max{5·dim, d_star})` with `d_star` a large constant power of two
  (the large-`d` inequalities bind around `loglog d ≳ 640`, i.e. an astronomically
  large but **constant** `d_star`). The main theorem is already threshold-free via
  per-instance padding; a footnote noting `d_star` is an explicit constant may help.

---

## Provenance
All findings are logged in `formalization/PAPER-FINDINGS.md` (F1, F2) and the
formalization loop journal (`C:\lean\npc-cc\loop-log.md`). F1/F2 counterexamples
and repaired theorems are machine-checked. Pattern (per the Beyond-the-Library
methodology, arXiv:2606.31134): faithful formalization against *literal*
definitions surfaces statement gaps that human review missed.
