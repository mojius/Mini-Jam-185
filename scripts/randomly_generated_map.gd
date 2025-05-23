class_name RandomlyGeneratedMap extends TileMapLayer

@export var kitty: PackedScene

var atlas_id := 5

var floor_tile: Vector2i:
    get:
        return [Vector2i(3,0), Vector2i(4,0)].pick_random()

var floor_tiles: Array[Vector2i] = [Vector2i(3,0), Vector2i(4,0)]

var wall_tile := Vector2i(0,0)
var cracked_tile : Vector2i:
    get:
        return [Vector2i(1,0), Vector2i(2,0)].pick_random()

func _ready() -> void:
    generate()

func generate():

    var stack: Array[Vector2i]
    var visited: Dictionary[Vector2i, bool]

    var edge: Array[int] = [0, 8]
    var random_even_array: Array[int] = [0, 2, 4, 6, 8]

    var random = randi_range(0,1)
    var rand_tile := Vector2i(-1,-1)

    if random == 0:
        rand_tile = Vector2i(edge.pick_random(), random_even_array.pick_random())
    else:
        rand_tile = Vector2i(random_even_array.pick_random(), edge.pick_random())

    
    init_cell(rand_tile, floor_tile, visited, stack)
    
    var k = kitty.instantiate()
    add_child(k)
    k.position = map_to_local(rand_tile)

    while stack.size() > 0:
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
            init_cell(random_neighbor, floor_tile, visited, stack)
            var difference: Vector2i = (random_neighbor - cell) / 2
            #print("Difference is: ", difference)
            var wall: Vector2i = cell + difference
            set_cell(wall, atlas_id, floor_tile)
    
    # Generate breaks
    var walls = get_used_cells().filter(func(cell): return get_cell_atlas_coords(cell) == wall_tile)
    for w in walls:
        var rand = randi_range(1,10)
        if rand < 3:
            if ((get_cell_atlas_coords(w + Vector2i.LEFT) in  floor_tiles and
                get_cell_atlas_coords(w + Vector2i.RIGHT) in  floor_tiles) !=
                (get_cell_atlas_coords(w + Vector2i.UP) in  floor_tiles and
                get_cell_atlas_coords(w + Vector2i.DOWN) in floor_tiles)):
                    set_cell(w, atlas_id, cracked_tile)

            

func init_cell(cell: Vector2i, atlas: Vector2i, visited: Dictionary[Vector2i, bool], stack: Array[Vector2i]):
    if cell not in get_used_cells(): return
    visited[cell] = true
    set_cell(cell, atlas_id, atlas)
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
