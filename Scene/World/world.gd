extends Node2D

@export var new_monster: PackedScene

@onready var monsters = %Monsters
@onready var items = %Items
@onready var spawners_monster = %Spawners_monster



#func _ready():
	#await get_tree().create_timer(6.0).timeout
	#spawn_monster_active()


func spawn_monster_active():
	var random_spawn_monster_position = spawners_monster.get_children().pick_random()
	random_spawn_monster_position = random_spawn_monster_position.global_position
	monsters.add_child(new_monster.instantiate())
	var random_item_in_items = []
	for child in items.get_children():
		if str(child.name) in Globals.count_win_item:
			random_item_in_items.append(child)
	if random_item_in_items.size() > 0: # Если хотя бы 1 предмет активирован
		random_item_in_items = random_item_in_items.pick_random()
		random_item_in_items = random_item_in_items.global_position
		get_tree().call_group("Monster", "get_position_item", random_item_in_items)
		get_tree().call_group("Monster", "monster_start")
	else:
		pass
	
