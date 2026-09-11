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

var arr_text=[
	"从前有一座大陆",
	"这里受到了天神的“赏赐”",
	"神兽会为这里降下种子雨",
	"种子落到地上",
	"随着时间会长成大萝卜",
	"兔兔们为了争抢萝卜，打得不可开交",
	"这天，两位高手为了占领这块大陆，开始了最后的决斗……"
]

var order=0
var next_out:bool=true

func _ready() -> void:
	SoundEngine.set_bgm(preload("uid://dl5e35grgprfj"))
	set_process_unhandled_input(false)
	%Label.text=arr_text[order]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("confirm"):
		if next_out:%ApCg.play("fade_out")
		else:
			order+=1
			if order>=7:%Dialogue.hide()
			else:%Label.text=arr_text[order]
			if order<CGS.size():
				%Cg.texture=CGS[order]
				%ApCg.play("fade_in")
			else:SceneEngine.switch(load(Global.THEME))
		next_out=!next_out
	accept_event()

func _physics_process(delta: float) -> void:pass

func _on_timer_timeout() -> void:
	set_process_unhandled_input(true)
