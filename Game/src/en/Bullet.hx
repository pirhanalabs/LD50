package en;

class Bullet extends Entity
{
	public static var ALL(default, null):Array<Bullet> = [];

	public var turn_alive = 0;

	public function new(game:Game, cx:Int, cy:Int, direction:Direction)
	{
		super(game, null);
		this.direction = direction;
		this.cx = cx;
		this.cy = cy;
		this.sprite.x = cx * Reg.TILE_SIZE;
		this.sprite.y = cy * Reg.TILE_SIZE;
		setSprite();
		ALL.push(this);
	}

	override function dispose()
	{
		super.dispose();
		ALL.remove(this);
	}

	function setSprite()
	{
		switch (this.direction)
		{
			case N:
				this.sprite.tile = Assets.bullet_n;
			case S:
				this.sprite.tile = Assets.bullet_s;
			case W:
				this.sprite.tile = Assets.bullet_w;
			case E:
				this.sprite.tile = Assets.bullet_e;
		}
	}

	function collide(ent:Entity)
	{
		if (this.destroyed)
			return;

		if (!Std.isOfType(ent, Boat))
		{
			if (Std.isOfType(ent, Kraken))
			{
				this.direction = this.direction.getOpposite();
				ent.destroy();
				this.game.addPoint();
			}
			else if (Std.isOfType(ent, Bullet))
			{
				var other:Bullet = cast(ent, Bullet);
				// if we have the same direction, we dont change anything.
				if (other.direction == this.direction)
					return;
				other.direction = this.direction; // we push the other one in the direction we want.
				other.setSprite(); // we only set the other one as ours will be switched already
				// this.destroy();
				this.direction = this.direction.getOpposite();
			}
		}
		else
		{
			for (boat in Boat.ALL)
			{
				boat.sprite.tile = Assets.explosion;
			}
			for (i in 0...Reg.lives)
			{
				game.takeDamage();
			}
			// game.gameOver();
			Assets.sfx_dead.play();
		}
	}

	override function step()
	{
		super.step();
		if (turn_alive == 15)
		{
			this.destroy();
			return;
		}
		turn_alive++;

		var point = this.direction.getPoint();

		// if the bullet hits a wall, move another direction for next step
		// while (!this.game.isInBounds(this.cx + point.x, this.cy + point.y))
		// {
		// 	this.direction = this.direction.getOpposite();
		// 	point = this.direction.getPoint();
		// }

		if (this.game.isInBounds(this.cx + point.x, this.cy + point.y))
		{
			cx += point.x;
			cy += point.y;
		}

		// if the bullet hits a wall, move another direction for next step
		while (!this.game.isInBounds(this.cx + point.x, this.cy + point.y))
		{
			this.direction = this.direction.getOpposite();
			point = this.direction.getPoint();
		}

		// if we hit another entity, handle it
		for (ent in Entity.ALL)
		{
			if (ent.cx == this.cx && ent.cy == this.cy && ent != this)
			{
				collide(ent);
				break;
			}
			// we check a special case where an entity crossed a bullet.
			// if we cross a bullet, we should be dead.
			if (ent.direction == this.direction.getOpposite() && ent != this)
			{
				if (!this.direction.vertical())
				{
					if (ent.cx == this.cx + point.x * -1 && this.cy == ent.cy)
					{
						collide(ent);
						break;
					}
				}
				else
				{
					if (ent.cy == this.cy + point.y * -1 && this.cx == ent.cx)
					{
						collide(ent);
						break;
					}
				}
			}
		}

		setSprite();
	}
}
