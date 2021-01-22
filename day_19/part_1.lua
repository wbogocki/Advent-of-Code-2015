function Keys(array)
    local out = {}
    for key, _ in pairs(array) do table.insert(out, key) end
    return out
end

function Copy(array)
    local out = {}
    for key, value in pairs(array) do out[key] = value end
    return out
end

local file = io.open("input.txt")

-- PARSE REPLACEMENTS

local replacements = {}

while true do
    local line = file:read("*l")
    assert(line, "Reached EOF before parsing the molecule")

    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    if #words >= 1 then
        -- print(table.concat(words, " "))

        local from = words[1]
        local to = words[3]

        if replacements[from] == nil then replacements[from] = {} end

        table.insert(replacements[from], to)
    else
        break
    end
end

-- PARSE THE MOLECULE

local molecule = {}

local molecule_str = file:read("*l")
local acc = {}
for i = 1, #molecule_str do
    local char = molecule_str:sub(i, i)

    if char == char:upper() and i ~= 1 then
        table.insert(molecule, table.concat(acc))
        acc = {char}
    else
        table.insert(acc, char)
    end
end
table.insert(molecule, table.concat(acc))

-- print(table.concat(molecule, "-"))

-- CHECK HOW MANY THINGS WE CAN REPLACE IN ONE STEP

local new_molecules = {}

for i = 1, #molecule do
    local component = molecule[i]
    local component_replacements = replacements[component]

    if component_replacements ~= nil then
        for j = 1, #component_replacements do
            local replacement = component_replacements[j]
            local new_molecule = Copy(molecule)
            new_molecule[i] = replacement
            new_molecules[table.concat(new_molecule)] = new_molecule
        end
    end
end

new_molecules = Keys(new_molecules)

print(table.concat(new_molecules, "\n"))
print("Calibration result: " .. #new_molecules)
