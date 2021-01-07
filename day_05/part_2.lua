local function is_nice(string)
    local rule_1_ok = false
    local rule_2_ok = false

    for i = 2, #string do
        local pair = string:sub(i - 1, i)

        if string:find(pair, i + 1, true) then rule_1_ok = true end

        if i > 2 and string:sub(i - 2, i - 2) == string:sub(i, i) then
            rule_2_ok = true
        end
    end

    return rule_1_ok and rule_2_ok
end

local file = io.open("input.txt", "r")

local nice_string_count = 0

for string in file:lines() do
    if is_nice(string) then
        print(string .. " is nice")
        nice_string_count = nice_string_count + 1
    else
        print(string .. " is naughty")
    end
end

print(nice_string_count .. " string are nice!")
