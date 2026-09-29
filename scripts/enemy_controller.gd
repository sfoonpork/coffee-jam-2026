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
	stats.health = stats.max_health
	ui.set_health_color(Color.RED)
	stats.bullet_speed_factor = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if player:
		var player_direction: Vector2 = (player.position - position).normalized()
		super.move(player_direction, delta)
		if stats.fire_rate > 0.0:
			timer -= delta
			while timer < 0.0:
				timer += 1.0 / stats.fire_rate
				fire(player_direction, 1.0, 0.0, "enemy", Color.RED)


func _on_area_2d_body_entered(body: Player) -> void:
	
	var direction: Vector2 = body.position - self.position
	body.take_knockback(direction.normalized() * 500.0)
	self.take_knockback(-direction.normalized() * 500.0)
	
	var damage: float = max(body.stats.health, self.stats.health)
	body.take_damage(damage)
	self.take_damage(damage)


func die() -> void:
	if is_dying:
		return
	
	is_dying = true
	GameData.enemies_killed += 1
	Signals.enemy_killed.emit()
	super()
