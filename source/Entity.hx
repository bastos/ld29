package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class Entity extends FlxSprite
{
  public var firing = false;
  public var reloadingTime = 100;
  public var lastFire:Int = 0;
  public var reloading = false;

  override public function update():Void
  {
    super.update();

    if (lastFire >= reloadingTime) {
      lastFire = 0;
      reloading = false;
    }

    if (firing == true) {
      firing = false;
      reloading = true;
    }

    if (reloading) {
      lastFire += 1;
    }
  }
}
