#ifdef SPACEMAN_DMM
    #ifndef RETURN_TYPE
        #define RETURN_TYPE(X) set SpacemanDMM_return_type = X
    #endif
    #ifndef SHOULD_CALL_PARENT
        #define SHOULD_CALL_PARENT(X) set SpacemanDMM_should_call_parent = X
    #endif
    #ifndef UNLINT
        #define UNLINT(X) SpacemanDMM_unlint(X)
    #endif
    #ifndef SHOULD_NOT_OVERRIDE
        #define SHOULD_NOT_OVERRIDE(X) set SpacemanDMM_should_not_override = X
    #endif
    #ifndef VAR_FINAL
        #define VAR_FINAL var/SpacemanDMM_final
    #endif
#else
    #ifndef RETURN_TYPE
        #define RETURN_TYPE(X)
    #endif
    #ifndef SHOULD_CALL_PARENT
        #define SHOULD_CALL_PARENT(X)
    #endif
    #ifndef UNLINT
        #define UNLINT(X) X
    #endif
    #ifndef SHOULD_NOT_OVERRIDE
        #define SHOULD_NOT_OVERRIDE(X)
    #endif
    #ifndef VAR_FINAL
        #define VAR_FINAL var
    #endif
#endif
