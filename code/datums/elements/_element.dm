COMPONENT_COMPAT_CREATE_GLOBAL_LIST(__dcs_elements)

/**
  * A holder for simple behaviour that can be attached to many different types
  *
  * Only one element of each type is instanced during game init.
  * Otherwise acts basically like a lightweight component.
  */
/datum/element
	/// Option flags for element behaviour
	var/element_flags = NONE
	/**
	  * The index of the first attach argument to consider for duplicate elements
	  * Is only used when flags contains ELEMENT_BESPOKE
	  * This is infinity so you must explicitly set this
	  */
	var/id_arg_index = -1

/// Activates the functionality defined by the element on the given target datum
/datum/element/proc/Attach(datum/target)
	//SHOULD_CALL_PARENT(TRUE)
	if(type == /datum/element)
		return ELEMENT_INCOMPATIBLE
	if(element_flags & ELEMENT_DETACH)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/Detach, override = TRUE)

/// Deactivates the functionality defines by the element on the given datum
/datum/element/proc/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)

/datum/element/COMPONENT_COMPAT_DATUM_CLEANUP
	var/list/elements_by_type = COMPONENT_COMPAT_ACCESS_GLOBAL_LIST(__dcs_elements)
	elements_by_type -= type
	return ..()

//DATUM PROCS

/// Finds or instances the element specified
/proc/__GetElement(datum/element/eletype, ...)
	var/list/elements_by_type = COMPONENT_COMPAT_ACCESS_GLOBAL_LIST(__dcs_elements)
	var/element_id = eletype
	
	if(initial(eletype.element_flags) & ELEMENT_BESPOKE)
		var/list/fullid = list("[eletype]")
		for(var/i in initial(eletype.id_arg_index) to length(args))
			var/argument = args[i]
			if(istext(argument) || isnum(argument))
				fullid += "[argument]"
			else
				fullid += "\ref[argument]"
		element_id = fullid.Join("&")
			
	. = elements_by_type[element_id]
	if(.)
		return
	if(!ispath(eletype, /datum/element))
		CRASH("Attempted to instantiate [eletype] as a /datum/element")
	. = elements_by_type[element_id] = new eletype

/// Finds the singleton for the element type given and attaches it to src
/datum/proc/AddElement(eletype, ...)
	var/datum/element/ele = __GetElement(arglist(args))
	args[1] = src
	if(ele.Attach(arglist(args)) == ELEMENT_INCOMPATIBLE)
		CRASH("Incompatible [eletype] assigned to a [type]! args: [json_encode(args)]")

/**
  * Finds the singleton for the element type given and detaches it from src
  * You only need additional arguments beyond the type if you're using ELEMENT_BESPOKE
  */
/datum/proc/RemoveElement(eletype, ...)
	var/datum/element/ele = __GetElement(arglist(args))
	ele.Detach(src)
