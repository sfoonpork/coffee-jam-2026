class_name EnemySpawner
extends Node2D

const LEFT_BOUND = 16.0
const RIGHT_BOUND = 1280.0
const UPPER_BOUND = 16.0
const LOWER_BOUND = 720.0
const MIN_SPAWN_DISTANCE = 175.0

@export var enemy_scene: PackedScene

var is_spawning: bool = false
var spawn_timer: Timer
var cur_wave: WaveStats
var enemies_to_spawn: Array[EnemyStats]
var enemies_left: int

var duration: float = 4.0
var timer: float = 0.0

var enemy_positions_x: Array[float]
var enemy_positions_y: Array[float]

@onready var player: Player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.boss_defeated.connect(on_boss_defeated)
	Signals.wave_started.connect(start_wave)
	Signals.enemy_killed.connect(on_enemy_killed)
	
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.one_shot = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	#enemy.modulate = Color.RED  # TODO delete when we have enemy sprites
	enemy.enemy_type = enemies_to_spawn.pop_back()
	
	add_child(enemy)
	move_child(enemy, -1)
	Signals.enemy_spawned.emit()
	enemies_left += 1
	if enemies_to_spawn.size() == 0:
		spawn_timer.stop()
	print(enemy.stats.name + " spawned at " + str(enemy.position))


# Old weighted functionality
#func get_enemy_type() -> EnemyStats:
	#var total_weight: int = 0
	#for enemy_tuple in cur_wave.enemy_pool:
		#total_weight += enemy_tuple.weight
	#
	#var target: int = randi_range(0, total_weight)
	#
	#for enemy_tuple in cur_wave.enemy_pool:
		#target -= enemy_tuple.weight
		#if target <= 0:
			#return enemy_tuple.enemy
	#
	#return null


func start_wave(new_wave: WaveStats) -> void:
	cur_wave = new_wave
	is_spawning = true
	
	for enemy_tuple in cur_wave.enemy_pool:
		for i in enemy_tuple.count:
			enemies_to_spawn.append(enemy_tuple.enemy)
	enemies_to_spawn.shuffle()
	
	spawn_timer.start(cur_wave.spawn_time)


func on_enemy_killed() -> void:
	enemies_left -= 1
	print("enemies_left: " + str(enemies_left))
	if enemies_to_spawn.size() == 0 and enemies_left == 0:
		Signals.wave_defeated.emit()


func on_boss_defeated() -> void:
	print("boss was defeated")
