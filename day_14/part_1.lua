function DistanceTravelled(speed, time_between_rests, rest_length, time)
    local distance = 0
    local time_remaining = time
    while time_remaining > 0 do
        -- Add distance until the next rest
        local time_to_travel = math.min(time_between_rests, time_remaining)
        distance = distance + (speed * time_to_travel)

        -- Subtract time travelled and time taken by the rest
        time_remaining = time_remaining - time_to_travel - rest_length
    end
    return distance
end

local file = io.open("input.txt", "r")

local raindeers = {}
for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local raindeer = {
        name = words[1],
        speed = tonumber(words[4]),
        time_between_rests = tonumber(words[7]),
        rest_length = tonumber(words[14])
    }

    -- print(raindeer.name, raindeer.speed, raindeer.time_between_rests,
    --       raindeer.rest_length)

    table.insert(raindeers, raindeer)
end

local time = 2503

local best_name = nil
local best_distance = 0

for _, raindeer in pairs(raindeers) do
    local distance = DistanceTravelled(raindeer.speed,
                                       raindeer.time_between_rests,
                                       raindeer.rest_length, time)

    print(raindeer.name, distance)

    if distance > best_distance then
        best_name = raindeer.name
        best_distance = distance
    end
end

print("---")
print("Winner: " .. best_name .. " (" .. best_distance .. ")")
