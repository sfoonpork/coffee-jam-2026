extends Node


func play(position: Vector2, sfx: AudioStreamMP3, volume: float, pitch: float) -> void:
	var sound = AudioStreamPlayer2D.new()
	sound.volume_db = volume
	sound.pitch_scale = pitch
	sound.stream = sfx
	get_tree().root.add_child(sound)
	sound.finished.connect(func(): sound.queue_free())
	sound.play()
