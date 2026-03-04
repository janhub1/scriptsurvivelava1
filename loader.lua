print("[XENO DEBUG] Loader start")

local key = "aVysHSYBTqIuFaQW"   -- ← ZKONTROLUJ, ŽE TO JE PŘESNĚ STEJNÝ KLÍČ JAKO V C#

local function decrypt(data, key)
    print("[DEBUG] Dešifrování start | délka dat: " .. #data)
    local res = {}
    for i = 1, #data do
        local k = key:byte((i - 1) % #key + 1)
        local c = data:byte(i)
        if not k or not c then
            print("[CHYBA] Nil na indexu " .. i .. " | k=" .. tostring(k) .. " c=" .. tostring(c))
            return nil
        end
        local xored = bit32.bxor(c, k)
        local safe = bit32.band(xored, 0xFF)
        res[i] = string.char(safe)
    end
    local result = table.concat(res)
    print("[DEBUG] Dešifrováno | délka: " .. #result)
    print("[DEBUG] Prvních 60 znaků decoded: " .. result:sub(1, 60))
    return result
end

local url = "https://raw.githubusercontent.com/janhub1/scriptsurvivelava1/main/payload.xor"

print("[DEBUG] Stahuji z: " .. url)
local success, encrypted = pcall(function()
    return game:HttpGet(url, true)
end)

if not success then
    print("[CHYBA] Stahování selhalo: " .. tostring(encrypted))
    return
end

print("[DEBUG] Stáhnuto OK | délka encrypted: " .. #encrypted)

local decoded = decrypt(encrypted, key)
if not decoded or #decoded == 0 then
    print("[CHYBA] Decoded je nil nebo prázdné!")
    return
end

print("[DEBUG] Pokus o loadstring...")
local func, err = loadstring(decoded)
if not func then
    print("[CHYBA] loadstring selhal: " .. tostring(err))
    print("[DEBUG] Prvních 300 znaků decoded pro kontrolu: " .. decoded:sub(1, 300))
    return
end

print("[DEBUG] loadstring OK → spouštím skript")
func()
print("[DEBUG] Skript dokončen")
