# Motion quality checklist

Mandatory review list for `motion` before handing back and for `media-qa` when
auditing. Applies to animation made in code and, largely, to any motion. These
are finish rules, not style: they say what is broken, never what a piece should
look like.

## Connections (lines, traces, branches)

- A line appears only after both things it connects exist. Order: origin → line →
  destination. Never a lone line, a branch before its parent, or an arrow to nothing.
- Lines run edge to edge; never behind a translucent box or ending loose. Nodes
  are drawn over the line.
- A growing line must not start as a dot: a zero-length line with a round cap is
  a stray dot on frame one. Draw it only once it has length.
- Connectors leave and arrive at the center of an edge.

## Moving particles and pulses

- Follow the path, curves included. Start at its beginning; finish before vanishing.
- Grow and fade smoothly, eased in position. Start only when the path is complete.
- Parallel pulses are staggered, or they read as copies.

## Appearing and disappearing

- Nothing pops on or off. No hard switching of opacity, size or label by condition.
- Every element has an entrance, a rest and an exit.
- Don't let the frame freeze for seconds; keep meaningful movement going.
- State change: the old dims, the new lights up, never the reverse.

## Start, end, continuity

- In a sequence or loop, pieces start and end clean so any order joins without a
  hard cut. Persistent elements also ease in and out.
- A series may share a closing, if it's declared as a series.

## Alignment and composition

- A defined grid and margins; equal centers; nothing slightly off-axis.
- Content inside the safe area of the real medium; nothing clipped by frame or mask.
- Icons centered by visual center, not by the drawing's anchor.
- A stack that builds up item by item re-centers at each item.
- No overlaps, no dead space, no large empty boxes.
- Same role, same visual weight.

## Meaning

- Every element corresponds to what is being said. No narrative role, it goes.
- Labels name what a shape is. One visual idea per scene: few, large, legible
  things beat many small ones, especially on anything seen in passing.
- Nothing the script or client forbids: invented numbers, real product screens
  without permission, absolute guarantees.

## Text

- Copy is literal from the approved script, never inside generated images.
- A minimum type size set by the medium, nothing below it; no thin weights on LED.
- Short entrance, then stable for real reading time. Art never cuts text.

## Brand

- The official logo is never altered in color, proportion or drawing; use the
  official variant for the background.
- New brand phrases only with approval.
- QR codes generated locally and static, confirmed by reading them from a rendered
  frame.

## Review method

- Review by frames, the whole video: contact sheets with 12–18 frames including
  start, end, scene changes, the **first frames of each animation** (where stray
  dots are born) and the moments just after something enters.
- After touching a shared component, review everything using it. After fixing an
  error, search for the same pattern elsewhere. Fix at the origin.
- Measure what can be measured (QR, duration, resolution, audio presence, contrast).
- Show the human only after your own review, and say what changed.
- A quick low-quality test before the final render; approval by stage (animatic →
  final). Versions clearly named, old ones archived.

## Delivery

- Native resolution of the medium, exact proportion, no bars. Confirm fps, codec
  and container with whoever plays it. No audio track for silent media.
- Final export at high quality; rendering at 2× and reducing smooths thin lines.
- Testing on the real medium is the final criterion.
