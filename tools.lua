cores={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
--------------------------------------------------------
function create_canvas(x0,y0,x1,y1)
	canvas = {x0=x0,
            y0=y0,
            x1=x1,
            y1=y1,
            selected=false}

    canvas.pattern = random_pattern(PATTERN_SIZE)

    for y=0,canvas.y1-canvas.y0-1 do
        canvas[y] = {}
		for x=0,canvas.x1-canvas.x0-1 do
			canvas[y][x] = 0
		end
	end
    
    canvas.draw = function(canvas)
        local x0 = canvas.x0-1
        local x1 = canvas.x1-1
        local y0 = canvas.y0-1
        local y1 = canvas.y1-1
		for y=0,canvas.y1-canvas.y0-1 do
			for x=0,canvas.x1-canvas.x0-1 do
				pset(canvas.x0+x,canvas.y0+y,canvas[y][x])
			end
		end
        if canvas.selected then
            rect(x0,y0,x1,y1,8)
        else
            rect(x0,y0,x1,y1,0)
        end
	end

    canvas.update = function(canvas)
		for y=0,canvas.y1-canvas.y0-1 do
			for x=0,canvas.x1-canvas.x0-1 do
                local inputs = {x/128, y/128}  -- normalizados
                local val = run_program(canvas.pattern.prog, inputs)
                color = flr((val % 1) * canvas.pattern.palleteSize)
                canvas[y][x] = color
			end
		end 			 
    end
	
	return canvas
end
--------------------------------------------------------
function create_all_canvas(size)
    allCanvas = {}
    xStart = 1
    yStart = 1
    
    axisMax = flr(127/size)

    for i=0,axisMax-1 do
        x0 = xStart + (i * size) 
        if i>0 then
            x0 += i
        end
        x1 = x0 + size
        for i=0,axisMax-1 do
            y0 = yStart + (i * size) 
            if i>0 then
                y0 += i
            end
            y1 = y0 + size
            add(allCanvas,create_canvas(x0,y0,x1,y1))
        end
    end

    return allCanvas
end
--------------------------------------------------------
function run_program(prog, inputs)
    local value = 0
    for i=1, #prog do
        value = value + prog[i]:apply(inputs)
    end
    return value
end
--------------------------------------------------------
function random_pattern(size)
    local pattern = {}
    pattern.palleteSize = flr(rnd(PALLETE_MAX_SIZE)) + 2
    pattern.prog = {}
    for i=1,size do
        if rnd(100) < 50 then
            local action = actions[flr(rnd(#actions)) + 1]
            local const = rnd(2) - 1   
            local input_index = flr(rnd(2)) + 1
            add(pattern.prog, alter_const(const, action, input_index))
        else
            local action = actions[flr(rnd(#mix_actions)) + 1]
            local first = flr(rnd(2)) + 1
            add(pattern.prog, mix_values(action,first))
        end
    end
    return pattern
end
--------------------------------------------------------
function randomize_all()
    for canvas in all(ALL_CANVAS) do
        local patternSize = flr(rnd(PATTERN_SIZE)) + 1
        canvas.pattern = random_pattern(patternSize)
        canvas:update()
    end
    GENERATION = 0
end
--------------------------------------------------------
function returnMouseObj()
    Mouse = {
        x=0,
        y=0,
        sprite = 1,
        onCanvas = 1,
        button=0,
        button_clicked = false,
        click_max_buffer = 1,
        click_buffer = 0,
        update = function(self)
            self.mx = stat(32) 
            self.my = stat(33) 
            self.x = self.mx + 2
            self.y = self.my + 2
            self.button_clicked = self:left_clicked()
        end,

        draw = function (self)
            spr(self.sprite,self.mx,self.my)
        end,

        left_clicked = function(self)
            local button_now = stat(34)
            local mb = self.click_max_buffer
            if (self.button!=0) and (button_now==0) then
                self.click_buffer += 1
                if self.click_buffer > self.click_max_buffer then
                    self.button = button_now
                    self.click_buffer = 0
                    return true  

                end
            else
                self.button = button_now
                
            end
            return false
        end,

    }
    return Mouse
end
--------------------------------------------------------
function checkMouseCanvasCollision()
    for i, canvas in ipairs(ALL_CANVAS) do
        if (Mouse.x >= canvas.x0) and (Mouse.x <= canvas.x1-1) then
            if (Mouse.y >= canvas.y0) and (Mouse.y <= canvas.y1-1) then
                Mouse.onCanvas = i
            end
        end 
    end
end
--------------------------------------------------------
function checkMouseTopScreen(limit)
    local value = limit 
    if limit == nil then limit = 5 end
    if Mouse.y <= limit then
        return true
    else
        return false
    end
end
--------------------------------------------------------
function checkMouseBottonScreen()
    if Mouse.y >= 122 then
        return true
    else
        return false
    end
end
--------------------------------------------------------
function copyPattern(patternToCopy)
    local childPattern = {}
    childPattern.palleteSize = patternToCopy.palleteSize
    childPattern.prog = {}

    for func in all(patternToCopy.prog) do
        if func.inputIndex then
            add(childPattern.prog, alter_const(func.const, func.action, func.inputIndex))
        else
            add(childPattern.prog, mix_values(func.action, func.first))
        end
    end
    
    return childPattern
end
--------------------------------------------------------
function mutateSelected(selectedCanvasIndex)
    --make a copy of selected canvas and mutate
    local newPatterns = {}
    for selected in all(selectedCanvasIndex) do
        childPattern = copyPattern(ALL_CANVAS[selected].pattern)
        for func in all(childPattern.prog) do
            func:mutate()
        end
        add(newPatterns, childPattern) 
    end
    --if need more patterns, pick randomly of the picked ones
    while #newPatterns < #ALL_CANVAS do
        parentPattern = rnd(selectedCanvasIndex)
        childPattern = copyPattern(ALL_CANVAS[parentPattern].pattern)
        for func in all(childPattern.prog) do
            func:mutate()
        end
        add(newPatterns, childPattern)
    end
    --change the canvas on the screen
    for i=1,#ALL_CANVAS do
        ALL_CANVAS[i].pattern = newPatterns[i]
        ALL_CANVAS[i]:update()
    end
    --de-select all canvas
    for i=1,#ALL_CANVAS do
        ALL_CANVAS[i].selected = false
    end
end
--------------------------------------------------------
function create_generation_pop_up ()
    p = {
        x=40,
        y=2,
        color=8,


        draw = function(self, value)
            if checkMouseTopScreen() then
                local digits = #tostr(value)
                local adjustSize = (digits - 1) * 4

                rectfill(self.x-2-adjustSize/2,self.y-2,self.x+48+adjustSize/2,self.y+7,0)
                rect(self.x-2-adjustSize/2,self.y-2,self.x+48+adjustSize/2,self.y+7,7)
                print("generation "..value,self.x-adjustSize/2,self.y,self.color)
            end
        end,

        update = function()
        end
    }
    return p
end
--------------------------------------------------------
function create_varBox(x,y,color,value,minValue,maxValue)
    v = {
        x=x,
        y=y,
        color=color,
        value=value,
        minValue=minValue,
        maxValue=maxValue,

        draw = function(self) 
                local digits = #tostr(self.value)
                local adjustSize = (digits) * 4
                rectfill(self.x-2-adjustSize/2,self.y-2,self.x+adjustSize/2,self.y+7,0)
                rect(self.x-2-adjustSize/2,self.y-2,self.x+adjustSize/2,self.y+7,7)
                print(self.value,self.x-adjustSize/2,self.y,self.color)
        end,

        sumValue = function(self, value)
            self.value += value
            if self.value > self.maxValue then
                self.value = self.maxValue
            elseif self.value < self.minValue then
                self.value = self.minValue
            end
        end,
    }
    return v
end
--------------------------------------------------------
function create_button(x,y,color,text,varBox)
    b = {
        x=x,
        y=y,
        color=color,
        stdColor = color,
        pressedColor = 8,
        text=text,
        varBox=varBox,
        area = {x0=0,y0=0,x1=1,y1=1},
        clicked = false,
        clickTimer = 0,
        clickMaxTimer=5,

        on_click = function(self)
            self.clickTimer = self.clickMaxTimer
            self.clicked = true
        end,

        update = function(self)
            if self.clicked then
                self.clickTimer -= 1
                self.color = self.pressedColor
                if self.clickTimer < 0 then
                    self.clicked = false
                    self.color = self.stdColor
                end
            end
        end,

        draw = function(self)
            local digits = #tostr(self.text)
            local adjustSize = (digits) * 4
            rectfill(self.x-2-adjustSize/2,self.y-2,self.x+adjustSize/2,self.y+7,0)
            rect(self.x-2-adjustSize/2,self.y-2,self.x+adjustSize/2,self.y+7,self.color)
            print(self.text,self.x-adjustSize/2,self.y,self.color)
        end,
    }
    local digits = #tostr(b.text)
    local adjustSize = (digits) * 4
    b.area.x0 = b.x-2-adjustSize/2
    b.area.y0 = b.y-2
    b.area.x1 = b.x+adjustSize/2
    b.area.y1 = b.y+7
    return b
end
--------------------------------------------------------
function create_manager(x,y,minValue,maxValue,varTitle)
    m = {
        x=x,
        y=y,
        varTitle=varTitle,
        plusButton = create_button(x,y,7,"+"),
        minusButton = create_button(x+10,y,7,"-"),
        varBox = create_varBox(x+40,y+10,7,minValue,minValue,maxValue),

        draw = function(self)
            print(self.varTitle,self.x+15,self.y)
            self.plusButton:draw()
            self.minusButton:draw()
            self.varBox:draw()
        end,
    }
    m.plusButton.varBox = m.varBox
    m.minusButton.varBox = m.varBox
    return m
end
--------------------------------------------------------
function isMouseInsideArea(area)
    return (Mouse.x >= area.x0) and (Mouse.x <= area.x1) and
           (Mouse.y >= area.y0) and (Mouse.y <= area.y1)
end
--------------------------------------------------------
function checkButtonClick(button, action)
    if isMouseInsideArea(button.area) then
        action()
        return true
    end
    return false
end
--------------------------------------------------------
function checkMouseButtonClicks()
    if Mouse.button_clicked then

       if checkButtonClick(randomizeButton, randomize_all) then
            sfx(2)
            CHANGES = false
            SCENE = "canvas"
        end

       local managers = {patternSizeManager, canvasSizeManager, palleteSizeManager}
       for manager in all(managers) do
            if checkButtonClick(manager.plusButton, 
                            function()
                                manager.varBox:sumValue(1)
                                manager.plusButton:on_click()

                                sfx(0)
                            end) then
                CHANGES = true
            end
            if checkButtonClick(manager.minusButton, 
                function()
                    manager.varBox:sumValue(-1)
                    manager.minusButton:on_click()
                    sfx(1)
                end) then
                CHANGES = true
            end      
        end

        if CHANGES then
            if checkButtonClick(applyButton, 
                            function()
                                PATTERN_SIZE = palleteSizeManager.varBox.value
                                CANVAS_SIZE = canvasSizeManager.varBox.value
                                PALLETE_MAX_SIZE = palleteSizeManager.varBox.value

                                for i=1,#ALL_CANVAS do
                                    ALL_CANVAS[i] = nil
                                end

                                ALL_CANVAS = nil
                                ALL_CANVAS = create_all_canvas(CANVAS_SIZE)
                                GENERATION = 0
                                CHANGES = false
                                Mouse.onCanvas = 1
                                SCENE = "canvas"
                                sfx(3)
                            end) then
                            for i=1,#ALL_CANVAS do
                                ALL_CANVAS[i]:update()
                            end
            end
        end

    end
end
--------------------------------------------------------
function create_pop_up (x,y,text,conditionFunction)
    p = {
        x=x,
        y=y,
        color=7,
        text=text,

        draw = function(self)
            if conditionFunction() then
                local digits = #self.text
                local adjustSize = (digits) * 4

                rectfill(self.x,self.y-2,self.x+adjustSize+6,self.y+7,0)
                rect(self.x,self.y-2,self.x+adjustSize+6,self.y+7,7)
                print(self.text,self.x+2,self.y,self.color)
            end
        end,

        update = function()
        end
    }
    return p
end