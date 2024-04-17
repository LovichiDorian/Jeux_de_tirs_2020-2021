package com.isartdigital.shmup.game.sprites
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.collectibles.Collectable;
	import com.isartdigital.shmup.game.sprites.enemies.Boss;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy0;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy2;
	import com.isartdigital.shmup.game.sprites.enemies.EnemyNormal;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class ShotPlayer extends StateObject
	{
		
		public var velocity:Point = new Point(50.1);
		private var enemyTimeLine:TimelineLite;
		public static var shots:Vector.<ShotPlayer> = new Vector.<ShotPlayer>();
		private var enemExplo:MovieClip;
		
		public function ShotPlayer(pAsset:String)
		{
			assetName = pAsset;
			shots.push(this);
			TweenPlugin.activate([VisiblePlugin, TintPlugin]);
			//SoundManager.getNewSoundFX("playerShoot0").start();
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			
			x += velocity.x * 50;
			y += velocity.y * 50;
			colliderEnemy();
			colliderObstacle();
			colliderBoss();
			
			for (var k:int = 0; k < shots.length; k++)
			{
				
				if (x >= GameLayer.getInstance().screenLimits.right - 10)
				{
					shots[k].destroy();
					
				}
			}
		}
		
		private function colliderBoss():void
		{
			for (var i:int = 0; i < Boss.list.length; i++)
			{
				if (CollisionManager.hasCollision(hitBox, Boss.list[i].hitBox))
				{
					setState("explosion");
					Hud.getInstance().mcTopLeft.mcSpecialBar.mcBar.x = -300;
					
				}
				
			}
		}
		
		private function colliderEnemy():void
		{
			
			for (var i:int = EnemyNormal.list.length - 1; i > -1; i--)
			{
				
				if (CollisionManager.hasCollision(hitBox, EnemyNormal.list[i].hitBox))
				{
					EnemyNormal.list[i].EnemyIsTouched = true;
					EnemyNormal.list[i].undergoesDamage++;
					setState("explosion");
					TweenLite.to(EnemyNormal.list[i], 0.2, {scaleX: 1.5, scaleY: 1.5});
					
					doAction = doActionExplo;
					Hud.getInstance().mcTopLeft.mcSpecialBar.mcBar.x+=3;
					
				}
				
			}
			
		}
		
		private function colliderObstacle():void
		{
			for (var i:int = 0; i < Obstacle.list.length; i++)
			{
				if (CollisionManager.hasCollision(hitBox, Obstacle.list[i].hitBox))
				{
					setState("explosion");
					//doAction = doActionExplo;
					
				}
				
			}
		
		}
		
		override public function doActionExplo():void 
		{
			clearCollider();
			if (isAnimEnd() && state == "explosion")
			{
				Hud.getInstance().scores++;
				destroy();
				
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			shots.removeAt(shots.indexOf(this));
		}
	
	}
}