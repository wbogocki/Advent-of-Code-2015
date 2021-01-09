local file = io.open("input.txt", "r")

local num_of_chars_in_literals = 0
local num_of_chars_in_bin_repr = 0

local function unescape(literal)
    local out = ""
    local i = 2 -- account for initial quote
    while i <= #literal - 1 do -- - 1 accounts for the final quote
        local char = literal:sub(i, i)
        if char ~= "\\" then
            out = out .. char
            i = i + 1
        else
            local next = literal:sub(i + 1, i + 1)
            if next == "\\" or next == "\"" then
                out = out .. next
                i = i + 2
            elseif next == "x" then
                local ascii_code_hex = literal:sub(i + 2, i + 3)
                local ascii_code = tonumber(ascii_code_hex, 16)
                out = out .. string.char(ascii_code)
                i = i + 4
            end
        end
    end
    return out
end

for line in file:lines() do
    local unescaped = unescape(line)
    print(line .. " -> " .. unescaped)
    num_of_chars_in_literals = num_of_chars_in_literals + #line
    num_of_chars_in_bin_repr = num_of_chars_in_bin_repr + #unescaped
end

print(num_of_chars_in_literals .. " characters in literals")
print(num_of_chars_in_bin_repr .. " characters in binary representation")

print("---")

print("Difference: " .. num_of_chars_in_literals - num_of_chars_in_bin_repr)
