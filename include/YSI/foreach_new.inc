/*
 * foreach_new.inc — reconstructed shim for the lost MFR include.
 * Wraps the standalone foreach include and provides the Itter_* aliases
 * the gamemode uses alongside the standard Iter_* ones.
 */
#if defined _inc_foreach_new
	#endinput
#endif
#define _inc_foreach_new

#include <foreach>

#define Itter_Add(%0,%1)     Iter_Add(%0,%1)
#define Itter_Remove(%0,%1)  Iter_Remove(%0,%1)
#define Itter_Count(%0)      Iter_Count(%0)
#define Itter_Random(%0)     Iter_Random(%0)
#define Itter_Free(%0)       Iter_Free(%0)
#define Itter_Contains(%0,%1) Iter_Contains(%0,%1)

// String copy helper the original include pack provided (used gamemode-wide).
stock strcpy(dest[], const source[], len = sizeof(dest))
{
	dest[0] = EOS;
	return strcat(dest, source, len);
}
