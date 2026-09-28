class_name WaveController
extends Node2D

#const UPGRADE_UI = preload("uid://cey3pfs0nq3gy")

@export var game_ui: GameUI
@export var upgrade_ui: UpgradeUI
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
	game_ui.set_wave_text("WAVE " + str(wave_index + 1))
	if wave_index + 1 == waves.size():
		game_ui.set_wave_text("FINAL WAVE")
		
	SoundManager.play(position, preload("uid://el6yecnhnc0b"), -6.0, 1.0)
	


func end_wave() -> void:
	
	# TODO open upgrade window or something
	print("wave defeated")
	wave_index += 1
	
	
	if wave_index == waves.size():
		GameData.end_state = "You won!"
		Signals.game_defeated.emit()
		return
	
	upgrade_ui.prompt(1)
	
	pass
