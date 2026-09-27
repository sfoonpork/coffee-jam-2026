class_name Entity
extends CharacterBody2D

var stats: EntityStats
var move_direction: Vector2 = Vector2.ZERO

var accel: Vector2 = Vector2.ZERO
var accel_speed: float = 50.0
var max_speed: float = 250.0

func move(accel: Vector2) -> void:
	
	if accel.length_squared() > 0.0:
		move_direction += accel.normalized() * accel_speed
		if move_direction.length() > max_speed:
			move_direction = move_direction.normalized() * max_speed
	else:
		if move_direction.length_squared() > 0.0:
			var move_direction_last = move_direction
			move_direction -= move_direction.normalized() * accel_speed
			if move_direction.dot(move_direction_last) <= 0.0:
				move_direction = Vector2.ZERO
	
	self.set_velocity(move_direction)
	move_and_slide()
	

func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health <= 0.0:
		print(3)
		die()
		queue_free()

func die() -> void:
	pass
