local function is_nice(string)
    local vowel_count = 0
    local doubled_letter = false
    local blacklisted = false

    for i = 1, #string do
        local char = string:sub(i, i)

        if char:match("[aeiou]") then vowel_count = vowel_count + 1 end

        if i > 1 then
            local pair = string:sub(i - 1, i)

            if pair:sub(1, 1) == pair:sub(2, 2) then
                doubled_letter = true
            end

            if pair == "ab" or pair == "cd" or pair == "pq" or pair == "xy" then
                blacklisted = true
                break
            end
        end
    end

    return vowel_count >= 3 and doubled_letter and (blacklisted == false)
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
