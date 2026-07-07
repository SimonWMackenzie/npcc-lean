import Mathlib
import NPCC.Scaffold
import NPCC.Gadget
import NPCC.VBP

/-! # Tranche 6 — output size bounds (candidate `NPCC/Size.lean`)

Authority: paper §5 `sec:Hardness`; the `lem:polytime` kernel half.
Binding design rulings: `pipeline/judgments/ultra-npcc-10-t6-design-audit.md`
D2 / D7 (+ the "never name a kernel lemma `polytime`" trap, #41 in that file).

**SIZE-BOUNDS-FIRST kernel statement.** D2/D7 forbid an in-kernel theorem
named as if it proved Turing-machine polynomial *time* / machine
constructibility. This file therefore delivers ONLY explicit cardinality
bounds on the reduction's output carriers `R₄` (rows of `M₄`) and `C₄`
(columns of `M₄`), as functions of the source instance's `n` (vector count)
and the ambient dimension `d`. The genuine "poly-time reduction exists"
sentence and the NP-completeness claim stay in the Layer-B boundary
certificate (they are not stated here).

**NAMING FLAG (report item, per trap #41).** The ledger entry names this
obligation `lem:polytime`. That name is FORBIDDEN as an in-kernel lemma name
by the ruling ("never name a kernel lemma `polytime` when it proves
cardinality bounds"). The theorem below is therefore named
`output_size_bounds`; the CLAIM markers carry the ledgered label
`lem:polytime` (the pipeline binds blocks by label, not by Lean identifier)
but the Lean identifier is a size-bound name. Mismatch surfaced for
adjudication: either (a) keep the ledger label `lem:polytime` on the block
while the Lean name stays `output_size_bounds` (current choice — the block
label is prose-facing, the Lean name is what could be mis-cited), or
(b) re-label the block to `lem:output-size-bounds`. Recommendation: (a) if
the label is only a cross-reference key; (b) if any consumer cites the label
verbatim as a "polytime" fact.

**What is proved (poly in `n + d`, explicit monomials, no O-notation).**
The row/column carriers unfold to exact cardinalities
* `|R₄| = 4·|C₂| + n = 4·L₂(d) + n`  (`card_R4`)
* `|C₄| = 32·|R₂|⁴ = 32·(q₂(d)·L₁(d))⁴`  (`card_C4`)
and the AGHP citation axiom's explicit size clause
`L ≤ (q+2)^C · (|Y|+2)^{C·t} · ⌈1/ε⌉^C` (`NPCC.aghp_balanced_family_exists`,
`Axioms.lean`) bounds the two balanced-family sizes `L₁(d)`, `L₂(d)` by
explicit monomials in the scaffold parameters `q₁,q₂,t₁,t₂` (all exact ℕ
functions of `Nat.log 2 d`). Composing gives `output_size_bounds`:
`|R₄| ≤ n + P_R(d)` and `|C₄| ≤ P_C(d)` with `P_R`, `P_C` the explicit
closed-form monomials `rowPoly d`, `colPoly d` below. No Turing machines,
no O-notation, no `polytime` name on any kernel declaration.

The gate hypotheses (`t₁ ≤ q₁+5`, `t₂ ≤ q₂`, `1 ≤ q₁`) are exactly the
large-`d` side conditions the balanced families are already exposed under
(`S1fam_balanced`, `S2fam_balanced`); on the reduction's normalised
power-of-two regime `d ≥ d_star` they hold (`LargeD.lean`). They are carried
as hypotheses here — the size lemma is regime-agnostic. -/

namespace NPCC

open Workspace.Types.Interlace

/-! ## Exact carrier cardinalities -/

/-- Exact row count of `M₄`: `|R₄| = |R₃| + n = 4·|C₂| + n = 4·L₂(d) + n`.
`R₄ = R₃ ⊕ [n]` (tagged sum), `R₃ = [4] × C₂`, `C₂ = Fin (L₂ d)`. -/
theorem card_R4 (d n : ℕ) : Fintype.card (R4 d n) = 4 * L2 d + n := by
  simp [R4, R3, C2, Fintype.card_sum, Fintype.card_prod, Fintype.card_fin,
        mul_comm]

/-- Exact column count of `M₄`: `|C₄| = 2⁵·|C₃| = 32·|R₂|⁴ = 32·(q₂(d)·L₁(d))⁴`.
`C₄ = [2⁵] × C₃`, `C₃ = [4] → R₂`, `R₂ = [q₂] × C₁`, `C₁ = Fin (L₁ d)`. -/
theorem card_C4 (d : ℕ) : Fintype.card (C4 d) = 32 * (Params.q2 d * L1 d) ^ 4 := by
  simp [C4, C3, R2, C1, Fintype.card_prod, Fintype.card_fin]

/-! ## Reciprocal-accuracy accessor (`⌈1/ε_{q,t}⌉` is exact) -/

/-- The AGHP accuracy `ε_{q,t} = (2qt)^{−C}` has an EXACT integer reciprocal
`1/ε_{q,t} = (2qt)^C`, so `⌈1/ε_{q,t}⌉ = (2qt)^C` with no rounding slack —
the ceiling factor of the axiom's size clause is a clean monomial. -/
theorem ceil_inv_epsQT (q t : ℕ) (hq : 0 < q) (ht : 0 < t) :
    ⌈1 / epsQT q t⌉₊ = (2 * q * t) ^ aghpConstant := by
  have hbase : (0 : ℝ) < ((2 * q * t : ℕ) : ℝ) := by
    have : 0 < 2 * q * t := by positivity
    exact_mod_cast this
  rw [epsQT, zpow_neg, zpow_natCast, one_div, inv_inv, ← Nat.cast_pow]
  exact Nat.ceil_natCast _

/-! ## Explicit monomial bounds on the balanced-family sizes -/

/-- Explicit monomial upper bound on `L₁(d) = |C₁|` from the AGHP axiom's
size clause (alphabet `Fin 2`, so `|Y| = 2`; parameters `q = q₁+5`, `t = t₁`,
`ε = ε_{q₁+5,t₁}`):
`L₁(d) ≤ (q₁+7)^C · 4^{C·t₁} · ((2(q₁+5)t₁)^C)^C`.
`C = aghpConstant`. Gated on the Stage-1 balancedness side condition
`t₁ ≤ q₁+5`. -/
theorem L1_le_poly (d : ℕ) (h1 : 1 ≤ Params.t1 d)
    (h2 : Params.t1 d ≤ Params.q1 d + 5) :
    (L1 d : ℝ) ≤ ((Params.q1 d + 7 : ℕ) : ℝ) ^ aghpConstant
        * (4 : ℝ) ^ (aghpConstant * Params.t1 d)
        * (((2 * (Params.q1 d + 5) * Params.t1 d) ^ aghpConstant : ℕ) : ℝ)
            ^ aghpConstant := by
  have hq : 0 < Params.q1 d + 5 := by omega
  have hbound := (balancedFamilyData_spec (Params.q1 d + 5) (Params.t1 d) (Fin 2)
    h1 h2 (epsQT_pos hq (Params.t1_pos d)) (epsQT_lt_one hq (Params.t1_pos d))
    (by simp)).2
  have hrecip :=
    ceil_inv_epsQT (Params.q1 d + 5) (Params.t1 d) hq (Params.t1_pos d)
  rw [hrecip] at hbound
  have e1 : (Params.q1 d + 5 + 2 : ℕ) = (Params.q1 d + 7 : ℕ) := by ring
  have e2 : (Fintype.card (Fin 2) + 2 : ℕ) = 4 := by simp
  rw [e1, e2] at hbound
  convert hbound using 3

/-- Explicit monomial upper bound on `L₂(d) = |C₂|` from the AGHP axiom's
size clause (alphabet `R₁ = Fin q₁ × Fin 1`, so `|Y| = q₁`; parameters
`q = q₂`, `t = t₂`, `ε = ε_{q₂,t₂}`):
`L₂(d) ≤ (q₂+2)^C · (q₁+2)^{C·t₂} · ((2·q₂·t₂)^C)^C`.
Gated on the Stage-2 balancedness side conditions `t₂ ≤ q₂`, `1 ≤ q₁`. -/
theorem L2_le_poly (d : ℕ) (h1 : 1 ≤ Params.t2 d) (h2 : Params.t2 d ≤ Params.q2 d)
    (hq1 : 1 ≤ Params.q1 d) :
    (L2 d : ℝ) ≤ ((Params.q2 d + 2 : ℕ) : ℝ) ^ aghpConstant
        * ((Params.q1 d + 2 : ℕ) : ℝ) ^ (aghpConstant * Params.t2 d)
        * (((2 * Params.q2 d * Params.t2 d) ^ aghpConstant : ℕ) : ℝ)
            ^ aghpConstant := by
  have hcard : 1 ≤ Fintype.card (Fin (Params.q1 d) × Fin 1) := by simpa using hq1
  have hbound := (balancedFamilyData_spec (Params.q2 d) (Params.t2 d)
    (Fin (Params.q1 d) × Fin 1) h1 h2
    (epsQT_pos (Params.q2_pos d) (Params.t2_pos d))
    (epsQT_lt_one (Params.q2_pos d) (Params.t2_pos d)) hcard).2
  have hrecip :=
    ceil_inv_epsQT (Params.q2 d) (Params.t2 d) (Params.q2_pos d) (Params.t2_pos d)
  rw [hrecip] at hbound
  have ecard : (Fintype.card (Fin (Params.q1 d) × Fin 1) + 2 : ℕ)
      = (Params.q1 d + 2 : ℕ) := by simp
  rw [ecard] at hbound
  convert hbound using 3

/-! ## The reduction's explicit output-size polynomials -/

/-- The explicit closed-form monomial bounding the "structural" part of the
row count, `P_R(d)`: `4 · L₁-style monomial in the Stage-2 parameters`.
`|R₄| = 4·L₂(d) + n`, and `L₂(d) ≤ (q₂+2)^C·(q₁+2)^{C·t₂}·((2q₂t₂)^C)^C`, so
`P_R(d) := 4·(q₂+2)^C·(q₁+2)^{C·t₂}·((2q₂t₂)^C)^C`. Every factor is an
explicit ℕ monomial in `q₁(d), q₂(d), t₂(d)` (themselves exact functions of
`Nat.log 2 d`) with the single absolute exponent `C = aghpConstant`. -/
noncomputable def rowPoly (d : ℕ) : ℝ :=
  4 * (((Params.q2 d + 2 : ℕ) : ℝ) ^ aghpConstant
        * ((Params.q1 d + 2 : ℕ) : ℝ) ^ (aghpConstant * Params.t2 d)
        * (((2 * Params.q2 d * Params.t2 d) ^ aghpConstant : ℕ) : ℝ) ^ aghpConstant)

/-- The explicit closed-form monomial bounding the column count, `P_C(d)`:
`|C₄| = 32·(q₂(d)·L₁(d))⁴`, and `L₁(d) ≤ (q₁+7)^C·4^{C·t₁}·((2(q₁+5)t₁)^C)^C`,
so `P_C(d) := 32·(q₂ · [that monomial])⁴`. Every factor is an explicit ℕ
monomial in `q₁(d), q₂(d), t₁(d)` with the single absolute exponent
`C = aghpConstant`. -/
noncomputable def colPoly (d : ℕ) : ℝ :=
  32 * (((Params.q2 d : ℕ) : ℝ)
        * (((Params.q1 d + 7 : ℕ) : ℝ) ^ aghpConstant
            * (4 : ℝ) ^ (aghpConstant * Params.t1 d)
            * (((2 * (Params.q1 d + 5) * Params.t1 d) ^ aghpConstant : ℕ) : ℝ)
                ^ aghpConstant)) ^ 4

-- CLAIM-BEGIN lem:polytime
/-- Paper `lem:polytime`, SIZE-BOUNDS-FIRST kernel half (D2/D7). NAMING FLAG:
the Lean identifier is `output_size_bounds`, NOT `polytime` — the ruling
forbids a kernel lemma named as if it certified machine-constructibility
(trap #41); this theorem proves only cardinality bounds. No Turing machines,
no O-notation.

For every source vector count `n` and ambient dimension `d`, under the
large-`d` balancedness gates (`t₁ ≤ q₁+5`, `t₂ ≤ q₂`, `1 ≤ q₁` — all supplied
on the normalised `d ≥ d_star` regime), the reduction's output matrix `M₄`
has row and column carriers bounded by EXPLICIT MONOMIALS in `n` and `d`:
* rows:    `|R₄| ≤ n + rowPoly d`   (linear in `n`, monomial in `d`);
* columns: `|C₄| ≤ colPoly d`       (monomial in `d`, independent of `n`).
Both `rowPoly` and `colPoly` are the closed-form monomials defined above,
whose only transcendental ingredient is the single absolute AGHP constant
`C = aghpConstant` in the exponents; `q₁,q₂,t₁,t₂` are exact ℕ functions of
`Nat.log 2 d`. This is the explicit `poly(n+d)` output-size certificate the
Layer-B NP-hardness wrapper consumes. -/
theorem output_size_bounds (d n : ℕ)
    (ht1 : 1 ≤ Params.t1 d) (ht1q : Params.t1 d ≤ Params.q1 d + 5)
    (ht2 : 1 ≤ Params.t2 d) (ht2q : Params.t2 d ≤ Params.q2 d)
    (hq1 : 1 ≤ Params.q1 d) :
    (Fintype.card (R4 d n) : ℝ) ≤ (n : ℝ) + rowPoly d
      ∧ (Fintype.card (C4 d) : ℝ) ≤ colPoly d := by
  refine ⟨?_, ?_⟩
  · -- rows: |R₄| = 4·L₂(d) + n ≤ n + 4·(L₂ monomial) = n + rowPoly d.
    rw [card_R4, rowPoly]
    have hL2 := L2_le_poly d ht2 ht2q hq1
    have hcast : ((4 * L2 d + n : ℕ) : ℝ) = (n : ℝ) + 4 * (L2 d : ℝ) := by
      push_cast; ring
    rw [hcast]
    have : 4 * (L2 d : ℝ)
        ≤ 4 * (((Params.q2 d + 2 : ℕ) : ℝ) ^ aghpConstant
              * ((Params.q1 d + 2 : ℕ) : ℝ) ^ (aghpConstant * Params.t2 d)
              * (((2 * Params.q2 d * Params.t2 d) ^ aghpConstant : ℕ) : ℝ)
                  ^ aghpConstant) := by
      gcongr
    linarith
  · -- columns: |C₄| = 32·(q₂·L₁)⁴ ≤ 32·(q₂·(L₁ monomial))⁴ = colPoly d.
    rw [card_C4, colPoly]
    have hL1 := L1_le_poly d ht1 ht1q
    have hcast : ((32 * (Params.q2 d * L1 d) ^ 4 : ℕ) : ℝ)
        = 32 * ((Params.q2 d : ℝ) * (L1 d : ℝ)) ^ 4 := by
      push_cast; ring
    rw [hcast]
    have hq2nn : (0 : ℝ) ≤ (Params.q2 d : ℝ) := by positivity
    gcongr
-- CLAIM-END lem:polytime

/-! ## Corollary: `|R₄|` is linear in `n` with a `d`-only slope-1 form -/

/-- Companion (wrapper convenience): the row bound in the exact "linear in `n`,
plus a `d`-only constant" shape the Layer-B reduction records. Needs ONLY the
Stage-2 gates (`|R₄|` is independent of the Stage-1 family). -/
theorem card_R4_le (d n : ℕ)
    (ht2 : 1 ≤ Params.t2 d) (ht2q : Params.t2 d ≤ Params.q2 d)
    (hq1 : 1 ≤ Params.q1 d) :
    (Fintype.card (R4 d n) : ℝ) ≤ (n : ℝ) + rowPoly d := by
  rw [card_R4, rowPoly]
  have hL2 := L2_le_poly d ht2 ht2q hq1
  have hcast : ((4 * L2 d + n : ℕ) : ℝ) = (n : ℝ) + 4 * (L2 d : ℝ) := by
    push_cast; ring
  rw [hcast]
  have : 4 * (L2 d : ℝ)
      ≤ 4 * (((Params.q2 d + 2 : ℕ) : ℝ) ^ aghpConstant
            * ((Params.q1 d + 2 : ℕ) : ℝ) ^ (aghpConstant * Params.t2 d)
            * (((2 * Params.q2 d * Params.t2 d) ^ aghpConstant : ℕ) : ℝ)
                ^ aghpConstant) := by
    gcongr
  linarith

end NPCC
