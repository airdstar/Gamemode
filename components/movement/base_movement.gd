extends Movement

var jump_velocity := 10.0

var gravity := 20

# Ground Movement

var move_speed := 9.0
var ground_accel := 14.0
var ground_decel := 10.0
var ground_friction := 8.0

var was_on_floor : bool

# Air Movement
var air_cap := 0.85
var air_accel := 800.0
var air_move_speed := 500.0

var wish_dir := Vector3.ZERO

var speed : float

func handle_air_physics(delta : float) -> void:
	body.velocity.y -= gravity * delta
	
	var cur_speed_in_wish_dir = body.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	var speed_till_cap = capped_speed - cur_speed_in_wish_dir
	
	if speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, speed_till_cap)
		body.velocity += accel_speed * wish_dir

func handle_ground_physics(delta : float) -> void:
	
	var cur_speed_in_wish_dir = body.velocity.dot(wish_dir)
	var speed_till_cap = move_speed - cur_speed_in_wish_dir
	
	if speed_till_cap > 0:
		var accel_speed = ground_accel * delta * move_speed
		accel_speed = min(accel_speed, speed_till_cap)
		body.velocity += accel_speed * wish_dir
	
	var control = max(body.velocity.length(), ground_decel)
	var drop = control * ground_friction * delta
	var new_speed = max(body.velocity.length() - drop, 0.0)
	
	if body.velocity.length() > 0:
		new_speed /= body.velocity.length()
	body.velocity *= new_speed
	
func _physics_process(delta: float) -> void:
	if !freeze:
		if is_multiplayer_authority():
			
			var input_dir := Input.get_vector(
				"move_left",
				"move_right",
				"move_forward",
				"move_backward"
			).normalized()
			
			wish_dir = body.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
			
			if body.is_on_floor():
				if Input.is_action_pressed("jump"):
					body.velocity.y = jump_velocity
					if !was_on_floor and body.velocity.x == 0 and body.velocity.z == 0:
						body.velocity += Vector3(body.get_floor_normal().x * 20, -1, body.get_floor_normal().z * 20)
				
				if !was_on_floor:
					was_on_floor = true
					
				
				handle_ground_physics(delta)
			else:
				was_on_floor = false
				handle_air_physics(delta)
		
		body.move_and_slide()
