note
	description: "Summary description for {BUTTON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BUTTON

create
	make

feature
	inProgress: BOOLEAN

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			inProgress := false
		end

feature -- press the BUTTON

	push()

		do
			inProgress := true
		end

end
