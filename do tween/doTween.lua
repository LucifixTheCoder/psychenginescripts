_tweenData = {length = 0}
function doTween(object, values, duration, options, doErrors)
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
		tag = tag,
		doErrors = doErrors and true or false
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
end
function _tweenComplete(tag) 
	if _tweenData[tag] and _tweenData[tag].onComplete then 
		_tweenData[tag].onComplete()
		_tweenData[tag].onComplete = nil 
		_tweenData[tag].onUpdate = nil 
	end 
end
function _tweenUpdate(tag, p) 
	if _tweenData[tag] and _tweenData[tag].onUpdate then 
		_tweenData[tag].onUpdate(p)
	end 
end
function _tweenStart(tag) 
	if _tweenData[tag] and _tweenData[tag].onStart then 
		_tweenData[tag].onStart()
		_tweenData[tag].onStart = nil 
	end 
end