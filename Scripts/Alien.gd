extends Area2D

onready var tileManager := get_node("/root/TileManager");
export var tileSize := 16;

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
	tileManager.object_moved(position.x, position.y, name);


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
			tileManager.object_moved(position.x, position.y, name);
			print(tileManager.to_string());


func move_with_mouse() -> void:
	position = lerp(position, mouse_position, lerpFactor);


func snap_to_grid(location : Vector2) -> void:
	var x := location.x;
	var y := location.y;
# warning-ignore:integer_division
	x = floor(x / tileSize) * tileSize + floor((tileSize / 2));
# warning-ignore:integer_division
	y = floor(y / tileSize) * tileSize + floor((tileSize / 2));
	if colliding[collision.LEFT] or colliding[collision.RIGHT] or colliding[collision.UP] or colliding[collision.DOWN]:
		var locationX := int(location.x)  % tileSize;
		var locationY := int(location.y) % tileSize;
		#print(str(locationX) + "  " + str(locationY));
		
		if locationX <= 7 and not colliding[collision.LEFT]:
			x -= tileSize;
		elif not colliding[collision.RIGHT]:
			x += tileSize;
		elif locationY < 7 and not colliding[collision.UP]:
			y -= tileSize;
		elif not colliding[collision.DOWN]:
			y += tileSize;
		else:
			printerr("Line 65 Alien.gd unhandled case because I thought this should never run anyway.");
			print("MX: ", locationX, "MY: ", locationY, "Left: ", colliding[collision.LEFT], "Right: ", colliding[collision.RIGHT], "UP: ", colliding[collision.UP], "Down: ", colliding[collision.DOWN]);
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


func _on_Mouse_moved(pos : Vector2) -> void:
	mouse_position = pos;
