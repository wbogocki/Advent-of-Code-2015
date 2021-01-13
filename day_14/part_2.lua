State = {FLYING = 1, RESTING = 2}

local file = io.open("input.txt", "r")

local raindeers = {}
for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local raindeer = {
        name = words[1],
        speed = tonumber(words[4]),
        time_between_rests = tonumber(words[7]),
        rest_length = tonumber(words[14]),
        state = State.FLYING,
        distance = 0,
        timer = 0,
        score = 0
    }

    -- print(raindeer.name, raindeer.speed, raindeer.time_between_rests,
    --       raindeer.rest_length)

    table.insert(raindeers, raindeer)
end

local time = 2503

for _ = 1, time do
    local best_distance = 0

    for _, raindeer in pairs(raindeers) do
        if raindeer.state == State.FLYING then
            raindeer.distance = raindeer.distance + raindeer.speed
            raindeer.timer = raindeer.timer + 1

            if raindeer.timer == raindeer.time_between_rests then
                raindeer.state = State.RESTING
                raindeer.timer = 0
            end
        else -- raindeer.state == State.RESTING
            raindeer.timer = raindeer.timer + 1

            if raindeer.timer == raindeer.rest_length then
                raindeer.state = State.FLYING
                raindeer.timer = 0
            end
        end

        if raindeer.distance > best_distance then
            best_distance = raindeer.distance
        end
    end

    for _, raindeer in pairs(raindeers) do
        if raindeer.distance == best_distance then
            raindeer.score = raindeer.score + 1
        end
    end
end

local best_name = nil
local best_score = 0

for _, raindeer in pairs(raindeers) do
    print(raindeer.name, raindeer.distance, raindeer.score)

    if raindeer.score > best_score then
        best_name = raindeer.name
        best_score = raindeer.score
    end
end

print("---")
print("Winner: " .. best_name .. " (" .. best_score .. ")")
