extends Node


static func generate_random_string(length):
	var chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	var res = ""
	var n_char = len(chars)
	for i in range(length):
		res += chars[randi()% n_char]
	return res
