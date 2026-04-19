#!/usr/bin/env bash
# Cut a new release of tachyons-neo.
#
# Usage: scripts/release.sh [patch|minor|major]
#        scripts/release.sh vX.Y.Z   # pin an exact version
#
# Bumps the version in tachyons.css, commits, tags, pushes, and creates a
# GitHub release with auto-generated notes.

set -euo pipefail

arg="${1:-patch}"

cd "$(git rev-parse --show-toplevel)"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: working tree not clean — commit or stash first" >&2
  exit 1
fi

branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$branch" != "main" ]]; then
  echo "error: releases must be cut from main (currently on $branch)" >&2
  exit 1
fi

git fetch --tags origin

if [[ "$arg" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  new="$arg"
else
  case "$arg" in
    patch|minor|major) ;;
    *) echo "usage: $0 [patch|minor|major|vX.Y.Z]" >&2; exit 1 ;;
  esac

  latest="$(git tag -l 'v*' --sort=-v:refname | head -n1)"
  latest="${latest:-v0.0.0}"
  IFS='.' read -r major minor patch <<< "${latest#v}"

  case "$arg" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
  esac

  new="v${major}.${minor}.${patch}"
fi

if git rev-parse --verify --quiet "refs/tags/${new}" >/dev/null; then
  echo "error: tag ${new} already exists" >&2
  exit 1
fi

echo "→ releasing ${new}"

# Update the version banner on line 1 of tachyons.css
sed -i.bak -E "1 s|TACHYONS NEO v[0-9]+\.[0-9]+\.[0-9]+|TACHYONS NEO ${new}|" tachyons.css
rm tachyons.css.bak

if git diff --quiet tachyons.css; then
  echo "note: tachyons.css already at ${new}, skipping commit"
else
  git add tachyons.css
  git commit -m "Release ${new}"
  git push origin main
fi

git tag -a "${new}" -m "Release ${new}"
git push origin "${new}"

gh release create "${new}" --title "${new}" --generate-notes

echo "✓ released ${new}"
