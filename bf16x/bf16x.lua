dNotes = {} --table thats strumTime => notes pressed in that time
function onCreatePost()
	setProperty('boyfriend.visible', false)
	luaDebugMode = true
	anims = {'sing0123', 'idle'}
	for i=0,3 do --auto generate the animations :)
		for j=0,4 do
			if i ~= j and j > i then
				for o=0,4 do
					if o ~= j and o > j then
						o = (o == 4) and '' or o
						j = (j == 4) and '' or j
						table.insert(anims, 'sing'..i..j..o)
					end
				end
			end
		end
		table.insert(anims, 'sing'..i)
	end
	makeAnimatedLuaSprite('bf16x', 'bf16x', getMidpointX 'boyfriend', getMidpointY 'boyfriend')
	for i,anim in pairs(anims) do addAnimationByPrefix('bf16x', anim, anim..'0', 12, false) end --add al the animationsns
	playAnim('bf16x', 'idle')
	setProperty('bf16x.x', getProperty 'bf16x.x' - getProperty 'bf16x.width' / 2)
	setProperty('bf16x.y', getProperty 'bf16x.y' - getProperty 'bf16x.height' / 2)
	addLuaSprite('bf16x', true)
	local dualNotes = runHaxeCode([=[
		var dualNotes = [1 => 0]; //make a map in hscript???? no way
		dualNotes.remove(1);
		for(note in game.unspawnNotes)
		{
			if(!note.mustPress) continue; //dont include dad notes cause lame
			if(dualNotes.exists(note.strumTime)) //add note to list of notes in that strum time thing
				dualNotes.get(note.strumTime).push(note.noteData);
			else //or create it if it doesnt exist
				dualNotes.set(note.strumTime, [note.noteData]);
		}
		var luaDualNotes = [];
		for(key in dualNotes.keys()) {
			if(dualNotes.get(key).length > 1){
				var array = [key, dualNotes.get(key)]; //make it an array of [strumtime, [notes]]
				luaDualNotes.push(array);
			}
		}
		return luaDualNotes;
	]=])
	for k,v in pairs(dualNotes) do --sort notes and index the strumtimes to the notes
		table.sort(v[2], function(i, o) return i < o end)
		dNotes[v[1]] = v[2]
	end
end
function onBeatHit()
	if curBeat % 2 == 0 and animTimer <= 0 then playAnim('bf16x', 'idle') end --idle if the anim timer is done
end
animTimer = 0
function goodNoteHit(id, data, type, sus)
	local strumTime = math.floor(getPropertyFromGroup('notes', id, 'strumTime')) --floor the strum time cause yeah
	if dNotes[strumTime] then --check if theres chords/jumps/duals/whatevers notes there
		local theGreatest = true --only play anim if its the greatest note
		for k,v in pairs(dNotes[strumTime]) do
			if data < v then theGreatest = false end
		end
		if theGreatest then
			playAnim('bf16x', 'sing'..table.concat(dNotes[strumTime])) --add it all together
			animTimer = 0.5
		end
	else playAnim('bf16x', 'sing'..data) --or just play the normal anim
	end
end
function onUpdate(e)
	animTimer = animTimer - e
end