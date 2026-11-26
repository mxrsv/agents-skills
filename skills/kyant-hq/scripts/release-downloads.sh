#!/usr/bin/env bash
# Print today's public numbers for a product hosted on GitHub Releases, as one JSON line:
# total downloads of every asset under releases whose tag starts with <tag-prefix>,
# the newest such release, and the repo's stars. The total is cumulative; the weekly
# figure is this total minus the last snapshot recorded in the product's HQ note.
# Usage: release-downloads.sh <owner/repo> [tag-prefix]
set -euo pipefail

readonly DEFAULT_TAG_PREFIX="app-v"
readonly PAGE_SIZE=100

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: release-downloads.sh <owner/repo> [tag-prefix]" >&2
  exit 2
fi

repo="$1"
tag_prefix="${2:-$DEFAULT_TAG_PREFIX}"

stars="$(gh api "repos/${repo}" --jq '.stargazers_count')"

gh api --paginate "repos/${repo}/releases?per_page=${PAGE_SIZE}" |
  jq -c -s --arg prefix "$tag_prefix" --arg repo "$repo" --argjson stars "$stars" '
    [.[][] | select(.tag_name | startswith($prefix))
      | {tag: .tag_name, published: .published_at[0:10], downloads: ([.assets[].download_count] | add // 0)}]
    | sort_by(.published)
    | {
        date: (now | strftime("%Y-%m-%d")),
        repo: $repo,
        stars: $stars,
        releases: length,
        total_downloads: (map(.downloads) | add // 0),
        latest: (last // null)
      }
  '
