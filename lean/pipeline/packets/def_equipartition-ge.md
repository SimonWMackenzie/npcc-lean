# WORK PACKET — def:equipartition-ge [STATE]

lean_name: NPCC.IsEquipartitionedGE
file: NPCC/Defs.lean
kind: def
deps: none

## Statement (VERBATIM from frozen arXiv v4 — the ONLY authority)

```latex
\begin{definition}[(Q,T)-Equipartitioned Row Set]\label{def:equipartition}
    Let \(X\) be a finite set, let \(k \ge 1\), and let \(Q \subseteq [k]\).
    For a row set \(R \subseteq [k]\times X\) and an integer \(T \ge 1\), write
    \[
        R_q := \{x \in X : (q,x) \in R\}
        \quad\text{for each } q \in Q.
    \]
    We say that \(R\) is \emph{\((Q,T)\)-equipartitioned} if
    \[
        |R_q| \ge T
        \quad\text{for every } q \in Q.
    \]
\end{definition}
```

## Spec / intent

Paper Def (>= T variant): |R_q| >= T for every q in Q. NOT the artifact's exact-card IsEquipartitioned.

## Contract (STATE phase)
- Author the Lean STATEMENT only (defs: the definition; lemmas: `theorem ... := by sorry`).
- Wrap the statement in claim markers:
```
-- CLAIM-BEGIN def:equipartition-ge
<statement lines>
-- CLAIM-END def:equipartition-ge
```
- General and faithful to the tex; no problem-specific tailoring beyond the paper.
- Submit with: node pipeline/runner.mjs state def:equipartition-ge <file-containing-full-new-lean-file>
- SIGN-OFF REQUIRED (Simon) before proving starts.

## Available context
- Reuse layer: Workspace.* (artifact, verified; see formalization/reference-lean/REUSE-INVENTORY.md)
- Existing NPCC modules in this repo: see NPCC/ directory
- Prior attempts: 0
