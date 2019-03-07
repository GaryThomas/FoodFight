extends KinematicBody

const PROJECTILE_SPEED = 0.5

func fire():
	print("Fire!")
	var bullet = load("res://Scenes/Ammo/Projectile.tscn").instance()
	add_child(bullet)
	bullet.set_as_toplevel(true)
	bullet.global_transform = $ForwardLaunchPoint.global_transform
	var character_forward = get_global_transform().basis[2].normalized()
	bullet.set_linear_velocity(PROJECTILE_SPEED * character_forward)
	print(str(character_forward))
	bullet.add_collision_exception_with(self)

