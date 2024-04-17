package com.isartdigital.shmup.game.sprites.collectibles
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.maths.MathTools;
	import com.isartdigital.utils.maths.geometry.VectorTools;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class Collectable extends StateObject
	{
		public static var list:Vector.<Collectable> = new Vector.<Collectable>();
		
		public function Collectable()
		{
			
			list.push(this);
			
			super();
		
		}
		
		
		public static function randomCollectibles():Collectable
		{
			
			var RandomVector:Vector.<Collectable> = new Vector.<Collectable>();
			
			for (var j:int = 0; j < 20; j++)
			{
				var lCollectableFirePower:CollectableFirePower = new CollectableFirePower("CollectableFirePower");
				RandomVector.push(lCollectableFirePower);
			}
			for (var k:int = 0; k < 20; k++)
			{
				var lCollectableFireUpgrade:CollectableFireUpgrade = new CollectableFireUpgrade("CollectableFireUpgrade");
				RandomVector.push(lCollectableFireUpgrade);
			}
			for (var l:int = 0; l < 50; l++)
			{
				var lCollectableLife:CollectableLife = new CollectableLife("CollectableLife");
				RandomVector.push(lCollectableLife);
			}
			for (var m:int = 0; m < 10; m++)
			{
				var lCollectableBomb:CollectableBomb = new CollectableBomb("CollectableBomb");
				RandomVector.push(lCollectableBomb);
			}
			
			var a:int;
			
			a = Math.random() * RandomVector.length;
			
			return RandomVector[a];
		
		}
		
		public static function Createcollectible(pX:int, pY:int):void
		{
			
			var lCollectable:Collectable = Collectable.randomCollectibles();
			GameLayer.getInstance().addChild(lCollectable);
			
			Collectable.list.push(lCollectable);
			
			lCollectable.start();
			
			lCollectable.x = pX;
			lCollectable.y = pY;
			
			for (var i:int = 0; i < Enemy1.list.length; i++)
			{
				
				lCollectable.x = Enemy1.list[i].x;
				lCollectable.y = Enemy1.list[i].y;
				
			}
			for (var j:int = 0; j < Obstacle.list.length; j++)
			{
				lCollectable.x = Obstacle.list[j].x;
				lCollectable.y = Obstacle.list[j].y;
				
			}
		}
		
		
	
	}

}