class_name UpgradeModifier
extends Resource

enum Operation {SET, ADD, MUL}

@export var property: String
@export var operation: Operation
@export var value: float
