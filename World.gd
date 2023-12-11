@tool
extends Sprite2D
var height = preload("res://height.tres") as NoiseTexture2D
var height_noise = preload("res://height-noise.tres") as FastNoiseLite
var panning = false
var panning_pos :Vector2
var height_pos : Vector3
func _process(_delta):
	var pos = get_global_mouse_position()
		
	if Input.is_action_just_pressed("mouse_button"):
		panning = true
		panning_pos = pos
		height_pos = height_noise.offset
	if Input.is_action_just_released("mouse_button"):
		panning = false	
		
	if panning:
		var xx = height_pos.x + (panning_pos.x - pos.x)
		var yy = height_pos.y + (panning_pos.y - pos.y)
		height_noise.offset = Vector3(xx, yy, 0.0)
		
	var sunPos = Vector3(pos.x/1920, pos.y/1024, 2.)
	var mat = material as ShaderMaterial
	
	height.noise = height_noise
	mat.set_shader_parameter("shadow", !panning)
	mat.set_shader_parameter("height", height)
	mat.set_shader_parameter("sunPos", sunPos)

func _on_zoom_in_button_down():
	height_noise.frequency -= .0001


func _on_zoom_out_button_down():
	height_noise.frequency += .0001
