#ifndef COMPONENT_COMPAT_DATUM_CLEANUP
#define COMPONENT_COMPAT_DATUM_CLEANUP Del()
#endif

#ifndef COMPONENT_COMPAT_DELETE
#define COMPONENT_COMPAT_DELETE(thing) del thing
#endif

#ifndef COMPONENT_COMPAT_DELETED
#define COMPONENT_COMPAT_DELETED(thing) (!thing)
#endif

#ifndef COMPONENT_COMPAT_CREATE_GLOBAL_LIST
#define COMPONENT_COMPAT_CREATE_GLOBAL_LIST(name) var/list/##name = list()
#endif

#ifndef COMPONENT_COMPAT_ACCESS_GLOBAL_LIST
#define COMPONENT_COMPAT_ACCESS_GLOBAL_LIST(name) name
#endif

#ifndef COMPONENT_COMPAT_STACK_TRACE
#define COMPONENT_COMPAT_STACK_TRACE(msg) __component_compat_stack_trace(msg)
/proc/__component_compat_stack_trace(msg)
	CRASH(msg)
#endif

#ifndef COMPONENT_COMPAT_CALL_ASYNC
#define COMPONENT_COMPAT_CALL_ASYNC(thing, proctype, arguments) __component_compat_call_async(thing, proctype, arguments)
/proc/__component_compat_call_async(thing, proctype, arguments)
    set waitfor = FALSE
    call(thing, proctype)(arglist(arguments))
#endif

#ifndef COMPONENT_COMPAT_TYPE_TO_PARENT
#define COMPONENT_COMPAT_TYPE_TO_PARENT(child) __component_compat_type_to_parent(child)
/proc/__component_compat_type_to_parent(child)
	var/string_type = "[child]"
	var/last_slash = findlasttext(string_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return null
			if(/obj || /mob)
				return /atom/movable
			if(/area || /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(string_type, 1, last_slash))
#endif