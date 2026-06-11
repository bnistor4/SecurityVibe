# 05 — Supabase Storage & Upload

## Bug classes to cover

- [ ] Private bucket made public for convenience
- [ ] Overly permissive `storage.objects` policies
- [ ] `SELECT` allowing full bucket listing
- [ ] `upsert` without correct `SELECT`/`UPDATE` and owner control
- [ ] Path/folder derived from user input without normalization
- [ ] Upload to another user/tenant folder
- [ ] Signed URL TTL too long
- [ ] Reusable signed upload URL not bound to context
- [ ] MIME type validated only on client
- [ ] Valid extension but dangerous content
- [ ] SVG/HTML served inline
- [ ] EXIF/metadata PII not stripped where required
- [ ] Oversized files, too many parts, parallel upload abuse
- [ ] Zip/archive without decompression limits
- [ ] Orphan files after record delete
- [ ] CDN/cache serving files after auth revocation
- [ ] `service_role` serving user downloads
- [ ] Public URLs stored in DB for files that should be private

## Detection

```bash
rg -n 'storage\.from|upload\(|download\(|createSignedUrl|createSignedUrls|createSignedUploadUrl|upsert|remove\(' app src lib
rg -n 'bucket|storage\.objects|foldername|owner_id|create policy' supabase migrations db sql
rg -n 'mime|content-type|file\.type|file\.size|FileReader|FormData|accept=' app src components
```

## Mitigations

- Private buckets for all non-public data
- Storage policies per bucket, folder, owner/tenant
- Short signed URL TTL aligned with data sensitivity
- Server-mediated download when extra audit/authz needed
- Server-side validation: size, MIME, magic bytes, content policy
- SVG: block or sanitize; if served use `Content-Disposition: attachment` + CSP
- Per-user/tenant upload quota, rate limits, orphan cleanup
- Randomized filenames; never trust original names
- Separate public avatars from private documents

## Regression tests

- [ ] User A cannot upload/download/list User B paths
- [ ] User A cannot `upsert` User B files
- [ ] Expired signed URL fails
- [ ] Allowed extension with wrong content blocked
- [ ] Record deletion removes or blocks linked file

## Related

- [Prompt](../../prompts/04-storage-upload.md)
- [Supabase Storage Access Control](https://supabase.com/docs/guides/storage/security/access-control)
