extends Area2D
class_name Projectile

@export var speed := 420.0
@export var lifetime := 1.4
var direction := Vector2.RIGHT
var damage := 10

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta
	rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and not body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
