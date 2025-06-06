/datum/admins/proc/open_shuttlepanel()
	set category = "Admin.Shuttles"
	set name = "Shuttle Manipulator"
	set desc = "Opens the shuttle manipulator UI."

	if(!check_rights(R_EVENT|R_DEBUG|R_HOST))
		return

	SSshuttle.tgui_interact(usr)


/obj/docking_port/mobile/proc/admin_fly_shuttle(mob/user)
	var/list/options = list()

	for(var/port in SSshuttle.stationary)
		if (istype(port, /obj/docking_port/stationary/transit))
			continue  // please don't do this
		var/obj/docking_port/stationary/S = port
		if (canDock(S) == SHUTTLE_CAN_DOCK)
			options[S.name || S.id] = S

	options += "--------"
	options += "Infinite Transit"
	options += "Delete Shuttle"
	options += "Into The Sunset (delete & greentext 'escape')"

	var/selection = input(user, "Select where to fly [name || id]:", "Fly Shuttle") as null|anything in options
	if(!selection)
		return

	switch(selection)
		if("Infinite Transit")
			destination = null
			set_mode(SHUTTLE_IGNITING)
			on_ignition()
			setTimer(ignitionTime)

		if("Delete Shuttle")
			if(alert(user, "Really delete [name || id]?", "Delete Shuttle", "Cancel", "Really!") != "Really!")
				return
			jumpToNullSpace()

		if("Into The Sunset (delete & greentext 'escape')")
			if(alert(user, "Really delete [name || id] and greentext escape objectives?", "Delete Shuttle", "Cancel", "Really!") != "Really!")
				return
			intoTheSunset()

		else
			if(options[selection])
				request(options[selection])
	message_admins("[usr] has manipulated [name || id ] with selection [selection]")
