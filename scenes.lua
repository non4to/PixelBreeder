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
end
----------------------------------------------------------------------------
function update_pause()
    --deal with button pressing
    checkMouseButtonClicks()

    --change scenes
    if btnp(4) then
        for i=1,#ALL_CANVAS do
            ALL_CANVAS[i]:update()
        end
        SCENE = "canvas"
    end
end
----------------------------------------------------------------------------
function draw_pause()
    -- isMouseInsideArea()




    patternSizeManager:draw()
    canvasSizeManager:draw()
    palleteSizeManager:draw()
    randomizeButton:draw()
    applyButton:draw()

end