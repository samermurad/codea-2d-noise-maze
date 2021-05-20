-- NoiseMazeGeneration

-- Use this function to perform your initial setup
function setup()
    progs = {BasicMazeProg(), MazeCreatorProg(), MazeDrawProgram()}
    CurrentProgram = 1
    setParams()
    progs[CurrentProgram]:setup()
end

function setParams()
    parameter.number('SplitThresh', 0.1, 0.9, 0.5)
    parameter.number('Mult', 0.5, 2, 0.5)
    parameter.number('CheckerThresh', 0.1, 0.9, 0.8)
    
    parameter.number('TurbFreq', 0.1, 5, 0.2)
    parameter.number('TurbPow', 0.1, 1, 0.2)
    parameter.integer('TurbSeed', 0, 100000, 0)
    parameter.action('BumpSedd', function()
        TurbSeed = TurbSeed + 1
    end)
end
-- This function gets called once every frame
function draw()
    background(0)
    progs[CurrentProgram]:draw()
end

function touched(touch)
    if progs[CurrentProgram].touched then
        progs[CurrentProgram]:touched(touch)
    end
end

