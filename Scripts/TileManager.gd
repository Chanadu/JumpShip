extends Node2D


onready var tileMap : TileMap = get_node("/root/Main/TileMap");

var takenSquares := {
	# ID: Vector2(x, y)
};


func _ready():
	add_tileMap_tiles()
	pass


func add_tileMap_tiles():
	var tiles := tileMap.get_used_cells();
	for i in range(len(tiles)):
		if tileMap.tile_set.tile_get_name(tileMap.get_cellv(tiles[i])) == "Space":
			object_moved(tileMap.map_to_world(tiles[i]).x + Consts.HALF_TILE, tileMap.map_to_world(tiles[i]).y + Consts.HALF_TILE, "Tile"+ str(i));


func object_removed(id : String) -> void:
	takenSquares[id] = null;


func object_moved(x : float, y : float, id : String) -> void:
	takenSquares[id] = Vector2(x, y);


func is_tile_taken(x : float, y : float) -> bool:
	var id := find_position(Vector2(x, y));
	if id == "":
		return false;
	return true;


func clear_all_squares() -> void:
	takenSquares.clear();


func to_string() -> String:
	return str(takenSquares);


func find_position(pos : Vector2) -> String:
	for id in takenSquares:
		if takenSquares[id] == pos:
			return id;
	return "";
