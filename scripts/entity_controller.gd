class_name Entity
extends CharacterBody2D

var ui: EntityUI

var stats: EntityStats
var move_direction: Vector2 = Vector2.ZERO
var accel_speed: float = 2500.0
var health_regen_rate: float = 10.0

var knockback_direction: Vector2 = Vector2.ZERO

var sprite: Sprite2D

func _ready() -> void:
	sprite = $Sprite2D
	ui = preload("uid://cqi08xmfgs818").instantiate()
	add_child(ui)
	pass


func _process(delta: float) -> void:
	sprite.rotate(move_direction.normalized().x * PI * 2.0 * delta)
	regen_health_tick(delta)
	ui.set_health(stats.health)
	
	
	if knockback_direction.length_squared() > 0.0:
		var knockback_direction_last = knockback_direction
		knockback_direction -= knockback_direction.normalized() * accel_speed * delta
		if knockback_direction.dot(knockback_direction_last) <= 0.0:
			knockback_direction = Vector2.ZERO
			
	
	self.set_velocity(knockback_direction)
	move_and_slide()
	
	
	
func regen_health_tick(delta: float) -> void:
	stats.health += health_regen_rate * delta
	if stats.health >= stats.max_health:
		stats.health = stats.max_health


func move(accel: Vector2, delta: float) -> void:
	
	if accel.length_squared() > 0.0:
		move_direction += accel.normalized() * accel_speed * delta
		if move_direction.length() > stats.speed:
			move_direction = move_direction.normalized() * stats.speed
	else:
		if move_direction.length_squared() > 0.0:
			var move_direction_last = move_direction
			move_direction -= move_direction.normalized() * accel_speed * delta
			if move_direction.dot(move_direction_last) <= 0.0:
				move_direction = Vector2.ZERO
	
	self.set_velocity(move_direction)
	move_and_slide()


func fire(direction: Vector2, ignore: String, color: Color) -> void:
	
	var bullet: Bullet = preload("uid://datv25v5nu10j").instantiate()
	bullet.position = position + direction.normalized() * 32.0
	bullet.direction = direction
	bullet.ignore = ignore
	bullet.modulate = color
	bullet.speed = stats.bullet_speed
	
	add_sibling(bullet)
	
	GameData.bullets_fired += 1


func take_knockback(direction: Vector2) -> void:
	knockback_direction += direction


func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health <= 0.0:
		die()


func die() -> void:
	var death_sfx: AudioStreamMP3 = preload("uid://beyg3eg8ccc70")
	var death_sound = AudioStreamPlayer2D.new()
	#death_sound.volume_db += 12.0
	death_sound.pitch_scale = 1.0 + randf()
	death_sound.stream = death_sfx
	add_sibling(death_sound)
	death_sound.finished.connect(func(): queue_free())
	death_sound.play()
	queue_free()
