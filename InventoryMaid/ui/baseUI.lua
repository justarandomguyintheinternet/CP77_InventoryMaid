baseUI = {

}

function baseUI.Draw(InventoryMaid)
    wWidth, wHeight = GetDisplayResolution()

    baseUI.fileSysUI = require ("ui/modules/fileSysUI.lua")
    baseUI.generalUI = require ("ui/modules/generalUI.lua")
    baseUI.weaponUI = require ("ui/modules/weaponUI.lua")
    baseUI.armorUI = require ("ui/modules/armorUI.lua")
    baseUI.junkUI = require ("ui/modules/junkUI.lua")

    InventoryMaid.CPS.setThemeBegin()
    ImGui.Begin("InventoryMaid v.1.3")
    ImGui.SetWindowPos(wWidth/2-250, wHeight/2-400, ImGuiCond.FirstUseEver)
    ImGui.SetWindowSize(450, 800)

    if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
        InventoryMaid.CPS.styleBegin("TabRounding", 0)

        if ImGui.BeginTabItem("Global") then
            baseUI.generalUI.draw(InventoryMaid)
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Weapon Settings") then
            baseUI.weaponUI.draw(InventoryMaid)
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Armor Settings") then
            baseUI.armorUI.draw(InventoryMaid)
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Junk") then
            baseUI.junkUI.draw(InventoryMaid)
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Load / Save") then
            baseUI.fileSysUI.draw(InventoryMaid)
            ImGui.EndTabItem()
        end
    end
-- End Tabbar

    ImGui.End()
    InventoryMaid.CPS.setThemeEnd()
end

return baseUI