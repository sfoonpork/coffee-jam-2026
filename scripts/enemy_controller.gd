class_name Enemy
extends Entity

var enemy_type: EnemyStats

var timer: float = 0.0

var is_dying: bool = false

@onready var player: Player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	stats = enemy_type
	stats = stats.duplicate()
	
	var bonus_multiplier = GameData.wave_index
	stats.max_health += stats.bonus_max_health * bonus_multiplier
	stats.speed += stats.bonus_speed * bonus_multiplier
	stats.fire_rate += stats.bonus_fire_rate * bonus_multiplier
	stats.bullet_chocolate_count += stats.bonus_bullet_chocolate_count * bonus_multiplier
	stats.bullet_espresso_count += stats.bonus_bullet_espresso_count * bonus_multiplier
	stats.bullet_milk_count += stats.bonus_bullet_milk_count * bonus_multiplier
	stats.bullet_speed += stats.bonus_bullet_speed * bonus_multiplier
	stats.health_regen_rate += stats.bonus_health_regen_rate * bonus_multiplier
	
	stats.speed *= randf_range(0.8, 1.2)
	
	stats.health = stats.max_health
	ui.set_health_color(Color.RED)
	stats.bullet_damage_factor = 1
	
	GameData.enemies.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if player:
		var player_direction: Vector2 = (player.position - position).normalized()
		var boid_direction: Vector2 = Vector2.ZERO
		for enemy in GameData.enemies:
			boid_direction += (position - enemy.position)
		#boid_direction /= GameData.enemies.
		
		
		
		super.move(player_direction, delta)
		if stats.fire_rate > 0.0:
			timer -= delta
			while timer < 0.0:
				timer += 1.0 / stats.fire_rate
				fire_all(player_direction, "enemy", Color.RED)


func _on_area_2d_body_entered(body: Player) -> void:
	
	var direction: Vector2 = body.position - self.position
	body.take_knockback(direction.normalized() * 500.0)
	self.take_knockback(-direction.normalized() * 500.0)
	
	body.take_damage(self.stats.body_damage)
	self.take_damage(body.stats.body_damage)


func die() -> void:
	if is_dying:
		return
	
	is_dying = true
	GameData.enemies_killed += 1
	Signals.enemy_killed.emit()
	super()
