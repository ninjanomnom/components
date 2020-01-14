/datum
	/// Components attached to this datum
	/// Lazy associated list in the structure of `type:component/list of components`
	var/list/datum_components
	/// Any datum registered to receive signals from this datum is in this list
	/// Lazy associated list in the structure of `signal:registree/list of registrees`
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/list/signal_procs
	/// Is this datum capable of sending signals?
	/// Set to true when a signal has been registered
	var/signal_enabled = FALSE

/datum/COMPONENT_COMPAT_DATUM_CLEANUP
	signal_enabled = FALSE

	var/list/dc = datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/i in all_components)
				var/datum/component/comp = i
				comp.__cleanup(FALSE, TRUE)
		else
			var/datum/component/comp = all_components
			comp.__cleanup(FALSE, TRUE)
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

	// We may or may not have other sibling overrides to call, the linter is going to be wrong about one of them
	return UNLINT(..())