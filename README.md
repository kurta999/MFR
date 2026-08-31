# MFR — MaXXiMuM FreeRoam

**[HuN] .:: MaXXiMuM FreeRoam ::. [EnG]** — a once-popular Hungarian SA-MP (San Andreas Multiplayer) gamemode. Stunt · DM · Drift · Fallout · PK freeroam server, written in Pawn.

- **Version:** 4.1 (last update: 2016-11-13)
- **Website (historical):** www.mfrserver.net
- **Source:** a single monolithic script — `nmss.pwn` (~67,000 lines, ~1,135 commands, ~840 functions)
- **Languages:** Hungarian and English (built-in per-player language system, `/lang`)

> ⚠️ **This gamemode is discontinued.** The original MySQL schema and several include/source files were lost, but they have since been reconstructed: the code **compiles again** (see [BUILDING.md](BUILDING.md)) and a rebuilt schema is provided in [mfr_schema.sql](mfr_schema.sql). It is shared for nostalgia and as a reference; maybe somebody will benefit from it.

## Features

### Accounts & progression
- MySQL-backed registration/login (`a_mysql`), password change, auto-login by IP/serial
- XP and level system (`szintek` table) with per-level rewards
- Player statistics: kills, deaths, shots, FPS/ping averages, command usage, playtime
- Name-change system with name history tracking
- SMF forum integration — in-game forum registration and account linking (`smf_members`)
- VIP system (VIP colors, VIP chat text, VIP island, donation support)
- Saved spawn places, saved positions, per-player settings (HUD, nametags, speedo, chat colors, key bindings, walk styles…)

### Minigames & PvP
- **Race system** with a full in-game race editor (`/buildrace`, `/editrace`, checkpoint recording, saving/loading races from MySQL)
- **Derby** mode with loadable derby maps and multiple derby modes
- **Fallout** minigame (collapsing platform arena) — one of the server's signature modes
- **CTC** (round-based team flag/capture minigame) and flag mechanics (`/flag`, `/dropflag`)
- **Custom DM zones** — admins can create/save deathmatch arenas (`custom_dm` table), TDM support, per-DM kill stats
- **Duels** with selectable locations and duel statistics
- **Gangwar / clan zone wars** — capturable map zones with team colors, icons, attack/defend logic
- Bounty system, killstreaks, stunt bonuses
- Shooting range, weapon skill settings, instagib mode
- Small games: lottery, reaction test, math test, teleport test, gold pot treasure hunts, hidden collectibles (horseshoes, oysters, photo-ops, Easter egg / "aranytojás")
- Jail/prison system with jail time and admin jail commands

### Economy & property
- **Houses** — buyable/buildable houses with types, prices, interiors, furniture editor ("bútorok"), house cars, house income, locks, alarms and a house-robbery ("ház feltörés") minigame with hack-detector alarm
- **Businesses** ("biznis") — buyable businesses with types, income, interiors, icons, locks
- **Properties** — additional ownable properties with locks and owner data
- Bank: deposit/withdraw/balance, clan bank with transaction logs
- Payday, cash transfers (`/givecash` with logging), weapon shop, PC/element purchases

### Clans
- Full clan system: creation with activation flow, ranks, member management, clan chat
- Clan bank + bank log, clan color, clan spawn/home/HQ zones, clan checkpoints
- Clan zones on the map, clan wars, clan logs

### Vehicles
- Car spawner dialogs, personal bonus car, spawn saved cars
- **Tuning garage** — components, paintjobs, colors, wheels saved to MySQL (`vehicle_components`)
- Neon, nitro (with nitro state config), hydraulics, speed boost, autofix, flip, tow, lock
- Attachable vehicle objects (saved per player: `holdingobjects_v` / `_vset`), vehicle recording/playback
- Vehicle health/damage tracking system, drift/stunt support, plane NPC (Shamal pilot)

### Jobs & roleplay-lite
- Taxi job, pizza delivery, postman ("postás") job, medic/heal, drug dealer ("deal"), arrest/cop mechanics
- Hundreds of animations (`/anims`, dances, actions), attachable player objects/clothes (`holdingobjects` / `_set`)

### World & fun
- Teleport system with MySQL-stored teleports (`/teles`), interiors menu
- Vice City map area, custom mapped areas, working elevators, Ferris wheel, carousel ("körhinta")
- Streamed music/radio: MySQL music list, per-player streams, radio dialog
- 3D text labels (personal and admin-placed), textdraw systems, map icons, gates
- Weather/time controls, gravity, ghost mode, noclip/freecam for admins

### Administration & security
- 5 admin levels (Level 1–4 + RCON) with per-command level requirements
- Ban system: name/IP/serial (GPCI) bans, temp bans, ban lists, unban, kick logs
- Admin logging to MySQL (`adminlog`, `commands`, `connections`, `faillogins`), admin chat, reports (bugs/ideas/complaints), PM logging
- Spectate, goto/gethere, freeze, mute, warn, disarm, sobriety, and dozens of moderation tools
- Anti-cheat: hack detector, anti-sobeit, RakSAMP fake-client detection, weapon/health checks, anti-deAMX, crashdetect integration
- GeoIP country lookup, NPC bots, in-game FilterScript loading, live SQL console commands (`/sql`, `/sqlstat`)

## Tech stack / dependencies

Compiles with the SA-MP Pawn compiler against:

`a_samp`, `a_mysql`, `a_zones`, `streamer`, `sscanf2`, YSI (`foreach_new`, `y_va`, `y_scripting`, `y_bit`), `zcmd2`, `gvar`, `sniperfix`, `Geoip_Plugin`, `mapandreas`, `crashdetect`, `YSF`, `mSelection`

Server plugins required: MySQL, streamer, sscanf, YSF, mapandreas, crashdetect, gvar, GeoIP, mSelection.

## Recovery status

- ✅ **MySQL schema** — reconstructed from the ~700 queries in the code as [mfr_schema.sql](mfr_schema.sql) (69 tables, positional column layouts preserved for the old `cache_get_row_*` API, verified against a live MariaDB).
- ✅ **Build** — the mode **compiles** with the community Pawn compiler 3.10.10: run `./build.sh` (see [BUILDING.md](BUILDING.md)). The include pack (2016-era-compatible versions of MySQL R33, streamer, sscanf2, YSF, foreach, a_zones, mSelection…) is bundled in `include/`, and the lost files (`NMSS_config.pwn`, `NMSS_vehicles.pwn`, `zcmd2`, minimal YSI shims, `Geoip_Plugin`, `sniperfix`) were reconstructed from how the code uses them.
- ⚠️ **Not yet done** — runtime testing with the actual server + plugins; seed data for `teleports`/`szintek`/`vehicle_components` etc.; the lost static vehicle fleet and a few placeholder tables (vehicle prices, petrol-cap offsets, mod compatibility) noted in BUILDING.md; assorted filterscripts and `scriptfiles/NMSS/` data files referenced by the mode.

## License

See [LICENSE](LICENSE).
