extends Spatial
class_name Main

onready var multisampler: Multisampler = $Multisampler
onready var sampler: Multisampler = $Sampler
onready var player: Player = $Player

var notes := ["C", "D", "E", "F", "G", "A", "B", "B#"]
var idx :=0

func _ready():
  var music_theory: MusicTheory = get_node("/root/MusicTheory")
  player.setHarmony('C', music_theory.Scale.MAJOR)

func _input(event: InputEvent):
  if event.is_pressed():
    # multisampler.play_note(notes[idx], 4)
    # idx = (idx + 1) % notes.size()
    player.play_random_note()
