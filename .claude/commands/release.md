---
description: Draft CHANGELOG Unreleased entries from the completed plan and commits.
---

Prepare a changelog update — draft only, do not edit files until I approve.

1. Read the active plan and the commits since the last release tag.
2. Summarise the changes a reader of this methodology would notice, one concise line each.
   The docs are the product, so treat changed guidance, new appendices, re-numberings, and
   template changes as user-facing.
3. Sort them into Keep a Changelog categories: Added, Changed, Deprecated, Removed, Fixed,
   Security. Omit empty categories.
4. Propose these under `## [Unreleased]` in `CHANGELOG.md`. Use `DD/MM/YYYY` for any date.
5. If a version was given ($1), also propose renaming Unreleased to
   `## [$1] — <today's date>`.

Exclude genuinely internal churn (typo sweeps, formatting) unless it changes the guidance.
I will curate before anything is committed.
