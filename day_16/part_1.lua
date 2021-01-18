local MFCSAM_OUT = {
    ["children"] = 3,
    ["cats"] = 7,
    ["samoyeds"] = 2,
    ["pomeranians"] = 3,
    ["akitas"] = 0,
    ["vizslas"] = 0,
    ["goldfish"] = 5,
    ["trees"] = 3,
    ["cars"] = 2,
    ["perfumes"] = 1
}

local file = io.open("input.txt", "r")

local aunts_sue = {}

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    -- print(table.concat(words, "\t"))

    local strip_last = function(word) return word:sub(1, #word - 1) end

    local props = {
        [strip_last(words[3])] = tonumber(strip_last(words[4])),
        [strip_last(words[5])] = tonumber(strip_last(words[6])),
        [strip_last(words[7])] = tonumber(words[8])
    }

    -- for k, v in pairs(props) do print(#aunts_sue, k, v) end

    table.insert(aunts_sue, props)
end

for i, aunt in ipairs(aunts_sue) do
    -- Check if the aunt qualifies

    local qualifies = true
    for prop, mfcsam_reading in pairs(MFCSAM_OUT) do
        if aunt[prop] ~= nil and aunt[prop] ~= mfcsam_reading then
            qualifies = false
            break
        end
    end

    if qualifies then print("Aunt " .. i .. " qualifies") end
end
