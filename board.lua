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
            self.grid[y][x] = "water"
        end
    end
end

-- Board Island Fill
function Board:Island()
    for y = 10, gridYCount - 10 do
        for x = 10, gridXCount -10 do
            table.insert(dirt_table, Dirt:Create(x,y))
            self.grid[y][x] = "dirt"
        end
    end
end
