extends Node2D


var takenSquares := {
	# ID: Vector2(x, y)
};


func object_moved(x : int, y : int, id : String) -> void:
	takenSquares[id] = Vector2(x, y);


func is_tile_taken(x : int, y : int) -> bool:
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
