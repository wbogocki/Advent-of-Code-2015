function LoadShop(filepath)
    local weapons = {}
    local armors = {}
    local rings = {}

    local file = io.open(filepath)

    local lines = file:lines()

    -- Weapons
    for line in lines do
        local words = {}
        for word in line:gmatch("%S+") do table.insert(words, word) end

        if #words == 0 then
            -- end of section
            break
        elseif words[1] ~= "Weapons:" then
            -- data (ignore the header)
            local weapon = {
                name = words[1],
                cost = tonumber(words[2]),
                damage = tonumber(words[3]),
                armor = tonumber(words[4])
            }
            table.insert(weapons, weapon)
        else
            assert(words[1] == "Weapons:")
        end
    end

    -- Armors
    for line in lines do
        local words = {}
        for word in line:gmatch("%S+") do table.insert(words, word) end

        if #words == 0 then
            -- end of section
            break
        elseif words[1] ~= "Armor:" then
            -- data (ignore the header)
            local armor = {
                name = words[1],
                cost = tonumber(words[2]),
                damage = tonumber(words[3]),
                armor = tonumber(words[4])
            }
            table.insert(armors, armor)
        else
            assert(words[1] == "Armor:")
        end
    end

    -- Rings
    for line in lines do
        local words = {}
        for word in line:gmatch("%S+") do table.insert(words, word) end

        if words[1] ~= "Rings:" then
            -- data (ignore the header)
            local ring = {
                name = words[1] .. " " .. words[2],
                cost = tonumber(words[3]),
                damage = tonumber(words[4]),
                armor = tonumber(words[5])
            }
            table.insert(rings, ring)
        else
            assert(words[1] == "Rings:")
        end
    end

    file:close()

    return {weapons = weapons, armors = armors, rings = rings}
end

function EquipmentStats(weapon, armor, ring_1, ring_2)
    return {
        damage = weapon.damage + ring_1.damage + ring_2.damage,
        armor = armor.armor + ring_1.armor + ring_2.armor
    }
end

function EquipmentCost(weapon, armor, ring_1, ring_2)
    return weapon.cost + armor.cost + ring_1.cost + ring_2.cost
end

function Victory(player, boss)
    local player_dar = math.max(1, player.damage - boss.armor)
    local boss_dar = math.max(1, boss.damage - player.armor)

    local player_ttk = math.ceil(player.hp / boss_dar)
    local boss_ttk = math.ceil(boss.hp / player_dar)

    -- print("TTK (Player)", player_ttk)
    -- print("TTK (Boss)", boss_ttk)

    return player_ttk >= boss_ttk
end

local shop = LoadShop("shop.txt")
local boss = {hp = 104, damage = 8, armor = 1}

local highest_cost = 0

for w = 1, #shop.weapons do
    -- Start at 0 where the thing is optional
    for a = 0, #shop.armors do
        for r1 = 0, #shop.rings do
            for r2 = 0, #shop.rings do
                local default = {cost = 0, damage = 0, armor = 0}

                local weapon = shop.weapons[w]
                local armor = shop.armors[a] or default
                local ring_1 = shop.rings[r1] or default
                local ring_2 = shop.rings[r2] or default

                local cost = EquipmentCost(weapon, armor, ring_1, ring_2)

                if cost > highest_cost then
                    local stats = EquipmentStats(weapon, armor, ring_1, ring_2)

                    local player = {
                        hp = 100,
                        damage = stats.damage,
                        armor = stats.armor
                    }

                    if not Victory(player, boss) then
                        print("NEW WORST", cost, weapon.name, armor.name,
                              ring_1.name, ring_2.name)

                        highest_cost = cost
                    end
                end
            end
        end
    end
end

print("Highest equipment cost to still lose the fight is " .. highest_cost)
