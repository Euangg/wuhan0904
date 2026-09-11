extends Control
const SFX_TIP = preload("uid://calumh6ckfunj")
const SFX_TIP_CONTROLLER = preload("uid://4p704t0dryjj")
const SFX_TIP_KEYBOARD = preload("uid://c1r7d8m2tnre5")
const TIPS_01 = preload("uid://b8lio5ht0fqsp")
const TIPS_02 = preload("uid://15q2tx5i28er")
const TIPS_03 = preload("uid://wb45rg026jxl")

func tip_rule():
	%Sprite2D.texture=TIPS_01
	SoundEngine.play_sfx_sfx(SFX_TIP.instantiate())

func tip_keyboard():
	%Sprite2D.texture=TIPS_02
	SoundEngine.play_sfx_sfx(SFX_TIP_KEYBOARD.instantiate())
	
func tip_controller():
	%Sprite2D.texture=TIPS_03
	SoundEngine.play_sfx_sfx(SFX_TIP_CONTROLLER.instantiate())


func _ready() -> void:
	tip_rule()


func _on_button_confirm_button_down() -> void:
	SceneEngine.switch(load(Global.PLAY))

func _on_button_rule_button_down() -> void:tip_rule()
func _on_button_keyboard_button_down() -> void:tip_keyboard()
func _on_button_contrller_button_down() -> void:tip_controller()
