extends CharacterBody2D


@export var move_speed := 100
@export var starting_direction := Vector2.DOWN

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _ready() -> void:
	update_animation_parameters(starting_direction)


func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	update_animation_parameters(input_direction)
	pick_animation_state()
	velocity = input_direction * move_speed
	move_and_slide()


func update_animation_parameters(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)


func pick_animation_state() -> void:
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
