extends Node2D
class_name Graphic
enum Direction{LEFT=-1,RIGHT=1}
var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		scale.x=direction

func to_left():direction=Direction.LEFT
func to_right():direction=Direction.RIGHT
