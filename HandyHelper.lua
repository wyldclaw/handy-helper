HandyHelper = LibStub('AceAddon-3.0'):NewAddon('HandyHelper', 'AceConsole-3.0')
local HandyHelper = HandyHelper

local AceGUI = LibStub('AceGUI-3.0')

local frame = AceGUI:Create('Frame')
frame:SetTitle('Handy Helper')
frame:SetCallback('OnClose', function(widget) AceGUI:Release(widget) end)
frame:SetWidth(300)

local idBox = AceGUI:Create('EditBox')
idBox:SetLabel('Achievement ID:')
idBox:SetFullWidth(true)
idBox:DisableButton(true)
idBox:SetText('1312')
frame:AddChild(idBox)

local button = AceGUI:Create('Button')
button:SetText('Get Criteria')
button:SetFullWidth(true)
button:SetCallback('OnClick', function() HandyHelper:GenerateAchievementReward(idBox:GetText()) end)
frame:AddChild(button)

local nameBox = AceGUI:Create('EditBox')
nameBox:SetLabel('Achievement Name:')
nameBox:SetFullWidth(true)
nameBox:DisableButton(true)
frame:AddChild(nameBox)

local iconBox = AceGUI:Create('EditBox')
iconBox:SetLabel('Achievement Icon:')
iconBox:SetFullWidth(true)
iconBox:DisableButton(true)
frame:AddChild(iconBox)

local criteriaBox = AceGUI:Create('MultiLineEditBox')
criteriaBox:SetLabel('Achievement Criteria:')
criteriaBox:SetFullWidth(true)
criteriaBox:DisableButton(true)
criteriaBox:SetNumLines(17)
frame:AddChild(criteriaBox)

function HandyHelper:GenerateAchievementReward (achievementID)
    local ok, name, image = HandyHelper:GetAchievementInfo(achievementID)
    if (ok == true and not (name == nil)) then
        nameBox:SetText(name)
        iconBox:SetText(image)
        local criteria = HandyHelper:GetAchievementCriteria(achievementID)
        local reward = 'Achievement({\n    id = ' .. achievementID .. ',\n    criteria = {\n'
        for i = 1, #criteria do
            reward = reward .. '        ' .. criteria[i].id .. ', -- ' .. criteria[i].str .. '\n'
        end
        reward = reward .. '    }\n}) -- ' .. name
        criteriaBox:SetText(reward)
        criteriaBox:SetFocus()
    else
        criteriaBox:SetText('')
    end
end

function HandyHelper:GetAchievementInfo (achievementID)
    local ok, _, name, _, _, _, _, _, _, _, image = pcall(GetAchievementInfo, achievementID)
    return ok, name, image
end

function HandyHelper:GetAchievementCriteria (achievementID)
    criteria = {}
    numCriteria = GetAchievementNumCriteria(achievementID)
    for i = 1, numCriteria, 1 do
        criteriaString, _, _, _, _, _, _, _, _, criteriaID = GetAchievementCriteriaInfo(achievementID, i)
        criteria[i] = {id = criteriaID, str = criteriaString}
    end
    return criteria
end

-- /run for i = 1, GetNumTitles(), 1 do print(i..":"..(GetTitleName(i) or "nil"))end
