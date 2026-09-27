extends Control

@onready var enemies_killed_label: Label = $EnemiesKilledLabel
@onready var bullets_fired_label: Label = $BulletsFiredLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_killed_label.text = "Enemies Killed: " + str(GameData.enemies_killed)
	bullets_fired_label.text = "Bullets Fired: " + str(GameData.bullets_fired)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GameData.reset()
		get_tree().change_scene_to_file.call_deferred("res://scenes/world.tscn")
