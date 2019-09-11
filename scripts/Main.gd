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

var current_measure := 0
var current_beat := 0


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
  current_measure = 0
  current_beat = 0
  metronome.play()
  
func on_measure():
  current_measure += 1
  var next := sheet.get_next_section()
  if (next.measure == current_measure):
    var new_mode := sheet.mode
    var new_root := sheet.root

    if (next.mode != null):
      new_mode = sheet.mode
    
    if (next.chord != null):
      var new_root_value: int = music_theory.calculate_note_value(
        new_root, 4,
        new_mode, next.chord)
      new_root = calculator.get_note_name(new_root_value)
      new_mode = (new_mode + next.chord) % music_theory.scales_intervals.size()
      
    get_tree().call_group("player", "set_harmony", new_root, new_mode)
    
    sheet.change_section()

func on_beat(n: int):
  player.play_random_note()
  current_beat = n

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
