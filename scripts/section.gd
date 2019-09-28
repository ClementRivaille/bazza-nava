extends Resource
class_name Section

var measures: int
var beats: int
var chord: int
var mode: int

func _init(json_data: Dictionary):
  measures = json_data["measures"] if json_data.has("measures") else 0
  beats = json_data["beats"] if json_data.has("beats") else 0
  chord = json_data["chord"]
  if json_data.has("mode"):
    mode = MusicTheory.SCALES[json_data["mode"]]
