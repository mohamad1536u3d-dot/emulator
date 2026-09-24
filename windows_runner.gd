extends Node
class_name WindowsRunner

# Architecture for the real Windows runtime:
# Android -> Wine -> Box64/Box86 -> Windows EXE
# The actual native runtime binaries are intentionally not bundled in this prototype.

var wine_path := ""
var box64_path := ""
var prefix_path := ""
var last_exe := ""

func configure(wine: String, box64: String, prefix: String) -> void:
    wine_path = wine
    box64_path = box64
    prefix_path = prefix

func prepare_game(exe_path: String) -> Dictionary:
    last_exe = exe_path
    if exe_path.is_empty():
        return {"ok": false, "message": "لم يتم اختيار ملف EXE"}
    return {
        "ok": true,
        "message": "تم تجهيز اللعبة لبيئة Windows",
        "exe": exe_path,
        "wine": wine_path,
        "box64": box64_path,
        "prefix": prefix_path
    }

func launch_game(exe_path: String) -> Dictionary:
    # Placeholder until native Wine/Box64 Android binaries are linked.
    if wine_path.is_empty() or box64_path.is_empty():
        return {
            "ok": false,
            "message": "محرك Wine/Box64 غير مدمج في نسخة APK الحالية"
        }
    return {"ok": false, "message": "Native launcher not linked yet"}
