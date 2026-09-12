// SA-MP Player Data FilterScript
// ================================

#include <a_samp>
#include "../includes/drift.inc"

enum PlayerInfo
{
    pLevel,
    pExp,
    pDriftPoints,
    pMoney,
    pZoneRecords[MAX_ZONES]
};

new gPlayerInfo[MAX_PLAYERS][PlayerInfo];

public OnFilterScriptInit()
{
    print("SA-MP Player Data FilterScript Loaded");
    return 1;
}

public OnPlayerConnect(playerid)
{
    LoadPlayerDataFromFile(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerDataToFile(playerid);
    return 1;
}

stock LoadPlayerDataFromFile(playerid)
{
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    new filepath[256];
    format(filepath, sizeof(filepath), PLAYER_DATA_PATH "%d_%s.ini", playerid, playerName);
    
    // Инициализация по умолчанию
    gPlayerInfo[playerid][pLevel] = 1;
    gPlayerInfo[playerid][pExp] = 0;
    gPlayerInfo[playerid][pDriftPoints] = 0;
    gPlayerInfo[playerid][pMoney] = 0;
    
    for(new i = 0; i < MAX_ZONES; i++)
        gPlayerInfo[playerid][pZoneRecords][i] = 0;
}

stock SavePlayerDataToFile(playerid)
{
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    new filepath[256];
    format(filepath, sizeof(filepath), PLAYER_DATA_PATH "%d_%s.ini", playerid, playerName);
    
    // Сохранение данных в файл
}