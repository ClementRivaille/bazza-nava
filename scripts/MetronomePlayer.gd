extends AudioStreamPlayer
class_name MetronomePlayer

signal beat
signal measure

export (int) var bpm: int = 120
export (int) var beats_in_measure: int = 4

var precision: float = 0.0001
var beat_length: float
var current_b := 0
var next_b: float

func _ready():
  beat_length = 60.0 / bpm

func play(from_position: float = 0.0):
  current_b = 0
  next_b = beat_length
  .play(from_position)

# warning-ignore:unused_argument
func _process(delta):
  if playing:
    var position := get_playback_position()
    
    if (next_b - position < precision):
      current_b = (current_b + 1) % beats_in_measure
      next_b += beat_length
      
      if current_b == 0:
        emit_signal("measure")
      emit_signal("beat", current_b)
