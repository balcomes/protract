function love.load()

    cellSize = 12

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

    player = Player:Create()

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
function love.update(dt)
    -- Player Movement
    if love.keyboard.isDown( "z" ) then
        if love.keyboard.isDown( "up" ) and player.y > 1 then
            if snake == nil then
                snake = Snake:Create(player.x,player.y)
            else
                table.insert(snake.snakeSegments, 1,
                {x = snake.snakeSegments[1].x,
                 y = snake.snakeSegments[1].y - 1})
            end

        elseif love.keyboard.isDown( "down" ) and player.y < gridYCount then
            if snake == nil then
                snake = Snake:Create(player.x,player.y)
            else
                table.insert(snake.snakeSegments, 1,
                {x = snake.snakeSegments[1].x,
                 y = snake.snakeSegments[1].y + 1})
            end

        elseif love.keyboard.isDown( "left" ) and player.x > 1 then
            if snake == nil then
                snake = Snake:Create(player.x,player.y)
            else
                table.insert(snake.snakeSegments, 1,
                {x = snake.snakeSegments[1].x - 1,
                 y = snake.snakeSegments[1].y})
            end

        elseif love.keyboard.isDown( "right" ) and player.x < gridXCount then
            if snake == nil then
                snake = Snake:Create(player.x,player.y)
            else
                table.insert(snake.snakeSegments, 1,
                {x = snake.snakeSegments[1].x + 1,
                 y = snake.snakeSegments[1].y})
            end
        end

    else
        if snake ~= nil then
            for i = 1, #snake.snakeSegments do
                table.remove(snake.snakeSegments)
            end
        end
        snake = nil

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

--------------------------------------------------------------------------------

-- Draw Everything
function love.draw()
    player:Animate()
    if snake ~= nil then
        snake:Animate()
    end
end
