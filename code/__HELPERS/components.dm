// This is the holder for global signals
COMPONENT_COMPAT_CREATE_GLOBAL(__dcs, /datum, new /datum)

/// A wrapper so sending signals can be referenced by proc path
/proc/send_global_signal(signal, ...)
	SEND_GLOBAL_SIGNAL(signal)
