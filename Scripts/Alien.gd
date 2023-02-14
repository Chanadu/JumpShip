extends Area2D

enum AlienTypes {
	Blue,
	Red,
	Purple,
	Green
};

var alienTypesToString := {
	AlienTypes.Blue: "blue",
	AlienTypes.Red: "red",
	AlienTypes.Purple: "purple",
	AlienTypes.Green: "green"
};

export(AlienTypes) var alienType = AlienTypes.Blue;
export var lerpFactor := .3;

var isMouseOver := false;
var isDragging := false;
var inMouseExitTimer := false;

var mousePosition : Vector2;
var originalPosition : Vector2;


func _ready() -> void:
	TileManager.object_moved(position.x, position.y, name);
	$Sprite.play(alienTypesToString[alienType])


func _physics_process(_delta : float) -> void:
	process_inputs()


func process_inputs() -> void:
	if isMouseOver and Input.is_action_just_pressed("click"):
		isDragging = true;
		originalPosition = position;
	if isDragging:
		if Input.is_action_pressed("click"):
			move_with_mouse();
			TileManager.object_removed(name)
		if Input.is_action_just_released("click"):
			isDragging = false;
			if snap_to_grid(mousePosition):
				#print(position, originalPosition);
				position = originalPosition;
			TileManager.object_moved(position.x, position.y, name);


func move_with_mouse() -> void:
	position = lerp(position, mousePosition, lerpFactor);


func snap_to_grid(location : Vector2) -> bool:
	var x := floor(location.x / Consts.TILE_SIZE) * Consts.TILE_SIZE + Consts.HALF_TILE;
	var y := floor(location.y / Consts.TILE_SIZE) * Consts.TILE_SIZE + Consts.HALF_TILE;
	
	if TileManager.is_tile_taken(x, y):
		var mouseX := int(location.x) % Consts.TILE_SIZE;
		var mouseY := int(location.y) % Consts.TILE_SIZE;
		
		if mouseX <= 7 and !TileManager.is_tile_taken(x - 16, y):
			x -= 16;
		elif mouseX >= 8 and !TileManager.is_tile_taken(x + 16, y):
			x += 16;
		elif mouseY <= 7 and !TileManager.is_tile_taken(x, y - 16):
			y -= 16;
		elif mouseY >= 8 and !TileManager.is_tile_taken(x, y + 16):
			y += 16;
		elif !TileManager.is_tile_taken(x - 16, y):
			x -= 16;
		elif !TileManager.is_tile_taken(x + 16, y):
			x += 16;
		elif !TileManager.is_tile_taken(x, y - 16):
			y -= 16;
		elif !TileManager.is_tile_taken(x, y + 16):
			y += 16;
		else:
			return true;
			#print("MouseX: ", mouseX, " MouseY: ", mouseY, " Left: ", TileManager.is_tile_taken(x - 16, y), " Right: ", TileManager.is_tile_taken(x + 16, y), " Up: ", TileManager.is_tile_taken(x, y + 16), " Down: ", TileManager.is_tile_taken(x, y - 16));
	position = Vector2(x, y);
	return false;


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
	mousePosition = pos;
