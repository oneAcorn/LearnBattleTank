@tool
extends EditorPlugin

var btn = Button.new()


func _enter_tree() -> void:
	btn.text = "显示当前时间"
	btn.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	btn.pressed.connect(_on_btn_pressed)
	add_control_to_container(CONTAINER_INSPECTOR_BOTTOM, btn)


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_INSPECTOR_BOTTOM, btn)
	btn.queue_free()


func _on_btn_pressed():
	var now = Time.get_datetime_string_from_system(false, true)
	print("now:", now)
