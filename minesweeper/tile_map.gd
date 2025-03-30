extends TileMap

#grid values
const ROWS : int = 17
const COLS : int = 17
const CELL_SIZE : int = 32

#tilemap
var tile_id : int = 0

#layer values
var mine_layer : int = 0
var numer_layer : int = 1
var cover_layer : int = 2
var flag_layer : int = 3
var hover_layer : int = 4

#array of mine coordiantes
var minecoords = []

#executes on start
func _ready():
	new_game()

func new_game():
	clear()
	minecoords.clear()
	generate_mines()

func generate_mines():
	pass
