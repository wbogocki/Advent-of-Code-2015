local file = io.open("input.txt", "r")
local text = file:read("*all")

local sum = 0

for number in text:gmatch("-?[0-9]+") do sum = sum + tonumber(number) end

print("The sum of all the numbers in the document is " .. sum)
