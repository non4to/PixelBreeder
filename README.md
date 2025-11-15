# PixelBreeder

The main goal of PixelBreeder is to act as a way to see evolution in action. In this case, each canvas is assigned a program with N functions. Each function receives the pixel x,y coordinates as input and outputs a number. This number carries on as input to all program's functions and in the end is used to assign a color to the imputed coordinates.

Here the user acts as the selection pressure, deciding which programs are allowed to go to the next generation by judging the images they generate.

This project was inspired by [picbreeder](https://nbenko1.github.io/#/). 

## SYSTEM

There are two types of functions. One that choses one coordinate (x or y) and alters it with a constant, and another that uses both coordinates. The first one may sum, take the difference, divide, or multiply the input by a constant or calculate the sin or cos of the input. The second one may sum, take the difference, divide, or multiply the input coordinates. The output of the functions is transformed into a color the is assigned to the pixel.

In each screen the user may chose any number of canvas that they want. Once the mutate button is pressed, the next generation of screen will have mutations of the selected canvas. These mutation may alter the constant value or even change the applied operation. 

It is possible to alter how many functions each program has, the size of each canvas and the number of colors used in the pallete. All within limits.

## TOOLS

    - [pico8]

## HOW TO USE

    - Game can be played [HERE](https://non4to.itch.io/pixel-breeder)

## STATUS

    - Finished
    - Maybe Future: Added option to choose palleter. Add new functions.



