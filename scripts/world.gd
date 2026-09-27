extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.player_died.connect(on_player_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_player_death() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/end_screen.tscn")
