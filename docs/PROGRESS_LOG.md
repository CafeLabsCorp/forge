# Progress log (`docs/PROGRESSO.md`)

Every project or piece Forge works on keeps `docs/PROGRESSO.md` (for a piece of
creative work, in the piece's folder), always, even for a short job. It records
where the work is and the exact next step, so a new session, a different agent or
the user a week later resumes from the right place instead of reconstructing it.
It is tool-agnostic and committed with the project. Write it in the language of the
project's docs.

It is not `docs/PENDENCIAS.md`: that one is what is still *open* (findings, risks,
dependencies); this one is *where the work stands*. Link between them, never copy.

## Format

Keep it short; a reader should know where to start from the first block.

1. **Retomar daqui** (always first, rewritten each time): phase, unit in progress,
   the next step in one or two concrete sentences (who does it, which files to
   open), and anything waiting on the user.
2. **Unidades**: one line per unit of work: what, owner, state (`a fazer`,
   `em andamento`, `feito`, `bloqueado`), and where the output is (paths, commit).
3. **Decisões e convenções**: what later units must respect so they do not diverge:
   names, IDs, tokens, style, API shape, brand choices, what was rejected and why.
4. **Histórico**: one dated line per checkpoint (`date, agent, what changed`).
   Keep the last ~20; older ones are summarized in one line.

## Who writes it

- The `orchestrator` (or `creative-director`) creates it when the work starts, with
  the plan split into units and the shared decisions.
- Every specialist updates it **at each milestone and before returning**, not only
  at the end, so an interrupted run still leaves a trail: mark the unit, rewrite
  "Retomar daqui", add the decisions the next unit needs, add a history line.
- `security` has no `Write`: it puts the checkpoint in its reply and the
  orchestrator records it. If whoever called you restricted where you may write,
  that restriction wins: put it in the reply.

## Sizing units

A unit is one coherent, reviewable deliverable: a screen or feature, a flow, one
piece, one endpoint with its data model. Splitting only changes how the work is
cut, never its depth: a unit gets the full care, tests and review it would get in
a single long run, and nothing is dropped to make it fit. Things that cross units
(data model, tokens, brand, naming) are decided once, up front, and written under
"Decisões e convenções" so the units stay consistent. A new unit starts in a fresh
delegation that receives the scope, "Retomar daqui" and the relevant decisions, so
it does not drag the full history of earlier units along.

## When you pick work up

Before anything else, read `docs/PROGRESSO.md`, then `docs/PENDENCIAS.md`. Then
check the log against reality (the repo's state, the files it says exist): the log
can be stale, and when they disagree the repo wins, so fix the log and say so.
Start from "Retomar daqui" and tell the user in a line where the work stands.
