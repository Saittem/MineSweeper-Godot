extends Node2D

#game consts
@export var total_mines : int
var time_elapsed : float
var remaining_mines : int

#nodes
@onready var HUD = $HUD
@onready var GameOver = $GameOver

func _ready() -> void:
	var new_background
	
	if (Global.difficulty == "easy"):
		total_mines = Global.MINE_COUNT_EASY
		new_background = load("res://sprites/background-easy.png")
	elif (Global.difficulty == "medium"):
		total_mines = Global.MINE_COUNT_MEDIUM
		new_background = load("res://sprites/background-medium.png")
	elif (Global.difficulty == "hard"):
		total_mines = Global.MINE_COUNT_HARD
		new_background = load("res://sprites/background-hard.png")
	
	$Background.texture = new_background
	$Background.position = Vector2(new_background.get_width()/2, (new_background.get_height()/2) + 64)
	new_game()

func new_game() -> void:
	time_elapsed = 0
	remaining_mines = total_mines
	$TileMap.new_game()
	GameOver.hide()
	get_tree().paused = false

func _process(delta: float) -> void:
	time_elapsed += delta
	HUD.get_node("stopwatchLabel").text = str(int(time_elapsed))
	HUD.get_node("flagsLabel").text = str(remaining_mines)

func _on_tile_map_flag_placed() -> void:
	remaining_mines -= 1

func _on_tile_map_flag_removed() -> void:
	remaining_mines += 1

func end_game() -> void:
	GameOver.show()
	get_tree().paused = true

func game_won() -> void:
	end_game()
	GameOver.get_node("Panel/Label").text = "Won"

func _on_tile_map_game_lost() -> void:
	end_game()
	GameOver.get_node("Panel/Label").text = "Lost"

func _on_game_over_restart() -> void:
	new_game()

func _on_tile_map_game_won() -> void:
	game_won()
