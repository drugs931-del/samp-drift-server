// SA-MP Drift Server - Main Gamemode
// ===================================

#include <a_samp>
#include "../includes/drift.inc"

#define GAMEMODE_NAME "SA-MP Drift Server 1.0"
#define GAMEMODE_VERSION "1.0"

// Variables
new gPlayerDriftPoints[MAX_PLAYERS];
new gPlayerLevel[MAX_PLAYERS];
new gPlayerExp[MAX_PLAYERS];
new gPlayerMoney[MAX_PLAYERS];
new gPlayerCombo[MAX_PLAYERS];
new Float:gPlayerMaxCombo[MAX_PLAYERS];
new gPlayerInZone[MAX_PLAYERS] = {-1, ...};
new gPlayerLastDriftTime[MAX_PLAYERS];
new gPlayerZoneRecord[MAX_PLAYERS][MAX_ZONES];

// Zones
new gZoneCount = 0;
new gZoneData[MAX_ZONES][DriftZoneData];
new Float:gPlayerLastX[MAX_PLAYERS];
new Float:gPlayerLastY[MAX_PLAYERS];
new Float:gPlayerLastZ[MAX_PLAYERS];

public OnGameModeInit()
{
    print("\n=====================================");
    print("SA-MP Drift Server Initializing...");
    print("=====================================");
    
    SetGameModeText(GAMEMODE_NAME);
    SetWeather(10);
    SetWorldTime(12, 0);
    
    // Создание дрифт-зон
    CreateDriftZones();
    
    // Таймер проверки дрифта
    SetTimer("CheckDrift", DRIFT_CHECK_INTERVAL, 1);
    SetTimer("UpdateRanking", RANKING_UPDATE_TIME, 1);
    SetTimer("AutoSaveData", AUTO_SAVE_TIME, 1);
    
    print("Drift Server initialized successfully!");
    return 1;
}

public OnGameModeExit()
{
    // Сохранение всех данных
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SavePlayerData(i);
        }
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Инициализация переменных
    gPlayerDriftPoints[playerid] = 0;
    gPlayerLevel[playerid] = START_LEVEL;
    gPlayerExp[playerid] = 0;
    gPlayerMoney[playerid] = 0;
    gPlayerCombo[playerid] = 0;
    gPlayerMaxCombo[playerid] = 0.0;
    gPlayerInZone[playerid] = -1;
    gPlayerLastDriftTime[playerid] = 0;
    
    for(new i = 0; i < MAX_ZONES; i++)
        gPlayerZoneRecord[playerid][i] = 0;
    
    // Загрузка данных
    LoadPlayerData(playerid);
    
    // Приветственное сообщение
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    printf("%s подключился. Уровень: %d, Очки: %d", 
        playerName, gPlayerLevel[playerid], gPlayerDriftPoints[playerid]);
    
    SendClientMessage(playerid, COLOR_INFO, "Добро пожаловать на Drift сервер!");
    SendClientMessage(playerid, COLOR_INFO, "Введите /help для справки");
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerData(playerid);
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128];
    ExtractCmd(cmdtext, cmd, sizeof(cmd));
    
    if(!strcmp(cmd, "/drift", true))
    {
        ShowDriftInfo(playerid);
        return 1;
    }
    
    if(!strcmp(cmd, "/stats", true))
    {
        ShowPlayerStats(playerid);
        return 1;
    }
    
    if(!strcmp(cmd, "/zones", true))
    {
        ShowZonesList(playerid);
        return 1;
    }
    
    if(!strcmp(cmd, "/ranking", true))
    {
        ShowRanking(playerid);
        return 1;
    }
    
    if(!strcmp(cmd, "/level", true))
    {
        ShowLevelInfo(playerid);
        return 1;
    }
    
    if(!strcmp(cmd, "/help", true))
    {
        SendClientMessage(playerid, COLOR_INFO, "=== Команды дрифт сервера ===");
        SendClientMessage(playerid, COLOR_INFO, "/drift - информация о дрифте");
        SendClientMessage(playerid, COLOR_INFO, "/stats - ваша статистика");
        SendClientMessage(playerid, COLOR_INFO, "/zones - список дрифт-зон");
        SendClientMessage(playerid, COLOR_INFO, "/ranking - таблица рейтинга");
        SendClientMessage(playerid, COLOR_INFO, "/level - информация об уровне");
        SendClientMessage(playerid, COLOR_INFO, "/adddrift [ID] [очки] - добавить очки (админ)");
        return 1;
    }
    
    if(!strcmp(cmd, "/adddrift", true))
    {
        if(IsPlayerAdmin(playerid))
        {
            new params[256], targetid, points;
            ExtractParams(cmdtext, params, sizeof(params));
            
            if(GetIntValue(params, 0, targetid) && GetIntValue(params, 1, points))
            {
                if(IsPlayerConnected(targetid))
                {
                    AddDriftPoints(targetid, points);
                    SendClientMessage(playerid, COLOR_SUCCESS, "Очки добавлены!");
                }
                else
                    SendClientMessage(playerid, COLOR_ERROR, "Игрок не найден!");
            }
            else
                SendClientMessage(playerid, COLOR_ERROR, "Использование: /adddrift [ID] [очки]");
        }
        else
            SendClientMessage(playerid, COLOR_ERROR, "Недостаточно прав!");
        return 1;
    }
    
    if(!strcmp(cmd, "/resetstats", true))
    {
        if(IsPlayerAdmin(playerid))
        {
            new params[256], targetid;
            ExtractParams(cmdtext, params, sizeof(params));
            
            if(strlen(params) > 0)
            {
                targetid = strval(params);
                if(IsPlayerConnected(targetid))
                {
                    ResetPlayerStats(targetid);
                    SendClientMessage(playerid, COLOR_SUCCESS, "Статистика сброшена!");
                }
                else
                    SendClientMessage(playerid, COLOR_ERROR, "Игрок не найден!");
            }
            else
                SendClientMessage(playerid, COLOR_ERROR, "Использование: /resetstats [ID]");
        }
        return 1;
    }
    
    return 0;
}

// ===== DRIFT FUNCTIONS =====

public CheckDrift()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        
        new Float:x, Float:y, Float:z, Float:angle, Float:speed;
        GetPlayerPos(i, x, y, z);
        GetVehicleZAngle(GetPlayerVehicleID(i), angle);
        speed = GetVehicleSpeed(GetPlayerVehicleID(i));
        
        // Проверка дрифта
        if(IsPlayerDrifting(i, x, y, z))
        {
            new points = CalculateDriftPoints(i, speed, angle);
            AddDriftPoints(i, points);
            gPlayerCombo[i]++;
        }
        else
        {
            if(gPlayerCombo[i] > 0)
            {
                OnComboBreak(i, gPlayerCombo[i], gPlayerDriftPoints[i]);
                gPlayerCombo[i] = 0;
            }
        }
        
        // Проверка зон
        CheckPlayerZones(i, x, y, z);
        
        // Обновление последних координат
        gPlayerLastX[i] = x;
        gPlayerLastY[i] = y;
        gPlayerLastZ[i] = z;
    }
}

stock bool:IsPlayerDrifting(playerid, Float:x, Float:y, Float:z)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return false;
    
    new Float:speed = GetVehicleSpeed(vehicleid);
    if(speed < MIN_DRIFT_SPEED) return false;
    
    new Float:distance = GetDistanceBetweenPoints(gPlayerLastX[playerid], gPlayerLastY[playerid], gPlayerLastZ[playerid], x, y, z);
    if(distance > 50.0) return false;
    
    return true;
}

stock CalculateDriftPoints(playerid, Float:speed, Float:angle)
{
    new points = BASE_DRIFT_POINTS;
    
    // Бонус за скорость
    points += floatround(speed / 10);
    
    // Множитель за комбо
    if(gPlayerCombo[playerid] > 10)
        points = floatround(points * COMBO_MULTIPLIER);
    
    // Бонус в зоне
    if(gPlayerInZone[playerid] != -1)
        points = floatround(points * ZONE_BONUS);
    
    return points;
}

stock CheckPlayerZones(playerid, Float:x, Float:y, Float:z)
{
    for(new i = 0; i < gZoneCount; i++)
    {
        new Float:dist = GetDistanceBetweenPoints(x, y, z, gZoneData[i][zoneX], gZoneData[i][zoneY], gZoneData[i][zoneZ]);
        
        if(dist <= gZoneData[i][zoneRadius])
        {
            if(gPlayerInZone[playerid] != i)
            {
                gPlayerInZone[playerid] = i;
                OnPlayerEnterDriftZone(playerid, i);
            }
        }
        else if(gPlayerInZone[playerid] == i)
        {
            gPlayerInZone[playerid] = -1;
            OnPlayerExitDriftZone(playerid, i);
        }
    }
}

stock AddDriftPoints(playerid, points)
{
    gPlayerDriftPoints[playerid] += points;
    gPlayerMoney[playerid] += MONEY_PER_DRIFT;
    
    new exp = floatround(points / 10);
    AddPlayerExp(playerid, exp);
}

stock AddPlayerExp(playerid, exp)
{
    gPlayerExp[playerid] += exp;
    
    if(gPlayerExp[playerid] >= (gPlayerLevel[playerid] * EXP_PER_LEVEL))
    {
        gPlayerLevel[playerid]++;
        gPlayerExp[playerid] = 0;
        gPlayerMoney[playerid] += LEVEL_UP_REWARD;
        
        OnPlayerLevelUp(playerid, gPlayerLevel[playerid]);
        
        new playerName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, playerName, sizeof(playerName));
        
        new msg[128];
        format(msg, sizeof(msg), "%s достиг уровня %d!", playerName, gPlayerLevel[playerid]);
        SendClientMessageToAll(COLOR_RANK, msg);
    }
}

// ===== ZONE FUNCTIONS =====

stock CreateDriftZones()
{
    // Зона 1: Downtown
    CreateDriftZone(1440.0, -1040.0, 100.0, 100.0, "Downtown", 100);
    
    // Зона 2: Airport
    CreateDriftZone(380.0, 2450.0, 100.0, 150.0, "Airport", 150);
    
    // Зона 3: Highway
    CreateDriftZone(2410.0, -2370.0, 0.0, 200.0, "Highway", 200);
    
    // Зона 4: Industrial
    CreateDriftZone(-2600.0, 1270.0, 0.0, 120.0, "Industrial", 120);
    
    // Зона 5: Port
    CreateDriftZone(386.0, -3020.0, 5.0, 150.0, "Port", 150);
}

stock CreateDriftZone(Float:x, Float:y, Float:z, Float:radius, name[], points)
{
    if(gZoneCount >= MAX_ZONES) return INVALID_ZONE_ID;
    
    new idx = gZoneCount;
    gZoneData[idx][zoneID] = idx;
    gZoneData[idx][zoneX] = x;
    gZoneData[idx][zoneY] = y;
    gZoneData[idx][zoneZ] = z;
    gZoneData[idx][zoneRadius] = radius;
    gZoneData[idx][zonePoints] = points;
    gZoneData[idx][zoneRecord] = 0;
    format(gZoneData[idx][zoneName], 32, name);
    
    gZoneCount++;
    return idx;
}

// ===== DISPLAY FUNCTIONS =====

stock ShowDriftInfo(playerid)
{
    new msg[512];
    format(msg, sizeof(msg), 
        "=== ИНФОРМАЦИЯ О ДРИФТЕ ===\n\n"
        "Ваши очки: {FFFF00}%d{FFFFFF}\n"
        "Уровень: {00FF00}%d{FFFFFF}\n"
        "Опыт: {00FFFF}%d/%d{FFFFFF}\n"
        "Деньги: {00FF00}$%d{FFFFFF}\n"
        "Текущее комбо: {FF0000}%d{FFFFFF}\n\n"
        "Используйте дрифт-машину и выполняйте трюки!",
        gPlayerDriftPoints[playerid],
        gPlayerLevel[playerid],
        gPlayerExp[playerid],
        gPlayerLevel[playerid] * EXP_PER_LEVEL,
        gPlayerMoney[playerid],
        gPlayerCombo[playerid]);
    
    ShowPlayerDialog(playerid, 100, DIALOG_STYLE_MSGBOX, "Drift Info", msg, "Закрыть", "");
}

stock ShowPlayerStats(playerid)
{
    new msg[512];
    format(msg, sizeof(msg),
        "=== СТАТИСТИКА ===\n"
        "Очки дрифта: %d\n"
        "Уровень: %d\n"
        "Опыт: %d\n"
        "Деньги: $%d\n"
        "Максимальное комбо: %.0f",
        gPlayerDriftPoints[playerid],
        gPlayerLevel[playerid],
        gPlayerExp[playerid],
        gPlayerMoney[playerid],
        gPlayerMaxCombo[playerid]);
    
    SendClientMessage(playerid, COLOR_INFO, msg);
}

stock ShowZonesList(playerid)
{
    new msg[256];
    SendClientMessage(playerid, COLOR_ZONE, "=== ДРИФТ-ЗОНЫ ===");
    
    for(new i = 0; i < gZoneCount; i++)
    {
        format(msg, sizeof(msg), "[%d] %s - Рекорд: %d очков", i+1, gZoneData[i][zoneName], gZoneData[i][zoneRecord]);
        SendClientMessage(playerid, COLOR_ZONE, msg);
    }
}

stock ShowRanking(playerid)
{
    SendClientMessage(playerid, COLOR_RANK, "=== ТАБЛИЦА РЕЙТИНГА ===");
    SendClientMessage(playerid, COLOR_RANK, "Функция будет реализована в следующей версии");
}

stock ShowLevelInfo(playerid)
{
    new msg[256];
    format(msg, sizeof(msg), "Ваш уровень: %d из %d", gPlayerLevel[playerid], MAX_LEVEL);
    SendClientMessage(playerid, COLOR_INFO, msg);
    
    format(msg, sizeof(msg), "Опыт: %d / %d", gPlayerExp[playerid], gPlayerLevel[playerid] * EXP_PER_LEVEL);
    SendClientMessage(playerid, COLOR_INFO, msg);
}

public UpdateRanking()
{
    // Обновление рейтинга
}

public AutoSaveData()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SavePlayerData(i);
        }
    }
}

// ===== DATA FUNCTIONS =====

stock LoadPlayerData(playerid)
{
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    new filepath[256];
    format(filepath, sizeof(filepath), PLAYER_DATA_PATH "%d_%s.ini", playerid, playerName);
    
    // Здесь будет загрузка из файла
    gPlayerLevel[playerid] = START_LEVEL;
}

stock SavePlayerData(playerid)
{
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    new filepath[256];
    format(filepath, sizeof(filepath), PLAYER_DATA_PATH "%d_%s.ini", playerid, playerName);
    
    // Здесь будет сохранение в файл
}

stock ResetPlayerStats(playerid)
{
    gPlayerDriftPoints[playerid] = 0;
    gPlayerLevel[playerid] = START_LEVEL;
    gPlayerExp[playerid] = 0;
    gPlayerMoney[playerid] = 0;
    gPlayerCombo[playerid] = 0;
    gPlayerMaxCombo[playerid] = 0.0;
}

// ===== UTILITY FUNCTIONS =====

stock Float:GetVehicleSpeed(vehicleid)
{
    new Float:x, Float:y, Float:z, Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    return floatsqrt((vx*vx) + (vy*vy) + (vz*vz)) * 200;
}

stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    new Float:dx = x2 - x1;
    new Float:dy = y2 - y1;
    new Float:dz = z2 - z1;
    return floatsqrt((dx * dx) + (dy * dy) + (dz * dz));
}

stock bool:IsPlayerAdmin(playerid)
{
    return (IsPlayerAdmin(playerid) || gPlayerLevel[playerid] >= 30);
}

// Парсинг команды
stock ExtractCmd(const cmdtext[], cmd[], cmdlen)
{
    new idx = 0;
    if(cmdtext[0] == '/') idx = 1;
    
    new cmdidx = 0;
    while(idx < strlen(cmdtext) && cmdtext[idx] != ' ' && cmdidx < cmdlen - 1)
    {
        cmd[cmdidx++] = cmdtext[idx++];
    }
    cmd[cmdidx] = EOS;
}

// Парсинг параметров команды
stock ExtractParams(const cmdtext[], params[], paramslen)
{
    new idx = 0;
    while(idx < strlen(cmdtext) && cmdtext[idx] != ' ') idx++;
    while(idx < strlen(cmdtext) && cmdtext[idx] == ' ') idx++;
    
    new paramsidx = 0;
    while(idx < strlen(cmdtext) && paramsidx < paramslen - 1)
    {
        params[paramsidx++] = cmdtext[idx++];
    }
    params[paramsidx] = EOS;
}

// Получить целое число из строки по позиции
stock GetIntValue(const str[], pos, &result)
{
    new idx = 0, count = 0, value = 0, negative = 0;
    
    while(idx < strlen(str))
    {
        while(str[idx] == ' ') idx++;
        if(!str[idx]) break;
        
        if(count == pos)
        {
            if(str[idx] == '-')
            {
                negative = 1;
                idx++;
            }
            
            while(str[idx] >= '0' && str[idx] <= '9')
            {
                value = value * 10 + (str[idx] - '0');
                idx++;
            }
            
            result = negative ? -value : value;
            return 1;
        }
        
        while(str[idx] != ' ' && str[idx]) idx++;
        count++;
    }
    return 0;
}

// ===== CALLBACKS =====

public OnPlayerDrifting(playerid, Float:angle, Float:speed, points) { }
public OnPlayerEnterDriftZone(playerid, zoneid) { }
public OnPlayerExitDriftZone(playerid, zoneid) { }
public OnPlayerLevelUp(playerid, newlevel) { }
public OnPlayerZoneRecord(playerid, zoneid, score) { }
public OnComboBreak(playerid, combo, points) { }
