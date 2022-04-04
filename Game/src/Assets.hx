class Assets
{
	private static var initialized:Bool = false;

	public static var water1(default, null):h2d.Tile;
	public static var water2(default, null):h2d.Tile;
	public static var boat(default, null):h2d.Tile;
	public static var ball(default, null):h2d.Tile;
	public static var bullet_n(default, null):h2d.Tile;
	public static var bullet_s(default, null):h2d.Tile;
	public static var bullet_w(default, null):h2d.Tile;
	public static var bullet_e(default, null):h2d.Tile;
	public static var kraken(default, null):h2d.Tile;
	public static var spawn(default, null):h2d.Tile;
	public static var heart(default, null):h2d.Tile;
	public static var heart_hurt(default, null):h2d.Tile;
	public static var explosion(default, null):h2d.Tile;

	public static var sfx_puddle(default, null):hxd.res.Sound;
	public static var sfx_dead(default, null):hxd.res.Sound;
	public static var sfx_shoot(default, null):hxd.res.Sound;

	public static var music_intro(default, null):hxd.res.Sound;
	public static var music_loop(default, null):hxd.res.Sound;

	public static var font(default, null):h2d.Font;

	public static function init()
	{
		if (Assets.initialized)
			return;
		Assets.initialized = true;

		water1 = hxd.Res.images.water1.toTile();
		water2 = hxd.Res.images.water2.toTile();
		boat = hxd.Res.images.boat.toTile();
		boat.dx = -boat.width * 0.5;
		boat.dy = -boat.height;
		ball = hxd.Res.images.ball.toTile();
		kraken = hxd.Res.images.kraken.toTile();
		spawn = hxd.Res.images.spawn.toTile();
		bullet_n = hxd.Res.images.bullet_n.toTile();
		bullet_s = hxd.Res.images.bullet_s.toTile();
		bullet_w = hxd.Res.images.bullet_w.toTile();
		bullet_e = hxd.Res.images.bullet_e.toTile();
		heart = hxd.Res.images.heart.toTile();
		heart_hurt = hxd.Res.images.heart_hurt.toTile();
		explosion = hxd.Res.images.explosion.toTile();
		explosion.dx = -explosion.width * 0.5;
		explosion.dy = -explosion.height;

		sfx_puddle = hxd.Res.sfx.footsteepsmud_002;
		sfx_dead = hxd.Res.sfx.BRRRRSSHPP;
		sfx_shoot = hxd.Res.sfx.cannonshot;

		music_intro = hxd.Res.music.Definitely_Not_A_Gladiator_Theme_v2___Intro;
		music_loop = hxd.Res.music.Definitely_Not_A_Gladiator_Theme_v2___Loop;

		font = hxd.Res.fonts.pokemonclassic.pokemonclassic.toFont();
	}
}
