extends Control
const S2 = preload("uid://cleqavhb7h58m")

func _ready() -> void:
	Global.times_end+=1
	if Global.times_end%2:%Sprite2D.texture=S2


func _input(event: InputEvent) -> void:
	if event.is_action("confirm"):SceneEngine.switch(load(Global.THEME))
