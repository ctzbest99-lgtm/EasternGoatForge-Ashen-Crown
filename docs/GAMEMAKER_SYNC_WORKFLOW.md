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
# CI check; non-zero when generated output is stale
python tools/sync_gamemaker.py --check
# Apply after reviewing the preview
python tools/sync_gamemaker.py --apply
# Validate the committed project without regenerating
python validate_gamemaker.py
```

The sync tool never runs the generator against the live `gamemaker/` directory. It builds in a temporary checkout, validates the generated project, and compares normalized output. Generated UUIDs, frame filenames, and instance names are normalized for drift checks; the generator now emits deterministic identifiers for future builds. `--apply` is explicit and additive: it copies generated additions and updates into `gamemaker/` without replacing the project directory or deleting live-only resources. Room and sound resources are excluded from generated-file comparison until they have authoritative source inputs.

## Recommended change cycle

1. Make changes in `game/` and the appropriate source asset/import table.
2. Run `python validate_gamemaker.py` against the current project.
3. Run `python tools/sync_gamemaker.py` and inspect the proposed file list.
4. Review the preview, then run `python tools/sync_gamemaker.py --apply` to copy only generated additions and updates. Live-only resources are retained.
5. Run `python validate_gamemaker.py` again.
6. Open `gamemaker/AshenCrown.yyp` in GameMaker and compile/playtest.
7. Commit source and generated output together.

## CI guarantees and limits

Pull requests and pushes to `main` run static validation and a regeneration drift check. CI does not claim to compile or launch GameMaker; that still requires a compatible GameMaker installation/runtime. Static checks cover project JSON, referenced paths, sprite/frame/layer files, object event-file parity, source/generated script and datafile parity, room structure, selected room invariants, and statically recognizable GML resource references.

## Conflict policy

If the proposed sync changes a resource manually edited in GameMaker, do not discard that work blindly. Port the intended change into `game/` or the generator, then regenerate and review the diff. A passing sync check is not proof of a successful IDE compile or gameplay test.
