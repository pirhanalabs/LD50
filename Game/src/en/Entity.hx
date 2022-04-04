package en;

class Entity
{
	public static var ALL(default, null):Array<Entity> = [];

	public static function getAt(cx:Int, cy:Int)
	{
		for (ent in Entity.ALL)
		{
			if (ent.cx == cx && ent.cy == cy)
			{
				return ent;
			}
		}
		return null;
	}

	public var direction:Direction = Direction.S;
	public var sprite:h2d.Bitmap;

	public var cx(default, null):Int = 0;
	public var cy(default, null):Int = 0;

	var footX(default, null):Int = 0;
	var footY(default, null):Int = 0;

	var modScaleX:Float = 0;
	var modScaleY:Float = 0;

	var game:Game;

	public var destroyed(default, null) = false;

	public function new(game:Game, tile:h2d.Tile)
	{
		this.game = game;
		this.sprite = new h2d.Bitmap(tile);
		this.game.scroller.add(this.sprite, Game.LAYER_ENTITIES);
		ALL.push(this);
	}

	public function step()
	{
		// override this in subclasses for behavior
	}

	public function destroy()
	{
		this.destroyed = true;
	}

	public function dispose()
	{
		if (sprite != null)
		{
			sprite.remove();
		}
		ALL.remove(this);
	}

	public function update(dt:Float)
	{
		var targetX = cx * Reg.TILE_SIZE + footX;
		var targetY = cy * Reg.TILE_SIZE + footY;

		this.sprite.scaleX = 1 + this.modScaleX;
		this.sprite.scaleY = 1 + this.modScaleY;
		this.modScaleX *= 0.8;
		this.modScaleY *= 0.8;

		this.sprite.x += (targetX - this.sprite.x) * 0.2;
		this.sprite.y += (targetY - this.sprite.y) * 0.2;
	}
}
