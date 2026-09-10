extends CharacterBody3D

const CARROT_3D = preload("uid://blfg8trbu3wrh")

func grow():
	var carrot:Carrot3D=CARROT_3D.instantiate()
	carrot.position=position
	carrot.scale_max=randf_range(0.4,1.2)
	add_sibling(carrot)
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.y-=90*delta
	move_and_slide()
	if is_on_floor():grow()
