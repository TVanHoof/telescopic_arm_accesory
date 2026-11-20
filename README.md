# Telescopic arm accessory system

Modular OpenSCAD parts for mounting accessories to a telescopic arm. Each part is
a separate module so it can be re-used or printed on its own.
`telesopic_arm_accesory.scad` is the top-level file: it assembles the parts into
the complete rig and can also lay them out as an exploded view.

## Files

| File | Contents |
| --- | --- |
| `telesopic_arm_accesory.scad` | Top-level assembly and exploded layout. |
| `pole_connection.scad` | Sleeve and handle that connect to the pole; includes the printed spring-button insert and uses the indexed joint. |
| `base_mount.scad` | Bracket that saddles the hub, with male dovetail ribs. |
| `accesory_mount.scad` | Plate with female dovetail slots that slides onto the base mount. |
| `accesory_base.scad` | Flat mounting plate with corner holes and a central boss. |
| `dovetail_joint.scad` | One module for both halves of the dovetail slide joint. |
| `indexed_joint.scad` | 24-tooth indexed flange joint, male and female halves. |
| `accesories/clamp.scad` | Split shaft collar with M8 thumb screws, plus `clamp_adapter()`. |

Dependencies are declared with `use <...>`, so the library files contribute
modules only; their top-level geometry is not drawn.

## External hardware

Counts are for the full `view="assembly"` build.

| Location | Hardware | Qty | Notes |
| --- | --- | --- | --- |
| Handle ↔ two base mounts (indexed joints) | M8 through-bolt, ~55–60 mm | 1 | The handle has one continuous Ø8 cross-hole, so a single bolt clamps both base mounts. All joint holes are plain, not tapped. Two shorter M8 bolts can be used instead. |
| Handle ↔ two base mounts | M8 nut + washers | 1 / 2 | Washers are recommended against the printed flanges. |
| Clamps (two per assembly) | M8 thumb screws, ~55 mm | 4 | Two per clamp; screw holes are Ø8.5. |
| Clamps | M8 hex nuts, 13 mm across flats, 6.5 mm thick | 4 | Sit in the printed captive pockets. |
| Clamps | M8 washers, OD 16 mm, ~1.5 mm thick | 4 | Sit in the printed recesses. |
| Clamp adapter | M4 thumb/set screw, ~25–30 mm | 1 | The tip bears on the shaft; no nut is needed. |
| Accessory mount top plate (when fitting an accessory) | M5 bolts + nuts | 4 / 4 | Through the four corner holes; length depends on the accessory thickness. |
| Accessory mount centre (when fitting an accessory) | M6 bolt + nut | 1 / 1 | See the fit note below. |

Non-fastener external parts:

- The outer telescopic arm tube with the ~Ø6 locking holes that the printed
  spring-button insert snaps into.
- The accessory shaft, Ø30 mm by default for `clamp_adapter()`.
- The accessory itself, bolted to the top plate.

No hardware is needed for the dovetail joints or for the spring-button insert.

**Fit note:** the central hole in `accesory_base.scad` is Ø6, which is a snug fit
for an M6 shank, and the hex recess is about 8.66 mm across flats — too small
for a standard M6 nut (10 mm across flats). For a clearance fit with a captive
M6 nut, open the hole to Ø6.6 and the hex to about Ø11.55. The corner Ø5 holes
are likewise tight for M5 bolts; Ø5.5 gives normal clearance.

## Selecting what to render

The top-level file uses a `view` variable to decide which geometry is emitted:

```scad
// ["assembly", "exploded", "all"]
view = "all";

$fn = $preview ? 32 : 500;
```

| `view` value | Result |
| --- | --- |
| `"assembly"` | The complete assembled rig: pole connection, two base mounts, accessory mount, two clamps and the clamp adapter. |
| `"exploded"` | The parts laid out in a row along the Y axis, starting at the origin. |
| `"all"` (default) | Both of the above; the exploded row is shifted 100 mm in Y so it does not overlap the assembly. |

In the GUI, open the Customizer panel (Window → Customizer) and pick a value
from the `view` dropdown, then press **F5** for preview or **F6** for a full
render.

From the command line, override `view` with `-D`:

```bash
openscad -D 'view="assembly"' -o assembly.stl telesopic_arm_accesory.scad
openscad -D 'view="exploded"' -o exploded.png telesopic_arm_accesory.scad
openscad -o all.png telesopic_arm_accesory.scad                # default: "all"
```

The single quotes are needed in bash so that the double quotes around the
string reach OpenSCAD; the `-D` value overrides the assignment in the file.

## Rendering

GUI: **F5** for preview, **F6** for full render. Command line:

```bash
openscad -o preview.png telesopic_arm_accesory.scad            # preview image
openscad --render -o assembly.png telesopic_arm_accesory.scad  # full render image
openscad -o assembly.stl telesopic_arm_accesory.scad           # STL export
```

Image output also accepts `--camera`, `--viewall`, `--autocenter` and
`--imgsize=width,height`.

`$fn` is set from `$preview`: previews use 32 fragments for responsive feedback,
while full renders and exports use 500. It can still be overridden if needed:

```bash
openscad -D '$fn=64' -o smoother-preview.png telesopic_arm_accesory.scad
```

## License

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 Thomas Van Hoof.
