_tweenData = {length = 0}
function doTween(object, values, duration, options)
	options = options or {}
	addHaxeLibrary 'FunkinLua'
	addHaxeLibrary 'Reflect'
	_tweenData.length = _tweenData.length + 1
	local tag = options.tag or '___DOTWEEN'.._tweenData.length
	_tweenData[tag] = options
	runHaxeCode 'setVar("_tweenStuff", null);'
	setProperty('_tweenStuff', {
		object = object,
		values = values,
		duration = duration,
		options = options,
		has = { --maybe goes faster then??? idk
			onComplete = options.onComplete and true or false,
			onUpdate = options.onUpdate and true or false,
			onStart = options.onStart and true or false,
			ease = options.ease and true or false
		},
		tag = tag
	})
	runHaxeCode[[
		var data = getVar("_tweenStuff");
		if(data.has.onComplete) data.options.onComplete = _ -> game.callOnLuas('_tweenComplete', [data.tag]);
		if(data.has.onUpdate) data.options.onUpdate = t -> game.callOnLuas('_tweenUpdate', [data.tag, t.percent]);
		if(data.has.onStart) data.options.onStart = _ -> game.callOnLuas('_tweenStart', [t.onStart]);
		if(data.has.ease) data.options.ease = Reflect.field(FlxEase, data.options.ease);
		var obj = FunkinLua.getObjectDirectly(data.object);
		game.modchartTweens.set(data.tag, FlxTween.tween(obj, data.values, data.duration, data.options));
	]]
	local helper = {
		tag = tag,
		options = options,
		values = values,
		duration = duration,
		object = object,
		set = function(self, var, val)
			setProperty(self.tag..'.'..var, val)
		end,
		get = function(self, var)
			return getProperty(self.tag..'.'..var)
		end,
		reTween = doTweenFromHelper,
		destroyOnComplete = true --this is for the helper itself not the tween
	}
	_tweenData[tag].helper = helper
	return helper
end
function doTweenFromHelper(helper)
	return doTween(helper.object, helper.values, helper.duration, helper.options)
end
function _tweenComplete(tag) 
	if _tweenData[tag] and _tweenData[tag].onComplete then 
		_tweenData[tag].onComplete(_tweenData[tag].helper)
		_tweenData[tag].onComplete = nil 
		_tweenData[tag].onUpdate = nil 
		if _tweenData.helper.destroyOnComplete then _tweenData[tag].helper = nil end
	end 
end
function _tweenUpdate(tag, p) 
	if _tweenData[tag] and _tweenData[tag].onUpdate then 
		_tweenData[tag].onUpdate(p, _tweenData[tag].helper)
	end 
end
function _tweenStart(tag) 
	if _tweenData[tag] and _tweenData[tag].onStart then 
		_tweenData[tag].onStart(_tweenData[tag].helper)
		_tweenData[tag].onStart = nil 
	end 
end