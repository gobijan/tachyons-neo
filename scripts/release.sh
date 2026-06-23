#!/usr/bin/env bash
# Cut a new release of tachyons-neo.
#
# Usage: scripts/release.sh [patch|minor|major]
#        scripts/release.sh vX.Y.Z   # pin an exact version
#
# Bumps the version in tachyons.css and _config.yml, summarises the diff since
# the previous tag via `claude -p`, prepends changelog entries to
# _data/releases.yml and README.md, commits, tags, pushes, and creates a GitHub
# release with the same bullets as the release body.

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

latest="$(git tag -l 'v*' --sort=-v:refname | head -n1)"
latest="${latest:-v0.0.0}"
version_pattern='v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?'

if [[ "$arg" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  new="$arg"
else
  case "$arg" in
    patch|minor|major) ;;
    *) echo "usage: $0 [patch|minor|major|vX.Y.Z]" >&2; exit 1 ;;
  esac

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

date_iso="$(date +%Y-%m-%d)"

# Diff of real changes since the previous tag, stripping version-banner noise.
diff_text=""
if [[ "$latest" != "v0.0.0" ]]; then
  diff_text="$(git diff "${latest}..HEAD" -- tachyons.css app.css index.html README.md _config.yml _data docs \
    | grep -Ev "^[-+].*TACHYONS NEO ${version_pattern}" \
    | grep -Ev "^[-+]version: \"[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?\"" \
    || true)"
fi

echo "→ about to release ${new} (previous: ${latest})"
if [[ "$latest" != "v0.0.0" ]]; then
  echo "commits since ${latest}:"
  git log --oneline "${latest}..HEAD" || true
fi
read -r -p "proceed? [y/N] " reply
case "$reply" in
  y|Y|yes|YES) ;;
  *) echo "aborted" >&2; exit 1 ;;
esac

# Ask the LLM for a short editorial summary of the diff.
bullets=""
if [[ -n "$diff_text" ]]; then
  echo "→ asking claude for a changelog summary…"
  prompt='Summarize these changes as 1-3 terse bullets for an editorial changelog.
Output only the bullets, one per line, starting with "- ".
Be specific (name the utility, token, or section that changed).
Avoid marketing language. No headings, no preamble.'

  raw="$(printf '%s\n\n---\n\n%s\n' "$prompt" "$diff_text" \
    | claude -p 2>/dev/null || true)"

  bullets="$(printf '%s\n' "$raw" \
    | grep -E '^[-*] ' \
    | sed -E 's/^\* /- /' \
    | head -n 5 \
    || true)"
fi

if [[ -z "${bullets// }" ]]; then
  echo "warning: no LLM bullets; falling back to commit subjects" >&2
  if [[ "$latest" != "v0.0.0" ]]; then
    bullets="$(git log --pretty='- %s' "${latest}..HEAD" \
      | grep -viE '^- Release v[0-9]' \
      | head -n 5 \
      || true)"
  fi
fi

if [[ -z "${bullets// }" ]]; then
  echo "error: no changelog bullets (empty diff and empty log) — aborting" >&2
  exit 1
fi

tmp_bullets="$(mktemp -t tn-changelog.XXXXXX)"
entry_yml="$(mktemp -t tn-entry-yml.XXXXXX)"
entry_md="$(mktemp -t tn-entry-md.XXXXXX)"
tmp_releases=""

cleanup() {
  local rc=$?
  rm -f "$tmp_bullets" "$entry_yml" "$entry_md" "$tmp_releases" 2>/dev/null || true
  if (( rc != 0 )); then
    echo "error: release aborted mid-run; reverting working tree" >&2
    git checkout -- tachyons.css _config.yml _data/releases.yml README.md 2>/dev/null || true
  fi
}
trap cleanup EXIT

# Let the user review / edit the bullets.
printf '%s\n' "$bullets" > "$tmp_bullets"
"${EDITOR:-vi}" "$tmp_bullets"
bullets="$(cat "$tmp_bullets")"
if [[ -z "${bullets// }" ]]; then
  echo "error: changelog bullets empty after edit — aborting" >&2
  exit 1
fi

# Render the site data entry.
{
  printf -- '- version: "%s"\n' "$new"
  printf '  date: "%s"\n' "$date_iso"
  printf '  notes:\n'
  while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    text="${line#- }"
    printf '    - >-\n'
    printf '      %s\n' "$text"
  done <<< "$bullets"
} > "$entry_yml"

# Render the Markdown entry.
{
  printf '### %s — %s\n\n' "$new" "$date_iso"
  while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    [[ "$line" =~ ^-\  ]] || line="- $line"
    printf '%s\n' "$line"
  done <<< "$bullets"
  printf '\n'
} > "$entry_md"

# Prepend entries to the site data and README changelog.
tmp_releases="$(mktemp -t tn-releases.XXXXXX)"
cat "$entry_yml" _data/releases.yml > "$tmp_releases"
mv "$tmp_releases" _data/releases.yml
sed -i.bak "/<!-- CHANGELOG:INSERT -->/r ${entry_md}" README.md
rm -f README.md.bak

# Update the version banner on line 1 of tachyons.css.
sed -i.bak -E "1 s|TACHYONS NEO ${version_pattern}|TACHYONS NEO ${new}|" tachyons.css
rm -f tachyons.css.bak

# Update the site version used by Jekyll templates.
new_without_v="${new#v}"
semver_pattern='[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?'
sed -i.bak -E "s|^version: \"${semver_pattern}\"|version: \"${new_without_v}\"|" _config.yml
rm -f _config.yml.bak

# Update the pinned CDN examples in README.md. Leaves floating-major and
# unpinned forms alone - only the semver @vX.Y.Z pins.
sed -i.bak -E \
  -e "s|tachyons-neo@${version_pattern}/tachyons\.css|tachyons-neo@${new}/tachyons.css|g" \
  -e "s|tachyons-neo@${version_pattern}/app\.css|tachyons-neo@${new}/app.css|g" \
  README.md
rm -f README.md.bak

if git diff --quiet tachyons.css _config.yml _data/releases.yml README.md; then
  echo "note: no file changes, skipping commit"
else
  git add tachyons.css _config.yml _data/releases.yml README.md
  git commit -m "Release ${new}"
  git push origin main
fi

git tag -a "${new}" -m "Release ${new}"
git push origin "${new}"

gh release create "${new}" --title "${new}" --notes "$bullets"

echo "✓ released ${new}"
