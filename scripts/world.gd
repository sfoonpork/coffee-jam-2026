extends Node2D

@export var bullet_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.bullet_spawned.connect(on_bullet_spawn)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_bullet_spawn(origin: Vector2, direction: Vector2, ignore: String) -> void:
	
	var bullet: Bullet = bullet_scene.instantiate()
	#bullet.setup(position, direction, ignore)
	bullet.position = origin + direction.normalized() * 32.0
	bullet.direction = direction
	bullet.ignore = ignore
	add_child(bullet)
	pass
