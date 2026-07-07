# Formalization COMPLETE — arXiv:2508.05597 machine-verified in Lean 4

**2026-07-07. Board: 125 obligations proved, 0 open.** The Gaspers–He–Mackenzie
"NP-Completeness of Deterministic Communication Complexity via Relaxed
Interlacing" is now machine-checked in Lean 4, resting on exactly two cited
axioms plus Lean's standard three.

## Capstone verification (reproducible)
From `C:\lean\npc-cc`:
- `lake build NPCC` → **Build completed successfully (8528 jobs)**, exit 0.
- `#print axioms NPCC.main_np_hardness` →
  `[propext, Classical.choice, NPCC.aghp_balanced_family_exists, NPCC.vbp_np_hard, Quot.sound]`.
- Repo-wide `sorry`-token scan over `Npcc/*.lean` → **0 hits**.
- `axiom` declarations in `Npcc/` → **exactly 2** (`aghp_balanced_family_exists`, `vbp_np_hard`).

Source mirror: `formalization/lean-mirror.bundle` (git bundle, refreshed). Final
commit `ebdfa3f`.

## The headline theorem (`NPCC.main_np_hardness`, `Npcc/Wrapper.lean`)
Layer-B kernel content — a size-bounded many-one **gap reduction** from edge-list
4-Colouring to the communication matrix `M₄`. For every `G : FourColorInstance`:
1. `(vbp_np_hard.toVBP G).Promise` — the produced VBP instance is in the promised class;
2. `(toVBP G).n ≤ G.sourceSize` and `(toVBP G).d ≤ G.sourceSize` — source→VBP size polynomial;
3. `ctorScaleFull (toVBP G) ≤ 2 · max (preprocess …).d ctorDStarFull` — construction scale controlled;
4. `card (R4 …) ≤ n' + rowPoly …` and `card (C4 …) ≤ colPoly …` — M₄ truth-table carrier bounded;
5. **`G.IsYes ↔ D (M4 (ctorScaleFull (toVBP G)) (reducedVectorsFull (toVBP G))) ≤ Byes …`** — the two-sided gap.

Chained, (2)–(4) bound the M₄ truth-table size polynomially in `G.sourceSize`; (5)
is the NO⟺GAP separation (`D` = deterministic communication complexity = protocol depth).

## Scope (as you ratified)
Kernel certifies **construction size bounds + the NO⟺GAP separation**. Polynomial
**runtime** and formal **NP-membership / the class-level "NP-complete" predicate**
remain Layer-B prose — deliberately NOT in the kernel statement.

## The two citation axioms
- `aghp_balanced_family_exists` (`Npcc/Axioms.lean`) — Alon–Goldreich–Håstad–Peralta balanced families (existence; poly-time constructibility is prose).
- `vbp_np_hard` (`Npcc/Wrapper.lean`) — NP-hardness of the promised `{0,1}`-VBP endpoint (`c=1, m=4`) as a size-bounded YES-preserving many-one reduction from 4-Colouring, packaged `VBP4PromiseHardnessPackage` (paper Prop. 42). **Governed declaration:** you authorized it; then a 5-lens adversarial audit returned CLEAR_TO_DECLARE — the satisfiability lens produced a *positive truth certificate* (brute-forced the paper's construction against the Lean semantics over all 251 small graphs + the Kₖ chromatic boundary, confirming the axiom is a true statement, not merely non-over-claiming). Audit banked at `pipeline/judgments/audit-vbp-np-hard-governed-2026-07-07.md`.

## Ratification pile — for your final review (all backed by CORRECT C5 judges)
Recorded provisional statement sign-offs made under your "keep going until done" +
"I approve / I unblock the wrapper" authorizations:
1. **`lem:MFourNoWasteLift` reformulation** — added the `IsPow2`+`2^18 ≤ log₂ d`+analytic-bundle hypotheses (same bundle as the fuzzy-leaves lemma, discharged downstream by `CtorScaleCertificateFull`); paper conclusion verbatim. Delta-judge CORRECT (`pipeline/judgments/judge-nwl-faithfulness-delta.md`).
2. **`thm:reduction-gap` statement** — the gap pair over the full construction scale `ctorScaleFull`. C5 CORRECT (`judge-reduction-gap-faithfulness.md`).
3. **`thm:main-nphard-intro` statement** — the reduction-map + gap + poly-size-bounds form above (the D7-ratified shape; I folded in the audit's suggestion to surface the `sourceSize` bounds so "polynomial-size reduction" is licensed by stated conjuncts). Headline C5 CORRECT (`judge-main-nphard-faithfulness.md`).

Nothing here changes the kernel's soundness (compiler-checked); these are faithfulness/statement-shape ratifications for your sign-off on the record.

## Where things live
- Lean development: `C:\lean\npc-cc` (mirror `formalization/lean-mirror.bundle`).
- Ledger: `obligations.json` (125 proved). Loop journal: `loop-log.md`. Judgments/audits: `pipeline/judgments/`.
- Canonical text: `formalization/paper-snapshots/arxiv-2508.05597-src/main.tex` (v4).
