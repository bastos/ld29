package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;

class Iceberg extends FlxSprite
{
	public function new()
	{
		super(80, 112);
    loadGraphic('assets/images/icebergs.png', true, 80, 112);
    animation.frameIndex = FlxRandom.intRanged(0, 2);
    facing = FlxObject.RIGHT;
    x = FlxG.width + 1000;
    var _sfactor = FlxRandom.floatRanged(0.6, 1.5);
    scale = new FlxPoint(_sfactor, _sfactor);
    if (_sfactor <= 0.6) {
      velocity.x = 5;
      alpha = 0.4;
    } else if (_sfactor > 0.5 && _sfactor <= 1) {
      velocity.x = 20;
      alpha = 0.6;
    } else if (_sfactor >= 1) {
      velocity.x = 30;
      alpha = 1;
    }
	}

	override public function update():Void
	{
    super.update();

    if (x > FlxG.width + width) {
      exists = false;
    }
	}

	override public function kill():Void
	{
		if(!exists)
			return;

		super.kill();
	}

	public function onFlashDone():Void
	{
		FlxG.resetState();
	}
}
