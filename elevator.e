note
	description: "Summary description for {ELEVATOR}."
	model:		checking , cur_floor, cabin_buttons, floor_up_buttons, floor_down_buttons,
	is_moving, 	is_door_open, destination_floor,
	min_floor, max_floor

class
	ELEVATOR

creation
	make

feature {NONE} -- create

	make (a_min_floor, a_max_floor : INTEGER)
		note
			status: creator
		require
			number_is_ok: 	a_min_floor > {ELEVATOR}.null
			number_is_ok_2: a_max_floor > a_min_floor
		do
			create checking.make
			create cabin_buttons
			create floor_up_buttons
			create floor_down_buttons

			max_floor := a_max_floor
			min_floor := a_min_floor
			cur_floor := a_min_floor
			destination_floor := {ELEVATOR}.null
			is_moving := false
			is_door_open := true
		ensure
			min_floor				: min_floor = a_min_floor
			max_floor				: max_floor = a_max_floor
			cur_floor				: cur_floor = a_min_floor
			destination_floor		: destination_floor = {ELEVATOR}.null
			is_moving				: is_moving = false
			is_door_open			: is_door_open = true
			no_buttons_1			: cabin_buttons.is_empty
			no_buttons_2			: floor_up_buttons.is_empty
			no_buttons_3			: floor_down_buttons.is_empty
			in_buttons 				: destination_in_buttons_or_null
		end

feature  -- ACCESS
	NULL : INTEGER = -1000

	min_floor, max_floor : INTEGER
	checking: CHECKING
	cur_floor : INTEGER

	floor_up_buttons 	: MML_SET[INTEGER]
	floor_down_buttons  : MML_SET[INTEGER]
	cabin_buttons		: MML_SET[INTEGER]

	is_moving			: BOOLEAN
	is_door_open		: BOOLEAN


	destination_floor 	: INTEGER -- '{ELEVATOR}.null' means that there is no destination

-- mirrors of the destination_floor  and cur_floor

	is_destination		: BOOLEAN
		note
			status 		: functional
		do
			Result := 	destination_floor /= {ELEVATOR}.null
		end

	no_destination		: BOOLEAN
		note
			status 		: functional
		do
			Result := 	destination_floor = {ELEVATOR}.null
		ensure
			Result = 	(destination_floor = {ELEVATOR}.null)
		end

	destination_up		: BOOLEAN
		note
			status 		: functional
		do
			Result := 	is_destination and destination_floor > cur_floor
		end

	destination_down: BOOLEAN
		note
			status 		: functional
		do
			Result := 	is_destination and destination_floor < cur_floor
		end

-- mirror function for cur_floor and max/min_floor
	can_move_up		: BOOLEAN
	note
		status 		: functional
	do
		Result := 	 cur_floor < max_floor
	end

	can_move_down		: BOOLEAN
	note
		status 		: functional
	do
		Result :=  min_floor < cur_floor
	end

--=========================================================================
-- INTERFACE  : PUSHING BUTTONS
--=========================================================================
feature

	push_cabin_button (button : INTEGER)
		require
			modify_model ("cabin_buttons", Current)
			in_range: min_floor  <= button and button <= max_floor
		do
			cabin_buttons := set_after_push(cabin_buttons, button)
		ensure
			def: cabin_buttons = set_after_push(old cabin_buttons, button)
		end

	push_floor_up_button (button : INTEGER)
		require
			modify_model ("floor_up_buttons", Current)
			in_range: min_floor <= button and button <= (max_floor-1)
		do
			floor_up_buttons := set_after_push(floor_up_buttons, button)
		ensure
			def: floor_up_buttons = set_after_push(old floor_up_buttons, button)
		end

	push_floor_down_button (button : INTEGER)
		require
			modify_model ("floor_down_buttons", Current)
			in_range: (min_floor +1) <= button and button <= max_floor
		do
			floor_down_buttons := set_after_push(floor_down_buttons, button)
		ensure
			def: floor_down_buttons = set_after_push(old floor_down_buttons, button)
		end

--=========================================================================
feature -- INTERFACE  : MAIN OPERATION FUNCTION
--=========================================================================

	operate
		note
			explicit: wrapping
		require
			inv
			modify_model (["floor_up_buttons","floor_down_buttons","cabin_buttons",
							"is_moving","is_door_open", "destination_floor", "cur_floor"], Current)
			in_buttons		:	destination_in_buttons_or_null
		local
			old_have_to_stop : BOOLEAN

		do
			drop_buttons_with_open_door  -- drop buttons pushed at the floor, than the lift is here
			old_have_to_stop := have_to_stop_and_open_door
			if have_to_stop_and_open_door then
				stop_and_open_door
			elseif have_to_close_the_door_and_allow_moving then
				close_door_and_start_moving
			elseif have_to_move_up then
				move_up
			elseif have_to_move_down then
				move_down
			else
				-- do_nothing
			end

			if old_have_to_stop then -- it means that now lift is stopped, and door is open - so drop buttons again
				if (destination_up or no_destination )  then
					release_floor_up_button (cur_floor)
				end
				if (destination_down or no_destination)  then
					release_floor_down_button (cur_floor)
				end
				release_cabin_button (cur_floor)
			end

			set_destination_floor (checking.get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons,
																cur_floor, destination_floor,
																destination_up, destination_down) )
		ensure

	-- ensure from drop_buttons	
			floor_up_buttons: checking.result_release_button_check (((old is_door_open and not (old is_moving) or old have_to_stop_and_open_door)
																					 and  (old destination_up or old no_destination)) ,
																		floor_up_buttons, old floor_up_buttons,  old cur_floor)
			floor_down_buttons: checking.result_release_button_check (((old is_door_open and not (old is_moving) or old have_to_stop_and_open_door)
																					and (old destination_down or old no_destination)),
																	floor_down_buttons, old floor_down_buttons, old cur_floor)
			cabin_buttons: 	checking.result_release_button_check ((old is_door_open and not (old is_moving) or old have_to_stop_and_open_door),
																		cabin_buttons, old cabin_buttons, old cur_floor)

	--ensure have_to_close_the_door_and_allow_moving, move_up, move_down

			stop_moving:	old have_to_stop_and_open_door
							implies (is_moving = false            and is_door_open = true              and  cur_floor = old cur_floor)

			start_moving:  	(not old have_to_stop_and_open_door  and  old have_to_close_the_door_and_allow_moving )
							implies (is_moving = true            and is_door_open = false              and  cur_floor = old cur_floor)

			move_up:		(not old have_to_stop_and_open_door  and  (not old have_to_close_the_door_and_allow_moving)
							and old have_to_move_up)
							implies (is_moving = old is_moving   and is_door_open = old is_door_open   and  cur_floor = old cur_floor + 1)

			move_down: 		(not old have_to_stop_and_open_door  and  not old have_to_close_the_door_and_allow_moving
							and not old have_to_move_up and old have_to_move_down)
							implies (is_moving = old is_moving   and is_door_open = old is_door_open   and  cur_floor = old cur_floor - 1)

			wait :			(not old have_to_stop_and_open_door  and  not old have_to_close_the_door_and_allow_moving
							and not old have_to_move_up and not old have_to_move_down)
							implies (is_moving = old is_moving   and is_door_open = old is_door_open   and  cur_floor = old cur_floor )

	--destination
		dest_floor:	destination_floor = checking.get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons,
																 cur_floor, old destination_floor,
																old destination_up, old destination_down)
		end

-- NOT INTERFACE AREA

feature -- release buttons routines

	drop_buttons_with_open_door
		note
			explicit: wrapping
		require
			r1: inv
			r2: destination_in_buttons_or_null or cur_floor = destination_floor
			r3: modify_model (["floor_up_buttons","floor_down_buttons","cabin_buttons"], Current)
		do
			if (
			is_door_open and not is_moving and
			(destination_up or no_destination) )  then
				release_floor_up_button (cur_floor)
			end

			if (
			is_door_open and not is_moving and
			(destination_down or no_destination))  then
				release_floor_down_button (cur_floor)
			end

			if (is_door_open and not is_moving) then
				release_cabin_button (cur_floor)
			end
		ensure

			floor_up_buttons: checking.result_release_button_check (is_door_open and not is_moving and  (destination_up or no_destination) ,
																		floor_up_buttons, old floor_up_buttons,  cur_floor)
			floor_down_buttons: checking.result_release_button_check (is_door_open and not is_moving and (destination_down or no_destination),
																	floor_down_buttons, old floor_down_buttons,  cur_floor)
			cabin_buttons: 	checking.result_release_button_check (is_door_open and not is_moving,
																		cabin_buttons, old cabin_buttons,  cur_floor)
			in_buttons: destination_in_buttons_or_null or destination_floor = cur_floor
		end

	release_floor_up_button (floor:INTEGER)
        require
            modify_model ("floor_up_buttons",Current)
			cur_floor: floor = cur_floor
        do
			floor_up_buttons := floor_up_buttons.removed (floor)
        ensure
			check_ok : checking.result_release_button_check (true, floor_up_buttons, old floor_up_buttons, floor)
		end

	release_cabin_button (floor:INTEGER)
        require
            modify_model ("cabin_buttons",Current)
            cur_floor: floor = cur_floor
        do
			cabin_buttons := cabin_buttons.removed (floor)

        ensure
			check_ok : checking.result_release_button_check (true, cabin_buttons, old cabin_buttons, floor)

		end

	release_floor_down_button (floor:INTEGER)
        require
            modify_model ("floor_down_buttons",Current)
			cur_floor: floor = cur_floor
        do
			floor_down_buttons := floor_down_buttons.removed (floor)
        ensure
			check_ok : checking.result_release_button_check (true, floor_down_buttons, old floor_down_buttons, floor)
		end

feature -- four operate routines

	stop_and_open_door
		require
			modify_model (["is_moving","is_door_open"], Current)
		do
			is_moving := false
			is_door_open := true
		ensure
			is_moving = false
			is_door_open = true
		end

	close_door_and_start_moving
		require
			modify_model (["is_moving","is_door_open"], Current)
		do
			is_moving := true
			is_door_open := false
		ensure
			is_moving = true
			is_door_open = false
		end

	move_up
		require
			modify_model ("cur_floor",Current)
			not_top: can_move_up
			cur_floor_not_dist: cur_floor /= destination_floor
		do
			cur_floor :=  cur_floor+1;
		ensure
			cur_floor_ok: cur_floor = old cur_floor+1;
		end

	move_down
		require
			modify_model ("cur_floor",Current)
			not_bottom : can_move_down
			cur_floor_not_dist: cur_floor /= destination_floor
		do
			cur_floor :=  cur_floor-1;
		ensure
			cur_floor_ok: cur_floor = old cur_floor-1;
		end

feature -- SETTER FOR destination_floor

	set_destination_floor (new_dest: INTEGER)
		require
			modify_model ("destination_floor",Current)
			new_dest1: checking.destination_in_buttons_or_null (cabin_buttons, floor_up_buttons, floor_down_buttons, new_dest)
		do
			destination_floor :=  new_dest
		ensure
			new_dest1: destination_floor =  new_dest
		end


feature -- WHAT TO DO NEXT OPERATE

	have_to_stop_and_open_door  : BOOLEAN
		note
			status: functional
		do
			Result:= is_moving and (
					cabin_buttons.has(cur_floor)
				or	( (destination_up or no_destination) and floor_up_buttons.has(cur_floor))
				or  ((destination_down or no_destination) and floor_down_buttons.has(cur_floor))
			)
		end

	have_to_close_the_door_and_allow_moving  : BOOLEAN
		note
			status: functional
		do
			Result:= (not is_moving) and is_destination
		end

	have_to_move_up : BOOLEAN
		note
			status: functional
		do
			Result := is_moving and destination_up and can_move_up
		end

	have_to_move_down : BOOLEAN
		note
			status: functional
		do
			Result := is_moving and destination_down and can_move_down
		end

feature   -- CHECKINGS

	set_after_push (set: MML_SET[INTEGER]; button : INTEGER) : MML_SET[INTEGER]
		note
			status: functional
		do
			Result:=  set.extended(button)
		ensure
			Result =  set.extended(button)
		end


	destination_in_buttons_or_null : BOOLEAN
		note
			status: functional
		do
			Result :=   destination_floor = {ELEVATOR}.null or
					cabin_buttons.has (destination_floor) or
					floor_up_buttons.has (destination_floor) or
					floor_down_buttons.has (destination_floor)
		end


feature -- DEBUG: some invariant can fault

	future_destination : INTEGER
		note
			status: functional
		require
			all_inv: inv
		do
			Result:= checking.get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons,
																	cur_floor, destination_floor,
																	destination_up, destination_down)
		end
-----------------------END DEBUG


invariant
	checking_not_null: checking /= Void

	buttons_in_range_1	: 	if cabin_buttons.is_empty then
								true
							else
								cabin_buttons.max <= max_floor and cabin_buttons.min >= min_floor
							end
	buttons_in_range_2	: 	if floor_up_buttons.is_empty then
								true
							else
								floor_up_buttons.max <= (max_floor-1) and floor_up_buttons.min >= min_floor
							end

	buttons_in_range_3	: 	if floor_down_buttons.is_empty then
								true
							else
								floor_down_buttons.max <= max_floor and floor_down_buttons.min >= (min_floor+1)
							end

	min_max_is_ok_1: min_floor > {ELEVATOR}.null
	min_max_is_ok_2: max_floor > min_floor

	cur_floor_is_ok1: min_floor <= cur_floor
	cur_floor_is_ok2: cur_floor <= max_floor

	owns_definition: owns = [checking]

	reverse_door_and_moving:	is_moving = not is_door_open

	destination_in_range1 : min_floor <= destination_floor or destination_floor = {ELEVATOR}.null

	destination_in_range2 : destination_floor<= max_floor

	destination_in_buttons : destination_floor = {ELEVATOR}.null or cabin_buttons.has (destination_floor) or
								floor_up_buttons.has (destination_floor) or floor_down_buttons.has (destination_floor) or
								destination_floor = cur_floor
end
