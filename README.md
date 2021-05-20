# NoiseMaze.codea

project uses the Codea built-in noise lib to generate 2d side scrolling
mazes.

Proejct currently includes three demo programs


### Program 1: BasicMazeProg

Generates a 2d maze that fits screen size.
allows user to control params of noise to manipulate the generated
output.

output can be saved to project folder.


### Program 2: MazeCreatorProg

Allows the generation of multiple 2d mazes, concatinated to one another.
Mazes are currently (128x128) in size, this is to allow future
reading of the generated images in order to build levels.

Same params from previous program are included.

It is possible to add a couple of mazes together, saving the result
creates a new codea project drawing the outputted sprites.


### Program 3: MazeDrawProgram (Extra)

Initial added for testing purposes, currently allows to draw a maze
manually (cell size is set to 32)

so bacisally a pixel art maze drawing program.

output can be saved to project folder.

Requires the AxisPad Project as a dependency