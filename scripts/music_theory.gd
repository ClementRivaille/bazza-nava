extends Node
class_name MusicTheory

enum Scale {
  MAJOR = 0,
  DORIAN = 1,
  PHRYGIAN = 2,
  LYDIAN = 3,
  MIXOLYDIAN = 4,
  MINOR = 5,
  LOCRIAN = 6
}

var scales_intervals := [
  [0,2,2,1,2,2,2,1],
  [0,2,1,2,2,2,1,2],
  [0,1,2,2,2,1,2,2],
  [0,2,2,2,1,2,2,1],
  [0,2,2,1,2,2,1,2],
  [0,2,1,2,2,1,2,2],
  [0,1,2,2,1,2,2,2]
]

func calculate_note_value(base: String, octave: int, scale: int, distance: int) -> int:
  var calculator: NoteValueCalculator = get_node("/root/NoteValue")
  var intervals: Array = scales_intervals[scale]
  
  var note := calculator.get_note_value(base, octave)
  for i in range(distance):
    var index := i % intervals.size()
    note = note + intervals[index]
  
  return note