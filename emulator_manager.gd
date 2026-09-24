extends Node
class_name EmulatorManager

var runtime_ready := false
var runtime_name := "Wine + Box64"
var architecture := "ARM64 Android"

func check_runtime() -> Dictionary:
    return {
        "ready": runtime_ready,
        "runtime": runtime_name,
        "architecture": architecture
    }

func set_runtime_ready(value: bool) -> void:
    runtime_ready = value
