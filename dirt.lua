--------------------------------------------------------------------------------
-- Dirt
--------------------------------------------------------------------------------

-- Dirt Class

Dirt = {}
Dirt.__index = Dirt
function Dirt:Create(xo,yo)
    local this =
    {
        x = xo,
        y = yo,
        c1 = 35/255,
        c2 = 40/255,
        c3 = 45/255,
    }
    setmetatable(this, Dirt)
    board.grid[yo][xo] = "dirt"
    return this
end

-- Dirt Animate

function Dirt:Animate()
    love.graphics.setColor(self.c1, self.c2, self.c3)
    drawCell(self.x, self.y)
end
