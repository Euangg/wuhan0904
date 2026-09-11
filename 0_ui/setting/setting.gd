extends Control

func _ready() -> void:
	%HSliderSound.value=AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))

func _on_button_back_button_down() -> void:
	SceneEngine.switch(load(Global.THEME))

const BACK__02 = preload("uid://dfwbjes8u05st")
const BACK_01 = preload("uid://dgplt2fot8qwe")
func _on_button_back_mouse_entered() -> void:%Back.texture=BACK__02
func _on_button_back_mouse_exited() -> void:%Back.texture=BACK_01

const SOUND_01 = preload("uid://dvfjctp4ityv5")
const SOUND_02 = preload("uid://b157e7s26jxat")
func _on_button_sound_mouse_entered() -> void:%Sound.texture=SOUND_02
func _on_button_sound_mouse_exited() -> void:%Sound.texture=SOUND_01
func _on_h_slider_sound_value_changed(value: float) -> void:
	var index=AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(index,value)

const FULLSCREEN_01 = preload("uid://boii32pf1imbb")
const FULLSCREEN_02 = preload("uid://045rr7jibu68")
const FULLSCREEN_03 = preload("uid://dtxoo0tsda5ka")
func _on_button_full_screen_mouse_entered() -> void:
	refresh_button_fullscreen_texture()
func _on_button_full_screen_mouse_exited() -> void:%Fullscreen.texture=FULLSCREEN_01
func refresh_button_fullscreen_texture():
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED:%Fullscreen.texture=FULLSCREEN_02
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:%Fullscreen.texture=FULLSCREEN_03
		DisplayServer.WINDOW_MODE_FULLSCREEN:%Fullscreen.texture=FULLSCREEN_03
func _on_button_full_screen_button_down() -> void:
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.WINDOW_MODE_FULLSCREEN:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	refresh_button_fullscreen_texture()
