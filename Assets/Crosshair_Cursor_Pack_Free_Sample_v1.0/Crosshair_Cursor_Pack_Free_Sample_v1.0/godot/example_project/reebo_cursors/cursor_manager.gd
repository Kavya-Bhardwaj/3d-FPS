class_name ReeboCursors
extends Node
## REEBOO Crosshair and Cursor Pack - cursor helper for Godot 4.x
##
## Add this script as an Autoload (Project Settings > Globals) named "Cursors",
## or add it as a child node of your main scene.
##
##   Cursors.set_cursor("arrow_classic")                     # OS arrow replaced
##   Cursors.set_cursor("hand_point", Input.CURSOR_POINTING_HAND)
##   Cursors.set_cursor("text_beam", Input.CURSOR_IBEAM)
##   Cursors.set_cursor("resize_horizontal", Input.CURSOR_HSIZE, 64)
##   Cursors.reset_cursor(Input.CURSOR_ARROW)
##
## Hotspots come from manifest.json, so the click point is always correct.

## Folder that contains manifest.json and the png/ folder of the pack.
@export var pack_root: String = "res://assets"
## Default variant: "outlined" (white with black outline) or "white" (tintable).
@export var default_variant: String = "outlined"
## Default size in px: 32, 64 or 128.
@export var default_size: int = 32

var manifest: Dictionary = {}
var _items: Dictionary = {}
var _cache: Dictionary = {}


func _ready() -> void:
	if manifest.is_empty():
		load_manifest()


## Reads manifest.json from pack_root. Returns true on success.
func load_manifest(path: String = "") -> bool:
	if path == "":
		path = pack_root.path_join("manifest.json")
	if not FileAccess.file_exists(path):
		push_error("ReeboCursors: manifest not found: " + path)
		return false
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("ReeboCursors: manifest is not valid JSON: " + path)
		return false
	manifest = parsed
	_items.clear()
	for it in manifest.get("items", []):
		_items[it["name"]] = it
	return true


func has_item(item_name: String) -> bool:
	return _items.has(item_name)


func item_names(kind: String = "") -> PackedStringArray:
	var out := PackedStringArray()
	for n in _items:
		if kind == "" or _items[n]["kind"] == kind:
			out.append(n)
	return out


## Returns the Texture2D of an item (cached) or null.
func get_texture(item_name: String, size: int = 0, variant: String = "") -> Texture2D:
	if not _items.has(item_name):
		push_warning("ReeboCursors: unknown item " + item_name)
		return null
	if size == 0:
		size = default_size
	if variant == "":
		variant = default_variant
	var rel: String = _items[item_name]["files"][str(size)][variant]
	var path := pack_root.path_join(rel)
	if not _cache.has(path):
		_cache[path] = load(path)
	return _cache[path]


## Hotspot in pixels for the given size (cursor items only; crosshairs return the centre).
func get_hotspot(item_name: String, size: int = 0) -> Vector2:
	if size == 0:
		size = default_size
	var h: Array = _items[item_name]["hotspot"][str(size)]
	return Vector2(h[0], h[1])


## Replaces one of the OS cursor shapes with a cursor from the pack.
func set_cursor(item_name: String, shape: Input.CursorShape = Input.CURSOR_ARROW, size: int = 0, variant: String = "") -> bool:
	var tex := get_texture(item_name, size, variant)
	if tex == null:
		return false
	Input.set_custom_mouse_cursor(tex, shape, get_hotspot(item_name, size))
	return true


## Direct version: any Texture2D plus a hotspot in pixels.
func set_cursor_texture(tex: Texture2D, hotspot: Vector2 = Vector2.ZERO, shape: Input.CursorShape = Input.CURSOR_ARROW) -> void:
	Input.set_custom_mouse_cursor(tex, shape, hotspot)


## Restores the default OS cursor for a shape.
func reset_cursor(shape: Input.CursorShape = Input.CURSOR_ARROW) -> void:
	Input.set_custom_mouse_cursor(null, shape)


## Sets the common set in one call (arrow, hand, text, resize, busy, forbidden).
## Items that are not in the loaded manifest are skipped (the free sample has fewer).
func apply_default_set(size: int = 0, variant: String = "") -> void:
	var pairs := {
		"arrow_classic": Input.CURSOR_ARROW,
		"hand_point": Input.CURSOR_POINTING_HAND,
		"text_beam": Input.CURSOR_IBEAM,
		"resize_horizontal": Input.CURSOR_HSIZE,
		"resize_vertical": Input.CURSOR_VSIZE,
		"resize_diagonal_nwse": Input.CURSOR_FDIAGSIZE,
		"resize_diagonal_nesw": Input.CURSOR_BDIAGSIZE,
		"move_four": Input.CURSOR_MOVE,
		"forbidden_circle": Input.CURSOR_FORBIDDEN,
		"loading_arc": Input.CURSOR_BUSY,
		"hand_open": Input.CURSOR_CAN_DROP,
		"hand_grab": Input.CURSOR_DRAG,
	}
	for item_name in pairs:
		if has_item(item_name):
			set_cursor(item_name, pairs[item_name], size, variant)
