--Made my Sp4rk1ngc0m3t
--Put this into a stage lua, if you understand how making a stage lua works there will be no issues
--if you are seeing the edge of the background at times it is recommended that you just increase the size of the image
sprite = 'bg' --name of the image you want moving in the background
size = 2048 --number of pixels from left to right
startX = -400 --where you want it to be from left to right
startY = 300 --where you want it to be from bottom to top
duration = 5 --how long it takes to scroll from one side of the screen to the other


function onCreate()
makeLuaSprite(sprite .. '1', sprite, startX, startY)
addLuaSprite(sprite .. '1', false)
makeLuaSprite(sprite .. '2', sprite, startX + size, startY)
addLuaSprite(sprite .. '2', false)
scrollA()
end


function scrollA()
doTweenX(sprite .. '1move',sprite .. '1', startX - size, duration)
doTweenX(sprite .. '2move',sprite .. '2', startX, duration)
end

function onTweenCompleted(tag)
if tag == (sprite .. '2move') then
scrollB()
end
if tag == (sprite .. '2move2') then
scrollA()
end
end
function scrollB()
doTweenX(sprite .. '1move2',sprite .. '1', startX, 0.001)
doTweenX(sprite .. '2move2',sprite .. '2', startX + size, 0.001)
end