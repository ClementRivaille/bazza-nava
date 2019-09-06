extends Node
class_name NoteValueCalculator

var note_values := {
  "C": 0,
  "C#": 1,
  "Db": 1,
  "D": 2,
  "D#": 3,
  "Eb": 3,
  "E": 4,
  "E#": 5,
  "Fb": 4,
  "F": 5,
  "F#": 6,
  "Gb": 6,
  "G": 7,
  "G#": 8,
  "Ab": 8,
  "A": 9,
  "A#": 10,
  "Bb": 10,
  "B": 11,
  "B#": 12,
  "Cb": -1
}

func get_note_value(tone: String, octave: int = 4) -> int:
  var value: int = note_values[tone]
  if value != null:
    return value + 12 * octave
  return 0

func get_note_name(value: int) -> String:
  var notes := note_values.keys()
  var values := note_values.values()
  var index: int = values.find(value % 12)
  return notes[index]

func get_note_octave(value: int) -> int:
  return value / 12