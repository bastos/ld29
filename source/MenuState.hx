package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
  private var _instructions:FlxText;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

    var background = new FlxSprite(0, 0);
    background.loadGraphic('assets/images/cover.png');
    add(background);

    var title = new FlxText(0, 190, FlxG.width);
    title.setFormat(null, 35, FlxColor.WHITE, "center");
    add(title);
    title.text = "Submarines Vs. Airplanes";

    add(new FlxText(FlxG.width-130, FlxG.height - 20, 200, "A game by Tiago Bastos"));
    add(new FlxButton((FlxG.width / 2) - 40, FlxG.height - 200, "Start", startCallback));

    _instructions = new FlxText(0, 290, FlxG.width);
    _instructions.setFormat(null, 25, FlxColor.WHITE, "center");
    add(_instructions);
    _instructions.text = "Your King and Country Need You!";
    new FlxTimer(2.0, showHowToDrag, 1);
	}
  // Really dumb way to do this... unfortunately I don't have much time!
  private function showHowToDrag(Timer:FlxTimer):Void
  {
    _instructions.text = "Drag your submarines to avoid torpedoes!";
    new FlxTimer(2.0, showHowToShootAll, 1);
  }

  private function showHowToShootAll(Timer:FlxTimer):Void
  {
    _instructions.text = "Use SPACE to shoot from all submarines!";
    new FlxTimer(2.0, showHowToShoot, 1);
  }

  private function showHowToShoot(Timer:FlxTimer):Void
  {
    _instructions.text = "Use keyboard numbers #1, #2, #3 and #4 to shoot!";
    new FlxTimer(3.0, showHowToWait, 1);
  }

  private function showHowToWait(Timer:FlxTimer):Void
  {
    _instructions.text = "After shooting, wait to reload!";
    new FlxTimer(3.0, eraseMessage, 1);
  }

  private function eraseMessage(Timer:FlxTimer):Void
  {
    _instructions.text = "Good luck!";
  }

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}


  private function startCallback():Void
  {
      FlxG.switchState(new PlayState());
  }
}
