function Copy(array)
    local out = {}
    for key, value in pairs(array) do out[key] = value end
    return out
end

function Swap(array, i, j)
    local tmp = array[i]
    array[i] = array[j]
    array[j] = tmp
end

function Permutations(array)
    -- Heap's Algorithm (non-recursive version)

    local out = {}

    local c = {}

    for i = 0, #array - 1 do -- - 1 to account for Lua's indexing system
        c[i] = 0
    end

    table.insert(out, Copy(array))

    local i = 0
    while i < #array do
        if c[i] < i then
            if i % 2 == 0 then
                Swap(array, 1, i + 1) -- + 1 to account for Lua's indexing system
            else
                Swap(array, c[i] + 1, i + 1) -- + 1 to account for Lua's indexing system
            end

            table.insert(out, Copy(array))

            c[i] = c[i] + 1

            i = 0
        else
            c[i] = 0
            i = i + 1
        end
    end

    return out
end

function CombineHappiness(arrangement, effects)
    local happiness = 0
    for i = 1, #arrangement do
        local person = arrangement[i]
        local neighbors = {
            arrangement[i % #arrangement + 1],
            arrangement[(#arrangement + i - 2) % #arrangement + 1]
        }

        for j = 1, #neighbors do
            local neighbor = neighbors[j]

            local effect = effects[person][neighbor]

            if effect.effect == "gain" then
                happiness = happiness + effect.amount
            else
                happiness = happiness - effect.amount
            end
        end
    end
    return happiness
end

local file = io.open("input.txt", "r")

local effects = {}
local people = {}

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local person = words[1]
    local neighbor = words[11]:sub(1, #words[11] - 1)
    local effect = words[3]
    local amount = tonumber(words[4])

    -- print(person, neighbor, effect, amount)

    if not effects[person] then effects[person] = {} end

    effects[person][neighbor] = {effect = effect, amount = amount}
end

for person, _ in pairs(effects) do table.insert(people, person) end

-- print(table.concat(people, " "))

local arrangements = Permutations(people)

local best_arrangement = nil
local best_happiness = 0
for i = 1, #arrangements do
    local arrangement = arrangements[i]
    local happiness = CombineHappiness(arrangement, effects)

    -- print(table.concat(arrangement, " "), CombineHappiness(arrangement, effects))

    if happiness > best_happiness then
        best_arrangement = arrangement
        best_happiness = happiness
    end
end

print("Best arrangement: ", table.concat(best_arrangement, " "))
print("Best happiness: ", best_happiness)
