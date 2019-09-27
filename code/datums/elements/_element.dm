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

/// Activates the functionality defined by the element on the given target datum
/datum/element/proc/Attach(datum/target)
	//SHOULD_CALL_PARENT(TRUE)
	if(type == /datum/element)
		return ELEMENT_INCOMPATIBLE
	if(element_flags & ELEMENT_DETACH)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/Detach)

/// Deactivates the functionality defines by the element on the given datum
/datum/element/proc/Detach(datum/source, force)
	//SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)

/datum/element/COMPONENT_COMPAT_DATUM_CLEANUP
	var/list/elements_by_type = COMPONENT_COMPAT_ACCESS_GLOBAL_LIST(__dcs_elements)
	elements_by_type -= type
	return ..()

//DATUM PROCS

/// Finds or instances the element specified
/proc/__GetElement(eletype)
	var/list/elements_by_type = COMPONENT_COMPAT_ACCESS_GLOBAL_LIST(__dcs_elements)
	. = elements_by_type[eletype]
	if(.)
		return
	if(!ispath(eletype, /datum/element))
		CRASH("Attempted to instantiate [eletype] as a /datum/element")
	. = elements_by_type[eletype] = new eletype

/// Finds the singleton for the element type given and attaches it to src
/datum/proc/AddElement(eletype, ...)
    var/datum/element/ele = __GetElement(eletype)
    args[1] = src
    if(ele.Attach(arglist(args)) == ELEMENT_INCOMPATIBLE)
        CRASH("Incompatible [eletype] assigned to a [type]! args: [json_encode(args)]")

/// Finds the singleton for the element type given and detaches it from src
/datum/proc/RemoveElement(eletype)
	var/datum/element/ele = __GetElement(eletype)
	ele.Detach(src)
