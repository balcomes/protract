--------------------------------------------------------------------------------
-- Beetle
--------------------------------------------------------------------------------

-- Beetle Class
Beetle = {}
Beetle.__index = Beetle
function Beetle:Create(xo,yo)
    local this =
    {
        x = xo,
        y = yo,
        c1 = math.floor(math.random(1,4))/3,
        c2 = math.floor(math.random(1,4))/3,
        c3 = math.floor(math.random(1,4))/3,
        fertile = true,
    }
    setmetatable(this, Beetle)
    return this
end

-- Animate Beetle
function Beetle:Animate()
    love.graphics.setColor(self.c1, self.c2, self.c3)
    drawCell(self.x, self.y)
end

    -- Beetle Move
function Beetle:Move()
    if math.random() < 0.5 then
        direction = math.floor(math.random()*5)
        local oktogo = true
        if direction == 1 and self.y > 10 then
            for k,v in pairs(snake.snakeSegments) do
                if v.x == self.x and v.y == self.y - 1 then
                    oktogo = false
                end
            end
            if oktogo == true then
                self.y = self.y - 1
            end
        end
        if direction == 2 and self.y < gridYCount - 10 then
            for k,v in pairs(snake.snakeSegments) do
                if v.x == self.x and v.y == self.y + 1 then
                    oktogo = false
                end
            end
            if oktogo == true then
                self.y = self.y + 1
            end
        end
        if direction == 3 and self.x > 10 then
            for k,v in pairs(snake.snakeSegments) do
                if v.x == self.x - 1 and v.y == self.y then
                    oktogo = false
                end
            end
            if oktogo == true then
                self.x = self.x - 1
            end
        end
        if direction == 4 and self.x < gridXCount - 10 then
            for k,v in pairs(snake.snakeSegments) do
                if v.x == self.x + 1 and v.y == self.y then
                    oktogo = false
                end
            end
            if oktogo == true then
                self.x = self.x + 1
            end
        end
    end
end
