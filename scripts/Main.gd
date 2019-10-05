extends Spatial
class_name Main

onready var multisampler: Multisampler = $Multisampler
onready var sampler: Multisampler = $Sampler
onready var player: Player = $Player
onready var metronome: MetronomePlayer = $MetronomePlayer
onready var music_theory: MusicTheory = get_node("/root/MusicTheory")
onready var calculator: NoteValueCalculator = get_node("/root/NoteValue")

var notes := ["C", "D", "E", "F", "G", "A", "B", "B#"]
var idx :=0

var sheet: MusicSheet
var sheet_path := "res://assets/sheet.json"

var measures_left := 0
var beats_left := 0


func _ready():
  metronome.connect("beat", self, "on_beat")
  metronome.connect("measure", self, "on_measure")
  
  _read_sheet(sheet_path)

  start_song()

func _input(event: InputEvent):
  if event.is_pressed():
    # multisampler.play_note(notes[idx], 4)
    # idx = (idx + 1) % notes.size()
    player.play_random_note()
    
func start_song():
  get_tree().call_group("player", "set_harmony", sheet.root, sheet.mode)
  sheet.restart()
  metronome.play()
  
  read_next_section()
  
func read_next_section():
  var next_segment := sheet.get_next_segment()
  var new_mode := sheet.mode
  var new_root := sheet.root
  var next_section := sheet.get_section(next_segment.section)

  if (next_section.mode != null):
    new_mode = sheet.mode
  
  if (next_section.chord != null):
    var new_root_value: int = music_theory.calculate_note_value(
      new_root, 4,
      new_mode, next_section.chord)
    new_root = calculator.get_note_name(new_root_value)
    new_mode = (new_mode + next_section.chord) % music_theory.scales_intervals.size()
    
  get_tree().call_group("player", "set_harmony", new_root, new_mode)
  
  measures_left = next_segment.measures
  beats_left = next_segment.beats
  sheet.change_segment()

  
func on_measure():
  measures_left -= 1
  if (measures_left <= 0 && beats_left <= 0):
    read_next_section()

func on_beat(n: int):
  # player.play_random_note()
  if (measures_left <=0):
    beats_left -= 1
    if (beats_left <= 0):
      read_next_section()

func _read_sheet(source_file: String):
    var file := File.new()
    var err = file.open(source_file, File.READ)
    if err != OK:
        return err

    var text = file.get_as_text()
    var dict := JSON.parse(text)

    file.close()
    if (dict.error):
      print(str(dict.error_line) + ': ' + dict.error_string)
      get_tree().quit()
      
    sheet = MusicSheet.new(dict.result)
