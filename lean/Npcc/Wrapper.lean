import Mathlib
import NPCC.VBP
import NPCC.Gap
import NPCC.Reduction
import NPCC.Size

/-! # Layer-B citation axiom: NP-hardness of promised {0,1}-Vector Bin Packing
Governed declaration (Simon-authorized 2026-07-07; design = Ultra npcc-12 Shape C,
audited twice). Compile-check artifact for the faithfulness audit before the
real declaration lands in `Npcc/Wrapper.lean`. -/

namespace NPCC

open Workspace.Types.CommComplexity

/-- An edge-list instance of 4-Colouring: `numVerts` vertices, `numEdges` edges
given by two endpoint maps, with no self-loops. This is the source problem the
paper reduces from (arXiv:2508.05597, Proposition 42: the restricted
`{0,1}`-Vector-Bin-Packing endpoint with capacity `c = 1` and `m = 4` bins is
NP-complete by reduction from 4-Colouring). -/
structure FourColorInstance where
  numVerts : Nat
  numEdges : Nat
  edgeL : Fin numEdges → Fin numVerts
  edgeR : Fin numEdges → Fin numVerts
  edge_ne : ∀ e : Fin numEdges, edgeL e ≠ edgeR e

namespace FourColorInstance

/-- `G` is a YES-instance iff its vertices admit a proper 4-colouring: some
`colour : [numVerts] → [4]` giving distinct colours to the two endpoints of
every edge. -/
def IsYes (G : FourColorInstance) : Prop :=
  ∃ colour : Fin G.numVerts → Fin 4,
    ∀ e : Fin G.numEdges, colour (G.edgeL e) ≠ colour (G.edgeR e)

/-- The source description length (vertices + edges + 1), the polynomial the
reduction's output sizes are measured against. -/
def sourceSize (G : FourColorInstance) : Nat :=
  G.numVerts + G.numEdges + 1

end FourColorInstance

namespace VBPInstance

/-- The Boolean-matrix footprint `(n+1)(d+1)` of a VBP instance's presentation,
used to state the reduction's monomial size bound. -/
def hardnessMatrixSize (I : VBPInstance) : Nat :=
  (I.n + 1) * (I.d + 1)

end VBPInstance

/-- The content of `vbp_np_hard`: a size-bounded many-one reduction from
edge-list 4-Colouring to the promised `{0,1}`-Vector-Bin-Packing endpoint
(`c = 1`, `m = 4`). It supplies a map `toVBP` such that every produced instance
(i) satisfies the per-coordinate weight promise (each coordinate is `1` in at
most 4 vectors — the paper's "one vector per vertex, one coordinate per edge, so
each coordinate hits exactly its two endpoints" observation, generously
bounded), (ii) is a YES-instance iff the source is 4-colourable, and (iii) has
item count, dimension, and matrix footprint all bounded by fixed monomials in
`sourceSize`. It asserts NOTHING about polynomial runtime, about the class NP,
or about promise-violating VBP inputs — those stay outside the kernel. -/
structure VBP4PromiseHardnessPackage where
  toVBP : FourColorInstance → VBPInstance
  toVBP_promise : ∀ G : FourColorInstance, (toVBP G).Promise
  toVBP_yes_iff : ∀ G : FourColorInstance, G.IsYes ↔ (toVBP G).IsYes
  toVBP_numItems_bound : ∀ G : FourColorInstance, (toVBP G).n ≤ G.sourceSize
  toVBP_numDims_bound : ∀ G : FourColorInstance, (toVBP G).d ≤ G.sourceSize
  toVBP_matrixSize_bound :
    ∀ G : FourColorInstance, (toVBP G).hardnessMatrixSize ≤ (G.sourceSize) ^ 2

-- CLAIM-BEGIN axiom:vbp-np-hard
/-- CITATION AXIOM [arXiv:2508.05597 Proposition 42; the cited NP-completeness of
the restricted `{0,1}`-`d`-Dimension Vector Bin Packing problem with capacity
`c = 1` and `m = 4` bins, proved there by a size-bounded many-one reduction from
4-Colouring — one vector per vertex, one coordinate per edge]: there is a
size-bounded many-one reduction from edge-list 4-Colouring to the promised
endpoint, packaged as a `VBP4PromiseHardnessPackage`. The reduction preserves
YES exactly (`toVBP_yes_iff`), always lands in the promise class
(`toVBP_promise`), and blows up size only monomially (`toVBP_numItems_bound`,
`toVBP_numDims_bound`, `toVBP_matrixSize_bound`). This is the ONLY Layer-B
citation axiom; like `aghp_balanced_family_exists`, it imports a cited external
result. It deliberately does NOT formalize polynomial-time constructibility, the
class NP, or any statement about non-promised inputs (all Layer-B prose). -/
axiom vbp_np_hard : VBP4PromiseHardnessPackage
-- CLAIM-END axiom:vbp-np-hard

/-- Full-constructor analogue of `ctorScale_le_two_mul_max`. -/
theorem ctorScaleFull_le_two_mul_max (I : VBPInstance)
    (hmax : 1 <= max (preprocess I).d ctorDStarFull) :
    ctorScaleFull I <= 2 * max (preprocess I).d ctorDStarFull := by
  simpa [ctorScaleFull_eq_ceilPowTwo I] using ceilPowTwo_le_two_mul hmax

-- CLAIM-BEGIN thm:main-nphard-intro
/-- Paper `thm:main-nphard-intro` (NP-completeness of deterministic communication
complexity), Layer-B kernel content: a size-bounded many-one gap reduction from
edge-list 4-Colouring to the communication matrix `M₄`. For every 4-colouring
instance `G`, the produced VBP instance is promised, its item/dimension counts and
the `M₄` truth-table carrier are polynomially bounded in `G.sourceSize`, and `G`
is 4-colourable IFF `M₄` has a deterministic protocol of cost `≤ B_yes`. Poly-time
constructibility and NP membership remain Layer-B prose. -/
theorem main_np_hardness :
    ∀ G : FourColorInstance,
      (vbp_np_hard.toVBP G).Promise ∧
      (vbp_np_hard.toVBP G).n ≤ G.sourceSize ∧
      (vbp_np_hard.toVBP G).d ≤ G.sourceSize ∧
      ctorScaleFull (vbp_np_hard.toVBP G)
          ≤ 2 * max (preprocess (vbp_np_hard.toVBP G)).d ctorDStarFull ∧
      ((Fintype.card (R4 (ctorScaleFull (vbp_np_hard.toVBP G))
            (reducedInstanceFull (vbp_np_hard.toVBP G)).n) : ℝ)
          ≤ ((reducedInstanceFull (vbp_np_hard.toVBP G)).n : ℝ)
            + rowPoly (ctorScaleFull (vbp_np_hard.toVBP G))) ∧
      ((Fintype.card (C4 (ctorScaleFull (vbp_np_hard.toVBP G))) : ℝ)
          ≤ colPoly (ctorScaleFull (vbp_np_hard.toVBP G))) ∧
      (G.IsYes ↔
        D (M4 (ctorScaleFull (vbp_np_hard.toVBP G))
              (reducedVectorsFull (vbp_np_hard.toVBP G)))
          ≤ Byes (ctorScaleFull (vbp_np_hard.toVBP G)))
-- CLAIM-END thm:main-nphard-intro
  := by
  intro G
  let I := vbp_np_hard.toVBP G
  let dCtor := ctorScaleFull I
  obtain ⟨hpow, hlog, hchk, hd, hm0, hrowT, hraw, hprime, h35, hrob⟩ :=
    CtorScaleCertificateFull I
  have hscale : dCtor <= 2 * max (preprocess I).d ctorDStarFull := by
    have hmax : 1 <= max (preprocess I).d ctorDStarFull := by
      by_contra hmax
      have hmax0 : max (preprocess I).d ctorDStarFull = 0 := by omega
      have hdCtor : dCtor = 1 := by
        simp [dCtor, ctorScaleFull_eq_ceilPowTwo, hmax0, ceilPowTwo]
      omega
    simpa [dCtor] using ctorScaleFull_le_two_mul_max I hmax
  have hsize :=
    output_size_bounds dCtor (reducedInstanceFull I).n
      (Params.t1_pos dCtor) hchk.t1_le_q1_add_five
      (Params.t2_pos dCtor) hchk.t2_le_q2 hchk.one_le_q1
  have hgap :
      G.IsYes ↔ D (M4 dCtor (reducedVectorsFull I)) <= Byes dCtor := by
    obtain ⟨hYes, hNo⟩ := reduction_gap I
      (by simpa [I] using vbp_np_hard.toVBP_promise G)
    constructor
    · intro hG
      exact hYes ((vbp_np_hard.toVBP_yes_iff G).mp hG)
    · intro hD
      by_contra hnG
      have hNoI : ¬ I.IsYes := by
        intro hI
        exact hnG ((vbp_np_hard.toVBP_yes_iff G).mpr hI)
      exact (not_le.mpr (hNo hNoI)) hD
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simpa [I] using vbp_np_hard.toVBP_promise G
  · simpa [I] using vbp_np_hard.toVBP_numItems_bound G
  · simpa [I] using vbp_np_hard.toVBP_numDims_bound G
  · simpa [I, dCtor] using hscale
  · simpa [I, dCtor] using hsize.1
  · simpa [I, dCtor] using hsize.2
  · simpa [I, dCtor] using hgap

end NPCC
