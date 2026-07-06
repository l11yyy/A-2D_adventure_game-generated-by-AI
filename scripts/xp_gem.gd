extends Area2D
class_name XPGem

@export var xp_value := 1
@export var magnet_distance := 120.0
@export var magnet_speed := 260.0

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var distance := global_position.distance_to(player.global_position)
	if distance < magnet_distance:
		global_position = global_position.move_toward(player.global_position, magnet_speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("gain_xp"):
		body.gain_xp(xp_value)
		queue_free()
