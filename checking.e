note
	description: "Summary description for {CHECKING}."

class
	CHECKING

creation
	make

feature {NONE}
	make
		note
			status: creator
		do
		end

feature -- get the destination function -"the decision making"

	get_the_destination (cabin_buttons, floor_up_buttons, floor_down_buttons : MML_SET[INTEGER];
						cur_floor, destination_floor: INTEGER
						destination_up, destination_down: BOOLEAN) :  INTEGER
		require
			in_buttons_or_cur: destination_in_buttons_or_null (cabin_buttons, floor_up_buttons, floor_down_buttons ,destination_floor)
								or cur_floor = destination_floor
			modify: modify ([])
		do
				if destination_floor = cur_floor and  destination_floor /= {ELEVATOR}.null then							-- A
					Result := {ELEVATOR}.null
				elseif destination_floor = {ELEVATOR}.null  then							-- B
					Result:= dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons,
						cur_floor, destination_floor,
						destination_up, destination_down)
				elseif destination_floor /= {ELEVATOR}.null and not cabin_buttons.is_empty  then --C
					Result:= dest_var_C (cabin_buttons,
						destination_floor,
						destination_up, destination_down)
				elseif not destination_in_buttons_or_null(cabin_buttons, floor_up_buttons, floor_down_buttons,
																			destination_floor ) then
					Result:= {ELEVATOR}.null
				else
					Result := destination_floor
				end
		ensure
			post1 : destination_floor = cur_floor and  destination_floor /= {ELEVATOR}.null  implies Result = {ELEVATOR}.null  --A
			post2 : (not  (destination_floor = cur_floor and  destination_floor /= {ELEVATOR}.null) and         --B
					destination_floor = {ELEVATOR}.null)
					implies Result =  dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons,
											cur_floor, destination_floor,
											destination_up, destination_down)
			post3 : (not  (destination_floor = cur_floor and  destination_floor /= {ELEVATOR}.null) and    --C
					not (destination_floor = {ELEVATOR}.null) and
					(destination_floor /= {ELEVATOR}.null and not cabin_buttons.is_empty ) )
					implies Result = dest_var_C (cabin_buttons,
											destination_floor,
											destination_up, destination_down)

			post4 :	(not  (destination_floor = cur_floor and  destination_floor /= {ELEVATOR}.null) and    --C
					not (destination_floor = {ELEVATOR}.null) and
					not (destination_floor /= {ELEVATOR}.null and not cabin_buttons.is_empty )  and
					 	(not destination_in_buttons_or_null(cabin_buttons, floor_up_buttons,
					 							 floor_down_buttons, destination_floor ) )) implies
					Result = {ELEVATOR}.null

			post5 : (not  (destination_floor = cur_floor and  destination_floor /= {ELEVATOR}.null) and    --C
					not (destination_floor = {ELEVATOR}.null) and
					not (destination_floor /= {ELEVATOR}.null and not cabin_buttons.is_empty )  and
					not 	(not destination_in_buttons_or_null(cabin_buttons, floor_up_buttons,
					 							 floor_down_buttons,old	destination_floor ))) implies
					Result = destination_floor

			in_buttons: destination_in_buttons_or_null (cabin_buttons, floor_up_buttons, floor_down_buttons, Result) or Result = cur_floor

		end

	-- VAR_B - "decession_making" for the case "no current destination_floor"
	dest_var_B (cabin_buttons, floor_up_buttons, floor_down_buttons : MML_SET[INTEGER];
				cur_floor, destination_floor: INTEGER
				destination_up, destination_down: BOOLEAN) :  INTEGER

		do
			if (cabin_buttons.is_empty and floor_up_buttons.is_empty 			-- B.a
				and floor_down_buttons.is_empty) then
				Result:= {ELEVATOR}.null
			elseif not cabin_buttons.is_empty then								-- B.b
				Result := farest_in_set(cabin_buttons, cur_floor)
			elseif cabin_buttons.is_empty and
					(not floor_up_buttons.is_empty or
					not floor_down_buttons.is_empty) then						-- B.c
				Result := farest_in_2sets (floor_up_buttons, floor_down_buttons, cur_floor)
			end
		ensure
			post1: cabin_buttons.is_empty and floor_up_buttons.is_empty 			-- B.a
				and floor_down_buttons.is_empty implies
				Result = {ELEVATOR}.null

			post2: not cabin_buttons.is_empty implies
				Result = farest_in_set(cabin_buttons, cur_floor)

			post3: cabin_buttons.is_empty and  (not floor_up_buttons.is_empty or
					not floor_down_buttons.is_empty) implies
				Result = farest_in_2sets (floor_up_buttons, floor_down_buttons, cur_floor)
		end

		-- VAR_B - "decession_making" for the case "lift has destination_floor, so we can just add increase the distance according cabin buttons"
		dest_var_C (cabin_buttons : MML_SET[INTEGER];
							destination_floor: INTEGER
							destination_up, destination_down: BOOLEAN) :  INTEGER
		note
	        status: functional
	    require
	    	not cabin_buttons.is_empty
	    do
	       Result:=
					if destination_up  then
						max (cabin_buttons.max, destination_floor)
					else
						min (cabin_buttons.min, destination_floor)
					end
	    end

feature -- support function for "decession making"

    farest_in_set (set: MML_SET[INTEGER]; cur: INTEGER) : INTEGER
	    note
	        status: functional
	    require
	        not set.is_empty
	    do
	       Result:=
	            if (set.max - cur > cur - set.min) then
	               set.max
	            else
	               set.min
	            end
	    end

    farest_in_2sets (set1, set2: MML_SET[INTEGER]; cur: INTEGER) : INTEGER
	    require
	        not set1.is_empty or not set2.is_empty
	    do
	        if set1.is_empty then
		      Result:= farest_in_set (set2, cur)
	        elseif set2.is_empty then
	    	  Result:= farest_in_set (set1, cur)
	        elseif abs(farest_in_set (set2, cur)-cur) > abs(farest_in_set (set1, cur)-cur)  then
	          Result:= farest_in_set (set2, cur)
	        else
	          Result:= farest_in_set (set1, cur)

	        end
	    ensure
	    	post1: set1.is_empty  implies Result =  farest_in_set (set2, cur)
	    	post2: set2.is_empty  implies Result = farest_in_set (set1, cur)
	    	post3: not set1.is_empty and not set2.is_empty implies
	    				Result = if abs(farest_in_set (set2, cur)-cur) > abs(farest_in_set (set1, cur)-cur) then
	    					farest_in_set (set2, cur)
	    				else
	    					farest_in_set (set1, cur)
	    				end

	    end

feature -- support functions for "farest" functions

	max (a,b : INTEGER) : INTEGER
		note
	        status: functional
		do
			Result :=
						if a>b then
							a
						else
							b
						end
		end

	min (a,b : INTEGER) : INTEGER
		note
	        status: functional
		do
			Result :=
					if a<b then
						a
					else
						b
					end
		end

	abs (x:INTEGER) : INTEGER
		note
			status: functional
		do
			Result := if x>0 then
				x
			else
				-x
			end
		end

feature  -- check is the new value in buttons sets

	destination_in_buttons_or_null (cabin_buttons, floor_up_buttons, floor_down_buttons : MML_SET[INTEGER];
									destination_floor: INTEGER	): BOOLEAN
		note
			status: functional
		do
			Result :=   destination_floor = {ELEVATOR}.null or
						cabin_buttons.has (destination_floor) or
						floor_up_buttons.has (destination_floor) or
						floor_down_buttons.has (destination_floor)
		end

feature -- check the set of button after apply release button routine

	result_release_button_check (condition: BOOLEAN; destination, old_destination: MML_SET[INTEGER]; floor:INTEGER) :BOOLEAN
		note
			status: functional
		do
			Result:= if condition then
				destination = old_destination.removed (floor)
			else
				destination = old_destination
			end
		end

end
