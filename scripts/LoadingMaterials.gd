extends Spatial
class_name LoadingMaterials

signal loading_ready

var loaded := false

func _ready():
  var bodies = get_tree().get_nodes_in_group("heavy")
  
  for body in bodies:
    if body is MeshInstance:
      add_material(body)
      
    for child in body.get_children():
      if child is MeshInstance:
        add_material(child)
        
func _process(_delta):
  # Stay for one frame before removing itself from tree
  if !loaded:
    loaded = true
    emit_signal("loading_ready")
      
func add_material(body: MeshInstance):
  var material1 = body.mesh.surface_get_material(0)
  var material2 := body.material_override
  
  var quad := MeshInstance.new()
  quad.set_mesh(QuadMesh.new())
  if material2 != null:
    quad.material_override = material2
  else:
    quad.material_override = material1
    
  add_child(quad)
  
func clear():
  for child in get_children():
    remove_child(child)
