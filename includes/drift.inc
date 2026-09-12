// SA-MP Drift System Include File
// ================================

#if defined _drift_included
    #endinput
#endif
#define _drift_included

#include <a_samp>
#include <a_http>
#include "config.inc"

// ===== CONSTANTS =====
#define INVALID_ZONE_ID -1
#define INVALID_PLAYER_ID -1
#define INVALID_DRIFT_ID -1

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
    zoneRecord,
    Text3D:zoneLabel
};

enum PlayerDriftData
{
    playerID,
    playerName[MAX_PLAYER_NAME],
    playerLevel,
    playerExp,
    playerDriftPoints,
    playerMoney,
    playerCombo,
    Float:playerMaxCombo,
    playerZoneRecord[MAX_ZONES],
    playerJoinTime,
    playerLastSave
};

enum DriftStats
{
    statsDriftPoints,
    statsLevel,
    statsExp,
    statsMoney,
    statsCombo,
    statsZoneEnters,
    statsZoneExits,
    statsSessionTime
};

// ===== NATIVE FUNCTIONS =====

// Инициализация системы дрифта
native InitDriftSystem();

// Загрузить данные игрока
native LoadPlayerData(playerid);

// Сохранить данные игрока
native SavePlayerData(playerid);

// Добавить очки дрифта
native AddDriftPoints(playerid, points);

// Получить очки дрифта игрока
native GetPlayerDriftPoints(playerid);

// Получить уровень игрока
native GetPlayerDriftLevel(playerid);

// Добавить опыт
native AddPlayerExp(playerid, exp);

// Создать дрифт-зону
native CreateDriftZone(Float:x, Float:y, Float:z, Float:radius, name[], points);

// Получить зону по ID
native GetZoneByID(zoneid);

// Проверить если игрок в зоне
native IsPlayerInDriftZone(playerid, zoneid);

// Добавить деньги
native AddPlayerMoney(playerid, money);

// Получить деньги
native GetPlayerDriftMoney(playerid);

// Очистить статистику
native ResetPlayerStats(playerid);

// ===== CALLBACK FUNCTIONS =====

// Когда игрок дрифтит
forward OnPlayerDrifting(playerid, Float:angle, Float:speed, points);

// Когда игрок входит в зону
forward OnPlayerEnterDriftZone(playerid, zoneid);

// Когда игрок выходит из зоны
forward OnPlayerExitDriftZone(playerid, zoneid);

// Когда игрок повышает уровень
forward OnPlayerLevelUp(playerid, newlevel);

// Когда игрок устанавливает рекорд в зоне
forward OnPlayerZoneRecord(playerid, zoneid, score);

// Комбо сломана
forward OnComboBreak(playerid, combo, points);

// ===== UTILITY FUNCTIONS =====

// Вычислить угол
stock Float:CalculateAngle(Float:x1, Float:y1, Float:x2, Float:y2)
{
    new Float:dx = x2 - x1;
    new Float:dy = y2 - y1;
    return atan2(dy, dx) * 180.0 / 3.14159;
}

// Расстояние между точками
stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    new Float:dx = x2 - x1;
    new Float:dy = y2 - y1;
    new Float:dz = z2 - z1;
    return floatsqrt((dx * dx) + (dy * dy) + (dz * dz));
}

// Форматирование больших чисел
stock FormatNumber(number, output[], len)
{
    if(number >= 1000000)
        format(output, len, "%dM", number / 1000000);
    else if(number >= 1000)
        format(output, len, "%dK", number / 1000);
    else
        format(output, len, "%d", number);
}

// Логирование
stock DriftLog(const message[])
{
    if(DEBUG_MODE)
    {
        new timestamp[32];
        format(timestamp, sizeof(timestamp), "[Drift] %s", message);
        print(timestamp);
    }
}