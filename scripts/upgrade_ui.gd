class_name UpgradeUI
extends CanvasLayer

@export var upgrade_pool: Array[UpgradeWeightTuple]
var curr_upgrade_pool: Array[UpgradeWeightTuple]

const CARD_UI = preload("uid://dia2yamwblh47")

var card_uis: Array[CardUI]
var seen: Dictionary

var root: CoffeeClassNode = preload("uid://d285d026kt5lc")
var curr = root

func _ready() -> void:
	curr_upgrade_pool = upgrade_pool.duplicate()
	seen = {}


func lay_out_cards(num_cards: int) -> Array[CardUI]:
	
	var curr_card_uis: Array[CardUI] = []
	var dist: float = 256.0 + 32.0
	var offset: float = 0.0
	if num_cards % 2 == 0:
		offset += 0.5
	offset -= int(num_cards/2)
	
	var start_x = dist * offset
	
	for i in range(num_cards):
		
		var card_ui: CardUI = CARD_UI.instantiate()
		
		card_ui.position = Vector2(start_x + dist * i - card_ui.size.x/2.0, -card_ui.size.y/2.0)
		curr_card_uis.append(card_ui)
		add_child(card_ui)
		
	return curr_card_uis


func prompt(amount: int, promotion: bool) -> void:
	
	var num_cards: int = randi_range(2, 4)
	var num_available: int = 0
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		num_available += 1
	
	card_uis = lay_out_cards(min(num_cards, num_available))
	
	
	for card_ui in card_uis:
		randomize_upgrade(card_ui, amount, promotion)
		
	get_tree().paused = true
	
	if num_available == 0:
		Signals.upgrade_chosen.emit()
		print("no more available cards")
		get_tree().paused = false


func randomize_upgrade(card_ui: CardUI, remaining: int, promotion: bool) -> void:
	
	if upgrade_pool.size() == 0:
		return
	
	# add weight
	var total_weight: int = 0
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		total_weight += upgrade_tuple.weight
	
	# select upgrade
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
	
	apply_modifiers(upgrade.modifiers)
	
	for upgrade_tuple in curr_upgrade_pool:
		if upgrade_tuple.upgrade == upgrade:
			continue
		upgrade_tuple.weight *= 2.0
	
	remaining -= 1
	
	for card_ui in card_uis:
		card_ui.queue_free()
	card_uis.clear()
	
	if remaining == 0:
		Signals.upgrade_chosen.emit()
		seen = {}
		if promotion:
			promote()
		else:
			get_tree().paused = false
			
	else:
		prompt(remaining, promotion)


func promote() -> void:
	
	var num_cards = curr.next.size()
	if num_cards == 0:
		print("no classes left")
		get_tree().paused = false
		return
	
	card_uis = lay_out_cards(num_cards)
	
	for i in range(num_cards):
		
		var card_ui: CardUI = card_uis[i]
		var candidate: CoffeeClassNode = curr.next[i]
		
		card_ui.text = candidate.value.name + "\n"
		card_ui.text += "\nADD " + candidate.value.upgrade.name
		
		card_uis.append(card_ui)
		list_coffee_class(card_ui, candidate)


func list_coffee_class(card_ui: CardUI, coffee_class: CoffeeClassNode) -> void:
	
	if upgrade_pool.size() == 0:
		return
	
	card_ui.pressed.connect(func(): select_promotion(coffee_class))
	


func select_promotion(coffee_class: CoffeeClassNode) -> void:
	
	curr = coffee_class
	
	apply_modifiers(coffee_class.value.upgrade.modifiers)
	
	for card_ui in card_uis:
		card_ui.queue_free()
	card_uis.clear()
	
	get_tree().paused = false
	Signals.upgrade_chosen.emit()
	seen = {}

func apply_modifiers(modifiers: Array[UpgradeModifier]) -> void:

	for modifier in modifiers:
		if modifier.operation == UpgradeModifier.OPERATION.SET:
			Signals.set_player_stat.emit(modifier.property, modifier.value)
		if modifier.operation == UpgradeModifier.OPERATION.ADD:
			Signals.add_player_stat.emit(modifier.property, modifier.value)
		if modifier.operation == UpgradeModifier.OPERATION.MUL:
			Signals.mul_player_stat.emit(modifier.property, modifier.value)
	
