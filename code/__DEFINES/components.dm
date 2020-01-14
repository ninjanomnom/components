#ifndef SEND_SIGNAL
#define SEND_SIGNAL(target, sigtype, arguments...) ( !target.comp_lookup || !target.comp_lookup[sigtype] ? NONE : target._SendSignal(sigtype, list(target, ##arguments)) )
#endif

#ifndef SEND_GLOBAL_SIGNAL
// You need the extra wrapping around COMPONENT_COMPAT_ACCESS_GLOBAL because of some oddity with how byond interprets defines
// Probably a byond bug that needs to be isolated
#define SEND_GLOBAL_SIGNAL(sigtype, arguments...) SEND_SIGNAL((COMPONENT_COMPAT_ACCESS_GLOBAL(__dcs)), sigtype, ##arguments)
#endif

#ifndef RegisterGlobalSignal
#define RegisterGlobalSignal(arguments...) RegisterSignal(COMPONENT_COMPAT_ACCESS_GLOBAL(__dcs), ##arguments)
#endif

#ifndef UnregisterGlobalSignal
#define UnregisterGlobalSignal(arguments...) UnregisterSignal(COMPONENT_COMPAT_ACCESS_GLOBAL(__dcs), ##arguments)
#endif

/// Return this from `/datum/component/Initialize` or `datum/component/OnTransfer` to have the component be deleted if it's applied to an incorrect type.
/// `parent` must not be modified if this is to be returned.
/// This will be noted in the runtime logs
#define COMPONENT_INCOMPATIBLE 1
/// Returned in PostTransfer to prevent transfer, similar to `COMPONENT_INCOMPATIBLE`
#define COMPONENT_NOTRANSFER 2

/// Return value to cancel attaching
#define ELEMENT_INCOMPATIBLE 1

/// /datum/element flags
#define ELEMENT_DETACH		(1 << 0)
/**
  * Only elements created with the same arguments given after `id_arg_index` share an element instance
  * The arguments are the same when the text and number values are the same and all other values have the same ref
  */
#define ELEMENT_BESPOKE		(1 << 1)

// How multiple components of the exact same type are handled in the same datum
/// old component is deleted (default)
#define COMPONENT_DUPE_HIGHLANDER		0
/// duplicates allowed
#define COMPONENT_DUPE_ALLOWED			1
/// new component is deleted
#define COMPONENT_DUPE_UNIQUE			2
/// old component is given the initialization args of the new
#define COMPONENT_DUPE_UNIQUE_PASSARGS	4
/// each component of the same type is consulted as to whether the duplicate should be allowed
#define COMPONENT_DUPE_SELECTIVE		5

// Default return value from signal procs
#ifndef NONE
#define NONE 0
#endif

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// Should be sent from wherever your datum cleanup code is
#define COMSIG_PARENT_QDELETING "component_qdeleting"