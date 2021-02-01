fileSysUI = {nameText = "", 
			saveBoxSize = {x = 430, y = 67},
			colors = {frame = {0, 50, 255}},
			statusText = ""}

function fileSysUI.saveFilter(InventoryMaid, slot, name)
	if name == "" then
		name = InventoryMaid.settings.fileSettings.tableNames[slot]
	end
	InventoryMaid.settings.fileSettings.currentName = name
	local file = io.open(InventoryMaid.rootPathIO.."saves/slot"..slot..".json", "w")
	io.output(file)
	local jconfig = json.encode(InventoryMaid.settings)
	io.write(jconfig)
	file:close()
end

function fileSysUI.loadFilter(InventoryMaid, slot)
	local file = io.open(InventoryMaid.rootPathIO.."saves/slot"..slot..".json", "r")
	io.input(file)
	local config = json.decode(io.read("*a"))
	file:close()
	InventoryMaid.settings = config
end

function fileSysUI.loadNames(InventoryMaid)
	if not InventoryMaid.fileExists(InventoryMaid.rootPathIO.."saves/slot1.json") then
		fileSysUI.resetSlot(InventoryMaid, 1)
	end
	if not InventoryMaid.fileExists(InventoryMaid.rootPathIO.."saves/slot2.json") then
		fileSysUI.resetSlot(InventoryMaid, 2)
	end
	if not InventoryMaid.fileExists(InventoryMaid.rootPathIO.."saves/slot3.json") then
		fileSysUI.resetSlot(InventoryMaid, 3)
	end
	if not InventoryMaid.fileExists(InventoryMaid.rootPathIO.."saves/slot4.json") then
		fileSysUI.resetSlot(InventoryMaid, 4)
	end
	if not InventoryMaid.fileExists(InventoryMaid.rootPathIO.."saves/slot5.json") then
		fileSysUI.resetSlot(InventoryMaid, 5)
	end

	local slot1 = io.open(InventoryMaid.rootPathIO.."saves/slot1.json", "r")
	io.input(slot1)
	local config1 = json.decode(io.read("*a"))
	slot1:close()

	local slot2 = io.open(InventoryMaid.rootPathIO.."saves/slot2.json", "r")
	io.input(slot2)
	local config2 = json.decode(io.read("*a"))
	slot2:close()

	local slot3 = io.open(InventoryMaid.rootPathIO.."saves/slot3.json", "r")
	io.input(slot3)
	local config3 = json.decode(io.read("*a"))
	slot3:close()

	local slot4 = io.open(InventoryMaid.rootPathIO.."saves/slot4.json", "r")
	io.input(slot4)
	local config4 = json.decode(io.read("*a"))
	slot4:close()

	local slot5 = io.open(InventoryMaid.rootPathIO.."saves/slot5.json", "r")
	io.input(slot5)
	local config5 = json.decode(io.read("*a"))
	slot5:close()

	InventoryMaid.settings.fileSettings.tableNames[1] = config1.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[2] = config2.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[3] = config3.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[4] = config4.fileSettings.currentName
	InventoryMaid.settings.fileSettings.tableNames[5] = config5.fileSettings.currentName
end

function fileSysUI.resetSlot(InventoryMaid, slot)
		local default = io.open(InventoryMaid.rootPathIO.."saves/default.json", "r")
		io.input(default)
		local defaultConfig = json.decode(io.read("*a"))
		default:close()

		local s = io.open(InventoryMaid.rootPathIO.."saves/slot"..slot..".json", "w")
		io.output(s)
		local dc = json.encode(defaultConfig)
		io.write(dc)
		s:close()
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
	tooltips = require (InventoryMaid.rootPath.. ".utility.tooltips")

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
