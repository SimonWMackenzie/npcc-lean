# WORK PACKET — lem:M1LowColumnStage2 [STATE]

lean_name: NPCC.M1_low_column_stage2
file: NPCC/Stage1.lean
kind: lemma
deps: lem:rankclaim, lem:relaxed-to-classical, def:equipartition-ge, def:stage-matrices, lem:large-d-checklist, cor:localized-extension, lem:M0-column-loss-resilient

## Statement (VERBATIM from frozen arXiv v4 — the ONLY authority)

```latex
\begin{lemma}[Residual Stage-1 hardness at Stage-2 densities]\label{lem:M1LowColumnStage2}
    Let
    \[
        h^{\downarrow}_2:=2^{-(\Robustness_1+\log r_2)},
        \qquad
        h'^{\downarrow}_2:=\frac{2^{-\CoreRobustness_1}}{16\Independence_1}.
    \]
    For every power of two \(1\le r'\le r_1\), any extraction
    \[
        N=\extractmatrix{\MOne}{R'}{C'}
    \]
    such that \(R'\) is a \((Q,1)\)-equipartition with
    \[
        |Q|=\frac{9}{16}\,r'\Independence_1
    \]
    and
    \[
        \frac{|C'|}{|C_1|}\ge h^{\downarrow}_2
    \]
    satisfies
    \[
        \comp{N}\ge \comp{\MZero}+\log\Independence_1+\log r'.
    \]
\end{lemma}
```

## Spec / intent

CORRECTED VEHICLE (lane finding 2026-07-06): NOT relaxed_to_classical (impossible: u = (9/16)r't1 > t1 for r' >= 2; S1fam only (q1+5,t1)-balanced). Vehicle = cor:localized-extension at f=M0, T=log t1, R'e=log r', a=0, p_seed=(9/16)t1 (gate t1/2 <= p_seed <= t1 holds). Needs: lem:M0-column-loss-resilient (new), the LargeD seed-bound inequality b1+log r2+T+1+log2(1+eps) < t1/16, and an S1fam projection/relabel wrapper Fin(q1+5) -> Fin(q1+2)=Fin(r1*t1) via IsBalancedFamily.projection + D_equiv_invariance. Conditional proof banked: pipeline/tmp/m1lcs2.opus.v1.lean (typechecked; 3 named hypotheses isolate the gap; statement verified well-formed against the live tree - REUSE ITS EXACT CLAIM BLOCK verbatim at STATE time). COLLISION: same live file as lem:stage1-threshold - serialize gates, append-only merge per the candidate header.

## Contract (STATE phase)
- Author the Lean STATEMENT only (defs: the definition; lemmas: `theorem ... := by sorry`).
- Wrap the statement in claim markers:
```
-- CLAIM-BEGIN lem:M1LowColumnStage2
<statement lines>
-- CLAIM-END lem:M1LowColumnStage2
```
- General and faithful to the tex; no problem-specific tailoring beyond the paper.
- Submit with: node pipeline/runner.mjs state lem:M1LowColumnStage2 <file-containing-full-new-lean-file>
- SIGN-OFF REQUIRED (Simon) before proving starts.

## Available context
- Reuse layer: Workspace.* (artifact, verified; see formalization/reference-lean/REUSE-INVENTORY.md)
- Existing NPCC modules in this repo: see NPCC/ directory
- Prior attempts: 0
