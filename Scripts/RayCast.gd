extends RayCast2D


signal ray_cast_collided;


func _physics_process(_delta : float) -> void:
	if is_colliding() and get_collider().name != "Mouse":
		#print(name + " " + get_collider().name);
		emit_signal("ray_cast_collided", true);
	else:
		emit_signal("ray_cast_collided", false);

