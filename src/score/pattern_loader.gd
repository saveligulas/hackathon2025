extends Node

var patterns: Array[Pattern] = []

func _ready() -> void:
    load_all_patterns("res://patterns")

func get_patterns() -> Array[Pattern]:
    return patterns

func load_all_patterns(folder_path: String):
    patterns.clear()

    var dir := DirAccess.open(folder_path)
    if dir == null:
        push_error("Cannot open folder: " + folder_path)
        return

    dir.list_dir_begin()

    while true:
        var file_name = dir.get_next()
        if file_name == "":
            break

        if file_name.ends_with(".tres"):
            var file_path = folder_path + "/" + file_name

            var pattern: Pattern = load(file_path)

            if pattern != null and pattern is Pattern:
                patterns.append(pattern)

    dir.list_dir_end()

    print("Loaded patterns:", patterns)
