# 06 — Server Actions

## Bug classes to cover

- [ ] Mutating action without auth
- [ ] Auth present but no per-object authorization
- [ ] Arbitrary object or unvalidated `FormData` input
- [ ] Mass assignment: `role`, `price`, `status`, `owner_id`, `tenant_id`, `is_admin`
- [ ] Return value includes full DB record or unnecessary PII
- [ ] Action imported by Client Component with secrets in closure
- [ ] Over-broad revalidation (`revalidatePath('/')`) after user input
- [ ] Redirect/open redirect from user input
- [ ] Server-side fetch to user-supplied URL
- [ ] Long operation without timeout, idempotency, or queue
- [ ] Missing rate limit on email, export, upload init, invite, AI generation
- [ ] Raw errors returned to client
- [ ] Action auto-invoked from `useEffect` without guardrails
- [ ] Side effects in render instead of action
- [ ] `allowedOrigins` too broad for reverse proxy

## Detection

```bash
rg -n '"use server"|useActionState|formAction|revalidatePath|revalidateTag|redirect\(|cookies\(|headers\(' app src
rg -n 'safeParse|parse\(|z\.object|request\.json|FormData|Object\.fromEntries' app src
rg -n 'insert\(|update\(|upsert\(|delete\(|rpc\(|fetch\(' app src
```

## Minimum standard per mutating action

1. `requireUser()` or equivalent guard
2. Runtime input validation (zod, valibot, internal schema)
3. Field whitelist
4. Per-resource authz: owner/tenant/role/state
5. Mutation in server-only DAL or secure RPC
6. Minimal output
7. Targeted revalidation
8. Rate limit / idempotency if abusable
9. Non-verbose error mapping
10. Negative test

## Example finding

```markdown
### Finding: Server Action allows role mass assignment
- Severity: High
- Area: Server Actions / Authorization
- File and lines: app/.../actions.ts:...
- Evidence: action passes full/partial validated object to `update(...)` including client-controlled fields
- Impact: user may elevate privileges or change owner/status
- Fix: pick/whitelist editable fields; server-side role check; DB constraints
- Test: normal user sends `role`/`is_admin`; record unchanged and action fails
```

## Related

- [Prompt](../../prompts/05-server-actions.md)
