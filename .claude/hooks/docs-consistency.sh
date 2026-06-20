#!/usr/bin/env bash
# docs-consistency.sh — PostToolUse hook (matcher: Edit|Write|MultiEdit).
#
# Catches, at edit time, two defect classes the code-reviewer keeps finding by
# hand in the product docs:
#   A) dangling cross-references — a §N or "Appendix X" that points at no real
#      heading, validated against docs/methodology.md's actual headings; and
#   B) US spellings — the house style is British (-ise); a curated, exact-word
#      list flags the unambiguous American forms.
#
# The edited file arrives as .tool_input.file_path in the JSON on stdin (the
# field is identical for Edit, Write and MultiEdit). PostToolUse runs after the
# edit, so it cannot block; exit 2 surfaces findings to Claude as actionable
# feedback. Exit 0 when the file is clean or out of scope.
#
# Scope: docs/**/*.md (except docs/local/), README.md, CHANGELOG.md,
# templates/*.md. Out: .claude/** (quoted config and tool names trip the
# spelling list), LICENSE/NOTICE (intentionally American), non-Markdown.
#
# Known limitations: (1) runs per-file — a single batch that adds "## 11." to
# methodology.md *and* a §11 reference elsewhere may flag the reference until
# methodology.md's own edit lands; a re-edit clears it. (2) Check A matches the
# singular "Appendix X"; plural "Appendices A & C" forms are skipped (safe
# under-flagging, not a block).
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
esac
case "$REL" in
  docs/*|README.md|CHANGELOG.md|templates/*) ;;
  *) exit 0 ;;
esac

findings=""

# --- Check A: §N / Appendix-X cross-references resolve to real headings ---
METH="$ROOT/docs/methodology.md"
if [ -r "$METH" ]; then
  valid_sections=$(grep -oE '^## [0-9]+\.' "$METH" | grep -oE '[0-9]+' | sort -un)
  valid_appendices=$(grep -oE '^## Appendix [A-Z]' "$METH" | grep -oE '[A-Z]$' | sort -u)

  for n in $(grep -oE '§[0-9]+' "$FILE" | grep -oE '[0-9]+' | sort -un); do
    if ! printf '%s\n' $valid_sections | grep -qx "$n"; then
      lines=$(grep -nE "§${n}([^0-9]|$)" "$FILE" | cut -d: -f1 | paste -sd ',' -)
      findings="${findings}  dangling reference §${n} — no such section (line ${lines})\n"
    fi
  done

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

if [ -n "$findings" ]; then
  {
    echo "docs-consistency: issues in ${REL}:"
    printf '%b' "$findings"
    echo "Fix these, or proceed if a flag is a false positive. §/appendix refs must resolve to docs/methodology.md headings; prose is British English."
  } >&2
  exit 2
fi
exit 0
