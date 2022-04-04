class Tile
{
	public var cx(default, null):Int = 0;
	public var cy(default, null):Int = 0;
	public var tile(default, null):h2d.Tile;
	public var entity:en.Entity;

	public function new(cx:Int, cy:Int, tile:h2d.Tile)
	{
		this.cx = cx;
		this.cy = cy;
		this.tile = tile;
	}
}
