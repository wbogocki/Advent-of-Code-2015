function FindCode(row, column)
    local num = 20151125

    for diagonal = 1, math.huge do
        for n = 1, diagonal do
            local r = diagonal - n + 1
            local c = n

            if r == row and c == column then return num end

            if r == 1 then print(r, c, num) end

            num = (num * 252533) % 33554393
        end
    end
end

print("Result: ", FindCode(3010, 3019))
