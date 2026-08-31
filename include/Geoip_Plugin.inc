/*
 * Geoip_Plugin.inc — reconstruction for the lost GeoIP include.
 * The gamemode uses GetCountryName() and GetCityLongitude().
 *
 * Implemented as harmless fallbacks so the mode also runs WITHOUT the
 * original GeoIP plugin (country shows as unknown, GMT as 0xFF).
 * If you recover the real plugin, replace these stocks with its natives:
 *   native GetCountryName(const ip[], name[], len = sizeof(name));
 *   native GetCityLongitude(const ip[], &Float:longitude);
 */
#if defined _geoip_included
	#endinput
#endif
#define _geoip_included

stock GetCountryName(const ip[], name[], len = sizeof(name))
{
	#pragma unused ip
	name[0] = EOS;
	strcat(name, "Unknown", len);
	return 0; // 0 = lookup failed -> gamemode falls back to "N/A"
}

stock GetCityLongitude(const ip[], &Float:longitude)
{
	#pragma unused ip
	longitude = 0.0;
	return 0; // 0 = lookup failed -> gamemode stores GMT 0xFF
}
