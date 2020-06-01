extends Node
class_name Instrument

signal triggered

var body: RigidBody
var timer: Timer
var tween: Tween

export(int, 0, 9) var input: int

onready var player: Player = $Player
var collision_lock = false
var previous_collide: Node

var FORCE: float = 15.0
var COLLISION_DELAY = 0.1
var PLAYING_DELAY = 1.5

var activated := false
var collision_sound := true
var triggered := false

# Called when the node enters the scene tree for the first time.
func _ready():
  for child in get_children():
    if child is RigidBody:
      body = child
      break
  
  body.connect("body_entered", self, "on_collide")
  
  timer = Timer.new()
  timer.one_shot = true
  timer.wait_time = COLLISION_DELAY
  add_child(timer)
  timer.connect("timeout", self, "unlock_collision")
  
  tween = Tween.new()
  add_child(tween)
  
  add_to_group("instrument")

func _input(event):
  if activated && event.is_action_pressed(str(input)):
    # Deactivate gravity the first time instrument is triggered
    if !triggered:
      deactivate_gravity()
      triggered = true
      emit_signal("triggered")
    
    body.angular_velocity = Vector3(0,0,0)
    body.linear_velocity = Vector3(0,0,0)
    
    var position: Vector3 = Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1)
    var impulse = Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1).normalized() * FORCE
    body.apply_impulse(position, impulse)
    
    player.play_random_note()
    
    # Prevent sound from collision
    collision_lock = true
    previous_collide = null
    if (!timer.is_stopped()):
      timer.stop()
    timer.wait_time = PLAYING_DELAY
    timer.start()

func on_collide(body: Node):
  if (collision_sound && !collision_lock && previous_collide != body):
    player.play_random_note(true)
    
    previous_collide = body
    collision_lock = true
    if (!timer.is_stopped()):
      timer.stop()
    timer.wait_time = COLLISION_DELAY
    timer.start()

func unlock_collision():
  collision_lock = false
  timer.wait_time = COLLISION_DELAY
  
func set_activated(val: bool):
  activated = val
  
func set_collision_sound(val: bool):
  collision_sound = val
  
func activate_gravity(time: float):
  tween.interpolate_property(body, "gravity_scale", 0, 1,
    time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  tween.start()
  triggered = false

func deactivate_gravity():
  if tween.is_active():
    tween.stop_all()
  body.gravity_scale = 0