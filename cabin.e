note
	description: "Summary description for {CABIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CABIN

creation
	make

feature {ELEVATOR}

	TOTAL_FLOORS : INTEGER -- total floors

	curFloor : INTEGER 		-- current floor

	doorIsOpen : BOOLEAN 	-- is doorOpened

	direction : INTEGER		-- 1 = cabin should move up, -1= cabin should move down, 0= cabin has no pressed buttons

	buttons : ARRAY[BUTTON] -- buttons

	make (floors : INTEGER)
		require
			floors > 1
		do
			TOTAL_FLOORS := floors
			curFloor := 0
			doorIsOpen := true
			direction :=0
			create buttons.make (0, TOTAL_FLOORS-1)
		end

invariant
	-1 <= direction  and direction <=1
	0 <= curFloor and curFloor < TOTAL_FLOORS

end
