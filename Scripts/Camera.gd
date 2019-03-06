extends Camera

export var mouse_sensitivity = 1200

onready var Player = get_parent()

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _input(event):
	if event is InputEventMouseMotion:
		return mouse(event)
		
func mouse(event):
	Player.set_rotation(look_left_rignt(-event.relative.x / mouse_sensitivity))
	self.set_rotation(look_up_down(-event.relative.y / mouse_sensitivity))
	
func look_left_rignt(amount):
	return Player.get_rotation() + Vector3(0, amount, 0)
	
func look_up_down(amount):
	var new_rotation = self.get_rotation() + Vector3(amount, 0, 0)
	new_rotation.x = clamp(new_rotation.x, PI / -2, PI / 2)
	return new_rotation

