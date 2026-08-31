/*
 * NMSS_config.pwn - reconstructed configuration + utility file (the original
 * was not part of the repository; it held credentials and shared helpers).
 * Fill in your own MySQL access data before running the server.
 */

// Game database (connection id 1)
#define MYSQL_HOST      "127.0.0.1"
#define MYSQL_USER      "mfr"
#define MYSQL_PASS      "changeme"
#define MYSQL_DB        "mfr"

// Host machine database (connection id 2, used when running on the old host)
#define MYSQL_HOST_HOST "127.0.0.1"
#define MYSQL_USER_HOST "mfr"
#define MYSQL_PASS_HOST "changeme"
#define MYSQL_DB_HOST   "mfr"

// MySQL plugin log level
#define MYSQL_DEBUG_    (LOG_ERROR | LOG_WARNING)

// RCON password (also set it in server.cfg!)
#define RCON_PASSWORD   "changeme_rcon"

// IRC (the IRC bot code is disabled via IRC_ASD, kept for completeness)
#define IRC_SERVER      "irc.example.com"
#define IRC_PORT        (6667)
#define IRC_CHANNEL     "#mfr"

// ---------------------------------------------------------------------------
// Reconstructed globals the original NMSS_config.pwn provided
// ---------------------------------------------------------------------------

// Player name cache (pName(id) macro in nmss.pwn maps to this array)
new g_szaPlayerNames[MAX_PLAYERS][MAX_PLAYER_NAME];

// Max registered accounts per IP (loaded from the config table at startup)
new gIP_Count = 6;

// Forum (SMF) database connection handle (assigned by mysql_connect at init)
new ForumSQLConnect = 2;

// Forum SQL availability flag (checked before forum registration features)
new gForumSQL = 1;

// Number of saved holding-object sets / musiclist entries (refreshed from SQL)
new g_Hosets;
new g_Musics;

// Server-side tracked money ("Ex" anti-moneyhack wrappers)
new g_iMoneyEx[MAX_PLAYERS];

// Weapon whitelist bits (weapon ids 0..46)
new Bit:g_baAllowedWeapon[MAX_PLAYERS][2];

// Attached-object editor state (per player, per slot)
new gAOModel[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new gAOBone[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAOOffSet_X[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAOOffSet_Y[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAOOffSet_Z[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAORot_X[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAORot_Y[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAORot_Z[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAOScale_X[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAOScale_Y[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new Float:gAOScale_Z[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new gAOColor1[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];
new gAOColor2[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS];

// Second banned-word list (chat filter) - original contents lost
new const g_szTiltottSzavak2[][] = {
	"http://", "www.", ".com", ".net", ".hu/", "samp://"
};

// Pickup extra-id categories (streamer E_STREAMER_EXTRA_ID markers)
enum
{
	e_PICKUP_TYPE_DEFAULT = 0,
	e_PICKUP_TYPE_HOUSE,
	e_PICKUP_TYPE_BIZNIS,
	e_PICKUP_TYPE_HORSESHOE,
	e_PICKUP_TYPE_OYSTER,
	e_PICKUP_TYPE_DEATH_MONEY
}

#if !defined WEAPON_NIGHTVISION
	#define WEAPON_NIGHTVISION (44)
#endif
#if !defined WEAPON_INFRARED
	#define WEAPON_INFRARED (45)
#endif

// Key state macros (used inside OnPlayerKeyStateChange bodies)
#define HOLDING(%0)  ((newkeys & (%0)) == (%0))
#define PRESSED(%0)  (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

// ---------------------------------------------------------------------------
// Reconstructed helper functions
// ---------------------------------------------------------------------------

// Vehicle model validity
stock IsValidModel(modelid)
	return (400 <= modelid <= 611);

// Classic unix-timestamp builder
stock mktime(hour, minute, second, day, month, year)
{
	new timestamp = 0;
	static const days_of_month[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

	for(new y = 1970; y < year; y++)
		timestamp += ((((y % 4) == 0 && (y % 100) != 0) || (y % 400) == 0) ? 366 : 365) * 86400;

	for(new m = 1; m < month; m++)
	{
		timestamp += days_of_month[m - 1] * 86400;
		if(m == 2 && (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0))
			timestamp += 86400;
	}

	timestamp += (day - 1) * 86400 + hour * 3600 + minute * 60 + second;
	return timestamp;
}

// Unix timestamp "now" (SA-MP's gettime() with no args returns it)
stock CurrentTimestamp()
	return gettime();

// timestamp -> date components (inverse of mktime)
stock date(timestamp, &day, &month, &year, &hour, &minute, &second)
{
	static const days_of_month[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
	new days = timestamp / 86400, rem = timestamp % 86400;

	hour = rem / 3600; minute = (rem % 3600) / 60; second = rem % 60;

	year = 1970;
	while(true)
	{
		new ydays = ((((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0) ? 366 : 365);
		if(days < ydays) break;
		days -= ydays; year++;
	}
	month = 1;
	while(true)
	{
		new mdays = days_of_month[month - 1];
		if(month == 2 && (((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0)) mdays++;
		if(days < mdays) break;
		days -= mdays; month++;
	}
	day = days + 1;
	return 1;
}

// Formatted kick with reason logging; delayed so pending messages arrive
forward NMSS_DelayedKick(playerid);
public NMSS_DelayedKick(playerid)
	return Kick(playerid);

stock KickEx(playerid, const reason_fmt[], va_args<>)
{
	va_format(gs_szKimenet, sizeof(gs_szKimenet), reason_fmt, va_start<2>);
	printf("[KICK] %s (id %d): %s", g_szaPlayerNames[playerid], playerid, gs_szKimenet);
	SetTimerEx("NMSS_DelayedKick", 200, false, "d", playerid);
	return 1;
}

// Replace literal "\n" (backslash + n, e.g. from the database) with newlines
stock ConvertNewLine(str[])
{
	for(new i = 0; str[i] != EOS; i++)
	{
		if(str[i] == '\\' && str[i + 1] == 'n')
		{
			str[i] = '\n';
			strdel(str, i + 1, i + 2);
		}
	}
	return 1;
}

// Swimming check (swim animation indexes)
stock IsPlayerInWater(playerid)
{
	new anim = GetPlayerAnimationIndex(playerid);
	return (1538 <= anim <= 1544);
}

stock Float:GetDistance2D(Float:x1, Float:y1, Float:x2, Float:y2)
	return floatsqroot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));

stock Float:GetDistance3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
	return floatsqroot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2));

// RC ("toy") vehicles
stock IsVehicleToy(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 441, 464, 465, 501, 564, 594: return 1;
	}
	return 0;
}

// Thousands-separated number string (Hungarian style: 1.234.567)
stock FormatNumber(number)
{
	static out[24];
	new tmp[24], neg = (number < 0), len, outpos = 0;
	format(tmp, sizeof(tmp), "%d", neg ? -number : number);
	len = strlen(tmp);
	out[0] = EOS;
	if(neg) out[outpos++] = '-';
	for(new i = 0; i < len; i++)
	{
		if(i && ((len - i) % 3) == 0) out[outpos++] = '.';
		out[outpos++] = tmp[i];
	}
	out[outpos] = EOS;
	return out;
}

stock GivePlayerMoneyEx(playerid, amount, const reason[] = "")
{
	#pragma unused reason
	g_iMoneyEx[playerid] += amount;
	return GivePlayerMoney(playerid, amount);
}

stock GetPlayerMoneyEx(playerid)
	return g_iMoneyEx[playerid];

stock SetPlayerMoneyEx(playerid, amount)
{
	g_iMoneyEx[playerid] = amount;
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, amount);
}

// Weapon id <-> pickup model mapping
stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
		case 1: return 331;
		case 2..8: return 332 + weaponid;
		case 9: return 341;
		case 10: return 321; case 11: return 322; case 12: return 323;
		case 13: return 324; case 14: return 325; case 15: return 326;
		case 16: return 342; case 17: return 343; case 18: return 344;
		case 22: return 346; case 23: return 347; case 24: return 348;
		case 25: return 349; case 26: return 350; case 27: return 351;
		case 28: return 352; case 29: return 353; case 30: return 355;
		case 31: return 356; case 32: return 372; case 33: return 357;
		case 34: return 358; case 35: return 359; case 36: return 360;
		case 37: return 361; case 38: return 362; case 39: return 363;
		case 40: return 364; case 41: return 365; case 42: return 366;
		case 43: return 367; case 44: return 368; case 45: return 369;
		case 46: return 371;
	}
	return 0;
}

stock GetWeaponIDFromModel(modelid)
{
	for(new w = 1; w <= 46; w++)
		if(GetWeaponModel(w) == modelid) return w;
	return 0;
}

// Localized broadcast to online admins of at least the given level
stock SendClientMessageToAdmins(color, minlevel, const langkey[], va_args<>)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;
		if(GetPVarInt(i, "Level") < minlevel && !IsPlayerAdmin(i)) continue;
		va_format(gs_szKimenet, sizeof(gs_szKimenet), LANG(i, langkey), va_start<3>);
		SendClientMessage(i, color, gs_szKimenet);
	}
	return 1;
}

stock GivePlayerScore(playerid, amount)
	return SetPlayerScore(playerid, GetPlayerScore(playerid) + amount);

stock IsValidEmail(const email[])
{
	new at = -1, dot = -1, len = strlen(email);
	if(len < 5 || len > 64) return 0;
	for(new i = 0; i < len; i++)
	{
		if(email[i] == '@')
		{
			if(at != -1) return 0;
			at = i;
		}
		else if(email[i] == '.' && at != -1) dot = i;
		else if(email[i] <= ' ') return 0;
	}
	return (at > 0 && dot > at + 1 && dot < len - 1);
}

stock SetPlayerSkillLevelEx(playerid, skill, level)
{
	g_pWeaponSkill[playerid][skill] = level;
	return SetPlayerSkillLevel(playerid, skill, level);
}

stock IsNumeric(const str[])
{
	new i = 0;
	if(str[0] == '-' || str[0] == '+') i = 1;
	if(!str[i]) return 0;
	for( ; str[i] != EOS; i++)
		if(!('0' <= str[i] <= '9')) return 0;
	return 1;
}

stock abs(value)
	return (value < 0) ? (-value) : (value);

stock Float:Clamp360(Float:angle)
{
	while(angle < 0.0) angle += 360.0;
	while(angle >= 360.0) angle -= 360.0;
	return angle;
}

stock Float:GetPointAngleToPoint(Float:x1, Float:y1, Float:x2, Float:y2)
{
	new Float:a;
	a = atan2(y2 - y1, x2 - x1) - 90.0;
	return Clamp360(a);
}

stock Float:GetAngleToPoint(Float:x1, Float:y1, Float:x2, Float:y2)
	return GetPointAngleToPoint(x1, y1, x2, y2);

// Distance from the player to the bonus car
stock Float:BonusCarDistance(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	return GetVehicleDistanceFromPoint(g_BonusCarID, x, y, z);
}

// Localized chat bubble wrapper: the gamemode calls
// SetPlayerChatBubble(playerid, color, drawdist, ms, "LANG_KEY", args...)
native SetPlayerChatBubble_(playerid, const text[], color, Float:drawdistance, expiretime) = SetPlayerChatBubble;
#define SetPlayerChatBubble(%0,%1,%2,%3,%4) MFR_ChatBubble(%0, %1, %2, %3, %4)

stock MFR_ChatBubble(playerid, color, Float:drawdistance, expiretime, const langkey[], va_args<>)
{
	va_format(gs_szKimenet, sizeof(gs_szKimenet), LANG(playerid, langkey), va_start<5>);
	return SetPlayerChatBubble_(playerid, gs_szKimenet, color, drawdistance, expiretime);
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a, Float:z;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return 1;
}

// Vehicle damage status encoders (see SA-MP wiki, vehicle damage bitfields)
stock encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper)
	return flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);

stock encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door = 0, behind_passenger_door = 0)
{
	#pragma unused behind_driver_door, behind_passenger_door
	return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}

stock encode_lights(front_left_light, front_right_light, back_lights, unused = 0)
{
	#pragma unused unused
	return front_left_light | (front_right_light << 2) | (back_lights << 6);
}

stock encode_tires(rear_right_tire, front_right_tire, rear_left_tire, front_left_tire)
	return rear_right_tire | (front_right_tire << 1) | (rear_left_tire << 2) | (front_left_tire << 3);

// Weapon id -> weaponshots statistics slot (14 categories)
stock GetWeaponShotSQLIdFromWeaponid(weaponid)
{
	switch(weaponid)
	{
		case 22: return 0;       // Colt45
		case 23: return 1;       // Silenced
		case 24: return 2;       // Deagle
		case 25: return 3;       // Shotgun
		case 26: return 4;       // Sawnoff
		case 27: return 5;       // Combat shotgun
		case 28: return 6;       // Uzi
		case 29: return 7;       // MP5
		case 30: return 8;       // AK47
		case 31: return 9;       // M4
		case 32: return 10;      // Tec9
		case 33: return 11;      // Country rifle
		case 34: return 12;      // Sniper
		case 38: return 13;      // Minigun
	}
	return 13;
}

// Strip {RRGGBB} color codes from a string (in place)
stock RemoveHexColorFromString(str[])
{
	new i = 0;
	while(str[i] != EOS)
	{
		if(str[i] == '{' && str[i + 7] == '}')
		{
			new ok = 1;
			for(new j = 1; j <= 6; j++)
			{
				new c = str[i + j];
				if(!(('0' <= c <= '9') || ('a' <= c <= 'f') || ('A' <= c <= 'F'))) { ok = 0; break; }
			}
			if(ok) { strdel(str, i, i + 8); continue; }
		}
		i++;
	}
	return 1;
}

// Object model bounds (basic validity check for anticheat purposes)
stock IsValidObjectModel(modelid)
	return (321 <= modelid <= 19999);

// Pass text through, keeping color tags (original transformed custom color
// markup; identity keeps behaviour neutral). Returns a copy of the input.
stock ColouredText(const str[])
{
	static out[512];
	out[0] = EOS;
	strcat(out, str, sizeof(out));
	return out;
}

// Strip color tags in place
stock FilterColorTags(str[])
	return RemoveHexColorFromString(str);

stock CreateZoneSquare(Float:x, Float:y, Float:size)
	return GangZoneCreate(x - size, y - size, x + size, y + size);

stock CreatePlayerZoneSquare(playerid, Float:x, Float:y, Float:size)
{
	#pragma unused playerid
	return GangZoneCreate(x - size, y - size, x + size, y + size);
}

stock IsValidWeapon(weaponid)
	return (0 < weaponid <= 46 && weaponid != 19 && weaponid != 20 && weaponid != 21);

stock IsValidSkin(skinid)
	return (0 <= skinid <= 311 && skinid != 74);

// Raw (non-localized) formatted broadcast
stock SendClientMessageToAllf_(color, const fmt[], va_args<>)
{
	va_format(gs_szKimenet, sizeof(gs_szKimenet), fmt, va_start<2>);
	return SendClientMessageToAll(color, gs_szKimenet);
}

stock SendClientMessageToAll_(color, const msg[])
	return SendClientMessageToAll(color, msg);

// Textdraw-safe text: tilde sequences crash clients in textdraws
stock IsSafeForTextdraw(const str[])
{
	for(new i = 0; str[i] != EOS; i++)
		if(str[i] == '~') return 0;
	return 1;
}

// Older YSF exposed this; current builds dropped it - keep as no-op
stock TogglePlayerInServerQuery(playerid, toggle)
{
	#pragma unused playerid, toggle
	return 1;
}

// Original mapped an interior-type id to a shop name; mapping lost - no-op.
stock SetPlayerShopNameEx(playerid, shoptype)
{
	#pragma unused playerid, shoptype
	return 1;
}

stock IsValidIcon(iconid)
	return (0 <= iconid <= 63);

stock Float:floatrandom(Float:max)
	return (float(random(10000)) / 10000.0) * max;

stock IsValidHex(const str[])
{
	if(!str[0]) return 0;
	for(new i = 0; str[i] != EOS; i++)
	{
		new c = str[i];
		if(i == 1 && (c == 'x' || c == 'X') && str[0] == '0') continue;
		if(!(('0' <= c <= '9') || ('a' <= c <= 'f') || ('A' <= c <= 'F'))) return 0;
	}
	return 1;
}

stock StripNewLine(str[])
{
	new len = strlen(str);
	while(len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r'))
		str[--len] = EOS;
	return 1;
}

// Called at init: the original created the server's static vehicle fleet here.
// The spawn list was lost - recreate/spawn vehicles as they are recovered.
stock NMSS_vehicles()
	return 1;

stock ReloadAttachedObjects(playerid)
{
	for(new slot = 0; slot < MAX_PLAYER_ATTACHED_OBJECTS; slot++)
	{
		if(!gAOModel[playerid][slot]) continue;
		SetPlayerAttachedObject(playerid, slot, gAOModel[playerid][slot], gAOBone[playerid][slot],
			gAOOffSet_X[playerid][slot], gAOOffSet_Y[playerid][slot], gAOOffSet_Z[playerid][slot],
			gAORot_X[playerid][slot], gAORot_Y[playerid][slot], gAORot_Z[playerid][slot],
			gAOScale_X[playerid][slot], gAOScale_Y[playerid][slot], gAOScale_Z[playerid][slot],
			gAOColor1[playerid][slot], gAOColor2[playerid][slot]);
	}
	return 1;
}

stock CountSetBits(value)
{
	new count = 0;
	while(value) { value &= value - 1; count++; }
	return count;
}

// Approximate textdraw string pixel width (for right-aligned positioning)
stock Float:CheckTextdrawStringLen(const str[])
	return float(strlen(str)) * 3.0;

// Is the player aiming (uses camera mode; 7 = aiming weapon, 46/53 = scoped)
stock IsPlayerAimingEx(playerid)
{
	new mode = GetPlayerCameraMode(playerid);
	return (mode == 7 || mode == 8 || mode == 46 || mode == 51 || mode == 53);
}

stock PlaySoundForPlayersInRange(soundid, Float:range, Float:x, Float:y, Float:z)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;
		if(IsPlayerInRangeOfPoint(i, range, x, y, z))
			PlayerPlaySound(i, soundid, x, y, z);
	}
	return 1;
}
