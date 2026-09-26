extends Node2D

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
	print("spawned")

func on_enemy_spawned() -> void:
	pass

func on_boss_defeated() -> void:
	print("boss was defeated")
