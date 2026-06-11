#!/usr/bin/env bash
# SecurityVibe — project surface inventory
# Usage: ./scripts/inventory.sh /path/to/target-project

set -euo pipefail

TARGET="${1:-.}"

if ! command -v rg &>/dev/null; then
  echo "Error: ripgrep (rg) is required. Install from https://github.com/BurntSushi/ripgrep"
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Error: directory not found: $TARGET"
  exit 1
fi

section() {
  echo ""
  echo "================================================================================"
  echo " $1"
  echo "================================================================================"
}

run_rg() {
  local title="$1"
  local pattern="$2"
  shift 2
  section "$title"
  rg -n --no-heading "$pattern" "$@" "$TARGET" 2>/dev/null || echo "(no matches)"
}

echo "SecurityVibe Inventory"
echo "Target: $TARGET"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

run_rg "Server Actions & Route Handlers" '"use server"|export async function (GET|POST|PUT|PATCH|DELETE)|NextResponse|NextRequest' app src
run_rg "Middleware / Proxy / Routing" 'middleware|proxy|matcher|redirect\(|rewrite\(' .
run_rg "Supabase clients & auth" 'createClient|createServerClient|createBrowserClient|getSession|getUser|getClaims|auth\.uid|auth\.jwt' .
run_rg "Secrets & service role" 'service_role|sb_secret|SUPABASE_SERVICE|NEXT_PUBLIC_.*(SECRET|TOKEN|KEY|PASSWORD)' .
run_rg "XSS / HTML injection" 'dangerouslySetInnerHTML|innerHTML|outerHTML|DOMPurify|sanitize|mdx|markdown' app src components
run_rg "Outbound requests & input" 'fetch\(|axios|new URL|URLSearchParams|request\.json\(|formData\(' app src
run_rg "Cache & cookies" 'revalidatePath|revalidateTag|unstable_cache|cacheTag|use cache|cookies\(|headers\(' app src
run_rg "Storage" 'storage\.from|createSignedUrl|upload\(|download\(|remove\(' app src supabase
run_rg "Realtime" 'channel\(|subscribe\(|removeChannel|presence|broadcast|realtime' app src
run_rg "Webhooks & cron" 'webhook|signature|svix|stripe|resend|cron|schedule' app src vercel.json
run_rg "Image optimizer config" 'dangerouslyAllowSVG|remotePatterns|domains:|maximumRedirects|maximumResponseBody|maximumDiskCacheSize' next.config.* .
run_rg "Edge runtime" 'runtime = .edge.|runtime: .edge.|edge' app src next.config.* vercel.json
run_rg "Env usage" 'NEXT_PUBLIC_|process\.env|VERCEL_|SUPABASE_' app src lib next.config.* vercel.json .env.example
run_rg "SQL / RLS migrations" 'enable row level security|create policy|security definer|bypassrls' supabase migrations db sql

section "Done"
echo "Classify matches using docs/categories/02-project-inventory.md"
