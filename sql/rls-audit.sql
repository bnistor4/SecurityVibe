-- SecurityVibe: Supabase/Postgres RLS audit queries
-- Run only on databases you are authorized to access.

-- 1. Tables and RLS status
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname IN ('public', 'storage')
ORDER BY schemaname, tablename;

-- 2. All policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
ORDER BY schemaname, tablename, policyname;

-- 3. Relation owners
SELECT n.nspname AS schema, c.relname AS relation, r.rolname AS owner
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_roles r ON r.oid = c.relowner
WHERE n.nspname IN ('public', 'storage')
  AND c.relkind IN ('r', 'v', 'm')
ORDER BY 1, 2;

-- 4. Tables in public schema WITHOUT RLS enabled (review each)
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND rowsecurity = false
ORDER BY tablename;

-- 5. Policies with permissive USING (true) or WITH CHECK (true) — manual review
SELECT schemaname, tablename, policyname, cmd, qual, with_check
FROM pg_policies
WHERE qual = 'true' OR with_check = 'true'
ORDER BY schemaname, tablename;

-- 6. SECURITY DEFINER functions in public schema
SELECT n.nspname AS schema,
       p.proname AS function_name,
       pg_get_userbyid(p.proowner) AS owner,
       p.prosecdef AS security_definer
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.prosecdef = true
ORDER BY p.proname;

-- 7. Roles with BYPASSRLS
SELECT rolname, rolbypassrls
FROM pg_roles
WHERE rolbypassrls = true;
