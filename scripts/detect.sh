#!/usr/bin/env bash
# SecurityVibe — run category-specific detection for a single area
# Usage: ./scripts/detect.sh auth /path/to/project

set -euo pipefail

CATEGORY="${1:-}"
TARGET="${2:-.}"

if [[ -z "$CATEGORY" ]]; then
  echo "Usage: $0 <category> [project-path]"
  echo "Categories: auth, rls, storage, actions, api, rsc, middleware, cache, vercel, xss, ssrf, dos, supply"
  exit 1
fi

if ! command -v rg &>/dev/null; then
  echo "Error: ripgrep (rg) required"
  exit 1
fi

run() {
  echo "--- $1"
  rg -n --no-heading "$2" "$TARGET" 2>/dev/null || echo "(no matches)"
  echo ""
}

case "$CATEGORY" in
  auth)
    run "Auth patterns" 'getSession\(|getUser\(|getClaims\(|signInWith|signOut|redirectTo|next=|returnTo' app src lib
    ;;
  rls)
    run "RLS migrations" 'enable row level security|create policy|security definer|bypassrls|auth\.uid|WITH CHECK' supabase migrations db sql
    ;;
  storage)
    run "Storage usage" 'storage\.from|createSignedUrl|upload\(|download\(|upsert' app src lib supabase
    ;;
  actions)
    run "Server Actions" '"use server"|revalidatePath|revalidateTag|redirect\(' app src
    ;;
  api)
    run "Route Handlers" 'export async function (GET|POST|PUT|PATCH|DELETE)|request\.json|webhook|cron' app src vercel.json
    ;;
  rsc)
    run "RSC & cache" '"use client"|server-only|unstable_cache|use cache|select\(\*\)' app src
    ;;
  middleware)
    run "Middleware" 'middleware|proxy|matcher|NextResponse\.redirect|rewrite' .
    ;;
  cache)
    run "Cache headers" 'Cache-Control|revalidatePath|remotePatterns|dangerouslyAllowSVG' app src next.config.*
    ;;
  vercel)
    run "Env & runtime" 'NEXT_PUBLIC_|process\.env|runtime|edge|crons' app src vercel.json next.config.*
    ;;
  xss)
    run "XSS" 'dangerouslySetInnerHTML|innerHTML|mdx|DOMPurify|Content-Security-Policy' app src components
    ;;
  ssrf)
    run "SSRF" 'fetch\(|axios|new URL|x-forwarded-host' app src lib
    ;;
  dos)
    run "DoS patterns" 'select\("\*"\)|limit\(|rateLimit|maxDuration|AbortController' app src
    ;;
  supply)
    run "Supply chain" 'postinstall|preinstall|prepare|npmrc|sourceMap|npm audit' package.json .github .
    ;;
  *)
    echo "Unknown category: $CATEGORY"
    exit 1
    ;;
esac
