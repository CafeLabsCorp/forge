# Optional tools

Some specialists can use software that not everyone has or wants. A missing tool
must **never block the work**, and nothing gets installed without the user asking.

## The setting

Each person's choice lives in `/home/felip/projetos/forge/.local/tools.conf`, which
is git-ignored. One line per tool:

```
blender: on
```

- `on` — use it.
- `off` — the person doesn't want it. Don't use it, don't offer it again.
- File or line missing — check whether it exists (`command -v blender`). If it does,
  use it. If not, mention once that it's optional and how to install it, then
  continue with the alternatives.

## Blender

Used by `3d-artist`. To install on Linux or WSL, no admin needed:

```bash
./scripts/install-blender.sh
```

To turn it off: put `blender: off` in the file above.

**Without Blender,** `3d-artist` still works: it builds in Three.js (real geometry,
camera and light, usable by `motion`), works from a model the user supplies
(`.glb`, `.gltf`), or writes a ready-to-paste prompt for a generated image. It says
which of these it's doing and what is lost.
