extends Control

@onready var center_container_setting = %CenterContainer_setting

@onready var volume = %Volume
@onready var mute = %Mute
@onready var button_back = %Button_back


func _ready():
	center_container_setting.visible = false
	volume.mouse_filter = MOUSE_FILTER_IGNORE
	mute.mouse_filter = MOUSE_FILTER_IGNORE
	button_back.mouse_filter = MOUSE_FILTER_IGNORE




func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)


func _on_button_pressed(): # кнопка назад
	center_container_setting.visible = false
	volume.mouse_filter = MOUSE_FILTER_IGNORE
	mute.mouse_filter = MOUSE_FILTER_IGNORE
	button_back.mouse_filter = MOUSE_FILTER_IGNORE

func setting_visible():
	center_container_setting.visible = true
	volume.mouse_filter = MOUSE_FILTER_PASS
	mute.mouse_filter = MOUSE_FILTER_PASS
	button_back.mouse_filter = MOUSE_FILTER_PASS
