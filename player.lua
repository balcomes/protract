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
-- Player Drawing Function
--------------------------------------------------------------------------------

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
-- Player Bump Lichen
--------------------------------------------------------------------------------

function Player:BumpBeetle()
    for k,v in pairs(brood) do
        for k2,v2 in pairs(v.snakeSegments) do
            if v2.x == self.x and v2.y == self.y then
                bumpblink = 0.5
            end
        end
    end
end
