junkUI = {boxSize = {x = 430, y = 80},
          colors = {frame = {0, 50, 255}}}

function junkUI.drawType(InventoryMaid, t)
    ImGui.BeginChild(t.typeName, junkUI.boxSize.x, junkUI.boxSize.y, true)
    InventoryMaid.CPS.colorBegin("Text", junkUI.colors.frame)
    ImGui.Text(t.typeName)
    ImGui.Separator()
    t.sellType = ImGui.Checkbox("Sell "..t.typeName, t.sellType)
    t.percent = ImGui.SliderInt("Sell %", t.percent, 0, 100, "%d%%")
    InventoryMaid.CPS.colorEnd(1)
    ImGui.EndChild()
end

function junkUI.draw(InventoryMaid)
    InventoryMaid.CPS.colorBegin("Border", junkUI.colors.frame)
    InventoryMaid.CPS.colorBegin("Separator", junkUI.colors.frame)
    
    for _, v in pairs(InventoryMaid.settings.junkSettings) do 
        junkUI.drawType(InventoryMaid, v)
    end

    InventoryMaid.CPS.colorEnd(2)
end

return junkUI