extends Area

func _ready():
  connect("body_entered", self, "reset_body")
  
func reset_body(body: RigidBody):
  call_deferred("move_body", body)

func move_body(body: RigidBody):
  # Reset position
  body.global_translate($BackupPoint.global_transform.origin - body.get_global_transform().origin)
  # slow down the body
  body.set_linear_velocity(body.linear_velocity.normalized() * 7)
  body.set_angular_velocity(body.angular_velocity.normalized() * 7)