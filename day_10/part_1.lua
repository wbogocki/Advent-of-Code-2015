function Step(input)
    local out = ""

    local digit = input:sub(1, 1)
    local count = 1

    for i = 2, #input do
        local next = input:sub(i, i)
        if digit == next then
            count = count + 1
        else
            out = out .. count .. digit
            digit = next
            count = 1
        end
    end

    out = out .. count .. digit

    return out
end

local input = "3113322113"

for i = 1, 40 do input = Step(input) end

print("Length of the final string is " .. #input)
