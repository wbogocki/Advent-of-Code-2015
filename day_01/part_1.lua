local file = io.open("input.txt", "r")
local content = file:read("*all")
file:close()

local up = 0
local down = 0

for i = 1, #content do
    local char = string.sub(content, i, i)
    if char == "(" then
        up = up + 1
    elseif char == ")" then
        down = down + 1
    end
end

print("Floor: " .. up - down)
