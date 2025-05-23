class_name RandomlyGeneratedMap extends TileMapLayer

func _ready() -> void:
    generate()

func generate():

    var stack: Array[Vector2i]
    var visited: Dictionary[Vector2i, bool]

    var edge: Array[int] = [0, 7]

    var random = randi_range(0,1)
    var rand_tile := Vector2i(-1,-1)

    if random == 0:
        rand_tile = Vector2i(edge.pick_random(), randi_range(0,7))
    else:
        rand_tile = Vector2i(randi_range(0,7), edge.pick_random())

    
    init_cell(rand_tile, Vector2i(0,0), visited, stack)

    while stack.size() > 0:
        await get_tree().create_timer(0.03).timeout
        var cell: Vector2i = stack.pop_front()
        #print("Popped! ", cell)
        var neighbors: Array[Vector2i] = get_special_surrounding(cell)
        var unvisited_neighbors: Array[Vector2i]

        for n in neighbors:
            if visited.get(n, false) == false and n in get_used_cells():
                #print("Good tile at ", n)
                unvisited_neighbors.push_front(n)

        if unvisited_neighbors.size() > 0:
            stack.push_front(cell)
            var random_neighbor = unvisited_neighbors.pick_random()
            init_cell(random_neighbor, Vector2i(0,0), visited, stack)
            var difference: Vector2i = (random_neighbor - cell) / 2
            #print("Difference is: ", difference)
            var wall: Vector2i = cell + difference
            set_cell(wall, 0, Vector2i(0,0))
    
    # Generate breaks
    var walls = get_used_cells().filter(func(cell): return get_cell_atlas_coords(cell) == Vector2i(1,0))
    for w in walls:
        var rand = randi_range(1,10)
        if rand < 3:
            if ((get_cell_atlas_coords(w + Vector2i.LEFT) == Vector2i(0,0) and
                get_cell_atlas_coords(w + Vector2i.RIGHT) == Vector2i(0,0)) !=
                (get_cell_atlas_coords(w + Vector2i.UP) == Vector2i(0,0) and
                get_cell_atlas_coords(w + Vector2i.DOWN) == Vector2i(0,0))):
                    set_cell(w, 0, Vector2i(0,1))

            

    


func init_cell(cell: Vector2i, atlas: Vector2i, visited: Dictionary[Vector2i, bool], stack: Array[Vector2i]):
    if cell not in get_used_cells(): return
    visited[cell] = true
    set_cell(cell, 0, atlas)
    stack.push_front(cell)

func get_special_surrounding(cell: Vector2i) -> Array[Vector2i]:
    var array: Array[Vector2i] = []

    if (cell + (Vector2i.UP * 2)) in get_used_cells():
        array.push_front(cell + (Vector2i.UP * 2))
    if (cell + (Vector2i.DOWN * 2)) in get_used_cells():
        array.push_front(cell + (Vector2i.DOWN * 2))
    if (cell + (Vector2i.LEFT * 2)) in get_used_cells():
        array.push_front(cell + (Vector2i.LEFT * 2))
    if (cell + (Vector2i.RIGHT * 2)) in get_used_cells():
        array.push_front(cell + (Vector2i.RIGHT * 2))

    return array
