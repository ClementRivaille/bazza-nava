extends Resource
class_name Section

var chord: int = -1
var mode: int = -1
var root: String
var modifiers: Array = []

func _init(json_data: Dictionary):
  chord = json_data["chord"]
  if json_data.has("mode"):
    mode = MusicTheory.SCALES[json_data["mode"]]
  if json_data.has("root"):
    root = json_data["root"]
  if json_data.has("modifiers"):
    modifiers = json_data["modifiers"]
