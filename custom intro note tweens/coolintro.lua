--every function in this table is called 4 times for each note
tweens = {
  --[[
  --EXAMPLES
  --i: the current notes index for their strum group
  --isPlayer: uhhh idk
  --strum: name of the strum group (opponentStrums and playerStrums)
  --set: a function that can be used to set a property in the current note
  --get: a function that can be used to get a property from the current note
  --tween: a function that tweens the current note
    --tween function stuff
    --vars: just like in haxeflixel, this should be a table of variables and what to tween them to
    --duration: NO CLUE!!!!!!
    --options: options for the flxtween, supports onComplete and onStart!! cool!!
  dad = function(i, isPlayer, strum, set, get, tween)
    local d = downscroll and -1 or 1
    set('y', get 'y' + 900*d)
    tween({y = get 'y' - 920*d}, 0.5, {startDelay = 0.5 + (0.2 * i), ease = 'cubeOut', onComplete = function()
      tween({y = get 'y' + 30*d}, 0.25, {ease = 'cubeIn', onComplete = function()
        tween({y = get 'y' - 10*d}, 0.25/2, {ease = 'backOut'})
      end})
    end})
  end,
  bf = function(i, isPlayer, strum, set, get, tween)
    set('x', get 'x' + 550)
    set('angle', 180)
    tween({angle = 0, x = get 'x' - 550}, 1, {startDelay = 0.5 + (0.2 * i), ease = 'cubeOut'})
  end
  ]]
}
tweenNum = 0
function onStartCountdown()
  setProperty('skipArrowStartTween', true)
  luaDebugMode = true
end
function onCountdownStarted()
  local stuff = function(func, char)
    local isPlayer = char == boyfriendName
    local strum = isPlayer and 'playerStrums' or 'opponentStrums'
    for i=0,3 do 
      local set = function(variable, value)
        setPropertyFromGroup(strum, i, variable, value)
      end
      local get = function(variable)
        return getPropertyFromGroup(strum, i, variable)
      end
      local tween = function(vars, duration, options)
        local curTweenNum = tweenNum
        local tag = options.tag or 'CUSTOM_INTRO_TWEEN_'..tostring(curTweenNum)
        runHaxeCode('setVar("CUSTOM_INTRO_tweenstuff", null);')
        setProperty('CUSTOM_INTRO_tweenstuff', {vars = vars, duration = duration, options = options, i = i})
        if options.onComplete then
          local a = onTweenCompleted
          local b = options.onComplete
          local tagtag = tag
          function onTweenCompleted(tag)
            if a then
              a(tag)
            end
            if tag == tagtag then
              b()
            end
          end
        end
        if options.onStart then
          local a = onTweenStarted
          local b = options.onStart
          local tagtag = tag
          function onTweenStarted(tag)
            if a then
              a(tag)
            end
            if tag == tagtag then
              b()
            end
          end
        end
        local idiotTag = '"'..tag:gsub('"', '\\"')..'"'
        runHaxeCode([[
          var stuff = getVar('CUSTOM_INTRO_tweenstuff');
          if(stuff.options != null && stuff.options.ease != null)
            stuff.options.ease = FlxEase.]]..(options.ease or '')..[[;
          var strum = game.]]..strum..[[.members[stuff.i];
          if(stuff.options == null)
            stuff.options = {onComplete: function(twn:FlxTween) {}, onStart: function(twn:FlxTween) {}};
          stuff.options.onComplete = function(twn:FlxTween)
            game.callOnLuas('onTweenCompleted', []]..idiotTag..[[]);
          stuff.options.onStart = function(twn:FlxTween)
            game.callOnLuas('onTweenStarted', []]..idiotTag..[[]);
          game.modchartTweens.set(]]..idiotTag..[[, FlxTween.tween(strum, stuff.vars, stuff.duration, stuff.options));
          setVar('CUSTOM_INTRO_tweenstuff', null);
        ]])
        tweenNum = tweenNum + 1
      end
      func(i, isPlayer, strum, set, get, tween) 
    end
  end
  for i,char in pairs{dadName, boyfriendName} do
    if tweens[char] then
      stuff(tweens[char], char)
    else
      stuff(function(i, isPlayer, strum, set, get, tween) --just does the normal shit
        set('alpha', 0)
        tween({alpha = 1}, 1, {startDelay = 0.5 + (0.2 * i), ease = 'circOut'})
      end, char)
    end
  end
end