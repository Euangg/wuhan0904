extends Node3D
const SEED = preload("uid://ceogoh04styvy")

var score_p1:int=0
var score_p2:int=0
var base_scale:float

func add_joypad_button(action_name:StringName,joy_button:JoyButton):
	var event=InputEventJoypadButton.new()
	event.button_index=joy_button
	event.pressed=true
	InputMap.action_add_event(action_name,event)
func add_joypad_axis(action_name:StringName,joy_axis:JoyAxis,amount:float):
	var event=InputEventJoypadMotion.new()
	event.axis=joy_axis
	event.axis_value=amount
	InputMap.action_add_event(action_name,event)

func _ready() -> void:
	base_scale=%Player3d.scale.x
	
	%Player3d.global_position=%MarkerSpawn1.global_position
	%Player3d2.global_position=%MarkerSpawn2.global_position
	%Player3d.add_to_group("player_1")
	%Player3d2.add_to_group("player_2")
	print(%Player3d.get_groups())
	print(%Player3d2.get_groups())
	
	%Player3d2.action_left=&"left"
	%Player3d2.action_up=&"up"
	%Player3d2.action_right=&"right"
	%Player3d2.action_down=&"down"
	%Player3d2.action_carrot=&"num_1"
	%Player3d2.action_bite=&"num_2"
	%Player3d2.action_shit=&"num_4"
	%Player3d2.action_eat=&"num_5"
	%Player3d2.direction=Player3D.Direction.LEFT
	#%Player3d2.sprite_body.modulate=Color(0x9b70ffff)
	%Player3d2.sprite_body.texture=preload("uid://c40vl25ocwddj")
	
	Global.controller=2
	var control_player:Player3D=%Player3d if Global.controller==1 else %Player3d2
	add_joypad_button(control_player.action_left,JOY_BUTTON_DPAD_LEFT)
	add_joypad_axis(control_player.action_left,JOY_AXIS_LEFT_X,-0.1)
	add_joypad_button(control_player.action_up,JOY_BUTTON_DPAD_UP)
	add_joypad_axis(control_player.action_up,JOY_AXIS_LEFT_Y,-0.1)
	add_joypad_button(control_player.action_right,JOY_BUTTON_DPAD_RIGHT)
	add_joypad_axis(control_player.action_right,JOY_AXIS_LEFT_X,0.1)
	add_joypad_button(control_player.action_down,JOY_BUTTON_DPAD_DOWN)
	add_joypad_axis(control_player.action_down,JOY_AXIS_LEFT_Y,0.1)
	add_joypad_button(control_player.action_carrot,JOY_BUTTON_A)
	add_joypad_button(control_player.action_bite,JOY_BUTTON_B)
	add_joypad_button(control_player.action_shit,JOY_BUTTON_X)
	add_joypad_button(control_player.action_eat,JOY_BUTTON_Y)
	
	%Player3d.set_process_input(false)
	%Player3d2.set_process_input(false)
	
	
	SoundEngine.set_bgm(preload("uid://dl5e35grgprfj"))
	%TimerSeed.start()

var camera_target:Vector3
func camera_chase():
	camera_target.x=(%Player3d.position.x+%Player3d2.position.x)/2
	camera_target.y=%Camera.position.y
	var all_scale=(%Player3d.scale.x+%Player3d2.scale.x)
	camera_target.z=max(%Player3d.position.z,%Player3d2.position.z)+40+5*all_scale
	
func _physics_process(delta: float) -> void:
	camera_chase()
	%Camera.position=%Camera.position.lerp(camera_target,0.08)
	#%Camera.position=%Camera.position.move_toward(camera_target,40*delta)
	
	#var old_scale=%island2.scale.x
	#old_scale-=delta
	#%island2.scale=Vector3(old_scale,old_scale,old_scale)


const TEX_SCORE = [preload("uid://b5trxcgxydq0n")
,preload("uid://d2bi4cj3w0vuh")
,preload("uid://yhlpwafe03up")
, preload("uid://iqosqluphsd5")]

func _on_area_dead_body_entered(body: Node3D) -> void:
	if body is Player3D:
		var p:Player3D=body
		p.is_die=true
		#p.scale=Vector3.ONE*base_scale
		p.num_hurt=0
		if p.is_in_group("player_1"):
			p.position=%MarkerSpawn1.global_position
		else:
			p.position=%MarkerSpawn2.global_position
		if max(score_p1,score_p2)>=3:pass
		else:
			if p.is_in_group("player_1"):score_p2+=1
			else:score_p1+=1
			%Score1.texture=TEX_SCORE[score_p1]
			%Score2.texture=TEX_SCORE[score_p2]
			if max(score_p1,score_p2)>=3:
				%Player3d.set_process_input(false)
				%Player3d2.set_process_input(false)
				SoundEngine.play_sfx_sfx(preload("uid://da2jyysvbo2lu").instantiate())
				Global.winner=1 if score_p1>score_p2 else 2
				%TimerEnd.start()
	else:body.queue_free()

func _on_timer_seed_timeout() -> void:
	var seed:CharacterBody3D=SEED.instantiate()
	seed.position=Vector3(randf_range(-110,110),60,randf_range(-70,70))
	add_child(seed)
	%TimerSeed.start(randf_range(5,10))

func _on_audio_stream_player_provoke_2_finished() -> void:
	%AudioStreamPlayerProvoke1.play()
func _on_audio_stream_player_provoke_1_finished() -> void:
	%AudioStreamPlayer3.play()
	%AnimationPlayer.play("3")
func _on_audio_stream_player_3_finished() -> void:
	%AudioStreamPlayer2.play()
	%AnimationPlayer.play("2")
func _on_audio_stream_player_2_finished() -> void:
	%AudioStreamPlayer1.play()
	%AnimationPlayer.play("1")
func _on_audio_stream_player_1_finished() -> void:
	%AudioStreamPlayerF.play()
	%Player3d.set_process_input(true)
	%Player3d2.set_process_input(true)
	%AnimationPlayer.play("fight")
	%Tip1.hide()
	%Tip2.hide()
func _on_audio_stream_player_f_finished() -> void:pass

func _on_timer_end_timeout() -> void:
	SoundEngine.stop_bgm()
	SceneEngine.switch(load(Global.END))
