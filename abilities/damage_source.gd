class_name DamageSource extends RefCounted

var damageValue: int

func _init(damageValue:int = 2):
	damage = damageValue

enum StatusEffect {
	None, # Default value
	Freeze,
}


# Mandatory fields
var damage: int = 0

# optional
var status: StatusEffect
