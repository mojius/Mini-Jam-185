class_name RandomlyGeneratedMap extends TileMapLayer

func _ready() -> void:
    generate()

func generate():

    var stack: Array[Vector2i]
    var visited: Dictionary[Vector2i, bool]
    var size_x = get_used_rect().size.x
    var size_y = get_used_rect().size.y
    
    var rand_tile = Vector2i(randi_range(0, size_x - 1), randi_range(0, size_y - 1))
    visited[rand_tile] = true
    stack.push_front(rand_tile)
    while stack.size() != 0:
        var cell: Vector2i = stack.pop_front()


    