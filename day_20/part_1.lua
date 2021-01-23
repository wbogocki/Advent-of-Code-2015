function Keys(array)
    local out = {}
    for key, _ in pairs(array) do table.insert(out, key) end
    return out
end

function Factorize(number)
    -- Trial division algorithm
    -- https://en.wikipedia.org/wiki/Trial_division

    local out = {}

    while number % 2 == 0 do
        out[2] = 1
        number = number / 2
    end

    local factor = 3
    while factor * factor <= number do
        if number % factor == 0 then
            out[factor] = 1
            number = number / factor
        else
            factor = factor + 2
        end
    end

    if number ~= 1 then out[1] = 1 end

    return Keys(out)
end

function Presents(house_number)
    local out = 0
    for elf = 1, house_number do
        if house_number % elf == 0 then
            --
            out = out + (elf * 10)
        end
    end
    return out
end

local input = 36000000

local factors = Factorize(input)

-- print("Factors:", table.concat(factors, " "))

local step = 1
for i = 1, #factors do step = step * factors[i] end

-- print("Step:", step)

local start = input / 100
local stop = input / 10

for house_number = start, stop, step do
    local presents = Presents(house_number)

    if house_number % 1000 == 0 then
        --
        print(house_number, presents)
    end

    if presents >= input then
        print("First house to get at least " .. input .. " is house " ..
                  house_number .. " with " .. presents .. " presents")
        break
    end
end
