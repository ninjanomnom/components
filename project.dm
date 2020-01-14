// This is a workaround so we can check this file in the dme
// Normaly the interface doesnt allow including dmes directly

// __SUBMODULE is so we can have different compile options when this is inside another project

#define __SUBMODULE
#include "components.dme"
#undef __SUBMODULE
