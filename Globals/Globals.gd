extends Node

var count_win_item := []
var step_to_monster: int

var count_victory: = 2

func _ready() -> void:
	step_to_monster = randi_range(2, 3)
