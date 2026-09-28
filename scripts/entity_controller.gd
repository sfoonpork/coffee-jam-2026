class_name Entity
extends CharacterBody2D

var ui: EntityUI

var stats: EntityStats
var move_direction: Vector2 = Vector2.ZERO
var accel_speed: float = 2500.0
#var health_regen_rate: float = 10.0

var knockback_direction: Vector2 = Vector2.ZERO
var rotation_velocity: float = 0.0

var sprite: Sprite2D

func _ready() -> void:
	sprite = $Sprite2D
	ui = preload("uid://cqi08xmfgs818").instantiate()
	add_child(ui)
	pass

var phase = 0.0

func _process(delta: float) -> void:
	var target_rotation = move_direction.x / 250.0 * PI / 6.0
	rotation_velocity += (target_rotation - sprite.rotation) * 8.0 * delta
	rotation_velocity += (0 - rotation_velocity) * 8.0 * delta
	sprite.rotation += rotation_velocity
	
	phase += delta * move_direction.length() / 250.0 * 2.0
	phase = fmod(phase, 1.0)
	var x = sin(phase * 2.0 * PI)
	var y = cos(phase * 2.0 * PI * 2.0)
	if stats.speed > 0.0:
		sprite.position = Vector2(x * 2.0, y * -2.0) * move_direction.length() / stats.speed
	
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
	stats.health += stats.health_regen_rate * delta
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
	SoundManager.play(self.position, preload("uid://d2a8e5a8bv8mw"), 0.0, 1.0 + randf() * 3.0)
	if stats.health <= 0.0:
		die()


func die() -> void:
	SoundManager.play(self.position, preload("uid://beyg3eg8ccc70"), 0.0, 1.0 + randf())
	queue_free()
