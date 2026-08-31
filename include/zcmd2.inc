/*
 * zcmd2.inc — reconstruction of the lost MFR command include.
 *
 * Based on zcmd 0.3.1 (ZeeX), extended the way the gamemode expects:
 *
 *   CMD:name(playerid, params[], <admin level>, <blocked-activity bits>)
 *
 * - 3rd arg:   minimum admin level (PVar "Level"; RCON admins always pass)
 * - 4th arg:   e_GamesData bitmask (see D:<...> in the gamemode); the
 *              command is refused while the player is in one of those
 *              activities. 0 = always allowed.
 *
 * Callbacks used by the gamemode (called by the dispatcher below):
 *   OnPlayerCommandReceived(playerid, cmdtext[])            - 0 blocks
 *   OnPlayerCommandPerformed(playerid, cmdtext[], success)
 */
#if defined _zcmd2_included
	#endinput
#endif
#define _zcmd2_included

#define MAX_COMMAND_NAME (32)

forward OnPlayerCommandReceived(playerid, cmdtext[]);
forward OnPlayerCommandPerformed(playerid, cmdtext[], success);

stock ZCMD2_Gate(playerid, level, flags, current)
{
	if(level > 0 && GetPVarInt(playerid, "Level") < level && !IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, 0xFF0000AA, "Nincs jogosults�god ehhez a parancshoz!");
		return 0;
	}
	if(flags && (flags & current))
	{
		SendClientMessage(playerid, 0xFF0000AA, "Ezt a parancsot jelenleg nem haszn�lhatod!");
		return 0;
	}
	return 1;
}

// CMD:name(playerid, params[], level, flags) { ... }
#define CMD:%0(%1,%2[],%3,%4) \
	forward cmd_%0(%1, %2[]); \
	public cmd_%0(%1, %2[]) return ZCMD2_Gate(%1, (%3), _:(%4), _:g_pGamesData[%1]) ? ZC2_%0(%1, %2) : 1; \
	stock ZC2_%0(%1, %2[])

#define COMMAND:%0(%1) CMD:%0(%1)

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!CallLocalFunction("OnPlayerCommandReceived", "is", playerid, cmdtext))
		return 1;

	new
		pos = 0,
		funcname[MAX_COMMAND_NAME + 4] = "cmd_",
		i = 4;
	while(cmdtext[++pos] > ' ')
	{
		if(i < MAX_COMMAND_NAME + 3)
			funcname[i++] = tolower(cmdtext[pos]);
	}
	funcname[i] = EOS;

	new success = 0;
	if(funcidx(funcname) != -1)
	{
		while(cmdtext[pos] == ' ') pos++;
		if(!cmdtext[pos])
			success = CallLocalFunction(funcname, "is", playerid, "\1");
		else
			success = CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
	}
	return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, success);
}

#if !defined isnull
	#define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif
