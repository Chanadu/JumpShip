extends KinematicBody2D


signal mouse_moved;


func _physics_process(delta) -> void:
	var pos := position;
	# I have no idea how this works
	var _collisions := move_and_slide((get_global_mouse_position() - position) / delta);
	if (pos != position):
		emit_signal("mouse_moved", position);
