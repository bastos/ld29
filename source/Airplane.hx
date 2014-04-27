package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.plugin.MouseEventManager;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Airplane extends Entity
{
  public function new()
  {
    super(60, 38);
    loadGraphic('assets/images/airplane.png', false, 60, 38);
  }

  override public function update():Void
  {
    super.update();
  }

  override public function kill():Void
  {
    if(!exists)
      return;
    FlxG.camera.flash(0xffffffff,1, null);
    FlxG.camera.shake(0.02,0.35);
    super.kill();
  }

  override public function destroy():Void
  {
    super.destroy();

    if (x < FlxG.width + width) {
      exists = false;
    }
  }

  public function explode():Void {
    FlxG.sound.play("assets/sounds/explosion01.wav");
    var explosion:FlxEmitter = new FlxEmitter(x, y, 70);
    explosion.makeParticles("assets/images/explosionparticles.png", 20, 0, true);
    explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.8);
    explosion.start(true, .8);
    FlxG.state.add(explosion);
  }
}
