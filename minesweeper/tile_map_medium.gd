extends Node

#grid consts
const ROWS : int = 17
const COLS : int = 17
const CELL_SIZE : int = 32

#tilemap variables
var tile_id : int = 0

#layer variables
var mine_layer : int = -4
var number_layer : int = -3
var grass_layer : int = -2
var flag_layer : int = -1
var hover_layer : int = 0
