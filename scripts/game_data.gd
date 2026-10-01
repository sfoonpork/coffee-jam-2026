extends Node

enum EndState {DEFEATED, WON}

var enemies: Array[Enemy] = []
var enemies_killed: int = 0
var bullets_fired: int = 0
var end_state: EndState
var wave_index: int = 0
var player_stats: PlayerStats




func reset() -> void:
	enemies_killed = 0
	bullets_fired = 0
	wave_index = 0
	enemies = []
	player_stats = null
