// SA-MP Drift Zones FilterScript
// ===============================

#include <a_samp>
#include "../includes/drift.inc"

new gZoneList[MAX_ZONES];
new gZoneCount = 0;

public OnFilterScriptInit()
{
    print("SA-MP Drift Zones FilterScript Loaded");
    LoadDriftZones();
    return 1;
}

stock LoadDriftZones()
{
    // Загрузка зон из конфигурации
    gZoneCount = 0;
}

stock CreateDriftZone(Float:x, Float:y, Float:z, Float:radius, name[])
{
    if(gZoneCount >= MAX_ZONES) return -1;
    
    gZoneList[gZoneCount] = gZoneCount;
    gZoneCount++;
    return gZoneCount - 1;
}

stock GetZoneByID(zoneid)
{
    if(zoneid < 0 || zoneid >= gZoneCount) return -1;
    return gZoneList[zoneid];
}