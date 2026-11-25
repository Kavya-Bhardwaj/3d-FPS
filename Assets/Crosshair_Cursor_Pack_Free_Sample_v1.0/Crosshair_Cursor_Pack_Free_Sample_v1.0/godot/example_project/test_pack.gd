extends SceneTree
## Headless self-test: godot --headless --path <project> --script res://test_pack.gd

func _initialize() -> void:
	var ok := true
	var m := ReeboCursors.new()
	m.pack_root = "res://assets"
	ok = m.load_manifest() and ok
	print("items in manifest: ", m.item_names().size())
	for n in m.item_names("cursors"):
		var tex := m.get_texture(n, 32, "outlined")
		var tex2 := m.get_texture(n, 128, "white")
		if tex == null or tex2 == null or tex.get_width() != 32 or tex2.get_width() != 128:
			print("FAIL texture ", n)
			ok = false
		else:
			var hs := m.get_hotspot(n, 64)
			if hs.x < 0 or hs.y < 0 or hs.x > 64 or hs.y > 64:
				print("FAIL hotspot ", n)
				ok = false
			m.set_cursor(n)
	for n in m.item_names("crosshairs"):
		var t := m.get_texture(n, 64, "white")
		if t == null or t.get_width() != 64:
			print("FAIL crosshair ", n)
			ok = false
	m.apply_default_set(64, "white")
	m.reset_cursor()
	var scene: PackedScene = load("res://demo.tscn")
	var inst := scene.instantiate()
	root.add_child(inst)
	await process_frame
	await process_frame
	inst.crosshair.spread(1.4)
	inst.crosshair.hit_marker(true)
	await process_frame
	print("demo scene instantiated, crosshair=", inst.crosshair.crosshair_name)
	print("SELFTEST ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)
