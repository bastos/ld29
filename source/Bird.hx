package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class Bird extends FlxSprite
{
  public function new()
  {
    super(80, 112);
    loadGraphic('assets/images/bird.png', false, 32, 32);
    facing = FlxObject.RIGHT;
    x = FlxG.width + 1000;
    velocity.x = FlxRandom.intRanged(50, 100);
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
}
