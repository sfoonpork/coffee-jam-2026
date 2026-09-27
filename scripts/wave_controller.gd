class_name WaveController
extends Node2D

const UPGRADE_UI = preload("uid://cey3pfs0nq3gy")

@export var waves: Array[WaveStats]

var wave_index: int = 0
var in_intermission: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.wave_defeated.connect(end_wave)
	Signals.upgrade_chosen.connect(start_wave)
	
	start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_wave() -> void:
	print("Starting wave: " + waves[wave_index].name)
	Signals.wave_started.emit(waves[wave_index])


func end_wave() -> void:
	# TODO open upgrade window or something
	print("wave defeated")
	wave_index += 1
	if wave_index == waves.size():
		GameData.end_state = "You won!"
		Signals.game_defeated.emit()
		return
	var upgrade_ui: UpgradeUI = UPGRADE_UI.instantiate()
	add_child(upgrade_ui)
	
	pass
