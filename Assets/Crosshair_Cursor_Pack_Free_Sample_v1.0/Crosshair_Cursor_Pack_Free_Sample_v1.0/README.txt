Crosshair and Cursor Pack - Free Sample v1.0
by REEBOO Labs

WHAT IS INSIDE
This is the FREE SAMPLE: 20 crosshairs, 2 hit markers and 6 cursors, same quality and
formats as the full pack, so you can test them in your game.

Want everything? The full pack has 245 crosshairs, 29 hit markers and 76 cursors (350 items):
  https://reebo0.itch.io/crosshair-cursor-pack
(also in GET_THE_FULL_PACK.url)

Folders
  png/<size>/<variant>/<kind>/<category>/<name>.png
      size    = 32, 64 or 128 (px, square)
      variant = white | outlined
      kind    = crosshairs | hit_markers | cursors
  svg/<variant>/<kind>/<category>/<name>.svg    (vector, 32 x 32 unit grid)
  manifest.json                                  every item, its files, category and cursor hotspots
  godot/reebo_cursors/                           GDScript helpers for Godot 4 (cursor manager + crosshair node)
  godot/example_project/                         small Godot 4.4 project that uses them
  LICENSE.txt

Design rules
  - All shapes are drawn on a 32 x 32 unit grid with a 2 unit stroke, so lines are 2 / 4 / 8 px at 32 / 64 / 128 px
    and stay crisp (a few designs use a 4 unit bold stroke).
  - White variant: pure white pixels with alpha. Multiply with any colour (modulate / tint) to recolour.
  - Outlined variant: white with a 1 unit black outline. Use it for mouse cursors and anywhere the background is unknown.
  - Crosshairs and hit markers are centred in the image. Cursor hotspots are in manifest.json ("hotspot" per size).

HOW TO USE
Godot 4
  1. Copy png/ and manifest.json into your project (for example res://assets/).
  2. Copy godot/reebo_cursors/ into your project and add cursor_manager.gd as an Autoload named "Cursors".
  3. In a script:  Cursors.set_cursor("arrow_classic")  or  Cursors.set_cursor("hand_point", Input.CURSOR_POINTING_HAND)
     Crosshair: add a ReeboCrosshair node (crosshair.gd) to your HUD, call set_crosshair("cross_w2_gap4_len5"), set tint,
     spread() when firing and hit_marker() on hits.
  The example project in godot/example_project/ shows all of it (open it with Godot 4.4 or newer).
  Plain Godot without the scripts:  Input.set_custom_mouse_cursor(load("res://.../arrow_classic.png"), Input.CURSOR_ARROW, Vector2(5, 3))
  Note: Godot limits custom cursor images to 256 x 256 px.
Unity
  Import the PNGs (Texture Type: Sprite or Cursor). Cursor.SetCursor(texture, hotspot, CursorMode.Auto) with the hotspot from manifest.json.
  Crosshair: a UI Image with a tint colour on a Canvas.
GameMaker / Construct / Unreal / any engine
  Use the PNGs as sprites or UI images. For OS cursors use the 32 px outlined PNGs and the manifest hotspots.
Web / CSS
  cursor: url("arrow_classic.png") 5 3, auto;   (hotspot x y from the manifest; use the 32 px file)
Vector editors
  The SVGs open in Inkscape, Illustrator, Figma, Affinity. Shapes are plain paths, circles and polygons.

LICENSE
Royalty-free for commercial and non-commercial games and apps. Credit is appreciated, not required.
You may not resell or redistribute the assets as-is, alone or inside an asset pack. See LICENSE.txt.

LINKS
  Full pack:   https://reebo0.itch.io/crosshair-cursor-pack
  Free sample: https://reebo0.itch.io/crosshair-cursor-pack-free-sample
