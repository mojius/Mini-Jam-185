class_name RandomlyGeneratedMap extends TileMapLayer

func _ready() -> void:
    generate()

func generate():

    var stack: Array[Vector2i]
    var visited: Dictionary[Vector2i, bool]
    var size_x := get_used_rect().size.x
    var size_y := get_used_rect().size.y
    
    var rand_tile = Vector2i(randi_range(0, size_x - 1), randi_range(0, size_y - 1))
    init_cell(rand_tile, stack, visited)

    while stack.size() != 0:
        var cell: Vector2i = stack.pop_front()
        var neighbors: Array[Vector2i] = get_surrounding_cells(cell)
        for n in neighbors:
            if visited.get(n, false) == false and get_cell_atlas_coords(n) == Vector2i(1,1):
                print("Good tile at ", n)
                break
            else: continue


func init_cell(cell: Vector2i, stack: Array, visited: Dictionary):
    visited[cell] = true
    set_cell(cell, 0, Vector2i(0,0))
    stack.push_front(cell)
    