package com.isartdigital.shmup.game.sprites
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.enemies.EnemyNormal;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class Bomb extends StateObject
	{
		public static var list:Vector.<Bomb> = new Vector.<Bomb>();
		protected var countFrame:int = 0;
		protected var waitingTime:int = 120;
		
		public function Bomb(pAsset:String)
		{
			assetName = pAsset;
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			x += 10;
			
			if (countFrame++ >= waitingTime)
			{
				setState("explosion");
				doActionExplo();
			}
			if (x >= GameLayer.getInstance().screenLimits.right)
			{
				destroy();
			}
		
		}
		
		override public function doActionExplo():void
		{
			clearCollider();
			if (isAnimEnd() && state == "explosion")
			{
				for (var i:int = 0; i < EnemyNormal.list.length; i++)
				{
					if (EnemyNormal.list[i].x <= GameLayer.getInstance().screenLimits.right - 10)
					{
						EnemyNormal.list[i].destroy();
					}
					
				}
				for (var j:int = 0; j < Teleguided.list.length; j++) 
				{
					Teleguided.list[j].destroy();
				}
				for (var k:int = 0; k < ShotEnemy.shotsEnemy.length; k++) 
				{
					ShotEnemy.shotsEnemy[k].destroy();
				}
				
				destroy();
				
			}
		}
	}

}