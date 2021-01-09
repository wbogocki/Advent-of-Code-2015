function Keys(array)
    local out = {}
    for key, _ in pairs(array) do table.insert(out, key) end
    return out
end

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

local file = io.open("input.txt", "r")

local locations = {}
local distances = {}

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local from, to, distance = words[1], words[3], tonumber(words[5])

    locations[from] = true
    locations[to] = true

    distances[from .. "-" .. to] = distance
    distances[to .. "-" .. from] = distance -- because why not :)
end

locations = Keys(locations)

-- print(table.concat(locations, " "))

local permutations = Permutations(locations)

local shortest_distance = 2 ^ 32

for _, route in pairs(permutations) do
    local route_str = table.concat(route, " -> ")
    local distance = 0

    for i = 2, #route do
        local from = route[i - 1]
        local to = route[i]

        distance = distance + distances[from .. "-" .. to]
    end

    print(route_str .. " = " .. distance)

    if distance < shortest_distance then
        --
        shortest_distance = distance
    end
end

print("---")
print(shortest_distance .. " is the shortest distance!")
