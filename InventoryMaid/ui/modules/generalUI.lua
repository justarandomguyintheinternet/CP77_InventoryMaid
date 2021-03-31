generalUI = {
	
}

generalUI.previewText = "Press the \"Preview selected\" button!"

function generalUI.updateSubOptions(InventoryMaid, update, key)
    if update then
        if key == "sellFilter" then
            InventoryMaid.settings.weaponSettings.sellFilter = InventoryMaid.settings.globalSettings.sellFilter

            InventoryMaid.settings.armorSettings.sellFilter = InventoryMaid.settings.globalSettings.sellFilter
        elseif key == "filterValue" then
            InventoryMaid.settings.weaponSettings.filterValueTopX = InventoryMaid.settings.globalSettings.filterValueTopX
            InventoryMaid.settings.weaponSettings.filterValuePercent = InventoryMaid.settings.globalSettings.filterValuePercent
            InventoryMaid.baseUI.weaponUI.updateSubOptions(InventoryMaid, true, "filterValue")

            InventoryMaid.settings.armorSettings.filterValueTopX = InventoryMaid.settings.globalSettings.filterValueTopX
            InventoryMaid.settings.armorSettings.filterValuePercent = InventoryMaid.settings.globalSettings.filterValuePercent
            InventoryMaid.baseUI.armorUI.updateSubOptions(InventoryMaid, true, "filterValue")
        elseif key == "quality_common" then
            InventoryMaid.settings.weaponSettings.sellQualitys.common = InventoryMaid.settings.globalSettings.sellQualitys.common                       
            InventoryMaid.settings.armorSettings.sellQualitys.common = InventoryMaid.settings.globalSettings.sellQualitys.common                                     
        elseif key == "quality_uncommon" then
            InventoryMaid.settings.weaponSettings.sellQualitys.uncommon = InventoryMaid.settings.globalSettings.sellQualitys.uncommon
            InventoryMaid.settings.armorSettings.sellQualitys.uncommon = InventoryMaid.settings.globalSettings.sellQualitys.uncommon
        elseif key == "quality_rare" then
            InventoryMaid.settings.weaponSettings.sellQualitys.rare = InventoryMaid.settings.globalSettings.sellQualitys.rare
            InventoryMaid.settings.armorSettings.sellQualitys.rare = InventoryMaid.settings.globalSettings.sellQualitys.rare
        elseif key == "quality_epic" then
            InventoryMaid.settings.weaponSettings.sellQualitys.epic = InventoryMaid.settings.globalSettings.sellQualitys.epic
            InventoryMaid.settings.armorSettings.sellQualitys.epic = InventoryMaid.settings.globalSettings.sellQualitys.epic
        elseif key == "quality_legendary" then
            InventoryMaid.settings.weaponSettings.sellQualitys.legendary = InventoryMaid.settings.globalSettings.sellQualitys.legendary
            InventoryMaid.settings.armorSettings.sellQualitys.legendary = InventoryMaid.settings.globalSettings.sellQualitys.legendary
        elseif key == "quality_iconic" then
            InventoryMaid.settings.weaponSettings.sellQualitys.iconic = InventoryMaid.settings.globalSettings.sellQualitys.iconic
            InventoryMaid.settings.armorSettings.sellQualitys.iconic = InventoryMaid.settings.globalSettings.sellQualitys.iconic
        end
    end
end

function generalUI.draw(InventoryMaid)

        tooltips = require ("utility/tooltips.lua")
        tableFunctions = require ("utility/tableFunctions.lua")
        generalUI.sell = require ("sort/sell.lua")
        
    -- Sell filter selection 
        InventoryMaid.settings.globalSettings.sellFilter, changed = ImGui.Combo("Sell filter", InventoryMaid.settings.globalSettings.sellFilter, { "Sell to have only top x left", "Sell worst x %", "Sell x % worse than avg equipped"}, 3, 3)
        generalUI.updateSubOptions(InventoryMaid, changed, "sellFilter")
        ImGui.SameLine()
		ImGui.Button("?")
        tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "sellFilter")
    -- End Sell filter selection 

    -- Sell filter value selection             
        if InventoryMaid.settings.globalSettings.sellFilter == 0 then       
            InventoryMaid.settings.globalSettings.filterValueTopX, changed = ImGui.SliderInt("Filter value (x)", InventoryMaid.settings.globalSettings.filterValueTopX, 0, 25, "%d")
        else      
            InventoryMaid.settings.globalSettings.filterValuePercent, changed = ImGui.SliderInt("Filter value (x)", InventoryMaid.settings.globalSettings.filterValuePercent, 0, 100, "%d%%")
        end
        generalUI.updateSubOptions(InventoryMaid, changed, "filterValue")
    -- End Sell value filter selection 

    -- Sell qualitys selection
        if ImGui.BeginListBox("Sell qualities", 292, 105) then
            ImGui.SetWindowFontScale(1.0)
            backup = tableFunctions.deepcopy(InventoryMaid.settings.globalSettings.sellQualitys)
            InventoryMaid.settings.globalSettings.sellQualitys.common = ImGui.Selectable("Sell common", InventoryMaid.settings.globalSettings.sellQualitys.common)
			InventoryMaid.settings.globalSettings.sellQualitys.uncommon = ImGui.Selectable("Sell uncommon", InventoryMaid.settings.globalSettings.sellQualitys.uncommon)
			InventoryMaid.settings.globalSettings.sellQualitys.rare = ImGui.Selectable("Sell rare", InventoryMaid.settings.globalSettings.sellQualitys.rare)
			InventoryMaid.settings.globalSettings.sellQualitys.epic = ImGui.Selectable("Sell epic", InventoryMaid.settings.globalSettings.sellQualitys.epic)
            InventoryMaid.settings.globalSettings.sellQualitys.legendary = ImGui.Selectable("Sell legendary", InventoryMaid.settings.globalSettings.sellQualitys.legendary)
            InventoryMaid.settings.globalSettings.sellQualitys.iconic = ImGui.Selectable("Sell iconic", InventoryMaid.settings.globalSettings.sellQualitys.iconic)         
            changed_common = backup.common ~= InventoryMaid.settings.globalSettings.sellQualitys.common 
            changed_uncommon = backup.uncommon ~= InventoryMaid.settings.globalSettings.sellQualitys.uncommon 
            changed_rare = backup.rare ~= InventoryMaid.settings.globalSettings.sellQualitys.rare 
            changed_epic = backup.epic ~= InventoryMaid.settings.globalSettings.sellQualitys.epic 
            changed_legendary = backup.legendary ~= InventoryMaid.settings.globalSettings.sellQualitys.legendary 
            changed_iconic = backup.iconic ~= InventoryMaid.settings.globalSettings.sellQualitys.iconic 
            generalUI.updateSubOptions(InventoryMaid, changed_common, "quality_common")
            generalUI.updateSubOptions(InventoryMaid, changed_uncommon, "quality_uncommon")
            generalUI.updateSubOptions(InventoryMaid, changed_rare, "quality_rare")
            generalUI.updateSubOptions(InventoryMaid, changed_epic, "quality_epic")
            generalUI.updateSubOptions(InventoryMaid, changed_legendary, "quality_legendary")
            generalUI.updateSubOptions(InventoryMaid, changed_iconic, "quality_iconic")
            ImGui.EndListBox()
        end  
    -- End Sell qualitys selection

    -- Action buttons
        ImGui.Separator()
        preview = InventoryMaid.CPS:CPButton("Preview selected", 125, 30)
        if preview then       
             generalUI.previewText = generalUI.sell.preview(InventoryMaid)
        end
        ImGui.SameLine()
        ImGui.Text(generalUI.previewText)
        ImGui.Separator()
        sellPressed = InventoryMaid.CPS:CPButton("Sell selected", 125, 30)
        if sellPressed then 
            generalUI.previewText = "Sold!"
            generalUI.sell.sell(InventoryMaid)
        end
        ImGui.SameLine()
        disassemble = InventoryMaid.CPS:CPButton("Disassemble selected", 150, 30)
        if disassemble then
            generalUI.previewText = "Disassembled!"
            generalUI.sell.disassemble(InventoryMaid)
        end
        ImGui.SameLine()
        if (InventoryMaid.CPS:CPButton("Reset", 75, 30)) then
            InventoryMaid.resetSettings()
        end

    -- End Action buttons
end


return generalUI