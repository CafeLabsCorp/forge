# Video pipeline

How `audio`, `video-editor` and `motion` work on the same piece. Each runs isolated,
so **files in the piece's folder are the conversation**. If the maintainer has
`/home/felip/projetos/forge/.local/ambiente.md`, read it for local tools and scripts.

## Handoff files

- `brief.md` — goal, audience, format, duration, who must appear, in what order.
  Written first, confirmed by the user.
- `roteiro.md` — the approved script, when there is one. Copy is literal.
- `transcricao.md` — from `audio`: `[start → end] speaker: text`, with confidence.
- `tempos.json` — from `audio`: word or phrase timestamps. Times are always
  relative to the file named inside it; `motion` and captions read this instead of
  measuring by hand.
- `cortes.md` — from `video-editor`: numbered edit list (source, in, out, what's
  said, confidence), so the user can say "cut 6 is wrong" and only that one changes.
- `notas.md` — anything the next agent needs to know.

## Usual order

Recorded footage: `audio` (transcribe, identify speakers) → `video-editor` (structure,
cuts, draft) → approval → `audio` (final mix) → `motion` (graphics on the locked cut)
→ `media-qa`. Narrated animation: script → `audio` (narration and `tempos.json`) →
`motion` → `media-qa`. If the cut changes after timing or graphics were made, say
what must be redone.

## Rules for everyone

- Originals are never modified or overwritten. Work on copies, and keep inputs
  inside the project, not in Downloads.
- Renders can be regenerated from source. Inputs that can't (footage, narration,
  generated clips) are what must be kept safe.
- Estimate long jobs before starting, run them in the background, and report by
  stage from the job's log.
- Draft first at low cost, final quality only after approval.
