# SecurityVibe — project surface inventory (PowerShell)
# Usage: .\scripts\inventory.ps1 -ProjectPath C:\path\to\target-project

param(
    [Parameter(Position = 0)]
    [string]$ProjectPath = "."
)

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host ("=" * 80)
    Write-Host " $Title"
    Write-Host ("=" * 80)
}

function Invoke-Rg {
    param(
        [string]$Title,
        [string]$Pattern,
        [string[]]$Paths = @("app", "src", ".")
    )

    Write-Section $Title

    if (-not (Get-Command rg -ErrorAction SilentlyContinue)) {
        Write-Host "Error: ripgrep (rg) is required."
        exit 1
    }

    $existing = $Paths | Where-Object { Test-Path (Join-Path $ProjectPath $_) }
    if ($existing.Count -eq 0) {
        Write-Host "(no matching paths)"
        return
    }

    $args = @("-n", "--no-heading", $Pattern) + ($existing | ForEach-Object { Join-Path $ProjectPath $_ })
    & rg @args 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "(no matches)"
    }
}

if (-not (Test-Path $ProjectPath)) {
    Write-Error "Directory not found: $ProjectPath"
    exit 1
}

Write-Host "SecurityVibe Inventory"
Write-Host "Target: $ProjectPath"
Write-Host "Date: $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))"

Invoke-Rg "Server Actions & Route Handlers" '"use server"|export async function (GET|POST|PUT|PATCH|DELETE)|NextResponse|NextRequest' @("app", "src")
Invoke-Rg "Middleware / Proxy / Routing" 'middleware|proxy|matcher|redirect\(|rewrite\(' @(".")
Invoke-Rg "Supabase clients & auth" 'createClient|createServerClient|createBrowserClient|getSession|getUser|getClaims|auth\.uid|auth\.jwt' @(".")
Invoke-Rg "Secrets & service role" 'service_role|sb_secret|SUPABASE_SERVICE|NEXT_PUBLIC_.*(SECRET|TOKEN|KEY|PASSWORD)' @(".")
Invoke-Rg "XSS / HTML injection" 'dangerouslySetInnerHTML|innerHTML|outerHTML|DOMPurify|sanitize|mdx|markdown' @("app", "src", "components")
Invoke-Rg "Outbound requests & input" 'fetch\(|axios|new URL|URLSearchParams|request\.json\(|formData\(' @("app", "src")
Invoke-Rg "Cache & cookies" 'revalidatePath|revalidateTag|unstable_cache|cacheTag|use cache|cookies\(|headers\(' @("app", "src")
Invoke-Rg "Storage" 'storage\.from|createSignedUrl|upload\(|download\(|remove\(' @("app", "src", "supabase")
Invoke-Rg "Realtime" 'channel\(|subscribe\(|removeChannel|presence|broadcast|realtime' @("app", "src")
Invoke-Rg "Webhooks & cron" 'webhook|signature|svix|stripe|resend|cron|schedule' @("app", "src", "vercel.json")
Invoke-Rg "Image optimizer config" 'dangerouslyAllowSVG|remotePatterns|domains:|maximumRedirects|maximumResponseBody|maximumDiskCacheSize' @("next.config.js", "next.config.mjs", "next.config.ts", ".")
Invoke-Rg "Edge runtime" 'runtime = .edge.|runtime: .edge.|edge' @("app", "src", "next.config.js", "next.config.mjs", "vercel.json")
Invoke-Rg "Env usage" 'NEXT_PUBLIC_|process\.env|VERCEL_|SUPABASE_' @("app", "src", "lib", "next.config.js", "vercel.json", ".env.example")
Invoke-Rg "SQL / RLS migrations" 'enable row level security|create policy|security definer|bypassrls' @("supabase", "migrations", "db", "sql")

Write-Section "Done"
Write-Host "Classify matches using docs/categories/02-project-inventory.md"
