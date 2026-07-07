# Findings about the paper surfaced by formalization
(arXiv:2508.05597 v4; pipeline: formalization/PIPELINE-SPEC.md. BtL-on-Pham pattern:
faithful formalization against literal definitions surfaces statement gaps.)

## F1 (2026-07-06): lem:two-copy-ladder needs a level guard
As literally stated (H in R, no lower bound on H), the lemma is FALSE. Witness
(machine-verified, exact counting): M = M0 = [1 0] (equivalently [0 1]), x = 1/2,
y = 3/5, H = 1. All three hypotheses hold; the middle two-copy conclusion fails
(ceil(4 * 9/50) = 1 column admits a monochromatic 2x1 member, comp 0 < H = 1) and the
top conclusion also fails (columns (0,0),(1,1) give [[0,1],[0,1]], comp 1 < H+1 = 2).
MINIMAL REPAIR: add H > 1 (integer form: H >= 2). Every downstream use in the paper
appears to run at comp M >= 2 (odd-copy seed, plus-one family, separation all assume
it), BUT cor:robust-two-copy-ladder as stated instantiates H = comp M where R1 only
supplies comp M >= 1 — recommend adding comp M >= 2 (or the H guard) there too in the
next revision. Discovered by the GPT-5.5 Pro faithfulness lane; independently flagged
(empty-domain variant) by Gemini Deep Think; verified by GPT-5.5 xhigh re-derivation.
Lean side: theorem carries the guard (hH : 1 < H), documented in the claim docstring.

## F1 addendum (2026-07-06 ~10:45): the repair is PROVED sufficient
The guarded lemma (with H > 1) is now machine-PROVED in Lean, kernel-axioms-only —
via the Dfamily=DSet transfer into the M&S artifact ladder machinery. Structural note
for the revision: the two-copy squaring y -> y^2 is exactly the artifact column-ladder
step at (p=1, tau=1); the guard is load-bearing at (a) the degenerate-domain kill and
(b) bottom-rung non-monochromaticity — precisely where the unguarded statement failed.
So the recommended fix (H > 1 on the lemma; comp M >= 2 on cor:robust-two-copy-ladder)
is not conjectural: the repaired statement is a verified theorem.

## F2 (2026-07-06) — lem:hard-seed: threshold must not be uniform in the robustness margin δ

Formalization finding (paper text SOUND under its intended reading; clarification
recommended). The first Lean rendering hoisted the entire robustness datum
(f, δ, b) inside the asymptotic threshold ("∃ m₀ ∀ m ≥ m₀ ∀ M robust...").
That statement is UNPROVABLE: landing the target density 2^(−2^(0.49·√m))
from rungs at y₀ = (1/2+δ)² requires grid depth s·log₂ρ ≥ 0.49√m + log₂(1/η)
with η = −2·log₂(1/2+δ), while the copy-count cap
⌊2^k β^s p⌋ ≤ (2^(j−1)+2)·2^(m−j) bounds s by O(√m) with a j-fixed constant —
so δ → 1/2⁻ defeats any candidate m₀ (two independent GPT-5.5 re-derivations,
one blind; discovered by the Opus prover lane, which correctly refused to
fabricate a proof). At δ = 1/2 exactly (an endpoint our earlier closed-bound
convention δ ≤ 1/2 admits, though the paper's convention is open) the
amplification route is impossible outright.

REPAIR (adopted): quantify j AND δ (0 < δ < 1/2, open) BEFORE the threshold —
m₀ = m₀(j, δ); the game and b stay inside (b grows with the downstream
instance; δ is a fixed constant of the reduction's construction). This matches
the paper's proof, which treats y₀ as constant in t.

SUGGESTED PAPER EDIT: in lem:hard-seed, make explicit that the "sufficiently
large" threshold may depend on the robustness parameters (or fix δ globally
before the lemma), since the lemma quantifies M after t.
