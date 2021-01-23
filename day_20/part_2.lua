function Presents(house_number)
    local out = 0
    local first_elf = math.ceil(house_number / 50)
    -- print(house_number, first_elf)
    for elf = first_elf, house_number do
        if house_number % elf == 0 then
            --
            out = out + (elf * 11)
        end
    end
    return out
end

-- for house_number = 1, 200 do
--     local presents = Presents(house_number)
--     -- print(house_number, presents)
-- end

-- os.exit(0)

local input = 36000000

local start = math.floor(input / (11 * 11))
local stop = math.floor(input / 11)

for house_number = start, stop do
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
