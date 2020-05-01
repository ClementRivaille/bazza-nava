extends ViewportContainer
class_name FiltersManager

export(Array, Shader) var shaders: Array
export(Array, int) var orthogonal: Array = []
export(Array, Array, AudioEffect) var audio_effects: Array

onready var camera: Camera = $Viewport/Main/Camera

var pool: Array

var filter_on := false

func _ready():
  pool = range(shaders.size())
  pool.shuffle()

func _input(event: InputEvent):
  if event.is_action_pressed("0"):
    camera.projection = Camera.PROJECTION_PERSPECTIVE
    if (filter_on):
      material.shader = null
      filter_on = false
    else:
      var shader_idx := select_shader()
      var shader: Shader = shaders[shader_idx]
      material.shader = shader
      filter_on = true
      
      if (orthogonal.find(shader_idx) > -1):
        camera.projection = Camera.PROJECTION_ORTHOGONAL
      
func select_shader() -> int:
  var shader_idx :int = pool.pop_front()
  
  if pool.size() == 0:
    pool = range(shaders.size())
    pool.shuffle()
  
  return shader_idx