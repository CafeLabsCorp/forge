# Architecture

Agent Forge is a pattern for orchestrating a team of specialized subagents on top
of Claude Code (or any agent runtime with an equivalent subagent/tool-delegation
primitive) to accelerate the **Build** phase of a new product or MVP: one
orchestrator agent that runs initial discovery, decides which specialists to
involve, delegates to them, and synthesizes their output back to the user.

## Core pattern: orchestrator + specialists

### The orchestrator

- Runs on the highest-capability model available (e.g. Opus) — it is the only
  role that makes whole-project architecture decisions. That happens rarely per
  project, so the stronger reasoning is worth the cost.
- Triggers automatically when the user signals they're starting a new project or
  want to validate a product idea — defined declaratively via the agent's
  `description` trigger, no explicit command needed. Its very first message
  states plainly that the user is talking to the orchestrator, so the active
  role is never ambiguous.
- Also triggers inside an already-scoped, in-progress product when the user
  explicitly asks for Forge/the team rather than naming one specialist (e.g.
  "let's loop in the team on this") — it never self-triggers on a routine,
  unprompted task in an existing product. There it runs in **triage mode**
  instead of full discovery: it decides whether the change needs the full
  specialist cycle or is confined to one domain. For a single-domain change,
  it names that specialist and hands the user off to talk to them directly
  instead of running a Task delegation for a one-agent job. For a
  multi-domain change, it runs the normal delegation flow but scoped to what's
  actually changing, not a restatement of the whole product.
- Runs discovery as a draft-first conversation, not an upfront interrogation:
  it turns whatever the user gives it — often just a one-line idea — into a
  concrete draft in the same reply (problem, target audience, platform(s),
  rough scope, a recommended stack) for the user to validate, correct, or
  override, rather than opening with a round of questions. Budget is not a
  checkbox inside that draft — for any stack/infrastructure decision with more
  than one viable path, it names a recommendation plus the concrete
  alternative(s) (free/self-hosted vs. paid, with what each actually buys and
  costs) rather than defaulting to "free tier" as if cost were the only axis
  that mattered. Cost is the user's constraint to weigh, not the
  orchestrator's to assume — a paid option is sometimes the right call. When a
  design specialist is in scope, the draft also proposes a default design
  ambition — safe/proven (native UI patterns, lower risk, faster) vs.
  bold/experimental (custom visual identity, more time/risk, more
  differentiation) — skipping it entirely for disposable MVPs, where fast
  validation matters more than form, and defaulting to safe/proven.
- Decides which specialists to involve — only the ones relevant to the scope,
  never all of them by default.
- Has authority to decide technically on its own only for low-stakes,
  reversible implementation details. Anything that shapes the stack itself
  (backend, hosting, free vs. paid, framework) is brought to the user as
  concrete options, never decided alone.
- Surfaces decisions and trade-offs before proceeding. Never asks trivial
  questions, but also never unilaterally makes an expensive or hard-to-reverse
  decision (e.g. backend choice, monetization model) without exposing the
  options first, paid ones included.

### Specialists

Each specialist is a separate subagent file (for example: `product`, `design`,
`mobile`, `backend`, `frontend-web`, `devops`, `qa`, `security`, `compliance`,
`analytics`, `docs`, `creative-director`, `content-strategist`, `motion`, `video-editor`, `audio`,
`3d-artist`, `media-qa` — the roster is a starting point, not a fixed list) with:

- a `name` and a `description` containing a clear trigger — the phrases that
  should activate it;
- the minimal `tools` needed for its scope;
- a `model` — the mid-tier model by default, escalated to the top-tier model
  only when the role makes expensive or hard-to-reverse decisions (the
  canonical example is a backend/data-architecture specialist choosing the
  persistence layer).

Specialists run in **isolated context** — they never see the conversation that
led to the delegation. The orchestrator must summarize the agreed scope
explicitly in the delegation call; nothing is implicit.

## Security/launch checklist reference

`docs/SECURITY_CHECKLISTS.md` holds a shared list of concrete security,
infra-operations, store-compliance, and public-site-launch checks, each
tagged with the project attribute it depends on (has a backend/DB, handles
payments, is public-facing, distributed to a store, etc.) instead of being
duplicated across each relevant specialist's own file. During Discovery, the
orchestrator determines which attributes this project actually has and
passes the filtered subset of applicable items to each relevant specialist
(`security`, `qa`, `devops`, `backend`, `frontend-web`, `mobile`,
`compliance`, `analytics`) as part of its scope summary — the same way any
other delegation context is passed to a cold-start specialist. A specialist
working standalone (triage mode) reads the file directly and judges what
applies, the same way it applies any other domain-mastery heuristic.

## Delegation flow

1. The orchestrator runs discovery and agrees on scope with the user.
2. It explicitly asks the user for a go-ahead ("anything else to define, or can
   I start?") and waits for an affirmative reply — the conversation moving
   forward, or the absence of an objection, is not a yes.
3. Only once confirmed, it picks the relevant specialists and delegates to
   each of them, passing the scope summary explicitly (specialists start cold,
   with no memory of the conversation).
4. Each specialist returns its output: decisions made, trade-offs considered,
   and what was produced.
5. Once every other delegated specialist has returned, the orchestrator
   delegates once more — to `docs` — passing the scope summary plus each
   specialist's actual output, so the project's documentation set (README,
   architecture, design, deploy, and backend docs where relevant) is produced
   from what was really built, not skipped as an afterthought. `docs` runs
   once per project, near the end of Build, unlike a recurring/incremental
   step.
6. The orchestrator synthesizes the specialists' output for the user instead of
   relaying raw output — the user gets one coherent narrative, not N reports.
7. Shipping Build is not the end of the flow. The orchestrator names when the
   Measure phase gets read (a date or a usage threshold) as part of that
   synthesis, and later owns the Learn call — reading the result against the
   success criteria `product` agreed *before* launch, distinguishing a
   disproven hypothesis from one that never got tested (no distribution,
   broken instrumentation, too few users to read), and recommending
   persevere / pivot / stop. Without an owner and a named checkpoint, Learn
   is the phase that silently never happens and a validation project becomes
   permanent unexamined maintenance.

## Model selection heuristic

- Default every subagent to the mid-tier model — cheaper, and fast enough for
  well-scoped implementation work.
- Escalate to the top-tier model only for roles that make whole-project or
  hard-to-reverse decisions: the orchestrator itself, and any specialist that
  owns data/infrastructure architecture.
- This keeps cost proportional to the blast radius of the decision being made,
  rather than a blanket "always use the best model" policy.
- One deliberate exception: `design` runs on the top-tier model (changed
  2026-11-09) not for blast radius but for creative range — on the mid-tier
  model its output kept converging on the expected version of a product's
  genre. It is the first specialist to revisit if token cost needs trimming.

## Advocate, don't just comply

Every specialist — and the orchestrator itself — is expected to bring and use
real domain judgment, not just execute whatever is asked for literally. Being
"a master of the craft" means the same thing here it means for a senior human
hire: understanding the actual problem behind the request, and saying so when
the requested path is technically doable but not the best available option, or
is actively harmful to the project's cost, security, maintainability, or the
business hypothesis being tested.

The behavior has three parts:

1. **Object once, with reasoning.** State the concern and the better
   alternative in the same breath — backed by a concrete failure mode ("this
   breaks under X", "this leaks Y"), never a vague appeal to "best practices."
2. **Yield when given a real justification.** A reason tied to the user's
   actual constraints (timeline, budget, a requirement the agent didn't know
   about, a risk being consciously accepted) is enough to proceed. The agent's
   job is to make sure the trade-off was actually seen, not to keep
   re-litigating a decision already made with full information.
3. **Never yield silently on non-negotiables.** Each specialist below defines
   its own short list of things that aren't preference trade-offs — mostly
   basic security, data integrity, and anything that would make the MVP unable
   to actually test its hypothesis. For these, push back harder and require an
   explicit, affirmative override before proceeding; one mention followed by
   silent compliance is not enough.

This applies to the human user, and equally to accepting another specialist's
handoff uncritically — e.g. `mobile` should flag it if the `design` handoff
specifies a flow that isn't buildable within the agreed constraints, instead of
just implementing it as given.

## Self-maintaining roster

The orchestrator also owns the evolution of its own specialist team — not just
the execution of individual projects. This is a deliberate design choice: the
team of agents is itself a product that improves over time, and the same agent
that knows the roster best is the one that should maintain it. This is still
Discovery-grade work, not implementation: the same rule that stops the
orchestrator from jumping into a new product before scope is agreed applies to
the roster itself. Writing a file is the last step, never the first.

- **Creating a new specialist**: before writing anything, agree with the user
  on the agent's role and boundary with existing specialists, the minimal
  `tools` it needs, the model tier (mid-tier by default, escalate only if the
  decision is expensive or hard to reverse, same rule as above), and any
  default stack/behavioral assumption the agent will encode. These are exactly
  the hard-to-reverse calls the "advocate, don't just comply" principle says to
  expose rather than decide alone. Only once that's agreed, write the file
  following the existing pattern: frontmatter with a clear trigger
  `description`, the agreed `tools`/model.
- **Updating a specialist**: edit its file directly (prompt, tools, model). For
  a non-trivial behavior change, explain what changes and why before applying
  it.
- **Splitting a specialist in two**: propose the new split of responsibilities
  first — never split unilaterally without confirmation. Once approved, create
  the new files, retire or update the old one, and fix every reference to the
  old roster (including this document).
- After any add/rename/remove under the agents directory, re-run the symlink
  setup script (see below) — otherwise the runtime won't see the change.
- Keep the roster documentation in sync with the real files — it's the team's
  source of truth for what exists and why.

## Wiring into Claude Code

Subagent definitions are plain Markdown files with YAML frontmatter (`name`,
`description`, `tools`, `model`) under `agents/`. `scripts/setup-symlinks.sh`
symlinks each of them into `~/.claude/agents/` so Claude Code picks them up as
available subagent types — see that script for the exact mechanism, and re-run
it any time an agent file is added, renamed, or removed.

## Extending the roster

The specialist list in this repo (`agents/`) is a generalized starting point
extracted from a real, working team of agents used to ship production MVPs. It
is deliberately not tied to any specific product domain or tech stack — treat
each specialist file as a template to adapt to your own stack, team roles, and
decision-making priorities.

## Two front doors: product and studio

`orchestrator` leads software products through Build-Measure-Learn.
`creative-director` leads brand, campaign, content and video work through concept
and staged approval, delegating to `content-strategist`, `design`, `motion`,
`video-editor`, `audio` and `3d-artist`, with `media-qa` reviewing every finished piece. `design`,
`compliance`, `analytics` and `docs` serve both. A subagent can delegate to another
within the runtime's depth limit; the leads fall back to naming the sequence for the
user if delegation isn't available.

## Medium playbooks and shared references

`design` is a generalist: its core prompt holds what's true in every medium and it
reads one playbook per job from `docs/playbooks/`, so range doesn't add weight to
every call. `motion` does the same with `motion-repertoire.md`. Shared references:
`docs/MOTION_QUALITY.md` (mandatory finish checklist for `motion` and `media-qa`)
and `docs/VISUAL_RESEARCH.md`. `docs/playbooks/video-pipeline.md` defines the
files `audio`, `video-editor` and `motion` hand to each other. Forge is public: only generic rules live here;
specific brands and clients stay in each brand's manual.

## Optional tools

Software not everyone has (Blender) is configured per person in the git-ignored
`.local/tools.conf`. A missing tool never blocks the work, and nothing is installed
unasked. See `docs/OPTIONAL_TOOLS.md`.

## Open items in the project

Every project Forge builds keeps `docs/PENDENCIAS.md` (open items, accepted
risks, dependencies, `TODO: confirmar`), written by whichever specialist leaves
something open and reconciled by `docs`. When the orchestrator is invoked on such
a project it reads that file first. See `docs/PENDING_ITEMS.md`.

## Progress log

Every project or piece also keeps `docs/PROGRESSO.md`: units, shared decisions and the
exact next step, written at each milestone so any new session resumes from the right
place. Big jobs are cut into reviewable units rather than delegated whole. See
`docs/PROGRESS_LOG.md`.

## Creator mode

Features for the maintainer of Forge only (silent logging of improvement
proposals by the agents, and a periodic review round run by the orchestrator).
Off by default and git-ignored locally; see `docs/CREATOR_MODE.md`.
