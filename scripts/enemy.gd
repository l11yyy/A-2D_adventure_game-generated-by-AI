extends CharacterBody2D
class_name Enemy

@export var speed := 85.0
@export var max_hp := 28
@export var contact_damage := 8
@export var xp_value := 1
@export var xp_gem_scene: PackedScene
@export var flying := false

@onready var sprite: Sprite2D = $Sprite2D

var hp := max_hp
var target: Node2D

func _ready() -> void:
	hp = max_hp
	target = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	var direction := global_position.direction_to(target.global_position)
	velocity = direction * speed
	move_and_slide()
	animate_enemy(direction)

func animate_enemy(direction: Vector2) -> void:
	if direction.x != 0.0:
		sprite.flip_h = direction.x < 0.0
	sprite.frame = int(Time.get_ticks_msec() / (90 if flying else 180)) % 4

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	if xp_gem_scene != null:
		var gem := xp_gem_scene.instantiate()
		gem.global_position = global_position
		gem.xp_value = xp_value
		get_tree().current_scene.call_deferred("add_child", gem)
	queue_free()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(contact_damage)
