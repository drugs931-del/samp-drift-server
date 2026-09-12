// SA-MP Drift System FilterScript
// ================================

#include <a_samp>
#include "../includes/drift.inc"

// Переменные
new gPlayerDriftScore[MAX_PLAYERS];
new gPlayerIsInDrift[MAX_PLAYERS];
new Timer:gDriftTimer[MAX_PLAYERS];

public OnFilterScriptInit()
{
    print("SA-MP Drift System FilterScript Loaded");
    return 1;
}

public OnFilterScriptExit()
{
    print("SA-MP Drift System FilterScript Unloaded");
    return 1;
}

public OnPlayerConnect(playerid)
{
    gPlayerDriftScore[playerid] = 0;
    gPlayerIsInDrift[playerid] = 0;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    gPlayerDriftScore[playerid] = 0;
    gPlayerIsInDrift[playerid] = 0;
    return 1;
}

stock StartDrift(playerid)
{
    gPlayerIsInDrift[playerid] = 1;
    gPlayerDriftScore[playerid] = 0;
}

stock StopDrift(playerid)
{
    gPlayerIsInDrift[playerid] = 0;
}

stock AddDriftScore(playerid, score)
{
    gPlayerDriftScore[playerid] += score;
}

stock GetDriftScore(playerid)
{
    return gPlayerDriftScore[playerid];
}