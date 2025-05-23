extends Control

func set_score(score: int):
    $HBoxContainer/Floor.text = "Score: " + str(score)

func set_time(time: float):
    $HBoxContainer/Time.text = "Time: " + str(time)

func set_floor(floor: int):
    $HBoxContainer/Floor.text = "Time: " + str(floor)
