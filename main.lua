--------------------------------------------------------------------------------
-- Load
--------------------------------------------------------------------------------

function love.load()

    require("board")
    require("lichen")
    require("dirt")
    require("player")
    require("snake")
    require("water")

    cellSize = 12
    timer = 0
    timerLimit = 0.05
    bumpblink = 0
    level = 1
    water_table = {}
    dirt_table = {}
    brood = {}

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

    -- Setup Board
    board = Board:Create()
    board:Clear()
    board:Ocean()
    board:Island()

    player = Player:Create()
    snake = Snake:Create(player.x,player.y)

end

--------------------------------------------------------------------------------
-- Update
--------------------------------------------------------------------------------

function love.update(dt)

    timer = timer + dt
    bumpblink = bumpblink - dt
    if timer >= timerLimit then
        timer = timer - timerLimit
        snake.x = player.x
        snake.y = player.y

        if math.random() < 0.01 then
            table.insert(brood, Lichen:Create(math.random(13,gridXCount-13),
                                             math.random(13,gridYCount-13)))
        end

        snake:HitSelf()
        snake:UseTool()
        snake:HitLichen()
        player:HitLichen()


        -- Lichen Brood Move
        for k,v in pairs(brood) do
            v:Move()
            v:Move()

        end

        -- Lichen Brood Injured
        for k,v in pairs(brood) do
            v:HitTool()
        end

        for k,v in pairs(brood) do
            v:Circulation()
        end

        for k,v in pairs(brood) do
            if #v.snakeSegments < 2 then
                table.remove(brood,k)
            end
        end

        -- Kill Lichen
        for k,v in pairs(brood) do
            if v.alive == false then
                n1 = copy1(v.snakeSegments[math.random(#v.snakeSegments)])
                n2 = copy1(v.snakeSegments[math.random(#v.snakeSegments)])
                n3 = copy1(v.snakeSegments[math.random(#v.snakeSegments)])
                table.remove(brood, k)
                table.insert(brood, Lichen:Create(n1.x,n1.y))
                table.insert(brood, Lichen:Create(n2.x,n2.y))
                table.insert(brood, Lichen:Create(n3.x,n3.y))
            end
        end

        -- Record water
        for k,v in pairs(water_table) do
            board.grid[v.y][v.x] = "water"
        end

        -- Record dirt
        for k,v in pairs(dirt_table) do
            board.grid[v.y][v.x] = "dirt"
        end

        -- Record Lichen
        for k,v in pairs(brood) do
            for k2,v2 in pairs(v.snakeSegments) do
                board.grid[v2.y][v2.x] = "lichen"
            end
        end

    end
end

--------------------------------------------------------------------------------
-- Draw
--------------------------------------------------------------------------------

function love.draw()

    for k,v in pairs(water_table) do
        v:Animate()
    end
    for k,v in pairs(dirt_table) do
        v:Animate()
    end

    snake:Animate()
    player:Animate()

    for k,v in pairs(brood) do
        v:Animate()
    end

end
