package en;

class Kraken extends Entity
{
	public static var ALL(default, null):Array<Kraken> = [];

	var attack_counter = 0;

	public function new(game:Game, cx:Int, cy:Int)
	{
		super(game, Assets.kraken);
		this.direction = Direction.S;
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

	override function destroy()
	{
		super.destroy();
		game.spawnEnemies(1);
		Assets.sfx_dead.play();
	}

	override function step()
	{
		super.step();
		if (this.destroyed)
			return;

		var point = this.direction.getPoint();
		if (game.isInBounds(this.cx + point.x, this.cy + point.y))
		{
			if (Entity.getAt(this.cx + point.x, this.cy + point.y) == null)
			{
				this.cx += point.x;
				this.cy += point.y;
			}
		}
		else
		{
			if (attack_counter == 2)
			{
				attack_counter = 0;
				this.sprite.y += 16; // do an attack move thing
				this.game.takeDamage();
			}
			attack_counter++;
		}
	}
}
