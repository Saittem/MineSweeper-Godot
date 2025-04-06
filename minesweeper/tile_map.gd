extends TileMap

#grid values
const ROWS : int = 17
const COLS : int = 17
const CELL_SIZE : int = 32

#tilemap
var tile_id : int = 0

#layer values
var mine_layer : int = 0
var number_layer : int = 1
var cover_layer : int = 2
var flag_layer : int = 3
var hover_layer : int = 4

#atlas coordiantes
var mine_atlas = Vector2i(4, 0)
var number_atlas : Array = generate_number_atlas()

#array of mine coordiantes
var mine_coords = []

func generate_number_atlas():
	var a := []
	for i in range(8):
		a.append(Vector2i(i, 1))
	return a

#executes on start
func _ready():
	new_game()

func new_game():
	clear()
	mine_coords.clear()
	generate_mines()
	generate_numbers()
	generate_cover()

func generate_mines():
	for i in range(get_parent().TOTAL_MINES):
		var mine_position = Vector2i(randi_range(0, COLS - 1), randi_range(0, ROWS - 1))
		#check if mine_position doesn't already exist
		while mine_coords.has(mine_position):
			mine_position = Vector2i(randi_range(0, COLS - 1), randi_range(2, ROWS - 1))
		mine_coords.append(mine_position)
		
		#add mine to tilemap
		set_cell(mine_layer, mine_position, tile_id, mine_atlas)

func generate_numbers():
	#clear previous numbers in case the mine was moved
	clear_layer(number_layer)
	for i in get_empty_cells():
		var mine_count : int = 0
		for j in get_all_surrounding_cells(i):
			#check if there is a min in the cell
			if is_mine(j):
				mine_count += 1
		#once counted, add the number cell to the tilemap
		if mine_count > 0 :
			set_cell(number_layer, i, tile_id, number_atlas[mine_count - 1])

func generate_cover():
	for y in range(ROWS):
		for x in range(COLS):
			var toggle = ((x + y) % 2)
			set_cell(cover_layer, Vector2i(x, y), tile_id, Vector2i(3 - toggle, 0))

func get_empty_cells():
	var empty_cells = []
	
	for y in range(ROWS):
		for x in range(COLS):
			#check if cell is empty and add it to the array
			if not is_mine(Vector2i(x, y)):
				empty_cells.append(Vector2i(x, y))
	
	return empty_cells

func get_all_surrounding_cells(middle_cell):
	var surrounding_cells := []
	var target_cell
	for y in range(3):
		for x in range(3):
			target_cell = middle_cell + Vector2i(x - 1, y - 1)
			#skip cell if it is the one in the middle
			if target_cell != middle_cell:
				#check that the cell is on the grid
				if (target_cell.x >= 0 and target_cell.x <= COLS - 1
					and target_cell.y >= 0 and target_cell.y <= ROWS - 1):
						surrounding_cells.append(target_cell)
	return surrounding_cells

func is_mine(position):
	return get_cell_source_id(mine_layer, position) != -1
