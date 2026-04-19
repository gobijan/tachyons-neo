#!/usr/bin/env bash
# Cut a new release of tachyons-neo.
#
# Usage: scripts/release.sh [patch|minor|major]
#        scripts/release.sh vX.Y.Z   # pin an exact version
#
# Bumps the version in tachyons.css and index.html, summarises the diff since
# the previous tag via `claude -p`, prepends a changelog entry to index.html
# and README.md, commits, tags, pushes, and creates a GitHub release with the
# same bullets as the release body.

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
date_human="$(date +'%Y &mdash; %m &mdash; %d')"

# Diff of real changes since the previous tag, stripping version-banner noise.
diff_text=""
if [[ "$latest" != "v0.0.0" ]]; then
  diff_text="$(git diff "${latest}..HEAD" -- tachyons.css index.html README.md \
    | grep -Ev '^[-+].*TACHYONS NEO v[0-9]+\.[0-9]+\.[0-9]+' \
    | grep -Ev '^[-+].*id="version"[^>]*>v[0-9]+\.[0-9]+\.[0-9]+' \
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
entry_html="$(mktemp -t tn-entry-html.XXXXXX)"
entry_md="$(mktemp -t tn-entry-md.XXXXXX)"

cleanup() {
  local rc=$?
  rm -f "$tmp_bullets" "$entry_html" "$entry_md" 2>/dev/null || true
  if (( rc != 0 )); then
    echo "error: release aborted mid-run; reverting working tree" >&2
    git checkout -- tachyons.css index.html README.md 2>/dev/null || true
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

# Render the HTML entry.
{
  printf '    <article class="bt b--near-black bw1 pv4 pv5-l flex flex-column flex-row-l g3 g0-l">\n'
  printf '      <div class="tnum f3 f1-l fw9 lh-solid w-100 w-20-l">\n'
  printf '        %s\n' "$new"
  printf '        <div class="f6 fw4 ttu tracked mt2 silver"><time datetime="%s">%s</time></div>\n' \
         "$date_iso" "$date_human"
  printf '      </div>\n'
  printf '      <div class="w-100 w-80-l pr4-l">\n'
  printf '        <ul class="list pa0 ma0 lh-copy measure">\n'
  while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    text="${line#- }"
    text="${text//&/&amp;}"
    text="${text//</&lt;}"
    text="${text//>/&gt;}"
    printf '          <li class="mb2">%s</li>\n' "$text"
  done <<< "$bullets"
  printf '        </ul>\n'
  printf '      </div>\n'
  printf '    </article>\n'
} > "$entry_html"

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

# Prepend entries after the <!-- CHANGELOG:INSERT --> marker in each file.
sed -i.bak "/<!-- CHANGELOG:INSERT -->/r ${entry_html}" index.html
rm -f index.html.bak
sed -i.bak "/<!-- CHANGELOG:INSERT -->/r ${entry_md}" README.md
rm -f README.md.bak

# Update the version banner on line 1 of tachyons.css.
sed -i.bak -E "1 s|TACHYONS NEO v[0-9]+\.[0-9]+\.[0-9]+|TACHYONS NEO ${new}|" tachyons.css
rm -f tachyons.css.bak

# Update the version badge in index.html (the <span id="version">…</span>).
sed -i.bak -E "s|(id=\"version\"[^>]*>)v[0-9]+\.[0-9]+\.[0-9]+|\1${new}|" index.html
rm -f index.html.bak

if git diff --quiet tachyons.css index.html README.md; then
  echo "note: no file changes, skipping commit"
else
  git add tachyons.css index.html README.md
  git commit -m "Release ${new}"
  git push origin main
fi

git tag -a "${new}" -m "Release ${new}"
git push origin "${new}"

gh release create "${new}" --title "${new}" --notes "$bullets"

echo "✓ released ${new}"
