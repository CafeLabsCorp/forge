# Security & Launch Checklist Reference

A shared list of concrete checks — not general advice, each one a specific
thing to verify — covering security, infrastructure operations, and public
site launch basics. It exists so `security`, `qa`, `devops`, `backend`,
`frontend-web`, and `mobile` pull from one source instead of each carrying
their own partial, drifting copy of the same items.

Source: field checklists on shipping site security/launch practices, plus
gaps found in practice across Café Labs products (Dindin, Domo, Micare) that
those field checklists didn't cover (session expiry, admin MFA, secret
rotation, audit logging, and a few others below).

## How this gets used

Not every item applies to every project — a static landing page doesn't need
a rate-limit check, a project with no admin role doesn't need admin MFA. Each
item below states **applies when** in plain language.

- **Normal flow (new project, full cycle):** the `orchestrator` determines
  which conditions this project actually matches (platform, whether it has a
  backend/DB, auth, payments, personal data, a public site, store
  distribution) during Discovery, and passes the filtered subset explicitly
  to each relevant specialist as part of their scope summary — the same way
  any other delegation context is passed to a cold-start specialist. Don't
  hand a specialist the whole list; that defeats the point of filtering.
- **Triage mode / working solo:** a specialist invoked directly (not through
  a fresh orchestrator delegation) reads this file itself and uses judgment
  on which items apply to the project at hand, the same way it applies any
  other domain-mastery heuristic.

Owners in parentheses are who normally acts on the item, not who's exclusively
allowed to raise it — `security`'s independent pass should still catch
anything another specialist's item was supposed to cover but didn't.

## Authentication & session

- **Auth decided server-side, never trusted from the client** — applies when: the app has user accounts. (`backend`, `security`)
- **API routes protected by authentication, not just the UI** — applies when: the project has its own API. (`backend`, `security`)
- **Passwords hashed with a strong algorithm, never stored plaintext** — applies when: the app stores its own password (not applicable to a managed provider's auth like Firebase Auth/Supabase Auth). (`backend`, `security`)
- **Login attempts rate-limited** — applies when: there's a self-hosted login flow. (`backend`, `security`)
- **Session/token expiry and timeout** — applies when: the app has an authenticated session. (`backend`, `security`)
- **MFA required for admin/internal-panel accounts** — applies when: a privileged admin role exists. (`backend`, `security`)
- **Email verified before sensitive actions unlock** — applies when: signup is email/password based. (`backend`, `security`)
- **CSRF protection** — applies when: the session is cookie-based (not applicable to a Bearer/JWT-in-header API). (`backend`, `security`)
- **Session tokens never in `localStorage`** (prefer an `HttpOnly` cookie) — applies when: a web app holds an authenticated session. (`frontend-web`, `security`)

## Authorization & data access

- **Authorization checked on every read/write, not just authentication** — applies when: data is user-specific. (`backend`, `security`)
- **DB rules (RLS / Firestore or Storage rules) deny-by-default with an explicit allowlist** — applies when: the project uses Supabase RLS or Firestore/Storage rules. (`backend`, `security`)
- **Non-guessable IDs for sensitive resources referenced in a URL** — applies when: a resource with sensitive data is addressed by ID in a URL/route. (`backend`, `frontend-web`)
- **Mass assignment restricted** (a request body can't overwrite fields it shouldn't) — applies when: an endpoint accepts a client-supplied object for create/update. (`backend`)
- **Least-privilege permissions for service accounts/server credentials** — applies when: the project uses any cloud service account. (`backend`, `devops`)

## Secrets & credentials

- **No API key/secret committed to git, including history** — applies when: any key or secret exists at all. (`devops`, `security`)
- **No sensitive key exposed in the frontend bundle** — applies when: a key exists that isn't meant to be public (a service-role/admin key, not an SDK's intentionally-public client key). (`frontend-web`, `security`)
- **Secret/API key rotation in place** — applies when: a key is already live in production. (`devops`, `security`)
- **Dev/prod environment separation** (distinct projects/env vars) — applies when: a real production deploy exists. (`devops`)

## Input validation & injection

- **Parameterized queries** (never concatenating user input into SQL/a command) — applies when: a dynamic query includes user-supplied data. (`backend`, `security`)
- **Input validated on every endpoint** (type, size, shape) — applies when: an endpoint accepts client-supplied data. (`backend`, `security`)
- **Uploads restricted/validated** (file type, size) — applies when: the app accepts file uploads. (`backend`)
- **Webhook signature/origin verified** — applies when: the app receives a webhook from a third party (payments, etc). (`backend`)

## Data exposure & API responses

- **API responses return only the fields the client needs** (no full-object leaks) — applies when: an own API returns objects. (`backend`)
- **No stack trace/detailed error output in production** — applies when: a backend/API runs in production. (`backend`, `devops`)
- **CORS restricted to the expected origin(s)** (never `*` combined with credentials) — applies when: the API is called from a known domain. (`backend`, `devops`)
- **Sensitive data encrypted at rest** — applies when: the app stores sensitive data (financial, health, documents). (`backend`, `security`)

## Transport & headers

- **HTTPS enforced, no HTTP fallback** — applies when: the project has a public domain. (`devops`)
- **Security headers set** (CSP, HSTS, X-Frame-Options, etc.) — applies when: a web app is served over HTTP. (`devops`, `frontend-web`)
- **Cookies use secure flags** (`Secure`, `HttpOnly`, `SameSite`) — applies when: the app uses a session cookie. (`backend`, `frontend-web`)

## Dependencies & release build

- **Dependency vulnerability scan** — applies when: the project has a package manager, i.e. always. (`devops`, `security`)
- **Third-party dependency licenses compatible with the intended use** — applies when: the project is commercial/distributed. (`devops`)
- **Release build obfuscated/minified** — applies when: the app is distributed as a mobile or desktop binary. (`mobile`, `devops`)
- **Certificate pinning** — applies when: a mobile app makes a sensitive (e.g. financial) call and MITM mitigation is worth the added complexity; optional/advanced, not launch-blocking by default. (`mobile`, `security`)

## Operations & visibility (post-launch)

- **Uptime monitor** — applies when: any production service exists. (`devops`)
- **Error tracking** (e.g. Sentry) — applies when: any app runs in production. (`devops`)
- **Automated backup, with a tested restore** — applies when: persistent data exists that can't be lost. (`devops`)
- **Audit log for sensitive actions** (admin actions, deletions, permission changes) — applies when: an irreversible or privileged action exists. (`backend`, `security`)
- **Admin/access credentials stored securely** (a password manager, not a spreadsheet or chat) — applies when: any admin access exists. (`devops`)

## Store & distribution compliance

- **Store Data Safety declaration matches what the app actually collects** — applies when: the app is published to the Play Store/App Store. (`compliance`, `mobile`)
- **Opt-out available for crash reporting/analytics** — applies when: the app collects end-user analytics/crash data. (`compliance`, `analytics`)

These two overlap with `compliance`'s own checklist (see `agents/compliance.md`)
— listed here too so `orchestrator` can filter them alongside the rest in one
pass, not because `compliance` needs a second copy of its own domain.

## Public site launch basics

Not security items, but the same source material and the same filtering
mechanism applies — a static marketing site needs these even with no backend
at all.

- **Tested on a real mobile device**: form submission, WhatsApp/CTA links, no dead links — applies when: a public site has a form or CTA. (`frontend-web`, `qa`)
- **Custom 404 page** — applies when: a public multi-route site. (`frontend-web`)
- **Own domain, favicon, Open Graph image** — applies when: any public site. (`frontend-web`, `devops`)
- **`sitemap.xml` and `robots.txt`** — applies when: a public, indexable site. (`frontend-web`)
- **Per-page titles and meta descriptions** — applies when: SEO matters for the site. (`frontend-web`)
- **PageSpeed check, compressed images** — applies when: any public site. (`frontend-web`)
- **Analytics/Search Console configured, cookie notice shown** — applies when: the site runs analytics. (`analytics`, `compliance`)
- **Contact/footer info current** (company name, CNPJ if applicable) — applies when: an institutional/commercial site. (`compliance`, `frontend-web`)

## See also

- [ARCHITECTURE.md](ARCHITECTURE.md) — how `orchestrator` filters and delegates this list as part of the normal Discovery/delegation flow.
