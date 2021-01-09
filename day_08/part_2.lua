local file = io.open("input.txt", "r")

local num_of_chars_in_escaped_literals = 0
local num_of_chars_in_literals = 0

local function escape(input)
    local out = ""
    for i = 1, #input do
        local char = input:sub(i, i)
        if char == "\\" or char == "\"" then
            out = out .. "\\" .. char
        else
            out = out .. char
        end
    end
    return "\"" .. out .. "\""
end

for line in file:lines() do
    local escaped = escape(line)
    print(line .. " -> " .. escaped)
    num_of_chars_in_escaped_literals = num_of_chars_in_escaped_literals +
                                           #escaped
    num_of_chars_in_literals = num_of_chars_in_literals + #line
end

print(num_of_chars_in_escaped_literals .. " characters in escaped literals")
print(num_of_chars_in_literals .. " characters in literals")

print("---")

local difference = num_of_chars_in_escaped_literals - num_of_chars_in_literals
print("Difference: " .. difference)
