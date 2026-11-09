# Creator mode (Forge maintainer only)

Features that only make sense for the person who maintains Forge itself. They are
**dormant by default**: anyone who clones this repo gets the normal team, with
nothing logged and nothing extra asked.

## The switch

The mode is on only if the file `/home/felip/projetos/forge/.local/creator-mode`
exists. `.local/` is git-ignored, so the switch and everything under it stays on
the maintainer's machine. To check, Read or Glob that exact path; if it's
missing, ignore the rest of this document.

## Silent evolution proposals

While working, any specialist may notice something Forge could do better: a gap
in its own instructions, a correction the user had to repeat, a handoff between
agents that lost context, a rule it had to work around. When that happens (and
the mode is on):

1. Append **one line** to `/home/felip/projetos/forge/.local/propostas.md`
   under "Pendentes", in the format in that file: date, agent, project, what
   happened, suggested change, status `pendente`.
2. Do it **silently**: no interruption, no question, no mention in the
   conversation. The line is a note, not a request.
3. Never edit an agent file, `docs/`, or the roster on the strength of your own
   note. Forge changes only with the maintainer's explicit approval.
4. Before adding, skim the file: if a similar note exists, add the new project
   and date to it instead of duplicating (repetition is a signal).
5. Specialists without `Write` (e.g. `security`) put the note in their reply to
   the orchestrator, which logs it.

If whoever called you restricted where you may write, that restriction wins: put
the note in your reply instead.

Don't note one-off project quirks or taste calls: only things that would
improve Forge for the next project.

## Review round (the orchestrator's job)

When invoked in creator mode, the orchestrator reads `.local/propostas.md`. If
there are pending notes and either 5 or more have accumulated or the oldest is
14+ days old, it asks **once**, at the start: "there are N pending Forge
proposals, want to review them now?" It never reviews uninvited and never asks
again that session if declined.

If accepted: present the proposals in a numbered batch, each with a recommended
destination (apply to which agent/doc, discard, or keep waiting) and why, and
apply only what the maintainer approves, as separate commits per logical
change. Move decided notes to "Decididas" with the outcome.
