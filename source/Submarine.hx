package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.plugin.MouseEventManager;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.text.FlxText;

class Submarine extends Entity
{
  var _followMouse = false;
  var _mouseOver = false;
  public var numberText:FlxText;
  public var number:String;

  public function new()
  {
    super(64, 26);
    loadGraphic('assets/images/submarine.png', true, 64, 26);
    animation.frameIndex = 0;
    facing = FlxObject.RIGHT;
    reloadingTime = 150;
    MouseEventManager.add(this, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
  }

  function onMouseDown(sprite:FlxSprite)
  {
    _followMouse = true;
  }

  function onMouseUp(sprite:FlxSprite)
  {
    _followMouse = false;
  }

  function onMouseOver(sprite:FlxSprite)
  {
    _mouseOver = true;
  }

  function onMouseOut(sprite:FlxSprite)
  {
    _mouseOver = false;
  }

  override public function update():Void
  {
    super.update();

    if (_mouseOver) {
      animation.frameIndex = 1;
    } else if (!reloading) {
      animation.frameIndex = 2;
    } else {
      animation.frameIndex = 0;
    }

    if (_followMouse && FlxG.mouse.y > 255)
    {
        x = FlxG.mouse.x - width/2;
        y = FlxG.mouse.y - height/2;
        numberText.x = x + width/2;
        numberText.y = (y + height/2) + 15;
    }

    if(FlxG.keys.anyJustPressed([number, "SPACE"]) && !reloading) {
      FlxG.sound.play("assets/sounds/shoot02.wav");
      firing = true;
    }


    if (FlxG.mouse.y < 245)
    {
      _followMouse = false;
    }
  }

  override public function kill():Void
  {
    if(!exists)
      return;
    FlxG.camera.flash(0xffffffff,1, null);
    FlxG.camera.shake(0.02,0.35);
    numberText.kill();
    alive = false;
    super.kill();
  }

  public function onFlashDone():Void
  {
    FlxG.resetState();
  }

	override public function destroy():Void
	{
		MouseEventManager.remove(this);
		super.destroy();
	}

  public function explode():Void {
    FlxG.sound.play("assets/sounds/explosion02.wav");
    var explosion:FlxEmitter = new FlxEmitter(x, y, 70);
    explosion.makeParticles("assets/images/explosionparticles.png", 20, 0, true);
    explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.8);
    explosion.start(true, .8);
    FlxG.state.add(explosion);
  }
}
