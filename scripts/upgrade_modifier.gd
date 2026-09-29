class_name UpgradeModifier
extends Resource

enum OPERATION {SET, ADD, MUL}

@export var property: String
@export var operation: OPERATION
@export var value: float
