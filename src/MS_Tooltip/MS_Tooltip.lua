-- MS_Tooltip
--
-- Displays which specs should roll for MS on raid epics.
-- 

MS_Tooltip = {}

MS_Tooltip.Name = "MS_Tooltip"
MS_Tooltip.Version = "1.5.5"
MS_Tooltip.Enabled = 0
MS_Tooltip.Colors = {
    red = "ffff0000",
    green = "ff00ff00",
    yellow = "ffffff00",
    gray = "ff999999",
    orange = "ffe66600",
}

MS_Tooltip.SlashCmd = "mstt"
MS_Tooltip.Title = MS_Tooltip.Name.." v"..MS_Tooltip.Version

MS_Tooltip.Cmds = {
    {
        cmd = "help",
        desc = "Displays this message.",
        cb = function() MS_Tooltip:Help() end
    }
}

function MS_Tooltip:OnLoad()

    SLASH_MS_Tooltip1 = "/"..MS_Tooltip.SlashCmd
    SlashCmdList["MS_Tooltip"] = function(msg)
        MS_Tooltip:SlashCommandHandler(msg)
    end

    GameTooltip:HookScript("OnTooltipSetItem", MS_Tooltip_setTooltip)

    MS_Tooltip:Print(MS_Tooltip:Color("green")..MS_Tooltip.Title.." Loaded - "..SLASH_MS_Tooltip1)
end

function MS_Tooltip:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function MS_Tooltip:Color(col)
    return "|c"..MS_Tooltip.Colors[col]
end

function MS_Tooltip:ClassColor(str)
    if strsub(str,1,4) == "Mage" then -- Mage
        return {0.25, 0.78, 0.92}
    elseif str == "Warlock" then -- Warlock
        return {0.53,0.53,0.93}
    elseif str == "Hunter" then -- Hunter
        return {0.67, 0.83, 0.45}
    elseif strsub(str,1,1) == "D" then -- Druid
        return {1.0,0.49,0.04}
    elseif strsub(str,1,1) == "W" then -- Warrior
        return {0.78,0.61,0.43}
    elseif strsub(str,1,1) == "R" then -- Rogue
        return {1,0.96,0.41}
    elseif strsub(str,1,1) == "S" then -- Shaman
        return {0.00,0.44,0.87}
    elseif strsub(str,1,2) == "Pa" then -- Paladin
        return {0.96,0.55,0.73}
    elseif strsub(str,1,1) == "P" then -- Priest
        return {1,1,1}
    else
        return {1,1,1}
    end
end

function MS_Tooltip:SlashCommandHandler(msg)
    if( msg ) then
        local command = string.lower(msg)

        local i = 0

        for k,o in pairs(MS_Tooltip.Cmds) do
            if command == o["cmd"] then
                --MS_Tooltip:Print(MS_Tooltip:Color("green").."You triggered command '"..MS_Tooltip:Color("yellow")..o["cmd"]..MS_Tooltip:Color("green").."'")
                if o.cb then
                    o.cb()
                end
                i = i+1
                break
            end
        end
        if i==0 then
            MS_Tooltip:Print(MS_Tooltip:Color("yellow").."Unknown command " ..MS_Tooltip:Color("green").."/"..MS_Tooltip.SlashCmd.." "..msg);
            MS_Tooltip:Help()
        end
    else
        MS_Tooltip:Help()
    end
end

function MS_Tooltip:Help()
    MS_Tooltip:Print(MS_Tooltip:Color("green")..MS_Tooltip.Title..MS_Tooltip:Color("yellow").." : Usage - /"..MS_Tooltip.SlashCmd.." option");
    for k,o in pairs(MS_Tooltip.Cmds) do
        MS_Tooltip:Print(MS_Tooltip:Color("green").."/"..MS_Tooltip.SlashCmd.." "..MS_Tooltip:Color("yellow")..o
            ["cmd"]..MS_Tooltip:Color("green")..MS_Tooltip:Color("yellow")..MS_Tooltip:Color("green")..": "..o["desc"])
    end
    MS_Tooltip:Print(MS_Tooltip:Color("green").."Usage - /"..MS_Tooltip.SlashCmd.." option");
end

function MS_Tooltip:getItemString(link)
    if not link then
        return nil;
    end
    local itemString = string.find(link, "item[%-?%d:]+");
    itemString = strsub(link, itemString, string.len(link)-(string.len(link)-2)-6);
    return itemString;
end

function MS_Tooltip:getItemID(iString)
    if not iString or not string.find(iString, "item:") then
        return nil;
    end
    local itemString = string.sub(iString, 6, string.len(iString)-1)--"^[%-?%d:]+");
    return string.sub(itemString, 1, string.find(itemString, ":")-1);
end

function MS_Tooltip:itemExists(id)
    if not id or not tonumber(id) then return false; end
    if C_Item.DoesItemExistByID(tonumber(id)) then
        return true;
    else
        return false;
    end
end

function MS_Tooltip:Length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function MS_Tooltip:Draw(prio, specs)
    if MS_Tooltip:Length(specs) == 0 then return end
    GameTooltip:AddLine("  "..prio..":", {1,1,1})
    for i = 1,MS_Tooltip:Length(specs),2 do
        if i == MS_Tooltip:Length(specs) then
            GameTooltip:AddLine("    "..specs[i],MS_Tooltip:ClassColor(specs[i])[1],MS_Tooltip:ClassColor(specs[i])[2],MS_Tooltip:ClassColor(specs[i])[3])
        else
            GameTooltip:AddDoubleLine("    "..specs[i],specs[i+1],MS_Tooltip:ClassColor(specs[i])[1],MS_Tooltip:ClassColor(specs[i])[2],MS_Tooltip:ClassColor(specs[i])[3],MS_Tooltip:ClassColor(specs[i+1])[1],MS_Tooltip:ClassColor(specs[i+1])[2],MS_Tooltip:ClassColor(specs[i+1])[3])
        end
    end
end

function MS_Tooltip_setTooltip(self)
    local _, link = self:GetItem()
    local id = tonumber(MS_Tooltip:getItemID(MS_Tooltip:getItemString(link)))
    if not MS_Tooltip:itemExists(tonumber(id)) then return; end
    for raid, items in pairs(MS_Items) do
        for k, o in pairs(items) do
            if id == k then
                GameTooltip:AddLine(" ", {1,1,1})
                GameTooltip:AddLine("Loot priority v"..MS_Tooltip.Version, {1,1,1})
                p = 0
                p1 = 0
                for prio, specs in pairs(o) do
                    p1 = p1+1
                    if prio == 'PRIO' then
                        MS_Tooltip:Draw(prio, specs)
                        p = p1
                    end
                end
                p2 = 0
                for prio, specs in pairs(o) do
                    p2 = p2+1
                    if p2 == p then
                    else
                        if prio == "Notes" then
                        else
                            MS_Tooltip:Draw(prio,specs)
                        end
                    end
                end
                for prio, specs in pairs(o) do
                    if prio == "Notes" then
                        GameTooltip:AddLine("Notes:",{1,1,1})
                        GameTooltip:AddLine("  "..specs,{1,1,1})
                    end
                end
            end
        end
    end
end
