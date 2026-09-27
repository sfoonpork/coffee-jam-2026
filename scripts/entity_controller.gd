class_name Entity
extends CharacterBody2D

var stats: EntityStats
var move_direction: Vector2 = Vector2.ZERO
var accel_speed: float = 50.0
var health_regen_rate: float = 0.0

var sprite: Sprite2D

func _ready() -> void:
	sprite = $Sprite2D
	pass


func _process(delta: float) -> void:
	sprite.rotate(move_direction.normalized().x * PI * 2.0 * delta)
	regen_health_tick(delta)


func regen_health_tick(delta: float) -> void:
	stats.health += health_regen_rate + delta
	if stats.health >= stats.max_health:
		stats.health = stats.max_health


func move(accel: Vector2) -> void:
	if accel.length_squared() > 0.0:
		move_direction += accel.normalized() * accel_speed
		if move_direction.length() > stats.speed:
			move_direction = move_direction.normalized() * stats.speed
	else:
		if move_direction.length_squared() > 0.0:
			var move_direction_last = move_direction
			move_direction -= move_direction.normalized() * accel_speed
			if move_direction.dot(move_direction_last) <= 0.0:
				move_direction = Vector2.ZERO
	
	self.set_velocity(move_direction)
	move_and_slide()
	


func shoot(direction: Vector2) -> void:
	
	var bullet: Bullet = preload("uid://datv25v5nu10j").instantiate()
	bullet.position = position + direction.normalized() * 32.0
	bullet.direction = direction
	bullet.ignore = "player"
	add_sibling(bullet)
	
	GameData.bullets_fired += 1
	print("fired")


func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health <= 0.0:
		print(3)
		die()
		queue_free()


func die() -> void:
	pass
