# WORK PACKET — def:bracket-ge [STATE]

lean_name: NPCC.bracketGE
file: NPCC/Defs.lean
kind: def
deps: def:equipartition-ge

## Statement (VERBATIM from frozen arXiv v4 — the ONLY authority)

```latex
\begin{definition}[Bracket family]\label{def:bracket}
    Let \(M\) be an \(m\times n\) matrix, let \(p\ge 1\), and let
    \(0<x,y\le 1\).  Write
    \[
        T:=\ceil{mx},
        \qquad
        S:=\ceil{n^p y}.
    \]
    The family \(\bracket{M}{p}{x}{y}\) consists of all submatrices of
    \(\interlaceOp{M}{p}\) whose row set is \(([p],T)\)-equipartitioned and
    whose column set has size at least \(S\).
\end{definition}
```

## Spec / intent

Paper Def bracket family: row set ([p], ceil(mx))-equipartitioned (>=), column set SIZE >= ceil(n^p y). Set of extracted submatrices of interlace M p.

## Contract (STATE phase)
- Author the Lean STATEMENT only (defs: the definition; lemmas: `theorem ... := by sorry`).
- Wrap the statement in claim markers:
```
-- CLAIM-BEGIN def:bracket-ge
<statement lines>
-- CLAIM-END def:bracket-ge
```
- General and faithful to the tex; no problem-specific tailoring beyond the paper.
- Submit with: node pipeline/runner.mjs state def:bracket-ge <file-containing-full-new-lean-file>
- SIGN-OFF REQUIRED (Simon) before proving starts.

## Available context
- Reuse layer: Workspace.* (artifact, verified; see formalization/reference-lean/REUSE-INVENTORY.md)
- Existing NPCC modules in this repo: see NPCC/ directory
- Prior attempts: 0
