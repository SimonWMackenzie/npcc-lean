# Reuse verification status (npc-cc workspace)

Declaration inventory (295 decls / 34 files, per-file table): see
[reference-lean/REUSE-INVENTORY.md](reference-lean/REUSE-INVENTORY.md).

## Re-verification status (2026-07-06)

Workspace `C:\lean\npc-cc` (git-mirrored to `formalization/lean-mirror.git`), pinned to
**Lean 4.30.0 + mathlib v4.30.0 release**.

CAUGHT during verification: the published artifact's root module `Workspace.lean` imports
ONLY `Workspace.Basic` (23 bytes), so the first "successful" `lake build Workspace`
compiled just the sanity file — a false verification, exposed when `#print axioms` failed
to find the main theorems. Root module regenerated to import all 33 modules; the full
rebuild + `#print axioms` on the four main theorems is the actual verdict:

**VERDICT (2026-07-06): VERIFIED.** Full tree (all 33 modules) builds clean under
Lean 4.30.0 + mathlib v4.30.0 — `Build completed successfully (8,509 jobs)`, zero compile
errors (remaining log noise = style-linter `info` lines). `#print axioms` on the four main
theorems (namespace `Workspace.MainTheorem`: `refutation_of_direct_sum_conjecture`,
`multiplicative_consequence`, `complexity_invariant_to_transposition`,
`subgames_are_easier`) → exactly `[propext, Classical.choice, Quot.sound]` each.
The imported-toolkit layer for the NP-hardness formalization is certified reusable under
our pin, independently of the authors' original toolchain. Logs: `build-workspace.log`,
`axiom-report.log` in the workspace (mirrored).
