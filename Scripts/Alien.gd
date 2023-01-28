extends Area2D


export var tileSize := 16.0;

export var lerpFactor := .3

var isMouseOver := false;
var isDragging := false;
var inMouseExitTimer := false;

var colliding := [false, false, false, false];

var mouse_position := Vector2(0, 0);

enum collision {
	LEFT,
	RIGHT,
	UP,
	DOWN
};

func _ready() -> void:
	pass


func _physics_process(_delta : float) -> void:
	process_inputs()


func process_inputs() -> void:
	if isMouseOver and Input.is_action_just_pressed("click"):
		isDragging = true;
	if isDragging:
		if Input.is_action_pressed("click"):
			move_with_mouse();
		if Input.is_action_just_released("click"):
			isDragging = false;
			snap_to_grid(mouse_position);


func move_with_mouse() -> void:
	position = lerp(position, mouse_position, lerpFactor);
	


func snap_to_grid(location : Vector2) -> void:
	var x := location.x;
	var y := location.y;
	x = floor(x / tileSize) * tileSize + (tileSize / 2);
	y = floor(y / tileSize) * tileSize + (tileSize / 2);
	position = Vector2(x, y);


func _on_Alien_mouse_entered() -> void:
	isMouseOver = true;
	if inMouseExitTimer:
		inMouseExitTimer = false;


func _on_Alien_mouse_exited() -> void:
	inMouseExitTimer = true;
	yield(get_tree().create_timer(.1), "timeout");
	if inMouseExitTimer:
		inMouseExitTimer = false;
		isMouseOver = false;


func _on_RayCastLeft_ray_cast_collided(collided : bool):
	colliding[collision.LEFT] = collided;

func _on_RayCastRight_ray_cast_collided(collided : bool):
	colliding[collision.RIGHT] = collided;


func _on_RayCastUp_ray_cast_collided(collided : bool):
	colliding[collision.UP] = collided;


func _on_RayCastDown_ray_cast_collided(collided : bool):
	colliding[collision.DOWN] = collided;


func _on_Mouse_mouse_moved(pos : Vector2):
	mouse_position = pos;
