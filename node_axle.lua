minetest.register_node("digtron:axle", {
	description = "Digtron Rotation Unit",
	groups = {cracky = 3, oddly_breakable_by_hand=3, digtron = 1},
	drop = "digtron:axel",
	sounds = digtron.metal_sounds,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,
	-- Aims in the +Z direction by default
	tiles = {
		"digtron_axel_top.png",
		"digtron_axel_top.png",
		"digtron_axel_side.png",
		"digtron_axel_side.png",
		"digtron_axel_side.png",
		"digtron_axel_side.png",
	},
	
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.3125, -0.3125, 0.5, 0.5, 0.3125}, -- Uppercap
			{-0.5, -0.5, -0.3125, 0.5, -0.3125, 0.3125}, -- Lowercap
			{-0.3125, 0.3125, -0.5, 0.3125, 0.5, -0.3125}, -- Uppercap_edge2
			{-0.3125, 0.3125, 0.3125, 0.3125, 0.5, 0.5}, -- Uppercap_edge1
			{-0.3125, -0.5, -0.5, 0.3125, -0.3125, -0.3125}, -- Lowercap_edge1
			{-0.3125, -0.5, 0.3125, 0.3125, -0.3125, 0.5}, -- Lowercap_edge2
			{-0.25, -0.3125, -0.25, 0.25, 0.3125, 0.25}, -- Axel
		}
	},
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		if meta:get_string("waiting") == "true" then
			-- Been too soon since last time the digtron rotated.
			return
		end
		local image = digtron.get_layout_image(pos, clicker)
		digtron.rotate_layout_image(image, node.param2)
		if digtron.can_write_layout_image(image, clicker) then
			digtron.write_layout_image(image)
			
			minetest.sound_play("whirr", {gain=1.0, pos=pos})
			meta = minetest.get_meta(pos)
			meta:set_string("waiting", "true")
			meta:set_string("infotext", nil)
			minetest.get_node_timer(pos):start(digtron.cycle_time*2)
		else
			minetest.sound_play("buzzer", {gain=1.0, pos=pos})
			meta:set_string("infotext", "Digtron is obstructed.")
		end
	end,
	
	on_timer = function(pos, elapsed)
		minetest.get_meta(pos):set_string("waiting", nil)
	end,
})