extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius := 620.0
@export var world_half_size := Vector2(1600, 1100)

@onready var player: Player = $Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud_label: Label = $CanvasLayer/HUD

func _ready() -> void:
	player.stats_changed.connect(_on_player_stats_changed)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if enemy_scene == null:
		return
	var enemy := enemy_scene.instantiate()
	var angle := randf() * TAU
	var spawn_position := player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
	spawn_position.x = clamp(spawn_position.x, -world_half_size.x, world_half_size.x)
	spawn_position.y = clamp(spawn_position.y, -world_half_size.y, world_half_size.y)
	enemy.global_position = spawn_position
	add_child(enemy)

func _on_player_stats_changed(level: int, xp: int, xp_to_next: int, hp: int, max_hp: int) -> void:
	hud_label.text = "Level %d  XP %d/%d  HP %d/%d\nWASD移动  J近战  K远程" % [level, xp, xp_to_next, hp, max_hp]
