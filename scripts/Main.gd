extends Spatial
class_name Main

onready var multisampler: Multisampler = $Multisampler
onready var sampler: Multisampler = $Sampler

var notes := ["C", "D", "E", "F", "G", "A", "B", "B#"]
var idx :=0

func _ready():
  pass

func _input(event: InputEvent):
  if event.is_pressed():
    multisampler.play_note(notes[idx], 4)
    idx = (idx + 1) % notes.size()
