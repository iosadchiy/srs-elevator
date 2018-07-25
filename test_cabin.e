note
	description: "Summary description for {TEST_CABIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_CABIN

create
	make

feature {NONE} -- Initialization

	make
		do
		end

feature
	test_cabin

		local
			cab : CABIN

		do
			create cab.make(1,4)
			cab.close_door
			check cab.cur_floor = 1 end
			cab.move_up
			check cab.cur_floor = 2 end
			cab.stop
			cab.open_door
		end

end
