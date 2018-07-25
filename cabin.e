note
	description: "Summary description for {CABIN}."
	model: cur_floor, max_floor, min_floor, door_is_open, is_moved

class
	CABIN

creation
	make

feature {NONE} -- create

	make (a_min_floor, a_max_floor : INTEGER)
		note
			status: creator
		require
			number_is_ok: 	a_min_floor >= 0
			number_is_ok_2: a_max_floor > a_min_floor
		do
			max_floor := a_max_floor
			min_floor := a_min_floor
			cur_floor := min_floor
			door_is_open := true
			is_moved := false
		ensure
			cur_floor_is_ok: 	cur_floor = min_floor
			max_floor_is_ok: max_floor = a_max_floor
			min_floor_is_ok: min_floor = a_min_floor
			not_moved: is_moved = false
			door_is_open: door_is_open = true
		end


feature -- access
	max_floor : INTEGER -- max_floor index

	min_floor : INTEGER -- min_floor index

	cur_floor : INTEGER 		-- current floor

	door_is_open : BOOLEAN 	-- is doorOpened

	is_moved : BOOLEAN --




feature

	stop

		require
			modify_field (["is_moved","closed"], Current)
		do
			is_moved := false
		ensure
			is_moved_false: is_moved = false
		end

	close_door
		require
			modify_field (["door_is_open","closed"], Current)
			cabin_is_stopped: is_moved = false
		do
			door_is_open := false
		ensure
			door_is_open_false: door_is_open = false
		end

	open_door
		require
			modify_field (["door_is_open","closed"], Current)
			cabin_is_stopped: is_moved = false
		do
			door_is_open := true
		ensure
			door_is_open: door_is_open = true
		end


	move_up
		require
			modify_field (["cur_floor", "is_moved","closed"], Current)
			cabin_can_move_up: cabin_can_move_up
		do
			cur_floor := cur_floor + 1
			is_moved := true
		ensure
			floorIsNext:		 cur_floor = old cur_floor + 1
			is_moving	:		is_moved = true
		end

	move_down
		require
			modify_field (["cur_floor", "is_moved", "closed"], Current)
			cabin_can_move_down: cabin_can_move_down
		do
			cur_floor := cur_floor - 1
			is_moved := true
		ensure
			floorIsNext:		 cur_floor = old cur_floor - 1
			is_moving	:		is_moved = true
		end

	cabin_can_move_up  : BOOLEAN
		note
			status: functional
		do
			Result :=
					cur_floor < max_floor
			 	and	cur_floor >= min_floor
			    and	door_is_open = false
		end

	cabin_can_move_down : BOOLEAN
		note
			status: functional
		do
			Result :=
					cur_floor <= max_floor
			 	and	cur_floor > min_floor
			    and	door_is_open = false
		end


invariant

	border_bottom: min_floor <= cur_floor;
	border_up: cur_floor <= max_floor;
	min_max_is_ok_1: min_floor >= 0
	min_max_is_ok_2: max_floor > min_floor
end
