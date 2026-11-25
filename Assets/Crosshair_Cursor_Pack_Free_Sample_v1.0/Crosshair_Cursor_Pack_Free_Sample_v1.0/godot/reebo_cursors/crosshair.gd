class_name ReeboCrosshair
extends Control
## REEBOO Crosshair and Cursor Pack - tintable crosshair with hit marker, for Godot 4.x
##
## Add a ReeboCrosshair node to your HUD (full-rect Control or any size).
## It draws a "white" crosshair texture, tinted by `tint`, at the screen centre
## or at the mouse. Use the "white" variant of the pack so tinting is exact.
##
##   $Crosshair.set_crosshair("cross_w2_gap4_len5")
##   $Crosshair.tint = Color(0.2, 1.0, 0.3)
##   $Crosshair.spread(1.4)          # bloom while firing, eases back
##   $Crosshair.hit_marker()         # flash a hit marker
##   $Crosshair.hit_marker(true)     # headshot / kill style

## Folder containing manifest.json and png/ (same as ReeboCursors.pack_root).
@export var pack_root: String = "res://assets"
@export var crosshair_name: String = "cross_w2_gap4_len5"
@export var hit_marker_name: String = "hit_x_gap4_len5"
@export var kill_marker_name: String = "hit_x_ring"
@export_enum("32", "64", "128") var size_px: int = 64
@export var tint: Color = Color(1, 1, 1, 1):
	set(v):
		tint = v
		queue_redraw()
@export var follow_mouse: bool = false
@export var hide_os_cursor: bool = true
@export var hit_color: Color = Color(1, 0.25, 0.2, 1)
@export var kill_color: Color = Color(1, 0.85, 0.1, 1)

var _items: Dictionary = {}
var _tex: Texture2D
var _hit_tex: Texture2D
var _kill_tex: Texture2D
var _scale: float = 1.0
var _hit_alpha: float = 0.0
var _hit_is_kill: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(pack_root.path_join("manifest.json")))
	if typeof(parsed) == TYPE_DICTIONARY:
		for it in parsed.get("items", []):
			_items[it["name"]] = it
	set_crosshair(crosshair_name)
	_hit_tex = _load(hit_marker_name)
	_kill_tex = _load(kill_marker_name)
	if hide_os_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _exit_tree() -> void:
	if hide_os_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _load(item_name: String) -> Texture2D:
	if not _items.has(item_name):
		push_warning("ReeboCrosshair: unknown item " + item_name)
		return null
	return load(pack_root.path_join(_items[item_name]["files"][str(size_px)]["white"]))


func set_crosshair(item_name: String) -> void:
	crosshair_name = item_name
	_tex = _load(item_name)
	queue_redraw()


## Enlarges the crosshair by `amount` (1.0 = normal) and eases back.
func spread(amount: float = 1.3, time: float = 0.2) -> void:
	_scale = amount
	var tw := create_tween()
	tw.tween_property(self, "_scale", 1.0, time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


## Flashes a hit marker (kill style = ring marker in gold).
func hit_marker(kill: bool = false, time: float = 0.18) -> void:
	_hit_is_kill = kill
	_hit_alpha = 1.0
	var tw := create_tween()
	tw.tween_property(self, "_hit_alpha", 0.0, time)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var c := get_global_mouse_position() - global_position if follow_mouse else size * 0.5
	if _tex:
		var s := Vector2(_tex.get_size()) * _scale
		draw_texture_rect(_tex, Rect2(c - s * 0.5, s), false, tint)
	var ht := _kill_tex if _hit_is_kill else _hit_tex
	if ht and _hit_alpha > 0.0:
		var col := kill_color if _hit_is_kill else hit_color
		col.a = _hit_alpha
		var hs := Vector2(ht.get_size())
		draw_texture_rect(ht, Rect2(c - hs * 0.5, hs), false, col)
