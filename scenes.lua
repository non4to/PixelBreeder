function update_canvaScene()
 -- update mouse state
    Mouse:update()
    -- see in which canvas the mouse is on
    checkMouseCanvasCollision()   
    -- act if mouse was clicked
    if Mouse.button_clicked then
        ALL_CANVAS[Mouse.onCanvas].selected = not ALL_CANVAS[Mouse.onCanvas].selected
    end
    -- randomize all canvas
    if btnp(4) then
        SCENE = "pause"
    end
    -- mutate
    if btnp(5) then
        local selectedCanvasIndexes = {}
        --get all selected canvas
        for i=1,#ALL_CANVAS do
            if ALL_CANVAS[i].selected then
                add(selectedCanvasIndexes, i)
            end
        end
        --only mutate if any canvas was selected
        if #selectedCanvasIndexes > 0 then
            sfx(4)
            GENERATION += 1
            mutateSelected(selectedCanvasIndexes)
        end
        
    end
end
----------------------------------------------------------------------------
function draw_canvaScene()
    for canvas in all(ALL_CANVAS) do
        canvas:draw()
    end
    local x0 = ALL_CANVAS[Mouse.onCanvas].x0-1
    local x1 = ALL_CANVAS[Mouse.onCanvas].x1
    local y0 = ALL_CANVAS[Mouse.onCanvas].y0-1
    local y1 = ALL_CANVAS[Mouse.onCanvas].y1
    rect(x0,y0,x1,y1,7)
    genPopUp:draw(GENERATION)
    canvasPopUp1:draw()
    canvasPopUp2:draw()
end
----------------------------------------------------------------------------
function update_pause()
    --deal with button pressing
    checkMouseButtonClicks()

    for button in all(BUTTONS) do
        button:update()
    end

    for manager in all(MANAGERS) do
        manager.plusButton:update()
        manager.minusButton:update()
    end


    --change scenes
    if btnp(4) then
        for i=1,#ALL_CANVAS do
            ALL_CANVAS[i]:update()
        end
        SCENE = "canvas"
    end
    if btnp(5) then
        SCENE = "start"
    end
end
----------------------------------------------------------------------------
function draw_pause()
    patternSizeManager:draw()
    canvasSizeManager:draw()
    palleteSizeManager:draw()
    randomizeButton:draw()
    applyButton:draw()
    print("---------- use mouse -----------",0,120,7)
    pausePopUp:draw()

    if checkMouseTopScreen(1) then
        local x0 = 0
        local y0 = 0
        local x1 = 127
        local y1 = 127
        rectfill(x0,y0,x1,y1,0)
        rect(x0,y0,x1,y1,5)

        local text = "\
program max size:\n max number of functions applied to a pixel of an image to calculate its color\
-> each image is made by a program that has N functions. each function gets (X,Y) of a pixel does math with it.\
-> the returned value is passed to the next function. the final value is converted to a color\
\ncanvas size:\n(sizeXsize) of each image in pixels\
\npallete max size:\n max number of different colors to be used"
        local z,zc = word_wrap(split_fx(split_words(text), {}),30)
        -- print("program max size:",x0+2,y0+2,7)
        -- print(" max number of functions used to calculate pixels color",x0+2,y0+10,7)
        render_color(z,zc,x0+2,y0)
    end

end
----------------------------------------------------------------------------
function update_start()
    --change scenes
    if btnp(4) then
        SCENE = "pause"
        sfx(4)
    end
end
----------------------------------------------------------------------------
function draw_start()
    -- y varia entre dois valores
    local title = "pixelbreeder"

    if time()%1==0 then
        TITLE_COLOR = flr(rnd(15))
    end

    for i=1,#title do
        local color = (TITLE_COLOR + i)%16
        if color==0 then 
            color = 1
        end
        print("\^w\^t"..title[i], 10+(i*8), (20 + sin(time()+i/5) * 2), color)
    end   

    local sX = 1
    local sY = 55
    rect(sX,sY,127,97,7)
    print("controls",49,44,7)
    print("- use mouse to choose pictures",sX+2,sY+4,5)
    print("- use mouse to change parameter",sX+2,sY+12,6)
    print("- ❎ or 'x' to mutate",sX+2,sY+20,7)
    print("- 🅾️ or 'z' change screens",sX+2,sY+28,5)
    print("- test different parameters!",sX+2,sY+36,6)
    print("press 🅾️ or 'z' to begin!",15,105,7)    
end