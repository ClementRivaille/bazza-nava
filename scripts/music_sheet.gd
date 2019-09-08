extends Resource
class_name MusicSheet

var SCALES := {
  "MAJOR": 0,
  "DORIAN": 1,
  "PHRYGIAN": 2,
  "LYDIAN": 3,
  "MIXOLYDIAN": 4,
  "MINOR": 5,
  "LOCRIAN": 6
}

export(String) var root: String
export(int) var mode: int
var measures: Array

func _init(json_data: Dictionary):
  root = json_data["scale"]["note"]
  mode = SCALES[json_data["scale"]["mode"]]
  measures = json_data["measures"]
