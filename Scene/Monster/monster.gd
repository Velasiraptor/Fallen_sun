extends CharacterBody2D

@export var speed = 300
@export var get_scene: NodePath

@export var monster_on := false

@onready var animation_shake = %Animation_Shake
@onready var monster_sprite = %Monster_sprite
@onready var monster_end = %Monster_end
@onready var light = %Light
@onready var audio_die = %Audio_die
@onready var audio_move = %Audio_move
@onready var animation_end = %Animation_end

@onready var collision_monster = %Collision_monster
@onready var area_die = %Area_die


var target = position
var save_speed: int
var save_position_light
var victory_game := false

func _ready():
	save_speed = speed
	save_position_light = light.position.x
	monster_sprite.visible = true
	monster_end.visible = false


func _physics_process(delta):
	if velocity.x > 0:
		monster_sprite.flip_h = false
		light.position.x = save_position_light
	elif velocity.x < 0:
		monster_sprite.flip_h = true
		light.position.x = -save_position_light
	
	if monster_on:
		velocity = position.direction_to(target) * speed
		#look_at(target)
		if position.distance_to(target) > 5 and Globals.count_win_item.size() < 9:
			collision_monster.disabled = false
			move_and_slide()
		elif position.distance_to(target) > 5 and Globals.count_win_item.size() == 9:
			velocity = position.direction_to(target) * speed
			monster_sprite.visible = false
			monster_end.visible = true
			collision_monster.disabled = true
			move_and_slide()


func monster_start():
	audio_move.play()
	await get_tree().create_timer(2.0).timeout
	monster_on = true


func get_position_item(random_item_in_items):
	target = random_item_in_items


func monster():
	pass


func _on_area_die_area_entered(area): # Реагирование на фонарь
	if Globals.count_win_item.size() == 9:
		animation_end.play("the_end_monster")
	else:
		animation_shake.play("die")


func _on_area_die_area_exited(area):
	if Globals.count_win_item.size() == 9:
		animation_end.play_backwards("the_end_monster")
	else:
		animation_shake.play_backwards("die")


func _on_area_die_body_entered(body: Node2D) -> void:
	if Globals.count_win_item.size() == 9 and not victory_game:
		if body.has_method("player"):
			body.player_defeat() # Функция внутри игрока
			die()


func zero_speed():
	speed = 0
func max_speed():
	speed = save_speed


func die(): # Смерть
	queue_free()


func the_end():
	get_tree().call_group("Player", "move_player_off")
	victory_game = true
	get_tree().call_group("World", "the_end_game")
