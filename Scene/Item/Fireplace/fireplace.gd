extends Area2D

@export var speed_animation: float = 1.0 ## По умолчанию переменная умножается на 2 секунды 

@onready var animation_item = %Animation_item
@onready var fire = %Fire
@onready var audio = %Audio
@onready var audio_slow = %Audio_slow
@onready var audio_speed = %Audio_speed
@onready var collision = %Collision


var item_win := false
var item = "Fireplace"


func _ready():
	animation_item.speed_scale = speed_animation # Присваиваем скорость анимации


func _on_area_entered(area): # Для игрока
	if not item_win:
		animation_item.play("life")
		audio_slow.stop()
		audio_speed.play()


func _on_area_exited(area):
	if not item_win and animation_item.is_playing():
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
		Globals.count_win_item.erase(item)
	else:
		pass
	
	if Globals.count_win_item.size() >= Globals.count_victory:
		pass # Монстр выходит в центр
	else:
		Globals.step_to_monster -= 1
		if Globals.step_to_monster <= 0:
			Globals.step_to_monster = randi_range(2, 3)
			get_tree().call_group("World", "spawn_monster_active")


func defeat():
	item_win = false


func animation_fire():
	fire.play()

func animation_fire_off():
	fire.pause()


func area_on():
	monitoring = true


func area_off():
	monitoring = false
