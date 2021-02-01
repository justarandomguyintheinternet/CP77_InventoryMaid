tableFunctions = {}

function tableFunctions.deepcopy(origin)
    local orig_type = type(origin)
    local copy
    if orig_type == 'table' then
        copy = {}
        for origin_key, origin_value in next, origin, nil do
            copy[tableFunctions.deepcopy(origin_key)] = tableFunctions.deepcopy(origin_value)
        end
        setmetatable(copy, tableFunctions.deepcopy(getmetatable(origin)))
    else
        copy = origin
    end
    return copy
end

function tableFunctions.getIndex(tab, val)
    local index = nil
    for i, v in ipairs(tab) do
		if v == val then
			index = i
		end
    end
    return index
end

function tableFunctions.removeItem(tab, val)
    table.remove(tab, tableFunctions.getIndex(tab, val))
end

function tableFunctions.getLength(tab)
    local count = 0
    for _ in pairs(tab) do 
        count = count + 1 
    end
    return count
end

function tableFunctions.contains(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    
    return false
end

return tableFunctions