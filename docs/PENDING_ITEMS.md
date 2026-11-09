# Project open items (`docs/PENDENCIAS.md`)

Every project Forge builds keeps one file, `docs/PENDENCIAS.md`, that records
what is still open, so nothing depends on a conversation being remembered.
It is tool-agnostic and committed with the project. Its presence also marks the
project as built by Forge. Write it in the language of the project's docs.

Not to be confused with creator mode (`docs/CREATOR_MODE.md`), which is about
improving Forge itself and only the maintainer uses.

## Format

Four sections, one line per item, short:

- **Em aberto** — `- [ ] what is open. _origem:_ agent, date. _gravidade:_
  bloqueia lançamento | importante | menor.` An unresolved `security` finding, a
  failing or missing test, a deferred decision, a known limitation. Close with
  `[x]` and the date instead of deleting; prune closed items after a couple of
  weeks.
- **Riscos aceitos** — what the risk is, who accepted it, when, and why. A risk
  accepted silently is the same as an unknown one.
- **Dependências** — what the project depends on and what depends on it: the
  manifests and external services it needs (cloud project, domain, third-party
  APIs, SDKs, keys that must exist), plus any other project that consumes it or
  that it consumes, when known. The point is that changing one thing can warn
  about what else it touches.
- **Para confirmar** — every `TODO: confirmar` left in the docs, with where it is.

## Who writes it

Any specialist that leaves something open adds a line before returning, instead
of only mentioning it in the reply. `security` has no `Write`: it puts the item in
its reply and the orchestrator (or `docs`) records it. `docs` creates the file if
it doesn't exist and reconciles it against the repo at the end of Build. Never
duplicate an item in the README or in another doc: link to it.

## When you pick a project up

When the orchestrator is invoked on an existing project with this file (triage
mode), before scoping the change:

1. Read the file and list what is open and what is accepted risk.
2. Compare **Dependências** against reality (manifests, config, deploy): note
   drift in either direction — something used but unlisted, or listed but gone.
3. Check the `TODO: confirmar` markers in `docs/` for ones that now have an
   answer or that block the planned change.
4. If the change touches something another project consumes (or consumes from
   another), say so before work starts, so the dependent side is not forgotten.
5. Fold the relevant open items into the scope summary; ask about any that
   conflict with the change instead of silently carrying or dropping them.
