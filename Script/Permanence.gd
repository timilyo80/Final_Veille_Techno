extends Node

var LevelposX = 160
var LevelposY = 88

var unexistDict = {}

func unexist(Level, ID):
	if !unexistDict.has(Level):
		unexistDict[Level] = []
		
	unexistDict[Level].append(ID)

func is_Exist(Level, ID):
	if unexistDict.has(Level):
		return unexistDict[Level].find(ID)
	else:
		return -1
