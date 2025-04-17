extends CharacterBody2D

@export var speed = 400

@onready var rabbit = %Rabbit
@onready var light_big = %Light_big
@onready var light_ray = %Light_Ray
@onready var area_light = %Area_light
@onready var audio_step = %Audio_step
@onready var animation_die: AnimationPlayer = %Animation_die
@onready var animation_idle = %Animation_idle


var light_big_position: Vector2
var light_ray_position: Vector2
var area_light_position: Vector2

var player_die := false

func _ready():
	light_big_position = light_big.position
	light_ray_position = light_ray.position
	area_light_position = area_light.position


func _physics_process(delta):
	if not player_die:
		get_input()
		animation_player()
		move_and_slide()


func get_input():
	light_ray.look_at(get_global_mouse_position())
	area_light.look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed


func animation_player():
	if Input.is_action_pressed("ui_left"):
		rabbit.flip_h = true
		light_big.position.x = -light_big_position.x
		light_ray.position.x = -light_ray_position.x
		area_light.position.x = -area_light_position.x
	elif Input.is_action_pressed("ui_right"):
		rabbit.flip_h = false
		light_big.position.x = light_big_position.x
		light_ray.position.x = light_ray_position.x
		area_light.position.x = area_light_position.x
	if velocity == Vector2(0,0):
		rabbit.play("idle")
		animation_idle.play("idle")
	else:
		rabbit.play("walk")
		animation_idle.stop()


func player():
	pass


func player_defeat():
	animation_idle.stop()
	Globals.fall = true
	get_tree().call_group("World", "monster_in_world_off")
	get_tree().call_group("World", "camera_die")
	player_die = true
	rabbit.play("idle")
	animation_die.play("die")


func move_player_off():
	player_die = true


func back_MM():
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scene/Menu/main_menu.tscn")
