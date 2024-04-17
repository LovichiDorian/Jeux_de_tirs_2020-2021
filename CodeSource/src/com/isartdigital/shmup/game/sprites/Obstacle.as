package com.isartdigital.shmup.game.sprites
{
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.collectibles.Collectable;
	import com.isartdigital.shmup.game.sprites.collectibles.CollectableBomb;
	import com.isartdigital.shmup.game.sprites.collectibles.CollectableFirePower;
	import com.isartdigital.shmup.game.sprites.collectibles.CollectableFireUpgrade;
	import com.isartdigital.shmup.game.sprites.collectibles.CollectableLife;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * Classe Obstacle
	 * Cette classe hérite de la classe StateObject elle possède donc une propriété renderer représentation graphique
	 * de l'obstacle et une propriété collider servant de boite de collision de l'Obstacle
	 * @author Mathieu ANTHOINE
	 */
	public class Obstacle extends StateObject
	{
		private var undergoesDamage:int = 50;
		
		
		public static var list:Vector.<Obstacle> = new Vector.<Obstacle>();
		
		/**
		 * Constructeur de la classe Object
		 * @param	pAsset Nom de la classe du Generateur de l'Obstacle. Ce nom permet d'identifier l'Obstacle et le créer en conséquence
		 */
		public function Obstacle(pAsset:String)
		{
			assetName = pAsset;
			super();
		}
		
		override protected function doActionNormal():void
		{
			if (Player.getInstance().onTransparence == false)
			{
				collision();
			}
			
			if (x <= GameLayer.getInstance().screenLimits.left + 10)
				{
					
					destroy();
					clearCollider();
					
				}
		
		}
		
		private function collision():void
		{
			if (assetName == "Obstacle2")
			{
				if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox,Player.getInstance().hitPoints))
				{
					if (Player.getInstance().x >=hitBox.x)
					{
						Player.getInstance().x = x - width;
						
					}
					
				}
				for (var i:int = ShotPlayer.shots.length-1; i >-1 ; i--)
				{
					
					if (CollisionManager.hasCollision(hitBox, ShotPlayer.shots[i].hitBox))
					{
						undergoesDamage--;
						if (undergoesDamage<=0) 
						{
							setState("explosion");
							clearCollider();
						}
						
				
					}
				}
				if (isAnimEnd() && state == "explosion")
				{
					destroy();
				}
				
			}
		}
		
		
		
	}

}