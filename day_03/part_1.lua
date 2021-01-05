local file = io.open("input.txt", "r")
local path = file:read("*all")

local houses = {}
local x, y = 0, 0

houses["0,0"] = "yes"

for i = 1, #path do
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
    houses[x .. "," .. y] = "yes"
end

local count = 0

for k, v in pairs(houses) do
    -- print(k .. ": " .. v)
    count = count + 1
end

print("Houses visited by Santa: " .. count)
