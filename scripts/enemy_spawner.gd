extends Node2D

const LEFT_BOUND = 0.0
const RIGHT_BOUND = 1280.0
const UPPER_BOUND = 0.0
const LOWER_BOUND = 720.0
const MIN_SPAWN_DISTANCE = 180.0

@export var enemy_scene: PackedScene

var duration: float = 4.0
var timer: float = 0.0

var enemy_positions_x: Array[float]
var enemy_positions_y: Array[float]

@onready var player: Player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.boss_defeated.connect(on_boss_defeated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		timer += duration
		spawn_enemy()


func spawn_enemy() -> void:
	if not player:
		return
	var enemy: Enemy = enemy_scene.instantiate()
	var position_x: float = randf_range(LEFT_BOUND, RIGHT_BOUND)
	var position_y: float = randf_range(UPPER_BOUND, LOWER_BOUND)
	var x_diff = position_x - player.position.x
	var y_diff = position_y - player.position.y
	
	if absf(x_diff) < MIN_SPAWN_DISTANCE:
		if x_diff <= 0.0:  # spawned to the left
			if position_x < LEFT_BOUND + MIN_SPAWN_DISTANCE:
				position_x = player.position.x + absf(x_diff) + MIN_SPAWN_DISTANCE
			else:
				position_x -= MIN_SPAWN_DISTANCE
		else:  # spawned to the right
			if position_x > RIGHT_BOUND - MIN_SPAWN_DISTANCE:
				position_x = player.position.x - absf(x_diff) - MIN_SPAWN_DISTANCE
			else:
				position_x += MIN_SPAWN_DISTANCE
	
	if absf(y_diff) < MIN_SPAWN_DISTANCE:
		if y_diff <= 0.0:  # spawned above
			if position_y < UPPER_BOUND + MIN_SPAWN_DISTANCE:
				position_y = player.position.y + absf(y_diff) + MIN_SPAWN_DISTANCE
			else:
				position_y -= MIN_SPAWN_DISTANCE
		else:  # spawned below
			if position_y > LOWER_BOUND - MIN_SPAWN_DISTANCE:
				position_y = player.position.y - absf(y_diff) - MIN_SPAWN_DISTANCE
			else:
				position_y += MIN_SPAWN_DISTANCE
	enemy.position = Vector2(position_x, position_y)
	enemy_positions_x.append(position_x)
	enemy_positions_y.append(position_y)
	enemy.modulate = Color.RED  # TODO delete when we have enemy sprites
	
	add_child(enemy)
	Signals.enemy_spawned.emit()
	print(enemy.stats.name + " spawned at " + str(enemy.position))


func on_enemy_spawned() -> void:
	pass


func on_boss_defeated() -> void:
	print("boss was defeated")
