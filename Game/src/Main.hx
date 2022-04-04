class Main extends hxd.App
{
	var game:Game;

	public static function main()
	{
		new Main();
	}

	override function init()
	{
		super.init();
		initEngine();
		initGame();
	}

	function initEngine()
	{
		hxd.snd.Manager.get();
		hxd.Timer.skip();
		hxd.Res.initEmbed();
		Assets.init();
		// engine.backgroundColor = 0xffffff;
		s2d.scaleMode = LetterBox(Reg.GAME_WID, Reg.GAME_HEI, false, Center, Center);
		// s2d.defaultSmooth = true;
	}

	function initGame()
	{
		this.game = new Game(this.s2d);
	}

	override function update(dt:Float)
	{
		super.update(dt);
		this.game.update(dt);
	}
}
