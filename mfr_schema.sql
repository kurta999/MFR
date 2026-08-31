-- ============================================================================
--  MFR (MaXXiMuM FreeRoam) v4.1 — reconstructed MySQL schema
-- ============================================================================
--  Reverse-engineered from nmss.pwn (2016.11.13 build). The original .sql
--  files are lost; every table, column, order and default below was inferred
--  from the queries and cache_get_row_*() calls in the gamemode.
--
--  IMPORTANT — COLUMN ORDER MATTERS:
--  The old BlueG MySQL plugin API used positional result access
--  (cache_get_row_int(row, INDEX, ...)), so the gamemode reads columns by
--  their POSITION for every "SELECT *" query. Do not reorder, insert or drop
--  columns in: players, houses, biznis, clans, racedata, custom_dm, config,
--  savepositions, teleports, bans, bans_serial, radio, musiclist, szintek,
--  holdingobjects*, cameras, clans_log — or loading will silently corrupt.
--
--  Columns marked "unused filler" are positions the surviving code never
--  reads/writes by name; they only exist to keep the positional layout.
--
--  Target: MySQL 5.5+ / MariaDB. Charset utf8 (the 2016 server predates
--  utf8mb4 use; the code relies on `pass COLLATE utf8_bin` comparisons).
-- ============================================================================

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- CREATE DATABASE IF NOT EXISTS `mfr` DEFAULT CHARACTER SET utf8;
-- USE `mfr`;

-- ============================================================================
-- CORE: players  (positional layout, indexes 0..126 — see LoginPlayer)
-- ============================================================================
DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `reg_id`           int(11)      NOT NULL AUTO_INCREMENT,            -- 0
  `name`             varchar(24)  NOT NULL DEFAULT '',                -- 1
  `forumid`          int(11)      NOT NULL DEFAULT 0,                 -- 2  SMF id_member (0 = not linked)
  `pass`             varchar(129) NOT NULL DEFAULT '',                -- 3  compared with COLLATE utf8_bin
  `ip`               varchar(16)  NOT NULL DEFAULT '',                -- 4
  `reg_date`         int(11)      NOT NULL DEFAULT 0,                 -- 5  unix timestamp
  `laston`           int(11)      NOT NULL DEFAULT 0,                 -- 6  unix timestamp
  `level`            int(11)      NOT NULL DEFAULT 0,                 -- 7  admin level 0..4
  `money`            int(11)      NOT NULL DEFAULT 0,                 -- 8
  `bank`             int(11)      NOT NULL DEFAULT 0,                 -- 9
  `kills`            int(11)      NOT NULL DEFAULT 0,                 -- 10
  `deaths`           int(11)      NOT NULL DEFAULT 0,                 -- 11
  `killstreak`       int(11)      NOT NULL DEFAULT 0,                 -- 12 best killstreak
  `score`            int(11)      NOT NULL DEFAULT 0,                 -- 13
  `fightingstyle`    int(11)      NOT NULL DEFAULT 4,                 -- 14
  `reactionwins`     int(11)      NOT NULL DEFAULT 0,                 -- 15
  `goldpots`         int(11)      NOT NULL DEFAULT 0,                 -- 16
  `o_time`           int(11)      NOT NULL DEFAULT 0,                 -- 17 online time (seconds)
  `posts`            int(11)      NOT NULL DEFAULT 0,                 -- 18 chat messages
  `hq`               int(11)      NOT NULL DEFAULT 0,                 -- 19 gang HQ id (0 = none)
  `warns`            int(11)      NOT NULL DEFAULT 0,                 -- 20
  `races`            int(11)      NOT NULL DEFAULT 0,                 -- 21 races won
  `rablasok`         int(11)      NOT NULL DEFAULT 0,                 -- 22 robberies
  `rangeshots`       int(11)      NOT NULL DEFAULT 0,                 -- 23 shooting range wins
  `nitrostate`       int(11)      NOT NULL DEFAULT 0,                 -- 24
  `laser`            int(11)      NOT NULL DEFAULT 0,                 -- 25 laser sight on/off
  `lastrabolt`       int(11)      NOT NULL DEFAULT 0,                 -- 26 last robbery timestamp
  `idcolor`          int(11)      NOT NULL DEFAULT 0,                 -- 27
  `flagtime`         int(11)      NOT NULL DEFAULT 0,                 -- 28 flag hold time
  `bcartime`         int(11)      NOT NULL DEFAULT 0,                 -- 29 bonus-car hold time
  `fuvarok`          int(11)      NOT NULL DEFAULT 0,                 -- 30 taxi fares
  `stuntbonus`       int(11)      NOT NULL DEFAULT 0,                 -- 31
  `fallout`          int(11)      NOT NULL DEFAULT 0,                 -- 32 fallout wins
  `mutetime`         int(11)      NOT NULL DEFAULT 0,                 -- 33
  `freezetime`       int(11)      NOT NULL DEFAULT 0,                 -- 34
  `x`                float        NOT NULL DEFAULT 0,                 -- 35 saved position
  `y`                float        NOT NULL DEFAULT 0,                 -- 36
  `z`                float        NOT NULL DEFAULT 0,                 -- 37
  `interior`         int(11)      NOT NULL DEFAULT 0,                 -- 38
  `world`            int(11)      NOT NULL DEFAULT 0,                 -- 39
  `angle`            float        NOT NULL DEFAULT 0,                 -- 40
  `deathx`           float        NOT NULL DEFAULT 0,                 -- 41
  `deathy`           float        NOT NULL DEFAULT 0,                 -- 42
  `deathz`           float        NOT NULL DEFAULT 0,                 -- 43
  `deatha`           float        NOT NULL DEFAULT 0,                 -- 44
  `deathint`         int(11)      NOT NULL DEFAULT 0,                 -- 45
  `deathworld`       int(11)      NOT NULL DEFAULT 0,                 -- 46
  `hydtype`          int(11)      NOT NULL DEFAULT 0,                 -- 47 hydraulics type 0..2
  `spin_x`           float        NOT NULL DEFAULT 0,                 -- 48
  `spin_y`           float        NOT NULL DEFAULT 0,                 -- 49
  `spin_z`           float        NOT NULL DEFAULT 0,                 -- 50
  `szint`            int(11)      NOT NULL DEFAULT 0,                 -- 51 player level (XP rank)
  `xp`               int(11)      NOT NULL DEFAULT 0,                 -- 52
  `chatcolor`        int(11)      NOT NULL DEFAULT 0,                 -- 53
  `walkstyle`        int(11)      NOT NULL DEFAULT 0,                 -- 54
  `jailtime`         int(11)      NOT NULL DEFAULT 0,                 -- 55
  `favcarradio`      int(11)      NOT NULL DEFAULT 0,                 -- 56
  `autorepair`       int(11)      NOT NULL DEFAULT 0,                 -- 57 0..3
  `afktime`          int(11)      NOT NULL DEFAULT 0,                 -- 58
  `gangwar_team`     int(11)      NOT NULL DEFAULT 15,                -- 59
  `vehicleboost`     float        NOT NULL DEFAULT 0,                 -- 60
  `vehiclehopping`   float        NOT NULL DEFAULT 0,                 -- 61
  `speedboost_key`   int(11)      NOT NULL DEFAULT 1,                 -- 62 KEY_ bitmasks
  `vehiclejump_key`  int(11)      NOT NULL DEFAULT 2,                 -- 63
  `flip_key`         int(11)      NOT NULL DEFAULT 8192,              -- 64
  `maths`            int(11)      NOT NULL DEFAULT 0,                 -- 65 math test wins
  `teles`            int(11)      NOT NULL DEFAULT 0,                 -- 66 teleport test wins
  `weather`          int(11)      NOT NULL DEFAULT 255,               -- 67 255 = server default
  `time`             int(11)      NOT NULL DEFAULT -1,                -- 68 personal time (-1 = server)
  `carcolor`         int(11)      NOT NULL DEFAULT -1,                -- 69
  `carcolor_2`       int(11)      NOT NULL DEFAULT -1,                -- 70
  `paintjob`         int(11)      NOT NULL DEFAULT 4,                 -- 71 4 = none
  `wheel`            int(11)      NOT NULL DEFAULT -1,                -- 72 favourite wheel mod
  `spawnlocation`    varchar(24)  NOT NULL DEFAULT '',                -- 73
  `favskin`          int(11)      NOT NULL DEFAULT -1,                -- 74
  `armedweapon`      int(11)      NOT NULL DEFAULT 0,                 -- 75
  `color`            int(11)      NOT NULL DEFAULT 0,                 -- 76
  `bounty`           int(11)      NOT NULL DEFAULT 0,                 -- 77
  `tdflags`          int(11)      NOT NULL DEFAULT 0,                 -- 78 textdraw flags
  `flags`            int(11)      NOT NULL DEFAULT 0,                 -- 79 e_PlayerFlags bits
  `weaponskill`      varchar(64)  NOT NULL DEFAULT '',                -- 80 11 csv ints
  `weapons`          varchar(64)  NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0', -- 81
  `ammo`             varchar(96)  NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0', -- 82
  `savedobjects`     varchar(128) NOT NULL DEFAULT '',                -- 83 10 csv ints
  `horseshoes`       varchar(160) NOT NULL DEFAULT '',                -- 84 50 csv ints
  `oysters`          varchar(160) NOT NULL DEFAULT '',                -- 85
  `photos`           varchar(160) NOT NULL DEFAULT '',                -- 86
  `clothes`          varchar(64)  NOT NULL DEFAULT '',                -- 87 8 csv ints
  `raktar`           varchar(128) NOT NULL DEFAULT '',                -- 88 house element storage, 30 csv ints
  `mytext`           varchar(180) NOT NULL DEFAULT '0,0.4,0,*',       -- 89 attached 3D text
  `jumps`            varchar(224) NOT NULL DEFAULT '',                -- 90 70 csv ints
  `tags`             varchar(320) NOT NULL DEFAULT '',                -- 91 100 csv ints
  `dminfo`           varchar(64)  NOT NULL DEFAULT '4,1,0,5,14,20,16,29,27,18,15', -- 92
  `serial`           varchar(64)  NOT NULL DEFAULT '',                -- 93 gpci
  `postas`           int(11)      NOT NULL DEFAULT 0,                 -- 94 postman jobs
  `pizzas`           int(11)      NOT NULL DEFAULT 0,                 -- 95
  `derby`            int(11)      NOT NULL DEFAULT 0,                 -- 96 derby wins
  `ctc_auto`         int(11)      NOT NULL DEFAULT 0,                 -- 97 CTC (car) wins
  `ctc_hajo`         int(11)      NOT NULL DEFAULT 0,                 -- 98 CTC (boat) wins
  `headshot_kill`    int(11)      NOT NULL DEFAULT 0,                 -- 99
  `headshot_death`   int(11)      NOT NULL DEFAULT 0,                 -- 100
  `unused_101`       int(11)      NOT NULL DEFAULT 0,                 -- 101 unused filler
  `carfly`           float        NOT NULL DEFAULT 0,                 -- 102 carfly speed value
  `lang`             int(11)      NOT NULL DEFAULT 0,                 -- 103 0 = HU, 1 = EN
  `pos_vy`           float        NOT NULL DEFAULT 0,                 -- 104 legacy, unused
  `flags2`           int(11)      NOT NULL DEFAULT 0,                 -- 105 e_PlayerFlags2 bits
  `longest_afk`      int(11)      NOT NULL DEFAULT 0,                 -- 106
  `weaponshots`      varchar(192) NOT NULL DEFAULT '',                -- 107 14 csv ints
  `minigame_joins`   varchar(128) NOT NULL DEFAULT '',                -- 108 10 csv ints
  `vip`              int(11)      NOT NULL DEFAULT 0,                 -- 109 VIP expiry timestamp (0 = none)
  `pos_0`            varchar(96)  NOT NULL DEFAULT '',                -- 110 saved pos: x,y,z,a,int,world,vx,vy,vz
  `pos_1`            varchar(96)  NOT NULL DEFAULT '',                -- 111
  `pos_2`            varchar(96)  NOT NULL DEFAULT '',                -- 112
  `pos_3`            varchar(96)  NOT NULL DEFAULT '',                -- 113
  `pos_4`            varchar(96)  NOT NULL DEFAULT '',                -- 114
  `pos_5`            varchar(96)  NOT NULL DEFAULT '',                -- 115
  `pos_6`            varchar(96)  NOT NULL DEFAULT '',                -- 116
  `pos_7`            varchar(96)  NOT NULL DEFAULT '',                -- 117
  `pos_8`            varchar(96)  NOT NULL DEFAULT '',                -- 118
  `pos_9`            varchar(96)  NOT NULL DEFAULT '',                -- 119
  `teleportmenu_key` int(11)      NOT NULL DEFAULT 65536,             -- 120
  `carfly_key`       int(11)      NOT NULL DEFAULT 4,                 -- 121
  `fly_key`          int(11)      NOT NULL DEFAULT 2,                 -- 122
  `vipcolor`         int(11)      NOT NULL DEFAULT 0,                 -- 123
  `taxi`             int(11)      NOT NULL DEFAULT 0,                 -- 124 taxi fares
  `chatflags`        int(11)      NOT NULL DEFAULT 0,                 -- 125 e_ChatMSG_Flags bits
  `km`               varchar(32)  NOT NULL DEFAULT '0.0',             -- 126 legacy "km driven", unused
  PRIMARY KEY (`reg_id`),
  KEY `name` (`name`),
  KEY `ip` (`ip`),
  KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- HOUSES  (positional 0..46 after the JOINed players.name — see THREAD_Houses)
-- ============================================================================
DROP TABLE IF EXISTS `houses`;
CREATE TABLE `houses` (
  `id`             int(11)      NOT NULL AUTO_INCREMENT,  -- 0
  `name`           varchar(64)  NOT NULL DEFAULT '',      -- 1  display name
  `default_name`   varchar(64)  NOT NULL DEFAULT '',      -- 2
  `prop_owner_id`  int(11)      NOT NULL DEFAULT -1,      -- 3  players.reg_id, -1 = for sale
  `prop_value`     int(11)      NOT NULL DEFAULT 0,       -- 4
  `prop_earning`   int(11)      NOT NULL DEFAULT 0,       -- 5
  `prop_locked`    varchar(32)  NOT NULL DEFAULT '*',     -- 6  '*' = unlocked, else password
  `rabolva`        int(11)      NOT NULL DEFAULT 0,       -- 7  times robbed
  `out_x`          float        NOT NULL DEFAULT 0,       -- 8
  `out_y`          float        NOT NULL DEFAULT 0,       -- 9
  `out_z`          float        NOT NULL DEFAULT 0,       -- 10
  `prop_angle`     float        NOT NULL DEFAULT 0,       -- 11
  `in_x`           float        NOT NULL DEFAULT 0,       -- 12
  `in_y`           float        NOT NULL DEFAULT 0,       -- 13
  `in_z`           float        NOT NULL DEFAULT 0,       -- 14
  `in_angle`       float        NOT NULL DEFAULT 0,       -- 15
  `interior`       int(11)      NOT NULL DEFAULT 0,       -- 16
  `virtualworld`   int(11)      NOT NULL DEFAULT 0,       -- 17
  `car_model`      int(11)      NOT NULL DEFAULT -1,      -- 18
  `car_x`          float        NOT NULL DEFAULT 0,       -- 19
  `car_y`          float        NOT NULL DEFAULT 0,       -- 20
  `car_z`          float        NOT NULL DEFAULT 0,       -- 21
  `car_a`          float        NOT NULL DEFAULT 0,       -- 22
  `car_color_1`    int(11)      NOT NULL DEFAULT -1,      -- 23
  `car_color_2`    int(11)      NOT NULL DEFAULT -1,      -- 24
  `paintjob`       int(11)      NOT NULL DEFAULT 4,       -- 25
  `comp_0`         int(11)      NOT NULL DEFAULT 0,       -- 26 house-car tuning components
  `comp_1`         int(11)      NOT NULL DEFAULT 0,
  `comp_2`         int(11)      NOT NULL DEFAULT 0,
  `comp_3`         int(11)      NOT NULL DEFAULT 0,
  `comp_4`         int(11)      NOT NULL DEFAULT 0,
  `comp_5`         int(11)      NOT NULL DEFAULT 0,
  `comp_6`         int(11)      NOT NULL DEFAULT 0,
  `comp_7`         int(11)      NOT NULL DEFAULT 0,
  `comp_8`         int(11)      NOT NULL DEFAULT 0,
  `comp_9`         int(11)      NOT NULL DEFAULT 0,
  `comp_10`        int(11)      NOT NULL DEFAULT 0,
  `comp_11`        int(11)      NOT NULL DEFAULT 0,
  `comp_12`        int(11)      NOT NULL DEFAULT 0,
  `comp_13`        int(11)      NOT NULL DEFAULT 0,       -- 39
  `bits`           int(11)      NOT NULL DEFAULT 0,       -- 40 e_HouseFlags bits
  `elementbits`    int(11)      NOT NULL DEFAULT 0,       -- 41 furniture/elements bits
  `riaszto`        int(11)      NOT NULL DEFAULT 0,       -- 42 alarm
  `outint`         int(11)      NOT NULL DEFAULT 0,       -- 43 outside interior id
  `vehicleobjects` varchar(128) NOT NULL DEFAULT '',      -- 44 attached vehicle-object set
  `hackdetector`   int(11)      NOT NULL DEFAULT 0,       -- 45
  `type`           int(11)      NOT NULL DEFAULT 0,       -- 46 house type/class
  PRIMARY KEY (`id`),
  KEY `prop_owner_id` (`prop_owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- BIZNIS (businesses)  (positional 0..23 after JOINed players.name)
-- ============================================================================
DROP TABLE IF EXISTS `biznis`;
CREATE TABLE `biznis` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,  -- 0
  `name`         varchar(64) NOT NULL DEFAULT '',      -- 1
  `owner_id`     int(11)     NOT NULL DEFAULT -1,      -- 2  players.reg_id, -1 = for sale
  `value`        int(11)     NOT NULL DEFAULT 0,       -- 3
  `earning`      int(11)     NOT NULL DEFAULT 0,       -- 4
  `enter_value`  int(11)     NOT NULL DEFAULT 0,       -- 5  entrance fee
  `locked`       varchar(32) NOT NULL DEFAULT '*',     -- 6
  `rabolva`      int(11)     NOT NULL DEFAULT 0,       -- 7
  `interiortype` int(11)     NOT NULL DEFAULT 0,       -- 8
  `mapicon`      int(11)     NOT NULL DEFAULT 0,       -- 9
  `b_mapicon`    int(11)     NOT NULL DEFAULT 0,       -- 10
  `out_x`        float       NOT NULL DEFAULT 0,       -- 11
  `out_y`        float       NOT NULL DEFAULT 0,       -- 12
  `out_z`        float       NOT NULL DEFAULT 0,       -- 13
  `biz_angle`    float       NOT NULL DEFAULT 0,       -- 14
  `in_x`         float       NOT NULL DEFAULT 0,       -- 15
  `in_y`         float       NOT NULL DEFAULT 0,       -- 16
  `in_z`         float       NOT NULL DEFAULT 0,       -- 17
  `in_angle`     float       NOT NULL DEFAULT 0,       -- 18
  `interior`     int(11)     NOT NULL DEFAULT 0,       -- 19
  `virtualworld` int(11)     NOT NULL DEFAULT 0,       -- 20
  `bits`         int(11)     NOT NULL DEFAULT 0,       -- 21 packed: entervalue|interior|inttype|icon|icondisabled
  `type`         varchar(32) NOT NULL DEFAULT '',      -- 22
  `balance`      int(11)     NOT NULL DEFAULT 0,       -- 23
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- CLANS  (positional 0..34, JOINed players.name comes after — THREAD_LoadClanInfo)
-- ============================================================================
DROP TABLE IF EXISTS `clans`;
CREATE TABLE `clans` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT,  -- 0
  `activated`  int(11)      NOT NULL DEFAULT 0,       -- 1
  `clanname`   varchar(32)  NOT NULL DEFAULT '',      -- 2
  `leiras`     varchar(128) NOT NULL DEFAULT '',      -- 3  description
  `color`      int(11)      NOT NULL DEFAULT 0,       -- 4
  `reg_id`     int(11)      NOT NULL DEFAULT 0,       -- 5  creator players.reg_id
  `spawnx`     float        NOT NULL DEFAULT 0,       -- 6
  `spawny`     float        NOT NULL DEFAULT 0,       -- 7
  `spawnz`     float        NOT NULL DEFAULT 0,       -- 8
  `spawna`     float        NOT NULL DEFAULT 0,       -- 9
  `spawnint`   int(11)      NOT NULL DEFAULT 0,       -- 10
  `spawnworld` int(11)      NOT NULL DEFAULT 0,       -- 11
  `minx`       float        NOT NULL DEFAULT 0,       -- 12 clan zone cube
  `miny`       float        NOT NULL DEFAULT 0,       -- 13
  `minz`       float        NOT NULL DEFAULT 0,       -- 14
  `maxx`       float        NOT NULL DEFAULT 0,       -- 15
  `maxy`       float        NOT NULL DEFAULT 0,       -- 16
  `maxz`       float        NOT NULL DEFAULT 0,       -- 17
  `is_bank`    int(11)      NOT NULL DEFAULT 0,       -- 18
  `bankmoney`  int(11)      NOT NULL DEFAULT 0,       -- 19
  `bankx`      float        NOT NULL DEFAULT 0,       -- 20
  `banky`      float        NOT NULL DEFAULT 0,       -- 21
  `bankz`      float        NOT NULL DEFAULT 0,       -- 22
  `rang_1`     varchar(32)  NOT NULL DEFAULT '0,Rang 1',  -- 23 "flags,rankname"
  `rang_2`     varchar(32)  NOT NULL DEFAULT '0,Rang 2',  -- 24
  `rang_3`     varchar(32)  NOT NULL DEFAULT '0,Rang 3',  -- 25
  `rang_4`     varchar(32)  NOT NULL DEFAULT '0,Rang 4',  -- 26
  `rang_5`     varchar(32)  NOT NULL DEFAULT '0,Rang 5',  -- 27
  `rang_6`     varchar(32)  NOT NULL DEFAULT '0,Rang 6',  -- 28
  `rang_7`     varchar(32)  NOT NULL DEFAULT '0,Rang 7',  -- 29
  `rang_8`     varchar(32)  NOT NULL DEFAULT '0,Rang 8',  -- 30
  `rang_9`     varchar(32)  NOT NULL DEFAULT '0,Rang 9',  -- 31
  `rang_10`    varchar(32)  NOT NULL DEFAULT '0,Rang 10', -- 32
  `players`    text         NOT NULL,                 -- 33 csv "regid,rank,..." pairs (30 members)
  `time`       int(11)      NOT NULL DEFAULT 0,       -- 34 creation timestamp
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `clans_activation`;
CREATE TABLE `clans_activation` (
  `id`       int(11)     NOT NULL AUTO_INCREMENT,
  `clanid`   int(11)     NOT NULL DEFAULT 0,
  `clanname` varchar(32) NOT NULL DEFAULT '',
  `type`     varchar(16) NOT NULL DEFAULT '',   -- ACCEPT / DELETE
  `reg_id`   int(11)     NOT NULL DEFAULT 0,    -- admin reg_id
  `player`   varchar(24) NOT NULL DEFAULT '',   -- admin name
  `time`     int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `clans_banklog`;
CREATE TABLE `clans_banklog` (
  `id`        int(11)     NOT NULL AUTO_INCREMENT,
  `clanid`    int(11)     NOT NULL DEFAULT 0,
  `clan`      varchar(32) NOT NULL DEFAULT '',
  `type`      varchar(16) NOT NULL DEFAULT '',
  `reg_id`    int(11)     NOT NULL DEFAULT 0,
  `player`    varchar(24) NOT NULL DEFAULT '',
  `amount`    int(11)     NOT NULL DEFAULT 0,
  `newamount` int(11)     NOT NULL DEFAULT 0,
  `time`      int(11)     NOT NULL DEFAULT 0,       -- unix timestamp
  `time_`     varchar(24) NOT NULL DEFAULT '',      -- formatted date
  PRIMARY KEY (`id`),
  KEY `clanid` (`clanid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `clans_log`;
CREATE TABLE `clans_log` (
  `id`            int(11)      NOT NULL AUTO_INCREMENT, -- 0
  `clanid`        int(11)      NOT NULL DEFAULT 0,      -- 1
  `clanname`      varchar(32)  NOT NULL DEFAULT '',     -- 2
  `playerid`      int(11)      NOT NULL DEFAULT 0,      -- 3  actor reg_id
  `playerid_name` varchar(24)  NOT NULL DEFAULT '',     -- 4
  `player1`       int(11)      NOT NULL DEFAULT 0,      -- 5  target reg_id
  `player1_name`  varchar(24)  NOT NULL DEFAULT '',     -- 6
  `type`          varchar(32)  NOT NULL DEFAULT '',     -- 7
  `str`           varchar(160) NOT NULL DEFAULT '',     -- 8
  `time`          varchar(24)  NOT NULL DEFAULT '',     -- 9
  PRIMARY KEY (`id`),
  KEY `clanid` (`clanid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- RACES  (positional 0..167 after JOINed players.name — THREAD_LoadRaceInfo)
-- ============================================================================
DROP TABLE IF EXISTS `racedata`;
CREATE TABLE `racedata` (
  `raceid`      int(11)     NOT NULL AUTO_INCREMENT,  -- 0
  `race`        varchar(48) NOT NULL DEFAULT '',      -- 1  race name
  `autofix`     int(11)     NOT NULL DEFAULT 0,       -- 2
  `ghostmode`   int(11)     NOT NULL DEFAULT 0,       -- 3
  `cpsize`      float       NOT NULL DEFAULT 8,       -- 4
  `angle`       float       NOT NULL DEFAULT 0,       -- 5  start angle
  `racetype`    int(11)     NOT NULL DEFAULT 0,       -- 6
  `clearworld`  int(11)     NOT NULL DEFAULT 0,       -- 7
  `holder`      varchar(24) NOT NULL DEFAULT 'NINCS', -- 8  record holder name
  `regid`       int(11)     NOT NULL DEFAULT -1,      -- 9  record holder reg_id
  `record`      int(11)     NOT NULL DEFAULT 0,       -- 10 record (ms)
  `vehicle`     varchar(32) NOT NULL DEFAULT '',      -- 11 record vehicle name
  `recordtime`  int(11)     NOT NULL DEFAULT 0,       -- 12 record set at (unix)
  `reg_id`      int(11)     NOT NULL DEFAULT 0,       -- 13 creator reg_id
  `createtime`  int(11)     NOT NULL DEFAULT 0,       -- 14
  `gravity`     float       NOT NULL DEFAULT 0.008,   -- 15
  `racevehicle` int(11)     NOT NULL DEFAULT 0,       -- 16 forced vehicle model (0 = any)
  `interior`    int(11)     NOT NULL DEFAULT 0,       -- 17
  -- cp_0 .. cp_149: checkpoint coordinates "x,y,z"  (positions 18..167)
  PRIMARY KEY (`raceid`),
  KEY `regid` (`regid`),
  KEY `reg_id` (`reg_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
-- MyISAM: 150 varchar checkpoint columns exceed InnoDB's 8K row limit.

-- checkpoint columns generated below (MAX_RACE_CP = 150)
DELIMITER //
DROP PROCEDURE IF EXISTS add_race_cps //
CREATE PROCEDURE add_race_cps()
BEGIN
  DECLARE i INT DEFAULT 0;
  WHILE i < 150 DO
    SET @s = CONCAT('ALTER TABLE `racedata` ADD COLUMN `cp_', i, '` varchar(48) NOT NULL DEFAULT ''''');
    PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
    SET i = i + 1;
  END WHILE;
END //
CALL add_race_cps() //
DROP PROCEDURE add_race_cps //
DELIMITER ;

-- ============================================================================
-- CUSTOM DM ZONES  (positional 0..67; JOINed players.name after — LoadCustomDMInfo)
-- ============================================================================
DROP TABLE IF EXISTS `custom_dm`;
CREATE TABLE `custom_dm` (
  `id`             int(11)     NOT NULL AUTO_INCREMENT, -- 0
  `type`           int(11)     NOT NULL DEFAULT 0,      -- 1
  `activated`      int(11)     NOT NULL DEFAULT 0,      -- 2
  `completed`      int(11)     NOT NULL DEFAULT 0,      -- 3
  `creator_id`     int(11)     NOT NULL DEFAULT 0,      -- 4  players.reg_id
  `name`           varchar(48) NOT NULL DEFAULT '',     -- 5
  `cmd`            varchar(32) NOT NULL DEFAULT '',     -- 6
  `team_1`         varchar(40) NOT NULL DEFAULT '*',    -- 7  "color,name"
  `team_2`         varchar(40) NOT NULL DEFAULT '*',    -- 8
  `in_clearworld`  int(11)     NOT NULL DEFAULT 0,      -- 9
  `instagib`       int(11)     NOT NULL DEFAULT 0,      -- 10
  `headshot`       int(11)     NOT NULL DEFAULT 0,      -- 11
  `maxkills`       int(11)     NOT NULL DEFAULT 0,      -- 12
  `maxplayers`     int(11)     NOT NULL DEFAULT 0,      -- 13
  `weapons_buy`    int(11)     NOT NULL DEFAULT 0,      -- 14
  `place_bomb`     int(11)     NOT NULL DEFAULT 0,      -- 15
  `no_nametags`    int(11)     NOT NULL DEFAULT 0,      -- 16
  `explosive_ammo` int(11)     NOT NULL DEFAULT 0,      -- 17
  `interior`       int(11)     NOT NULL DEFAULT 0,      -- 18
  `health`         float       NOT NULL DEFAULT 100,    -- 19
  `armour`         float       NOT NULL DEFAULT 0,      -- 20
  `minx`           float       NOT NULL DEFAULT 0,      -- 21 DM gangzone rectangle
  `miny`           float       NOT NULL DEFAULT 0,      -- 22
  `maxx`           float       NOT NULL DEFAULT 0,      -- 23
  `maxy`           float       NOT NULL DEFAULT 0,      -- 24
  `color`          int(11)     NOT NULL DEFAULT 0,      -- 25
  `spawn_0`  varchar(64) NOT NULL DEFAULT '', `spawn_1`  varchar(64) NOT NULL DEFAULT '',
  `spawn_2`  varchar(64) NOT NULL DEFAULT '', `spawn_3`  varchar(64) NOT NULL DEFAULT '',
  `spawn_4`  varchar(64) NOT NULL DEFAULT '', `spawn_5`  varchar(64) NOT NULL DEFAULT '',
  `spawn_6`  varchar(64) NOT NULL DEFAULT '', `spawn_7`  varchar(64) NOT NULL DEFAULT '',
  `spawn_8`  varchar(64) NOT NULL DEFAULT '', `spawn_9`  varchar(64) NOT NULL DEFAULT '',
  `spawn_10` varchar(64) NOT NULL DEFAULT '', `spawn_11` varchar(64) NOT NULL DEFAULT '',
  `spawn_12` varchar(64) NOT NULL DEFAULT '', `spawn_13` varchar(64) NOT NULL DEFAULT '',
  `spawn_14` varchar(64) NOT NULL DEFAULT '', `spawn_15` varchar(64) NOT NULL DEFAULT '',
  `spawn_16` varchar(64) NOT NULL DEFAULT '', `spawn_17` varchar(64) NOT NULL DEFAULT '',
  `spawn_18` varchar(64) NOT NULL DEFAULT '', `spawn_19` varchar(64) NOT NULL DEFAULT '',
  `spawn_20` varchar(64) NOT NULL DEFAULT '', `spawn_21` varchar(64) NOT NULL DEFAULT '',
  `spawn_22` varchar(64) NOT NULL DEFAULT '', `spawn_23` varchar(64) NOT NULL DEFAULT '',
  `spawn_24` varchar(64) NOT NULL DEFAULT '', `spawn_25` varchar(64) NOT NULL DEFAULT '',
  `spawn_26` varchar(64) NOT NULL DEFAULT '', `spawn_27` varchar(64) NOT NULL DEFAULT '',
  `spawn_28` varchar(64) NOT NULL DEFAULT '', `spawn_29` varchar(64) NOT NULL DEFAULT '', -- 26..55  "x,y,z,angle"
  `weapons`        varchar(96) NOT NULL DEFAULT '',     -- 56 26 csv ints
  `armed_weapon`   int(11)     NOT NULL DEFAULT 255,    -- 57 0xFF = none
  `time`           int(11)     NOT NULL DEFAULT 0,      -- 58 creation timestamp
  `gravity`        float       NOT NULL DEFAULT 0.008,  -- 59
  `jetpack`        int(11)     NOT NULL DEFAULT 0,      -- 60
  `weather`        int(11)     NOT NULL DEFAULT -1,     -- 61 -1 = default
  `hour`           int(11)     NOT NULL DEFAULT -1,     -- 62 -1 = default
  `maxkillstreak`  int(11)     NOT NULL DEFAULT 0,      -- 63
  `player`         varchar(24) NOT NULL DEFAULT '',     -- 64 killstreak record holder
  `player_id`      int(11)     NOT NULL DEFAULT 0,      -- 65
  `hud`            int(11)     NOT NULL DEFAULT 0,      -- 66
  `mode`           int(11)     NOT NULL DEFAULT 0,      -- 67
  PRIMARY KEY (`id`),
  KEY `creator_id` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- SERVER CONFIG  (single row, id = 1; positional 0..17 — THREAD_Settings)
-- ============================================================================
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `id`            int(11)      NOT NULL,               -- 0
  `reserved_1`    int(11)      NOT NULL DEFAULT 0,     -- 1  unused filler
  `autogate`      int(11)      NOT NULL DEFAULT 1,     -- 2
  `autogate_2`    int(11)      NOT NULL DEFAULT 1,     -- 3
  `recordplayers` int(11)      NOT NULL DEFAULT 0,     -- 4  player-count record
  `seepms`        int(11)      NOT NULL DEFAULT 0,     -- 5
  `cmdflood`      int(11)      NOT NULL DEFAULT 0,     -- 6
  `antimop`       int(11)      NOT NULL DEFAULT 0,     -- 7
  `wtimeformat`   int(11)      NOT NULL DEFAULT 0,     -- 8
  `autotick`      int(11)      NOT NULL DEFAULT 0,     -- 9
  `name`          varchar(24)  NOT NULL DEFAULT '',    -- 10 record-holder name
  `reg_id`        int(11)      NOT NULL DEFAULT 0,     -- 11
  `record`        int(11)      NOT NULL DEFAULT 0,     -- 12 shooting-range record
  `record_time`   int(11)      NOT NULL DEFAULT 0,     -- 13
  `weaponshots`   varchar(192) NOT NULL DEFAULT '',    -- 14 global weapon-shot stats (14 csv)
  `iplimit`       int(11)      NOT NULL DEFAULT 6,     -- 15 max accounts per IP
  `sobeitkick`    int(11)      NOT NULL DEFAULT 0,     -- 16
  `antidb`        int(11)      NOT NULL DEFAULT 0,     -- 17
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `config` (`id`) VALUES (1);

-- ============================================================================
-- XP LEVELS  (positional: 0 id, 1 name, 2 level, 3 description_hu, 4 description_en)
-- ============================================================================
DROP TABLE IF EXISTS `szintek`;
CREATE TABLE `szintek` (
  `id`             int(11)      NOT NULL AUTO_INCREMENT,
  `name`           varchar(32)  NOT NULL DEFAULT '',   -- gvar key: SZINT_<name>
  `level`          int(11)      NOT NULL DEFAULT 0,
  `description_hu` varchar(128) NOT NULL DEFAULT '',
  `description_en` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- TELEPORTS  (positional 0..12 — THREAD_ShowSQLTeleportList3)
-- ============================================================================
DROP TABLE IF EXISTS `teleports`;
CREATE TABLE `teleports` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,  -- 0
  `name_hu`      varchar(48) NOT NULL DEFAULT '',      -- 1
  `name_en`      varchar(48) NOT NULL DEFAULT '',      -- 2  message/display name
  `cmd`          varchar(32) NOT NULL DEFAULT '',      -- 3  e.g. /sf ('NULL' = random)
  `x`            float       NOT NULL DEFAULT 0,       -- 4
  `y`            float       NOT NULL DEFAULT 0,       -- 5
  `z`            float       NOT NULL DEFAULT 0,       -- 6
  `angle`        float       NOT NULL DEFAULT 0,       -- 7
  `world`        int(11)     NOT NULL DEFAULT 0,       -- 8
  `interior`     int(11)     NOT NULL DEFAULT 0,       -- 9
  `kategoria_hu` varchar(32) NOT NULL DEFAULT '',      -- 10
  `kategoria_en` varchar(32) NOT NULL DEFAULT '',      -- 11
  `hasznalat`    int(11)     NOT NULL DEFAULT 0,       -- 12 usage counter
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- SAVED POSITION SLOTS (/sp — pre-seeded rows, updated in place; positional 0..15)
-- ============================================================================
DROP TABLE IF EXISTS `savepositions`;
CREATE TABLE `savepositions` (
  `id`        int(11)     NOT NULL AUTO_INCREMENT,  -- 0
  `name`      varchar(24) NOT NULL DEFAULT 'Senki', -- 1
  `reg_id`    int(11)     NOT NULL DEFAULT -1,      -- 2
  `x`         float       NOT NULL DEFAULT -1,      -- 3
  `y`         float       NOT NULL DEFAULT -1,      -- 4
  `z`         float       NOT NULL DEFAULT -1,      -- 5
  `angle`     float       NOT NULL DEFAULT -1,      -- 6
  `interior`  int(11)     NOT NULL DEFAULT 0,       -- 7
  `world`     int(11)     NOT NULL DEFAULT 0,       -- 8
  `vel_x`     float       NOT NULL DEFAULT -1,      -- 9
  `vel_y`     float       NOT NULL DEFAULT -1,      -- 10
  `vel_z`     float       NOT NULL DEFAULT -1,      -- 11
  `isvehicle` int(11)     NOT NULL DEFAULT 1,       -- 12
  `isvel`     int(11)     NOT NULL DEFAULT 0,       -- 13
  `time`      varchar(24) NOT NULL DEFAULT '0.0.0/0.0.0', -- 14
  `slotname`  varchar(32) NOT NULL DEFAULT 'N/A',   -- 15
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- ATTACHED / HOLDING OBJECTS
-- ============================================================================
DROP TABLE IF EXISTS `holdingobjects`;
CREATE TABLE `holdingobjects` (
  `id`             int(11)     NOT NULL AUTO_INCREMENT, -- 0
  `name`           varchar(24) NOT NULL DEFAULT '',     -- 1 creator name
  `reg_id`         int(11)     NOT NULL DEFAULT 0,      -- 2
  `objectname`     varchar(32) NOT NULL DEFAULT '',     -- 3
  `object_id`      int(11)     NOT NULL DEFAULT 0,      -- 4 model id
  `bone_id`        int(11)     NOT NULL DEFAULT 0,      -- 5
  `offset_x`       float       NOT NULL DEFAULT 0,      -- 6
  `offset_y`       float       NOT NULL DEFAULT 0,      -- 7
  `offset_z`       float       NOT NULL DEFAULT 0,      -- 8
  `rotation_x`     float       NOT NULL DEFAULT 0,      -- 9
  `rotation_y`     float       NOT NULL DEFAULT 0,      -- 10
  `rotation_z`     float       NOT NULL DEFAULT 0,      -- 11
  `scale_x`        float       NOT NULL DEFAULT 1,      -- 12
  `scale_y`        float       NOT NULL DEFAULT 1,      -- 13
  `scale_z`        float       NOT NULL DEFAULT 1,      -- 14
  `materialcolor1` int(11)     NOT NULL DEFAULT 0,      -- 15
  `materialcolor2` int(11)     NOT NULL DEFAULT 0,      -- 16
  `time`           varchar(24) NOT NULL DEFAULT '',     -- 17
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`),
  KEY `objectname` (`objectname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `holdingobjects_set`;
CREATE TABLE `holdingobjects_set` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT,
  `name`       varchar(24)  NOT NULL DEFAULT '',
  `reg_id`     int(11)      NOT NULL DEFAULT 0,
  `objectname` varchar(32)  NOT NULL DEFAULT '',
  `time`       varchar(24)  NOT NULL DEFAULT '',
  `lastedit`   varchar(24)  NOT NULL DEFAULT '',
  `objects`    varchar(128) NOT NULL DEFAULT '',   -- csv of holdingobjects ids
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `holdingobjects_v`;
CREATE TABLE `holdingobjects_v` (
  `id`          int(11)     NOT NULL AUTO_INCREMENT,
  `name`        varchar(24) NOT NULL DEFAULT '',
  `reg_id`      int(11)     NOT NULL DEFAULT 0,
  `objectname`  varchar(32) NOT NULL DEFAULT '',
  `object_id`   int(11)     NOT NULL DEFAULT 0,
  `offset_x`    float       NOT NULL DEFAULT 0,
  `offset_y`    float       NOT NULL DEFAULT 0,
  `offset_z`    float       NOT NULL DEFAULT 0,
  `rotation_x`  float       NOT NULL DEFAULT 0,
  `rotation_y`  float       NOT NULL DEFAULT 0,
  `rotation_z`  float       NOT NULL DEFAULT 0,
  `time`        varchar(24) NOT NULL DEFAULT '',
  `material_0`  varchar(96) NOT NULL DEFAULT '', `material_1`  varchar(96) NOT NULL DEFAULT '',
  `material_2`  varchar(96) NOT NULL DEFAULT '', `material_3`  varchar(96) NOT NULL DEFAULT '',
  `material_4`  varchar(96) NOT NULL DEFAULT '', `material_5`  varchar(96) NOT NULL DEFAULT '',
  `material_6`  varchar(96) NOT NULL DEFAULT '', `material_7`  varchar(96) NOT NULL DEFAULT '',
  `material_8`  varchar(96) NOT NULL DEFAULT '', `material_9`  varchar(96) NOT NULL DEFAULT '',
  `material_10` varchar(96) NOT NULL DEFAULT '', `material_11` varchar(96) NOT NULL DEFAULT '',
  `material_12` varchar(96) NOT NULL DEFAULT '', `material_13` varchar(96) NOT NULL DEFAULT '',
  `material_14` varchar(96) NOT NULL DEFAULT '', `material_15` varchar(96) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`),
  KEY `objectname` (`objectname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `holdingobjects_vset`;
CREATE TABLE `holdingobjects_vset` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT,
  `name`       varchar(24)  NOT NULL DEFAULT '',
  `reg_id`     int(11)      NOT NULL DEFAULT 0,
  `objectname` varchar(32)  NOT NULL DEFAULT '',
  `time`       varchar(24)  NOT NULL DEFAULT '',
  `lastedit`   varchar(24)  NOT NULL DEFAULT '',
  `objects`    varchar(512) NOT NULL DEFAULT '',   -- csv of holdingobjects_v ids (up to ~115)
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- BANS / MODERATION
-- ============================================================================
DROP TABLE IF EXISTS `bans`;
CREATE TABLE `bans` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT, -- 0
  `player`     varchar(24)  NOT NULL DEFAULT '',     -- 1
  `reg_id`     int(11)      NOT NULL DEFAULT -1,     -- 2  (-1/-2 = special)
  `admin`      varchar(24)  NOT NULL DEFAULT '',     -- 3
  `admin_id`   int(11)      NOT NULL DEFAULT 0,      -- 4
  `ip`         varchar(16)  NOT NULL DEFAULT '',     -- 5
  `serial`     varchar(64)  NOT NULL DEFAULT 'N/A',  -- 6
  `reason`     varchar(128) NOT NULL DEFAULT '',     -- 7
  `time`       varchar(24)  NOT NULL DEFAULT '',     -- 8
  `unban_time` int(11)      NOT NULL DEFAULT 0,      -- 9  unix ts, 0 = permanent
  `show_admin` int(11)      NOT NULL DEFAULT 1,      -- 10
  PRIMARY KEY (`id`),
  KEY `ip` (`ip`),
  KEY `player` (`player`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `bans_serial`;
CREATE TABLE `bans_serial` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT, -- 0
  `serial` varchar(128) NOT NULL DEFAULT '',     -- 1
  `reason` varchar(128) NOT NULL DEFAULT '',     -- 2
  `reg_id` int(11)      NOT NULL DEFAULT 0,      -- 3
  `name`   varchar(24)  NOT NULL DEFAULT '',     -- 4
  `time`   int(11)      NOT NULL DEFAULT 0,      -- 5
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `kicks`;
CREATE TABLE `kicks` (
  `id`           int(11)      NOT NULL AUTO_INCREMENT,
  `player`       varchar(24)  NOT NULL DEFAULT '',
  `player_regid` int(11)      NOT NULL DEFAULT 0,
  `player_ip`    varchar(16)  NOT NULL DEFAULT '',
  `admin`        varchar(24)  NOT NULL DEFAULT '',
  `admin_regid`  int(11)      NOT NULL DEFAULT 0,
  `reason`       varchar(128) NOT NULL DEFAULT '',
  `time`         varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `adminlog`;
CREATE TABLE `adminlog` (
  `id`       int(11)      NOT NULL AUTO_INCREMENT,
  `command`  varchar(32)  NOT NULL DEFAULT '',
  `admin`    varchar(24)  NOT NULL DEFAULT '',
  `adminid`  int(11)      NOT NULL DEFAULT 0,
  `player`   varchar(24)  NOT NULL DEFAULT '',
  `playerid` int(11)      NOT NULL DEFAULT 0,
  `str`      varchar(256) NOT NULL DEFAULT '',
  `time`     varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `adminid` (`adminid`),
  KEY `playerid` (`playerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `anticheat`;
CREATE TABLE `anticheat` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `name`   varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `type`   varchar(192) NOT NULL DEFAULT '',
  `ip`     varchar(16)  NOT NULL DEFAULT '',
  `serial` varchar(64)  NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `faillogins`;
CREATE TABLE `faillogins` (
  `id`       int(11)      NOT NULL AUTO_INCREMENT,
  `name`     varchar(24)  NOT NULL DEFAULT '',
  `reg_id`   int(11)      NOT NULL DEFAULT -1,
  `password` varchar(129) NOT NULL DEFAULT '',
  `ip`       varchar(16)  NOT NULL DEFAULT '',
  `serial`   varchar(128) NOT NULL DEFAULT '',
  `time`     varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- successful logins, same layout
DROP TABLE IF EXISTS `faillogins_s`;
CREATE TABLE `faillogins_s` (
  `id`       int(11)      NOT NULL AUTO_INCREMENT,
  `name`     varchar(24)  NOT NULL DEFAULT '',
  `reg_id`   int(11)      NOT NULL DEFAULT -1,
  `password` varchar(129) NOT NULL DEFAULT '',
  `ip`       varchar(16)  NOT NULL DEFAULT '',
  `serial`   varchar(128) NOT NULL DEFAULT '',
  `time`     varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `adminlogin`;
CREATE TABLE `adminlogin` (
  `id`       int(11)      NOT NULL AUTO_INCREMENT,
  `name`     varchar(24)  NOT NULL DEFAULT '',
  `reg_id`   int(11)      NOT NULL DEFAULT 0,
  `a_name`   varchar(24)  NOT NULL DEFAULT '',
  `a_reg_id` int(11)      NOT NULL DEFAULT 0,
  `pass`     varchar(129) NOT NULL DEFAULT '',
  `time`     varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- failed admin logins
DROP TABLE IF EXISTS `adminlogin_f`;
CREATE TABLE `adminlogin_f` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `name`   varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `a_name` varchar(24)  NOT NULL DEFAULT '',
  `pass`   varchar(129) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rcon`;
CREATE TABLE `rcon` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `name`   varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `ip`     varchar(16)  NOT NULL DEFAULT '',
  `pass`   varchar(129) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- failed rcon logins, same layout
DROP TABLE IF EXISTS `rcon_f`;
CREATE TABLE `rcon_f` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `name`   varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `ip`     varchar(16)  NOT NULL DEFAULT '',
  `pass`   varchar(129) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rcon_remote`;
CREATE TABLE `rcon_remote` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `ip`      varchar(16)  NOT NULL DEFAULT '',
  `port`    int(11)      NOT NULL DEFAULT 0,
  `pass`    varchar(64)  NOT NULL DEFAULT '',
  `command` varchar(128) NOT NULL DEFAULT '',
  `success` int(11)      NOT NULL DEFAULT 0,
  `time`    int(11)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- CONNECTION / SESSION LOGS
-- ============================================================================
DROP TABLE IF EXISTS `connections`;
CREATE TABLE `connections` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,
  `name`         varchar(24) NOT NULL DEFAULT '',
  `reg_id`       int(11)     NOT NULL DEFAULT -1,
  `ip`           varchar(16) NOT NULL DEFAULT '',
  `serial`       varchar(64) NOT NULL DEFAULT '',
  `country`      varchar(48) NOT NULL DEFAULT '',
  `gmt`          int(11)     NOT NULL DEFAULT 0,
  `version`      varchar(24) NOT NULL DEFAULT '',
  `playercount`  int(11)     NOT NULL DEFAULT 0,
  `time`         varchar(24) NOT NULL DEFAULT '',
  `elapsed_time` int(11)     NOT NULL DEFAULT 0,   -- session length (ms)
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`),
  KEY `ip` (`ip`),
  KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `serverstarts`;
CREATE TABLE `serverstarts` (
  `id`         int(11)     NOT NULL AUTO_INCREMENT,
  `time`       varchar(24) NOT NULL DEFAULT '',
  `sversion`   varchar(24) NOT NULL DEFAULT '',   -- SA-MP server version
  `version`    varchar(16) NOT NULL DEFAULT '',   -- gamemode SERVER_VERSION
  `lastupdate` varchar(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- CHAT / PM LOGS  (identical layout family)
-- ============================================================================
DROP TABLE IF EXISTS `chat`;
CREATE TABLE `chat` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `msg`    varchar(160) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `chat_c`;   -- console/clan-command chat
CREATE TABLE `chat_c`  LIKE `chat`;
DROP TABLE IF EXISTS `chat_sh`;  -- shout chat
CREATE TABLE `chat_sh` LIKE `chat`;
DROP TABLE IF EXISTS `chat_su`;  -- /su chat
CREATE TABLE `chat_su` LIKE `chat`;
DROP TABLE IF EXISTS `chat_t`;   -- team chat
CREATE TABLE `chat_t`  LIKE `chat`;

DROP TABLE IF EXISTS `chat_vip`;
CREATE TABLE `chat_vip` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `msg`    varchar(160) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `chat_clans`;
CREATE TABLE `chat_clans` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `clan`   varchar(32)  NOT NULL DEFAULT '',
  `clanid` int(11)      NOT NULL DEFAULT 0,
  `msg`    varchar(160) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `adminchat`;
CREATE TABLE `adminchat` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `msg`    varchar(160) NOT NULL DEFAULT '',
  `type`   int(11)      NOT NULL DEFAULT 0,
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pm`;
CREATE TABLE `pm` (
  `id`          int(11)      NOT NULL AUTO_INCREMENT,
  `player`      varchar(24)  NOT NULL DEFAULT '',
  `reg_id`      int(11)      NOT NULL DEFAULT 0,
  `reciever`    varchar(24)  NOT NULL DEFAULT '',
  `reciever_id` int(11)      NOT NULL DEFAULT 0,
  `msg`         varchar(160) NOT NULL DEFAULT '',
  `time`        varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`),
  KEY `reciever_id` (`reciever_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `commands`;
CREATE TABLE `commands` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `cmd`    varchar(128) NOT NULL DEFAULT '',
  `time`   int(11)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sentips`;
CREATE TABLE `sentips` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `msg`    varchar(160) NOT NULL DEFAULT '',
  `time`   int(11)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- KILL / GAME EVENT LOGS
-- ============================================================================
DROP TABLE IF EXISTS `killlist`;
CREATE TABLE `killlist` (
  `id`         int(11)     NOT NULL AUTO_INCREMENT,
  `player`     varchar(24) NOT NULL DEFAULT '',
  `player_id`  int(11)     NOT NULL DEFAULT 0,
  `killer`     varchar(24) NOT NULL DEFAULT '',
  `killer_id`  int(11)     NOT NULL DEFAULT -1,
  `reason`     int(11)     NOT NULL DEFAULT 0,    -- weapon id
  `weaponname` varchar(32) NOT NULL DEFAULT '',
  `dm_zone`    int(11)     NOT NULL DEFAULT -1,
  `killstreak` int(11)     NOT NULL DEFAULT 0,
  `time`       varchar(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `killer_id` (`killer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `fakekills`;
CREATE TABLE `fakekills` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,
  `killer`       varchar(24) NOT NULL DEFAULT '',
  `killer_regid` int(11)     NOT NULL DEFAULT 0,
  `player`       varchar(24) NOT NULL DEFAULT '',
  `player_regid` int(11)     NOT NULL DEFAULT 0,
  `weaponid`     int(11)     NOT NULL DEFAULT 0,
  `type`         int(11)     NOT NULL DEFAULT 0,
  `time`         int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `bounty`;
CREATE TABLE `bounty` (
  `id`          int(11)     NOT NULL AUTO_INCREMENT,
  `player`      varchar(24) NOT NULL DEFAULT '',
  `reg_id`      int(11)     NOT NULL DEFAULT 0,
  `giver`       varchar(24) NOT NULL DEFAULT '',
  `giver_regid` int(11)     NOT NULL DEFAULT 0,
  `bounty`      int(11)     NOT NULL DEFAULT 0,
  `total`       int(11)     NOT NULL DEFAULT 0,
  `time`        int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `bounty_kill`;
CREATE TABLE `bounty_kill` (
  `id`       int(11)     NOT NULL AUTO_INCREMENT,
  `killerid` int(11)     NOT NULL DEFAULT 0,
  `killer`   varchar(24) NOT NULL DEFAULT '',
  `regid`    int(11)     NOT NULL DEFAULT 0,
  `player`   varchar(24) NOT NULL DEFAULT '',
  `cash`     int(11)     NOT NULL DEFAULT 0,
  `time`     varchar(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `givecash`;
CREATE TABLE `givecash` (
  `id`            int(11)     NOT NULL AUTO_INCREMENT,
  `player`        varchar(24) NOT NULL DEFAULT '',
  `reg_id`        int(11)     NOT NULL DEFAULT 0,
  `player_cash`   int(11)     NOT NULL DEFAULT 0,
  `reciever`      varchar(24) NOT NULL DEFAULT '',
  `reciever_id`   int(11)     NOT NULL DEFAULT 0,
  `reciever_cash` int(11)     NOT NULL DEFAULT 0,
  `money`         int(11)     NOT NULL DEFAULT 0,
  `accept`        int(11)     NOT NULL DEFAULT 0,
  `time`          int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`),
  KEY `reciever_id` (`reciever_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rablasok`;
CREATE TABLE `rablasok` (
  `id`      int(11)     NOT NULL AUTO_INCREMENT,
  `reg_id`  int(11)     NOT NULL DEFAULT 0,
  `name`    varchar(24) NOT NULL DEFAULT '',
  `prop_id` int(11)     NOT NULL DEFAULT 0,
  `type`    int(11)     NOT NULL DEFAULT 0,
  `iscar`   int(11)     NOT NULL DEFAULT 0,
  `earning` int(11)     NOT NULL DEFAULT 0,
  `time`    varchar(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `enter`;
CREATE TABLE `enter` (
  `id`         int(11)     NOT NULL AUTO_INCREMENT,
  `type`       int(11)     NOT NULL DEFAULT 0,     -- 0 = house, 1 = biznis
  `buildingid` int(11)     NOT NULL DEFAULT 0,
  `reg_id`     int(11)     NOT NULL DEFAULT 0,
  `name`       varchar(24) NOT NULL DEFAULT '',
  `price`      int(11)     NOT NULL DEFAULT 0,
  `time`       int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `weaponbuy`;
CREATE TABLE `weaponbuy` (
  `id`         int(11)     NOT NULL AUTO_INCREMENT,
  `player`     varchar(24) NOT NULL DEFAULT '',
  `reg_id`     int(11)     NOT NULL DEFAULT 0,
  `weaponid`   int(11)     NOT NULL DEFAULT 0,
  `ammo`       int(11)     NOT NULL DEFAULT 0,
  `price`      int(11)     NOT NULL DEFAULT 0,
  `weaponname` varchar(32) NOT NULL DEFAULT '',
  `time`       int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- MINIGAME RESULT LOGS
-- ============================================================================
DROP TABLE IF EXISTS `fallout`;
CREATE TABLE `fallout` (
  `id`           int(11)     NOT NULL AUTO_INCREMENT,
  `winner`       varchar(24) NOT NULL DEFAULT '',
  `winner_regid` int(11)     NOT NULL DEFAULT 0,
  `speed`        int(11)     NOT NULL DEFAULT 0,    -- round length (s)
  `time`         varchar(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reactions`;
CREATE TABLE `reactions` (
  `id`           int(11)      NOT NULL AUTO_INCREMENT,
  `reaction`     varchar(128) NOT NULL DEFAULT '',
  `winner`       varchar(24)  NOT NULL DEFAULT '',
  `winner_regid` int(11)      NOT NULL DEFAULT 0,
  `speed`        float        NOT NULL DEFAULT 0,
  `time`         varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `maths`;
CREATE TABLE `maths` (
  `id`           int(11)      NOT NULL AUTO_INCREMENT,
  `question`     varchar(128) NOT NULL DEFAULT '',
  `answer`       int(11)      NOT NULL DEFAULT 0,
  `winner`       varchar(24)  NOT NULL DEFAULT '',
  `winner_regid` int(11)      NOT NULL DEFAULT 0,
  `speed`        float        NOT NULL DEFAULT 0,
  `time`         varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `teletests`;
CREATE TABLE `teletests` (
  `id`           int(11)      NOT NULL AUTO_INCREMENT,
  `reaction`     varchar(128) NOT NULL DEFAULT '',
  `winner`       varchar(24)  NOT NULL DEFAULT '',
  `winner_regid` int(11)      NOT NULL DEFAULT 0,
  `speed`        float        NOT NULL DEFAULT 0,
  `time`         varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stunts`;
CREATE TABLE `stunts` (
  `id`      int(11)     NOT NULL AUTO_INCREMENT,
  `player`  varchar(24) NOT NULL DEFAULT '',
  `reg_id`  int(11)     NOT NULL DEFAULT 0,
  `pos`     int(11)     NOT NULL DEFAULT 0,
  `stunt`   varchar(64) NOT NULL DEFAULT '',
  `reward`  int(11)     NOT NULL DEFAULT 0,
  `cpcount` int(11)     NOT NULL DEFAULT 0,
  `time`    int(11)     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- GOLD POTS (treasure hunt)
-- ============================================================================
DROP TABLE IF EXISTS `goldpot_data`;
CREATE TABLE `goldpot_data` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `X`       float        NOT NULL DEFAULT 0,
  `Y`       float        NOT NULL DEFAULT 0,
  `Z`       float        NOT NULL DEFAULT 0,
  `hint`    varchar(128) NOT NULL DEFAULT '',
  `hint_en` varchar(128) NOT NULL DEFAULT '',
  `reward`  int(11)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `goldpots`;
CREATE TABLE `goldpots` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `goldpot` varchar(128) NOT NULL DEFAULT '',
  `name`    varchar(24)  NOT NULL DEFAULT '',
  `reg_id`  int(11)      NOT NULL DEFAULT 0,
  `speed`   float        NOT NULL DEFAULT 0,
  `time`    int(11)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- MUSIC / RADIO
-- ============================================================================
DROP TABLE IF EXISTS `musiclist`;
CREATE TABLE `musiclist` (
  `id`        int(11)      NOT NULL AUTO_INCREMENT, -- 0
  `activated` int(11)      NOT NULL DEFAULT 0,      -- 1
  `reg_id`    int(11)      NOT NULL DEFAULT 0,      -- 2
  `name`      varchar(64)  NOT NULL DEFAULT '',     -- 3
  `url`       varchar(256) NOT NULL DEFAULT '',     -- 4
  `time`      int(11)      NOT NULL DEFAULT 0,      -- 5
  `played`    int(11)      NOT NULL DEFAULT 0,      -- 6
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `radio`;
CREATE TABLE `radio` (
  `id`        int(11)      NOT NULL AUTO_INCREMENT, -- 0
  `name`      varchar(64)  NOT NULL DEFAULT '',     -- 1
  `url`       varchar(256) NOT NULL DEFAULT '',     -- 2
  `activated` int(11)      NOT NULL DEFAULT 1,      -- 3 (unused filler position)
  `reg_id`    int(11)      NOT NULL DEFAULT 0,      -- 4 (unused filler position)
  `played`    int(11)      NOT NULL DEFAULT 0,      -- 5
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- NAME / PASSWORD CHANGES
-- ============================================================================
DROP TABLE IF EXISTS `namechanges`;
CREATE TABLE `namechanges` (
  `id`      int(11)     NOT NULL AUTO_INCREMENT,
  `reg_id`  int(11)     NOT NULL DEFAULT 0,
  `oldname` varchar(24) NOT NULL DEFAULT '',
  `newname` varchar(24) NOT NULL DEFAULT '',
  `time`    varchar(24) NOT NULL DEFAULT '',   -- formatted date
  `time_`   int(11)     NOT NULL DEFAULT 0,    -- unix timestamp
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `namechanges_p`;
CREATE TABLE `namechanges_p` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `reg_id`  int(11)      NOT NULL DEFAULT 0,
  `name`    varchar(24)  NOT NULL DEFAULT '',
  `oldpass` varchar(129) NOT NULL DEFAULT '',
  `newpass` varchar(129) NOT NULL DEFAULT '',
  `time`    varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `reg_id` (`reg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- REPORTS (bug / idea / complaint)
-- ============================================================================
DROP TABLE IF EXISTS `reports_bug`;
CREATE TABLE `reports_bug` (
  `id`     int(11)      NOT NULL AUTO_INCREMENT,
  `player` varchar(24)  NOT NULL DEFAULT '',
  `reg_id` int(11)      NOT NULL DEFAULT 0,
  `text`   varchar(256) NOT NULL DEFAULT '',
  `time`   varchar(24)  NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reports_ideas`;
CREATE TABLE `reports_ideas` LIKE `reports_bug`;
DROP TABLE IF EXISTS `reports_panasz`;
CREATE TABLE `reports_panasz` LIKE `reports_bug`;

-- ============================================================================
-- CAMERAS  (/savecam)
-- ============================================================================
DROP TABLE IF EXISTS `cameras`;
CREATE TABLE `cameras` (
  `id`       int(11)     NOT NULL AUTO_INCREMENT, -- 0
  `reg_id`   int(11)     NOT NULL DEFAULT 0,      -- 1
  `creator`  varchar(24) NOT NULL DEFAULT '',     -- 2
  `name`     varchar(32) NOT NULL DEFAULT '',     -- 3
  `pos_x`    float       NOT NULL DEFAULT 0,      -- 4
  `pos_y`    float       NOT NULL DEFAULT 0,      -- 5
  `pos_z`    float       NOT NULL DEFAULT 0,      -- 6
  `lookat_x` float       NOT NULL DEFAULT 0,      -- 7
  `lookat_y` float       NOT NULL DEFAULT 0,      -- 8
  `lookat_z` float       NOT NULL DEFAULT 0,      -- 9
  `interior` int(11)     NOT NULL DEFAULT 0,      -- 10
  `time`     int(11)     NOT NULL DEFAULT 0,      -- 11
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- VEHICLE TUNING CATALOG (static data — needs to be filled with SA:MP mod data)
-- ============================================================================
DROP TABLE IF EXISTS `vehicle_components`;
CREATE TABLE `vehicle_components` (
  `id`          int(11)     NOT NULL AUTO_INCREMENT,
  `componentid` int(11)     NOT NULL DEFAULT 0,    -- 1000..1193
  `part`        varchar(32) NOT NULL DEFAULT '',   -- Exhausts/Hood/Roof/...
  `type`        int(11)     NOT NULL DEFAULT 0,
  `cars`        int(11)     NOT NULL DEFAULT -1,   -- vehicle model, -1/0 = generic
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `vehicle_model_parts`;
CREATE TABLE `vehicle_model_parts` (
  `modelid` int(11) NOT NULL,             -- 400..611
  `parts`   int(11) NOT NULL DEFAULT 0,   -- bitmask: 1 Exhausts, 2 Hood, 4 Hydraulics,
                                          -- 8 Lights, 16 Roof, 32 Side Skirts,
                                          -- 64 Spoilers, 128 Vents, 256 Wheels
  PRIMARY KEY (`modelid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- SMF FORUM BRIDGE (minimal stand-in — normally these belong to an SMF 2.0
-- forum installation; only the columns the gamemode touches are included)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `smf_members` (
  `id_member`            int(11)      NOT NULL AUTO_INCREMENT,
  `member_name`          varchar(80)  NOT NULL DEFAULT '',
  `real_name`            varchar(255) NOT NULL DEFAULT '',
  `date_registered`      int(11)      NOT NULL DEFAULT 0,
  `passwd`               varchar(64)  NOT NULL DEFAULT '',
  `email_address`        varchar(255) NOT NULL DEFAULT '',
  `member_ip`            varchar(255) NOT NULL DEFAULT '',
  `member_ip2`           varchar(255) NOT NULL DEFAULT '',
  `id_post_group`        int(11)      NOT NULL DEFAULT 0,
  `posts`                int(11)      NOT NULL DEFAULT 0,
  `total_time_logged_in` int(11)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_member`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smf_settings` (
  `variable` varchar(255) NOT NULL DEFAULT '',
  `value`    text         NOT NULL,
  PRIMARY KEY (`variable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `smf_settings` (`variable`, `value`) VALUES
  ('smfVersion', 'SMF 2.0'), ('latestMember', '0'), ('latestRealName', ''),
  ('mostOnline', '0'), ('mostOnlineToday', '0'), ('mostDate', '0');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- POST-INSTALL NOTES
-- ============================================================================
-- 1. `savepositions` (/sp slots), `teleports`, `radio`, `vehicle_components`,
--    `vehicle_model_parts`, `szintek` and `goldpot_data` are DATA tables the
--    server expects to be pre-filled; the gamemode only updates them.
--    Seed savepositions with as many empty rows as slots you want:
--      INSERT INTO savepositions () VALUES (); -- repeat N times
-- 2. `config` must contain the row with id = 1 (inserted above).
-- 3. The gamemode connects with mysql_connect(...) using connection id 1 for
--    the game DB and a second connection for the SMF forum DB. If you don't
--    run SMF, the bridge tables above satisfy the queries.
-- 4. Player passwords are stored as-provided by the old login system and
--    compared with COLLATE utf8_bin; the forum bridge stores sha1(name+pass)
--    the way SMF 2.0 does.
