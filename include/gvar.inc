/*
 * gvar.inc — global variable plugin interface (Incognito's GVar plugin).
 * Native declarations reconstructed to the plugin's public API; the MFR
 * gamemode uses the per-id forms (id = extra dimension, default 0).
 * Runtime requires the gvar plugin (plugins/gvar.so | gvar.dll).
 */
#if defined _gvar_included
	#endinput
#endif
#define _gvar_included

#define GLOBAL_VARTYPE_NONE   (0)
#define GLOBAL_VARTYPE_INT    (1)
#define GLOBAL_VARTYPE_STRING (2)
#define GLOBAL_VARTYPE_FLOAT  (3)

native SetGVarInt(const varname[], int_value, id = 0);
native GetGVarInt(const varname[], id = 0);
native SetGVarString(const varname[], const string_value[], id = 0);
native GetGVarString(const varname[], string_return[], len = sizeof(string_return), id = 0);
native SetGVarFloat(const varname[], Float:float_value, id = 0);
native Float:GetGVarFloat(const varname[], id = 0);
native DeleteGVar(const varname[], id = 0);
native GetGVarsUpperIndex();
native GetGVarNameAtIndex(index, ret[], len = sizeof(ret));
native GetGVarType(const varname[], id = 0);
