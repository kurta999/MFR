/*
 * y_bit.inc — reconstructed minimal replacement for YSI's y_bit,
 * covering what the MFR gamemode uses:
 *   BitArray:name<size>;  BitArray:name[dim]<size>;
 *   Bit_Set(arr, slot, bool), Bit_Get(arr, slot), Bit_Let(arr, slot),
 *   Bit_Vet(arr, slot), Bit_SetAll(arr | arr[slice], bool), Bit_GetCount(...)
 */
#if defined _inc_y_bit_shim
	#endinput
#endif
#define _inc_y_bit_shim

#define Y_BIT_CELLS(%0) (((%0) + 31) / 32)

// %0 greedily captures "name" or "name[dim]", %1 is the bit count.
#define BitArray:%0<%1> Bit:%0[Y_BIT_CELLS(%1)]

stock Bit_Set(Bit:arr[], slot, bool:set)
{
	if(set) arr[slot >>> 5] |= Bit:(1 << (slot & 31));
	else arr[slot >>> 5] &= Bit:(~(1 << (slot & 31)));
	return 1;
}

stock Bit_Get(const Bit:arr[], slot)
	return (_:arr[slot >>> 5] >>> (slot & 31)) & 1;

stock Bit_Let(Bit:arr[], slot)
	return _:(arr[slot >>> 5] |= Bit:(1 << (slot & 31)));

stock Bit_Vet(Bit:arr[], slot)
	return _:(arr[slot >>> 5] &= Bit:(~(1 << (slot & 31))));

stock Bit_SetAll_(Bit:arr[], bool:set, size = sizeof(arr))
{
	new v = set ? -1 : 0;
	for(new c = 0; c < size; c++) arr[c] = Bit:v;
	return 1;
}

stock Bit_GetCount_(const Bit:arr[], size = sizeof(arr))
{
	new count = 0;
	for(new c = 0; c < size; c++)
	{
		new v = _:arr[c];
		while(v) { v &= v - 1; count++; }
	}
	return count;
}

// Bare-array wrappers — defined BEFORE the slice macros below so the macro
// pattern cannot mangle these declarations.
stock Bit_SetAll(Bit:arr[], bool:set, size = sizeof(arr))
	return Bit_SetAll_(arr, set, size);

stock Bit_GetCount(const Bit:arr[], size = sizeof(arr))
	return Bit_GetCount_(arr, size);

// Slice forms: Bit_SetAll(arr[i], v) needs the minor-dimension size passed
// explicitly; bare-array calls don't match these patterns and fall through
// to the wrapper functions above.
#define Bit_SetAll(%0[%1],%2) Bit_SetAll_(%0[%1], %2, sizeof(%0[]))
#define Bit_GetCount(%0[%1]) Bit_GetCount_(%0[%1], sizeof(%0[]))
