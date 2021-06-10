package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var lavTxt:Bool = false;

	var lavNum:Int = 0;
	var bfNum:Int = 0;

	var llav:Int = -1;
	var lbf:Int = -1;

	var tLavPorts = [1];
	var tBfPorts = [1];

	var lavOff = [[30, 110], [0, 100], [80, 100], [0, 100], [100, 100], [-60, 70], [160, 230]];

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		lavNum = 0;
		bfNum = 0;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'nature' | 'nature old':
				FlxG.sound.playMusic(Paths.sound('CutsceneMus'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'nature' | 'tempting' | 'deam natura' | 'nature old' | 'tempting old' | 'deam natura old':
				lavTxt = true;
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		
		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;

		if (lavTxt) hasDialog = true;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'nature' | 'nature old':
				tLavPorts = [1, 2, 4, 1, 4, 4, 3, 4, 3, 1, 5, 5];
				tBfPorts = [1, 1, 1, 2, 1, 1];
			case 'tempting' | 'tempting old':
				tLavPorts = [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]; //putting a fuck ton so txts can be altered loooool
				tBfPorts = [2, 2, 2, 2, 2, 2, 2];
			case 'deam natura' | 'deam natura old':
				tLavPorts = [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7];
				tBfPorts = [2, 2, 2, 2, 2, 2, 2];
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (lavTxt)
		{
			box.frames = Paths.getSparrowAtlas('lavport/box', 'shared');
			box.animation.addByPrefix('normalOpen', 'LavPortrait.png', 24, false);
			box.animation.addByPrefix('normal', 'LavPortrait.png', 24, false);
			box.animation.addByPrefix('bf', 'BFPortrait.png', 24, false);
			box.width = 180;
			box.height = 170;
			box.x = 400;
			box.y = 340;
			box.antialiasing = true;
		}
			
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}

		if (lavTxt)
		{
			portraitLeft = new FlxSprite(-2200, 0);
			portraitLeft.frames = Paths.getSparrowAtlas('lavport/LavPortraits', 'shared');
			portraitLeft.animation.addByPrefix('enter', 'LavPort' + tLavPorts[0], 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.135));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			portraitLeft.antialiasing = true;
			add(portraitLeft);
			portraitLeft.visible = false;
			portraitLeft.alpha = 0;

			portraitRight = new FlxSprite(-2700, 150);
			portraitRight.frames = Paths.getSparrowAtlas('lavport/BFPortraits', 'shared');
			portraitRight.animation.addByPrefix('enter', 'BFPort' + tBfPorts[0], 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.12));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			portraitRight.antialiasing = true;
			add(portraitRight);
			portraitRight.visible = false;
			portraitRight.alpha = 0;
		}
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);
		portraitRight.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		var tX = 240;
		var tY = 500;

		if (lavTxt)
		{
			tX = 500;
			tY = 460 - 15;
			box.x += 160;
			box.y -= 15;
			portraitLeft.x -= 450;
			portraitRight.x -= 400;
		}
		dropText = new FlxText(tX + 2, tY + 2, Std.int(FlxG.width * 0.6), "", 45);
		dropText.font = 'Cutie Shark';
		dropText.color = 0xFFD1DC;
		add(dropText);

		swagDialogue = new FlxTypeText(tX, tY, Std.int(FlxG.width * 0.6), "", 45);
		swagDialogue.font = 'Cutie Shark';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('Generic_Text'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		portraitLeft.alpha += 0.03;
		portraitRight.alpha += 0.03;

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		switch (curCharacter)
		{
			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelBText'), 0.6)];
			default:
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('Generic_Text'), 0.6)];
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'nature' || PlayState.SONG.song.toLowerCase() == 'tempting' || PlayState.SONG.song.toLowerCase() == 'deam natura' || PlayState.SONG.song.toLowerCase() == 'nature old' || PlayState.SONG.song.toLowerCase() == 'tempting old' || PlayState.SONG.song.toLowerCase() == 'deam natura old')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					if (lavTxt)
					{
						var pInd = tLavPorts[lavNum];
						portraitLeft.animation.addByPrefix('enter', 'LavPort' + pInd, 24, false);
						portraitLeft.alpha = 0;
						box.animation.play('normal');
						portraitLeft.offset.set(lavOff[pInd - 1][0], lavOff[pInd - 1][1]);
					}
					portraitLeft.animation.play('enter');
				}
				else if (lavTxt)
				{
					var pInd = tLavPorts[lavNum];
					if (pInd != llav)
					{
						portraitLeft.animation.addByPrefix('enter', 'LavPort' + pInd, 24, false);
						portraitLeft.animation.play('enter');
						portraitLeft.offset.set(lavOff[pInd - 1][0], lavOff[pInd - 1][1]);
					}
				}
				if (lavTxt)
				{
					llav = tLavPorts[lavNum];
					lavNum ++;
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					if (lavTxt)
					{
						portraitRight.animation.addByPrefix('enter', 'BFPort' + tBfPorts[bfNum], 24, false);
						portraitRight.alpha = 0;
						box.animation.play('bf');
					}
					portraitRight.animation.play('enter');
				}
				else if (lavTxt)
				{
					if (tBfPorts[bfNum] != lbf)
					{
						portraitRight.animation.addByPrefix('enter', 'BFPort' + tBfPorts[bfNum], 24, false);
						portraitRight.animation.play('enter');
					}
				}
				if (lavTxt)
				{
					lbf = tBfPorts[bfNum];
					bfNum ++;
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
