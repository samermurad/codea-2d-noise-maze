BasicMazeProg = class()

function BasicMazeProg:init()

end

function BasicMazeProg:setup()
    self.nd = NoiseDrawer{
        imgName = 'NewTest',
    }
    self.nd.zAxis = 9
    
    parameter.integer('tileSize', 1, 128, 32, function(ts)
        self.nd.tileSize = ts
    end)
    parameter.boolean('round', false, function(ts)
        self.nd.round = ts
    end)
    parameter.action("generate", function()
        self.nd.n = noiseTree()
        self.nd:apply()
    end)
    self.nd:apply()
end
function BasicMazeProg:draw()
    self.nd:draw()
    -- Codea does not automatically call this method
end

function BasicMazeProg:touched(touch)
    self.nd:touched(touch)
    -- Codea does not automatically call this method
end
