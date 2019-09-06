--------------------------------------------------------------------------------
-- Water
--------------------------------------------------------------------------------

-- Water Class

Water = {}
Water.__index = Water
function Water:Create(xo,yo)
    local this =
    {
        x = xo,
        y = yo,
        c1 = math.random()/4,
        c2 = math.random()/4,
        c3 = math.random()/2 + 0.5,
        blink = true,
    }
    setmetatable(this, Water)
    board.grid[yo][xo] = "water"
    return this
end

-- Water Blink

function Water:Blink()
    if math.random() < 0.01 then
        self.c1 = math.random()/4
        self.c2 = math.random()/4
        self.c3 = math.random()/2 + 0.5
    end
end

-- Water Animate

function Water:Animate()
    love.graphics.setColor(self.c1, self.c2, self.c3)
    if self.blink == true then
        self:Blink()
    end
    drawCell(self.x, self.y)
end
