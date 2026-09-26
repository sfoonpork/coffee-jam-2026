extends Node2D

@export var enemy_scene: PackedScene

var duration: float = 4.0
var timer: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.boss_defeated.connect(on_boss_defeated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		timer += duration
		spawn_enemy()
	pass

func spawn_enemy() -> void:
	var enemy: Node2D = enemy_scene.instantiate()
	enemy.modulate = Color.RED  # TODO delete when we have enemy sprites
	var position_x: float = randf_range(0, 1080)
	var position_y: float = randf_range(0, 720)
	enemy.position = Vector2(position_x, position_y)
	add_child(enemy)
	Signals.enemy_spawned.emit()
	print("spawned")

func on_enemy_spawned() -> void:
	pass

func on_boss_defeated() -> void:
	print("boss was defeated")
