extends Resource

class_name IngredientInfo

@export var ing_name : String
@export_enum("Unprocessed", "Processed") var state
@export var sprite_upd : Texture2D
@export var sprite_prd : Texture2D

func processed() -> bool:
	match state:
		0: return false
		1: return true
		_: return false
		
func get_current_sprite() -> Texture2D:
	match state:
		0: return sprite_upd
		1: return sprite_prd
		_: return null
