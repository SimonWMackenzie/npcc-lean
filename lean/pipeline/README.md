# pipeline/ — v1 loop runner (governed by formalization/PIPELINE-SPEC.md)

The runner is C1's only writer, C3 (compiler verdict + Claim-Check + axiom gate) and C4
(router with hard budgets). C2 (prover) and C5 (judge) drive it through packets: the
orchestrating Claude Code session — or a codex lane via model-bridge — reads
`pipeline/packets/<id>.md`, produces a full Lean file, and submits it.

## Drive loop
1. `node pipeline/runner.mjs status` — the honest readout (feeds loop-log.md).
2. `node pipeline/runner.mjs next` — picks the next actionable obligation
   (deps closed; parent-before-children by DAG), emits its work packet.
3. STATE phase: author the statement (defs; lemmas get `:= by sorry` bodies) inside
   `-- CLAIM-BEGIN <id> … -- CLAIM-END <id>` markers →
   `runner.mjs state <id> <file>` (must compile; claim block registered byte-exact in claims/).
4. C5: judge lanes (blind back-translation + direct compare, two model families via
   model-bridge) run on the registered statement; **Simon signs off** →
   `runner.mjs signoff <id>` (defs/lemmas/bridges/port-checks only; aux-lemmas are
   judge-only in v1 — they are redundant probes of the defs, not paper claims).
5. PROVE phase: `runner.mjs submit <id> <file>` — Claim Check (byte-identical statement),
   `lake build NPCC`, sorry scan, `#print axioms` ⊆ allowed set. Only this path can mark
   `proved`. Failures are routed with budgets (3/lane, then parked visibly).

## Invariants
- obligations.json is mutated ONLY by the runner. DAG frozen; decompositions are logged
  events, not silent edits.
- A rejected submission reverts the workspace file — the tree never holds unverified work.
- `NPCC.lean` root is regenerated from the NPCC/ directory on every state/submit.
- Kill criteria K1–K5 are computed from `status` output + loop-log.md; if the readout
  flatters, the readout is wrong.
