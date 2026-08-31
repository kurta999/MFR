# Building MFR

The gamemode compiles again. `./build.sh` (Linux) or `pawncc nmss.pwn -iinclude "-;+" "-(+" -d0` (Windows, [pawncc 3.10.10](https://github.com/pawn-lang/compiler/releases)) produces `nmss.amx` (~6.6 MB, ~4900 warnings, 0 errors).

The `-;+` flag (require semicolons) is **mandatory** — the code contains constructs like a `return` split across two lines that mis-parse without it.

## What was pulled from the internet

| Include | Source / version |
|---|---|
| a_samp & friends | [pawn-lang/samp-stdlib](https://github.com/pawn-lang/samp-stdlib) (0.3.7-R2) |
| core/float/string/... | [pawn-lang/pawn-stdlib](https://github.com/pawn-lang/pawn-stdlib) |
| a_mysql | [pBlueG/SA-MP-MySQL](https://github.com/pBlueG/SA-MP-MySQL) tag **R33** (`mysql_function_query` era) |
| streamer | [samp-incognito/samp-streamer-plugin](https://github.com/samp-incognito/samp-streamer-plugin) master |
| sscanf2 | [Y-Less/sscanf](https://github.com/Y-Less/sscanf) 2.15.1 |
| YSF | [kurta999/YSF](https://github.com/kurta999/YSF) master |
| foreach | standalone foreach.inc (Y-Less; karimcambridge mirror) |
| a_zones | Cueball/Betamaster/Mabako zones include |
| mSelection | D0erfler 2013 (omcho420 mirror) |

## What had to be reconstructed (lost files)

* **`NMSS_config.pwn`** — credentials template + ~50 utility functions/globals the
  gamemode expects (`KickEx`, `mktime`/`date`, `FormatNumber`, `GivePlayerMoneyEx`
  money tracking, `IPCheck` was found in nmss.pwn itself, attached-object state,
  key macros, etc.). **Fill in the MySQL credentials at the top.**
* **`NMSS_vehicles.pwn`** — originally "UVS", a vehicle streamer. Rebuilt as a thin
  1:1 wrapper of the `…DynamicVehicle…` API onto stock SA-MP vehicle natives
  (no streaming, 2000-vehicle limit; `UVS` deliberately left undefined so the
  gamemode uses its standard-callback branches). The static vehicle fleet the
  file also contained is lost — `NMSS_vehicles()` is an empty hook to refill.
* **`include/zcmd2.inc`** — zcmd extended with the 4-argument
  `CMD:name(playerid, params[], <admin level>, <D:<blocked activities>>)` form.
* **`include/YSI/*`** — minimal reimplementations of y_va (`va_format`), y_bit
  (`BitArray`/`Bit_*`), y_scripting (AMX public-table introspection for
  `/cmdlist`) and a `foreach_new` shim with the `Itter_*` aliases.
* **`include/gvar.inc`, `mapandreas.inc`, `crashdetect.inc`** — native
  declarations matching the classic plugins.
* **`include/Geoip_Plugin.inc`** — fallback stubs (country = "Unknown"); swap in
  the real plugin natives if you find it.
* **`include/sniperfix.inc`** — empty placeholder.

## Small source patches applied to nmss.pwn

* Four duplicate `Ide:` goto labels inside `OnDialogResponse` renamed
  (`Ide_a`…`Ide_d`) — the modern compiler rejects duplicate labels per function.

Patches applied to bundled includes (documented in-file): two forwarded
callbacks' parameter names aligned (`OnRconLoginAttempt`, `OnQueryError`) —
pawncc 3.10.10 *segfaults* when a public renames a forwarded array parameter —
plus an MFR compatibility layer appended to `a_mysql.inc`
(by-ref `cache_get_row_int/float` + `*_ex` forms) and `gSAZones` made global
in `a_zones.inc`.

## Known placeholder behaviour (refine when data is recovered)

* Vehicle price table (`GetVehiclePrice`), shop-name mapping
  (`SetPlayerShopNameEx`), petrol-cap offsets (feature disabled via zeros),
  mod-compatibility table (permissive), banned-word list #2, GeoIP lookups.
* `TogglePlayerInServerQuery` is a no-op (dropped from current YSF).

## Running it

1. SA-MP 0.3.7 server + plugins: **mysql (R33)**, **streamer**, **sscanf**,
   **YSF**, **gvar**, **mapandreas**, **crashdetect** (Windows `.dll` builds of
   that era are the safest match).
2. Create the database from `mfr_schema.sql`, set credentials in
   `NMSS_config.pwn`, rebuild.
3. The mode reads `scriptfiles/NMSS/` (cmdlist.txt, sql.txt, language files)
   and expects seed data (teleports, szintek, …) — see the schema's
   post-install notes. Runtime testing has not been done yet; expect follow-up
   fixes there.
