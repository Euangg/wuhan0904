extends Control


func activate():
	show()
	process_mode=Node.PROCESS_MODE_WHEN_PAUSED

func inactivate():
	hide()
	process_mode=Node.PROCESS_MODE_DISABLED

func back():
	get_tree().paused=false
	inactivate()
	
func quit():
	get_tree().paused=false
	SceneEngine.switch(load(Global.THEME))
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):back()
	accept_event()
