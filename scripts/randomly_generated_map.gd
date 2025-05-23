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
        await get_tree().create_timer(0.08).timeout
        var cell: Vector2i = stack.pop_front()
        print("Popped! ", cell)
        var neighbors: Array[Vector2i] = get_surrounding_cells(cell)
        for n in neighbors:
            if visited.get(n, false) == false and get_cell_atlas_coords(n) == Vector2i(1,1):
                print("Good tile at ", n)

                if n - cell == Vector2i.UP or n - cell == Vector2i.DOWN:
                    init_cell(n + Vector2i.LEFT, Vector2i(1,0), visited, stack)
                    init_cell(n + Vector2i.RIGHT, Vector2i(1,0), visited, stack)
                else:
                    init_cell(n + Vector2i.UP, Vector2i(1,0), visited, stack)
                    init_cell(n + Vector2i.DOWN, Vector2i(1,0), visited, stack)


                init_cell(n, Vector2i(0,0), visited, stack)


                
            else: continue

func init_cell(cell: Vector2i, atlas: Vector2i, visited: Dictionary[Vector2i, bool], stack: Array[Vector2i]):
    if cell not in get_used_cells(): return
    visited[cell] = true
    set_cell(cell, 0, atlas)
    stack.push_front(cell)
