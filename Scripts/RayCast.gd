extends RayCast2D


#signal ray_cast_collided;


func _physics_process(_delta : float) -> void:
	pass
	if is_colliding() and get_collider().name != "Mouse":
		#print(name + " " + get_collider().name);
		#emit_signal("ray_cast_collided", true);
		pass
	else:
		#emit_signal("ray_cast_collided", false);
		pass

