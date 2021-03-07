grenadeUI = {}

grenadeUI.colors = {frame = {0, 50, 255}, typeText = {255, 0, 0}}
grenadeUI.typeBoxSize = {x = 425, y = 105}

function grenadeUI.drawType(InventoryMaid, t)
    ImGui.BeginChild(t.typeName, grenadeUI.typeBoxSize.x, grenadeUI.typeBoxSize.y, true)
    InventoryMaid.CPS.colorBegin("Text", grenadeUI.colors.frame)
    ImGui.Text(t.displayName)
    ImGui.Separator()
    InventoryMaid.CPS.colorEnd(1)
    t.sellType =  ImGui.Checkbox("Sell items of this type", t.sellType)
    t.sellAll = ImGui.Checkbox("Sell all items of this type", t.sellAll)
    ImGui.SameLine()
    ImGui.Button("?")
    tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "sellAll")
    t.filterValuePercent = ImGui.SliderInt("Filter value (x)", t.filterValuePercent, 0, 100, "%d%%")

    ImGui.EndChild()    
end

function grenadeUI.updateSubOptions(InventoryMaid, update, key)
    if update then
        if key == "toggleAll" then
            for _, k in pairs(InventoryMaid.settings.grenadeSettings.typeOptions) do   
                k.sellType = InventoryMaid.settings.grenadeSettings.sellGrenades
            end
        elseif key == "filterValue" then
            for _, k in pairs(InventoryMaid.settings.grenadeSettings.typeOptions) do   
                k.filterValuePercent = InventoryMaid.settings.grenadeSettings.filterValuePercent
            end
        end
    end
end

function grenadeUI.draw(InventoryMaid)

    tooltips = require ("utility/tooltips.lua")

    if InventoryMaid.settings.grenadeSettings.forceSubOptionsUpdate then
        InventoryMaid.settings.grenadeSettings.forceSubOptionsUpdate = false
        grenadeUI.updateSubOptions(InventoryMaid, true, "filterValue")
    end

-- Sell grenades toggle
    InventoryMaid.settings.grenadeSettings.sellGrenades, changed = ImGui.Checkbox("Sell grenades", InventoryMaid.settings.grenadeSettings.sellGrenades)
    grenadeUI.updateSubOptions(InventoryMaid, changed, "toggleAll")
    ImGui.SameLine()
	ImGui.Button("?")
    tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "toggleSellAll")
-- End Sell grenades toggle

-- Sell filter value selection           
    InventoryMaid.settings.grenadeSettings.filterValuePercent, changed = ImGui.SliderInt("Filter value (x)", InventoryMaid.settings.grenadeSettings.filterValuePercent, 0, 100, "%d%%")
    grenadeUI.updateSubOptions(InventoryMaid, changed, "filterValue")
-- End Sell filter value selection

-- Sell qualitys selection
    if ImGui.BeginListBox("Sell qualities", 292, 70) then
		ImGui.SetWindowFontScale(1.0)
        InventoryMaid.settings.grenadeSettings.sellQualitys.common = ImGui.Selectable("Sell common", InventoryMaid.settings.grenadeSettings.sellQualitys.common)
		InventoryMaid.settings.grenadeSettings.sellQualitys.uncommon = ImGui.Selectable("Sell uncommon", InventoryMaid.settings.grenadeSettings.sellQualitys.uncommon)
		InventoryMaid.settings.grenadeSettings.sellQualitys.rare = ImGui.Selectable("Sell rare", InventoryMaid.settings.grenadeSettings.sellQualitys.rare)
		InventoryMaid.settings.grenadeSettings.sellQualitys.epic = ImGui.Selectable("Sell epic", InventoryMaid.settings.grenadeSettings.sellQualitys.epic)
		ImGui.EndListBox()
    end
-- End Sell qualitys selection

-- Draw type boxes
    InventoryMaid.CPS.colorBegin("Border", grenadeUI.colors.frame)
    InventoryMaid.CPS.colorBegin("Separator", grenadeUI.colors.frame)
    
    for _, k in pairs(InventoryMaid.settings.grenadeSettings.typeOptions) do 
        grenadeUI.drawType(InventoryMaid, k)
    end
    
    InventoryMaid.CPS.colorEnd(2)
-- End Draw type boxes
end

return grenadeUI