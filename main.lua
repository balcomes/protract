function love.load()

    cellSize = 12
    timer = 0
    timerLimit = 0.05
    bumpblink = 0
    colony = {}
    water_table = {}
    dirt_table = {}
    brood = {}
    level = 1

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
        if bumpblink > 0 then
            love.graphics.setColor(math.random(), math.random(), math.random())
        else
            love.graphics.setColor(1, 0, 1)
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + 1,
            cellSize - 1,
            cellSize/3
        )
        -- Face
        if bumpblink > 0 then
            love.graphics.setColor(math.random(), math.random(), math.random())
        else
            love.graphics.setColor(.8, .8, .8)
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1,
            cellSize/3
        )
        -- Eyes
        if bumpblink > 0 then
            love.graphics.setColor(math.random(), math.random(), math.random())
        else
            love.graphics.setColor(.1, .1, .1)
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Eyes
        if bumpblink > 0 then
            love.graphics.setColor(math.random(), math.random(), math.random())
        else
            love.graphics.setColor(.1, .1, .1)
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + 3*cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Pants
        if bumpblink > 0 then
            love.graphics.setColor(math.random(), math.random(), math.random())
        else
            love.graphics.setColor(.1, .2, .8)
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + 2*cellSize/3,
            cellSize - 1,
            cellSize/3 - 1
        )
    end

--------------------------------------------------------------------------------
-- Board
--------------------------------------------------------------------------------

    -- Board Class
    Board = {}
    Board.__index = Board
    function Board:Create()
        local this =
        {
            grid = {},
        }
        for y = 1, gridYCount do
            this.grid[y] = {}
            for x = 1, gridXCount do
                this.grid[y][x] = ""
            end
        end
        setmetatable(this, Board)
        return this
    end

    -- Board Clear
    function Board:Clear()
        for y = 1, gridYCount do
            self.grid[y] = {}
            for x = 1, gridXCount do
                self.grid[y][x] = ""
            end
        end
    end

    -- Board Water Fill
    function Board:Ocean()
        for y = 1, gridYCount do
            for x = 1, gridXCount do
                table.insert(water_table, Water:Create(x,y))
            end
        end
    end

    -- Board Island Fill
    function Board:Island()
        for y = 10, gridYCount - 10 do
            for x = 10, gridXCount -10 do
                table.insert(dirt_table, Dirt:Create(x,y))
            end
        end
    end

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

--------------------------------------------------------------------------------


    -- Setup Board
    board = Board:Create()
    Board:Ocean()
    Board:Island()


    player = Player:Create()
    snake = Snake:Create(player.x,player.y)
    for i = 1, 40 do
        x = math.random(10, gridXCount - 10)
        y = math.random(10, gridYCount - 10)
        table.insert(colony, Beetle:Create(x,y))
    end

end


function love.update(dt)
    timer = timer + dt
    bumpblink = bumpblink - dt
    -- Handle Frames
    if timer >= timerLimit then
        -- Handle Game Speed
        timer = timer - timerLimit

        snake.x = player.x
        snake.y = player.y

        if math.random() < 0.01 then
            table.insert(brood, Derpy:Create(gridXCount-10,gridYCount-10))
        end

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

                -- Snake Bump Beetle
        for k,v in pairs(snake.snakeSegments) do
            for k2,v2 in pairs(colony) do

                if v.x == v2.x
                and v.y == v2.y then
                    bumpblink = 0.5
                end
            end
        end

            -- Player Bump Beetle
        for k,v in pairs(colony) do
            if v.x == player.x
            and v.y == player.y then
                bumpblink = 0.5
            end
        end

        -- Move Beetles
        for k,v in pairs(colony) do
            v:Move()
        end

        -- Derpy Brood Move
        for k,v in pairs(brood) do
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
                    and v2.y == v.y
                    and v.fertile == true
                    and v2.fertile == true then
                        table.insert(colony, Beetle:Create(v.x,v.y))
                        if math.random() < 0.2 then
                            table.insert(colony, Beetle:Create(v.x,v.y))
                        end
                        v.fertile = false
                    end
                end
            end
        end

        for k,v in pairs(brood) do
            if v.alive == false then
                table.remove(brood, k)
            end
        end

    end
end

--------------------------------------------------------------------------------

-- Draw Everything
function love.draw()

    for k,v in pairs(water_table) do
        v:Animate()
    end
    for k,v in pairs(dirt_table) do
        v:Animate()
    end

    snake:Animate()
    player:Animate()

    for k,v in pairs(colony) do
        v:Animate()
    end

    for k,v in pairs(brood) do
        v:Animate()
    end

end
