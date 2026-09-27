extends Node


var enemies_killed: int = 0
var bullets_fired: int = 0
var end_state: String = ""


func reset() -> void:
	enemies_killed = 0
	bullets_fired = 0
