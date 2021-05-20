function invert(n)
    local i = craft.noise.invert()
    i:setSource(0, n)
    
    local a = craft.noise.add()
    a:setSource(0, craft.noise.const(1))
    a:setSource(1, i)
    return a
end

local function turb(n, f, s , p)
    local t = craft.noise.turbulence()
    t:setSource(0, n)
    t.frequency = f or 6
    t.seed = s or math.random(0, 10000)
    t.power = p or 5.6
    
    return t
end

local function cap(n, val)
    local min = craft.noise.min()
    local con = craft.noise.const(val)
    min:setSource(0, n)
    min:setSource(1, con)
    return min
end

function split(a, b, p)
    local s = craft.noise.select()
    s:setSource(0, a)
    s:setSource(1, b)
    s:setSource(2, craft.noise.gradient())
    s:setBounds(p, 1.0)
    return s
end
function checker(n, threshold)
    threshold = threshold or 0.5
    local s = craft.noise.select()
    s:setSource(0, craft.noise.const(0))
    s:setSource(1, craft.noise.const(1))
    s:setSource(2, n)
    s:setBounds(threshold, 1.0)
    return s
end
function mult(n, m)
    local mn = craft.noise.multiply()
    mn:setSource(0, n)
    mn:setSource(1, craft.noise.const(m))
    return mn
end

function mapp(a, b, n)
    local s = craft.noise.select()
    s:setSource(0, a)
    s:setSource(1, b)
    s:setSource(2, n)
    s:setBounds(0.5, 10)
    return s
end

function noiseTree()
    local n = craft.noise.gradient()
    local zero = craft.noise.const(0)

    local n2 = invert(n)
    n = split(n, n2, SplitThresh or 0.5)
    n = turb(n, TurbFreq or 0.2, TurbSeed or 2, TurbPow or 0.2)
    n = mult(n, Mult or 1.5)
    --n = split(n, n2, 0.45)
    n = invert(n)
    n = checker(n, CheckerThresh or 0.4)

    return n
end
