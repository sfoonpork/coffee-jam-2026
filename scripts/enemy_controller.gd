class_name Enemy
extends Entity

var enemy_types: Array[EnemyStats] = [preload("uid://d3r0qmikupetq"), preload("uid://cg3ytuokfahcp"), preload("uid://bsroal1ol5i62"), preload("uid://bj8cnvcn4nat")]

@onready var player: Player = get_tree().get_first_node_in_group("player")

var timer: float = 1.0
#var duration: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	stats = enemy_types.pick_random()
	stats = stats.duplicate()
	stats.health = stats.max_health
	ui.set_health_color(Color.RED)


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
				shoot(player_direction, "enemy", Color.RED)


func _on_area_2d_body_entered(body: Player) -> void:
	
	var direction: Vector2 = body.position - self.position
	body.take_knockback(direction.normalized() * 500.0)
	self.take_knockback(-direction.normalized() * 500.0)
	
	var damage: float = 10.0
	body.take_damage(damage)
	self.take_damage(damage)


func die() -> void:
	GameData.enemies_killed += 1
	super()
