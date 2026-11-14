# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## How releases are published

1. Add a section `## [X.Y.Z] - YYYY-MM-DD` below (move items out of `[Unreleased]`).
2. Commit and push to `main`.
3. Tag and push: `git tag vX.Y.Z && git push origin vX.Y.Z`.

The `Release` GitHub Action then creates a GitHub Release whose notes are the
matching section of this file. The workflow fails if the tag has no section.

## [Unreleased]

## [1.0.0] - 2026-11-15

First tagged release. Includes the original toolkit plus a round of bug fixes.

### Added

- Automated LaTeX package installer for the `sharelatex/sharelatex` container (`scripts/install-latex-packages.sh`).
- Full TeX Live updater (`scripts/update-all-packages.sh`).
- Cron setup for scheduled updates (`scripts/setup-weekly-cron.sh`).
- MkDocs Material documentation site, deployed to GitHub Pages.
- `CHANGELOG.md` and a `Release` workflow that publishes GitHub Releases from it.
- `.gitattributes` forcing LF line endings on `*.sh` so scripts keep working when cloned on Windows.

### Changed

- `CRON_EXPR` in `.env` is now honored by `setup-weekly-cron.sh` (default `0 4 * * 1`).
- Scripts now use strict-ish shell options, quoted variables, and exit non-zero on failure.
- Scripts are marked executable in git.
- Package list uses real `tlmgr` package names (`graphics`, `tools`, `algorithms`, `pgf`) instead of LaTeX package names.
- Docs: example paths use `/home/youruser/`; copyright year updated to 2026.
- CI: GitHub Actions bumped to current major versions; `requirements.txt` pinned to compatible ranges.
- Docs site shows page revision dates (`git-revision-date-localized` enabled).

### Fixed

- `setup-weekly-cron.sh` overwrote the user's entire crontab; it now preserves existing entries.
- `load-env.sh` did not expand `$HOME` / `$PROJECT_DIR` and broke on values with spaces; `.env` is now sourced.
- Installer reported failures for names that are not tlmgr packages (`amssymb`, `algorithmic`, `graphicx`, `array`, ...).
- Installer always printed "up to date" even when installs failed; failures are now counted and reported.
- Errors from `tlmgr` were discarded (`>/dev/null 2>&1`); they now reach the log.
- `docker exec -i` removed, since cron provides no stdin.

[Unreleased]: https://github.com/FahimFBA/overleaf-toolkit-essential/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/FahimFBA/overleaf-toolkit-essential/releases/tag/v1.0.0
