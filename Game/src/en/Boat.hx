package en;

class Boat extends Entity
{
	public static var ALL(default, null):Array<Boat> = [];

	var action:Void->Void;

	public function new(game:Game, cx:Int, cy:Int)
	{
		super(game, Assets.boat);
		footX = 8;
		footY = 16;

		this.cx = cx;
		this.cy = cy;
		this.sprite.x = cx * Reg.TILE_SIZE + footX;
		this.sprite.y = cy * Reg.TILE_SIZE + footY;
		this.game.scroller.add(this.sprite, Game.LAYER_ENTITIES + 1);
		ALL.push(this);
	}

	override function step()
	{
		super.step();
		if (this.action != null)
		{
			this.action();
			this.action == null;
		}
	}

	override function dispose()
	{
		ALL.remove(this);
		super.dispose();
	}

	function move(dx:Int, dy:Int)
	{
		if (this.game.isInBounds(this.cx + dx, this.cy + dy))
		{
			this.action = () ->
			{
				this.cx += dx;
				this.cy += dy;
				this.direction = Direction.fromPoint(dx, dy);
				Assets.sfx_puddle.play();
				this.modScaleX = .2;
				this.modScaleY = -.2;
			};
			game.step();
		}
	}

	function spawnBullet(direction:Direction)
	{
		var point = direction.getPoint();
		if (this.game.isInBounds(this.cx + point.x, this.cy + point.y))
		{
			this.action = () ->
			{
				new Bullet(this.game, this.cx, this.cy, direction);
				Assets.sfx_shoot.play();
				// this is a weird fix to prevent getting killed instantly.
				// when we are the opposite direction of the spawned bullet,
				// it will kill us on the spot when the world is stepped.
				this.direction = direction;
			};
			game.step();
		}
	}

	override function update(dt:Float)
	{
		super.update(dt);

		if (this.direction.getPoint().x != 0)
		{
			this.sprite.scaleX *= this.direction.getPoint().x;
		}

		if (hxd.Key.isPressed(hxd.Key.W))
		{
			move(0, -1);
		}
		else if (hxd.Key.isPressed(hxd.Key.S))
		{
			move(0, 1);
		}
		else if (hxd.Key.isPressed(hxd.Key.A))
		{
			move(-1, 0);
		}
		else if (hxd.Key.isPressed(hxd.Key.D))
		{
			move(1, 0);
		}
		else if (hxd.Key.isPressed(hxd.Key.UP) || hxd.Key.isPressed(hxd.Key.I))
		{
			spawnBullet(Direction.N);
		}
		else if (hxd.Key.isPressed(hxd.Key.DOWN) || hxd.Key.isPressed(hxd.Key.K))
		{
			spawnBullet(Direction.S);
		}
		else if (hxd.Key.isPressed(hxd.Key.RIGHT) || hxd.Key.isPressed(hxd.Key.L))
		{
			spawnBullet(Direction.E);
		}
		else if (hxd.Key.isPressed(hxd.Key.LEFT) || hxd.Key.isPressed(hxd.Key.J))
		{
			spawnBullet(Direction.W);
		}
	}
}
