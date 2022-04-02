package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import PlayState;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;

	var jelly:Character;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'bf-minecraft':
				daBf = 'minecraftDEATH';
			case 'jellybean':
				daBf = 'jelly-death';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		if(PlayState.SONG.song.toLowerCase() == 'atrocity')
		{
			jelly = new Character(x, y, "jelly-death");
			add(jelly);
		}
		else
			{
				bf = new Boyfriend(x, y, daBf);
				add(bf);
			}

		if(PlayState.SONG.song.toLowerCase() == 'atrocity')
		{	
			camFollow = new FlxObject(jelly.getGraphicMidpoint().x, jelly.getGraphicMidpoint().y - 100, 1, 1);
			add(camFollow);
		}
		else
		{
			camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
			add(camFollow);
		}
		

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		
		if(PlayState.SONG.song.toLowerCase() == 'atrocity')
		{
			jelly.playAnim('firstDeath');
			FlxG.sound.play(Paths.sound('voicelines/waaaaa'), 1);		
		}
		else
		{
			bf.playAnim('firstDeath');
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if(PlayState.SONG.song.toLowerCase() == 'atrocity')
			{
				if (jelly.animation.curAnim.name == 'firstDeath' && jelly.animation.curAnim.curFrame == 12)
					{
						FlxG.camera.follow(camFollow, LOCKON, 0.01);
					}
			}
			else
			{
				if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
					{
						FlxG.camera.follow(camFollow, LOCKON, 0.01);
					}
			}


		if(PlayState.SONG.song.toLowerCase() == 'atrocity')
		{
			if (jelly.animation.curAnim.name == 'firstDeath' && jelly.animation.curAnim.finished)
				{
					//FlxG.sound.play(Paths.sound('voicelines/waaaaa'), 1);		
				}
		}
		else 
			{
				if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
					{
						FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), 0.4);
					}
			}
		

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
			//FlxG.sound.music.volume = 0.5;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if(PlayState.SONG.song.toLowerCase() == 'atrocity')
				jelly.playAnim('deathConfirm', true);
			else
				bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}