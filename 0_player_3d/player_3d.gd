class_name Player3D
extends CharacterBody3D

const SFX_BLOCKED = preload("uid://ceiip8nwfy1jf")
const SFX_EAT = preload("uid://dyfhyybdodv2u")
const SFXS_DRAG = [preload("uid://bhqtv3ldvcu8d"), preload("uid://i3vm7lr6toot")
, preload("uid://bu28vq5i8wj1p")
,preload("uid://cns1p1jil052v")
,preload("uid://bxs16r2u0p1r5")
,preload("uid://6aeab5r4d5su")
,preload("uid://caeh741wmdj83")
,preload("uid://se83gpkwanwb")
,preload("uid://bhpapf8qtdeh8")
,preload("uid://rwwl27pxrohy")
,preload("uid://d1pf7r0dn6t3x")
,preload("uid://yip3biai4wjy")
,preload("uid://cmsmit0y7b1ru")
,preload("uid://c7ssrqa8r3t35")]

enum Direction{LEFT=-1,RIGHT=1}
var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		%Pivot.scale.x=direction
		#%SpriteBody.flip_h=(direction==Direction.RIGHT)
enum State{NULL,IDLE,WALK,
	DRAG,SHIT,EAT,
	ATTACK,BITE,
	HURT,STUN,DIE,
	RISE,
	FALL,
}
var current_state=State.NULL
var action_up:StringName=&"w"
var action_left:StringName=&"a"
var action_down:StringName=&"s"
var action_right:StringName=&"d"
var action_carrot:StringName=&"j"
var action_bite:StringName=&"k"
var action_shit:StringName=&"u"
var action_eat:StringName=&"i"

@onready var sprite_body: Hybrid2D3DSprite = %SpriteBody
@onready var box_carrot: Area3D = %BoxCarrot

var speed:float=50
var f:Vector3=Vector3.ZERO
var interact_carrot:Carrot3D=null
var has_carrot:bool=false
var is_hurt:bool=false
var is_die:bool=false
var is_bited:bool=false
var num_hurt:int=0
var body_scale:float=1:
	set(v):
		body_scale=v
		if not is_node_ready():await ready
		scale=Vector3(body_scale,body_scale,body_scale)
var add_scale:float=0

var time_shit_on_carrot:float=0

func _ready() -> void:body_scale=scale.x
const SFX_WC = preload("uid://dxjxs037thb3i")
var input:Vector2=Vector2.ZERO
func _input(event: InputEvent) -> void:
	input=Input.get_vector(action_left,action_right,action_up,action_down)
func _physics_process(delta: float) -> void:
	if add_scale>0:
		add_scale-=0.1*delta
		body_scale+=0.1*delta
	
	if %BoxCarrot.scale.x<=0.1:has_carrot=false
	
	if has_carrot:%BoxCarrot.show()
	else:%BoxCarrot.hide()
	var try_drag=false
	var try_attack=false
	var try_bite=Input.is_action_just_pressed(action_bite)
	var try_shit=Input.is_action_pressed(action_shit)
	var try_eat=Input.is_action_pressed(action_eat)
	
	var target_carrot:Carrot3D=null
	var c:Array[Area3D]=%AreaDetectCarrot.get_overlapping_areas()
	if c.is_empty():pass
	else:target_carrot=c[0].get_parent()
	
	%SpriteAttention.hide()
	if not has_carrot && target_carrot:%SpriteAttention.show()
	
	if Input.is_action_just_pressed(action_carrot):
		if has_carrot:try_attack=true
		else:
			if target_carrot && !target_carrot.occupied:try_drag=true
	
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if input.is_zero_approx():pass
			else:next_state=State.WALK
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
			if try_bite:next_state=State.BITE
			if try_drag:next_state=State.DRAG
			if try_shit:next_state=State.SHIT
			if try_eat and has_carrot:next_state=State.EAT
			if try_attack:next_state=State.ATTACK
			if is_hurt:next_state=State.HURT
		State.WALK:
			if input.is_zero_approx():next_state=State.IDLE
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
			if try_bite:next_state=State.BITE
			if try_drag:next_state=State.DRAG
			if try_shit:next_state=State.SHIT
			if try_eat and has_carrot:next_state=State.EAT
			if try_attack:next_state=State.ATTACK
			if is_hurt:next_state=State.HURT
		State.DRAG:
			if interact_carrot:pass
			else:next_state=State.IDLE
			if has_carrot:next_state=State.IDLE
			if try_shit:next_state=State.SHIT
			if is_hurt:next_state=State.HURT
		State.SHIT:
			if !try_shit:next_state=State.IDLE
			if is_hurt:next_state=State.HURT
		State.EAT:
			if !try_eat:next_state=State.IDLE
			if !has_carrot:next_state=State.IDLE
			if is_hurt:next_state=State.HURT
		State.RISE:
			if velocity.y>0:next_state=State.FALL
			if is_on_floor():next_state=State.IDLE
		State.FALL:
			if velocity.y<0:next_state=State.RISE
			if is_on_floor():
				next_state=State.IDLE
		State.HURT:
			if f.is_zero_approx():next_state=State.IDLE
		State.STUN:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.BITE:
			if %AnimationPlayer.is_playing():pass
			else:
				if %TimerBite.is_stopped():next_state=State.IDLE
			if is_hurt:next_state=State.HURT
		State.ATTACK:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
			if is_hurt:next_state=State.HURT
			if is_bited:next_state=State.STUN
		State.DIE:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
	if is_die and current_state!=State.DIE:
		next_state=State.DIE
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.IDLE:pass
			State.DRAG:interact_carrot=null
			State.BITE:
				%HitboxBite.monitoring=false
				%SpriteBody.modulate=Color.WHITE
			State.ATTACK:
				%BoxCarrot.monitoring=false
				%BoxCarrot.monitorable=false
			State.HURT:pass
			State.SHIT:%AudioShit.stop()
			State.DIE:is_die=false
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.WALK:%AnimationPlayer.play("walk")
			State.DRAG:
				%AnimationPlayer.play("drag_start")
				SoundEngine.play_sfx(SFXS_DRAG.pick_random())
				interact_carrot=target_carrot
				global_position=interact_carrot.global_position
				global_position.z+=0.1
				interact_carrot.dragged=true
			State.SHIT:
				%AnimationPlayer.play("shit")
				%AudioShit.play()
				time_shit_on_carrot=0
			State.EAT:
				%AnimationPlayer.play("eat")
				if %SpriteCarrot.frame==1:%SpriteCarrot.frame=2
			State.RISE:%AnimationPlayer.play("rise")
			State.FALL:%AnimationPlayer.play("fall")
			State.BITE:
				%AnimationPlayer.play("bite")
				SoundEngine.play_sfx(preload("uid://b513b80t6cnf"))
			State.ATTACK:
				%AnimationPlayer.play("attack")
				SoundEngine.play_sfx_sfx(SFX_WC.instantiate())
			State.HURT:
				%AnimationPlayer.stop()
				%SpriteBody.frame=16
				SoundEngine.play_sfx_sfx(preload("uid://bvpygussblv3o").instantiate())
				is_hurt=false
				num_hurt+=1
			State.STUN:
				is_bited=false
				has_carrot=false
				%AnimationPlayer.play("stun")
			State.DIE:
				%AnimationPlayer.play("die")
				SoundEngine.play_sfx(SFX_BLOCKED)
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			velocity.x=speed*input.x
			velocity.z=speed*input.y
			if not is_zero_approx(input.x):
				direction=Direction.LEFT if input.x<0 else Direction.RIGHT
		State.WALK:
			velocity.x=speed*input.x
			velocity.z=speed*input.y
			if not is_zero_approx(input.x):
				direction=Direction.LEFT if input.x<0 else Direction.RIGHT
		State.DRAG:
			velocity.x=0
			velocity.z=0
			if Input.is_action_just_pressed(action_carrot):
				SoundEngine.play_sfx(SFXS_DRAG.pick_random(),5)
				%AnimationPlayer.play("drag_1")
				if interact_carrot.be_dragged(scale.x*2):
					SoundEngine.play_sfx(preload("uid://cm3jw78ts60u6"))
					%BoxCarrot.scale=Vector3.ONE*sqrt(interact_carrot.scale.x)
					has_carrot=true
					if interact_carrot.scale.x>=1:%SpriteCarrot.frame=3
					elif interact_carrot.scale.x>=0.5:%SpriteCarrot.frame=1
					else:%SpriteCarrot.frame=0
					
					interact_carrot.queue_free()
					interact_carrot=null
		State.SHIT:
			velocity.x=0
			velocity.z=0
			if target_carrot:
				target_carrot.time+=3*delta
				time_shit_on_carrot+=delta
				if time_shit_on_carrot>1:
					time_shit_on_carrot-=20
					SoundEngine.play_sfx_sfx(preload("uid://dkxnh2rceb65d").instantiate())
				
		State.EAT:
			velocity.x=0
			velocity.z=0
			%BoxCarrot.hide()
			body_scale+=0.05*delta
			%BoxCarrot.scale-=Vector3.ONE*0.5*delta
		State.BITE:
			velocity.x=0
			velocity.z=0
			if %SpriteBody.frame==14:is_hurt=false
		State.ATTACK:
			velocity.x=0
			velocity.z=0
		State.STUN:
			velocity.x=0
			velocity.z=0
		State.HURT:
			velocity+=f*delta
			f*=0.9
			f=f.move_toward(Vector3.ZERO,12)
			if f.length_squared()<50000:%SpriteBody.frame=17
		State.DIE:
			velocity.x=0
			velocity.z=0
			
	velocity.y-=1000*delta
	move_and_slide()

const SFX_HIT = preload("uid://b5cffanbxmack")

func _on_box_carrot_area_entered(area: Area3D) -> void:
	if is_hurt or is_bited:
		return
	var p:Player3D=area.get_parent().get_parent()
	if p.is_in_group(get_groups()[0]):pass
	else:
		#box_carrot.scale-=Vector3.ONE*0.1
		p.f=(p.position-position).normalized()*400*(1+p.num_hurt/5.)
		p.is_hurt=true
		SoundEngine.play_sfx_sfx(SFX_HIT.instantiate())

func bite_failed():
	if %SpriteBody.frame==14:return
	%AnimationPlayer.stop()
	%SpriteBody.frame=15
	%TimerBite.start(0.3)
	SoundEngine.play_sfx(preload("uid://bktecspb5ton4"))
func bit_succeed():
	%AnimationPlayer.stop()
	%SpriteBody.frame=14
	%TimerBite.start(0.5)
	Global.stun(0.5)
	SoundEngine.play_sfx(SFX_BLOCKED)
	SoundEngine.play_sfx(SFX_EAT)
func _on_hitbix_bite_area_entered(area: Area3D) -> void:
	var p:Player3D=area.get_parent().get_parent()
	if p.is_in_group(get_groups()[0]):pass
	else:
		var multi=p.scale.x/scale.x
		add_scale+=p.box_carrot.scale.x*0.1*multi
		p.is_bited=true
		bit_succeed()

func play_sfx_eat():
	SoundEngine.play_sfx(SFX_EAT)


func _on_audio_shit_finished() -> void:
	%AudioShit.play()
