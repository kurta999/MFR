/*
 * crashdetect.inc — minimal interface for the crashdetect plugin.
 * The gamemode only #includes it (no symbols used); these are the
 * plugin's standard natives for completeness.
 */
#if defined _crashdetect_included
	#endinput
#endif
#define _crashdetect_included

native PrintAmxBacktrace();
native PrintNativeBacktrace();
native GetAmxBacktrace(string[], size = sizeof(string));
native GetNativeBacktrace(string[], size = sizeof(string));
