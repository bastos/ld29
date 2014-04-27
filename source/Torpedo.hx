package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Torpedo extends FlxSprite
{
  public var owner:Entity;
  public var resistence:Float = 0;

  public function new()
  {
    super(16, 32);
    loadGraphic('assets/images/torpedo.png', false, 16, 32);
    facing = FlxObject.UP;
    x = FlxG.width + 1000;
  }

  override public function update():Void
  {
    super.update();

    if (!isOnScreen())
    {
      exists = false;
    }

    if (facing == FlxObject.UP)
    {
      flipY = false;
      velocity.y = -100 + resistence;
    } else if(facing == FlxObject.DOWN) {
      velocity.y = 100 - resistence;
      flipY = true;
    }
  }

  override public function kill():Void
  {
    if(!exists)
      return;

    super.kill();
  }

  public function explode():Void
  {
    var explosion:FlxEmitter = new FlxEmitter(x, y, 70);
    explosion.makeParticles("assets/images/explosionparticles.png", 10, 0, true);
    explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.8);
    explosion.start(true, .8);
    FlxG.state.add(explosion);
  }
}
