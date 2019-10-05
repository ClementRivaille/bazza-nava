extends Spatial
class_name Player

export(PackedScene) var instrument: PackedScene

var sampler: Sampler

var currentBase: String
var currentScale: int

var musicTheory: MusicTheory
var calculator: NoteValueCalculator

var probabilities: Array = [
  {
    "keys": [0, 7],
    "value": 1
  },
  {
    "keys": [2],
    "value": 3
  },
  {
    "keys": [4],
    "value": 2
  },
  {
    "keys": [1,5,6],
    "value": 3
  },
  {
    "keys": [3],
    "value": 1
  }
]
var max_score: int = 0

func _ready():
  sampler = instrument.instance()
  add_child(sampler)
  musicTheory = get_node("/root/MusicTheory")
  calculator = get_node("/root/NoteValue")
  for prob in probabilities:
    max_score += prob["value"]

func set_harmony(base: String, scale: int):
  currentBase = base
  currentScale = scale

func _get_random_note() -> int:
  var dice := randf() * float(max_score)
  var score :float = 0
  var index := 0
  var resultCase
  while index < probabilities.size():
    var case = probabilities[index]
    score += case.value
    if dice <= score:
      resultCase = case
      break
    index += 1
  return resultCase.keys[randi()%resultCase.keys.size()]

func play_random_note():
  var r_note := _get_random_note()
  var noteValue := musicTheory.calculate_note_value(currentBase, 2, currentScale, r_note)
  
  var note_name := calculator.get_note_name(noteValue)
  var octave := 3 + randi()%2
  
  sampler.play_note(note_name, octave)
