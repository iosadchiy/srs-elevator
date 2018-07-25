note
	description: "Summary description for {TEST_CHECKING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_CHECKING


create
	make

feature {APPLICATION} -- Initialization

	make
		do

			print("%N_________Test completed___________%N");
		end

feature

	test_abs_max
		local
			c: CHECKING
            a, b : INTEGER
         do
         	create c.make

         	a:= 10
         	b:= 12
         	check max1: (c.max (a, b) = 12)         	end
         	check max2: (c.max (b, a) = 12)         	end
			a:=-10
			b:= 10
			check abs1: (c.abs (a) = 10) end
			check abs2: (c.abs (b) = 10) end
         end

	test_farest
			-- Test of routine `make' that has to pass verification.
		local
			c: CHECKING
            set, set2, empty_set: MML_SET[INTEGER]

            floor, new_floor : INTEGER
		do
			create c.make
            set := <<1,2,10>>
            floor := 4
            new_floor := c.farest_in_set(set, floor)
            check new_floor = 10 end
            new_floor := c.farest_in_2sets(set, empty_set, floor)
            check new_floor = 10 end
            set2 := <<1,15>>

            new_floor := c.farest_in_2sets(empty_set, set2, floor)
            check new_floor_15: new_floor = 15 end

			set := <<1,5>>
			set2 := <<5,6>>
			new_floor := c.farest_in_2sets(set, set2, floor)
            check new_floor_1: new_floor = 1 end
		end

	test_dest_var_C
	local
		checking : CHECKING
		cabin_buttons, floor_up_buttons, floor_down_buttons : MML_SET[INTEGER]
		cur_floor, old_destination_floor, destination_floor : INTEGER
		destination_up, destination_down					: BOOLEAN
	do
		create checking.make

		-- check var_C up
		cur_floor:=1
		old_destination_floor := 2
		cabin_buttons := <<4,5>>
		destination_up:= true
		destination_down:= false
		destination_floor := checking.dest_var_C (cabin_buttons,
														 old_destination_floor,
														destination_up, destination_down)
		check new_dest_5: destination_floor = 5 end

		-- check var_C down
		cur_floor:=5
		old_destination_floor := 3
		cabin_buttons := <<1,2>>
		destination_up:= false
		destination_down:= true
		destination_floor := checking.dest_var_C (cabin_buttons,
														 old_destination_floor,
														destination_up, destination_down)
		check destination_down and not cabin_buttons.is_empty end
		check destination_down and not cabin_buttons.is_empty end
		check checking.min (cabin_buttons.min, destination_floor) = 1 end
		check new_dest_1: destination_floor = 1 end
	end

	test_dest_var_B
	local
		checking : CHECKING
		cabin_buttons, floor_up_buttons, floor_down_buttons, empty_set : MML_SET[INTEGER]
		cur_floor, old_destination_floor, destination_floor : INTEGER
		destination_up, destination_down					: BOOLEAN
	do
		create checking.make

		-- check var_B a
		cur_floor:=1
		old_destination_floor := {ELEVATOR}.null
		destination_up:= true  -- unchecked
		destination_down:= true -- unchecked
		destination_floor := checking.dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)
		check ch_1: destination_floor = {ELEVATOR}.null end

		-- check var_B b
		cur_floor:=5
		old_destination_floor := {ELEVATOR}.null
		cabin_buttons := <<1,2,8>>
		floor_up_buttons := <<-1,100>>
		destination_floor := checking.dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)

		check new_dest_Bb: destination_floor = 1 end

		-- check var_B c_1
		cur_floor:=5
		old_destination_floor := {ELEVATOR}.null
		cabin_buttons := empty_set
		floor_up_buttons := <<-1,100>>
		destination_floor := checking.dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)

		check new_dest_Bc1: destination_floor = 100 end

		-- check var_B c_2
		cur_floor:=5
		old_destination_floor := {ELEVATOR}.null
		cabin_buttons := empty_set
		floor_up_buttons := <<-1,100>>
		floor_down_buttons := <<-200,10>>
		destination_floor := checking.dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)
		check new_dest_Bc2: destination_floor = -200 end
	end




	test_get_destination
	local
		checking : CHECKING
		cabin_buttons, floor_up_buttons, floor_down_buttons, empty_set : MML_SET[INTEGER]
		cur_floor, old_destination_floor, destination_floor : INTEGER
		destination_up, destination_down					: BOOLEAN
	do
		create checking.make

		-- check A
		cur_floor:=1
		old_destination_floor := 1
		cabin_buttons := <<4,5>>
		destination_up:= false
		destination_down:= false
		destination_floor := checking.get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)
		check new_dest_minus1000: destination_floor = {ELEVATOR}.null end

		-- check C_up
		cur_floor:=1
		old_destination_floor := -1000
		cabin_buttons := <<4,5>>
		destination_up:= true
		destination_down:= false
		destination_floor := checking.get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)
		check new_dest_5: destination_floor = 5 end
	end

	test_get_destination_1
	local
		checking : CHECKING
		cabin_buttons, floor_up_buttons, floor_down_buttons, empty_set : MML_SET[INTEGER]
		cur_floor, old_destination_floor, destination_floor : INTEGER
		destination_up, destination_down					: BOOLEAN
	do
		create checking.make

		-- check A
		cur_floor:=1
		old_destination_floor := -1000
		floor_up_buttons := <<0,2>>
		floor_down_buttons := <<2,3>>

		destination_up:= false
		destination_down:= false
		destination_floor := checking.get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons,
															cur_floor, old_destination_floor,
															destination_up, destination_down)
		check new_dest_minus1000: destination_floor =3 end
	end

end
