note
	description: "Summary description for {TEST_ELEVATOR_SIMPLE}."


class
	TEST_ELEVATOR_SIMPLE

creation
	make

feature {NONE}
	make
		note
			status: creator
		do
		end

feature

	test_lift_cabin_buttons
		local
			elevator : ELEVATOR
		do
			create elevator.make(0,4)
			-- simple check cabin buttons
			check ch_1: elevator.cabin_buttons.is_empty end

			elevator.push_cabin_button (1)
			check ch_2: elevator.cabin_buttons.has (1)  end
			check ch_3: elevator.cabin_buttons.count = 1  end

			elevator.push_cabin_button (2)
			check ch_4: not elevator.cabin_buttons.is_empty end
			check ch_5: elevator.cabin_buttons.has (1)  end
			check ch_6: elevator.cabin_buttons.has (2)  end
			check ch_7: not elevator.cabin_buttons.has (3)  end
			check ch_8: elevator.cabin_buttons.count=2  end

			elevator.move_up
			elevator.release_cabin_button (1)
			check ch_9: not elevator.cabin_buttons.is_empty end
			check ch_10: not elevator.cabin_buttons.has (1)  end
			check ch_11: elevator.cabin_buttons.has(2)  end
			check ch_12: elevator.cabin_buttons.count = 1  end

			elevator.move_up
			elevator.release_cabin_button (2)
			check ch_13: elevator.cabin_buttons.is_empty end
			check ch_14: not elevator.cabin_buttons.has (1)  end
			check ch_15: not elevator.cabin_buttons.has(2)  end
			check ch_16: elevator.cabin_buttons.count = 0  end
		end

	test_lift_floor_down_buttons
		local
			elevator : ELEVATOR
		do
			create elevator.make(0,4)
			-- simple check floor_down_buttons
			check ch_1: elevator.floor_down_buttons.is_empty end

			elevator.push_floor_down_button (1)
			check ch_2: elevator.floor_down_buttons.has (1)  end
			check ch_3: elevator.floor_down_buttons.count = 1  end

			elevator.push_floor_down_button (2)
			check ch_4: not elevator.floor_down_buttons.is_empty end
			check ch_5: elevator.floor_down_buttons.has (1)  end
			check ch_6: elevator.floor_down_buttons.has (2)  end
			check ch_7: not elevator.floor_down_buttons.has (3)  end
			check ch_8: elevator.floor_down_buttons.count=2  end

			elevator.move_up
			elevator.release_floor_down_button (1)
			check ch_9: not elevator.floor_down_buttons.is_empty end
			check ch_10: not elevator.floor_down_buttons.has (1)  end
			check ch_11: elevator.floor_down_buttons.has(2)  end
			check ch_12: elevator.floor_down_buttons.count = 1  end

			elevator.move_up
			elevator.release_floor_down_button (2)
			check ch_13: elevator.floor_down_buttons.is_empty end
			check ch_14: not elevator.floor_down_buttons.has (1)  end
			check ch_15: not elevator.floor_down_buttons.has(2)  end
			check ch_16: elevator.floor_down_buttons.count = 0  end
	end

	test_lift_floor_up_buttons
		local
			elevator : ELEVATOR
		do
			create elevator.make(0,4)
			-- simple check floor_up_buttons
			check ch_1: elevator.floor_up_buttons.is_empty end

			elevator.push_floor_up_button (1)
			check ch_2: elevator.floor_up_buttons.has (1)  end
			check ch_3: elevator.floor_up_buttons.count = 1  end

			elevator.push_floor_up_button (2)
			check ch_4: not elevator.floor_up_buttons.is_empty end
			check ch_5: elevator.floor_up_buttons.has (1)  end
			check ch_6: elevator.floor_up_buttons.has (2)  end
			check ch_7: not elevator.floor_up_buttons.has (3)  end
			check ch_8: elevator.floor_up_buttons.count=2  end

			elevator.move_up
			elevator.release_floor_up_button (1)
			check ch_9: not elevator.floor_up_buttons.is_empty end
			check ch_10: not elevator.floor_up_buttons.has (1)  end
			check ch_11: elevator.floor_up_buttons.has(2)  end
			check ch_12: elevator.floor_up_buttons.count = 1  end

			elevator.move_up
			elevator.release_floor_up_button (2)
			check ch_13: elevator.floor_up_buttons.is_empty end
			check ch_14: not elevator.floor_up_buttons.has (1)  end
			check ch_15: not elevator.floor_up_buttons.has(2)  end
			check ch_16: elevator.floor_up_buttons.count = 0  end
		end

	test_lift_drop_buttons
		local
			elevator : ELEVATOR
		do
			create elevator.make(0,4)

			check ch_1: elevator.cur_floor = 0 end

			elevator.push_floor_up_button (0)
			elevator.push_floor_down_button (1)
			elevator.push_cabin_button (0)
			check ch_2: elevator.floor_up_buttons.has (0)  end
			check ch_3: elevator.floor_down_buttons.has (1)  end
			check ch_4: elevator.cabin_buttons.has (0)  end

			elevator.drop_buttons_with_open_door

			check ch_5: not (elevator.floor_up_buttons.has (0))  end
			check ch_6: elevator.floor_down_buttons.has (1)  end
			check ch_7: not (elevator.cabin_buttons.has (0))  end

			check ch_8: elevator.cur_floor = 0 end
			elevator.move_up

			check ch_9: elevator.cur_floor = 1 end
			elevator.push_floor_up_button (1)
			elevator.push_floor_down_button (1)
			elevator.push_cabin_button (1)
			check ch_10: elevator.floor_up_buttons.has (1)  end
			check ch_11: elevator.floor_down_buttons.has (1)  end
			check ch_12: elevator.cabin_buttons.has (1)  end

			elevator.drop_buttons_with_open_door

			check ch_10: elevator.floor_up_buttons.is_empty  end
			check ch_11: elevator.floor_down_buttons.is_empty  end
			check ch_12: elevator.cabin_buttons.is_empty  end
		end


		test_lift_move_up_down
			local
				elevator : ELEVATOR
			do
				create elevator.make(0,4)
				check ch_1: elevator.cur_floor = 0 end
				elevator.move_up
				check ch_2: elevator.cur_floor = 1 end
				elevator.move_up
				check ch_3: elevator.cur_floor = 2 end
				elevator.move_down
				check ch_4: elevator.cur_floor = 1 end
				elevator.move_down
				check ch_5: elevator.cur_floor = 0 end
			end

		test_lift_open_close
			local
				lift : ELEVATOR
				test : TEST_ELEVATOR
			do
				create lift.make(0,4)
				create test.make

				check
					ch_1: test.is_stopped_and_openned (lift)
				end
				lift.close_door_and_start_moving
				check
					ch_2: test.move_and_closed (lift)
				end
				lift.stop_and_open_door
				check
					ch_1: test.is_stopped_and_openned (lift)
				end
			end

end
