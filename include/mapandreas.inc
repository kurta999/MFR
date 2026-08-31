/*
 * mapandreas.inc — MapAndreas plugin interface (height map lookups).
 * Native declarations per the classic MapAndreas plugin API.
 * Runtime requires the mapandreas plugin and its SAfull.hmap/SAmin.hmap data.
 */
#if defined _mapandreas_included
	#endinput
#endif
#define _mapandreas_included

#define MAP_ANDREAS_MODE_NONE    (0)
#define MAP_ANDREAS_MODE_MINIMAL (1)
#define MAP_ANDREAS_MODE_MEDIUM  (2)
#define MAP_ANDREAS_MODE_FULL    (3)
#define MAP_ANDREAS_MODE_NOBUFFER (4)

#define MAP_ANDREAS_ERROR_FAILURE (0)
#define MAP_ANDREAS_ERROR_SUCCESS (1)

native MapAndreas_Init(mode, name[] = "");
native MapAndreas_Unload();
native MapAndreas_SaveCurrentHMap(name[]);
native MapAndreas_FindZ_For2DCoord(Float:x, Float:y, &Float:z);
native MapAndreas_FindAverageZ(Float:x, Float:y, &Float:z);
native MapAndreas_SetZ_For2DCoord(Float:x, Float:y, Float:z);
