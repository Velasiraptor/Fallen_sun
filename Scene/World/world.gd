extends Node2D

@export var new_monster: PackedScene

@onready var monsters = %Monsters
@onready var items = %Items
@onready var spawners_monster = %Spawners_monster
@onready var random_timer_spawn: RandomTimer = %RandomTimer_spawn
@onready var player: CharacterBody2D = %Player

var monster_in_world := false

func _ready():
	await get_tree().create_timer(5.0).timeout
	if not Globals.fall:
		random_timer_spawn.start_random()


func _process(delta: float) -> void:
	if monster_in_world:
		get_tree().call_group("Monster", "get_position_item", player.global_position)


func spawn_monster_active():
	if monsters.get_child_count() == 0:
		var random_spawn_monster_position = spawners_monster.get_children().pick_random()
		random_spawn_monster_position = random_spawn_monster_position.global_position
		monsters.add_child(new_monster.instantiate())
		monsters.get_child(0).global_position = random_spawn_monster_position
		
		if Globals.count_win_item.size() == 0:
			monster_in_world = true
			get_tree().call_group("Monster", "monster_start")
		else:
			var random_number = randi_range(1, 3)
			if random_number == 1:
				monster_in_world = true
				get_tree().call_group("Monster", "monster_start")
			else:
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
					monster_in_world = true
					get_tree().call_group("Monster", "monster_start")
	else:
		random_timer_spawn.start_random()


func _on_random_timer_spawn_timeout() -> void:
	if not Globals.fall:
		spawn_monster_active()
		random_timer_spawn.start_random()


func monster_in_world_off():
	monster_in_world = false
