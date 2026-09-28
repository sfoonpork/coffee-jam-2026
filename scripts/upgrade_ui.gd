class_name UpgradeUI
extends CanvasLayer

@export var upgrade_pool: Array[UpgradeWeightTuple]
var curr_upgrade_pool: Array[UpgradeWeightTuple]

const CARD_UI = preload("uid://dia2yamwblh47")

var card_uis: Array[CardUI]
var seen: Dictionary

func _ready() -> void:
	curr_upgrade_pool = upgrade_pool.duplicate()
	seen = {}

func prompt(amount: int, promotion: bool) -> void:
	
	var num_cards = 3
	for i in range(num_cards):
		var card_ui: CardUI = CARD_UI.instantiate()
		card_ui.position = Vector2((i - num_cards/2) * 384.0 - card_ui.size.x/2.0, -card_ui.size.y/2.0)
		card_uis.append(card_ui)
		randomize_upgrades(card_ui, amount, promotion)
		add_child(card_ui)

	get_tree().paused = true


func randomize_upgrades(card_ui: CardUI, remaining: int, promotion: bool) -> void:
	
	
	if upgrade_pool.size() == 0:
		return
		
	var total_weight: int = 0
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		total_weight += upgrade_tuple.weight
	
	var target: int = randi_range(0, total_weight)
	
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		target -= upgrade_tuple.weight
		if target <= 0:
			var upgrade = upgrade_tuple.upgrade
			card_ui.text = upgrade.name + "\n"
			for modifier in upgrade.modifiers:
				card_ui.text += "\n" + modifier.property + ": " + str(UpgradeModifier.OPERATION.keys()[modifier.operation]) + " " + str(modifier.value)
			card_ui.pressed.connect(func(): select_upgrade(upgrade, remaining, promotion))
			seen[upgrade_tuple] = true
			return


func select_upgrade(upgrade: UpgradeStats, remaining: int, promotion: bool) -> void:
	
	for modifier in upgrade.modifiers:
		Signals.add_player_stat.emit(modifier.property, modifier.value)
	
	for upgrade_tuple in curr_upgrade_pool:
		if upgrade_tuple.upgrade == upgrade:
			continue
		upgrade_tuple.weight *= 2.0
	
	remaining -= 1
	
	for card_ui in card_uis:
		card_ui.queue_free()
	card_uis.clear()
	
	if remaining == 0:
		get_tree().paused = false
		Signals.upgrade_chosen.emit()
		seen = {}
		if promotion:
			promote()
	else:
		prompt(remaining, promotion)


func promote() -> void:
	print("promotion")
	pass
