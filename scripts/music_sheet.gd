extends Resource
class_name MusicSheet

export(String) var root: String
export(int) var mode: int
var sections: Array

var next_section: int

func _init(json_data: Dictionary):
  root = json_data["scale"]["note"]
  mode = MusicTheory.SCALES[json_data["scale"]["mode"]]
  sections = json_data["sections"]
  next_section = 0

func get_next_section() -> Section:
  return Section.new(sections[next_section])
  
func change_section():
  next_section = (next_section + 1) % sections.size()
  
func restart():
  next_section = 0
