MazeCreatorProg = class()

function MazeCreatorProg:init()
    self.sprtG = {x = WIDTH // 2, y = HEIGHT // 2, name = 'MazePack_' .. os.time() }
    self.sprtG.draw = function(self)
        pushMatrix() pushStyle()
        translate(self.x, self.y)
        translate(-(#self * 128),0)
        for _, s in ipairs(self) do
            s:draw()
        end
        popMatrix() popStyle()
    end
    
    self.sprtG.add = function(self, nd)
        local img = image(nd.w, nd.h)
        setContext(img)
        nd.sprite:draw()
         setContext()
        local sprt = Sprite2D(#self * 128, 0)
        sprt:setImage(nd.sprite.sprite.texture, 0,0, 128, 128)
        table.insert(self, sprt)
        img = nil
        sprt = nil
        collectgarbage()
    end
end

function MazeCreatorProg.save(sprtG)
    local didCreate = hasProject(sprtG.name)
    if not didCreate then
        createProject(sprtG.name)
    end

    local mainCode = [[
function setup()
    print ("]] .. sprtG.name .. [[")
end
    
function draw()
    translate(64, HEIGHT // 2)
    for i = 1, ]] .. #sprtG .. [[, 1 do
        sprite(asset['Image_' .. i])
        translate(128, 0)
    end
end
    ]]
    
    saveText(asset.documents[sprtG.name] .. 'Main.lua', mainCode)
    for i, s in ipairs(sprtG) do
        local img = image(128, 128)
        setContext(img)
        local oldX, oldY = s.x, s.y
        s.x = 64
        s.y = 64
        s:draw()
        s.x = oldX
        s.y = oldY
        setContext()
        local imgName = 'Image_' .. i .. '.png'
        saveImage(asset.documents[sprtG.name] .. imgName, img)
        img = nil
        collectgarbage()
        coroutine.yield()
    end
end

function MazeCreatorProg:setup()
    self.nd = NoiseDrawer{
        w = 128,
        h = 128,
        tileSize = 1,
        imgName = 'mini_maze',
    }
    self.axisPad = AxisPad{range = 250}
    parameter.text('mazeName', self.sprtG.name, function(n)
        self.sprtG.name = n
    end)
    parameter.action("generate", function()
        self.nd.n = noiseTree()
        self.nd:apply()
    end)
    parameter.action('add', function()
        self.sprtG:add(self.nd)
    end)
    parameter.action('save', function()
        self.thread = coroutine.create(self.save)
    end)
    self.nd:apply()
end

function MazeCreatorProg:update()
    if self.thread then
        local co, res = coroutine.resume(self.thread, self.sprtG)
        local status = coroutine.status(self.thread)
        if status == 'dead' then
            self.thread = nil
            print('done', res)
        end
    end
    local x, y = self.axisPad:getXY()
    
    self.sprtG.x = self.sprtG.x + x
    self.sprtG.y = self.sprtG.y + y
end
function MazeCreatorProg:draw()
    self:update()
    self.nd:draw()
    self.sprtG:draw()
    self.axisPad:draw()
end

function MazeCreatorProg:touched(touch)
    self.axisPad:touched(touch)
end
