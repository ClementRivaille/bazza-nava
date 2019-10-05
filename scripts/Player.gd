extends Spatial
class_name Player

export(PackedScene) var instrument: PackedScene

var sampler: Sampler

var currentBase: String
var currentScale: int

var musicTheory: MusicTheory
var calculator: NoteValueCalculator

var default_probabilities: Array = [4,3,5,2,4,3,1]
var probabilities: Array = []

var last_note: int
var last_octave: int

var MAX_REPEAT := 3
var OCTAVES := [3,4]

func _ready():
  sampler = instrument.instance()
  add_child(sampler)
  musicTheory = get_node("/root/MusicTheory")
  calculator = get_node("/root/NoteValue")

func set_harmony(base: String, scale: int, modifiers: Array = []):
  currentBase = base
  currentScale = scale
  probabilities = default_probabilities.duplicate()
  for m_idx in range(modifiers.size()):
    probabilities[m_idx] += modifiers[m_idx]

func _get_random_note() -> int:
  print(probabilities)
  var max_score = 0
  for prob in probabilities:
    max_score += prob

  var dice := randf() * float(max_score)
  var score :float = 0
  var index := 0
  while index < probabilities.size():
    var case: int = probabilities[index]
    score += case
    if dice <= score:
      break
    index += 1
  return int(min(6,index))

func play_random_note():
  var r_note := _get_random_note()
  var noteValue := musicTheory.calculate_note_value(currentBase, 2, currentScale, r_note)
  
  var note_name := calculator.get_note_name(noteValue)
  var octave : int = OCTAVES[randi()%OCTAVES.size()]
  
  sampler.play_note(note_name, octave)
