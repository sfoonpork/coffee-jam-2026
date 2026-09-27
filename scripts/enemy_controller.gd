class_name Enemy
extends Entity

var enemy_types: Array[EnemyStats] = [preload("uid://d3r0qmikupetq"), preload("uid://cg3ytuokfahcp"), preload("uid://bsroal1ol5i62"), preload("uid://bj8cnvcn4nat")]

@onready var player: Player = get_tree().get_first_node_in_group("player")

var timer: float = 1.0
var duration: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	stats = enemy_types.pick_random()
	stats = stats.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if player:
		var player_direction: Vector2 = (player.position - position).normalized()
		#position += player_direction * stats.speed * delta
		super.move(player_direction)
		timer -= delta
		while timer < 0.0:
			timer += duration
			shoot(player_direction, "Enemy", Color.RED)


func _on_area_2d_body_entered(body: Player) -> void:
	body.take_damage(60.0)
	# TODO: knockback for damage
	GameData.enemies_killed += 1
	queue_free()
	pass # Replace with function body.


func die() -> void:
	super.die()
	GameData.enemies_killed += 1
