minetest.register_privilege("no_knockback", {
	description = "Knockback does not affect players with this priv",
	give_to_singleplayer = false,
	give_to_admin = true,
})

minetest.register_on_punchplayer(function(player, _, _, tool, dir, damage)
	if minetest.check_player_privs(player, {no_knockback = false}) and player:get_hp() > 0 then
		if dir.y <= 0 then
			dir.y = -dir.y
		end

		if damage >= 3 then damage = 3 end
		if damage < 1 then return end

		local kback = damage or tool.damage_groups.knockback

		local pos = player:get_pos()
		pos.y = pos.y + 0.4
		local dest = vector.add(pos, vector.multiply(dir, kback/2.4))
		local ray = minetest.raycast(pos, dest, false, false)
		dir.y = 0

		local pointed = ray:next()

		if pointed == nil then
			local backdir = vector.divide(dir, -2)

			player:move_to(vector.add(dest, backdir), false)
		elseif pointed.above then
			local backdir = vector.divide(dir, -50)
			player:move_to(vector.add(pointed.above, backdir), false)
		end
	end
end)