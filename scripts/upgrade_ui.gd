class_name UpgradeUI
extends CanvasLayer

@export var upgrade_pool: Array[UpgradeWeightTuple]

const CARD_UI: PackedScene = preload("uid://dia2yamwblh47")
const ROOT: CoffeeClassNode = preload("uid://d285d026kt5lc")
const SPACING: float = 192.0 + 32.0

var curr_upgrade_pool: Array[UpgradeWeightTuple]
var card_uis: Array[CardUI] = []
var seen: Dictionary = {}
var curr = ROOT
var upgrading: bool = false

var num_cards_min: int = 2
var num_cards_max: int = 4

func _ready() -> void:
	curr_upgrade_pool = upgrade_pool.duplicate()


# prompt the user to select cards
func prompt(remaining: int, promotion: bool) -> void:
	
	# destroy card uis
	for card_ui in card_uis:
		card_ui.play_destroy()
	
	# clear cards
	card_uis.clear()
	
	# pause game
	get_tree().paused = true
	$ColorRect.modulate.a = 0.25
	
	# get card count
	var num_cards = 0
	if remaining > 0:
		var num_upgrades_randomized: int = randi_range(num_cards_min, num_cards_max)
		var num_upgades_available = get_num_available_upgrades()
		num_cards = min(num_upgrades_randomized, num_upgades_available)
	elif promotion:
		var num_coffee_classes = curr.next.size()
		num_cards = num_coffee_classes
	
	# break early if no more cards are left
	if num_cards == 0:
		if promotion and remaining > 0:
			prompt(remaining - 1, promotion)
			return
		elif remaining <= 0:
			close()
			return
	
	# lay out cards with upgrades
	await lay_out_cards(num_cards, SPACING, remaining, promotion)


# close the prompt
func close() -> void:
	
	seen.clear()
	Signals.upgrade_chosen.emit()
	get_tree().paused = false
	$ColorRect.modulate.a = 0.0


# lay out cards, spaced in pixels
func lay_out_cards(num_cards: int, spacing: float, remaining: int, promotion: bool) -> void:
	
	var running = true
	
	
	
	# calculate start position
	var offset: float = 0.0
	if num_cards % 2 == 0:
		offset += 0.5
	offset -= int(num_cards/2)
	var start_x = offset * spacing
	
	# spawn cards, sapced out
	for i in range(num_cards):
		
		if running == false:
			print("EXIT")
			return
		
		var card_ui: CardUI = CARD_UI.instantiate()
		var card_ui_position = Vector2(start_x + i * spacing, 0.0)
		card_ui_position -= card_ui.size/2.0
		card_ui.start_position = card_ui_position
		card_ui.position = card_ui_position
		card_ui.index = i
	
		if remaining > 0:
			
			# pull random upgrade
			var upgrade = pull_random_upgrade()
			if upgrade:
				card_ui.set_upgrade_texture(upgrade.texture, upgrade.modulate)
				card_ui.set_title_text(upgrade.name)
				card_ui.set_details_text(get_modifier_string(upgrade.modifiers))
				card_ui.upgrade = upgrade
				card_ui.pressed.connect(func():
					print("turned off running from upgrade")
					running = false
					apply_modifiers(upgrade.modifiers)
					prompt(remaining - 1, promotion))
					
		elif promotion:
			
			# get coffee class candidate among the next candidates
			var coffee_class: CoffeeClassNode = (curr.next[i] if i < curr.next.size() else null)
			if coffee_class:
				card_ui.set_upgrade_texture(coffee_class.value.texture, coffee_class.value.modulate)
				card_ui.set_title_text(coffee_class.value.name)
				var details: String = ""
				card_ui.set_details_text("\nNEW " + 
					coffee_class.value.upgrade.name +
					get_modifier_string(coffee_class.value.upgrade.modifiers))
				card_ui.pressed.connect(func():
					print("turned off running")
					running = false
					curr = coffee_class
					GameData.player_stats.coffee_class = coffee_class.value
					apply_modifiers(coffee_class.value.upgrade.modifiers)
					prompt(remaining, false)
					)
				
		card_uis.append(card_ui)
		add_child(card_ui)
		#await get_tree().create_timer(0.25).timeout


# check how many upgrades are available from the pool
func get_num_available_upgrades() -> int:
	var num_available: int = 0
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		num_available += 1
	return num_available


# pull a random upgrade
func pull_random_upgrade() -> UpgradeStats:
	
	if curr_upgrade_pool.size() == 0:
		return
	
	# add weight
	var total_weight: int = 0
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		total_weight += upgrade_tuple.weight
	
	# weighted select
	var target: int = randi_range(0, total_weight)
	for upgrade_tuple in curr_upgrade_pool:
		if seen.has(upgrade_tuple):
			continue
		target -= upgrade_tuple.weight
		if target <= 0:
			var upgrade = upgrade_tuple.upgrade
			seen[upgrade_tuple] = true
			return upgrade
	
	return null



func get_modifier_string(modifiers: Array[UpgradeModifier]) -> String:
	
	var text = ""
	for modifier in modifiers:
		
		var prefix: String = ""
		var body: String = get_property_string(modifier.property)
		var suffix: String = ""
		
		if modifier.operation == UpgradeModifier.Operation.SET:
			suffix = " => " + str(int(modifier.value))
		
		if modifier.operation == UpgradeModifier.Operation.ADD:
			if modifier.value < 0.0:
				prefix = "-" + str(int(modifier.value)) + " "
			else:
				prefix = "+" + str(int(modifier.value)) + " "
		
		if modifier.operation == UpgradeModifier.Operation.MUL:
			suffix = " x " + str(int(modifier.value * 100)) + "%"
		
		text += prefix + body + suffix + "\n"
	return text


func get_property_string(property: String) -> String:
	
	var property_map: Dictionary = {}
	
	property_map["max_health"] = "Max Health"
	property_map["health_regen_rate"] = "Health Regen"
	property_map["body_damage"] = "Body Damage"
	property_map["speed"] = "Speed"
	property_map["fire_rate"] = "Fire Rate"
	property_map["bullet_chocolate_count"] = "Chocolate Bullet"
	property_map["bullet_espresso_count"] = "Espresso Bullet"
	property_map["bullet_milk_count"] = "Milk Bullet"
	property_map["bullet_speed"] = "Bullet Speed"
	property_map["bullet_damage"] = "Bullet Damage"
	property_map["bullet_damage_factor"] = "Bullet Damage Multiplier"
	
	if property_map.has(property):
		return property_map[property]
		
	return property


func apply_modifiers(modifiers: Array[UpgradeModifier]) -> void:
	for modifier in modifiers:
		Signals.modify_player_stat.emit(modifier.property, modifier.operation, modifier.value)
