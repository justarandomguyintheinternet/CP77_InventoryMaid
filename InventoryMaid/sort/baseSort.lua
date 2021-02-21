baseSort = {}

baseSort.slots = {
	"FeetClothing",
	"HeadArmor",
	"ChestArmor",
	"InnerChest",
	"InnerChestArmor",
	"FaceArmor",
	"LegArmor",
    "Weapon"
}

baseSort.ssc = Game.GetScriptableSystemsContainer()
baseSort.equipmentSystem = baseSort.ssc:Get("EquipmentSystem")
baseSort.ps = Game.GetPlayerSystem()	
baseSort.player = baseSort.ps:GetLocalPlayerMainGameObject()
baseSort.espd = baseSort.equipmentSystem:GetPlayerData(baseSort.player)
baseSort.ss = Game.GetStatsSystem()
baseSort.ts = Game.GetTransactionSystem()

baseSort.equippedList = {weapons = {}, armor = {}}
baseSort.weaponList = {listAll = {}, listTypes = {}}
baseSort.armorList = {listAll = {}, listTypes = {}}
baseSort.nItems = 0

baseSort.finalSellList = {}

function baseSort.avgEquipped(type)
	avg = 0
	if type == "EffectiveDPS" then
		for _, v in ipairs(baseSort.equippedList.weapons) do
			stat = v:GetStatsObjectID()
			avg = avg + baseSort.ss:GetStatValue(stat, 'EffectiveDPS')
		end
		return avg / tableFunctions.getLength(baseSort.equippedList.weapons)
	else
		for _, v in ipairs(baseSort.equippedList.armor) do
			stat = v:GetStatsObjectID()
			avg = avg + baseSort.ss:GetStatValue(stat, 'Armor')
		end
		return avg / tableFunctions.getLength(baseSort.equippedList.armor)
	end
end

function baseSort.getItemLists(InventoryMaid) -- Fills the list for equipped items, weapons and armor
	_, itemList = baseSort.ts:GetItemListByTags(baseSort.player, baseSort.slots, itemList)
	n = 1
	for _,v in ipairs(itemList) do
		baseSort.nItems = baseSort.nItems + 1
		vItemID = v:GetID()	
		statObj = v:GetStatsObjectID()
		itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
		isItemEquipped = baseSort.espd:IsEquipped(vItemID)
		area = itemRecord:EquipArea():Type().value
		quest = baseSort.ts:HasTag(baseSort.player, "Quest", vItemID)
		if (area ~= "BaseFists") and (area ~= "VDefaultHandgun") and not quest then
			if isItemEquipped then
				if area == "Weapon" then
					table.insert(baseSort.equippedList.weapons, v)
				else
					table.insert(baseSort.equippedList.armor, v)
				end
			elseif area == "Weapon" then
				table.insert(baseSort.weaponList.listAll, v)
			else
				table.insert(baseSort.armorList.listAll, v)
			end
		end

	end
end

function baseSort.sortFilter(left, right)
	statL = left:GetStatsObjectID()
	statR = right:GetStatsObjectID()
	armor = baseSort.ss:GetStatValue(statL, 'Armor')
	if armor == 0 then
		return baseSort.ss:GetStatValue(statL, 'EffectiveDPS') < baseSort.ss:GetStatValue(statR, 'EffectiveDPS')
	else
		return baseSort.ss:GetStatValue(statL, 'Armor') < baseSort.ss:GetStatValue(statR, 'Armor')
	end
end

function baseSort.resetLists()
	baseSort.equippedList = {weapons = {}, armor = {}}
	baseSort.weaponList = {listAll = {}, listTypes = {}}
	baseSort.armorList = {listAll = {}, listTypes = {}}
	baseSort.finalSellList = {}
	baseSort.nItems = 0
end

function baseSort.printList(list)
	for _, v in ipairs(list) do
		print("-----------------------")
		vItemID = v:GetID()	
		statObj = v:GetStatsObjectID()
		itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
		name = v:GetNameAsString()
		area = itemRecord:EquipArea():Type().value
		t = itemRecord:ItemType():Type().value
		quality = baseSort.ss:GetStatValue(statObj, 'Quality')
		iconic = baseSort.ss:GetStatValue(statObj, 'IsItemIconic')
		quest = baseSort.ts:HasTag(baseSort.player, "Quest", vItemID)
		print("Name = ", name)
		print("Area = ", area)
		print("Type = ", t)	
		print("Quality = ", quality)
		print("Iconic = ", iconic)
		print("Quest = ", quest)
			
		if area ~= "Weapon" then
			currentItemLevel = baseSort.ss:GetStatValue(statObj, 'Armor')
			print("Armor Rating: ", currentItemLevel)
		else		
			currentItemLevel = baseSort.ss:GetStatValue(statObj, 'EffectiveDPS')
			print("Weapon EffectiveDPS: ",currentItemLevel)
		end
		print("-----------------------")
	end
end

function baseSort.removeQualitys(InventoryMaid, list)
	toRemove = {}
	for _, v in pairs(list) do
		vItemID = v:GetID()	
		itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
		statObj = v:GetStatsObjectID()
		quality = baseSort.ss:GetStatValue(statObj, 'Quality')
		iconic = baseSort.ss:GetStatValue(statObj, 'IsItemIconic')
		area = itemRecord:EquipArea():Type().value
		if area == "Weapon" then
			if not ((InventoryMaid.settings.weaponSettings.sellQualitys.common and quality == 0) or (InventoryMaid.settings.weaponSettings.sellQualitys.uncommon and quality == 1) or (InventoryMaid.settings.weaponSettings.sellQualitys.rare and quality == 2) or (InventoryMaid.settings.weaponSettings.sellQualitys.epic and quality == 3) or (InventoryMaid.settings.weaponSettings.sellQualitys.legendary and quality == 4) or (iconic == 1 and InventoryMaid.settings.weaponSettings.sellQualitys.iconic)) then
				table.insert(toRemove, v)
			end
			if (iconic == 1) and not InventoryMaid.settings.weaponSettings.sellQualitys.iconic then
				table.insert(toRemove, v)
			end
		else
			if not ((InventoryMaid.settings.armorSettings.sellQualitys.common and quality == 0) or (InventoryMaid.settings.armorSettings.sellQualitys.uncommon and quality == 1) or (InventoryMaid.settings.armorSettings.sellQualitys.rare and quality == 2) or (InventoryMaid.settings.armorSettings.sellQualitys.epic and quality == 3) or (InventoryMaid.settings.armorSettings.sellQualitys.legendary and quality == 4) or (iconic == 1 and InventoryMaid.settings.armorSettings.sellQualitys.iconic)) then
				table.insert(toRemove, v)
			end
			if (iconic == 1) and not InventoryMaid.settings.armorSettings.sellQualitys.iconic then
				table.insert(toRemove, v)
			end
		end

	end

	for _, v in pairs(toRemove) do
		tableFunctions.removeItem(list, v)
	end
end

function baseSort.generateTypeLists(InventoryMaid)
	for _, v in ipairs(InventoryMaid.settings.weaponSettings.typeOptions) do
		baseSort.weaponList.listTypes[v.typeName] = {}
	end

	for _, v in ipairs(InventoryMaid.settings.armorSettings.typeOptions) do
		baseSort.armorList.listTypes[v.typeName] = {}
	end

	for _, v in ipairs(baseSort.weaponList.listAll) do
		vItemID = v:GetID()	
		itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
		t = itemRecord:ItemType():Type().value
		table.insert(baseSort.weaponList.listTypes[t], v)
	end

	for _, v in ipairs(baseSort.armorList.listAll) do
		vItemID = v:GetID()	
		itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
		t = itemRecord:ItemType():Type().value
		table.insert(baseSort.armorList.listTypes[t], v)
	end

end

function baseSort.filterSellType(InventoryMaid, list, cat)
	notSellTypes = {}
	toRM = {}
	if cat == "Weapon" then
		s = InventoryMaid.settings.weaponSettings.typeOptions
	else 
		s = InventoryMaid.settings.armorSettings.typeOptions
	end

	for _, x in ipairs(s) do
		if not x.sellType then
			table.insert(notSellTypes, x.typeName)
		end
	end

	for _, v in ipairs(list) do
		vItemID = v:GetID()	
		itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
		statObj = v:GetStatsObjectID()
		t = itemRecord:ItemType():Type().value	
		if tableFunctions.contains(notSellTypes, t) then
			table.insert(toRM, v)
		end
	end

	for _, v in pairs(toRM) do
		tableFunctions.removeItem(list, v)
	end
end

function baseSort.getItemSettings(InventoryMaid, item)
	vItemID = item:GetID()	
	itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
	t = itemRecord:ItemType():Type().value
	area = itemRecord:EquipArea():Type().value
	if area == "Weapon" then
		for _, x in ipairs(InventoryMaid.settings.weaponSettings.typeOptions) do
			if t == x.typeName then
				return x
			end
		end
	else
		for _, x in ipairs(InventoryMaid.settings.armorSettings.typeOptions) do
			if t == x.typeName then
				return x
			end
		end
	end
end

function baseSort.keepTopX(InventoryMaid, list, typeList)
	length = tableFunctions.getLength(list)
	rmList = {}
	if length ~= 0 then
		if typeList then
			if not baseSort.getItemSettings(InventoryMaid, list[1]).sellAll then
				xVal = baseSort.getItemSettings(InventoryMaid, list[1]).filterValueTopX
				if length <= xVal then
					xVal = length	
				end

				for i = 1, length, 1 do 
					if i > length - xVal then
						table.insert(rmList, list[i])
					end
				end
			end
		else
			vItemID = list[1]:GetID()	
			itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
			area = itemRecord:EquipArea():Type().value
			if area == "Weapon" then
				xVal = InventoryMaid.settings.weaponSettings.filterValueTopX
			else
				xVal = InventoryMaid.settings.armorSettings.filterValueTopX
			end

			if length <= xVal then
				xVal = length	
			end

			for i = 1, length, 1 do 
				if i > length - xVal then
					if not baseSort.getItemSettings(InventoryMaid, list[i]).sellAll then
						table.insert(rmList, list[i])
					end
				end
			end

		end

	end

	for _, v in pairs(rmList) do
		tableFunctions.removeItem(list, v)
	end

end

function baseSort.worstXPercent(InventoryMaid, list, typeList)
	length = tableFunctions.getLength(list)
	rmList = {}
	if length ~= 0 then
		if typeList then
			if not baseSort.getItemSettings(InventoryMaid, list[1]).sellAll then
				xVal = baseSort.getItemSettings(InventoryMaid, list[1]).filterValuePercent
				xVal = length - ((xVal / 100) * length)
				if length <= xVal then
					xVal = length	
				end

				for i = 1, length, 1 do 
					if i > length - xVal then
						table.insert(rmList, list[i])
					end
				end
			end
		else
			vItemID = list[1]:GetID()	
			itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
			area = itemRecord:EquipArea():Type().value
			if area == "Weapon" then
				xVal = InventoryMaid.settings.weaponSettings.filterValuePercent
			else
				xVal = InventoryMaid.settings.armorSettings.filterValuePercent
			end
			xVal = length - ((xVal / 100) * length)
			if length <= xVal then
				xVal = length	
			end

			for i = 1, length, 1 do 
				if i > length - xVal then
					if not baseSort.getItemSettings(InventoryMaid, list[i]).sellAll then
						table.insert(rmList, list[i])
					end
				end
			end

		end

	end

	for _, v in pairs(rmList) do
		tableFunctions.removeItem(list, v)
	end
end

function baseSort.sellWorseAvg(InventoryMaid, list, typeList)
length = tableFunctions.getLength(list)
if length ~= 0 then
--Get armor / weapon list
	statType = ""

	vItemID = list[1]:GetID()	
	itemRecord = Game['gameRPGManager::GetItemRecord;ItemID'](vItemID)
	area = itemRecord:EquipArea():Type().value
	if area == "Weapon" then
		statType = "EffectiveDPS"
	else
		statType = "Armor"
	end
--End Get armor / weapon list
	
	rmList = {}
	avgStat = baseSort.avgEquipped(statType)
	
		if typeList then
			if not baseSort.getItemSettings(InventoryMaid, list[1]).sellAll then
				xVal = baseSort.getItemSettings(InventoryMaid, list[1]).filterValuePercent
				for _, v in ipairs(list) do
					stat = v:GetStatsObjectID()
					statValue = baseSort.ss:GetStatValue(stat, statType)
					if statValue > (avgStat * (1- (xVal / 100))) then
						table.insert(rmList, v)
					end
				end
			end
		else	
			if statType == "EffectiveDPS" then
				xVal = InventoryMaid.settings.weaponSettings.filterValuePercent
			else
				xVal = InventoryMaid.settings.armorSettings.filterValuePercent
			end

			for _, v in ipairs(list) do
				stat = v:GetStatsObjectID()
				statValue = baseSort.ss:GetStatValue(stat, statType)
				if statValue > (avgStat * (1- (xVal / 100))) then
					if not baseSort.getItemSettings(InventoryMaid, v).sellAll then
						table.insert(rmList, v)
					end
				end
			end
		end
	
	for _, v in pairs(rmList) do
		tableFunctions.removeItem(list, v)
	end

end
end

function baseSort.generateSellList(InventoryMaid)
	baseSort.resetLists()
	tableFunctions = require ("utility/tableFunctions.lua")

	baseSort.getItemLists(InventoryMaid)

	table.sort(baseSort.weaponList.listAll, baseSort.sortFilter) --Sort by stat
	table.sort(baseSort.armorList.listAll, baseSort.sortFilter)

	baseSort.removeQualitys(InventoryMaid, baseSort.weaponList.listAll) --Remove qualitys the user wants to keep
	baseSort.removeQualitys(InventoryMaid, baseSort.armorList.listAll)

	baseSort.filterSellType(InventoryMaid,  baseSort.armorList.listAll, "Armor") --Remove item types the user wants to keep
	baseSort.filterSellType(InventoryMaid,  baseSort.weaponList.listAll, "Weapon")

	baseSort.generateTypeLists(InventoryMaid)

	if InventoryMaid.settings.weaponSettings.sellPerType then
		for _, v in ipairs(InventoryMaid.settings.weaponSettings.typeOptions) do
			if InventoryMaid.settings.weaponSettings.sellFilter == 0 then
				baseSort.keepTopX(InventoryMaid, baseSort.weaponList.listTypes[v.typeName], true)
			elseif InventoryMaid.settings.weaponSettings.sellFilter == 1 then
				baseSort.worstXPercent(InventoryMaid, baseSort.weaponList.listTypes[v.typeName], true)
			elseif InventoryMaid.settings.weaponSettings.sellFilter == 2 then
				baseSort.sellWorseAvg(InventoryMaid, baseSort.weaponList.listTypes[v.typeName], true)
			end
			for _, x in ipairs(baseSort.weaponList.listTypes[v.typeName]) do
				table.insert(baseSort.finalSellList, x)
			end
		end

	else
		if InventoryMaid.settings.weaponSettings.sellFilter == 0 then
			baseSort.keepTopX(InventoryMaid, baseSort.weaponList.listAll, false)
		elseif InventoryMaid.settings.weaponSettings.sellFilter == 1 then
			baseSort.worstXPercent(InventoryMaid, baseSort.weaponList.listAll, false)
		elseif InventoryMaid.settings.weaponSettings.sellFilter == 2 then
			baseSort.sellWorseAvg(InventoryMaid, baseSort.weaponList.listAll, false)
		end

		for _, v in ipairs(baseSort.weaponList.listAll) do
			table.insert(baseSort.finalSellList, v)
		end
	end

	if InventoryMaid.settings.armorSettings.sellPerType then
		for _, v in ipairs(InventoryMaid.settings.armorSettings.typeOptions) do
			if InventoryMaid.settings.armorSettings.sellFilter == 0 then
				baseSort.keepTopX(InventoryMaid, baseSort.armorList.listTypes[v.typeName], true)
			elseif InventoryMaid.settings.armorSettings.sellFilter == 1 then
				baseSort.worstXPercent(InventoryMaid, baseSort.armorList.listTypes[v.typeName], true)
			elseif InventoryMaid.settings.armorSettings.sellFilter == 2 then
				baseSort.sellWorseAvg(InventoryMaid, baseSort.armorList.listTypes[v.typeName], true)
			end
			for _, x in ipairs(baseSort.armorList.listTypes[v.typeName]) do
				table.insert(baseSort.finalSellList, x)
			end
		end
	else
		if InventoryMaid.settings.armorSettings.sellFilter == 0 then
			baseSort.keepTopX(InventoryMaid, baseSort.armorList.listAll, false)
		elseif InventoryMaid.settings.armorSettings.sellFilter == 1 then
			baseSort.worstXPercent(InventoryMaid, baseSort.armorList.listAll, false)
		elseif InventoryMaid.settings.armorSettings.sellFilter == 2 then
			baseSort.sellWorseAvg(InventoryMaid, baseSort.armorList.listAll, false)
		end
		
		for _, v in ipairs(baseSort.armorList.listAll) do
			table.insert(baseSort.finalSellList, v)
		end
	end
end

return baseSort

--apply filter per list if sell at all: no remove it, sell at all + not sell all apply normal filter, sell at all + sell all do nothing leave on list