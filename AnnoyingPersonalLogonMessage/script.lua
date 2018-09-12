SLASH_APLM1 = '/APLM'
SlashCmdList['APLM'] = function(msg)
    print(msg);
end

local onlineMessages = {
    "G'day $$$$$!",
    "Evening $$$$$!",
    "Ello mates! ($$$$$)"
}
local maxOnlineMesssageLength = 255 - 14; --14 is the max length of the longest onlineMessage
local enteredWorld = false;
local guildRosterUpdated = false;
local notFired = true;

local function SendRandomOnlineMessage(names)
    print(names);
end

local function iterateGuildMembers()
    
    local names = "";
    local numTotalMembers = GetNumGuildMembers();
    for i=1,numTotalMembers do
        local name, online = GetGuildRosterInfo(i);
        if online then
            print(name);
            if ((strlen(names..name) +1) <= maxOnlineMesssageLength) then
                names = names..","..name;
                print(names);
            else
                SendRandomOnlineMessage(names);
                names = "";
            end
        end
    end
    notFired = false;
end

local function doMessagesMaybe(logon,roster)
    if (logon and roster and notFired) then
        iterateGuildMembers();
    else
        GuildRoster(); 
    end
end

local function logonHandler(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        local initialLogin = ...;
        if initialLogin then
            enteredWorld = true;
        end
    elseif (event == "GUILD_ROSTER_UPDATE") then
        guildRosterUpdated = true;
    end
    doMessagesMaybe(enteredWorld,guildRosterUpdated)
end

local frame = CreateFrame("Frame", "APLMAddonFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:SetScript("OnEvent", logonHandler);