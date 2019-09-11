extends Resource
class_name Section

var measure: int
var chord: int
var mode: int

func _init(json_data: Dictionary):
  measure = json_data["measure"]
  chord = json_data["chord"]
  if json_data.has("mode"):
    mode = MusicTheory.SCALES[json_data["mode"]]
