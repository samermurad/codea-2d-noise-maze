MazeDraw = class()

function MazeDraw:init(opt)
    opt = opt or {}
    self.tileSize = opt.tileSize or 32
    self.w = opt.w or WIDTH
    self.h = opt.h or HEIGHT
    self.zAxis = opt.zAxis or 0
    self.imgName = opt.imgName or 'NoiseDrawerOutput'
    self.img = image(self.w, self.h)
    setContext(self.img)
    background(0)
    setContext()
    self.sprite = Sprite2D(WIDTH // 2, HEIGHT // 2)
    self.sprite:setImage(self.img, 0, 0, self.w, self.h)
end

function MazeDraw:draw()
    self.sprite:draw()
end

local function round(num)
    return num > 0 and math.floor(num + 0.5) or math.ceil(num - 0.5)
end
function MazeDraw:touched(touch)
    local x = round( ( touch.x - ( self.tileSize // 2 ) ) / self.tileSize ) * self.tileSize
    local y = round( (touch.y - ( self.tileSize // 2 )) / self.tileSize ) * self.tileSize
    local colour = color(touch.tapCount == 1 and 255 or 0)
    setContext(self.img)
    noStroke()
    noSmooth()
    fill(colour)
    rect(x,y, self.tileSize, self.tileSize)
end
