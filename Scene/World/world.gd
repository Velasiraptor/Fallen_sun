extends Node2D

@onready var monsters = %Monsters
@onready var items = %Items
@onready var spawners_monster = %Spawners_monster


func _ready():
	var random_item_in_items = items.get_children().pick_random()
	random_item_in_items = random_item_in_items.global_position
	get_tree().call_group("Monster", "get_position_item", random_item_in_items)
	var random_spawn_monster_position = spawners_monster.get_children().pick_random()
	random_spawn_monster_position = random_spawn_monster_position.global_position
	await get_tree().create_timer(12.0).timeout
	get_tree().call_group("Monster", "monster_start", random_spawn_monster_position)
