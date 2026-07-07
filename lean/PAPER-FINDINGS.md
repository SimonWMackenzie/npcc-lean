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
