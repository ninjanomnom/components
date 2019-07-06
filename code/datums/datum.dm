/datum
	var/list/datum_components //for /datum/components
	var/list/comp_lookup //it used to be for looking up components which had registered a signal but now anything can register
	var/list/list/signal_procs
	var/signal_enabled = FALSE

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/COMPONENT_COMPAT_DATUM_CLEANUP
	signal_enabled = FALSE

	var/list/dc = datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/I in all_components)
				var/datum/component/C = I
				C._RemoveFromParent()
				C.parent = null
				COMPONENT_COMPAT_DELETE(C)
		else
			var/datum/component/C = all_components
			C._RemoveFromParent()
			C.parent = null
			COMPONENT_COMPAT_DELETE(C)
		dc.Cut()

	var/list/lookup = comp_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/i in comps)
					var/datum/component/comp = i
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		comp_lookup = lookup = null

	for(var/target in signal_procs)
		UnregisterSignal(target, signal_procs[target])

	return ..()