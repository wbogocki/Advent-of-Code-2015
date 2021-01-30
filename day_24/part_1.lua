function Copy(array)
    local out = {}
    for _, element in ipairs(array) do table.insert(out, element) end
    return out
end

function LoadPackages()
    local file = io.open("input.txt", "r")
    local packages = {}
    for line in file:lines() do table.insert(packages, tonumber(line)) end
    table.sort(packages)
    io.close(file)
    return packages
end

function Sum(packages)
    local sum = 0
    for _, package in ipairs(packages) do sum = sum + package end
    return sum
end

function PossibleGroupsInner(packages, target_weight, group, group_weight)
    local out = {}

    for package_index = group[#group] + 1, #packages do
        local package = packages[package_index]

        local new_group_weight = group_weight + package

        if new_group_weight < target_weight then
            -- Keep on trying to add to the group

            local new_group = Copy(group)
            table.insert(new_group, package_index)

            local possible_groups = PossibleGroupsInner(packages, target_weight,
                                                        new_group,
                                                        new_group_weight)

            for _, group in ipairs(possible_groups) do
                table.insert(out, group)
            end
        elseif new_group_weight == target_weight then
            -- Perfect fit! The next one is going to be bigger so let's also break out.

            local new_group = Copy(group)
            table.insert(new_group, package_index)

            -- print(table.concat(new_group, " "))

            table.insert(out, new_group)

            break
        else
            -- This group would weight too much, break out. This is ok because packages are sorted.

            break
        end
    end

    return out
end

function PossibleGroups(packages, target_weight)
    local out = {}

    for i = 1, #packages do out[i] = {} end

    for i = 1, #packages do
        local group = {i}
        local sum = packages[i]

        local possible_groups = PossibleGroupsInner(packages, target_weight,
                                                    group, sum)

        for _, group in pairs(possible_groups) do
            table.insert(out[#group], group)
        end
    end

    return out
end

function QE(packages, group)
    local out = 1
    for _, package_index in ipairs(group) do
        out = out * packages[package_index]
    end
    return out
end

function CheckConfiguration(packages, g1, g2, g3)
    -- Check if groups contain any duplicate packages

    local set = {}
    for _, element in ipairs(g1) do set[element] = 1 end
    for _, element in ipairs(g2) do set[element] = 1 end
    for _, element in ipairs(g3) do set[element] = 1 end

    local sum = 0
    for _, element in pairs(set) do sum = sum + element end

    return sum == #packages
end

function MatchRemainingGroups(packages, possible_groups, group)
    local group_sizes = {} -- sizes to consider for the remaining groups

    local remaining = #packages - #group
    for i = 1, remaining do
        if i > remaining - i then break end
        table.insert(group_sizes, {g2 = i, g3 = remaining - i})
    end

    -- print(group_sizes.g2, group_sizes.g3)

    for _, sizes in ipairs(group_sizes) do
        for _, g2 in ipairs(possible_groups[sizes.g2]) do
            for _, g3 in ipairs(possible_groups[sizes.g3]) do
                if CheckConfiguration(packages, group, g2, g3) then
                    return {g2 = g2, g3 = g3}
                end
            end
        end
    end

    return nil
end

function Packages(packages, group)
    -- Groups are arrays of package indices; this function transforms them into arrays of packages

    local out = {}
    for _, package_index in ipairs(group) do
        table.insert(out, packages[package_index])
    end
    return out
end

function OptimalConfiguration(packages, possible_groups)
    -- 1. Select first group candidate
    -- 2. Find two other groups that match it

    local cmp = function(left, right)
        return QE(packages, left) < QE(packages, right)
    end

    for group_size = 1, #possible_groups do
        -- Groups with a given number of elements starting from least

        local groups = possible_groups[group_size]

        table.sort(groups, cmp)

        -- print(QE(packages, group), table.concat(group, " "))

        for _, group in ipairs(groups) do
            local configuration = MatchRemainingGroups(packages,
                                                       possible_groups, group)
            if configuration then
                return {
                    qe = QE(packages, group),
                    groups = {
                        Packages(packages, group), --
                        Packages(packages, configuration.g2), --
                        Packages(packages, configuration.g3)
                    }
                }
            end
        end
    end

    return nil
end

local packages = LoadPackages()

-- print(table.concat(packages, " "))

local group_weight = Sum(packages) / 3

-- print("Group weight:", group_weight)

local possible_groups = PossibleGroups(packages, group_weight)

local configuration = OptimalConfiguration(packages, possible_groups)

print("-- Optimal Configuration --")
print("QE:", configuration.qe)
for i, group in ipairs(configuration.groups) do
    print("Group " .. i .. ":", table.concat(group, " "))
end
