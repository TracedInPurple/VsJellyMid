package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = false;
		animation.add('bf', [0, 1, 2], 0, false, isPlayer);
		animation.add('bf-pixel', [3, 5, 4, 33], 0, false, isPlayer);
		animation.add('bfminecraft', [25, 27, 26, 32], 0, false, isPlayer);
		animation.add('gf-pixel', [6, 8, 7], 0, false, isPlayer);
		animation.add('gf-christmas', [6, 8, 7], 0, false, isPlayer);
		animation.add('bf-jelly', [9, 10, 11], 0, false, isPlayer);
		animation.add('skeleton', [12, 12, 12], 0, false, isPlayer);
		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
