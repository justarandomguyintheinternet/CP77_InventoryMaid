fileSysUI = {nameText = "", 
			saveBoxSize = {x = 430, y = 67},
			colors = {frame = {0, 50, 255}},
			statusText = ""}

function fileSysUI.saveFilter(InventoryMaid, slot, name)
	if name == "" then
		name = InventoryMaid.settings.fileSettings.tableNames[slot]
	end
	InventoryMaid.settings.fileSettings.currentName = name
	local file = io.open("saves/slot"..slot..".json", "w")
	local jconfig = json.encode(InventoryMaid.settings)
	file:write(jconfig)
	file:close()
end

function fileSysUI.loadFilter(InventoryMaid, slot)
	tableFunctions = require("utility/tableFunctions")

	local file = io.open("saves/slot"..slot..".json", "r")
	local config = json.decode(file:read("*a"))
	file:close()

	if config.grenadeSettings == nil then
		config.grenadeSettings = tableFunctions.deepcopy(InventoryMaid.originalSettings.grenadeSettings)
	end

	InventoryMaid.settings = config
end

function fileSysUI.loadNames(InventoryMaid)
	if not InventoryMaid.fileExists("saves/slot1.json") then
		fileSysUI.resetSlot(InventoryMaid, 1)
	end
	if not InventoryMaid.fileExists("saves/slot2.json") then
		fileSysUI.resetSlot(InventoryMaid, 2)
	end
	if not InventoryMaid.fileExists("saves/slot3.json") then
		fileSysUI.resetSlot(InventoryMaid, 3)
	end
	if not InventoryMaid.fileExists("saves/slot4.json") then
		fileSysUI.resetSlot(InventoryMaid, 4)
	end
	if not InventoryMaid.fileExists("saves/slot5.json") then
		fileSysUI.resetSlot(InventoryMaid, 5)
	end

	local slot1 = io.open("saves/slot1.json", "r")
	local config1 = json.decode(slot1:read("*a"))
	slot1:close()

	local slot2 = io.open("saves/slot2.json", "r")
	local config2 = json.decode(slot2:read("*a"))
	slot2:close()

	local slot3 = io.open("saves/slot3.json", "r")
	local config3 = json.decode(slot3:read("*a"))
	slot3:close()

	local slot4 = io.open("saves/slot4.json", "r")
	local config4 = json.decode(slot4:read("*a"))
	slot4:close()

	local slot5 = io.open("saves/slot5.json", "r")
	local config5 = json.decode(slot5:read("*a"))
	slot5:close()

	InventoryMaid.settings.fileSettings.tableNames[1] = config1.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[2] = config2.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[3] = config3.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[4] = config4.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[5] = config5.fileSettings.currentName
end

function fileSysUI.resetSlot(InventoryMaid, slot)
		local default = io.open("saves/default.json", "r")
		local defaultConfig = json.decode(default:read("*a"))
		default:close()

		local s = io.open("saves/slot"..slot..".json", "w")
		local dc = json.encode(defaultConfig)
		s:write(dc)
		s:close()
end

function fileSysUI.writeStartup(InventoryMaid)
	local file = io.open("saves/startup.json", "w")
	local jconfig = json.encode(InventoryMaid.standardSlot)
	file:write(jconfig)
	file:close()
end

function fileSysUI.drawSlot(InventoryMaid, slot)
	ImGui.BeginChild("slot"..slot, fileSysUI.saveBoxSize.x, fileSysUI.saveBoxSize.y, true)
	InventoryMaid.CPS.colorBegin("Text", fileSysUI.colors.frame)
	title = "Slot ".. slot .. " | ".. InventoryMaid.settings.fileSettings.tableNames[slot]
    ImGui.Text(title)
	ImGui.Separator()

	l = InventoryMaid.CPS.CPButton("Load", 60, 30)
	ImGui.SameLine()
	save = InventoryMaid.CPS.CPButton("Save", 60, 30)
	ImGui.SameLine()
	reset = InventoryMaid.CPS.CPButton("Reset", 60, 30)
	ImGui.SameLine()
-- Handle load on start
	state = false
	if InventoryMaid.standardSlot == slot then
		state = true
	end

	state, changed = ImGui.Checkbox("Load with start", state)
	if state == true and changed then
		InventoryMaid.standardSlot = slot
		fileSysUI.writeStartup(InventoryMaid)
	elseif state == false and changed then
		InventoryMaid.standardSlot = 0
		fileSysUI.writeStartup(InventoryMaid)
	end
-- End Handle load on start
	InventoryMaid.CPS.colorEnd(1)
	ImGui.EndChild()
	if l then
		fileSysUI.loadFilter(InventoryMaid, slot)
		fileSysUI.statusText = "Loaded \""..InventoryMaid.settings.fileSettings.currentName.."\" from slot ".. slot
	end
	if save then
		fileSysUI.saveFilter(InventoryMaid, slot, fileSysUI.nameText)
		fileSysUI.statusText = "Saved \""..InventoryMaid.settings.fileSettings.currentName.."\" to slot ".. slot
	end
	if reset then
		fileSysUI.resetSlot(InventoryMaid, slot)
		fileSysUI.statusText = "Reset slot ".. slot
	end
end

function fileSysUI.draw(InventoryMaid)

	fileSysUI.loadNames(InventoryMaid)
	tooltips = require ("utility/tooltips.lua")

	fileSysUI.nameText = ImGui.InputTextWithHint("Enter a name", "Name...",fileSysUI.nameText, 100)
	ImGui.SameLine()
    ImGui.Button("?")
	tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "saveName")
	ImGui.Separator()

	InventoryMaid.CPS.colorBegin("Border", fileSysUI.colors.frame)
	InventoryMaid.CPS.colorBegin("Separator", fileSysUI.colors.frame)
	
	fileSysUI.drawSlot(InventoryMaid, 1)
	fileSysUI.drawSlot(InventoryMaid, 2)
	fileSysUI.drawSlot(InventoryMaid, 3)
	fileSysUI.drawSlot(InventoryMaid, 4)
	fileSysUI.drawSlot(InventoryMaid, 5)

	InventoryMaid.CPS.colorEnd(2)
	ImGui.Text(fileSysUI.statusText)
end

return fileSysUI
