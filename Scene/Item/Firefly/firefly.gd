extends Area2D

@export var speed_animation: float = 1.0 ## По умолчанию переменная умножается на 2 секунды 

@onready var animation_item = %Animation_item
@onready var firefly_animation = %Firefly_animation
@onready var audio = %Audio
@onready var audio_slow = %Audio_slow
@onready var audio_speed = %Audio_speed
@onready var audio_die = %Audio_die


var item_win := false
var item_eat_monster := false
var item = "Firefly"

func _ready():
	animation_item.speed_scale = speed_animation # Присваиваем скорость анимации


func _on_body_entered(body): # Для монстра
	if body.has_method("monster") and item_win and Globals.count_win_item.size() < Globals.count_victory:
		item_eat_monster = true
		animation_item.play_backwards("firefly") 
		Globals.count_win_item.erase(item)
		audio_speed.stop()
		audio_slow.play()
		await get_tree().create_timer(0.2).timeout
		body.queue_free()
		audio_die.play()
		await get_tree().create_timer(2.1).timeout # Время анимации +0.1
		item_eat_monster = false


func _on_area_entered(area): # Для игрока
	if not item_win and not item_eat_monster and not area.get_parent().has_method("monster"):
		animation_item.play("firefly")
		audio_slow.stop()
		audio_speed.play()


func _on_area_exited(area):
	if not item_win and not item_eat_monster and animation_item.is_playing() and not area.get_parent().has_method("monster"):
		animation_item.play_backwards("firefly")
		Globals.count_win_item.erase(item)
		audio_speed.stop()
		audio_slow.play()


func win():
	item_win = true
	if item in Globals.count_win_item:
		pass
	else:
		Globals.count_win_item.append(item)
	
	if Globals.count_win_item.size() >= Globals.count_victory:
		pass # Монстр выходит в центр
		get_tree().call_group("World", "timer_stop")


func defeat():
	item_win = false


func animation_firefly():
	firefly_animation.play("firefly")
func animation_firefly_off():
	firefly_animation.pause()
