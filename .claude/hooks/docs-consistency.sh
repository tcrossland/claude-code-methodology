#!/usr/bin/env bash
# docs-consistency.sh — PostToolUse hook (matcher: Edit|Write|MultiEdit).
#
# Catches, at edit time, three defect classes the code-reviewer keeps finding by
# hand in the product docs:
#   A) dangling cross-references — a §N or "Appendix X" that points at no real
#      heading (sections validated against methodology.md, appendices against
#      docs/appendices/*.md);
#   B) US spellings — the house style is British (-ise); a curated, exact-word
#      list flags the unambiguous American forms; and
#   C) broken intra-repo links — a [text](path) whose target file does not exist,
#      resolved relative to the edited file (fenced code blocks are skipped).
#
# The edited file arrives as .tool_input.file_path in the JSON on stdin (the
# field is identical for Edit, Write and MultiEdit). PostToolUse runs after the
# edit, so it cannot block; exit 2 surfaces findings to Claude as actionable
# feedback. Exit 0 when the file is clean or out of scope.
#
# Scope: docs/**/*.md (except docs/local/ and docs/plans/), README.md,
# CHANGELOG.md, templates/*.md. Out: .claude/** (quoted config and tool names
# trip the spelling list), docs/plans/ (plans and meta-docs legitimately discuss
# references that don't resolve yet), LICENSE/NOTICE (intentionally American),
# non-Markdown.
#
# Known limitations: (1) runs per-file — a single batch that adds "## 11." to
# methodology.md *and* a §11 reference elsewhere may flag the reference until
# methodology.md's own edit lands; a re-edit clears it. (2) Check A matches the
# singular "Appendix X"; plural "Appendices A & C" forms are skipped (safe
# under-flagging, not a block). (3) Check C resolves only inline [text](path)
# links to relative paths; reference-style links, absolute "/..." paths, scheme
# links (anything with a colon), and links inside fenced code blocks are not checked.
#
# POSIX sh only (no process substitution, no arrays), so a lost exec bit that
# routes this through /bin/sh still parses and runs rather than failing closed.

set -u

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

# jq parses the hook payload; without it the hook is a no-op rather than a block.
command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -n "$FILE" ] || exit 0
[ -f "$FILE" ] || exit 0

# Path relative to repo root, for scope matching.
case "$FILE" in
  "$ROOT"/*) REL="${FILE#"$ROOT"/}" ;;
  /*)        exit 0 ;;            # absolute path outside the repo — ignore
  *)         REL="$FILE" ;;
esac

# --- Scope gate (case globs match across '/', so docs/* spans subdirectories) ---
case "$REL" in
  *.md) ;;                       # Markdown only
  *)    exit 0 ;;
esac
case "$REL" in
  docs/local/*) exit 0 ;;        # private working notes — never checked
  docs/plans/*) exit 0 ;;        # plans/meta-docs legitimately discuss refs that don't resolve yet
esac
case "$REL" in
  docs/*|README.md|CHANGELOG.md|templates/*) ;;
  *) exit 0 ;;
esac

findings=""

# --- Check A: §N / Appendix-X cross-references resolve to real headings ---
# Sections are defined in methodology.md; appendices live in docs/appendices/*.md.
# Each source is optional: if it can't be read, that half of the check is skipped
# (fail-open) rather than flagging every reference.
METH="$ROOT/docs/methodology.md"
APPENDIX_DIR="$ROOT/docs/appendices"

valid_sections=""
[ -r "$METH" ] && valid_sections=$(grep -oE '^## [0-9]+\.' "$METH" | grep -oE '[0-9]+' | sort -un)

valid_appendices=""
[ -d "$APPENDIX_DIR" ] && valid_appendices=$(grep -hoE '^## Appendix [A-Z]' "$APPENDIX_DIR"/*.md 2>/dev/null | grep -oE '[A-Z]$' | sort -u)

if [ -n "$valid_sections" ]; then
  for n in $(grep -oE '§[0-9]+' "$FILE" | grep -oE '[0-9]+' | sort -un); do
    if ! printf '%s\n' $valid_sections | grep -qx "$n"; then
      lines=$(grep -nE "§${n}([^0-9]|$)" "$FILE" | cut -d: -f1 | paste -sd ',' -)
      findings="${findings}  dangling reference §${n} — no such section (line ${lines})\n"
    fi
  done
fi

if [ -n "$valid_appendices" ]; then
  for L in $(grep -oE 'Appendix [A-Z]' "$FILE" | grep -oE '[A-Z]$' | sort -u); do
    if ! printf '%s\n' $valid_appendices | grep -qx "$L"; then
      lines=$(grep -nE "Appendix ${L}([^A-Z]|$)" "$FILE" | cut -d: -f1 | paste -sd ',' -)
      findings="${findings}  dangling reference Appendix ${L} — no such appendix (line ${lines})\n"
    fi
  done
fi

# --- Check B: US spellings (curated, unambiguous; exact-word match) ---
US='color|colors|behavior|behaviors|behavioral|center|centers|centered|organize|organizes|organized|organizing|organization|organizations|recognize|recognizes|recognized|recognizing|prioritize|prioritizes|prioritized|prioritization|summarize|summarizes|summarized|optimize|optimizes|optimized|optimization|standardize|standardized|specialize|specialized|normalize|normalized|analyze|analyzes|analyzed|customize|customized|customization|catalog|catalogs|favor|favors|honor|honors|labor|neighbor|neighbors|fulfill|fulfills|fulfillment|gray|artifact|artifacts|modeling|traveled|traveling|canceled|defense|offense'
us_hits=$(grep -noiE "\b(${US})\b" "$FILE" 2>/dev/null || true)
while IFS= read -r hit; do
  [ -n "$hit" ] || continue
  ln="${hit%%:*}"
  word="${hit#*:}"
  findings="${findings}  US spelling '${word}' — use British English (line ${ln})\n"
done <<EOF
$us_hits
EOF

# --- Check C: intra-repo markdown links resolve to existing files ---
# Inline [text](path) / ![alt](path) whose target is a relative path must point at a
# file or directory that exists, resolved against the edited file's directory. Fenced
# code blocks are blanked first (line numbers preserved) so example links inside them
# aren't flagged — this is what lets the docs narrate dangling-link samples safely.
DIR=$(dirname "$FILE")
stripped=$(awk '/^[[:space:]]*```/ { f = !f; print ""; next } { if (f) print ""; else print }' "$FILE")
c_hits=$(printf '%s\n' "$stripped" | grep -noE '\]\([^)]*\)' 2>/dev/null || true)
while IFS= read -r hit; do
  [ -n "$hit" ] || continue
  ln=${hit%%:*}
  target=${hit#*:}
  target=${target#"]("}          # strip leading ](
  target=${target%")"}           # strip trailing )
  target=${target%% *}           # drop any "title"
  target=${target%%#*}           # drop #fragment
  [ -n "$target" ] || continue
  case "$target" in
    /*|//*) continue ;;          # absolute / protocol-relative — out of scope
    *:*)    continue ;;          # any scheme (http:, mailto:, ...); colons don't occur in repo paths
  esac
  [ -e "$DIR/$target" ] || findings="${findings}  broken link '${target}' — no such file (line ${ln})\n"
done <<EOF
$c_hits
EOF

if [ -n "$findings" ]; then
  {
    echo "docs-consistency: issues in ${REL}:"
    printf '%b' "$findings"
    echo "Fix these, or proceed if a flag is a false positive. § refs must resolve to methodology.md sections, Appendix refs to docs/appendices/ headings, and [text](path) links to existing files; prose is British English."
  } >&2
  exit 2
fi
exit 0
