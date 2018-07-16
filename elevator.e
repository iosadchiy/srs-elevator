note
	description: "Summary description for {ELEVATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ELEVATOR

create make

feature

	cabin: CABIN
	floors: ARRAY[FLOOR]
	totalFloors: INTEGER

feature

	make(nfloors: INTEGER)
		require
			nfloors > 1
		do
			totalFloors := nfloors
			create floors.make(0, totalFloors-1)
		end

end
