extends Node2D

@export var new_monster: PackedScene

@onready var monsters = %Monsters
@onready var items = %Items
@onready var spawners_monster = %Spawners_monster
@onready var random_timer_spawn: RandomTimer = %RandomTimer_spawn
@onready var player: CharacterBody2D = %Player
@onready var camera = %Camera
@onready var marker_the_end = %Marker_the_end
@onready var animation_end = %Animation_End
@onready var audio_stream_player = %AudioStreamPlayer
@onready var instr = %Instr


var monster_in_world := false
var tween: Tween


func _ready():
	Globals.count_win_item = []
	Globals.count_victory = 9


func _process(delta: float) -> void:
	if monster_in_world:
		get_tree().call_group("Monster", "get_position_item", player.global_position)
	if Input.is_action_just_pressed("ui_accept") and instr.visible == true:
		instr.visible = false
		if not Globals.fall:
			random_timer_spawn.start_random()
	
	print(Globals.count_win_item.size())


func spawn_monster_active():
	if monsters.get_child_count() == 0:
		monsters.add_child(new_monster.instantiate())
		var rnd_marker = find_farthest_marker(player, spawners_monster)
		monsters.get_child(0).global_position = rnd_marker.global_position
		
		if Globals.count_win_item.size() <= 1:
			monster_in_world = true
			get_tree().call_group("Monster", "monster_start")
		else:
			var random_number = randi_range(1, 3)
			if random_number == 1 and Globals.count_win_item.size() < Globals.count_victory:
				monster_in_world = true
				get_tree().call_group("Monster", "monster_start")
			else:
				if Globals.count_win_item.size() >= Globals.count_victory:
					get_tree().call_group("Monster", "get_position_item", marker_the_end.global_position)
					get_tree().call_group("Monster", "monster_start")
				else:
					var random_item_in_items = []
					for child in items.get_children():
						if str(child.name) in Globals.count_win_item:
							random_item_in_items.append(child)
					if random_item_in_items.size() > 1: # Если хотя бы 1 предмет активирован
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
		if Globals.count_win_item.size() > 0:
			random_timer_spawn.min_wait_time = 13
			random_timer_spawn.max_wait_time = 18
		elif Globals.count_win_item.size() > 3:
			random_timer_spawn.min_wait_time = 12
			random_timer_spawn.max_wait_time = 15
		elif Globals.count_win_item.size() > 6:
			random_timer_spawn.min_wait_time = 10
			random_timer_spawn.max_wait_time = 15
		random_timer_spawn.start_random()


func monster_in_world_off():
	monster_in_world = false


func camera_die():
	tween = create_tween().set_parallel(true)
	
	tween.tween_property(camera, "zoom", Vector2(2.0, 2.0), 2.0)
	tween.tween_property(camera, "position", player.global_position + Vector2(0, 50), 2.0)


func timer_stop():
	random_timer_spawn.stop()
	await get_tree().create_timer(4.0).timeout
	spawn_monster_active()


func find_farthest_marker(player, spawners_monster):
	# Проверяем, что родительский узел существует
	
	var farthest_marker # Для хранения самого дальнего маркера
	var max_distance: float = -1.0      # Для хранения максимального расстояния
	
	# Проходим по всем дочерним узлам родителя
	for child in spawners_monster.get_children():
		# Вычисляем расстояние от player до текущего маркера
		var distance = player.global_position.distance_to(child.global_position)
		# Если это расстояние больше текущего максимума, обновляем значения
		if distance > max_distance:
			max_distance = distance
			farthest_marker = child
		# Возвращаем самый дальний маркер
	return farthest_marker


func the_end_game():
	animation_end.play("end_game")


func back_MM():
	get_tree().change_scene_to_file("res://Scene/Menu/main_menu.tscn")
