/*
 * y_scripting.inc — reconstructed minimal replacement for YSI's y_scripting.
 * Provides AMX introspection used by the gamemode's /cmdlist generator:
 *   Scripting_GetPublicsCount(), Scripting_GetNativesCount(),
 *   Scripting_GetPublic(index, buffer[], prefix[])
 */
#if defined _inc_y_scripting_shim
	#endinput
#endif
#define _inc_y_scripting_shim

static stock AMX_Base()
{
	new ret;
	#emit ZERO.pri
	#emit LCTRL 1
	#emit NEG
	#emit STOR.S.pri ret
	return ret;
}

static stock AMX_Read(addr)
{
	new v;
	#emit LOAD.S.pri addr
	#emit LOAD.I
	#emit STOR.S.pri v
	return v;
}

static stock AMX_ReadChar(addr)
	return (AMX_Read(addr & ~0x03) >>> ((addr & 0x03) * 8)) & 0xFF;

static stock AMX_DefSize()
	return (AMX_Read(AMX_Base() + 8) >>> 16) & 0xFFFF;

stock Scripting_GetPublicsCount()
{
	new base = AMX_Base();
	return (AMX_Read(base + 36) - AMX_Read(base + 32)) / AMX_DefSize();
}

stock Scripting_GetNativesCount()
{
	new base = AMX_Base();
	return (AMX_Read(base + 40) - AMX_Read(base + 36)) / AMX_DefSize();
}

// Copy the name of the index-th public that starts with `prefix` into buffer.
// Returns 1 on success, 0 when there is no such public any more.
stock Scripting_GetPublic(index, buffer[], const prefix[] = "", size = sizeof(buffer))
{
	new base = AMX_Base(),
	    defsize = AMX_DefSize(),
	    publics = AMX_Read(base + 32),
	    count = Scripting_GetPublicsCount(),
	    plen = strlen(prefix),
	    found = 0;

	for(new i = 0; i < count; i++)
	{
		new nameofs = AMX_Read(base + publics + i * defsize + 4),
		    addr = base + nameofs,
		    j = 0,
		    match = 1;

		for(j = 0; j < plen; j++)
		{
			if(AMX_ReadChar(addr + j) != prefix[j]) { match = 0; break; }
		}
		if(!match) continue;

		if(found == index)
		{
			new c;
			for(j = 0; j < size - 1; j++)
			{
				c = AMX_ReadChar(addr + j);
				if(!c) break;
				buffer[j] = c;
			}
			buffer[j] = EOS;
			return 1;
		}
		found++;
	}
	return 0;
}
