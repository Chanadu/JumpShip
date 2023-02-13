extends Area2D

export var lerpFactor := .3;

var isMouseOver := false;
var isDragging := false;
var inMouseExitTimer := false;

var mouse_position := Vector2(0, 0);


func _ready() -> void:
	TileManager.object_moved(position.x, position.y, name);


func _physics_process(_delta : float) -> void:
	process_inputs()


func process_inputs() -> void:
	if isMouseOver and Input.is_action_just_pressed("click"):
		isDragging = true;
	if isDragging:
		if Input.is_action_pressed("click"):
			move_with_mouse();
			TileManager.object_removed(name)
		if Input.is_action_just_released("click"):
			isDragging = false;
			snap_to_grid(mouse_position);
			TileManager.object_moved(position.x, position.y, name);
			#print(TileManager.to_string());


func move_with_mouse() -> void:
	position = lerp(position, mouse_position, lerpFactor);


func snap_to_grid(location : Vector2) -> void:
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
			print("Wow that is wild. Line 66 Alien.gd unhanded case.");
			print("MouseX: ", mouseX, " MouseY: ", mouseY, " Left: ", TileManager.is_tile_taken(x - 16, y), " Right: ", TileManager.is_tile_taken(x + 16, y), " Up: ", TileManager.is_tile_taken(x, y + 16), " Down: ", TileManager.is_tile_taken(x, y - 16));
		
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
