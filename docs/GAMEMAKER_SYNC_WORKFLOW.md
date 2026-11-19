# GameMaker source and synchronization workflow

## Source of truth

- Edit gameplay scripts, object event GML, sprite import inputs, and data files under `game/` or their documented source inputs.
- `gen_gamemaker.py` and the asset importers generate the resources they explicitly own under `gamemaker/`.
- Some rooms, audio resources, and IDE-authored content currently exist only in `gamemaker/`. They are preserved by synchronization and are not claimed to be source-generated.
- Do not keep a gameplay edit only in a generated GML file; move it into its source input and regenerate.

## Commands

Run from the repository root with Python 3.10+ and Pillow installed:

```bash
python -m pip install pillow
# Read-only preview; generator runs in a temporary checkout
python tools/sync_gamemaker.py
# CI check; verifies source/generated GML parity
python tools/sync_gamemaker.py --check
# Apply after reviewing the preview
python tools/sync_gamemaker.py --apply
# Validate the committed project without regenerating
python validate_gamemaker.py
```

> **Do not use `--apply` to publish a GML-only edit.** It copies every generated
> resource in the preview, not just the file you changed. The committed sprites
> carry IDE-assigned frame names, while the generator emits its own UUIDs, so an
> apply rewrites sprite `.yy` metadata and frame PNGs across the project. In the
> 2026-11-19 stabilization pass a single apply for two script fixes touched 135
> generated files and left `validate_gamemaker.py` failing on a missing frame
> PNG (120 sprite asset files); it was reverted. For a script or event change,
> copy the source file into the matching `gamemaker/` resource and re-run
> `validate_gamemaker.py` and `sync_gamemaker.py --check` instead. `--check`
> compares GML only, so it will not warn you about sprite drift afterwards —
> `validate_gamemaker.py` is the gate that catches it.

The sync tool never runs the generator against the live `gamemaker/` directory. It builds in a temporary checkout, validates the generated project, and compares normalized output. Generated UUIDs, frame filenames, and instance names are normalized for the full dry-run. The CI `--check` gate compares GML source/event files only; `validate_gamemaker.py` separately checks the committed project's resource metadata, references, room structure, and sprite files. Imported binary assets and IDE metadata remain visible in the full dry-run for deliberate review. `--apply` is explicit and additive: it copies generated additions and updates into `gamemaker/` without replacing the project directory or deleting live-only resources. Room and sound resources are excluded from generated-file comparison until they have authoritative source inputs.

## Recommended change cycle

1. Make changes in `game/` and the appropriate source asset/import table.
2. Run `python validate_gamemaker.py` against the current project.
3. Run `python tools/sync_gamemaker.py` and inspect the proposed file list.
4. Review the preview, then run `python tools/sync_gamemaker.py --apply` to copy only generated additions and updates. Live-only resources are retained. If the preview contains only the GML file you edited, copy that one file across by hand instead of applying the whole preview — see the warning above about sprite metadata.
5. Run `python validate_gamemaker.py` again.
6. Open `gamemaker/AshenCrown.yyp` in GameMaker and compile/playtest.
7. Commit source and generated output together.

## CI guarantees and limits

Pull requests and pushes to `main` run static project validation and a source/generated GML parity check. CI does not claim to compile or launch GameMaker; that still requires a compatible GameMaker installation/runtime. Static checks cover project JSON, referenced paths, sprite/frame/layer files, object event-file parity, source/generated script and datafile parity, room structure, selected room invariants, and statically recognizable GML resource references.

## Conflict policy

If the proposed sync changes a resource manually edited in GameMaker, do not discard that work blindly. Port the intended change into `game/` or the generator, then regenerate and review the diff. A passing sync check is not proof of a successful IDE compile or gameplay test.
