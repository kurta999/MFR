/*
 * NMSS_vehicles.pwn — reconstructed replacement for the lost vehicle file.
 *
 * The original contained "UVS" (a vehicle streamer): the gamemode calls a
 * CreateDynamicVehicle/...DynamicVehicle... API everywhere and switches its
 * callbacks with `#if defined UVS`. This reconstruction deliberately does
 * NOT define UVS: the gamemode then compiles its standard SA-MP callbacks,
 * and the Dynamic* functions below map 1:1 onto the stock vehicle natives
 * (no streaming, MAX_VEHICLES limit applies).
 *
 * It also provides the vehicle-type classification (GetVehicleType) the
 * gamemode expects.
 */

// ---------------------------------------------------------------------------
// Vehicle type classification
// ---------------------------------------------------------------------------
enum // vehicle types
{
	VEHICLE_CAR = 1,
	VEHICLE_BIKE,         // motorbikes
	VEHICLE_BMX,          // bicycles
	VEHICLE_QUADBIKE,
	VEHICLE_BOAT,
	VEHICLE_HELI,
	VEHICLE_PLANE,
	VEHICLE_TRAIN,
	VEHICLE_TRAM,
	VEHICLE_TRAILER,
	VEHICLE_MONSTERTRUCK
}

stock GetVehicleType(modelid)
{
	switch(modelid)
	{
		case 449: return VEHICLE_TRAM;
		case 537, 538, 569, 570, 590: return VEHICLE_TRAIN;
		case 481, 509, 510: return VEHICLE_BMX;
		case 471: return VEHICLE_QUADBIKE;
		case 448, 461, 462, 463, 468, 521, 522, 523, 581, 586: return VEHICLE_BIKE;
		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return VEHICLE_BOAT;
		case 417, 425, 447, 465, 469, 487, 488, 497, 548, 563: return VEHICLE_HELI;
		case 460, 464, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: return VEHICLE_PLANE;
		case 435, 450, 584, 591, 606, 607, 608, 610, 611: return VEHICLE_TRAILER;
		case 444, 556, 557: return VEHICLE_MONSTERTRUCK;
	}
	return VEHICLE_CAR;
}

// ---------------------------------------------------------------------------
// Thin "dynamic vehicle" wrapper over the stock vehicle natives
// ---------------------------------------------------------------------------
new g_iVehicleSpawnWorld[MAX_VEHICLES];

static
	uvs_Color1[MAX_VEHICLES]   = {-1, ...},
	uvs_Color2[MAX_VEHICLES]   = {-1, ...},
	uvs_Paintjob[MAX_VEHICLES] = { 4, ...},
	uvs_Interior[MAX_VEHICLES];

stock CreateDynamicVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren = 0, worldid = 0, interiorid = 0)
{
	new v = CreateVehicle(modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren);
	if(v != INVALID_VEHICLE_ID && v > 0)
	{
		if(worldid) { SetVehicleVirtualWorld(v, worldid); g_iVehicleSpawnWorld[v] = worldid; }
		if(interiorid) LinkVehicleToInterior(v, interiorid);
	}
	if(v != INVALID_VEHICLE_ID && v > 0)
	{
		uvs_Color1[v] = color1;
		uvs_Color2[v] = color2;
		uvs_Paintjob[v] = 4;
		uvs_Interior[v] = 0;
	}
	return v;
}

stock DestroyDynamicVehicle(vehicleid)
	return DestroyVehicle(vehicleid);

stock IsValidDynamicVehicle(vehicleid)
	return (0 < vehicleid < MAX_VEHICLES) && GetVehicleModel(vehicleid) != 0;

stock CountDynamicVehicles()
{
	new count = 0;
	for(new v = 1; v < MAX_VEHICLES; v++)
		if(GetVehicleModel(v)) count++;
	return count;
}

stock GetDynamicVehicleModel(vehicleid)
	return GetVehicleModel(vehicleid);

stock GetPlayerDynamicVehicleID(playerid)
	return GetPlayerVehicleID(playerid);

stock IsPlayerInDynamicVehicle(playerid, vehicleid)
	return IsPlayerInVehicle(playerid, vehicleid);

stock IsPlayerInAnyDynamicVehicle(playerid)
	return IsPlayerInAnyVehicle(playerid);

stock GetDynamicVehiclePos(vehicleid, &Float:x, &Float:y, &Float:z)
	return GetVehiclePos(vehicleid, x, y, z);

stock SetDynamicVehiclePos(vehicleid, Float:x, Float:y, Float:z)
	return SetVehiclePos(vehicleid, x, y, z);

stock GetDynamicVehicleZAngle(vehicleid, &Float:angle)
	return GetVehicleZAngle(vehicleid, angle);

stock SetDynamicVehicleZAngle(vehicleid, Float:angle)
	return SetVehicleZAngle(vehicleid, angle);

stock GetDynamicVehicleRotationQuat(vehicleid, &Float:w, &Float:x, &Float:y, &Float:z)
	return GetVehicleRotationQuat(vehicleid, w, x, y, z);

stock GetDynamicVehicleVelocity(vehicleid, &Float:vx, &Float:vy, &Float:vz)
	return GetVehicleVelocity(vehicleid, vx, vy, vz);

stock SetDynamicVehicleVelocity(vehicleid, Float:vx, Float:vy, Float:vz)
	return SetVehicleVelocity(vehicleid, vx, vy, vz);

stock SetDynamicVehAngularVelocity(vehicleid, Float:vx, Float:vy, Float:vz)
	return SetVehicleAngularVelocity(vehicleid, vx, vy, vz);

stock GetDynamicVehicleHealth(vehicleid, &Float:health)
	return GetVehicleHealth(vehicleid, health);

stock SetDynamicVehicleHealth(vehicleid, Float:health)
	return SetVehicleHealth(vehicleid, health);

stock RepairDynamicVehicle(vehicleid)
	return RepairVehicle(vehicleid);

stock SetDynamicVehicleToRespawn(vehicleid)
	return SetVehicleToRespawn(vehicleid);

stock AddDynamicVehicleComponent(vehicleid, componentid)
	return AddVehicleComponent(vehicleid, componentid);

stock RemoveDynamicVehicleComponent(vehicleid, componentid)
	return RemoveVehicleComponent(vehicleid, componentid);

stock GetDynamicVehComponentInSlot(vehicleid, slot)
	return GetVehicleComponentInSlot(vehicleid, slot);

stock ChangeDynamicVehicleColor(vehicleid, color1, color2)
{
	uvs_Color1[vehicleid] = color1;
	uvs_Color2[vehicleid] = color2;
	return ChangeVehicleColor(vehicleid, color1, color2);
}

stock GetDynamicVehicleColor(vehicleid, &color1, &color2)
{
	color1 = uvs_Color1[vehicleid];
	color2 = uvs_Color2[vehicleid];
	return 1;
}

stock ChangeDynamicVehiclePaintjob(vehicleid, paintjobid)
{
	uvs_Paintjob[vehicleid] = paintjobid;
	return ChangeVehiclePaintjob(vehicleid, paintjobid);
}

stock GetDynamicVehiclePaintjob(vehicleid)
	return uvs_Paintjob[vehicleid];

stock SetDynamicVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective)
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

stock GetDynamicVehicleParamsEx(vehicleid, &engine, &lights, &alarm, &doors, &bonnet, &boot, &objective)
	return GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

stock SetDynamicVehParamsForPlayer(vehicleid, playerid, objective, doorslocked)
	return SetVehicleParamsForPlayer(vehicleid, playerid, objective, doorslocked);

stock SetDynamicVehParamsCarDoors(vehicleid, driver, passenger, backleft, backright)
	return SetVehicleParamsCarDoors(vehicleid, driver, passenger, backleft, backright);

stock GetDynamicVehParamsCarDoors(vehicleid, &driver, &passenger, &backleft, &backright)
	return GetVehicleParamsCarDoors(vehicleid, driver, passenger, backleft, backright);

stock SetDynamicVehParamsCarWindows(vehicleid, driver, passenger, backleft, backright)
	return SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);

stock GetDynamicVehParamsCarWindows(vehicleid, &driver, &passenger, &backleft, &backright)
	return GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);

stock SetDynamicVehicleVirtualWorld(vehicleid, worldid)
	return SetVehicleVirtualWorld(vehicleid, worldid);

stock GetDynamicVehicleVirtualWorld(vehicleid)
	return GetVehicleVirtualWorld(vehicleid);

stock LinkDynamicVehicleToInterior(vehicleid, interiorid)
{
	uvs_Interior[vehicleid] = interiorid;
	return LinkVehicleToInterior(vehicleid, interiorid);
}

stock GetDynamicVehicleInterior(vehicleid)
	return uvs_Interior[vehicleid];

stock PutPlayerInDynamicVehicle(playerid, vehicleid, seatid)
	return PutPlayerInVehicle(playerid, vehicleid, seatid);

stock PlayerSpectateDynamicVehicle(playerid, targetvehicleid, mode = SPECTATE_MODE_NORMAL)
	return PlayerSpectateVehicle(playerid, targetvehicleid, mode);

stock GetDynamicVehDistanceFromPoint(vehicleid, Float:x, Float:y, Float:z)
	return GetVehicleDistanceFromPoint(vehicleid, x, y, z);

stock GetDynamicVehicleTrailer(vehicleid)
	return GetVehicleTrailer(vehicleid);

stock AttachTrailerToDynamicVehicle(trailerid, vehicleid)
	return AttachTrailerToVehicle(trailerid, vehicleid);

stock DetachTrailerFromDynamicVeh(vehicleid)
	return DetachTrailerFromVehicle(vehicleid);

stock IsTrailerAttachedToDynamicVeh(vehicleid)
	return IsTrailerAttachedToVehicle(vehicleid);

stock UpdateDynamicVehDamageStatus(vehicleid, panels, doors, lights, tires)
	return UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

stock GetDynamicVehicleDamageStatus(vehicleid, &panels, &doors, &lights, &tires)
	return GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

stock SetDynamicVehicleNumberPlate(vehicleid, const numberplate[])
	return SetVehicleNumberPlate(vehicleid, numberplate);

stock IsDynamicVehicleStreamedIn(vehicleid, forplayerid)
	return IsVehicleStreamedIn(vehicleid, forplayerid);

stock GetPlayerSurfingDynamicVehID(playerid)
	return GetPlayerSurfingVehicleID(playerid);

stock IsDynamicVehicleOccupied(vehicleid)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(GetPlayerVehicleID(i) == vehicleid) return 1;
	}
	return 0;
}

// ---------------------------------------------------------------------------
// Per-vehicle metadata the original UVS tracked
// ---------------------------------------------------------------------------
enum (<<= 1) // vehicle status flag bits (plain ints, the gamemode mixes them with ints)
{
	e_BONNET_STATUS = 1,
	e_BOOT_STATUS,
	e_STEREO_STATUS,
	e_NO_TELE,
	e_RESPAWNED,
	e_NO_RAND_COLOR_1,
	e_NO_RAND_COLOR_2
}

static uvs_Flags[MAX_VEHICLES];
static uvs_ExplodeTimer[MAX_VEHICLES] = {-1, ...};
static uvs_SpawnColor1[MAX_VEHICLES] = {-1, ...};
static uvs_SpawnColor2[MAX_VEHICLES] = {-1, ...};
static uvs_SpawnInterior[MAX_VEHICLES];


stock GetVehicleFlags(vehicleid)
	return uvs_Flags[vehicleid];

stock SetVehicleFlags(vehicleid, flags)
	return (uvs_Flags[vehicleid] = flags);

stock SetVehicleExplodeTimer(vehicleid, timerid)
	return (uvs_ExplodeTimer[vehicleid] = timerid);

stock GetVehicleExplodeTimer(vehicleid)
	return uvs_ExplodeTimer[vehicleid];

stock ResetExplodeTimer(vehicleid)
{
	if(uvs_ExplodeTimer[vehicleid] != -1)
	{
		KillTimer(uvs_ExplodeTimer[vehicleid]);
		uvs_ExplodeTimer[vehicleid] = -1;
	}
	return 1;
}

stock GetVehicleSpawnColor(vehicleid, &color1, &color2)
{
	color1 = uvs_SpawnColor1[vehicleid];
	color2 = uvs_SpawnColor2[vehicleid];
	return 1;
}

stock GetVehicleSpawnInterior(vehicleid)
	return uvs_SpawnInterior[vehicleid];

stock UVS_RememberSpawnData(vehicleid, color1, color2, interior = 0)
{
	uvs_SpawnColor1[vehicleid] = color1;
	uvs_SpawnColor2[vehicleid] = color2;
	uvs_SpawnInterior[vehicleid] = interior;
	uvs_Flags[vehicleid] = 0;
	uvs_ExplodeTimer[vehicleid] = -1;
	return 1;
}

// ---------------------------------------------------------------------------
// Player-in-vehicle counters
// ---------------------------------------------------------------------------
stock GetMaxPassengers(modelid)
{
	switch(modelid)
	{
		case 437, 431: return 8; // Coach, Bus
		case 449: return 6;      // Tram
		case 425, 447, 465, 469, 501, 564: return 0;
		default:
		{
			switch(GetVehicleType(modelid))
			{
				case VEHICLE_BIKE, VEHICLE_BMX, VEHICLE_QUADBIKE: return 1;
				case VEHICLE_PLANE, VEHICLE_HELI: return 1;
			}
		}
	}
	return 3;
}

// NOTE: placeholder pricing — the original price table was in the lost file.
stock GetVehiclePrice(modelid)
{
	switch(GetVehicleType(modelid))
	{
		case VEHICLE_PLANE, VEHICLE_HELI: return 1000000;
		case VEHICLE_BOAT: return 500000;
		case VEHICLE_BMX: return 25000;
		case VEHICLE_BIKE, VEHICLE_QUADBIKE: return 150000;
		case VEHICLE_MONSTERTRUCK: return 750000;
	}
	return 250000;
}

stock GetVehicleComponentTypeName(componentid)
{
	static const names[][] = {
		"Spoiler", "Hood", "Roof", "Sideskirt", "Lamps", "Nitro", "Exhaust",
		"Wheels", "Stereo", "Hydraulics", "Front bumper", "Rear bumper",
		"Vent right", "Vent left"
	};
	static out[16];
	new type = GetVehicleComponentType(componentid);
	out[0] = EOS;
	strcat(out, (0 <= type < sizeof(names)) ? names[type] : names[0], sizeof(out));
	return out;
}

stock IsUpgrade(componentid)
	return (1000 <= componentid <= 1193);

// Permissive compatibility check (the original had a full table; invalid
// mods on some models can crash clients — refine when data is recovered).
stock IsUpgradeCompatible(modelid, componentid)
{
	if(!IsUpgrade(componentid)) return 0;
	switch(GetVehicleType(modelid))
	{
		case VEHICLE_CAR, VEHICLE_MONSTERTRUCK: return 1;
		default:
		{
			// only wheels & nitro elsewhere
			switch(componentid)
			{
				case 1008, 1009, 1010, 1025, 1073..1085, 1096..1098: return 1;
			}
		}
	}
	return 0;
}

stock IsLicensePlate(vehicleid)
{
	switch(GetVehicleType(GetVehicleModel(vehicleid)))
	{
		case VEHICLE_CAR, VEHICLE_BIKE, VEHICLE_QUADBIKE, VEHICLE_MONSTERTRUCK: return 1;
	}
	return 0;
}

stock RandomNumberPlate(vehicleid)
{
	new plate[16];
	format(plate, sizeof(plate), "MFR-%03d", random(1000));
	return SetVehicleNumberPlate(vehicleid, plate);
}



// Vehicle petrol-cap shot offsets per model (400..611). The original data
// table was lost; zeros disable the "shoot the fuel cap" explosion feature.
new const Float:gVehiclePetrolCapOffsets[212][3];

stock IsValidRaceVehicle(modelid)
{
	if(!(400 <= modelid <= 611)) return 0;
	switch(GetVehicleType(modelid))
	{
		case VEHICLE_TRAIN, VEHICLE_TRAM, VEHICLE_TRAILER: return 0;
	}
	switch(modelid)
	{
		case 441, 464, 465, 501, 564, 594: return 0; // RC toys
	}
	return 1;
}
