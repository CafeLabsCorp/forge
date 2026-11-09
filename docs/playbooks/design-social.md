# Design playbook: social posts

Read this for feed posts, carousels, stories, reels covers and highlight covers.

## The medium

- The piece competes with a thumb moving. It has about a second: one idea, one
  focal point, readable at phone size.
- Check current platform formats and interface overlays; they change. Common
  starting points: feed 1080×1350, story/reels 1080×1920, keeping roughly the top
  250 px and bottom 340 px of a vertical piece free of critical content. Grid
  previews crop further, so test the crop.
- Minimum legible type at phone size matters more than elegance. Render the piece
  at real phone width and look.

## Composition

- Let content choose the form: data → big number; person → photo; process →
  line or flow; event → badge and date.
- **Carousels:** the first slide earns the swipe, each slide makes one point, and
  the last one says what to do. For a continuous panorama, the right edge of the
  last slide matches the left edge of the first, and objects crossing a cut are
  drawn on both sides, with text kept well away from cuts.
- **Text belongs in code, not in generated images.** Generated images carry no
  copy; the copy stays exact and editable.
- Ask for the account's last 3–5 pieces and vary at least two axes (see Fixed ×
  Series × Variable in the core prompt).
- The identity follows the account where it is posted.

## Deliver

Separate files per slide at final size, plus the panorama when there is one, the
editable source, and ready-to-paste prompts for any image still to be generated.
Adjusting one piece of a set leaves the others byte-identical; prove it.
