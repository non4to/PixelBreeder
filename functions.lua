actions = {"sum", "dif", "mult", "div","sin","cos"}
function alter_const(const,action,inputIndex)
    local f = {
        const = const,
        action = action,
        inputIndex = inputIndex,

        apply = function(self, inputs)
            local value = inputs[self.inputIndex]
            if self.action == "sum" then
                return value + self.const
            elseif self.action == "dif" then
                return value - self.const
            elseif self.action == "mult" then
                return value * self.const
            elseif self.action == "div" then
                if self.const == 0 then
                    return 9999
                else
                    return value / self.const
                end
            elseif self.action == "sin" then
                return sin(value)
            elseif self.action == "cos" then
                return cos(value)
            end
        end,

        mutate = function(self)
            local mutatations = {0,0,0,0,0,0,0,0,1,2}
            local mutation = rnd(mutatations)

            --const
            if mutation == 0 then
                self.const += rnd(2) - 1
                if rnd(100) < 2 then
                    self.const += self.const*0.5
                end
            --change action
            elseif mutation == 1 then
                self.action = rnd(actions)
            --change index
            elseif mutation == 2 then
                if self.inputIndex==1 then
                    self.inputIndex = 2
                else
                    self.inputIndex = 1
                end            
            end
        end,


    }
    return f
end
--------------------------------------------------------
mix_actions = {"sum", "dif", "mult", "div"}
function mix_values(action,first)
    local f = {
        action = action,
        first = first,

        apply = function(self, inputs)
            local value1 = 0
            local value2 = 0
            if self.first==1 then
                value1 = inputs[1]
                value2 = inputs[2]
            else
                value1 = inputs[2]
                value2 = inputs[1]
            end

            if self.action == "sum" then
                return value1 + value2
            elseif self.action == "dif" then
                return value1 - value2
            elseif self.action == "mult" then
                return value1 * value2
            elseif self.action == "div" then
                if value2 == 0 then
                    return 9999
                else
                    return value1 / value2
                end
            end
        end,

        mutate = function(self)
            local mutatations = {0,0,0,0,0,0,0,0,0,1}
            local mutation = rnd(mutatations)

            -- change x for y
            if mutation == 0 then
                if self.first==1 then
                    self.first=2
                else
                    self.first=1
                end
            -- change action
            elseif mutation == 1 then
                self.action = rnd(mix_actions)
            end
        end,

    }
    return f
end
