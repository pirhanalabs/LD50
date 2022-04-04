import en.Boat;
import h2d.Bitmap;
import pirhana.heaps.CustomText;

class Game
{
	var s2d:h2d.Scene;

	public static inline var LAYER_TILES = 0;
	public static inline var LAYER_ENTITIES = 1;

	public var scroller(default, null):h2d.Layers;

	var MAP_WIDTH = 7;
	var MAP_HEIGHT = 7;
	var map:Array<h2d.Bitmap> = [];
	var mapContainer:h2d.Object;

	var SPAWN_COUNTER = 7;
	var spawn_timer:Int;

	var hearts:Array<h2d.Bitmap> = [];
	var gameover = false;

	var text_gameover:h2d.Text;
	var text_score:h2d.Text;
	var text_best_score:h2d.Text;
	var text_hints:h2d.Text;

	public function new(s2d:h2d.Scene)
	{
		this.s2d = s2d;
		init();
	}

	function init()
	{
		this.scroller = new h2d.Layers(s2d);
		this.mapContainer = new h2d.Object();
		this.scroller.add(mapContainer, LAYER_TILES);
		this.map = [
			for (y in 0...MAP_HEIGHT)
			{
				for (x in 0...MAP_WIDTH)
				{
					var bitmap = new h2d.Bitmap(Math.random() < 0.4 ? Assets.water1 : Assets.water2, this.mapContainer);
					bitmap.x = x * 16;
					bitmap.y = y * 16;
					bitmap;
				}
			}
		];
		this.scroller.x = Reg.GAME_WID * 0.5 - (MAP_WIDTH * 16 * 0.5);
		this.scroller.y = Reg.GAME_HEI * 0.5 - (MAP_HEIGHT * 16 * 0.5);

		text_score = new h2d.Text(Assets.font);
		scroller.add(text_score, 9);
		text_score.textColor = 0xffffff;
		text_score.text = "Score: " + Reg.score;
		text_score.y = -20;
		text_score.scale(0.5);

		text_best_score = new h2d.Text(Assets.font);
		scroller.add(text_best_score, 9);
		text_best_score.textColor = 0x555555;
		text_best_score.text = "Best: " + Reg.best_score;
		text_best_score.y = -14;
		text_best_score.scale(0.5);

		text_gameover = new h2d.Text(Assets.font);
		scroller.add(text_gameover, 9);
		text_gameover.textColor = 0xffffff;
		text_gameover.text = "Press SPACE to RESTART";
		text_gameover.y = MAP_HEIGHT * 16;
		text_gameover.x = 14;
		text_gameover.scale(0.5);

		text_hints = new h2d.Text(Assets.font);
		scroller.add(text_hints, 9);
		text_hints.textColor = 0xffffff;
		text_hints.text = "Press WASD to MOVE";
		text_hints.y = MAP_HEIGHT * 16;
		text_hints.x = MAP_WIDTH * 16 * 0.5;
		text_hints.scale(0.5);
		text_hints.textAlign = Center;

		reset();
	}

	function startMusic()
	{
		if (music != null)
			music.stop();
		music = Assets.music_intro.play();
		music.onEnd = () ->
		{
			music.stop();
			music = Assets.music_loop.play(true);
		}
	}

	var music:hxd.snd.Channel;

	private function initGame()
	{
		new Boat(this, 2, 4);
		spawnEnemies(2);
	}

	private function irand(min:Int, max:Int)
	{
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	public function addPoint()
	{
		Reg.score++;
		if (Reg.score > Reg.best_score)
			Reg.best_score = Reg.score;
		text_score.text = "Score: " + Reg.score;
		text_best_score.text = "Best: " + Reg.best_score;
	}

	public function takeDamage()
	{
		if (gameover)
			return;
		Reg.lives--;
		hearts[Reg.lives].tile = Assets.heart_hurt;
		if (Reg.lives == 0)
		{
			gameOver();
		}
	}

	public function gameOver()
	{
		this.gameover = true;
		this.text_gameover.visible = true;
	}

	public function spawnEnemies(num:Int)
	{
		for (i in 0...num)
		{
			var cx = irand(0, MAP_WIDTH - 1);
			var cy = irand(0, 2);
			if (en.Entity.getAt(cx, cy) != null)
			{
				continue;
			}
			new en.Spawn(this, cx, cy);
		}
		spawn_timer = SPAWN_COUNTER;
	}

	public function isInBounds(cx:Int, cy:Int)
	{
		return cx >= 0 && cy >= 0 && cx < MAP_WIDTH && cy < MAP_HEIGHT;
	}

	public function step()
	{
		if (gameover)
			return;

		if (text_hints.text == "Press WASD to MOVE")
		{
			text_hints.text = "Press IJKL or ARROWS to SHOOT";
		}
		else
		{
			text_hints.visible = false;
		}

		spawn_timer--;
		if (spawn_timer == 0)
		{
			spawnEnemies(irand(1, 3));
		}

		for (ent in en.Boat.ALL)
		{
			if (ent == null)
				continue;
			ent.step();
		}

		// this is a crummy fix to avoid gameplay frustration when bullets stack.
		// we simply remove all overlapping bullets.
		// it is really not optimised.
		for (ent in new pirhana.Iterators.ReverseArrayIterator(en.Bullet.ALL))
		{
			if (ent.destroyed)
				continue;
			for (other in new pirhana.Iterators.ReverseArrayIterator(en.Bullet.ALL))
			{
				if (other != ent && other.cx == ent.cx && other.cy == ent.cy)
				{
					other.destroy();
				}
			}
		}

		for (ent in new pirhana.Iterators.ReverseArrayIterator(en.Bullet.ALL))
		{
			if (ent == null)
				continue;
			ent.step();
		}

		for (ent in en.Kraken.ALL)
		{
			if (ent == null)
				continue;
			ent.step();
		}
		// this must be after the krakens
		for (ent in en.Spawn.ALL)
		{
			ent.step();
		}
	}

	public function update(dt:Float)
	{
		if (gameover && hxd.Key.isPressed(hxd.Key.SPACE))
		{
			reset();
		}

		for (ent in en.Entity.ALL)
		{
			ent.update(dt);
		}

		// dispose of destroyed entities
		for (ent in new pirhana.Iterators.ReverseArrayIterator(en.Entity.ALL))
		{
			if (ent.destroyed)
			{
				ent.dispose();
			}
		}

		if (en.Kraken.ALL.length == 0 && en.Spawn.ALL.length == 0)
		{
			spawnEnemies(3);
		}
	}

	public function reset()
	{
		gameover = false;
		Reg.lives = Reg.total_lives;
		Reg.score = 0;
		text_gameover.visible = false;

		for (ent in new pirhana.Iterators.ReverseArrayIterator(en.Entity.ALL))
		{
			ent.dispose();
		}
		for (i in 0...Reg.total_lives)
		{
			var heart = hearts[i];
			if (heart == null)
			{
				heart = new h2d.Bitmap(Assets.heart);
				scroller.add(heart, 9);
				heart.x = i * 7;
				heart.y = -5;
				hearts.push(heart);
			}
			else
			{
				heart.tile = Assets.heart;
			}
		}
		startMusic();
		initGame();
	}
}
