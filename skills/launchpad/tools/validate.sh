#!/bin/sh
# Launchpad structural + behavioral test harness.
# Usage: validate.sh [skill|refs|memory|hooks|all]
set -u
HERE="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"   # -> skills/launchpad
GROUP="${1:-all}"
FAILS=0

ok()   { printf 'PASS  %s\n' "$1"; }
bad()  { printf 'FAIL  %s\n' "$1"; FAILS=$((FAILS+1)); }
have() { [ -f "$HERE/$1" ]; }

assert_file()      { if have "$1"; then ok "exists: $1"; else bad "missing: $1"; fi; }
assert_absent()    { if have "$1"; then bad "should be deleted: $1"; else ok "absent: $1"; fi; }
assert_contains()  { # file substring label
  if have "$1" && grep -qF -- "$2" "$HERE/$1"; then ok "$3"; else bad "$3"; fi; }
assert_maxlines()  { # file n label
  if have "$1"; then n=$(wc -l < "$HERE/$1"); if [ "$n" -le "$2" ]; then ok "$3 ($n<=$2)"; else bad "$3 ($n>$2)"; fi
  else bad "$3 (missing)"; fi; }

json_ok() { # stdin -> 0 if valid-ish JSON. Tries node/python3, falls back to brace+quote check.
  data="$(cat)"
  if command -v node >/dev/null 2>&1; then printf '%s' "$data" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{JSON.parse(s)})' 2>/dev/null; return $?; fi
  if command -v python3 >/dev/null 2>&1; then printf '%s' "$data" | python3 -c 'import json,sys;json.load(sys.stdin)' 2>/dev/null; return $?; fi
  printf '%s' "$data" | grep -q '{' && printf '%s' "$data" | grep -q '}'
}

check_skill() {
  assert_file SKILL.md
  # description frontmatter <= 1024 chars (extract between 'description:' and next top-level key)
  if have SKILL.md; then
    desc=$(awk '/^description:/{f=1} f{print} /^---/{if(f)exit}' "$HERE/SKILL.md" | wc -c)
    if [ "$desc" -le 1024 ]; then ok "SKILL.md description <=1024 ($desc)"; else bad "SKILL.md description >1024 ($desc)"; fi
  fi
  assert_maxlines SKILL.md 500 "SKILL.md <=500 lines"
  # every references/*.md named in SKILL.md must exist
  if have SKILL.md; then
    for r in $(grep -oE 'references/[a-z-]+\.md' "$HERE/SKILL.md" | sort -u); do
      if [ -f "$HERE/$r" ]; then ok "linked ref exists: $r"; else bad "linked ref missing: $r"; fi
    done
  fi
}

check_refs() {
  for f in provisioning memory delegation orchestration self-learning org-structures council feasibility-council; do
    assert_file "references/$f.md"
  done
  assert_contains references/provisioning.md "Starter" "provisioning.md has tier table (Starter)"
  assert_contains references/provisioning.md "Pro" "provisioning.md has tier table (Pro)"
  assert_contains references/provisioning.md "upgrade" "provisioning.md documents re-provisioning"
  assert_contains references/provisioning.md "settings.starter.json" "provisioning.md maps tier deploys"
  assert_contains references/delegation.md "Explore" "delegation.md covers Explore/Plan inheritance"
  assert_contains references/delegation.md "Return-learnings" "delegation.md has the 7-point contract"
  assert_contains references/orchestration.md "Solo" "orchestration.md has 4-tier ladder (Solo)"
  assert_contains references/orchestration.md "org-structures.md" "orchestration.md points to appendix"
  assert_contains references/org-structures.md "appendix" "org-structures.md marked as appendix"
  assert_contains references/memory.md "metadata" "memory.md documents fact frontmatter"
  assert_contains references/memory.md "additionalContext" "memory.md documents the load hook"
  # guard: no reference file should name the deleted stores
  if grep -lqE 'ERRORS\.md|LEARNINGS\.md' "$HERE"/references/*.md 2>/dev/null; then
    bad "references name deleted stores (ERRORS/LEARNINGS)"
  else
    ok "no refs to deleted stores"
  fi
}

check_memory() {
  assert_file templates/MEMORY.md
  for s in "## Decisions" "## Learnings" "## Errors" "## References"; do
    assert_contains templates/MEMORY.md "$s" "MEMORY.md has section: $s"
  done
  assert_file templates/memory-fact.md
  for k in "name:" "description:" "metadata:" "type:"; do
    assert_contains templates/memory-fact.md "$k" "memory-fact.md frontmatter has: $k"
  done
  assert_contains templates/CLAUDE.md "LAUNCHPAD-MEMORY-POINTER" "CLAUDE.md has subagent memory-pointer block"
  assert_absent templates/ERRORS.md
  assert_absent templates/LEARNINGS.md
}

check_hooks() {
  assert_file templates/hooks/load-memory
  assert_file templates/hooks/harvest-nudge
  assert_file templates/settings.starter.json
  assert_file templates/settings.standard.json
  if have templates/settings.starter.json; then
    if json_ok < "$HERE/templates/settings.starter.json"; then ok "settings.starter.json valid JSON"; else bad "settings.starter.json invalid JSON"; fi
  fi
  if have templates/settings.standard.json; then
    if json_ok < "$HERE/templates/settings.standard.json"; then ok "settings.standard.json valid JSON"; else bad "settings.standard.json invalid JSON"; fi
    assert_contains templates/settings.standard.json "harvest-nudge" "standard settings registers harvest-nudge"
  fi
  # behavioral: load-memory emits additionalContext for a fixture MEMORY.md
  if have templates/hooks/load-memory; then
    tmp="$(mktemp -d)"; printf '# MEMORY\n- decision: use sqlite\n' > "$tmp/MEMORY.md"
    out="$(CLAUDE_PROJECT_DIR="$tmp" sh "$HERE/templates/hooks/load-memory" </dev/null 2>/dev/null)"
    if printf '%s' "$out" | grep -q 'additionalContext' && printf '%s' "$out" | json_ok; then ok "load-memory emits valid additionalContext JSON"; else bad "load-memory output wrong: $out"; fi
    rm -rf "$tmp"
  fi
  # behavioral: harvest-nudge blocks once, then silent
  if have templates/hooks/harvest-nudge; then
    tmp="$(mktemp -d)"
    o1="$(CLAUDE_PROJECT_DIR="$tmp" sh "$HERE/templates/hooks/harvest-nudge" </dev/null 2>/dev/null)"
    o2="$(CLAUDE_PROJECT_DIR="$tmp" sh "$HERE/templates/hooks/harvest-nudge" </dev/null 2>/dev/null)"
    if printf '%s' "$o1" | grep -q '"decision"[[:space:]]*:[[:space:]]*"block"'; then ok "harvest-nudge blocks on first run"; else bad "harvest-nudge first run not blocking: $o1"; fi
    if [ -z "$(printf '%s' "$o2" | tr -d '[:space:]')" ]; then ok "harvest-nudge silent on second run"; else bad "harvest-nudge second run not silent: $o2"; fi
    rm -rf "$tmp"
  fi
}

check_recommended() {
  assert_file templates/recommended-skills.md
  assert_contains templates/recommended-skills.md "obra/superpowers-marketplace" "manifest names Superpowers source"
  assert_contains templates/recommended-skills.md "captkernel/Skills_Curator" "manifest names Skills Curator source"
  assert_contains templates/recommended-skills.md "vercel-labs/agent-browser" "manifest names Agent Browser source"
  assert_contains templates/recommended-skills.md "install.sh" "manifest has POSIX install path"
  assert_contains templates/recommended-skills.md "install.ps1" "manifest has Windows install path"
  assert_contains templates/recommended-skills.md "npm install -g agent-browser" "manifest has agent-browser npm install"
  assert_contains templates/recommended-skills.md "agent-browser install" "manifest has agent-browser Chrome-download step"
  assert_contains templates/recommended-skills.md "claude plugin marketplace add" "manifest has plugin marketplace install"
  assert_contains references/provisioning.md "recommended-skills" "provisioning links the manifest"
  assert_contains references/provisioning.md "customise" "provisioning documents the customise option"
  assert_contains references/provisioning.md "skip" "provisioning documents the skip option"
  assert_contains references/provisioning.md "restart" "provisioning documents restart-to-activate"
  assert_contains SKILL.md "recommended-skills" "SKILL.md points to recommended skills"
}

case "$GROUP" in
  skill)  check_skill ;;
  refs)   check_refs ;;
  memory) check_memory ;;
  hooks)  check_hooks ;;
  recommended) check_recommended ;;
  all)    check_skill; check_refs; check_memory; check_hooks; check_recommended ;;
  *) echo "unknown group: $GROUP"; exit 2 ;;
esac

echo "----"
if [ "$FAILS" -eq 0 ]; then echo "ALL PASS ($GROUP)"; exit 0; else echo "$FAILS FAILED ($GROUP)"; exit 1; fi
