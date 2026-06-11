# 17 — AI / LLM Security

Use only if the project includes AI features.

## Bug classes to cover

- [ ] User prompts/documents can override system/tool policy
- [ ] Tool allowlist missing per capability, user, tenant, environment
- [ ] Mutating tools without authz and explicit approval when risky
- [ ] LLM output executed as SQL/code/command
- [ ] Structured output not validated at runtime
- [ ] Retrieval not filtered by tenant/user
- [ ] Citations/document IDs allow cross-tenant enumeration
- [ ] PII in prompts/documents/responses logged without redaction
- [ ] No per-user/tenant token/cost budget
- [ ] Document upload bypasses Storage policy / content validation
- [ ] Web search/fetch tools without allowlist and SSRF protection
- [ ] Model/provider keys in client or non-sensitive env
- [ ] Generated code sandbox lacks isolation or contains secrets

## Checklist

- [ ] Prompt injection resistance for system instructions and tool policy
- [ ] Tool allowlist per capability, user, tenant, environment
- [ ] Mutating tools require authz; risky ops need explicit confirmation
- [ ] LLM output never executed as SQL/code/command
- [ ] Structured output validated at runtime
- [ ] Retrieval filtered by tenant/user
- [ ] Citations/document IDs cannot enumerate cross-tenant
- [ ] PII not logged in prompts/responses (or redacted)
- [ ] Token/cost budget per user/tenant
- [ ] Document upload via Storage policy + content validation
- [ ] Web search/fetch with allowlist + SSRF protection
- [ ] Provider keys server-side in sensitive env only
- [ ] Code eval/sandbox isolated without secrets

## Related

- [Prompt](../../prompts/16-ai-llm.md)
- [OWASP Top 10 for LLM](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
