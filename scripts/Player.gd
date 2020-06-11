extends Spatial
class_name Player

export(PackedScene) var instrument: PackedScene
export(bool) var chord := false

var sampler: Sampler

var currentBase: String = ""
var currentScale: int

var musicTheory: MusicTheory
var calculator: NoteValueCalculator

var default_probabilities: Array = [4,2,5,2,4,3,1]
var probabilities: Array = []

var last_note: int
var last_octave: int = 0
var repeat: int = 0
var notes_in_chord := []


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

# Set base note, scale, and eventual modifiers
func set_harmony(base: String, scale: int, modifiers: Array = []):
  currentBase = base
  currentScale = scale
  probabilities = default_probabilities.duplicate()
  for m_idx in range(modifiers.size()):
    probabilities[m_idx] += modifiers[m_idx]

# Return a random note in the scale (from 0 to 6) based on probabilities
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
 
# Select an octave randomly or from current melody 
func _select_octave(last_note: String, next_note: String) -> int:
  # If melody is active or we are setting notes in a chord, select a close octave
  if ((!chord && !melody_timer.is_stopped()) || (chord && notes_in_chord.size() > 0)) && last_octave != 0:
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
        return int(max(last_octave - 1, OCTAVES[0]))
      else:
        return int(min(last_octave + 1, OCTAVES[OCTAVES.size() - 1]))
  else:
    if chord && notes_in_chord.size() == 0 && OCTAVES.size() > 2:
      # For the first note in a chord, ignore first and last octave
      return OCTAVES[min(OCTAVES.size() - 2, 1 + randi()%OCTAVES.size())]
    else:
      return OCTAVES[randi()%OCTAVES.size()]

# Play a random note or a random chord    
func play_random_note(muffled: bool = false):
  if !chord:
    play_single_note(muffled)
  else:
    var nb_notes := 1 + randi() % 3
    notes_in_chord = []
    for _i in range(0, nb_notes):
      play_single_note(muffled)

# Play a single random note
func play_single_note(muffled: bool = false):
  if (currentBase == ""):
    return

  # Select note index in scale (0-6)
  var r_note := _get_random_note()
  
  if !chord:
    # For a single note, avoid repetition
    if r_note == last_note:
      repeat += 1
      if repeat > MAX_REPEAT:
        # Select a different note if repeated too much
        while r_note == last_note:
          r_note = _get_random_note()
        repeat = 0
    else:
      repeat = 0
  else:
    # For a chord, ensure that the same note is not played twice
    while notes_in_chord.find(r_note) != -1:
      r_note = _get_random_note()
  
  # Get note values on a default octave to obtain name
  var note_value := musicTheory.calculate_note_value(currentBase, 2, currentScale, r_note)
  var note_name := calculator.get_note_name(note_value)
  
    # Use current note and previous one names to select octave
  var previous_value = musicTheory.calculate_note_value(currentBase, 2, currentScale, last_note)
  var previous_note_name := calculator.get_note_name(previous_value)
  var octave := _select_octave(previous_note_name, note_name)
  
  # Set volume
  if (muffled):
    amplifier.volume_db = -9
  else:
    amplifier.volume_db = 0
  
  # Play note
  sampler.play_note(note_name, octave)
  melody_timer.start()

  # Set note index and octave as previous
  last_note = r_note
  last_octave = octave
  if (chord):
    notes_in_chord.push_front(r_note)
