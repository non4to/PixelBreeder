function _init()
    poke(0x5f2d,1)
    PATTERN_SIZE = 3
    CANVAS_SIZE = 25
    PALLETE_MAX_SIZE = 2
    GENERATION = 0
    CHANGES = false
    SCENE = "start"
    TITLE_COLOR = 2

    ALL_CANVAS = create_all_canvas(CANVAS_SIZE)
    Mouse = returnMouseObj()
    genPopUp = create_generation_pop_up()
    pausePopUp = create_pop_up(0,119,"press ❎ or 'x' to instructions",checkMouseBottonScreen)
    canvasPopUp1 = create_pop_up(15,119,"press ❎ or 'x' to mutate",checkMouseBottonScreen)
    canvasPopUp2 = create_pop_up(15,110,"press 🅾️ or 'z' to params",checkMouseBottonScreen)

    applyButton = create_button(60,90,7,"apply changes")
    randomizeButton = create_button(60,110,7,"randomize canvas")
    patternSizeManager = create_manager(25,3,1,15,"program max size")
    patternSizeManager.varBox.value = PATTERN_SIZE
    canvasSizeManager = create_manager(25,30,5,50,"canvas size")
    canvasSizeManager.varBox.value = CANVAS_SIZE
    palleteSizeManager = create_manager(25,57,1,15,"pallete max size")
    palleteSizeManager.varBox.value = PALLETE_MAX_SIZE 
    BUTTONS = {applyButton, randomizeButton}
    MANAGERS = {patternSizeManager, canvasSizeManager, palleteSizeManager}
end

function _update()
    Mouse:update()
    if SCENE == "canvas" then
        update_canvaScene()
    elseif SCENE == "pause" then
        update_pause()
    elseif SCENE == "start" then
        update_start()
    end
end

function _draw()
    cls()
    if SCENE == "canvas" then
        draw_canvaScene()
    elseif SCENE == "pause" then
        draw_pause()
    elseif SCENE == "start" then
        draw_start()
    end
    Mouse:draw()

    
    -- print("on canvas "..Mouse.onCanvas,0,0,8)
    -- print(Mouse.button_clicked,10,10,8)
    -- print("selected: "..tostr(ALL_CANVAS[Mouse.onCanvas].selected),0,20,8)

end

--o botao 4 vai abrir a outra tela pra mudar os valores que eu quero mudar
--o botao 5 vai mutar
