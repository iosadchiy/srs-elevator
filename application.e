note
	description : "Elevator application root class"
	date        : "$Date$"
	revision    : "$Revision$"



class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			test_main 			: TEST_ELEVATOR
			test_lift_simple 	: TEST_ELEVATOR_SIMPLE
			test_cabin			: TEST_CABIN
			test_checking		: TEST_CHECKING

		do
			create	test_checking.make
				test_checking.test_abs_max
				test_checking.test_farest
				test_checking.test_dest_var_C
				test_checking.test_dest_var_B
				test_checking.test_get_destination
				test_checking.test_get_destination_1

			create test_lift_simple.make
				test_lift_simple.test_lift_cabin_buttons
				test_lift_simple.test_lift_floor_down_buttons
				test_lift_simple.test_lift_floor_up_buttons
				test_lift_simple.test_lift_drop_buttons
				test_lift_simple.test_lift_move_up_down
				test_lift_simple.test_lift_open_close

			create test_main.make
				test_main.test_lift_1_pers_in_cabin
				test_main.test_lift_many_buttons

			create test_cabin.make
				test_cabin.test_cabin
		end

invariant -- in other case we catch an yellow "internal error" of translation
	a: true
end
