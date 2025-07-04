extends Node

#signals
signal flag_placed
signal flag_removed
signal game_lost

#grid consts
const Y_OFFSET : int = 2
const ROWS : int = 17 + Y_OFFSET
const COLS : int = 17
const CELL_SIZE : int = 32

#tilemap variables
var tile_id : int = 0

#tilemaplayers
@onready var hover_tilemaplayer = $Hover
@onready var flags_tilemaplayer = $Flags
@onready var grass_tilemaplayer = $Grass
@onready var numbers_tilemaplayer = $Numbers
@onready var mines_tilemaplayer = $Mines

#layer variables
#var mine_layer : int = -4
#var number_layer : int = -3
#var grass_layer : int = -2
#var flag_layer : int = -1
#var hover_layer : int = 0

#atlas tile coords
var mine_atlas := Vector2i(4, 0)
var number_atlas : Array = generate_number_atlas()
var hover_atlas := Vector2i(6, 0)
var flag_atlas := Vector2i(5, 0)

#array to store mine coords
var mine_coords := []

func generate_number_atlas():
	var a := []
	for i in range(8):
		a.append(Vector2i(i, 1))
	return a

func _ready():
	new_game()

func _input(event):
	if event is InputEventMouseButton:
		#checks if the mouse is on the game board
		if (event.position.y < ROWS * CELL_SIZE) and (event.position.y >= 2 * CELL_SIZE):
			var map_pos : Vector2i = hover_tilemaplayer.local_to_map(event.position)
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if not is_flag(map_pos):
					if is_mine(map_pos):
						grass_tilemaplayer.clear()
						game_lost.emit()
					else:
						process_left_click(map_pos)
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				process_right_click(map_pos)

func process_left_click(pos):
	var revealed_cells := []
	var cells_to_reveal := [pos]
	while not cells_to_reveal.is_empty():
		grass_tilemaplayer.erase_cell(cells_to_reveal[0])
		revealed_cells.append(cells_to_reveal[0])
		if is_flag(cells_to_reveal[0]):
			flags_tilemaplayer.erase_cell(cells_to_reveal[0])
			flag_removed.emit()
		if not is_number(cells_to_reveal[0]):
			cells_to_reveal = reveal_surrounding_cells(cells_to_reveal, revealed_cells)
		cells_to_reveal.erase(cells_to_reveal[0])

func process_right_click(pos):
	#checks if it is a grass cell
	if is_grass(pos):
		if is_flag(pos):
			flags_tilemaplayer.erase_cell(pos)
			flag_removed.emit()
		else:
			flags_tilemaplayer.set_cell(pos, tile_id, flag_atlas)
			flag_placed.emit()

func reveal_surrounding_cells(cells_to_reveal, revealed_cells):
	for i in get_all_surround_cells(cells_to_reveal[0]):
		# skip if already revealed or mine
		if not revealed_cells.has(i) and not is_mine(i):
			if not cells_to_reveal.has(i):
				cells_to_reveal.append(i)
	return cells_to_reveal

func _process(_delta):
	highlight_cell()

func highlight_cell():
	var mouse_pos : Vector2i = hover_tilemaplayer.local_to_map(hover_tilemaplayer.get_local_mouse_position())
	hover_tilemaplayer.clear()
	#hover over grass
	if is_grass(mouse_pos):
		hover_tilemaplayer.set_cell(mouse_pos, tile_id, hover_atlas)

func new_game():
	tilemap_clear()
	mine_coords.clear()
	generate_mines()
	generate_numbers()
	generate_grass()

func tilemap_clear():
	hover_tilemaplayer.clear()
	flags_tilemaplayer.clear()
	grass_tilemaplayer.clear()
	numbers_tilemaplayer.clear()
	mines_tilemaplayer.clear()

func generate_mines():
	for i in range(get_parent().total_mines):
		var mine_pos = Vector2i(randi_range(0, COLS - 1), randi_range(2, ROWS - 1))
		
		#checks if the position was already generated and if was generates again
		while mine_coords.has(mine_pos):
			mine_pos = Vector2i(randi_range(0, COLS - 1), randi_range(2, ROWS - 1))
		mine_coords.append(mine_pos)
		#add mine to tilemaplayer
		mines_tilemaplayer.set_cell(mine_pos, tile_id, mine_atlas)

func generate_numbers():
	for i in get_empty_cells():
		var mine_count : int = 0
		for j in get_all_surround_cells(i):
			if is_mine(j):
				mine_count += 1
		
		if mine_count > 0:
				numbers_tilemaplayer.set_cell(i, tile_id, number_atlas[mine_count - 1])

func generate_grass():
	for y in range(ROWS):
		for x in range(COLS):
			var toggle = ((x + y) % 2)
			grass_tilemaplayer.set_cell(Vector2i(x, y + 2), tile_id, Vector2i(3 - toggle, 0))

func get_empty_cells():
	var empty_cells := []
	for y in range(ROWS):
		for x in range(COLS):
			#checks if the cell is empty and adds it to the array
			if not is_mine(Vector2i(x, y+2)):
				empty_cells.append(Vector2i(x, y+2))
	return empty_cells

func get_all_surround_cells(center_cell):
	var surrounding_cells := []
	var target_cell
	for y in range(3):
		for x in range(3):
			target_cell = center_cell + Vector2i(x - 1, y - 1)
			#skip cell if is is the one in the center
			if target_cell != center_cell:
				#checks if the cell is on the grid
				if (target_cell.x >= 0 and target_cell.x <= COLS - 1
					and target_cell.y >= 0 and target_cell.y <= ROWS - 1):
					surrounding_cells.append(target_cell)
	return surrounding_cells

func is_mine(pos):
	return mines_tilemaplayer.get_cell_source_id(pos) != -1

func is_grass(pos):
	return grass_tilemaplayer.get_cell_source_id(pos) != -1

func is_flag(pos):
	return flags_tilemaplayer.get_cell_source_id(pos) != -1
	
func is_number(pos):
	return numbers_tilemaplayer.get_cell_source_id(pos) != -1
