note
	description: "Summary description for {TEST_ELEVATOR_INTEGRATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ELEVATOR

creation
	make

feature {NONE}
	make
		note
			status: creator
		do
		end

feature

	-- one person push buttons in lift
	test_lift_1_pers_in_cabin
		note
--			status: skip
		local
			lift : ELEVATOR
		do
			create lift.make(0,2)
			check ch_1: is_stopped_and_openned (lift) end      -- opened doors
			check ch_2: lift.cur_floor = 0 end        -- current floor is 0
			check ch_2_1: lift.destination_floor = -1000 end -- destination


			lift.push_cabin_button (2) -- should go to the 2nd floor
			check ch_2_3: lift.cabin_buttons.has (2) end   -- 2 nd button is pressed
			check ch_2_4: lift.future_destination = 2 end  -- check future destination  /if this will be commented everything  is bad/

			check  future_operation_1:
				not lift.have_to_stop_and_open_door and
				not lift.have_to_close_the_door_and_allow_moving and
				not lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate -- lift aware the destination
			check ch_3_1: is_stopped_and_openned (lift) end   -- lift still stopped and open
			check ch_3_2: lift.cur_floor = 0 end      -- current floor still 0
			check ch_3_3: lift.destination_floor = 2 end   -- destination is setted according button in cabin
			check ch_3_4: lift.cabin_buttons.has (2) end   -- cabin button still pressed

			check  future_operation_4:
				not	lift.have_to_stop_and_open_door and
				    lift.have_to_close_the_door_and_allow_moving and
				not lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate  -- lift close the door
			check ch_4_1: move_and_closed (lift) end   -- lift still stopped and open
			check ch_4_2: lift.cur_floor = 0 end      -- current floor still 0
			check ch_4_3: lift.destination_floor = 2 end   -- destination is setted according button in cabin
			check ch_4_4: lift.cabin_buttons.has (2) end   -- cabin button still pressed

			check  future_operation_5:
				not	lift.have_to_stop_and_open_door and
				not lift.have_to_close_the_door_and_allow_moving and
				    lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate  -- lift move up
			check ch_5_1: move_and_closed (lift) end   -- lift still stopped and open
			check ch_5_2: lift.cur_floor = 1 end      -- current floor still 0
			check ch_5_3: lift.destination_floor = 2 end   -- destination is setted according button in cabin
			check ch_5_4: lift.cabin_buttons.has (2) end   -- cabin button still pressed

			check  future_operation_6:
				not	lift.have_to_stop_and_open_door and
				not lift.have_to_close_the_door_and_allow_moving and
				    lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate  -- lift move up
			check ch_6_1: move_and_closed (lift) end   -- lift moved and closed
			check ch_6_2: lift.cur_floor = 2 end      -- current floor still 0
			check ch_6_3: lift.destination_floor = -1000 end   -- destination is setted to NULL
			check ch_6_4: lift.cabin_buttons.has (2) end   -- cabin button still pressed

			check  future_operation_7:
					lift.have_to_stop_and_open_door and
				not lift.have_to_close_the_door_and_allow_moving and
				not lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate  -- lift stop and open
			check ch_7_1: is_stopped_and_openned (lift) end   -- lift  stopped and open
			check ch_7_2: lift.cur_floor = 2 end      -- current floor still 0
			check ch_7_3: lift.destination_floor = -1000 end   -- destination is setted to NULL
			check ch_7_4: lift.cabin_buttons.count = 0 end   -- cabin button is released

		-- LIFT is in waiting stage
			check  future_operation_8:
				not	lift.have_to_stop_and_open_door and
				not	lift.have_to_close_the_door_and_allow_moving and
				not lift.have_to_move_up and
				not lift.have_to_move_down and
			true end
		end

	test_lift_many_buttons -- many buttons
		note
--			status: skip
		local
			lift : ELEVATOR
		do
			create lift.make(0,3)
			check ch_1: is_stopped_and_openned (lift) end      -- opened door
			check ch_2: lift.cur_floor = 0 end        -- current floor is 0
			check ch_2_1: lift.destination_floor = -1000 end -- destination


			lift.push_cabin_button (2) -- should go to the 2nd floor
			check ch_2_3: lift.cabin_buttons.has (2) end   -- 2 nd button is pressed
			check ch_2_4: lift.future_destination = 2 end  -- check future destination  /if this will be commented everything  is bad/

			check  future_operation_1:
				not lift.have_to_stop_and_open_door and
				not lift.have_to_close_the_door_and_allow_moving and
				not lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate -- lift aware the destination
			check ch_2_1: lift.destination_floor = 2 end -- destination is 2

			lift.operate  -- lift close the door

			lift.push_cabin_button (3)  -- the destination should change to 3
			lift.push_floor_up_button (1)  -- we should stop here and take passanger
			lift.push_floor_down_button (2) -- we skip the 2nd floor as it is not ok_direction

			lift.operate  -- lift move up
			check ch_1_1: lift.destination_floor = 3 end -- destination is 2
			check ch_1_2: lift.cur_floor = 1 end      -- current floor 1
			check ch_1_3: lift.cabin_buttons.has(2) end   -- cabin has 2
			check ch_1_4: lift.cabin_buttons.has(3) end   -- cabin has 3
			check ch_1_5: lift.floor_up_buttons.has(1) end   -- up_buttons has 1
			check ch_1_6: lift.floor_down_buttons.has(2) end   -- up_buttons has 2


			lift.operate -- lift stop and open
			check ch_2_1: lift.cur_floor = 1 end
			check ch_2_2: is_stopped_and_openned (lift) end   -- lift  stopped and open
			check ch_2_3: lift.cabin_buttons.has(2) end   -- cabin has 2
			check ch_2_4: lift.cabin_buttons.has(3) end   -- cabin has 3
			check ch_2_5: not lift.floor_up_buttons.has(1) end   -- up_buttons NOT has 1
			check ch_2_6: lift.floor_down_buttons.has(2) end   -- up_buttons has 3

			lift.operate -- lift close door
			check ch_3_1: lift.cur_floor = 1 end
			check ch_3_2: move_and_closed (lift) end   -- lift  stopped and open


			lift.operate -- lift move up
			check ch_4_1: lift.cur_floor = 2 end
			check  future_operation_8:
					lift.have_to_stop_and_open_door and
				not	lift.have_to_close_the_door_and_allow_moving and
				    lift.have_to_move_up and
				not lift.have_to_move_down and
			true end

			lift.operate -- open the door, release the button,
			check ch_5_1: lift.cur_floor = 2 end
			check ch_5_2: is_stopped_and_openned (lift) end   -- lift  stopped and open
			check ch_5_3: not lift.cabin_buttons.has(2) end   -- cabin NOT has 2
			check ch_5_4: lift.cabin_buttons.has(3) end   -- cabin has 3
			check ch_5_5: lift.floor_down_buttons.has(2) end   -- up_buttons STILL has 2

--  I spent 2 min, but no result.

--			lift.operate -- close_door
--			lift.operate -- move_up
--			lift.operate -- open door
--			check ch_6_1: lift.cur_floor = 3 end
--			check ch_6_2: is_stopped_and_openned (lift) end   -- lift  stopped and open
--			check ch_6_3: not lift.cabin_buttons.has(3) end   -- cabin has NOT 3
--			check ch_6_4: lift.floor_down_buttons.has(2) end   -- up_buttons STILL has 2
--			check ch_2_4: lift.destination_floor = 2 end -- destination is 2
		end

feature -- special func for testing
	is_stopped_and_openned (lift: ELEVATOR) : BOOLEAN
		note
			status: functional
			status: skip
		do
			Result := not lift.is_moving and lift.is_door_open
		end

	move_and_closed (lift: ELEVATOR) : BOOLEAN
		note
			status: functional
			status: skip
		do
			Result := lift.is_moving and not lift.is_door_open
		end

end
