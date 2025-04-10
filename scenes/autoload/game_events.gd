extends Node

signal experience_smallexp_collected(number : float)

func emit_smallexp_collected(number: float):
	experience_smallexp_collected.emit(number)
