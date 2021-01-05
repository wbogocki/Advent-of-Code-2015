local function surface_area(l, w, h) return 2 * l * w + 2 * w * h + 2 * h * l end

local function slack(l, w, h)
    local side_1 = l * w
    local side_2 = w * h
    local side_3 = h * l
    return math.min(side_1, side_2, side_3)
end

local wrapping_paper_needed = 0

local file = io.open("input.txt", "r")

for line in file:lines() do
    local l, w, h = line:match("([^x]+)x([^x]+)x([^x]+)")
    l, w, h = tonumber(l), tonumber(w), tonumber(h)

    wrapping_paper_needed = wrapping_paper_needed + surface_area(l, w, h) +
                                slack(l, w, h)
end

print("Wrapping paper needed: " .. wrapping_paper_needed)
