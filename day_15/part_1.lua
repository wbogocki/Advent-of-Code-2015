function Partition(slots, elements)
    -- print(slots, elements)

    local out = {}

    if elements == 1 then
        table.insert(out, {slots}) -- if there is only one element then it takes all slots
    else
        for i = 0, slots do -- go over all slot counts for the first element
            local remaining_slots = Partition(slots - i, elements - 1) -- partition the remaining slots and elements

            for j = 1, #remaining_slots do
                local allocated_slots = {i} -- slots taken by each element

                for k = 1, #remaining_slots[j] do
                    table.insert(allocated_slots, remaining_slots[j][k])
                end

                table.insert(out, allocated_slots)
            end
        end
    end

    return out
end

function CookieScore(ingredients, ingredient_amounts)
    local cookie_properties = {
        capacity = 0,
        durability = 0,
        flavor = 0,
        texture = 0
    }

    for i = 1, #ingredients do
        local ingr_amount = ingredient_amounts[i]
        local ingr_properties = ingredients[i]

        -- print(ingr_properties.name, ingr_amount)

        for name, _ in pairs(cookie_properties) do
            local ingr_property = ingr_properties[name]
            local ingr_total = ingr_property * ingr_amount

            cookie_properties[name] = cookie_properties[name] + ingr_total

            -- print(name, cookie_properties[name])
        end

        -- print("---")
    end

    for name, _ in pairs(cookie_properties) do
        cookie_properties[name] = math.max(0, cookie_properties[name])
    end

    local score = 1
    for _, value in pairs(cookie_properties) do
        --
        score = score * value
    end

    return score
end

local file = io.open("input.txt", "r")

local ingredients = {}

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    -- print(table.concat(words, " "))

    local ingredient = {
        name = words[1]:sub(1, #words[1] - 1),
        capacity = tonumber(words[3]:sub(1, #words[3] - 1)),
        durability = tonumber(words[5]:sub(1, #words[5] - 1)),
        flavor = tonumber(words[7]:sub(1, #words[7] - 1)),
        texture = tonumber(words[9]:sub(1, #words[9] - 1)),
        calories = tonumber(words[11])
    }

    -- for k, v in pairs(ingredient) do print(k, v) end

    table.insert(ingredients, ingredient)
end

local teaspoons = 100

local ingredient_amounts_partitions = Partition(teaspoons, #ingredients)

-- print(#ingredient_amounts_partitions - 1 .. " partitions")
-- for i = 1, #ingredient_amounts_partitions do
--     print(table.concat(ingredient_amounts_partitions[i], " "))
-- end

local best_cookie_score = 0

for i = 1, #ingredient_amounts_partitions do
    local ingredient_amounts = ingredient_amounts_partitions[i]
    local cookie_score = CookieScore(ingredients, ingredient_amounts)

    if cookie_score > best_cookie_score then
        --
        best_cookie_score = cookie_score
    end
end

print("Best Cookie Score: " .. best_cookie_score)
