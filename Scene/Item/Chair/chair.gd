extends Area2D

@export var speed_animation: float = 1.0 ## По умолчанию переменная умножается на 2 секунды 

@onready var animation_item = %Animation_item
@onready var audio = %Audio
@onready var audio_slow = %Audio_slow
@onready var audio_speed = %Audio_speed
@onready var collision = %Collision
@onready var animation_chair = %Animation_chair


var item_win := false
var item = "Chair"


func _ready():
	animation_item.speed_scale = speed_animation # Присваиваем скорость анимации


func _on_area_entered(area): # Для игрока
	if not item_win and not area.get_parent().has_method("monster"):
		animation_item.play("life")
		audio_slow.stop()
		audio_speed.play()


func _on_area_exited(area):
	if not item_win and animation_item.is_playing() and not area.get_parent().has_method("monster"):
		animation_item.play_backwards("life")
		if item in Globals.count_win_item:
			Globals.count_win_item.erase(item)
		else:
			pass
		audio_speed.stop()
		audio_slow.play()


func win():
	item_win = true
	if item in Globals.count_win_item:
		pass
	else:
		Globals.count_win_item.append(item)
		get_tree().call_group("World", "music")
	
	if Globals.count_win_item.size() >= Globals.count_victory:
		pass # Монстр выходит в центр
		get_tree().call_group("World", "timer_stop")
	
	animation_chair.play("rotation")


func defeat():
	item_win = false


func area_on():
	monitoring = true


func area_off():
	monitoring = false
