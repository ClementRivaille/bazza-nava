extends Spatial
class_name Player

export(PackedScene) var instrument: PackedScene

var sampler: Sampler

var currentBase: String
var currentScale: int

var musicTheory: MusicTheory
var calculator: NoteValueCalculator

var default_probabilities: Array = [4,2,5,2,4,3,1]
var probabilities: Array = []

var last_note: int
var last_octave: int = 0
var repeat: int = 0


# volume
var amplifier: AudioEffectAmplify
var p_index: int

var MAX_REPEAT := 2
export(Array, int) var OCTAVES := [3,4]

onready var melody_timer: Timer = $MelodyTimer

func _enter_tree():
  add_to_group("player")
  
func _init():
  # create an audio bus
  p_index = AudioServer.get_bus_count()
  AudioServer.add_bus(p_index)
  AudioServer.set_bus_name(p_index, 'player' + str(p_index))
  amplifier = AudioEffectAmplify.new()
  AudioServer.add_bus_effect(p_index, amplifier)

func _ready():
  sampler = instrument.instance()
  # Put custom bus between sampler's one
  var bus_index := AudioServer.get_bus_index('player' + str(p_index))
  AudioServer.set_bus_send(bus_index, sampler.bus)
  sampler.bus = AudioServer.get_bus_name(bus_index)
  
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
  
func _select_octave(last_note: String, next_note: String) -> int:
  if !melody_timer.is_stopped() && last_octave != 0:
    var last_nvalue = calculator.get_note_value(last_note)
    var next_nvalue = calculator.get_note_value(next_note)
    if abs(last_nvalue - next_nvalue) <= 6:
      # if we hit the same note twice, there's a random chance to go to another octave
      if last_nvalue == next_nvalue:
        return OCTAVES[randi()%OCTAVES.size()]
      else:
        return last_octave
    else:
      if last_nvalue < next_nvalue:
        return int(max(last_octave, OCTAVES[0]))
      else:
        return int(min(last_octave + 1, OCTAVES[OCTAVES.size() - 1]))
  else:
    return OCTAVES[randi()%OCTAVES.size()]

func play_random_note(muffled: bool = false):
  var r_note := _get_random_note()
  if r_note == last_note:
    repeat += 1
    if repeat > MAX_REPEAT:
      while r_note == last_note:
        r_note = _get_random_note()
      repeat = 0
  else:
    repeat = 0
  
  var note_value := musicTheory.calculate_note_value(currentBase, 2, currentScale, r_note)
  var previous_value = musicTheory.calculate_note_value(currentBase, 2, currentScale, last_note)
  var previous_note_name := calculator.get_note_name(previous_value)
  
  var note_name := calculator.get_note_name(note_value)
  var octave := _select_octave(previous_note_name, note_name)
  
  if (muffled):
    amplifier.volume_db = -9
  else:
    amplifier.volume_db = 0
  
  sampler.play_note(note_name, octave)
  melody_timer.start()

  last_note = r_note
  last_octave = octave
