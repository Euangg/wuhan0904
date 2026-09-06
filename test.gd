extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("s"):SceneEngine.switch(load(Global.THEME))
