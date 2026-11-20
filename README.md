# Telescopic arm accessory system

Modular OpenSCAD parts for mounting accessories to a telescopic arm. Each part is
a separate module so it can be re-used or printed on its own.
`telesopic_arm_accesory.scad` is the top-level file: it assembles the parts into
the complete rig and can also lay them out as an exploded view.

## Files

| File | Contents |
| --- | --- |
| `telesopic_arm_accesory.scad` | Top-level assembly and exploded layout. |
| `pole_connection.scad` | Sleeve and handle that connect to the pole; uses the indexed joint. |
| `base_mount.scad` | Bracket that saddles the hub, with male dovetail ribs. |
| `accesory_mount.scad` | Plate with female dovetail slots that slides onto the base mount. |
| `accesory_base.scad` | Flat mounting plate with corner holes and a central boss. |
| `dovetail_joint.scad` | One module for both halves of the dovetail slide joint. |
| `indexed_joint.scad` | 24-tooth indexed flange joint, male and female halves. |
| `accesories/clamp.scad` | Split shaft collar with M8 thumb screws, plus `clamp_adapter()`. |

Dependencies are declared with `use <...>`, so the library files contribute
modules only; their top-level geometry is not drawn.

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
