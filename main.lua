function love.load()

    cellSize = 12
    timer = 0
    timerLimit = 0.05
    colony = {}

    gridXCount = math.floor(love.graphics.getWidth()/cellSize + 0.5)
    gridYCount = math.floor(love.graphics.getHeight()/cellSize + 0.5)
    love.graphics.setBackgroundColor(25/255, 30/255, 35/255)

    -- Cell Drawing Function
    function drawCell(x, y)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize - 1
        )
    end

    -- Player Drawing Function
    function drawPlayer(x, y)
        -- Hat
        love.graphics.setColor(1, 0, 1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + 1,
            cellSize - 1,
            cellSize/3
        )
        -- Face
        love.graphics.setColor(.8, .8, .8)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1,
            cellSize/3
        )
        -- Eyes
        love.graphics.setColor(.1, .1, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Eyes
        love.graphics.setColor(.1, .1, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + 3*cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Pants
        love.graphics.setColor(.1, .2, .8)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + 2*cellSize/3,
            cellSize - 1,
            cellSize/3 - 1
        )
    end

--------------------------------------------------------------------------------
-- Player
--------------------------------------------------------------------------------

    -- Player Class
    Player = {}
    Player.__index = Player
    function Player:Create()
        local this =
        {
            x = math.floor(gridXCount/2),
            y = math.floor(gridYCount/2),
        }
        setmetatable(this, Player)
        return this
    end

    -- Player Animate
    function Player:Animate()
        drawPlayer(self.x, self.y)
    end

--------------------------------------------------------------------------------
-- Snake
--------------------------------------------------------------------------------

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
            love.graphics.setColor(self.c1, self.c2, self.c3)
            drawCell(segment.x, segment.y)
        end
    end

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
            if direction == 1 and self.y > 2 then
                for k,v in pairs(snake.snakeSegments) do
                    if v.x == self.x and v.y == self.y - 1 then
                        oktogo = false
                    end
                end
                if oktogo == true then
                    self.y = self.y - 1
                end
            end
            if direction == 2 and self.y < gridYCount - 1 then
                for k,v in pairs(snake.snakeSegments) do
                    if v.x == self.x and v.y == self.y + 1 then
                        oktogo = false
                    end
                end
                if oktogo == true then
                    self.y = self.y + 1
                end
            end
            if direction == 3 and self.x > 2 then
                for k,v in pairs(snake.snakeSegments) do
                    if v.x == self.x - 1 and v.y == self.y then
                        oktogo = false
                    end
                end
                if oktogo == true then
                    self.x = self.x - 1
                end
            end
            if direction == 4 and self.x < gridXCount then
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

--------------------------------------------------------------------------------

    player = Player:Create()
    snake = Snake:Create(player.x,player.y)
    for i = 1, 40 do
        x = math.random(5, gridXCount - 5)
        y = math.random(5, gridYCount - 5)
        table.insert(colony, Beetle:Create(x,y))
    end

end


function love.update(dt)
    timer = timer + dt
    -- Handle Frames
    if timer >= timerLimit then
        -- Handle Game Speed
        timer = timer - timerLimit

        snake.x = player.x
        snake.y = player.y

        -- Hit self
        counter = 0
        for k,v in pairs(snake.snakeSegments) do
            if v.x == snake.snakeSegments[1].x and v.y == snake.snakeSegments[1].y then
                counter = counter + 1
            end
        end
        if counter > 1 then
            --for k,v in pairs(snake.snakeSegments) do
                table.remove(snake.snakeSegments,1)
            --end
        end

        -- Player Tool
        if love.keyboard.isDown( "z" ) then
            if love.keyboard.isDown( "up" ) and player.y > 1 then
                if snake.snakeSegments[1] ~= nil then
                    table.insert(snake.snakeSegments, 1,
                    {x = snake.snakeSegments[1].x,
                     y = snake.snakeSegments[1].y - 1})
                else
                    table.insert(snake.snakeSegments, 1,
                    {x = player.x,
                     y = player.y - 1})
                end

            elseif love.keyboard.isDown( "down" ) and player.y < gridYCount then
                if snake.snakeSegments[1] ~= nil then
                    table.insert(snake.snakeSegments, 1,
                    {x = snake.snakeSegments[1].x,
                     y = snake.snakeSegments[1].y + 1})
                else
                    table.insert(snake.snakeSegments, 1,
                    {x = player.x,
                     y = player.y + 1})
                end

            elseif love.keyboard.isDown( "left" ) and player.x > 1 then
                if snake.snakeSegments[1] ~= nil then
                    table.insert(snake.snakeSegments, 1,
                    {x = snake.snakeSegments[1].x - 1,
                     y = snake.snakeSegments[1].y})
                else
                    table.insert(snake.snakeSegments, 1,
                    {x = player.x - 1,
                     y = player.y})
                end

            elseif love.keyboard.isDown( "right" ) and player.x < gridXCount then
                if snake.snakeSegments[1] ~= nil then
                    table.insert(snake.snakeSegments, 1,
                    {x = snake.snakeSegments[1].x + 1,
                     y = snake.snakeSegments[1].y})
                else
                    table.insert(snake.snakeSegments, 1,
                    {x = player.x + 1,
                     y = player.y})
                end
            end

        else

            table.remove(snake.snakeSegments,1)

            if snake.snakeSegments[1] == nil then
                -- Player Movement
                if love.keyboard.isDown( "up" ) and player.y > 1 then
                    player.y = player.y - 1
                end
                if love.keyboard.isDown( "down" ) and player.y < gridYCount then
                    player.y = player.y + 1
                end
                if love.keyboard.isDown( "left" ) and player.x > 1 then
                    player.x = player.x - 1
                end
                if love.keyboard.isDown( "right" ) and player.x < gridXCount then
                    player.x = player.x + 1
                end
            end
        end

        -- Move Beetles
        for k,v in pairs(colony) do
            v:Move()
        end

        -- Breed Beetles
        for k,v in pairs(colony) do
            for k2,v2 in pairs(colony) do
                if k ~= k2 then
                    if v2.c1 == v.c1
                    and v2.c2 == v.c2
                    and v2.c3 == v.c3
                    and v2.x == v.x
                    and v2.y == v.y then
                        table.insert(colony, Beetle:Create(v.x,v.y))
                    end
                end
            end
        end

    end
end

--------------------------------------------------------------------------------

-- Draw Everything
function love.draw()
    snake:Animate()
    player:Animate()

    for k,v in pairs(colony) do
        v:Animate()
    end

end
