extends Node

func get_files(folder):
	var file_list = {}
	var file_count = 0
	var dir = Directory.new()
	
	if dir.open(folder) == OK:
		dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file != "":
				if not file.begins_with("."):
					file_list[file_count] = folder + file
					file_count += 1
			else:
				break
	return file_list

