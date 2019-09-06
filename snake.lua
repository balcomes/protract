--------------------------------------------------------------------------------
-- Snake
--------------------------------------------------------------------------------

-- Snake Class
Snake = {}
Snake.__index = Snake
function Snake:Create(xo,yo)
    local this =
    {
        snakeSegments = {
            {x = xo, y = yo},
        },
        c1 = math.random()/2,
        c2 = .5 + math.random()/2,
        c3 = math.random()/2,
    }
    setmetatable(this, Snake)
    return this
end

-- Animate Snake
function Snake:Animate()
    for segmentIndex, segment in ipairs(self.snakeSegments) do
        if bumpblink > 0 then
            love.graphics.setColor(math.random(), math.random(), math.random())
        else
            love.graphics.setColor(self.c1, self.c2, self.c3)
        end
        drawCell(segment.x, segment.y)
    end
end

-- Hit Self

function Snake:HitSelf()

    counter = 0
    for k,v in pairs(self.snakeSegments) do
        if v.x == self.snakeSegments[1].x and v.y == self.snakeSegments[1].y then
            counter = counter + 1
        end
    end
    if counter > 1 then
        table.remove(self.snakeSegments,1)
    end
end

-- Use Tool

function Snake:UseTool()

    if love.keyboard.isDown( "z" ) then
        if love.keyboard.isDown( "up" ) and player.y > 1 then
            if self.snakeSegments[1] ~= nil then
                table.insert(self.snakeSegments, 1,
                {x = self.snakeSegments[1].x,
                 y = self.snakeSegments[1].y - 1})
            else
                table.insert(self.snakeSegments, 1,
                {x = player.x,
                 y = player.y - 1})
            end

        elseif love.keyboard.isDown( "down" ) and player.y < gridYCount then
            if self.snakeSegments[1] ~= nil then
                table.insert(self.snakeSegments, 1,
                {x = self.snakeSegments[1].x,
                 y = self.snakeSegments[1].y + 1})
            else
                table.insert(self.snakeSegments, 1,
                {x = player.x,
                 y = player.y + 1})
            end

        elseif love.keyboard.isDown( "left" ) and player.x > 1 then
            if self.snakeSegments[1] ~= nil then
                table.insert(self.snakeSegments, 1,
                {x = self.snakeSegments[1].x - 1,
                 y = self.snakeSegments[1].y})
            else
                table.insert(self.snakeSegments, 1,
                {x = player.x - 1,
                 y = player.y})
            end

        elseif love.keyboard.isDown( "right" ) and player.x < gridXCount then
            if self.snakeSegments[1] ~= nil then
                table.insert(self.snakeSegments, 1,
                {x = self.snakeSegments[1].x + 1,
                 y = self.snakeSegments[1].y})
            else
                table.insert(self.snakeSegments, 1,
                {x = player.x + 1,
                 y = player.y})
            end
        end

    else

        table.remove(self.snakeSegments,1)

        if self.snakeSegments[1] == nil then
            -- Player Movement
            if love.keyboard.isDown( "up" ) and player.y > 10 then
                player.y = player.y - 1
            end
            if love.keyboard.isDown( "down" ) and player.y < gridYCount - 10 then
                player.y = player.y + 1
            end
            if love.keyboard.isDown( "left" ) and player.x > 10 then
                player.x = player.x - 1
            end
            if love.keyboard.isDown( "right" ) and player.x < gridXCount - 10 then
                player.x = player.x + 1
            end
        end
    end
end

-- Snake Hit Beetle

function Snake:HitBeetle()
    for k,v in pairs(self.snakeSegments) do
    for k2,v2 in pairs(colony) do

        if v.x == v2.x
        and v.y == v2.y then
            bumpblink = 0.5
        end
    end
    end
end
