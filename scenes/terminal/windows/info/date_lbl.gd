extends Label

func _process(delta: float) -> void:
	var t = Time.get_time_dict_from_system()
	var hour = ("0" if t.hour < 10 else "") + str(t.hour)
	var minute = ("0" if t.minute < 10 else "") + str(t.minute)
	var second = ("0" if t.second < 10 else "") + str(t.second)
	text = "%s %s:%s:%s" % [Constants.DATE, hour, minute, second]
