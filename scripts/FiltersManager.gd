extends ViewportContainer
class_name FiltersManager

export(Array, Shader) var shaders: Array
export(Array, int) var orthogonal: Array = []
export(Array, Array, AudioEffect) var audio_effects: Array
export(String) var effects_bus := "Effects"

onready var camera: Camera = $Viewport/Main/Camera
onready var main: GameManager = $Viewport/Main

var pool: Array
var filter_on := false

var locked := true
var players_to_wait := 9

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
  
  # Connect instruments to unlock
  var instruments: Array = get_tree().get_nodes_in_group("instrument")
  for i in instruments:
    var instrument: Instrument = i as Instrument
    instrument.connect("triggered", self, "_on_instrument_trigger")
  main.connect("end", self, "_on_end")
  main.connect("restart", self, "_on_restart")

func _input(event: InputEvent):
  if !locked && event.is_action_pressed("0"):
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
  
func _on_instrument_trigger():
  players_to_wait -= 1
  if players_to_wait <= 0:
    locked = false
    
func _on_end():
  locked = true
  # Remove filter
  if (filter_on):
    camera.projection = Camera.PROJECTION_PERSPECTIVE
    material.shader = null
    filter_on = false
    remove_audio_effects()
    
func _on_restart():
  locked = false