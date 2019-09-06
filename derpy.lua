--------------------------------------------------------------------------------
-- Derpy
--------------------------------------------------------------------------------

-- Derpy Class

Derpy = {}
Derpy.__index = Derpy
function Derpy:Create(xo,yo)
    local this =
    {
        snakeSegments = {
            {x = xo - 3, y = yo - 1},
            {x = xo - 2, y = yo - 1},
            {x = xo - 1, y = yo - 1},
        },
        directionQueue = {'left'},
        stay_count = 0,
        alive = true,
        unstuck = true,
        c1 = (.1),
        c2 = .5 + math.random()/2,
        c3 = (.1),
    }
    setmetatable(this, Derpy)
    return this
end

-- Animate Derpy

function Derpy:Animate()
    for segmentIndex, segment in ipairs(self.snakeSegments) do
        if self.stay_count > 30 then
            love.graphics.setColor(math.random(),math.random(),math.random())
        else
            love.graphics.setColor(self.c1, self.c2, self.c3)
        end
        drawCell(segment.x, segment.y)
    end
end

-- Derpy Movement

function Derpy:Move()
    if self.unstuck == true then
        if #self.directionQueue > 1 then
            table.remove(self.directionQueue, 1)
        end

        local stay = false
        local nextXPosition = self.snakeSegments[1].x
        local nextYPosition = self.snakeSegments[1].y

        local choices = {1,2,3,4}
        local choice = math.random(1,#choices)
        self.directionQueue[1] = choices[choice]

        if self.directionQueue[1] == 1 then
            nextXPosition = nextXPosition + 1
            if nextXPosition > gridXCount then
                nextXPosition = 1
            end
            oktogo = true
            for k,v in pairs(snake.snakeSegments) do
                if v.x ~= nil and v.y ~= nil then
                    if v.x == self.snakeSegments[1].x + 1 and v.y == self.snakeSegments[1].y then
                        oktogo = false
                    end
                end
            end
            for segmentIndex, segment in ipairs(self.snakeSegments) do
                if (segmentIndex ~= #self.snakeSegments
                and nextXPosition == segment.x
                and nextYPosition == segment.y) or oktogo == false then
                    stay = true
                end
            end
            if stay == true then
                nextXPosition = self.snakeSegments[1].x
            end
        end

        if self.directionQueue[1] == 2 then
            nextXPosition = nextXPosition - 1
            if nextXPosition < 1 then
                nextXPosition = gridXCount
            end
            oktogo = true
            for k,v in pairs(snake.snakeSegments) do
                if v.x ~= nil and v.y ~= nil then
                    if v.x == self.snakeSegments[1].x - 1 and v.y == self.snakeSegments[1].y then
                        oktogo = false
                    end
                end
            end
            for segmentIndex, segment in ipairs(self.snakeSegments) do
                if (segmentIndex ~= #self.snakeSegments
                and nextXPosition == segment.x
                and nextYPosition == segment.y) or oktogo == false then
                    stay = true
                end
            end
            if stay == true then
                nextXPosition = self.snakeSegments[1].x
            end
        end

        if self.directionQueue[1] == 3 then
            nextYPosition = nextYPosition + 1
            if nextYPosition > gridYCount then
                nextYPosition = 1
            end
            oktogo = true
            for k,v in pairs(snake.snakeSegments) do
                if v.x ~= nil and v.y ~= nil then
                    if v.x == self.snakeSegments[1].x and v.y == self.snakeSegments[1].y + 1 then
                        oktogo = false
                    end
                end
            end
            for segmentIndex, segment in ipairs(self.snakeSegments) do
                if (segmentIndex ~= #self.snakeSegments
                and nextXPosition == segment.x
                and nextYPosition == segment.y) or oktogo == false then
                    stay = true
                end
            end
            if stay == true then
                nextYPosition = self.snakeSegments[1].y
            end
        end

        if self.directionQueue[1] == 4 then
            nextYPosition = nextYPosition - 1
            if nextYPosition < 1 then
                nextYPosition = gridYCount
            end
            oktogo = true
            for k,v in pairs(snake.snakeSegments) do
                if v.x ~= nil and v.y ~= nil then
                    if v.x == self.snakeSegments[1].x and v.y == self.snakeSegments[1].y - 1 then
                        oktogo = false
                    end
                end
            end
            for segmentIndex, segment in ipairs(self.snakeSegments) do
                if (segmentIndex ~= #self.snakeSegments
                and nextXPosition == segment.x
                and nextYPosition == segment.y) or oktogo == false then
                    stay = true
                end
            end
            if stay == true then
                nextYPosition = self.snakeSegments[1].y
            end
        end

        if stay == false and nextXPosition ~= nil and nextYPosition ~= nil then
            table.insert(self.snakeSegments, 1, {x = nextXPosition, y = nextYPosition})
            if math.random() > 0.01 then
                table.remove(self.snakeSegments)
            end
            self.stay_count = 0
        else
            self.stay_count = self.stay_count + 1
        end
    end

    if self.stay_count > 40 then
        self.unstuck = false
        self.stay_count = self.stay_count + 1
    end

    -- Derpy Explodes, Change Mold Color, +Level, Spawn Babies, Speedup
    if self.stay_count > 80 and self.unstuck == false then
        level = level + 1
        timerLimit = timerLimit * 0.98
        love.window.setTitle("Level " .. level)
        self.alive = false
    end
end
