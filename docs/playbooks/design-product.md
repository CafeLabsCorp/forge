# Design playbook: digital product (apps and websites)

Read this when the surface is an app screen, a web app, or a site. `design`'s core
prompt still applies; this adds what is specific to interfaces people operate.

## Usability and interface craft

- **Apply usability heuristics, not just taste.** Visibility of system status,
  match with real-world conventions, user control (escape/undo), consistency
  with platform patterns, error prevention over error messages, recognition
  over recall — a checklist against your own flows, not background theory.
- **Design the unhappy paths first, not last.** Empty, loading, error,
  permission-denied and (for anything networked) offline/stale-data states are
  where real users get stuck. A happy-path-only flow is a demo, not a design.
- **Design for the longest string.** A label can be ~30% longer in one language
  than another (Portuguese vs. English is routine). Check fixed-width buttons,
  tab labels, and anything truncated with an ellipsis.
- **Dark mode is near-free if decided at design time, expensive to retrofit.**
  If the stack gives it cheaply (Material/Human Interface theming), decide it
  deliberately — colors that only work on one background are what make it costly.
- **Platform conventions are a shortcut, not a constraint to escape.** Users
  bring muscle memory (back gesture, tab bar, pull-to-refresh). Deviate only
  where deviation is the actual differentiation.
- **Accessibility is baseline, not a design-ambition dial.** Contrast, thumb-sized
  tap targets and screen-reader labels decide whether part of your audience can
  use the product at all.

## Design ambition — a decided input, not a reopened question

The orchestrator passes the **design ambition** decided with the user (safe/
proven vs. bold/experimental) in the scope summary; don't reopen it:

- **Safe/proven** (default when unspecified): solo-maintainer simplicity matters
  as much as aesthetics. Prefer patterns natively supported by the stack (e.g.
  standard Material widgets in Flutter) over expensive custom components.
- **Bold/experimental**: prioritize differentiation at extra implementation cost
  — custom layouts, motion, type/palette outside the default system. Still flag
  any choice needing a new library or visibly higher maintenance, so it's conscious.

Motion and imagery richness is a dimension of this same decision, not one tied
to surface type. Don't default to "bold only applies to the marketing site": a
daily-use app screen can earn one bold moment (onboarding, a signature
interaction on the core action) when it serves the differentiation, and a
landing page can stay restrained when the audience calls for it. Reason per
product and surface; no shortcut rule substitutes for the judgment.

## What to deliver

1. **Design the v1 user flow**: main screens, navigation, and — explicitly —
   empty/error/loading/permission states. The minimum that validates the
   hypothesis, not a complete app.
2. **Produce navigable wireframes** when it helps the decision (Artifact tool:
   an interactive HTML mockup beats describing a layout). For section-heavy or
   ambitious surfaces, only after the section plan has converged.
3. **Define a minimum visual identity** when the project doesn't inherit one:
   palette, typography, tone — coherent, not a full branding project. With real
   motion, add a minimum **motion identity** too (signature easing curve, rough
   timing: snappy vs. deliberate) so separate bold moments read as one
   product's language.
4. **Research references** (WebFetch) for established UX patterns instead of
   reinventing basic interactions.

