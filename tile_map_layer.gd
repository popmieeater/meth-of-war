@tool
extends Node

## Drag your TileMapLayer node here in the Inspector
@export var tilemap_layer: TileMapLayer
## Click this checkbox in the Inspector to trigger the export
@export var trigger_export: bool = false:
	set(value):
		if value and tilemap_layer:
			export_layer_to_image()
		trigger_export = false

func export_layer_to_image():
	var used_cells = tilemap_layer.get_used_cells()
	if used_cells.is_empty():
		print("TileMapLayer is empty!")
		return
		
	# 1. Calculate the bounding box of the tilemap
	var min_cell = used_cells[0]
	var max_cell = used_cells[0]
	for cell in used_cells:
		min_cell.x = min(min_cell.x, cell.x)
		min_cell.y = min(min_cell.y, cell.y)
		max_cell.x = max(max_cell.x, cell.x)
		max_cell.y = max(max_cell.y, cell.y)
		
	var cell_size = tilemap_layer.tile_set.tile_size
	var grid_width = (max_cell.x - min_cell.x + 1)
	var grid_height = (max_cell.y - min_cell.y + 1)
	
	# 2. Create a blank transparent image matching the total pixel size
	var export_image = Image.create(grid_width * cell_size.x, grid_height * cell_size.y, false, Image.FORMAT_RGBA8)
	var tileset = tilemap_layer.tile_set

	# 3. Blit each individual tile onto the master image
	for cell in used_cells:
		var source_id = tilemap_layer.get_cell_source_id(cell)
		if source_id == -1: continue
		
		var source = tileset.get_source(source_id)
		if source is TileSetAtlasSource:
			var atlas_coords = tilemap_layer.get_cell_atlas_coords(cell)
			var texture = source.texture
			if texture:
				# Extract the texture block belonging to this tile
				var tile_img = texture.get_image()
				var src_rect = source.get_tile_texture_region(atlas_coords)
				
				# Target coordinates on our new image
				var dest_x = (cell.x - min_cell.x) * cell_size.x
				var dest_y = (cell.y - min_cell.y) * cell_size.y
				
				export_image.blit_rect(tile_img, src_rect, Vector2i(dest_x, dest_y))

	# 4. Save the finalized file to your project root
	var output_path = "res://exported_tilemap.png"
	var error = export_image.save_png(output_path)
	if error == OK:
		print("Successfully saved tilemap image to: ", output_path)
	else:
		print("Failed to save image. Error code: ", error)
