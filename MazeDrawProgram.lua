MazeDrawProgram = class()

function MazeDrawProgram:init()
end

function MazeDrawProgram:setup()
    parameter.clear()
    
    parameter.text('name', 'Maze_' .. os.time())
    parameter.action('save', function()
        local img = image(self.md.w, self.md.h)
        setContext(img)
        self.md:draw()
        setContext()
        saveImage(asset .. name, img)
    end
    )
    
    self.md = MazeDraw{}
end
function MazeDrawProgram:draw()
    -- Codea does not automatically call this method
    self.md:draw()
end

function MazeDrawProgram:touched(touch)
    self.md:touched(touch)
end
