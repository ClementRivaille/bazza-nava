extends Spatial
class_name GameManager

signal loaded
signal start
signal intro_end
signal end
signal restart
signal toggle_collision_sound

onready var conductor: Conductor = $Conductor
onready var camera: Camera = $Camera
onready var loadingMaterialds: LoadingMaterials = $LoadingMaterials
onready var lights: LightsManager = $Lights
onready var timer: Timer = $Timer
onready var tween: Tween = $Tween

var started := false
var finished := false

var collision_sound := true

export(float) var camera_x_move := -24.0

func _ready():
  get_tree().call_group("instrument", "set_activated", false)
  conductor.connect("end_intro", self, "_on_intro_end")
  conductor.connect("end_song", self, "_on_song_end")
  loadingMaterialds.connect("loading_ready", self, "_on_loaded")

func _input(event: InputEvent):
  # Start screen
  if !started:
    
    # Start game
    if event.is_action_pressed("ui_accept"):
      conductor.start_song()
      started = true
      emit_signal("start")
      
      # Move camera
      var camera_new_position: Vector3 = Vector3() + camera.transform.origin
      camera_new_position.x += camera_x_move
      tween.interpolate_property(camera, "translation",
        camera.transform.origin, camera_new_position,
        conductor.get_intro_time(), Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
      tween.start()
      
  if finished:
    # Restart
    if event.is_action_pressed("ui_accept"):
      conductor.start_song()
      finished = false
      get_tree().call_group("instrument", "set_activated", true)
      lights.turn_on()
      emit_signal("restart")
      
  if event.is_action_pressed("toggle_collisions"):
    collision_sound = !collision_sound
    get_tree().call_group("instrument", "set_collision_sound", collision_sound)
    emit_signal("toggle_collision_sound", collision_sound)
  
func _on_intro_end():
  # After intro, activate players
  get_tree().call_group("instrument", "set_activated", true)
  emit_signal("intro_end")
  # clear materials for cache
  loadingMaterialds.clear()

func _on_song_end():
  # After intro, activate players
  get_tree().call_group("instrument", "set_activated", false)
  get_tree().call_group("instrument", "activate_gravity", conductor.get_outro_time())
  lights.fade_off(conductor.get_outro_time())
  finished = true
  emit_signal("end")
  
func _on_loaded():
  emit_signal("loaded")
