extends CharacterBody3D
enum Direction{LEFT=-1,RIGHT=1}
var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		%Pivot.scale.x=direction
enum State{
	NULL,FALL,FLAP
}
var current_state=State.NULL

signal reach_target

@export_group("fly")
@export var fly_up_speed:float=40
@export var fly_h_speed:float=40

var target_pos=Vector2.ZERO
func flap():
	velocity.y+=fly_up_speed
func _ready() -> void:
	reach_target.emit()
	target_pos=Vector2(20,10)
func _physics_process(delta: float) -> void:
	var is_flap=(position.y<10)
	var current_pos=Vector2(position.x,position.z)
	if current_pos.distance_squared_to(target_pos)<100:
		reach_target.emit()
	var input=current_pos.direction_to(target_pos)
	
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.FALL
		State.FALL:if is_flap:next_state=State.FLAP
		State.FLAP:if not %AP.is_playing():next_state=State.FALL
	if next_state==current_state:pass
	else:
		match next_state:
			State.FALL:%AP.play("fall")
			State.FLAP:%AP.play("flap")
		current_state=next_state

	if not is_zero_approx(input.x):
		direction=Direction.LEFT if input.x<0 else Direction.RIGHT
	velocity.x=fly_h_speed*input.x
	velocity.z=fly_h_speed*input.y
	
	velocity.y-=40*delta
	
	velocity*=1/(1+0.1*velocity.length()*delta)
	move_and_slide()

const SEED = preload("uid://ceogoh04styvy")
func _on_timer_seed_timeout() -> void:
	var seed:CharacterBody3D=SEED.instantiate()
	add_sibling(seed)
	seed.global_position=global_position
