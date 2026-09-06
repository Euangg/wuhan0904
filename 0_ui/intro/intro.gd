extends Control
const CGS = [preload("uid://bpa6230gece31")
,preload("uid://cj0ce8s5n35fq")
,preload("uid://ddvl4wiirnsot")
,preload("uid://j5pfc0vejjhg")
,preload("uid://cpc7bltrrk7xs")
,preload("uid://cr183s6rcehtn")
,preload("uid://sfijckbr7ssn")
,preload("uid://bxebs1jnec6dn")
,preload("uid://b6d2pp3o03p1r")
]

var order=-1
var t=0

func _ready() -> void:
	SoundEngine.set_bgm(preload("uid://dl5e35grgprfj"))
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("confirm"):
		t+=1
		if t%2:%ApCg.play("fade_out")
		else:
			order+=1
			if order>=7:%Dialogue.hide()
			if order<CGS.size():
				%Cg.texture=CGS[order]
				%ApCg.play("fade_in")
			else:SceneEngine.switch(load(Global.THEME))
	accept_event()

func _physics_process(delta: float) -> void:pass

func _on_timer_timeout() -> void:
	set_process_unhandled_input(true)
