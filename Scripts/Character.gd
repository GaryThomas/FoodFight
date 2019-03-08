extends KinematicBody

const PROJECTILE_SPEED = 0.5

var ammo_types = {}

func _enter_tree():
	ammo_types = file_grabber.get_files("res://Scenes/Ammo/AmmoModels/")
	randomize()

func fire():
	var random_bullet = ammo_types[randi() % ammo_types.size()]
	var bullet = load(random_bullet).instance()
	add_child(bullet)
	bullet.set_as_toplevel(true)
	bullet.global_transform = $ForwardLaunchPoint.global_transform
	print(str(bullet.global_transform))
	var character_forward = get_global_transform().basis[2].normalized()
	bullet.set_linear_velocity(PROJECTILE_SPEED * character_forward)
	print(str(character_forward))
	bullet.add_collision_exception_with(self)

