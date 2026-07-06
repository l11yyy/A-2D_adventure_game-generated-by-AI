extends CharacterBody2D
class_name Player

signal stats_changed(level: int, xp: int, xp_to_next: int, hp: int, max_hp: int)

@export var speed := 220.0
@export var max_hp := 120
@export var melee_damage := 14
@export var ranged_damage := 9
@export var xp_to_next_level := 5
@export var projectile_scene: PackedScene

var hp := max_hp
var level := 1
var xp := 0
var last_facing := Vector2.RIGHT

@onready var melee_area: Area2D = $MeleeArea
@onready var melee_shape: CollisionShape2D = $MeleeArea/CollisionShape2D
@onready var ranged_cooldown: Timer = $RangedCooldown
@onready var melee_cooldown: Timer = $MeleeCooldown

func _ready() -> void:
	hp = max_hp
	melee_shape.disabled = true
	emit_stats()

func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length() > 0.0:
		last_facing = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()
	rotation = 0.0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack_melee") and melee_cooldown.is_stopped():
		perform_melee_attack()
	if Input.is_action_pressed("attack_ranged") and ranged_cooldown.is_stopped():
		perform_ranged_attack()

func perform_melee_attack() -> void:
	melee_cooldown.start()
	melee_area.rotation = last_facing.angle()
	melee_shape.disabled = false
	await get_tree().create_timer(0.12).timeout
	melee_shape.disabled = true

func perform_ranged_attack() -> void:
	if projectile_scene == null:
		return
	ranged_cooldown.start()
	var projectile := projectile_scene.instantiate()
	projectile.global_position = global_position + last_facing * 28.0
	projectile.direction = last_facing
	projectile.damage = ranged_damage
	get_tree().current_scene.add_child(projectile)

func gain_xp(amount: int) -> void:
	xp += amount
	while xp >= xp_to_next_level:
		xp -= xp_to_next_level
		level_up()
	emit_stats()

func level_up() -> void:
	level += 1
	xp_to_next_level = int(ceil(xp_to_next_level * 1.45))
	max_hp += 12
	hp = max_hp
	melee_damage += 3
	ranged_damage += 2
	speed += 5.0

func take_damage(amount: int) -> void:
	hp = max(hp - amount, 0)
	emit_stats()
	if hp == 0:
		get_tree().reload_current_scene()

func emit_stats() -> void:
	stats_changed.emit(level, xp, xp_to_next_level, hp, max_hp)

func _on_melee_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(melee_damage)
