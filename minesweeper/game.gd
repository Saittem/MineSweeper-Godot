extends Node2D

#game consts
@export var total_mines : int = 45
var time_elapsed : float
var remaining_mines : int

#nodes
@onready var HUD = $HUD
@onready var GameOver = $GameOver

func _ready():
	new_game()

func new_game():
	time_elapsed = 0
	remaining_mines = total_mines
	GameOver.hide()
	get_tree().paused = false

func _process(delta: float):
	time_elapsed += delta
	HUD.get_node("stopwatchLabel").text = str(int(time_elapsed))
	HUD.get_node("flagsLabel").text = str(remaining_mines)
	
	if remaining_mines == 0:
		game_won()

func _on_tile_map_flag_placed():
	remaining_mines -= 1

func _on_tile_map_flag_removed():
	remaining_mines += 1

func end_game():
	GameOver.show()
	get_tree().paused = true

func game_won():
	end_game()
	GameOver.get_node("Panel/Label").text = "Won"

func _on_tile_map_game_lost():
	end_game()
	GameOver.get_node("Panel/Label").text = "Lost"
