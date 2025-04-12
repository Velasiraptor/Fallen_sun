extends Area2D

@export var speed_animation: float = 1.0 ## По умолчанию переменная умножается на 2 секунды 

@onready var animation_item = %Animation_item
@onready var fire = %Fire
@onready var audio = %Audio
@onready var audio_slow = %Audio_slow
@onready var audio_speed = %Audio_speed
@onready var audio_die = %Audio_die


var item_win := false
var item_eat_monster := false

func _ready():
	animation_item.speed_scale = speed_animation # Присваиваем скорость анимации


func _on_body_entered(body): # Для монстра
	if body.has_method("monster") and item_win:
		item_eat_monster = true
		animation_item.play_backwards("life") 
		audio_speed.stop()
		audio_slow.play()
		await get_tree().create_timer(0.2).timeout
		body.queue_free()
		audio_die.play()
		await get_tree().create_timer(2.1).timeout # Время анимации +0.1
		item_eat_monster = false


func _on_area_entered(area): # Для игрока
	if not item_win and not item_eat_monster:
		animation_item.play("life")
		audio_slow.stop()
		audio_speed.play()


func _on_area_exited(area):
	if not item_win and not item_eat_monster and animation_item.is_playing():
		animation_item.play_backwards("life")
		audio_speed.stop()
		audio_slow.play()


func win():
	item_win = true


func defeat():
	item_win = false


func animation_fire():
	fire.play()
