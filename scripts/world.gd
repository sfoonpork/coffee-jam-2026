extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.player_died.connect(on_player_death)
	Signals.game_defeated.connect(on_player_death)  # TODO change this if can't beat game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_player_death() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/end_screen.tscn")
