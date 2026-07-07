#!/usr/bin/env node
// pipeline/reformulate.mjs — ADDITIVE pipeline command (K2 exception, Simon 2026-07-06):
// send a 'stated' obligation back to 'open' with a logged reason; withdraw its claim.
// Usage: node pipeline/reformulate.mjs <id> "<reason>"
// Scope: touches ONLY the ledger + moves the claim file to claims/withdrawn/.
// runner.mjs is deliberately untouched.

import fs from "node:fs";
import path from "node:path";

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1")), "..");
const LEDGER = path.join(ROOT, "obligations.json");
const CLAIMS = path.join(ROOT, "claims");
const WITHDRAWN = path.join(CLAIMS, "withdrawn");
fs.mkdirSync(WITHDRAWN, { recursive: true });

const [, , id, reason] = process.argv;
if (!id || !reason) { console.error("usage: reformulate <id> \"<reason>\""); process.exit(1); }

const L = JSON.parse(fs.readFileSync(LEDGER, "utf8"));
const o = L.obligations.find(x => x.id === id);
if (!o) { console.error("unknown obligation: " + id); process.exit(1); }
if (o.status !== "stated") { console.error(`reformulate: ${id} is '${o.status}', expected 'stated'`); process.exit(1); }

const claimFile = path.join(CLAIMS, id.replace(/[:/]/g, "_") + ".txt");
if (fs.existsSync(claimFile)) {
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  fs.renameSync(claimFile, path.join(WITHDRAWN, id.replace(/[:/]/g, "_") + "." + stamp + ".txt"));
}
o.attempts.push({ ts: new Date().toISOString(), note: "REFORMULATED: " + reason.slice(0, 700) });
o.status = "open";
o.signed_off = false;
o.route = "reformulation requested: " + reason.slice(0, 200);

const tmp = LEDGER + ".tmp";
fs.writeFileSync(tmp, JSON.stringify(L, null, 1) + "\n");
fs.renameSync(tmp, LEDGER);
console.log(`REFORMULATED ${id} -> open (claim withdrawn to claims/withdrawn/)`);
