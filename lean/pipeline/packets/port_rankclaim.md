# WORK PACKET — port:rankclaim [STATE]

lean_name: NPCC.rankclaim
file: NPCC/SeedRank.lean
kind: port-check
deps: bridge:bracket

## Statement (VERBATIM from frozen arXiv v4 — the ONLY authority)

```latex
\begin{lemma}\label{lem:rankclaim}
    For \(\MZero=[1\;\;0]\), any positive integer \(p\), and reals
    \(0<x,y\le 1\) satisfying \(p+\log y>0\), one has
    \[
        \comp{\bracket{\MZero}{p}{x}{y}}
        \ge
        \ceil{\log\!\bigl(p+\log y\bigr)}+1.
    \]
\end{lemma}
```

## Spec / intent

Verify Workspace LogRankBound covers the paper's lem:rankclaim (D(bracket [1 0] p x y) >= ceil(log(p + log y)) + 1); restate NPCC-facing over bracketGE via bridge; no new proof if the artifact decl suffices.

## Contract (STATE phase)
- Author the Lean STATEMENT only (defs: the definition; lemmas: `theorem ... := by sorry`).
- Wrap the statement in claim markers:
```
-- CLAIM-BEGIN port:rankclaim
<statement lines>
-- CLAIM-END port:rankclaim
```
- General and faithful to the tex; no problem-specific tailoring beyond the paper.
- Submit with: node pipeline/runner.mjs state port:rankclaim <file-containing-full-new-lean-file>
- SIGN-OFF REQUIRED (Simon) before proving starts.

## Available context
- Reuse layer: Workspace.* (artifact, verified; see formalization/reference-lean/REUSE-INVENTORY.md)
- Existing NPCC modules in this repo: see NPCC/ directory
- Prior attempts: 0
