extends Node3D

var num_treader=0

func _on_area_3d_body_entered(body: Node3D) -> void:
	num_treader+=1
func _on_area_3d_body_exited(body: Node3D) -> void:
	num_treader-=1

func _physics_process(delta: float) -> void:
	if num_treader>0:
		%Pivot.rotation.x=move_toward(%Pivot.rotation.x,-PI/2,delta*6)
	else:
		%Pivot.rotation.x=move_toward(%Pivot.rotation.x,0,delta*2)
