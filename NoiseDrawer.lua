NoiseDrawer = class()

function NoiseDrawer:init(opt)
    opt = opt or {}
    self.n = opt.n or noiseTree()
    self.tileSize = opt.tileSize or 32
    self.w = opt.w or WIDTH
    self.h = opt.h or HEIGHT
    self.zAxis = opt.zAxis or 0
    self.imgName = opt.imgName or 'NoiseDrawerOutput'
    self.round = false
    self.thread = nil
    self.sprite = nil
    self.progress = nil
    self.cancel = false
end

function NoiseDrawer:threadData()
    return {
        tileSize = self.tileSize,
        w = self.w,
        h = self.h,
        round = self.round,
        cancel = self.cancel,
        imgName = self.imgName,
        n = self.n
    }
end

function NoiseDrawer.generate(data)
    local ts = data.tileSize
    local w = data.w
    local h = data.h
    local n = data.n -- noise
    local imgName = data.imgName
    local zAxis = data.zAxis

    local cols = math.ceil(w / ts)
    local rows = math.ceil(h / ts)
    local total = cols * rows

    coroutine.yield({ total = total, loaded = 0 })
    local img = image(w, h)
    setContext(img)
    pushMatrix() pushStyle() --resetMatrix()
    background(0)

    local dt = 0
    for i = 0, total - 1, 1 do
        local col = (i % cols)
        local row = math.floor(i / cols)
        local x = math.floor(col * ts)
        local y = math.floor(row * ts)
        local nVal = n:getValue(col / cols, row / rows, 0)
        local colour = color(nVal  * 255)
        fill(colour)
        
        if ts < 5 then
            noSmooth()
            noStroke()
        end
        if not round or ts < 5 then
            rect(x, y, ts, ts)
        else
            ellipse(x, y, ts)
        end

        if dt > 5 then
            setContext()
            popMatrix() popStyle()
            coroutine.yield({ total = total, loaded = i })
            pushMatrix() pushStyle() resetMatrix()
            dt = 0
            setContext(img)
        end
        dt = dt + DeltaTime
    end

    saveImage(asset .. imgName, img)
    local sprt = Sprite2D(WIDTH // 2, HEIGHT // 2)
    sprt:setImage(img, 0,0, w, h)
    
    img = nil
    collectgarbage()
    return sprt
end
function NoiseDrawer:apply()
    self.sprite = nil
    self.progress = nil
    self.thread = coroutine.create(self.generate)
end
function NoiseDrawer:update() 
    if self.thread then
        --local status = coroutine.status(self.thread)
        local co, res = coroutine.resume(self.thread, self:threadData())
        if res then
            local status = coroutine.status(self.thread)
            if status == 'suspended' then
                if res and res.loaded then
                    self.progress = res
                end
            elseif status == 'dead' then
                print('dead', res.sprite.draw)
                self.thread = nil
                self.progress = nil
                self.sprite = res
            end
        end
    end
end

function NoiseDrawer:drawProgress(p)
    pushMatrix() pushStyle()
    translate(WIDTH // 2, HEIGHT // 2)
    font("Verdana-Bold")
    textAlign(CENTER)
    fontSize(24)
    fill(255)
    smooth()
    text(string.format("Loading...\n %d / %d", p.loaded, p.total))
    popMatrix() popStyle()
end
function NoiseDrawer:draw()
    self:update()

    if self.sprite then
        self.sprite:draw()
    end

    if self.progress then
        self:drawProgress(self.progress)
    end
end

function NoiseDrawer:touched(touch)
    print(self.n:getValue(touch.x / WIDTH, touch.y / HEIGHT, 0))
end
