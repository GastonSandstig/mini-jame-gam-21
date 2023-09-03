class_name AudioLibrary
extends Node

@export var allow_interruption: bool = false

func play(soundID: = "", pitch: = 1.):
	var audio = get_children().pick_random() if soundID.is_empty() else get_node(soundID)

	if audio is AudioStreamPlayer:
		if audio.playing and !allow_interruption: return
		audio.pitch_scale = pitch
		audio.play()

	elif audio is AudioLibrary:
		audio.play(soundID, pitch)

	return
