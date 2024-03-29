APLM = {}

local onlineMessages = {
    "G'day TEXTTOREPLACE!",
    "Evening TEXTTOREPLACE!",
    "Ello mates! (TEXTTOREPLACE)"
}
local maxOnlineMesssageLength = 255 - 14; --14 is the max length of the longest onlineMessage
local enteredWorld = false;
local guildRosterUpdated = 0;
local notFired = true;
local guildChatAvailable = false;
local player = UnitName("player");

function APLM.SendRandomOnlineMessage(names)
    if (strlen(names) > 1) then
        local msgToSend = onlineMessages[math.random(1, table.getn(onlineMessages))];
        msgToSend = string.gsub(msgToSend, "TEXTTOREPLACE", names);
        SendChatMessage(msgToSend, "GUILD");
    end
end

function APLM.iterateGuildMembers()
    GuildRoster();
    local names = "";
    local clippedName = "";
    local numTotalMembers = GetNumGuildMembers();
    for i=1,numTotalMembers do
        local name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i);
        if online then
            clippedName = strsplit("-", name);
            if ((clippedName ~= nil) and (clippedName ~= "") and (clippedName ~= player)) then

                if (string.sub(names, 1, 2) == ", ") then names = string.sub(names, 3, strlen(names)) end
                if (string.sub(names, 1, 1) == ",") then names = string.sub(names, 2, strlen(names)) end
                

                if ((strlen(names..clippedName) +2) <= maxOnlineMesssageLength) then
                    names = names..", "..clippedName;
                else
                    APLM.SendRandomOnlineMessage(names);
                    names = "";
                end
            end
        end
    end
    APLM.SendRandomOnlineMessage(names);
    notFired = false;
end

function APLM.doMessagesMaybe()
    if (enteredWorld and guildRosterUpdated >= 2 and notFired and guildChatAvailable) then
        APLM.iterateGuildMembers();
    else
        GuildRoster(); 
    end
end

function APLM.logonHandler(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        local initialLogin = ...;
        if initialLogin then
            enteredWorld = true;
        end
    elseif (event == "GUILD_ROSTER_UPDATE" and enteredWorld) then
        guildRosterUpdated = guildRosterUpdated +1;
    elseif (event == "CLUB_STREAM_SUBSCRIBED" and enteredWorld) then
        guildChatAvailable = true;
    end
    APLM.doMessagesMaybe();
end

SLASH_APLM1 = '/APLM'
SlashCmdList['APLM'] = function(msg)
    APLM.iterateGuildMembers();
end
SendChatMessage("wat", "GUILD");
local frame = CreateFrame("Frame", "APLMAddonFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("GUILD_ROSTER_UPDATE");
frame:RegisterEvent("CLUB_STREAM_SUBSCRIBED");
frame:SetScript("OnEvent", APLM.logonHandler);