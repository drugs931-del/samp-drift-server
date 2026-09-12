// SA-MP Drift System Include File
// ================================

#if defined _drift_included
    #endinput
#endif
#define _drift_included

#include <a_samp>

// ===== CONFIGURATION CONSTANTS =====
#define DRIFT_MAX_ZONES 15
#define DRIFT_MAX_PLAYER_NAME 24

#define BASE_DRIFT_POINTS 10
#define COMBO_MULTIPLIER 1.5
#define ZONE_BONUS 2.0
#define MIN_DRIFT_SPEED 80
#define DRIFT_ANGLE_MIN 25
#define DRIFT_CHECK_INTERVAL 100

#define MAX_LEVEL 50
#define EXP_PER_LEVEL 1000
#define START_LEVEL 1
#define LEVEL_UP_REWARD 500

#define TOP_PLAYERS 10
#define RANKING_UPDATE_TIME 5000

#define MONEY_PER_DRIFT 50
#define MONEY_PER_COMBO 100
#define VEHICLE_REWARD_LEVEL 20
#define SKIN_REWARD_LEVEL 30

#define ZONE_CHECK_INTERVAL 500
#define ZONE_BONUS_POINTS 500
#define ZONE_POINTS_MULTIPLIER 1.5

#define PLAYER_DATA_PATH "scriptfiles/players/"
#define AUTO_SAVE_TIME 60000

#define TEXTDRAW_UPDATE_TIME 1000
#define SHOW_COMBO_ON_SCREEN 1
#define SHOW_DRIFT_ZONE_NAME 1
#define SHOW_RANKING 1

#define DRIFT_VEHICLES 1
#define ALLOWED_VEHICLE_1 421
#define ALLOWED_VEHICLE_2 589
#define ALLOWED_VEHICLE_3 480
#define ALLOWED_VEHICLE_4 506
#define ALLOWED_VEHICLE_5 451

#define ADMIN_LEVEL_BASIC 1
#define ADMIN_LEVEL_MODERATOR 2
#define ADMIN_LEVEL_ADMIN 3
#define ADMIN_LEVEL_OWNER 4

#define COLOR_DRIFT 0xFF6B6BFF
#define COLOR_SUCCESS 0x00FF00FF
#define COLOR_ERROR 0xFF0000FF
#define COLOR_WARNING 0xFFFF00FF
#define COLOR_INFO 0x00FFFFFF
#define COLOR_RANK 0xFFD700FF
#define COLOR_ZONE 0x00CCFFFF

#define DEBUG_MODE 0
#define LOG_ACTIONS 1

#define INVALID_ZONE_ID -1

// ===== ENUMERATORS =====
enum DriftZoneData
{
    zoneID,
    Float:zoneX,
    Float:zoneY,
    Float:zoneZ,
    Float:zoneRadius,
    zoneName[32],
    zonePoints,
    zoneRecord
};

enum PlayerDriftData
{
    playerID,
    playerName[DRIFT_MAX_PLAYER_NAME],
    playerLevel,
    playerExp,
    playerDriftPoints,
    playerMoney,
    playerCombo,
    Float:playerMaxCombo,
    playerZoneRecord[DRIFT_MAX_ZONES],
    playerJoinTime,
    playerLastSave
};

// ===== CALLBACK FUNCTIONS =====

forward CheckDrift();
forward UpdateRanking();
forward AutoSaveData();
forward OnPlayerDrifting(playerid, Float:angle, Float:speed, points);
forward OnPlayerEnterDriftZone(playerid, zoneid);
forward OnPlayerExitDriftZone(playerid, zoneid);
forward OnPlayerLevelUp(playerid, newlevel);
forward OnPlayerZoneRecord(playerid, zoneid, score);
forward OnComboBreak(playerid, combo, points);

// ===== UTILITY FUNCTIONS =====

stock Float:CalculateAngle(Float:x1, Float:y1, Float:x2, Float:y2)
{
    new Float:dx = x2 - x1;
    new Float:dy = y2 - y1;
    return atan2(dy, dx) * 180.0 / 3.14159;
}

stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    new Float:dx = x2 - x1;
    new Float:dy = y2 - y1;
    new Float:dz = z2 - z1;
    new Float:distance = floatpower((dx * dx) + (dy * dy) + (dz * dz), 0.5);
    return distance;
}

stock FormatNumber(number, output[], len)
{
    if(number >= 1000000)
        format(output, len, "%dM", number / 1000000);
    else if(number >= 1000)
        format(output, len, "%dK", number / 1000);
    else
        format(output, len, "%d", number);
}

stock DriftLog(const message[])
{
    if(DEBUG_MODE)
    {
        new timestamp[32];
        format(timestamp, sizeof(timestamp), "[Drift] %s", message);
        print(timestamp);
    }
}
