--------------------------------------------------------------------------------
-- Load
--------------------------------------------------------------------------------

function love.load()

    require("beetle")
    require("board")
    require("derpy")
    require("dirt")
    require("player")
    require("snake")
    require("water")

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
            table.insert(brood, Derpy:Create(gridXCount-10,gridYCount-10))
        end

        snake:HitSelf()
        snake:UseTool()
        snake:HitBeetle()

        player:BumpBeetle()

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

        -- Kill Derpy
        for k,v in pairs(brood) do
            if v.alive == false then
                table.remove(brood, k)
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

    for k,v in pairs(colony) do
        v:Animate()
    end

    for k,v in pairs(brood) do
        v:Animate()
    end

end
