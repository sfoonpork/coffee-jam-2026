class_name GameUI
extends CanvasLayer

var time: float = 0.0
var position_start: Vector2

func _ready() -> void:
	position_start = $WaveLabel.position
	
func set_wave_text(msg: String) -> void:
	$WaveLabel.text = msg
	time = 0.0

func _process(delta: float) -> void:
	time += delta
	
	var anim_in = ease(time, -4.0)
	var anim_land = -ease(time / 4.0, -4.0) / 2.0
	var anim_out = -ease(time / 8.0, -2.0)
	var a = anim_in + anim_out
	var scale = anim_in + anim_land
	
	#$WaveLabel.set("theme_override_font_sizes/font_size", 48.0  scale)
	#$WaveLabel.set("theme_override_font_sizes/font_size", 48.0  scale)
	#$WaveLabel.set("theme_override_font_sizes/font_size", 48.0  scale)
	$WaveLabel.position.y = position_start.y + (anim_in + anim_land) * 32.0
	$WaveLabel.modulate.a = (a + 1.0)/2.0
	$StatsLabel.text = "BULLETS FIRED: " + str(GameData.bullets_fired) + "\nENEMIES KILLED: " + str(GameData.enemies_killed)
	$StatsLabel.modulate.a = 0.5
