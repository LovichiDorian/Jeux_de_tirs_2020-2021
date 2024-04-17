package com.isartdigital.shmup.game.sprites.enemies
{
	import adobe.utils.CustomActions;
	import com.greensock.TweenLite;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Bomb;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShotEnemy;
	import com.isartdigital.shmup.game.sprites.ShotPlayer;
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
	public class Enemy0 extends EnemyNormal
	{
		
		protected var shotLevel:int = 0;
		protected var countFrame:int = 0;
		protected var waitingTime:int = 120;
		protected var angle:int;
	
		
		public function Enemy0(pAsset:String)
		{
			assetName = pAsset;
			TweenPlugin.activate([VisiblePlugin, TintPlugin,RemoveTintPlugin]);
			super();
		}
		
		override protected function doActionNormal():void
		{
			if (countFrame++ >= waitingTime)
			{
				setEnemy0Shot();
				countFrame = 0;
			}
			enemy0Move();
			
			if (Player.getInstance().onTransparence == false && Player.getInstance().onGodMod == false)
			{
				enemy0ColliderPlayer();
			}
			
			if (x <= GameLayer.getInstance().screenLimits.left + 10)
				{
					
					destroy();
					clearCollider();
					
				}
			
			
			//collisionTest();
			enemy0Hurt();
		
		}
		private function enemy0Move():void 
		{
			//x -= 1;
			angle += 5;
			y -= Math.sin(angle * (Math.PI / 180)) * 5;
		}
		
		
		private function enemy0Hurt():void
		{
			if (EnemyIsTouched == true)
			{
				
				setState("hurt");
				EnemyIsTouched = false;
				
			}
			if (undergoesDamage >= 5)
			{
				setState("explosion");
				SoundManager.getNewSoundFX("enemyExplosion").start();
				doAction = doActionExplo;
					
				
			}
			
			if (isAnimEnd() && state == "explosion")
			{
				
				destroy();
			}
			
			if (isAnimEnd() && state == "hurt")
			{
				setState("default");
				
			}
		
		}
		override public function doActionExplo():void 
		{
			 var score50:MovieClip;
			var score50Class:Class = Class(getDefinitionByName("Score50"));
			clearCollider();
			
			if (isAnimEnd() && state == "explosion")
			{
				
				Hud.getInstance().scores += 50;
				destroy();
				score50 = new score50Class();
				Hud.getInstance().addChild(score50);
				var lPoint:Point = new Point(x, y);
				var lPoint2:Point = GameLayer.getInstance().localToGlobal(lPoint);
				var lPoint3:Point = Hud.getInstance().globalToLocal(lPoint2);
				
				GameLayer.getInstance().localToGlobal(lPoint);
				Hud.getInstance().globalToLocal(lPoint);
				Hud.getInstance().mcTopCenter.globalToLocal(lPoint2);
			
				score50.x = lPoint3.x;
				score50.y = lPoint3.y;	
				
				TweenLite.to(score50, 2, {x:Hud.getInstance().mcTopCenter.x, y:Hud.getInstance().mcTopCenter.y + Hud.getInstance().mcTopCenter.height / 2,visible:false}); 
				TweenLite.to(score50, 0.1, {tint: Math.random()*0xFFFFFF}); 
			}
		}
		
		private function enemy0ColliderPlayer():void
		{
			if (CollisionManager.hasCollision(hitBox, Player.getInstance().hitBox, Player.getInstance().hitPoints, hitPoints))
			{
				Player.getInstance().isTouched = true;
				setState("explosion");
				Player.getInstance().life--;
				
				SoundManager.getNewSoundFX("enemyExplosion").start();
				doAction = doActionExplo;
			}
			if (isAnimEnd() && state == "explosion")
			{
				destroy();
			}
		}
		
		
		override public function get hitPoints():Vector.<Point>
		{
			var lPoint0:Point = new Point(collider.mcHitPoint1.x, collider.mcHitPoint1.y);
			var lPoint1:Point = new Point(collider.mcHitPoint2.x, collider.mcHitPoint2.y);
			var lPoint2:Point = new Point(collider.mcHitPoint3.x, collider.mcHitPoint3.y);
			return new <Point>[collider.localToGlobal(lPoint0), collider.localToGlobal(lPoint1), collider.localToGlobal(lPoint2)];
		}
		
		private function setEnemy0Shot():void
		{
			var lShotEnemy:ShotEnemy;
			
			lShotEnemy = new ShotEnemy("ShootEnemy" + shotLevel);
			parent.addChild(lShotEnemy);
			lShotEnemy.x = x + collider.mcWeapon0.x;
			lShotEnemy.y = y;
			SoundManager.getNewSoundFX("enemyShoot").start();
			lShotEnemy.start();
		
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			list.removeAt(list.indexOf(this));
		}
	
	}

}

