extends ViewportContainer
class_name FiltersManager

export(Array, Shader) var shaders: Array
export(Array, int) var orthogonal: Array = []
export(Array, Array, AudioEffect) var audio_effects: Array
export(String) var effects_bus := "Effects"

onready var camera: Camera = $Viewport/Main/Camera

var pool: Array
var filter_on := false

var EFFECT_BUS_PREFIX = 'effect'

func _ready():
  # Create effect buses
  for effects_idx in range(audio_effects.size()):
    AudioServer.add_bus(1)
    AudioServer.set_bus_name(1, EFFECT_BUS_PREFIX + str(effects_idx))
    var effects_list: Array = audio_effects[effects_idx]
    for _f in effects_list:
      var effect: AudioEffect = _f
      AudioServer.add_bus_effect(1, effect)
    AudioServer.set_bus_send(1, "Master")
  
  pool = range(shaders.size())
  pool.shuffle()

func _input(event: InputEvent):
  if event.is_action_pressed("0"):
    camera.projection = Camera.PROJECTION_PERSPECTIVE
    if (filter_on):
      material.shader = null
      filter_on = false
      remove_audio_effects()
    else:
      var shader_idx := select_shader()
      var shader: Shader = shaders[shader_idx]
      material.shader = shader
      add_audio_effects(shader_idx)
      filter_on = true
      
      if (orthogonal.find(shader_idx) > -1):
        camera.projection = Camera.PROJECTION_ORTHOGONAL
      
func select_shader() -> int:
  var shader_idx :int = pool.pop_front()
  
  if pool.size() == 0:
    pool = range(shaders.size())
    pool.shuffle()
  
  return shader_idx

func remove_audio_effects():
  var effects_bus_idx := AudioServer.get_bus_index(effects_bus)
  AudioServer.set_bus_send(effects_bus_idx, "Master")
    
func add_audio_effects(effect_idx: int):
  var effects_bus_idx := AudioServer.get_bus_index(effects_bus)
  AudioServer.set_bus_send(effects_bus_idx, EFFECT_BUS_PREFIX + str(effect_idx))