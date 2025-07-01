extends Node

#grid consts
const ROWS : int = 17
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

#array to store mine coords
var mine_coords := []

func _ready():
	new_game()

func new_game():
	tilemap_clear()
	mine_coords.clear()
	generate_mines()

func generate_mines():
	for i in range(get_parent().TOTAL_MINES):
		var mine_pos = Vector2i(randi_range(0, COLS - 1), randi_range(2, ROWS - 1))
		mine_coords.append(mine_pos)
		#add mine to tilemaplayer
		mines_tilemaplayer.set_cell(mine_pos, tile_id, mine_atlas)

func tilemap_clear():
	hover_tilemaplayer.clear()
	flags_tilemaplayer.clear()
	grass_tilemaplayer.clear()
	numbers_tilemaplayer.clear()
	mines_tilemaplayer.clear()
