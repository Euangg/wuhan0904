class_name Carrot3D
extends Node3D

var time=0
var scale_max=1
var hp_max=1
var hp=1
var dragged=false
var occupied=false

func set_occupied():
	%Area3D.monitorable=false
	occupied=true
	
func be_dragged(damage:float)->bool:
	hp-=damage
	return hp<=0
func _ready() -> void:
	%Hybrid2D3DSprite.frame=1
	scale=Vector3(0,0,0)
func _physics_process(delta: float) -> void:
	time+=delta	
	var should_scale=clamp(0.1+time/60,0,scale_max)
	var hp_max=1+time
	scale=Vector3(should_scale,should_scale,should_scale)
	if should_scale>=scale_max:pass
	else:
		if hp>0:hp+=delta
	
	if scale.x>0.8:%Hybrid2D3DSprite.frame=5
	elif scale.x>0.6:%Hybrid2D3DSprite.frame=4
	elif scale.x>0.4:%Hybrid2D3DSprite.frame=3
	elif scale.x>0.2:%Hybrid2D3DSprite.frame=2
	else :%Hybrid2D3DSprite.frame=1
	
	var camera:=get_viewport().get_camera_3d()
	%Control.global_position=camera.unproject_position(%Marker3D.global_position)
	%ProgressBar.value=hp/hp_max*100
	if dragged:%ProgressBar.show()
	else:%ProgressBar.hide()
	
