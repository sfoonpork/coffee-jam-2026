class_name UpgradeUI
extends CanvasLayer

@export var upgrade_pool: Array[UpgradeWeightTuple]
const CARD_UI = preload("uid://dia2yamwblh47")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var num_cards = 3
	var num_valid_cards = 0
	for upgrade_tuple in upgrade_pool:
		if upgrade_tuple.upgrade.modifiers.size() != 0:
			num_valid_cards += 1
	for i in range(min(num_cards, num_valid_cards)):
		var card_ui: CardUI = CARD_UI.instantiate()
		card_ui.position = Vector2((i - num_cards/2) * 384.0 - card_ui.size.x/2.0, -card_ui.size.y/2.0)
		randomize_upgrade(card_ui)
		add_child(card_ui)

	get_tree().paused = true


func randomize_upgrade(card_ui: CardUI) -> void:
	
	if upgrade_pool.size() == 0:
		return
		
	var total_weight: int = 0
	for upgrade_tuple in upgrade_pool:
		total_weight += upgrade_tuple.weight
	
	var target: int = randi_range(0, total_weight)
	
	for i in range(upgrade_pool.size()):
		var upgrade_tuple = upgrade_pool[i]
		target -= upgrade_tuple.weight
		if target <= 0:
			var upgrade = upgrade_tuple.upgrade
			card_ui.text = upgrade.name + "\n"
			for modifier in upgrade.modifiers:
				card_ui.text += modifier.property + ": " + str(UpgradeModifier.OPERATION.keys()[modifier.operation]) + " " + str(modifier.value)
			card_ui.pressed.connect(func(): select_upgrade(upgrade))
			upgrade_pool.remove_at(i)
			return


func select_upgrade(upgrade: UpgradeStats) -> void:
	
	for modifier in upgrade.modifiers:
		Signals.add_player_stat.emit(modifier.property, modifier.value)
		
	get_tree().paused = false
	Signals.upgrade_chosen.emit()
	queue_free()
