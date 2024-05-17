class_name DamageSource extends RefCounted

enum StatusEffect {
	None, # Default value
	Freeze,
}


# Mandatory fields
var damage: int = 0

# optional
var status: StatusEffect