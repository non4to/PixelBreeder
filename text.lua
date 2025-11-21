--this code is from: https://www.lexaloffle.com/bbs/?tid=31772

function whitespace(s, i)
    if i > #s then return 0
    elseif sub(s, i, i) == " " then return 1
    elseif sub(s, i, i) == "\n" then return 2
    else return 3 end
end

function split_words(s, c)
    local splits = {}
    local state = 0
    local i = 1
    while i<=#s do
        state = whitespace(s, i)
        local start_w = i
        local end_w = i
        local start_state = state
        while state == start_state do
            i += 1
            state = whitespace(s, i)
        end
        end_w = i - 1    
        add(splits, {t=start_state, d=sub(s, start_w, end_w)})
    end
    return splits
end

function word_wrap(splits, col_width, default_color)
    if default_color == nil then default_color = peek(0x5f25) end
    if col_width == nil then col_width = 32 end
    -- accumulate lines with split word data
    local c = 0
    result = {{""}}
    resultcolor = {{default_color}}
    for w in all(splits) do
        local color = default_color
        if w.c ~= nil then color = w.c end
        if c + #(w.d) > col_width then
            if w.t == 1 or w.t == 2 then
                add(result,{""})
                add(resultcolor,{color})
                c = 0
            else
                add(result,{w.d})
                add(resultcolor,{color})
                c = #(w.d)
            end
        else
            add(result[#result], w.d)
            add(resultcolor[#resultcolor],color)
            if w.t == 2 then c = 0 else c += #(w.d) end
        end
    end
    -- post-process: line break formatting
    splits = result
    rtext = {}
    rcolor = {}
    local srcidx = 1
    local lineidx = 1
    for line in all(splits) do
        rtext[lineidx] = ""
        rcolor[lineidx] = {}
        local wordidx = 1
        local charidx = 1
        for word in all(line) do
            if resultcolor[srcidx] ~= nil then
                rcolor[lineidx][charidx] = resultcolor[srcidx][wordidx]
            end
            for i=1,#word do
                local c = sub(word, i, i)
                if c == "\n" then 
                    lineidx += 1
                    charidx = 1
                    rtext[lineidx] = ""
                    rcolor[lineidx] = {}
                else
                    rtext[lineidx] = rtext[lineidx] .. c
                    charidx += 1
                end
            end
            wordidx += 1
        end
        srcidx += 1
        lineidx += 1
    end
    return rtext, rcolor
end

function split_fx(splits, mapping)
    for i=1,#splits do
        local m = mapping[splits[i].d]
        if m ~= nil then
            if m.d ~= nil then splits[i].d = m.d end
            if m.c ~= nil then splits[i].c = m.c end
        end
    end
    return splits
end

function render_color(text, colortab, x, y)
    local basex = x
    for i=1,#text do
        x = basex
        local c = 1
        local s = ""
        while c <= #text[i] do
            if colortab[i][c] ~= nil then
                print(s, x, y)
                x += #s * 4
                color(colortab[i][c])
                s = ""
            end
            s = s .. sub(text[i], c, c)
            c += 1
        end
        if #s > 0 then print(s, x, y) end
        y += 6
    end
end
