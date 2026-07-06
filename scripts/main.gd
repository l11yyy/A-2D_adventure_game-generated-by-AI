extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_radius := 620.0
@export var world_half_size := Vector2(1600, 1100)

@onready var player: Player = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud_label: Label = $CanvasLayer/HUD
@onready var scenery_root: Node2D = $World/Scenery

func _ready() -> void:
	player.stats_changed.connect(_on_player_stats_changed)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	build_scenery()

func build_scenery() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 20260706
	for index in range(90):
		var prop := PixelSprite.new()
		var kinds := ["tree", "rock", "flower", "ruin"]
		prop.sprite_kind = kinds[rng.randi_range(0, kinds.size() - 1)]
		prop.position = Vector2(
			rng.randf_range(-world_half_size.x + 80.0, world_half_size.x - 80.0),
			rng.randf_range(-world_half_size.y + 80.0, world_half_size.y - 80.0)
		)
		prop.pixel_size = rng.randf_range(1.8, 3.0)
		prop.z_index = 0
		scenery_root.add_child(prop)

func _on_spawn_timer_timeout() -> void:
	if enemy_scenes.is_empty():
		return
	var enemy := enemy_scenes.pick_random().instantiate()
	var angle := randf() * TAU
	var spawn_position := player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
	spawn_position.x = clamp(spawn_position.x, -world_half_size.x, world_half_size.x)
	spawn_position.y = clamp(spawn_position.y, -world_half_size.y, world_half_size.y)
	enemy.global_position = spawn_position
	add_child(enemy)

func _on_player_stats_changed(level: int, xp: int, xp_to_next: int, hp: int, max_hp: int) -> void:
	hud_label.text = "Level %d  XP %d/%d  HP %d/%d\nWASD移动  J近战  K远程" % [level, xp, xp_to_next, hp, max_hp]
