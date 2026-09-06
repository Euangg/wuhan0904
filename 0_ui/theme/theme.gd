extends Control

func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	pass

const START_01 = preload("uid://trb2akrd1w4o")
const START_02 = preload("uid://d1dh6ucghj22q")
func _on_area_start_mouse_entered() -> void:%Start.texture=START_02
func _on_area_start_mouse_exited() -> void:%Start.texture=START_01

const STORY_01 = preload("uid://c7n4b0qc788ac")
const STORY_02 = preload("uid://huhul12c6n32")
func _on_area_story_mouse_entered() -> void:%Story.texture=STORY_02
func _on_area_story_mouse_exited() -> void:%Story.texture=STORY_01

const SETTING_01 = preload("uid://cm0jhynts6bxi")
const SETTING_02 = preload("uid://c0e7rdbbp6okm")
func _on_area_setting_mouse_entered() -> void:%Setting.texture=SETTING_02
func _on_area_setting_mouse_exited() -> void:%Setting.texture=SETTING_01

const EXIT_01 = preload("uid://c7w7sjsysm4bt")
const EXIT_02 = preload("uid://csgl3jc0h3f4s")
func _on_area_exit_mouse_entered() -> void:%Exit.texture=EXIT_02
func _on_area_exit_mouse_exited() -> void:%Exit.texture=EXIT_01


func _on_button_start_button_down() -> void:
	SceneEngine.switch(load(Global.PLAY))


func _on_button_story_button_down() -> void:
	SceneEngine.switch(load(Global.INTRO))


func _on_button_setting_button_down() -> void:
	pass # Replace with function body.


func _on_button_exit_button_down() -> void:
	get_tree().quit()
