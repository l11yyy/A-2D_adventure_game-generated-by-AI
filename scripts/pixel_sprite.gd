extends Node2D
class_name PixelSprite

@export_enum("player", "slash", "slime", "bat", "bolt", "gem", "tree", "rock", "flower", "ruin") var sprite_kind := "player":
	set(value):
		sprite_kind = value
		queue_redraw()
@export var frame := 0:
	set(value):
		frame = value
		queue_redraw()
@export var pixel_size := 2.0:
	set(value):
		pixel_size = value
		queue_redraw()
@export var flip_h := false:
	set(value):
		flip_h = value
		queue_redraw()

const TRANSPARENT := Color(0, 0, 0, 0)
const PALE := Color(0.925, 0.749, 0.518, 1.0)
const BLUE := Color(0.176, 0.412, 0.824, 1.0)
const DARK := Color(0.075, 0.122, 0.196, 1.0)
const BOOT := Color(0.137, 0.098, 0.118, 1.0)
const HAIR := Color(0.282, 0.176, 0.110, 1.0)
const STEEL := Color(0.863, 0.902, 0.922, 1.0)
const SLIME := Color(0.388, 0.788, 0.365, 1.0)
const SLIME_DARK := Color(0.165, 0.439, 0.212, 1.0)
const SLIME_SHINE := Color(0.706, 1.0, 0.604, 1.0)
const BAT := Color(0.361, 0.271, 0.518, 1.0)
const BAT_WING := Color(0.235, 0.176, 0.361, 1.0)
const RED_EYE := Color(1.0, 0.333, 0.333, 1.0)

func _draw() -> void:
	match sprite_kind:
		"player": _draw_player(frame % 4)
		"slash": _draw_slash(frame % 4)
		"slime": _draw_slime(frame % 4)
		"bat": _draw_bat(frame % 4)
		"bolt": _draw_bolt()
		"gem": _draw_gem()
		"tree": _draw_tree()
		"rock": _draw_rock()
		"flower": _draw_flower()
		"ruin": _draw_ruin()

func p_rect(x: int, y: int, w: int, h: int, color: Color) -> void:
	if color.a <= 0.0:
		return
	var draw_x := float(-x - w if flip_h else x)
	draw_rect(Rect2(draw_x * pixel_size, float(y) * pixel_size, float(w) * pixel_size, float(h) * pixel_size), color)

func p_dot(x: int, y: int, color: Color) -> void:
	p_rect(x, y, 1, 1, color)

func p_circle(cx: int, cy: int, radius: int, color: Color) -> void:
	for y in range(cy - radius, cy + radius + 1):
		for x in range(cx - radius, cx + radius + 1):
			if (x - cx) * (x - cx) + (y - cy) * (y - cy) <= radius * radius:
				p_dot(x, y, color)

func _draw_player(step: int) -> void:
	var off := [0, 1, 0, -1][step]
	p_rect(11, 10, 10, 12, BLUE)
	p_rect(12, 5, 8, 7, PALE)
	p_rect(11, 4, 10, 3, HAIR)
	p_dot(14, 8, DARK)
	p_dot(18, 8, DARK)
	p_rect(8, 12 + off, 4, 8, BLUE)
	p_rect(20, 12 - off, 4, 8, BLUE)
	p_rect(11, 22, 4, 7 - off, BOOT)
	p_rect(17, 22, 4, 7 + off, BOOT)
	p_rect(24, 9 - off, 3, 13, STEEL)
	p_dot(26, 8 - off, STEEL)

func _draw_slash(step: int) -> void:
	var colors := [Color(1, 1, 1, 0.82), Color(1, 0.91, 0.47, 0.78), Color(1, 0.63, 0.27, 0.63), TRANSPARENT]
	var c := colors[step]
	for i in range(4 + step * 3):
		p_dot(8 + i, 22 - int(i / 2), c)
	for i in range(10 + step * 2):
		p_dot(9 + i, 20 - i, c)

func _draw_slime(step: int) -> void:
	var squish := [0, 1, 0, -1][step]
	p_circle(16, 18 + squish, 10, SLIME)
	p_rect(7, 18 + squish, 18, 9, SLIME)
	p_rect(8, 25, 16, 3, SLIME_DARK)
	p_dot(12, 17 + squish, DARK)
	p_dot(20, 17 + squish, DARK)
	p_rect(13, 22 + squish, 6, 2, SLIME_DARK)
	p_dot(11, 13 + squish, SLIME_SHINE)

func _draw_bat(step: int) -> void:
	var yoff := [0, -2, 0, 2][step]
	p_circle(16, 15 + yoff, 5, BAT)
	p_rect(13, 13 + yoff, 6, 10, BAT)
	p_rect(5, 10 + yoff, 8, 4, BAT_WING)
	p_rect(19, 10 + yoff, 8, 4, BAT_WING)
	p_rect(7, 14 + yoff, 4, 5, BAT_WING)
	p_rect(21, 14 + yoff, 4, 5, BAT_WING)
	p_dot(14, 15 + yoff, RED_EYE)
	p_dot(18, 15 + yoff, RED_EYE)

func _draw_bolt() -> void:
	p_rect(2, 6, 9, 4, Color(1.0, 0.867, 0.251, 1.0))
	p_rect(11, 4, 4, 8, Color(1, 0.55, 0.13, 0.86))

func _draw_gem() -> void:
	p_rect(6, 2, 4, 4, Color(0.251, 0.902, 1.0, 1.0))
	p_rect(4, 6, 8, 4, Color(0.125, 0.588, 0.863, 1.0))
	p_rect(6, 10, 4, 4, Color(0.251, 0.902, 1.0, 1.0))
	p_dot(7, 4, Color(0.824, 1.0, 1.0, 1.0))

func _draw_tree() -> void:
	p_rect(13, 8, 6, 17, Color(0.333, 0.216, 0.133, 1.0))
	p_circle(16, 9, 9, Color(0.169, 0.463, 0.243, 1.0))
	p_circle(10, 14, 6, Color(0.141, 0.388, 0.212, 1.0))
	p_circle(22, 14, 6, Color(0.196, 0.569, 0.282, 1.0))

func _draw_rock() -> void:
	p_circle(16, 20, 9, Color(0.361, 0.388, 0.412, 1.0))
	p_rect(8, 21, 17, 6, Color(0.235, 0.255, 0.282, 1.0))
	p_dot(12, 15, Color(0.549, 0.580, 0.588, 1.0))

func _draw_flower() -> void:
	p_rect(14, 12, 3, 14, Color(0.118, 0.431, 0.180, 1.0))
	p_circle(12, 11, 4, Color(0.863, 0.325, 0.518, 1.0))
	p_circle(20, 12, 4, Color(1.0, 0.847, 0.345, 1.0))

func _draw_ruin() -> void:
	p_rect(8, 10, 16, 15, Color(0.306, 0.314, 0.361, 1.0))
	p_rect(11, 6, 10, 4, Color(0.439, 0.447, 0.502, 1.0))
	p_rect(13, 14, 6, 11, Color(0.137, 0.149, 0.188, 1.0))
