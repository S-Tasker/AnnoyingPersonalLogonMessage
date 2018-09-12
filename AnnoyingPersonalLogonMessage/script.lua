SLASH_APLM1 = '/APLM'
SlashCmdList['APLM'] = function(msg)
    print(msg);
end

local function logonHandler(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        local initialLogin = ...;
        if initialLogin then
            --Fire Events here
        end
    end
end

local frame = CreateFrame("Frame", "APLMAddonFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:SetScript("OnEvent", logonHandler);