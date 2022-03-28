package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class Credits extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['VS jELLYMID TEaM'],
		['THEGaBODIaZ', 'gabo', 'Creator - Main artist & Animator, Composer of Jellymid, Cover Creator of Atrocity MC Version, Charter', 'https://youtube.com/thegabodiaz', 0xFF5EEBD8],
		['TRaCEDINPURPLE', 'tiago', 'Co-Creator - Main Coder, Menus', 'https://youtube.com/tracedinpurple', 0xFF41009C],
    	[''],
		['ORIGINaL SONG BY'],
		['SaSTER', 'saster', 'Creator of Atrocity | Provider of the FLP/MIDI files!', 'https://www.youtube.com/channel/UCC4CkqOAwulRil3BEK9L3Mg', 0xFF41009C],
    	[''],
    	['DISCORD', 'discord', 'Join the Official Vs Steve Community Server', 'https://discord.gg/aNTVTshnvA', 0xFF41009C]
	];

    //background
	var bg:FlxSprite;
    //description
	var justTextInfo:FlxText;
    //color stuff
	var originalColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('creditsBGTest'));
        bg.x -= 10;
		bg.y -= 20;
		bg.scale.set(1.8, 1.8);
		bg.updateHitbox();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) 
            {
				optionText.x -= 70;
			}
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) 
            {				
                var icon:AttachedSprite = new AttachedSprite('crediticons/' + creditsStuff[i][1]);
                icon.xAdd = optionText.width + 10;
				icon.yAdd = optionText.height - 20;
			    icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		justTextInfo = new FlxText(50, 600, 1180, "", 32);
		justTextInfo.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		justTextInfo.scrollFactor.set();
		justTextInfo.borderSize = 2.4;
		add(justTextInfo);

		bg.color = creditsStuff[curSelected][4];
		originalColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if(accepted) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != originalColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			originalColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, originalColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var selctthing:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = selctthing - curSelected;
			selctthing++;

			if(!unselectableCheck(selctthing-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		justTextInfo.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
