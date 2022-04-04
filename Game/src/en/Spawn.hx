package en;

class Spawn extends Entity
{
	public static var ALL(default, null):Array<Spawn> = [];

	var timer = 1;

	public function new(game:Game, cx:Int, cy:Int)
	{
		super(game, Assets.spawn);
		this.cx = cx;
		this.cy = cy;
		this.sprite.x = cx * Reg.TILE_SIZE;
		this.sprite.y = cy * Reg.TILE_SIZE;
		ALL.push(this);
	}

	override function dispose()
	{
		super.dispose();
		ALL.remove(this);
	}

	override function step()
	{
		super.step();
		if (timer == 0)
		{
			this.destroy();
			var krak = new Kraken(this.game, this.cx, this.cy);
			for (bullet in en.Bullet.ALL)
			{
				if (bullet.cx == cx && bullet.cy == cy)
				{
					krak.destroy();
				}
			}
		}
		else
		{
			timer--;
		}
	}
}
