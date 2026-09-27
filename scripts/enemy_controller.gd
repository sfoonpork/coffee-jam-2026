class_name Enemy
extends RigidBody2D

@export var speed: float = 100.0

var stats: EnemyStats
var enemy_types: Array[EnemyStats] = [preload("uid://d3r0qmikupetq"), preload("uid://cg3ytuokfahcp"), preload("uid://bsroal1ol5i62"), preload("uid://bj8cnvcn4nat")]

@onready var player: Player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = enemy_types.pick_random()
	stats = stats.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		var player_direction: Vector2 = (player.position - position).normalized()
		position += player_direction * stats.speed * delta


func _on_area_2d_body_entered(body: Player) -> void:
	body.take_damage(50.0)
	# TODO: knockback for damage
	queue_free()
	pass # Replace with function body.


func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health <= 0.0:
		queue_free()
