extends AudioStreamPlayer
class_name Sampler

export(Array, AudioStreamSample) var samples: Array

func _ready():
  # Calculate samples' values and sort them
  var calculator: NoteValueCalculator = get_node("/root/NoteValue")
  for s in samples:
    var sample: NoteSample = s
    sample.initValue(calculator)
  samples.sort_custom(self, "_compare_samples")

func _compare_samples(a: NoteSample, b: NoteSample):
  return a.value < b.value

func play_note(note: String, octave: int = 4):
  if samples.size() == 0:
    return

  # look for the closest note in the samples
  var calculator: NoteValueCalculator = get_node("/root/NoteValue")
  var note_val := calculator.get_note_value(note, octave)
  var idx := 0
  var sample: NoteSample = samples[0]
  var diff := abs(note_val - sample.value)
  while (idx <  samples.size() - 1):
    sample = samples[idx+1]
    var next_diff := abs(note_val - sample.value)
    if (diff < next_diff):
      break
    diff = next_diff
    idx += 1

  # Set sample
  sample = samples[idx]
  stream = sample.stream

  # Set pitch relatively to sample
  pitch_scale = pow(2, (note_val - sample.value) / 12.0)

  play(0.0)
