local file = io.open("input.txt", "r")
local path = file:read("*all")

local houses = {}
local santa_x, santa_y = 0, 0
local robosanta_x, robosanta_y = 0, 0

houses["0,0"] = "yes"

for i = 1, #path do
    local x, y = 0, 0

    if i % 2 == 1 then
        x, y = santa_x, santa_y
    else
        x, y = robosanta_x, robosanta_y
    end

    local direction = path:sub(i, i)
    if direction == "^" then
        y = y - 1
    elseif direction == ">" then
        x = x + 1
    elseif direction == "v" then
        y = y + 1
    elseif direction == "<" then
        x = x - 1
    end

    if i % 2 == 1 then
        santa_x, santa_y = x, y
    else
        robosanta_x, robosanta_y = x, y
    end

    houses[x .. "," .. y] = "yes"
end

local count = 0

for k, v in pairs(houses) do
    -- print(k .. ": " .. v)
    count = count + 1
end

print("Houses visited by Santa: " .. count)
