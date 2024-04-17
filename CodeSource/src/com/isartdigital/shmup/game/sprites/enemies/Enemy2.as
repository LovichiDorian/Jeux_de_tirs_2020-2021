package com.isartdigital.shmup.game.sprites.enemies
{
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Bomb;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShotEnemy;
	import com.isartdigital.shmup.game.sprites.ShotPlayer;
	import com.isartdigital.shmup.game.sprites.collectibles.Collectable;
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
	public class Enemy2 extends EnemyNormal
	{
		public static var list:Vector.<Enemy2> = new Vector.<Enemy2>();
		public var shotLevel:int = 0;
		private var countFrame:int = 0;
		private var waitingTime:int = 40;
		
		public function Enemy2(pAsset:String)
		{
			assetName = pAsset;
			super();
		
		}
		
		override protected function doActionNormal():void
		{
			if (x >= GameLayer.getInstance().screenLimits.right - width)
			{
				x = GameLayer.getInstance().screenLimits.right - 450;
				x += GameLayer.getInstance().speed;
			}
			if (Player.getInstance().onTransparence == false)
			{
				enemy2ColliderPlayer();
			}
			if (undergoesDamage < 50)
			{
				if (countFrame++ >= waitingTime)
				{
					setEnemy2Shot();
					countFrame = 0;
				}
			}
			
			enemy2Move();
			
			enemy2Hurt();
		}
		
		private function enemy2Hurt():void
		{
			if (EnemyIsTouched == true)
			{
				setState("hurt");
				EnemyIsTouched = !EnemyIsTouched;
				
				
			}
			if (undergoesDamage >= 50)
			{
				setState("explosion");
				
				//SoundManager.getNewSoundFX("enemyExplosion").start();
				doActionExplo();
				
			}
			//if (isAnimEnd() && state == "explosion")
			//{
			//destroy();
			//}
			//if (isAnimEnd() && state == "hurt")
			//{
			//setState("default");
			//} 	
		}
		
		override public function doActionExplo():void
		{
			clearCollider();
			var score500:MovieClip;
			var score500Class:Class = Class(getDefinitionByName("Score500"));
			
			if (isAnimEnd() && state == "explosion")
			{
				Collectable.Createcollectible(x, y);
				Hud.getInstance().scores += 500;
				destroy();
				for (var i:int = 0; i < ShotEnemy.shotsEnemy.length; i++)
				{
					ShotEnemy.shotsEnemy[i].destroy();
				}
				
				score500 = new score500Class();
				Hud.getInstance().addChild(score500);
				
				var lPoint:Point = new Point(x, y);
				var lPoint2:Point = GameLayer.getInstance().localToGlobal(lPoint);
				var lPoint3:Point = Hud.getInstance().globalToLocal(lPoint2);
				
				GameLayer.getInstance().localToGlobal(lPoint);
				Hud.getInstance().globalToLocal(lPoint);
				Hud.getInstance().mcTopCenter.globalToLocal(lPoint2);
				
				score500.x = lPoint3.x;
				score500.y = lPoint3.y;
				
				TweenLite.to(score500, 2, {x: Hud.getInstance().mcTopCenter.x, y: Hud.getInstance().mcTopCenter.y + Hud.getInstance().mcTopCenter.height / 2, visible: false});
				TweenLite.to(score500, 0.1, {tint: Math.random() * 0xFFFFFF});
				
			}
		}
		
		protected function enemy2ColliderPlayer():void
		{
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints))
			{
				Player.getInstance().isTouched = true;
				setState("explosion");
			}
			if (isAnimEnd() && state == "explosion")
			{
				//SoundManager.getNewSoundFX("enemyExplosion").start();
				destroy();
			}
		}
		
		private function setEnemy2Shot():void
		{
			var lShotEnemy2:ShotEnemy;
			
			lShotEnemy2 = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy2);
			lShotEnemy2.x = x + collider.mcWeapon2.x;
			lShotEnemy2.y = y + collider.mcWeapon2.y;
			lShotEnemy2.start();
			
			var lShotEnemy0:ShotEnemy;
			
			lShotEnemy0 = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy0);
			lShotEnemy0.x = x + collider.mcWeapon0.x;
			lShotEnemy0.y = y + collider.mcWeapon0.y;
			lShotEnemy0.start();
			
			var lShotEnemy1:ShotEnemy;
			
			lShotEnemy1 = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy1);
			lShotEnemy1.x = x + collider.mcWeapon1.x;
			lShotEnemy1.y = y + collider.mcWeapon1.y;
			lShotEnemy1.start();
			
			var lShotEnemy3:ShotEnemy;
			
			lShotEnemy3 = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy3);
			lShotEnemy3.x = x + collider.mcWeapon3.x;
			lShotEnemy3.y = y + collider.mcWeapon3.y;
			lShotEnemy3.start();
			
			var lShotEnemy4:ShotEnemy;
			
			lShotEnemy4 = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy4);
			lShotEnemy4.x = x + collider.mcWeapon4.x;
			lShotEnemy4.y = y + collider.mcWeapon4.y;
			lShotEnemy4.start();
			
			var lShotEnemy5:ShotEnemy;
			
			lShotEnemy5 = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy5);
			lShotEnemy5.x = x + collider.mcWeapon5.x;
			lShotEnemy5.y = y + collider.mcWeapon5.y;
			lShotEnemy5.start();
			
			SoundManager.getNewSoundFX("enemyShoot").start();
		}
		
		private function enemy2Move():void
		{
			
			y += 4;
			
			if (y >= GameLayer.getInstance().screenLimits.bottom - 10)
			{
				
				y = GameLayer.getInstance().screenLimits.top;
			}
		
		}
	}

}