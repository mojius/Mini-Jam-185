class_name RandomlyGeneratedMap extends TileMapLayer

func _ready() -> void:
    generate()

func generate():

    var stack: Array[Vector2i]
    var visited: Dictionary[Vector2i, bool]
    var size_x := get_used_rect().size.x
    var size_y := get_used_rect().size.y
    
    var rand_tile = Vector2i(randi_range(0, size_x - 1), randi_range(0, size_y - 1))
    
    init_cell(rand_tile, Vector2i(0,0), visited, stack)

    while stack.size() > 0:
        await get_tree().create_timer(0.03).timeout
        var cell: Vector2i = stack.pop_front()
        print("Popped! ", cell)
        var neighbors: Array[Vector2i] = get_surrounding_cells(cell)
        var unvisited_neighbors: Array[Vector2i]

        for n in neighbors:
            if visited.get(n, false) == false and n in get_used_cells():
                print("Good tile at ", n)
                unvisited_neighbors.push_front(n)

        if unvisited_neighbors.size() > 0:
            stack.push_front(cell)
            var random_neighbor = unvisited_neighbors.pick_random()
            init_cell(random_neighbor, Vector2i(0,0), visited, stack)
        



func init_cell(cell: Vector2i, atlas: Vector2i, visited: Dictionary[Vector2i, bool], stack: Array[Vector2i]):
    if cell not in get_used_cells(): return
    visited[cell] = true
    set_cell(cell, 0, atlas)
    stack.push_front(cell)
