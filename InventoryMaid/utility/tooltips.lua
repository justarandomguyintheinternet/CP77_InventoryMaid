tooltips = {}

function tooltips.draw(InventoryMaid, show, key)
    if show then
        if key == "sellFilter" then
            InventoryMaid.CPS:CPToolTip1Begin(300, 190)
            ImGui.TextWrapped("Sell to have only top x left:\n- This ranks your items by stats and only keeps the x best")
            ImGui.Separator()
            ImGui.TextWrapped("Sell worst x %%:\n- This ranks your items by stats and then sells the x %% worst of them (More %% more items)")
            ImGui.Separator()
            ImGui.TextWrapped("Sell x %% worse than avg equipped:\n- This ranks your items by stats and sells those that are x %% worse (Or more) than the average of the equipped items (More %% less items)")
            InventoryMaid.CPS:CPToolTip1End()

        elseif key == "perType" then
            InventoryMaid.CPS:CPToolTip1Begin(300, 110)
            ImGui.TextWrapped("Applys the filter per item type, this means if you set the filter to keep the top 1 item you will keep the best item of each type, instead of the single best weapon in your inventory. Use the filter value slider above to change the value for all types")
            InventoryMaid.CPS:CPToolTip1End()

        elseif key == "sellAll" then
            InventoryMaid.CPS:CPToolTip1Begin(300, 55)
            ImGui.TextWrapped("Sells all items of that type, ignoring the filter type/value, but not the quality filter")
            InventoryMaid.CPS:CPToolTip1End()

        elseif key == "toggleSellAll" then
            InventoryMaid.CPS:CPToolTip1Begin(300, 50)
            ImGui.TextWrapped("Toogles all the \"Sell items of that type\" boxes")
            InventoryMaid.CPS:CPToolTip1End()
        elseif key == "saveName" then
            InventoryMaid.CPS:CPToolTip1Begin(300, 42)
            ImGui.TextWrapped("Leave this empty to keep the name of the slot")
            InventoryMaid.CPS:CPToolTip1End()
        end
    end
end

return tooltips