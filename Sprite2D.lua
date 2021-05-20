Sprite2D = class()

function Sprite2D:init(x, y)
    -- you can accept and set parameters here
    self.x = x or 0
    self.y = y or 0
    self.sprite = mesh()
    self.mask = self.sprite:addRect(0,0,0.5,0.5)
    self.isSmooth = true
end

function Sprite2D:setImage(img, x, y, w, h)
    local source = type(img) == 'string' and readImage(img) or img
    self.sprite:setRect(self.mask, x, y, w, h)
    self.sprite.texture = source
    self.sprite:setRectTex(self.mask)
end

function Sprite2D:setCoords(x, y , w, h)
    self.sprite:setRectTex(self.mask, x, y, w, h)
end
function Sprite2D:draw()
    pushMatrix()
    pushStyle()
    translate(self.x, self.y)
    if self.isSmooth then
        smooth()
    else
        noSmooth()
    end
    self.sprite:draw()
    popMatrix()
    popStyle()
    -- Codea does not automatically call this method
end

function Sprite2D:touched(touch)
    -- Codea does not automatically call this method
end
