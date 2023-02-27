### you can do COOL with this.....

example on what an inserted piece of code should look likee

```lua
characternamehere = function(i, isPlayer, strum, set, get, tween) --last three are functions
    --this function will be called four times for each strum note
    local d = downscroll and -1 or 1 --downscroll stuff
    set('y', get 'y' + 900*d) --move the current note down 900 pixels (or up if downscroll), works for any strum property
    tween({y = get 'y' - 920*d}, 0.5, {startDelay = 0.5 + (0.2 * i) --[[start delay affected by what note it is (like i in a for loop)]], ease = 'cubeOut', onComplete = function() --tween the current note up/down 920 pixels
      tween({y = get 'y' + 30*d}, 0.25, {ease = 'cubeIn', onComplete = function() --this part is called when the previous tween ends
        tween({y = get 'y' - 10*d}, 0.25/2, {ease = 'backOut'})
      end})
    end})
end
```