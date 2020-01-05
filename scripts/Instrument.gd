extends Node
class_name Instrument

var body: RigidBody
export(int, 0, 9) var input: int

onready var player: Player = $Player

var FORCE: float = 15.0

# Called when the node enters the scene tree for the first time.
func _ready():
  for child in get_children():
    if child is RigidBody:
      body = child
      break

func _input(event):
  if event.is_action_pressed(str(input)):
    body.angular_velocity = Vector3(0,0,0)
    body.linear_velocity = Vector3(0,0,0)
    
    var position: Vector3 = Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1)
    var impulse = Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1).normalized() * FORCE
    body.apply_impulse(position, impulse)
    
    player.play_random_note()
