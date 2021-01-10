function Step(input)
    local out = {}

    local digit = input:sub(1, 1)
    local count = 1

    for i = 2, #input do
        local next = input:sub(i, i)
        if digit == next then
            count = count + 1
        else
            table.insert(out, count)
            table.insert(out, digit)
            digit = next
            count = 1
        end
    end

    table.insert(out, count)
    table.insert(out, digit)

    return table.concat(out)
end

local input = "3113322113"

for i = 1, 50 do
    print(i)
    input = Step(input)
end

print("Length of the final string is " .. #input)
