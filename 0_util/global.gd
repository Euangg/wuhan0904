extends Node
const INTRO = ("uid://cpcn6fy085di2")
const THEME = ("uid://gkabh7icruyr")
const PLAY =("uid://d3tgi0aom5546")
const END=("uid://dxd8a0pvybbu")

var controller=1

func stun(time:float=0.2):
	#var tween=create_tween()
	#tween.tween_property()
	Engine.time_scale=0.1
	if %TimerStun.is_stopped():%TimerStun.start(0.2)
	else:%TimerStun.start(%TimerStun.time_left+0.2)

func _on_timer_stun_timeout():Engine.time_scale=1

var times_end=0
var winner=0
