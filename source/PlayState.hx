package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.plugin.MouseEventManager;
import flixel.text.FlxText;
import flixel.util.FlxSave;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
  private var _background:FlxSprite;
  private var _sealevel:FlxSprite;
  private var _icebergs:FlxTypedGroup<Iceberg>;
  private var _birds:FlxTypedGroup<Bird>;
  private var _submarines:FlxTypedGroup<Submarine>;
  private var _airplanes:FlxTypedGroup<Airplane>;
  private var _torpedoes:FlxTypedGroup<Torpedo>;
  private var _rocks:FlxTypedGroup<Rock>;
  private var _submarineNumbers:FlxTypedGroup<FlxText>;
	private var _gameSave:FlxSave;
	private var _scoreDisplay:FlxText;
	private var _bestScoreDisplay:FlxText;
	private var _bestScore:Int;
  private var _instructions:FlxText;

  var _deadc:Int = 0;
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

    Reg.score = 0;
    _gameSave = new FlxSave();
		_gameSave.bind("com.bastos.SubmarinesVersusAircrafts");

		if (_gameSave.data.bestScore == null) {
			_bestScore = 0;
		} else {
			_bestScore = _gameSave.data.bestScore;
		}

		FlxG.plugins.add(new MouseEventManager());

    _background = new FlxSprite(0, 0);
    _background.loadGraphic('assets/images/background.png');
    add(_background);

    // Add scores

    _scoreDisplay = new FlxText(-10, 10, FlxG.width);
    _scoreDisplay.setFormat(null, 70, FlxColor.GRAY, "right");
    add(_scoreDisplay);
    _scoreDisplay.text = Std.string(Reg.score);

    _bestScoreDisplay = new FlxText(10, 10, FlxG.width);
    _bestScoreDisplay.setFormat(null, 70, FlxColor.WHITE, "left");
    add(_bestScoreDisplay);
    _bestScoreDisplay.text = Std.string(_bestScore);

    // Add Icebergs
    var icebergPoolSize = 20;
    _icebergs = new FlxTypedGroup<Iceberg>(icebergPoolSize);

    for (i in 0...icebergPoolSize)
    {
        var iceberg = new Iceberg();
        _icebergs.add(iceberg);
    }

    add(_icebergs);

    // Add Rocks
    _rocks = new FlxTypedGroup<Rock>(10);

    for (i in 0...10)
    {
        var rock = new Rock();
        _rocks.add(rock);
    }

    add(_rocks);

    // Add Birds
    var birdsPoolSize = 10;
    _birds = new FlxTypedGroup<Bird>(birdsPoolSize);

    for (i in 0...birdsPoolSize)
    {
        var bird = new Bird();
        _birds.add(bird);
    }
    add(_birds);

    // Add submarines
    var submarinesPoolSize = 4;
    _submarines = new FlxTypedGroup<Submarine>(submarinesPoolSize);
    _submarineNumbers = new FlxTypedGroup<FlxText>(submarinesPoolSize);

    for (i in 0...submarinesPoolSize)
    {
        var sub = new Submarine();
        _submarines.add(sub);
        var submarineNumber = new FlxText(0, 10, FlxG.width, "#" + (i+1));
        _submarineNumbers.add(submarineNumber);
        sub.numberText = submarineNumber;

        var number:String = switch(i) {
            case 0: "ONE";
            case 1: "TWO";
            case 2: "THREE";
            case 3: "FOUR";
            case _: "ONE";
        }

        sub.number = number;

        sub.x = 0 + FlxRandom.intRanged(100, 400);
        sub.y = 300 + FlxRandom.intRanged(100, 300);
        sub.numberText.x = sub.x + sub.width/2;
        sub.numberText.y = (sub.y + sub.height/2) + 15;
    }

    add(_submarines);
    add(_submarineNumbers);


    // Add airplanes
    var airplanesPoolSize = 50;
    _airplanes = new FlxTypedGroup<Airplane>(airplanesPoolSize);

    for (i in 0...airplanesPoolSize)
    {
        var airplane = new Airplane();
        airplane.x = FlxG.width + 1000;
        _airplanes.add(airplane);
    }

    add(_airplanes);

    // Add torpedoes
    _torpedoes = new FlxTypedGroup<Torpedo>(100);
    for (i in 0...100)
    {
        var torpedo = new Torpedo();
        _torpedoes.add(torpedo);
    }

    add(_torpedoes);

    // Add Sealevel
    _sealevel = new FlxSprite(0, 0);
    _sealevel.loadGraphic('assets/images/sealevel.png');
    add(_sealevel);

    // Add timers
    new FlxTimer(15.0, addRock, 0);
    // Dummy...
    new FlxTimer(2.0, addRock, 1);

    new FlxTimer(15.0, addIceberg, 0);
    // Dummy...
    new FlxTimer(2.0, addIceberg, 1);

    new FlxTimer(10.0, addBird, 0);
    // Dummy...
    new FlxTimer(2.0, addBird, 1);

    new FlxTimer(3.0, addAirplane, 0);
    // Dummy...
    new FlxTimer(2.0, addAirplane, 1);
    FlxG.sound.playMusic("assets/music/nosubs.wav");
    FlxG.sound.muteKeys = ["m", "M", "S", "s"];
	}

  private function collisionIcebergRockCallback(object1:FlxSprite, object2:FlxSprite):Void
  {
    if (FlxG.pixelPerfectOverlap(object1, object2))
    {
      var submarine:Submarine = cast(object1, Submarine);
      submarine.explode() ;
      submarine.kill();
      _deadc += 1;
    }
  }

  private function collisionTorpedoIcebergRockCallback(object1:FlxSprite, object2:FlxSprite):Void
  {
    if (FlxG.pixelPerfectOverlap(object1, object2) && object1.isOnScreen() && object2.isOnScreen())
    {
      var torpedo:Torpedo = cast(object1, Torpedo);
      if (torpedo.alive) {
        torpedo.explode() ;
        torpedo.kill();
        torpedo.alive = false;
        FlxG.sound.play("assets/sounds/explosion03.wav");
        FlxG.camera.flash(0xffffffff,1, null);
        FlxG.camera.shake(0.02,0.25);
      }
    }
  }

  private function collisionTorpedoSubmarineCallback(object1:FlxSprite, object2:FlxSprite):Void
  {
    if (FlxG.pixelPerfectOverlap(object1, object2))
    {
      var submarine:Submarine = cast(object2, Submarine);
      var torpedo:Torpedo = cast(object1, Torpedo);
      if (torpedo.owner != submarine)
      {
        submarine.explode() ;
        submarine.kill();
        _deadc += 1;

        torpedo.explode() ;
        torpedo.kill();
      }
    }
  }

  private function collisionTorpedoAirplaneCallback(object1:FlxSprite, object2:FlxSprite):Void
  {
    if (FlxG.pixelPerfectOverlap(object1, object2))
    {
      var airplane:Airplane = cast(object2, Airplane);
      var torpedo:Torpedo = cast(object1, Torpedo);
      var isOwnerAAirplane = Type.getClass(torpedo.owner) == Airplane;

      if (!isOwnerAAirplane)
      {
        FlxG.sound.play("assets/sounds/coin.wav");
        Reg.score += 1;
        airplane.explode() ;
        airplane.kill();

        torpedo.explode() ;
        torpedo.kill();
      }
    }
  }

  private function addBird(Timer:FlxTimer):Void
  {
    var bird = _birds.recycle(Bird);

    if (!bird.isOnScreen())
    {
      bird.exists = true;
      bird.y = FlxRandom.intRanged(100, 200);
      bird.x = -50;
    }

    // Roll the dice
    if (FlxRandom.intRanged(1, 5) == 3)
    {
      new FlxTimer(FlxRandom.intRanged(10, 15), addBird, 1);
    }
  }

  private function addAirplane(Timer:FlxTimer):Void
  {
    var airplane = _airplanes.recycle(Airplane);

    if (!airplane.isOnScreen())
    {
      airplane.exists = true;

      if (FlxRandom.chanceRoll(50))
      {
        airplane.y = FlxRandom.intRanged(50, 200);
        airplane.x = FlxG.width + 100;
        airplane.facing = FlxObject.LEFT;
        airplane.velocity.x = -FlxRandom.intRanged(100, 500);
        airplane.flipX = false;
      } else {
        airplane.flipX = true;
        airplane.y = FlxRandom.intRanged(50, 200);
        airplane.x = -100;
        airplane.facing = FlxObject.RIGHT;
        airplane.velocity.x = FlxRandom.intRanged(100, 500);
      }
    }

    // Roll the dice
    if (FlxRandom.chanceRoll(10 * (_deadc + 1)))
    {
      new FlxTimer(FlxRandom.intRanged(2, 5), addAirplane, FlxRandom.intRanged(1, 1+_deadc));
    }
  }

  private function addIceberg(Timer:FlxTimer):Void
  {
    var iceberg = _icebergs.recycle(Iceberg);

    if (!iceberg.isOnScreen())
    {
      iceberg.exists = true;
      iceberg.y = 230;
      iceberg.x = -100;
    }

    if (FlxRandom.chanceRoll(30))
    {
      new FlxTimer(FlxRandom.intRanged(10, 15), addIceberg, 1);
    }
  }

  private function addRock(Timer:FlxTimer):Void
  {
    var rock = _rocks.recycle(Rock);

    if (!rock.isOnScreen())
    {
      rock.exists = true;
      rock.animation.frameIndex = FlxRandom.intRanged(0, 5);
      rock.y = FlxG.height - (rock.height * rock.scale.y);
      rock.x = -100;
    }

    if (FlxRandom.chanceRoll(50))
    {
      new FlxTimer(FlxRandom.intRanged(10, 15), addRock, 1);
    }
  }

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

  function finishGame():Void
  {
    FlxG.resetState();
  }

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		_scoreDisplay.text = Std.string(Reg.score);


    FlxG.overlap(_submarines, _icebergs, collisionIcebergRockCallback);
    FlxG.overlap(_submarines, _rocks, collisionIcebergRockCallback);

    FlxG.overlap(_torpedoes, _icebergs, collisionTorpedoIcebergRockCallback);
    FlxG.overlap(_torpedoes, _rocks, collisionTorpedoIcebergRockCallback);

    FlxG.overlap(_torpedoes, _submarines, collisionTorpedoSubmarineCallback);
    FlxG.overlap(_torpedoes, _airplanes, collisionTorpedoAirplaneCallback);

    var submarine:Submarine;
    for (submarine in _submarines)
    {
      if (submarine.firing)
      {
        var torpedo = _torpedoes.recycle(Torpedo);
        torpedo.alive = true;
        torpedo.velocity.x = 0;
        torpedo.owner = submarine;

        if (submarine.y <= 260)
        {
          torpedo.resistence = -10;
        } else {
          torpedo.resistence = submarine.y/10;
        }

        torpedo.exists = true;
        torpedo.x = submarine.x + 10;
        torpedo.y = submarine.y - 10;
        torpedo.angle = 360;
        torpedo.facing = FlxObject.UP;
      }
    }

    var airplane:Airplane;
    for (airplane in _airplanes)
    {
      if (airplane.exists && !airplane.reloading && airplane.isOnScreen())
      {
        airplane.firing = true;
        FlxG.sound.play("assets/sounds/shoot02.wav");
        airplane.reloadingTime = Std.int(100 / (_deadc + 1));
        var torpedo = _torpedoes.recycle(Torpedo);
        torpedo.alive = true;

        if (airplane.facing == FlxObject.LEFT)
        {
          torpedo.angle = 30;
        } else {
          torpedo.angle = -30;
        }

        torpedo.resistence = 0;
        torpedo.owner = airplane;
        torpedo.velocity.x = airplane.velocity.x/3;
        torpedo.exists = true;
        torpedo.x = airplane.x + 10;
        torpedo.y = airplane.y - 10;
        torpedo.facing = FlxObject.DOWN;
      }
    }

		if (Reg.score > _bestScore) {
			_gameSave.data.bestScore = Reg.score;
			_gameSave.flush();
		}

    if (_deadc >= 4)
    {
      FlxG.camera.flash(0xffffffff,1, finishGame);
      FlxG.camera.shake(0.03,0.45);
    }

		if(FlxG.keys.anyJustPressed(["R","E"])) {
			FlxG.resetState();
		}
	}
}
