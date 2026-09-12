// SA-MP Rewards FilterScript
// ===========================

#include <a_samp>
#include "../includes/drift.inc"

enum RewardData
{
    rewardID,
    rewardType, // 0: Money, 1: Vehicle, 2: Skin
    rewardValue,
    rewardLevel
};

new gRewards[20][RewardData];

public OnFilterScriptInit()
{
    print("SA-MP Rewards FilterScript Loaded");
    LoadRewards();
    return 1;
}

stock LoadRewards()
{
    // Награды за уровни
    gRewards[0][rewardType] = 0; // Money
    gRewards[0][rewardValue] = 1000;
    gRewards[0][rewardLevel] = 5;
    
    gRewards[1][rewardType] = 0; // Money
    gRewards[1][rewardValue] = 5000;
    gRewards[1][rewardLevel] = 10;
    
    gRewards[2][rewardType] = 1; // Vehicle
    gRewards[2][rewardValue] = 421; // Futo
    gRewards[2][rewardLevel] = 15;
}

stock GiveReward(playerid, rewardid)
{
    if(rewardid < 0 || rewardid >= 20) return 0;
    
    switch(gRewards[rewardid][rewardType])
    {
        case 0: // Money
        {
            GivePlayerMoney(playerid, gRewards[rewardid][rewardValue]);
            SendClientMessage(playerid, COLOR_SUCCESS, "Вы получили награду!");
        }
        case 1: // Vehicle
        {
            SendClientMessage(playerid, COLOR_SUCCESS, "Вы получили новое транспортное средство!");
        }
        case 2: // Skin
        {
            SetPlayerSkin(playerid, gRewards[rewardid][rewardValue]);
            SendClientMessage(playerid, COLOR_SUCCESS, "Ваш скин изменён!");
        }
    }
    return 1;
}