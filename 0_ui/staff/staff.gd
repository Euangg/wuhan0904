extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():SceneEngine.switch(load(Global.THEME))
