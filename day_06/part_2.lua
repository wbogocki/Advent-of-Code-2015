local grid = {}

function grid:init()
    for y = 1, 1000 do
        for x = 1, 1000 do
            --
            self:set(y, x, 0)
        end
    end
end

function grid:get(x, y)
    --
    return self[y * 1000 + x]
end

function grid:set(x, y, bool)
    --
    self[y * 1000 + x] = bool
end

grid:init()

local instr = {}

local file = io.open("input.txt", "r")

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local action = nil
    local from_x, from_y = nil, nil
    local thru_x, thru_y = nil, nil

    if words[1] == "turn" then
        if words[2] == "on" then
            action = "turn on"
        else
            action = "turn off"
        end
        from_x, from_y = words[3]:match("([^,]+),([^,]+)")
        thru_x, thru_y = words[5]:match("([^,]+),([^,]+)")
    else
        action = "toggle"
        from_x, from_y = words[2]:match("([^,]+),([^,]+)")
        thru_x, thru_y = words[4]:match("([^,]+),([^,]+)")
    end

    from_x, from_y = tonumber(from_x), tonumber(from_y)
    thru_x, thru_y = tonumber(thru_x), tonumber(thru_y)

    table.insert(instr, {
        action = action,
        from_x = from_x,
        from_y = from_y,
        thru_x = thru_x,
        thru_y = thru_y
    })
end

-- for _, it in pairs(instr) do
--     print(it.action .. " " .. it.from_x .. "," .. it.from_y .. " through " ..
--               it.thru_x .. "," .. it.thru_y)
-- end

for _, it in pairs(instr) do
    for y = it.from_y + 1, it.thru_y + 1 do
        for x = it.from_x + 1, it.thru_x + 1 do
            if it.action == "turn on" then
                grid:set(x, y, grid:get(x, y) + 1)
            elseif it.action == "turn off" then
                if grid:get(x, y) > 0 then
                    grid:set(x, y, grid:get(x, y) - 1)
                end
            else -- toggle
                grid:set(x, y, grid:get(x, y) + 2)
            end
        end
    end
end

local total_brigtness = 0

for y = 1, 1000 do
    for x = 1, 1000 do
        --
        total_brigtness = total_brigtness + grid:get(x, y)
    end
end

print("The lights' total brightness is " .. total_brigtness)
