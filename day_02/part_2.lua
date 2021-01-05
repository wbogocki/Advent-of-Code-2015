local function ribbon(l, w, h)
    local perimeter = math.min(l + l + w + w, l + l + h + h, w + w + h + h)
    local bow = l * w * h
    return perimeter + bow
end

local ribbon_needed = 0

local file = io.open("input.txt", "r")

for line in file:lines() do
    local l, w, h = line:match("([^x]+)x([^x]+)x([^x]+)")
    l, w, h = tonumber(l), tonumber(w), tonumber(h)

    ribbon_needed = ribbon_needed + ribbon(l, w, h)
end

print("Ribbon needed: " .. ribbon_needed)
