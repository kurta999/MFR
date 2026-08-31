/*
 * y_va.inc — reconstructed minimal replacement for YSI's y_va,
 * covering exactly what the MFR gamemode uses:
 *
 *   stock Func(playerid, format[], va_args<>)
 *   {
 *       va_format(dest, sizeof(dest), format, va_start<2>);
 *   }
 *
 * va_start<N> = 0-based index of the first variadic parameter.
 * Implementation is the classic va trick (as in Slice's va.inc / y_va):
 * re-push the variadic argument addresses and SYSREQ format().
 */
#if defined _inc_y_va_shim
	#endinput
#endif
#define _inc_y_va_shim

#define va_args<> ...
#define va_start<%0> (%0)

stock va_format(output[], len, const format[], va_firstarg)
{
	new arg = numargs(),
	    args = (arg - va_firstarg) * 4;

	while(--arg >= va_firstarg)
	{
		// push the value of argument cell <arg> (= address of the passed var)
		#emit LCTRL       5
		#emit LOAD.S.alt  arg
		#emit SHL.C.alt   2
		#emit ADD
		#emit ADD.C       12
		#emit LOAD.I
		#emit PUSH.pri
	}
	#emit PUSH.S      format
	#emit PUSH.S      len
	#emit PUSH.S      output
	#emit LOAD.S.pri  args
	#emit ADD.C       12
	#emit PUSH.pri
	#emit SYSREQ.C    format
	// pop everything we pushed (args + format + len + output + bytecount)
	#emit LOAD.S.pri  args
	#emit ADD.C       16
	#emit LCTRL       4
	#emit ADD
	#emit SCTRL       4
	return 1;
}

// Shared formatted-output buffer used by the gamemode's va_format() helpers.
new gs_szKimenet[1024];
