extends AudioStreamPlayer
class_name Multisampler

export(Array, AudioStreamSample) var samples: Array
export(int) var max_notes:= 1

var samplers := []
var next_available = 0

func _ready():
  # Create samplers
  # warning-ignore:unused_variable
  for i in range(max_notes):
    var sampler := Sampler.new()
    sampler.samples = samples
    sampler.out_bus = bus
    sampler.volume_db = volume_db
    
    add_child(sampler)
    samplers.append(sampler)

func play_note(note: String, octave: int = 4):
  var sampler: Sampler = samplers[next_available]
  sampler.play_note(note, octave)
  next_available = (next_available + 1) % max_notes
  
func stop():
  for s in samplers:
    var sampler: Sampler = s
    sampler.stop()
