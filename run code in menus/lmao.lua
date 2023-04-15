function onCreate() 
    addHaxeLibrary 'Type'
    addHaxeLibrary 'Reflect'
	addHaxeLibrary 'Math'
	addHaxeLibrary 'FunkinLua'
	addHaxeLibrary 'MusicBeatState'
	addHaxeLibrary('Lua_helper', 'llua')
    local callbacks = runHaxeCode 'return [for(i in Lua_helper.callbacks.keys()) i];'
    for i,callback in pairs(callbacks) do
        runHaxeCode(callback..' = Lua_helper.callbacks.get("'..callback..'");')
    end
	luaDebugMode = true
end
--THIS CODE ALSO AFFECTS PLAYSTATE!!!!!!!!!!!!!!!
function onDestroy()
    runHaxeCode([[
		var import = thing -> {
			var ok = Type.resolveClass(thing);
			var splitty = thing.split('.');
			FunkinLua.hscript.variables.set(splitty[splitty.length-1], ok);
		}
		import('FreeplayState');
		import('Song');
		import('Highscore');
		import('flixel.text.FlxText');
		var ok;
		//these bypass private stuff cause hscript
		var state; //use this for accessing non static vars
		var class; //use this for accessing static vars
		var objs = new Array(); //uhhh i dont think this actually fixed anything lol!
		//use these functions if access stuff dont work!
		var getStaticVar = prop -> {
			return getPropertyFromClass('FreeplayState', prop);
		}
		var getVar = vari -> {
			return Reflect.field(state, vari);
		}
		var setStaticVar = (prop, value) -> {
			setPropertyFromClass('FreeplayState', prop, value);
		}
		var setVar = (vari, value) -> {
			Reflect.setField(state, vari, value);
		}
		var add = o -> {
			objs.push(o);
			state.add(o);
		}
		var create = () -> {
			state = FlxG.state;
			class = Type.getClass(state);
			curState = Type.getClassName(class);
			switch(curState) {
				case 'FreeplayState': 
					//little debug guy
					//ok = new FlxText(0, 0, 0, curState, 32);
					//add(ok);
			}
		}
		var remove = (o, keep) -> {
			if(!keep) objs.remove(o);
			state.remove(o);
		}
		var destroy = () -> {
			for(o in objs) {
				remove(o, true);
				o.destroy();
			}
			FlxG.signals.postUpdate.removeAll();
			FlxG.signals.postStateSwitch.removeAll();
			FlxG.signals.preStateSwitch.removeAll();
			if(curState == 'FreeplayState') Paths.clearUnusedMemory();
		}
		var elapsedTime = 0;
		var update = () -> {
			elapsedTime += FlxG.elapsed;
			switch(curState) {
				case 'FreeplayState':
					if(state.songs != null && state.instPlaying != class.curSelected && state.songs[class.curSelected] != null)
					{
						Paths.currentModDirectory = state.songs[class.curSelected].folder;
						var poop:String = Highscore.formatSong(state.songs[class.curSelected].songName.toLowerCase(), state.curDifficulty);
						PlayState.SONG = Song.loadFromJson(poop, state.songs[class.curSelected].songName.toLowerCase());
						
						FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
						state.instPlaying = class.curSelected;
					}
			}
		}
		FlxG.signals.postUpdate.add(update);
		FlxG.signals.postStateSwitch.add(create);
		FlxG.signals.preStateSwitch.add(destroy);
	]])
end