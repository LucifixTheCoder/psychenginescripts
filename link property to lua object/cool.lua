Property = {length = 0}
function Property:new(property, notSprite)
    self.length = self.length + 1
    local p = {property = property, members = {}} --members needs to update by a function
    function p:get(var)
        return getProperty(self.property..'.'..var)
    end
    function p:set(var, val)
        setProperty(self.property..'.'..var, val)
        return self;
    end
    function setPoint(var, x, y)
        self:set(var..'.x', x)
        self:set(var..'.y', y)
    end
    function setBlend(blend)
        setBlendMode(self.property, blend)
    end
    if not notSprite then
        function p:loadGraphic(graphic)
            p.curGraphic = graphic
            loadGraphic(p.property, graphic)
        end
        function p:setFrames(frames)
            p.curGraphic = frames
            setFrames(p.property, frames)
        end
        function p:addAnimByPrefix(anim, prefix, framerate, loops)
            addAnimationByPrefix(p.property, anim, prefix, framerate, loops)
        end
        function p:addAnimByIndices(anim, prefix, indices, framerate, loops)
            if loops then addAnimationByIndicesLoop(p.property, anim, prefix, table.concat(indices, ','), framerate)
            else addAnimationByIndices(p.property, anim, prefix, table.concat(indices, ','), framerate)
            end
        end
        function p:addAnim(anim, frames, framerate, loops)
            addAnimation(p.property, anim, frames, framerate, loops)
        end
        function p:playAnim(anim, forced, reverse, starts)
            playAnim(p.property, anim, forced, reverse, starts)
        end
        function p:addOffset(anim, x, y)
            addOffset(p.property, anim, x, y)
        end
        function p:setGraphicSize(width, height)
            setGraphicSize(p.property, width, height)
        end
        function p:setScale(x, y)
            scaleObject(p.property, x, y)
        end
        function p:updateHitbox()
            updateHitbox(p.property)
        end
    end
    --group functions
    function p:getMembers()
        local members = {}
        for i=0,self:get'length'-1 do
            members[i] = Property:new(self.property..'.members['..i..']')
        end
        self.members = members
        return self.members
    end
    function p:forEach(noUpdate)
        if not noUpdate then p:getMembers() end
        local i = -1
        return function()
            i = i + 1
            return self.members[i]
        end
    end
end
function Property:makeSprite(x, y, image)
    self.length = self.length + 1
    makeLuaSprite(self.length..'_propertySprite', image or '', x, y)
    return Property:new(self.length..'_propertySprite')
end
function add(property)
    addLuaSprite(property.property)
end
function onCreate()
    
end