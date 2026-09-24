extends Control

var games := []
var selected_game := -1
var games_box: VBoxContainer
var status_label: Label
var file_dialog: FileDialog
var touch_overlay: Control
var settings_panel: PanelContainer

func _ready():
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _build_ui()

func _build_ui():
    var bg = ColorRect.new()
    bg.color = Color("#eef2f7")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var header = PanelContainer.new()
    header.position = Vector2(0, 0)
    header.size = Vector2(800, 110)
    add_child(header)

    var h = HBoxContainer.new()
    h.add_theme_constant_override("separation", 18)
    header.add_child(h)

    var title = Label.new()
    title.text = "Windows 7 Game Emulator"
    title.add_theme_font_size_override("font_size", 27)
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    h.add_child(title)

    var settings = Button.new()
    settings.text = "⚙"
    settings.custom_minimum_size = Vector2(70, 70)
    settings.pressed.connect(_show_settings)
    h.add_child(settings)

    var content = VBoxContainer.new()
    content.position = Vector2(35, 135)
    content.size = Vector2(730, 1040)
    content.add_theme_constant_override("separation", 16)
    add_child(content)

    var info = Label.new()
    info.text = "مكتبة الألعاب"
    info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    info.add_theme_font_size_override("font_size", 25)
    content.add_child(info)

    var add = Button.new()
    add.text = "＋ إضافة لعبة من الهاتف"
    add.custom_minimum_size = Vector2(0, 72)
    add.add_theme_font_size_override("font_size", 23)
    add.pressed.connect(_open_picker)
    content.add_child(add)

    status_label = Label.new()
    status_label.text = "جاهز. أضف ملف EXE أو ZIP."
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    content.add_child(status_label)

    games_box = VBoxContainer.new()
    games_box.add_theme_constant_override("separation", 10)
    content.add_child(games_box)

    var hint = Label.new()
    hint.text = "التشغيل الحقيقي يعتمد على Wine + Box64/Box86.\nإعدادات اللمس والرسوميات تُحفظ لكل لعبة."
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    hint.add_theme_font_size_override("font_size", 16)
    content.add_child(hint)

    file_dialog = FileDialog.new()
    file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
    file_dialog.access = FileDialog.ACCESS_FILESYSTEM
    file_dialog.filters = PackedStringArray([
        "*.exe ; Windows executable",
        "*.zip ; Game archive"
    ])
    file_dialog.file_selected.connect(_game_selected)
    add_child(file_dialog)

    _build_touch_overlay()

func _open_picker():
    status_label.text = "اختر ملف اللعبة..."
    file_dialog.popup_centered_ratio(0.9)

func _game_selected(path: String):
    var item = {
        "name": path.get_file(),
        "path": path,
        "box64": "Balanced",
        "graphics": "Auto",
        "fullscreen": true
    }
    games.append(item)
    selected_game = games.size() - 1
    _refresh_games()
    status_label.text = "تمت إضافة: " + item.name

func _refresh_games():
    for child in games_box.get_children():
        child.queue_free()

    for i in range(games.size()):
        var item = games[i]
        var card = PanelContainer.new()
        card.custom_minimum_size = Vector2(0, 92)
        games_box.add_child(card)

        var row = HBoxContainer.new()
        row.add_theme_constant_override("separation", 8)
        card.add_child(row)

        var name = Label.new()
        name.text = item.name
        name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        name.add_theme_font_size_override("font_size", 17)
        row.add_child(name)

        var cfg = Button.new()
        cfg.text = "إعدادات"
        cfg.pressed.connect(func(): _select_settings(i))
        row.add_child(cfg)

        var play = Button.new()
        play.text = "تشغيل"
        play.pressed.connect(func(): _launch(i))
        row.add_child(play)

func _launch(index: int):
    selected_game = index
    status_label.text = "جاهز لتشغيل: " + games[index].name + "\nWine + Box64 runtime غير مضمّن في هذا prototype."

func _select_settings(index: int):
    selected_game = index
    _show_settings()

func _show_settings():
    if settings_panel:
        settings_panel.queue_free()

    settings_panel = PanelContainer.new()
    settings_panel.position = Vector2(90, 180)
    settings_panel.size = Vector2(620, 760)
    add_child(settings_panel)

    var box = VBoxContainer.new()
    box.add_theme_constant_override("separation", 14)
    settings_panel.add_child(box)

    var title = Label.new()
    title.text = "إعدادات المحاكي"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 26)
    box.add_child(title)

    var runtime = Label.new()
    runtime.text = "Runtime: Wine + Box64/Box86"
    box.add_theme_font_size_override("font_size", 18)
    box.add_child(runtime)

    var preset = OptionButton.new()
    preset.add_item("Box64: Stability")
    preset.add_item("Box64: Balanced")
    preset.add_item("Box64: Performance")
    box.add_child(preset)

    var graphics = OptionButton.new()
    graphics.add_item("Graphics: Auto")
    graphics.add_item("Graphics: OpenGL")
    graphics.add_item("Graphics: Vulkan/DXVK")
    box.add_child(graphics)

    var fullscreen = CheckButton.new()
    fullscreen.text = "ملء الشاشة"
    fullscreen.button_pressed = true
    box.add_child(fullscreen)

    var touch = CheckButton.new()
    touch.text = "إظهار أزرار اللمس"
    touch.button_pressed = true
    touch.toggled.connect(func(v): touch_overlay.visible = v)
    box.add_child(touch)

    var close = Button.new()
    close.text = "حفظ وإغلاق"
    close.custom_minimum_size = Vector2(0, 65)
    close.pressed.connect(func(): settings_panel.queue_free())
    box.add_child(close)

func _build_touch_overlay():
    touch_overlay = Control.new()
    touch_overlay.position = Vector2(20, 900)
    touch_overlay.size = Vector2(760, 300)
    add_child(touch_overlay)

    var left = Button.new()
    left.text = "←"
    left.position = Vector2(25, 80)
    left.size = Vector2(80, 80)
    touch_overlay.add_child(left)

    var right = Button.new()
    right.text = "→"
    right.position = Vector2(205, 80)
    right.size = Vector2(80, 80)
    touch_overlay.add_child(right)

    var jump = Button.new()
    jump.text = "A"
    jump.position = Vector2(580, 20)
    jump.size = Vector2(80, 80)
    touch_overlay.add_child(jump)

    var action = Button.new()
    action.text = "B"
    action.position = Vector2(670, 100)
    action.size = Vector2(80, 80)
    touch_overlay.add_child(action)
