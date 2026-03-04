print("[DEBUG] Loader startuje v Xeno")

local key = "aVysHSYBTqIuFaQW"  -- ← ujisti se, že to je přesně stejný klíč jako v C#

local function decrypt(data, key)
    print("[DEBUG] Začíná dešifrování, délka dat: " .. #data)
    local res = {}
    for i = 1, #data do
        local k = key:byte((i - 1) % #key + 1)
        local c = data:byte(i)
        if not k or not c then
            print("[DEBUG] Chyba na indexu " .. i .. ": k=" .. tostring(k) .. ", c=" .. tostring(c))
            return nil
        end
        local xored = bit32.bxor(c, k)
        local banded = bit32.band(xored, 0xFF)
        res[i] = string.char(banded)
    end
    local result = table.concat(res)
    print("[DEBUG] Dešifrování hotovo, délka výsledku: " .. #result)
    print("[DEBUG] Prvních 50 znaků dešifrovaného kódu: " .. result:sub(1, 50))
    return result
end

local url = "https://raw.githubusercontent.com/janhub1/scriptsurvivelava1/main/payload.xor"

print("[DEBUG] Stahuji payload z: " .. url)
local success, encrypted = pcall(function()
    return game:HttpGet(url, true)
end)

if not success then
    print("[DEBUG] Stahování selhalo: " .. tostring(encrypted))
    return
end

print("[DEBUG] Payload stáhnut, délka: " .. #encrypted)
print("[DEBUG] Prvních 50 znaků encrypted: " .. encrypted:sub(1, 50))

local decoded = decrypt(encrypted, key)
if not decoded then
    print("[DEBUG] Dešifrování selhalo – decoded je nil")
    return
end

print("[DEBUG] Pokouším se spustit loadstring...")
local func, err = loadstring(decoded)
if not func then
    print("[DEBUG] loadstring selhal: " .. tostring(err))
    print("[DEBUG] Prvních 200 znaků decoded pro kontrolu: " .. decoded:sub(1, 200))
    return
end

print("[DEBUG] loadstring OK – spouštím...")
func()
print("[DEBUG] Skript dokončen")
