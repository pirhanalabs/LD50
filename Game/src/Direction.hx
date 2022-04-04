@:enum
abstract Direction(Int)
{
	var N = 0;
	var S = 1;
	var W = 2;
	var E = 3;

	public function getPoint():{x:Int, y:Int}
	{
		return switch (this)
		{
			case 0: {x: 0, y: -1};
			case 1: {x: 0, y: 1};
			case 2: {x: -1, y: 0};
			case 3: {x: 1, y: 0};
			default: {x: 0, y: 0};
		}
	}

	public function vertical()
	{
		return this == 0 || this == 1;
	}

	public function getClockwise()
	{
		return switch (this)
		{
			case 0: E;
			case 1: W;
			case 2: N;
			case 3: S;
			default: N;
		}
	}

	public function getOpposite()
	{
		return switch (this)
		{
			case 0: S;
			case 1: N;
			case 2: E;
			case 3: W;
			default: N;
		}
	}

	public static function fromPoint(x:Int, y:Int)
	{
		if (x == 0 && y > 0)
			return S;
		if (x == 0 && y < 0)
			return N;
		if (x > 0 && y == 0)
			return E;
		if (x < 0 && y == 0)
			return W;
		return N;
	}
}
