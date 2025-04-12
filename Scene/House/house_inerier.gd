extends Node2D

@onready var animation_wall = %Animation_wall


func _on_area_player_body_entered(body):
	if body.has_method("player"):
		animation_wall.play("visible_wall")
		get_tree().call_group("item_in_home", "area_on")

func _on_area_player_body_exited(body):
	if body.has_method("player"):
		animation_wall.play_backwards("visible_wall")
		get_tree().call_group("item_in_home", "area_off")
