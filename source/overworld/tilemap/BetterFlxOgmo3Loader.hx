package overworld.tilemap;

/**
 * FlxOgmo3Loader but qwith the ability to directly access level data
 * why isnt this a feature already??
 */
class BetterFlxOgmo3Loader extends FlxOgmo3Loader
{
    public function getLevelData():LevelData{
        return level;
	}    
	/*
		var realSizeMin = FlxPoint.get();
			var realSizeMax = FlxPoint.get();

			realSizeMin.set(9999999, 9999999);
			
			for (layer in map.getLevelData().layers)
			{
				if (layer.tileset != null)
				{
					if (layer.name == "main")
					{
						var collumn:Int = 0;

						for (i in 0...layer.data.length)
						{
							if (data2D[collumn] == null)
								data2D[collumn] = [];

							var tile = layer.data[i];
							data2D[collumn].push(tile);

							if (i % layer.gridCellsX == 0 && i != 0)
							{
								collumn++;
							}
						}

						for (i in 0...data2D.length)
						{
							var row = data2D[i];

							for (j in 0...row.length)
							{
								var tile = row[j];

								if (tile != -1)
								{ // theres a real tile here
									if (realSizeMin.x > j)
									{
										realSizeMin.x = j;
									}
									if (realSizeMax.x < j)
									{
										realSizeMax.x = j;
									}
									if (realSizeMin.y > i)
									{
										realSizeMin.y = i;
									}
									if (realSizeMax.y < i)
									{
										realSizeMax.y = i;
									}
								}
							}
						}
					}
	 */
}